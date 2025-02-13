enum EnvUrlEnum {
  base,
  stock,
  flex,
  bond,
  socket,
  noAuth;

  String path() {
    final map = {
      EnvUrlEnum.base: '',
      EnvUrlEnum.stock: '/stock',
      EnvUrlEnum.flex: '/flex',
      EnvUrlEnum.bond: '/bond',
      EnvUrlEnum.socket: '/socket',
      EnvUrlEnum.noAuth: '/noauth'
    };

    return map[this] ?? '';
  }
}
