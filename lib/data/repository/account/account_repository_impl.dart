import 'package:app/core/networking/rest_client.dart';
import 'package:app/data/models/base_response.dart';
import 'package:app/data/request/sign_in_request.dart';
import 'package:app/domain/repository/account/account_repository.dart';

class AccountRepositoryImpl extends AccountRepository {
  final RestClient _baseRest;

  AccountRepositoryImpl({required RestClient baseRest}) : _baseRest = baseRest;
  @override
  Future<BEBaseResponse?> login(SignInRequest requestLogin) async {
    final result =
        await _baseRest.dio.post('/auth/token', data: requestLogin.toJson());
    return BEBaseResponse?.fromJson(result.data);
  }
}
