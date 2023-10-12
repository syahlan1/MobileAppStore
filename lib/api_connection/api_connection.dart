class API {
  // static const hostConnect = "http://192.168.100.43/api_store";
  static const hostConnect = "https://mordant-shed.000webhostapp.com/api_store";
  static const hostConnectUser = "$hostConnect/user";
  static const hostConnectAdmin = "$hostConnect/admin";
  static const hostUploadItem = "$hostConnect/item";
  static const hostClothes = "$hostConnect/clothes";
  static const hostCart = "$hostConnect/cart";

  //signUp - login user
  static const validateEmail = "$hostConnectUser/validate_email.php";
  static const signUp = "$hostConnectUser/signup.php";
  static const login = "$hostConnectUser/login.php";

  //login admin
  static const adminLogin = "$hostConnectAdmin/login.php";

  //upload=save new item
  static const uploadNewItems = "$hostUploadItem/upload.php";

  //clothes
  static const getTrendingMostPopularClothes = "$hostClothes/trending.php";
  static const getAllClothes = "$hostClothes/all.php";

  //cart
  static const addToCart = "$hostCart/add.php";
  static const getCartList = "$hostCart/read.php";
}
