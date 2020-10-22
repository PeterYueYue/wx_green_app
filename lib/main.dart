import 'package:flutter/material.dart';
import 'package:local_cache_sync/local_cache_sync.dart';
import 'package:path_provider/path_provider.dart';
import 'Tabs.dart';
import 'login.dart';
import 'mainPage.dart';
import 'unit/request.dart';

void main() async {

  WidgetsFlutterBinding.ensureInitialized();
  LocalCacheSync.instance.setCachePath(
    await getTemporaryDirectory(),
    'flutter_app/',
  );
  runApp(Home());
}
class Home extends StatelessWidget{

  @override
  Widget build(BuildContext context) {

    return  MaterialApp(
        // home: Tabs(),
        home:Login()
    );
  }


}



