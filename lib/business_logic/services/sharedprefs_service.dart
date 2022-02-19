import 'package:shared_preferences/shared_preferences.dart';

SharedprefsService sharedprefsService = SharedprefsService();

class SharedprefsService {
  SharedPreferences? sharedPreferences;
  Future init() async {
    sharedPreferences = await SharedPreferences.getInstance();
  }

  Future saveData(String key, List<String> value) async {
    await sharedPreferences!.setStringList(key, value);
  }

  Future<List<String>> getData(String key) async {
    List<String>? data = sharedPreferences!.getStringList(key);
    return data!;
  }
  
  Future resetData(String key) async {
    await sharedPreferences!.remove(key);
  }
  
  Future resetAllData() async {
    await sharedPreferences!.clear();
  }
}
