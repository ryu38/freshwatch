class UserData {

  UserData({
    this.uid,
    this.email
  }) :
    isLogin = uid != null || false ;

  String? uid;
  String? email;
  bool isLogin;
}