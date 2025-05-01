import 'dart:io';

import 'package:app/core/app_log.dart';
import 'package:app/core/cache/shared_prefs.dart';
import 'package:app/feature/utils/is_login.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../dio/dio_client.dart';
import '../models/user.dart';

part 'auth_state.dart';

final IsLogin _isLogin = IsLogin.getInstance();

class AuthCubit extends Cubit<AuthState> with NetWorkMixin {
  AuthCubit() : super(AuthInitial());

  final String baseURL = 'https://api-manga-user.vercel.app';
  final String devURL = 'http://192.168.10.106:3000';
  //Register
  Future<void> register(String username, String email, String password) async {
    try {
      emit(AuthLoading());
      final res = await callApiPost('$baseURL/user/register', {
        'username': username,
        'email': email,
        'password': password,
      });
      if (res.statusCode == 200) {
        emit(AuthOtpSent());
      } else {
        emit(const AuthError(error: 'Failed to register'));
      }
    } catch (e) {
      emit(AuthError(error: e.toString()));
    }
  }

  //Verify otp
  Future<void> verifyOtp(String email, String otp) async {
    try {
      emit(AuthLoading());

      final response = await callApiPost('$baseURL/user/verify-otp', {
        'email': email,
        'otp': otp,
      });
      if (response.statusCode == 201) {
        emit(AuthOtpSent());
      } else {
        emit(AuthError(
            error: 'Failed to verify OTP: ${response.data['message']}'));
      }
    } catch (e) {
      emit(AuthError(error: e.toString()));
    }
  }

  Future<void> checkLoginStatus() async {
    await _isLogin.loadSession(); // Load JWT từ SharedPreferences
    if (_isLogin.isLoggedIn) {
      await getProfile();
    } else {
      emit(AuthLogoutSuccess());
    }
  }

  //Login
  Future<void> login(String email, String password) async {
    try {
      emit(AuthLoading());
      final response = await callApiPost('$baseURL/user/login', {
        'email': email,
        'password': password,
      });
      if (response.statusCode == 200) {
        final user = User.fromJson(response.data);
        await SharedPref.putString('uid', user.sId!);
        var cookies = response.headers['set-cookie'];
        if (cookies != null && cookies.isNotEmpty) {
          // Lưu cookie vào SharedPreferences
          await _isLogin.login(
            cookies.first,
            user.username!,
            user.email!,
            user.avatar!,
            user.sId!,
          );
          dlog('JWT đã được lưu: ${await _isLogin.getJwt()}');
        }
        await getProfile();
        // Emit trạng thái thành công
        emit(AuthLoginSuccess(user: user));
      } else if (response.statusCode == 400) {
        emit(AuthWrongEmailOrPassword());
      } else {
        // Emit lỗi nếu đăng nhập thất bại
        emit(AuthError(error: 'Failed to login: ${response.data['message']}'));
      }
    } catch (e) {
      emit(AuthError(error: e.toString()));
    }
  }

  Future<void> loginGoogle(String idToken) async {
    try {
      emit(AuthLoading());
      final response = await callApiPost('$baseURL/auth/login', {
        'idToken': idToken,
      });
      if (response.statusCode == 200) {
        final user = User.fromJson(response.data);
        await SharedPref.putString('uid', user.sId!);
        var cookies = response.headers['set-cookie'];
        if (cookies != null && cookies.isNotEmpty) {
          // Lưu cookie vào SharedPreferences
          await _isLogin.login(
            cookies.first,
            user.username!,
            user.email!,
            user.avatar!,
            user.sId!,
          );
          dlog('JWT đã được lưu: ${await _isLogin.getJwt()}');
        }
        await getProfile();
        // Emit trạng thái thành công
        emit(AuthLoginSuccess(user: user));
      } else if (response.statusCode == 400) {
        emit(AuthWrongEmailOrPassword());
      } else {
        // Emit lỗi nếu đăng nhập thất bại
        emit(AuthError(error: 'Failed to login: ${response.data['message']}'));
      }
    } catch (e) {
      dlog('Error: $e');
      emit(AuthError(error: e.toString()));
    }
  }

