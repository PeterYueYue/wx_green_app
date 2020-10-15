import 'dart:async';
import 'dart:convert';
import 'dart:io' show Platform;
import '../listData.dart';

import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


class ScanPage extends StatefulWidget {
  ScanPage({Key key}) : super (key:key);
  _ScanPageState createState() => _ScanPageState();


}

class _ScanPageState extends State<ScanPage> {
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

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, designSize: Size(750, 1334), allowFontScaling: false);

    return Container(
      padding: EdgeInsets.only(top: 200.ssp),
      child: Column(
        children: [
          Container(
            child: IconButton(
              icon: Icon(Icons.camera),
              tooltip: "Scan",
              onPressed: scan,
            ),
          ),
          IconButton(
            icon: Icon(Icons.camera),
            tooltip: "Scan",
            onPressed: scan,
          ),
          Text(this.scanResult != null ?this.scanResult.rawContent:""),
          GestureDetector(
            child: Container(
              width: 200.ssp,
              height: 500.ssp,
              color: Colors.pink,
            ),
            onTapDown: (event) => {
              print(this.scanResult)
            },
          ),

        ],
      )
    );


  }

  Future scan() async {
    try {
      var options = ScanOptions(
        strings: {
          "cancel": "Cancel",
          "flash_on": "开启灯光1",
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


}