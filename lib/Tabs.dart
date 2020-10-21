//底部导航组件
import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';
import 'tabs/Home.dart';
import 'tabs/Scan.dart';
import 'tabs/My.dart';
import 'dart:convert' as convert;
import 'package:crypto/crypto.dart';
import 'unit/request.dart';
class Tabs extends StatefulWidget{
  Tabs({Key key}) : super (key:key);
  _TabsState createState() => _TabsState();

}

class _TabsState extends State<Tabs>{

  ScanResult scanResult;
  var _aspectTolerance = 0.00;
  var _numberOfCameras = 0;
  var _selectedCamera = -1;
  var _useAutoFocus = true;
  var _autoEnableFlash = false;

  static final _possibleFormats = BarcodeFormat.values.toList()
    ..removeWhere((e) => e == BarcodeFormat.unknown);

  List<BarcodeFormat> selectedFormats = [..._possibleFormats];

  @override
  // ignore: type_annotate_public_apis
  initState() {
    super.initState();

    Future.delayed(Duration.zero, () async {
      _numberOfCameras = await BarcodeScanner.numberOfCameras;
      setState(() {});
    });
    // scan();
  }
  int activeIndex = 0;
  List _pageList = [
    HomePage(key: globalKey),
    ScanPage(),
    MyPage()
  ];
  // _onRefresh 下拉刷新回调
  Future<Null> _onRefresh(){
    return Future.delayed(Duration(seconds: 5),(){   // 延迟5s完成刷新

    });
  }
  @override
  Widget build(BuildContext context) {
    //设置适配尺寸 (填入设计稿中设备的屏幕尺寸) 此处假如设计稿是按iPhone6的尺寸设计的(iPhone6 750*1334)
    ScreenUtil.init(context, designSize: Size(750, 1334), allowFontScaling: false);
    return Scaffold(
      resizeToAvoidBottomInset:false,
      body: this._pageList[this.activeIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: this.activeIndex,
        onTap: (int index){
         print(index);
         if(index == 1){
           scan();
           // setState(() {
           //   this.activeIndex = index;
           // });
         }else{
           setState(() {
             this.activeIndex = index;
           });
         }

        },selectedItemColor: Color(0xFF54CF7A),
        items: [

          BottomNavigationBarItem(
              icon: Icon(Icons.home),
              title: Text('首页'),
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.devices,),
              title: Text('扫一扫')
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.person),
              title: Text('我的')
          ),
        ],
      ),
    );
  }

  Future scan() async {
    try {
      var options = ScanOptions(
        strings: {
          "cancel": "Cancel",
          "flash_on": "开启灯光",
          "flash_off": "关闭灯光",
        },
        restrictFormat: selectedFormats,
        useCamera: _selectedCamera,
        autoEnableFlash: _autoEnableFlash,
        android: AndroidOptions(
          aspectTolerance: _aspectTolerance,
          useAutoFocus: _useAutoFocus,
        ),
      );

      var result = await BarcodeScanner.scan(options: options);


      _scanSbmit(result);
      setState(() => scanResult = result);
    } on PlatformException catch (e) {
      var result = ScanResult(
        type: ResultType.Error,
        format: BarcodeFormat.unknown,
      );

      if (e.code == BarcodeScanner.cameraAccessDenied) {
        setState(() {
          result.rawContent = 'The user did not grant the camera permission!';
        });
      } else {
        result.rawContent = 'Unknown error: $e';
      }

      setState(() {
        scanResult = result;
      });

    }
  }

  ///扫码提交
  _scanSbmit(trashNo)async{

    var resUlt = await Utils().request ({
      "method":"user.supervisor.scan",
      "biz_content":convert.jsonEncode({
        "trashNo":trashNo.rawContent.split('?')[1].split('=')[1],
      }),
      "token":myToken
    });

    print(resUlt);
    globalKey.currentState.childMethod();

  }

}