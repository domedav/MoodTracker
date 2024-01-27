import 'package:shared_preferences/shared_preferences.dart';

class NumberStorage{
  static Future<void> _saveData(String key, double value) async{
    final prefs = await SharedPreferences.getInstance();
    prefs.setDouble(key, value);
  }

  static Future<void> _removeData(String key) async{
    final haskey = await hasKey(key);
    if(!haskey){
      throw "NumberStorage removeData: key doesnt have a value pair";
    }
    final prefs = await SharedPreferences.getInstance();
    prefs.remove(key);
  }

  static void setData(String key, double value){
    if(key == "" || key == " ") {
      throw "NumberStorage setData: key was null or empty";
    }
    _saveData(key, value);
  }

  static Future<double> getData(String key) async{
    if(key == "" || key == " ") {
      throw "NumberStorage getData: key was null or empty";
    }
    if(! (await hasKey(key))){
      throw "NumberStorage getData: key doesnt have a value pair";
    }
    final prefs = await SharedPreferences.getInstance();
    return prefs.getDouble(key)!;
  }

  static void removeData(dynamic key){
    _removeData(key);
  }

  static Future<bool> hasKey(String key) async{
    final prefs = await SharedPreferences.getInstance();
    return prefs.containsKey(key);
  }
}

class StringStorage{
  static Future<void> _saveData(String key, String value) async{
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(key, value);
  }

  static Future<void> _removeData(String key) async{
    final haskey = await hasKey(key);
    if(!haskey){
      throw "NumberStorage removeData: key doesnt have a value pair";
    }
    final prefs = await SharedPreferences.getInstance();
    prefs.remove(key);
  }

  static void setData(String key, String value){
    if(key == "" || key == " ") {
      throw "NumberStorage setData: key was null or empty";
    }
    _saveData(key, value);
  }

  static Future<String> getData(String key) async{
    if(key == "" || key == " ") {
      throw "NumberStorage getData: key was null or empty";
    }
    if(! (await hasKey(key))){
      throw "NumberStorage getData: key doesnt have a value pair";
    }
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(key)!;
  }

  static void removeData(String key){
    _removeData(key);
  }

  static Future<bool> hasKey(String key) async{
    final prefs = await SharedPreferences.getInstance();
    return prefs.containsKey(key);
  }
}

class StorageHelper{
  static Future<void> clearData() async{
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}