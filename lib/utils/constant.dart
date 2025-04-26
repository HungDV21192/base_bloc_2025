class Base {
  static const String URL = 'https://your.api.base.url';
  static const imagePath = 'assets/images';
  static const svgPath = 'assets/svg';
}

class Endpoint {
  static const String LOGIN = 'api/SignIn';
  static const String REGISTER = 'api/Register';
}

class LocalStorageKey {
  static const String ACCESS_TOKEN = 'LOGIN_MODEL';
  static const String USERNAME = 'USERNAME';
  static const String PASSWORD = 'PASSWORD';
}

class LocalPrefsKey {
  static const String THEME_MODE = 'THEME_MODE';
  static const String LANGUAGE = 'LANGUAGE';
  static const String AUTHEN_PASSWORD = 'LOGIN_MODEL_BHHK';
}

class ImageAssets {
  static const String splash_screen = '${Base.imagePath}/splash_screen.png';
  static const String image_background =
      '${Base.imagePath}/image_background.png';
}

class SvgAssets {
  static const String ic_splash_next = '${Base.svgPath}/ic_splash_next.svg';
}
