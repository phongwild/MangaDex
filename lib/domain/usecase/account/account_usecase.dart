import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:app/core/networking/error/handle_error.dart';
import 'package:app/data/models/account/sign_in_model.dart';
import 'package:app/data/request/sign_in_request.dart';
import 'package:app/domain/repository/account/account_repository.dart';
import 'package:app/global/init_app/injector.dart';

@injectable
class AccountUsecase {
  final AccountRepository _accountRepository;

  AccountUsecase() : _accountRepository = sl.get<AccountRepository>();

  Future<Either<dynamic, SignInModel?>> login(SignInRequest request) async {
    try {
      final beBaseResponse = await _accountRepository.login(request);
      if (beBaseResponse != null && beBaseResponse.data is Map) {
        return Right<dynamic, SignInModel?>(
            SignInModel.fromJson(beBaseResponse.data));
      } else {
        return Left<dynamic, SignInModel?>(HandleError.from(beBaseResponse));
      }
    } catch (ex) {
      return Left<dynamic, SignInModel?>(HandleError.from(ex));
    }
  }
}