  //get profile
  Future<void> getProfile() async {
    try {
      emit(AuthLoading());
      final response = await callApiGet(
        endPoint: '$baseURL/user/profile',
        jwtToken: await _isLogin.getJwt(),
      );
      if (response.statusCode == 200) {
        final user = User.fromJson(response.data);
        emit(AuthProfileLoaded(user: user));
      }
    } catch (e) {
      dlog(e.toString());
      emit(AuthError(error: e.toString()));
    }
  }

  //Logout
  Future<void> logout() async {
    try {
      emit(AuthLoading());
      final response = await callApiGet(endPoint: '$baseURL/user/logout');
      if (response.statusCode == 200) {
        await _isLogin.logout();
        emit(AuthLogoutSuccess());
      }
    } catch (e) {
      dlog(e.toString());
      emit(AuthError(error: e.toString()));
    }
  }

  Future<void> changePass(String oldPass, String newPass) async {
    try {
      emit(AuthChangePassLoading());
      final uid = await SharedPref.getString('uid');
      final response = await callApiPut(
        '$baseURL/user/change-password/$uid',
        {
          'oldPassword': oldPass,
          'newPassword': newPass,
        },
      );
      if (response.statusCode == 200) {
        emit(AuthChangePassSuccess());
      } else {
        emit(AuthChangePassError(response.data['message']));
      }
    } catch (e) {
      dlog(e.toString());
      emit(AuthChangePassError(e.toString()));
    }
  }

  Future<void> uploadAvatar(File file) async {
    try {
      emit(AuthUploadAvatarLoading());

      final uid = await SharedPref.getString('uid');
      if (uid.isEmpty) {
        emit(const AuthUploadAvatarError(
            "Không tìm thấy UID người dùng (⁠〒⁠﹏⁠〒⁠)"));
        return;
      }

      final formData = FormData.fromMap({
        'image': await MultipartFile.fromFile(
          file.path,
          filename: file.path.split('/').last,
        ),
      });

      final uploadResponse = await callApiPost(
        '$baseURL/upload',
        formData,
      );

      if (uploadResponse.statusCode != 200) {
        final message = uploadResponse.data['message'] ??
            'Lỗi không xác định khi upload ảnh';
        emit(AuthUploadAvatarError(message));
        return;
      }

      final uploadedImageUrl = uploadResponse.data['data'];
      if (uploadedImageUrl == null || uploadedImageUrl.isEmpty) {
        emit(const AuthUploadAvatarError(
            "URL ảnh tải lên không hợp lệ (⁠╥⁠﹏⁠╥⁠)"));
        return;
      }

      final updateResponse = await callApiPut(
        '$baseURL/user/update-profile/$uid',
        {'avatar': uploadedImageUrl},
      );

      if (updateResponse.statusCode == 200) {
        final user = User.fromJson(updateResponse.data['data']);
        emit(AuthUploadAvatarSuccess(avatar: user.avatar));
      } else {
        final message = updateResponse.data['message'] ??
            'Lỗi khi cập nhật ảnh đại diện (⁠≧⁠Д⁠≦⁠)';
        emit(AuthUploadAvatarError(message));
      }
    } catch (e) {
      dlog(e.toString());
      emit(AuthUploadAvatarError("Đã xảy ra lỗi: ${e.toString()}"));
    }
  }

  Future<void> updateProfile(User user) async {
    try {
      emit(AuthUpdateProfileLoading());

      final uid = await SharedPref.getString('uid');
      if (uid.isEmpty) {
        emit(const AuthUpdateProfileError(
            "Không tìm thấy UID người dùng (⁠〒⁠﹏⁠〒⁠)"));
        return;
      }

      final response = await callApiPut(
        '$baseURL/user/update-profile/$uid',
        user.toJson(),
      );

      if (response.statusCode == 200) {
        emit(AuthUpdateProfileSuccess());
      } else {
        final message =
            response.data['message'] ?? 'Cập nhật thất bại (⁠≧⁠Д⁠≦⁠)';
        emit(AuthUpdateProfileError(message));
      }
    } catch (e) {
      dlog(e.toString());
      emit(AuthUpdateProfileError("Đã xảy ra lỗi: ${e.toString()}"));
    }
  }
}
