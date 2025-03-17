import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageRepository{
  final String xToken="x-auth-token";

  void setToken(String token)async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString(xToken, token);
  }

  Future<String?> getToken ()async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    
    return  preferences.getString(xToken);
  }
}