import 'package:app/data/models/base_response.dart';
import 'package:app/data/request/sign_in_request.dart';

abstract class AccountRepository {
  Future<BEBaseResponse?> login(SignInRequest requestLogin);
}
