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
  static const String AUTHEN_USERNAME = 'LOGIN_MODEL_BSHC';
  static const String AUTHEN_PASSWORD = 'LOGIN_MODEL_BHHK';
}

class LocalPrefsKey {
  static const String THEME_MODE = 'THEME_MODE';
  static const String LANGUAGE = 'LANGUAGE';
  static const String AUTHEN_PASSWORD = 'LOGIN_MODEL_BHHK';
}

class ImageAssets {
  static const String hinhen = '${Base.imagePath}/hinhen.jpg';
}

class SvgAssets {
  static const String demoIcon = '${Base.svgPath}/demoIcon.jpg';
}
