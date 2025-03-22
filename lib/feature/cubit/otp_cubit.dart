import 'package:flutter_bloc/flutter_bloc.dart';

part 'otp_state.dart';

class OtpCubit extends Cubit<String> {
  OtpCubit() : super("");
  void updateOtp(int index, String value, List<String> otp) {
    otp[index] = value; // Cập nhật giá trị tại ô tương ứng
    emit(otp.join()); // Phát trạng thái mới (kết hợp các giá trị thành chuỗi)
  }
}
