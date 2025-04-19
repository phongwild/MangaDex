import 'package:app/core/app_log.dart';
import 'package:app/core/cache/shared_prefs.dart';
import 'package:app/feature/utils/is_login.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../dio/dio_client.dart';
import '../models/user.dart';

part 'auth_state.dart';

final IsLogin _isLogin = IsLogin.getInstance();

class AuthCubit extends Cubit<AuthState> with NetWorkMixin {
  AuthCubit() : super(AuthInitial());

  final String baseURL = 'https://api-manga-user.vercel.app';

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
        var cookies =
            response.headers['set-cookie']; // Lấy cookie từ header nếu có
        if (cookies != null && cookies.isNotEmpty) {
          // Lưu cookie vào SharedPreferences
          await _isLogin.login(
            cookies.first,
            user.username!,
            user.email!,
            user.avatar!,
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

  //Put fcm token
  Future<void> putFcmToken(String idUser, String fcmToken) async {
    try {
      final response = await callApiPut(
          '$baseURL/user/putfcmtoken/$idUser', {"fcmToken": fcmToken});
      if (response.statusCode == 200) {
        dlog('Put FCM success');
      }
    } catch (e) {
      dlog(e.toString());
    }
  }

  //get user by id
  Future<void> getUserById(String id) async {
    try {
      emit(AuthLoading());
      final response =
          await callApiGet(endPoint: '$baseURL/user/getuserbyid?id=$id');
      if (response.statusCode == 200) {
        final user = User.fromJson(response.data);
        emit(AuthGetUserByIdSuccess(user: user));
      }
    } catch (e) {
      dlog(e.toString());
      emit(AuthError(error: e.toString()));
    }
  }

  //Get user
  Future<void> getUser(String? search) async {
    try {
      emit(AuthLoading());
      String uid = await SharedPref.getString('uid');
      final query = search == null ? '' : 'search=$search';
      final res = await callApiGet(endPoint: '$baseURL/user?$query&uid=$uid');
      if (res.statusCode == 200 && res.data is List) {
        final users = res.data.map<User>((e) => User.fromJson(e)).toList();
        emit(AuthSearchLoaded(users: users));
      }
    } catch (e) {
      emit(AuthError(error: e.toString()));
      dlog('Error: $e');
    }
  }
}
