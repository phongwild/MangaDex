import 'package:app/domain/env_config/env_url_type.dart';
import 'package:app/global/init_app/injector.dart';

const _devUrl = 'https://external.vpbanks.com.vn';
const _uatUrl = 'https://external.vpbanks.com.vn';
const _prodUrl = 'https://external.vpbanks.com.vn';

abstract class EnvUrl {
  String baseUrl();
  String flexUrl();
  String bondUrl();
  String noAuthUrl();
  String socketUrl();

  Envirement get env;

  EnvUrl._();

  factory EnvUrl(Envirement envirement) {
    switch (envirement) {
      case Envirement.dev:
        return _ProdUrlConfig();
      case Envirement.prod:
        return _DevUrlConfig();
      case Envirement.uat:
        return _UatUrlConfig();
    }
  }
}

class _DevUrlConfig extends EnvUrl {
  _DevUrlConfig() : super._();

  @override
  Envirement get env => Envirement.dev;

  @override
  String baseUrl() {
    return _devUrl;
  }

  @override
  String bondUrl() {
    return _devUrl + EnvUrlEnum.bond.path();
  }

  @override
  String flexUrl() {
    return _devUrl + EnvUrlEnum.flex.path();
  }

  @override
  String noAuthUrl() {
    return _devUrl + EnvUrlEnum.noAuth.path();
  }

  @override
  String socketUrl() {
    return 'https://socket.vpbanks.com.vn';
  }
}

class _ProdUrlConfig extends EnvUrl {
  _ProdUrlConfig() : super._();

  @override
  Envirement get env => Envirement.dev;

  @override
  String baseUrl() {
    return _prodUrl;
  }

  @override
  String bondUrl() {
    return _prodUrl + EnvUrlEnum.bond.path();
  }

  @override
  String flexUrl() {
    return _prodUrl + EnvUrlEnum.flex.path();
  }

  @override
  String noAuthUrl() {
    return _prodUrl + EnvUrlEnum.noAuth.path();
  }

  @override
  String socketUrl() {
    return 'https://socket.vpbanks.com.vn';
  }
}

class _UatUrlConfig extends EnvUrl {
  _UatUrlConfig() : super._();

  @override
  Envirement get env => Envirement.uat;

  @override
  String baseUrl() {
    return _uatUrl;
  }

  @override
  String bondUrl() {
    return _uatUrl + EnvUrlEnum.bond.path();
  }

  @override
  String flexUrl() {
    return _uatUrl + EnvUrlEnum.flex.path();
  }

  @override
  String noAuthUrl() {
    return _uatUrl + EnvUrlEnum.noAuth.path();
  }

  @override
  String socketUrl() {
    return 'https://socket.vpbanks.com.vn';
  }
}
