import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_app/unit/request.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'dart:convert' as convert;
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:toast/toast.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:async';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart' as path_provider;

_randomBit(int len) {
  String scopeF = "e16a94bf-3b29-49f6-8bc0-fe9706f8c302";//首位
  String scopeC = "${new DateTime.now().millisecondsSinceEpoch}";//中间
  String result = "";
  for (int i = 0; i < len; i++) {
    if (i == 1) {
      result = scopeF[Random().nextInt(scopeF.length)];
    } else {
      result = result + scopeC[Random().nextInt(scopeC.length)];
    }
  }
  return result;
}
GlobalKey<_HomePageState> globalKey = GlobalKey();

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  void showToast(String msg, {int duration, int gravity}) {
    Toast.show(msg, context, duration: duration, gravity: gravity);
  }
  EasyRefreshController _controller;
  var _imgPath = "";
  // 条目总数
  int listpage = 1;
  int _page = 1;

  @override
  int activeIndex = -1;
  var userInfo = {};
  var siteList = [];

  initState() {
    super.initState();
    _controller = EasyRefreshController();
    _getUserInfo();
    _getSiteListData(this._page);
  }

  childMethod() {
    print("123");
    _getUserInfo();
    this.siteList = [];
    _getSiteListData(1);
  }


  ///获取督导员当前信息
  _getUserInfo() async {
    var resUlt = await Utils().request({"method": "user.supervisor.info", "token": myToken});
    if (resUlt["code"] == "10000") {
      setState(() {
        userInfo = resUlt["result"];
      });
    } else {}
  }

  ///获取站点投递数据
  _getSiteListData(pageNumber) async {


    var resUlt = await Utils().request({
      "method": "user.delivery.sitePage",
      "biz_content":
          convert.jsonEncode({"pageNumber": pageNumber, "pageSize": 10}),
      "token": myToken
    });


    if (resUlt["code"] == "10000") {
      var arr = this.siteList;
      arr.addAll(resUlt["result"]["content"]);


      setState(() {
        siteList = arr;
        listpage = resUlt["result"]["pages"];
      });
    } else {}
  }

  ///审核投递结果
  _review(item, state) async {
    var resUlt = await Utils().request({
      "method": "user.supervisor.review",
      "biz_content": convert.jsonEncode({"id": item["id"], "state": state}),
      "token": myToken
    });
    showToast(convert.jsonDecode(resUlt.toString())["msg"], duration: Toast.LENGTH_LONG);
    if (convert.jsonDecode(resUlt.toString())["code"] == "10000") {
      _getUserInfo();

      setState(() {
        this.siteList = [];
      });
      _getSiteListData(this._page);
      this.activeIndex = -1;
    }
  }

  /*图片控件*/
  // Widget _ImageView(imgPath) {
  //   if (imgPath == null) {
  //     return Center(
  //       child: Text("请选择图片或拍照"),
  //     );
  //   } else {
  //     return Image.file(
  //       imgPath,
  //     );
  //   }
  // }

  //上传文件
  _upLoadImage(_image) async {
    String path = _image.path;
    var name = path.substring(path.lastIndexOf("/") + 1, path.length);

    File imageFile = await FlutterImageCompress.compressAndGetFile(
      _image.absolute.path,
      Directory.systemTemp.path +
          '/userava' +
          DateTime.now().millisecondsSinceEpoch.toString() +
          '.jpg',
      quality: 50,
    );

    var data = await Utils().upload({
      "method": "file.upload",
      "token": myToken,
    });
    print(data["app_id"]);
    FormData formData = FormData.fromMap({
      "method":data["method"],
      "app_id":data["app_id"],
      "timestamp":data["timestamp"],
      "nonce":data["nonce"],
      "microServiceIp":data["microServiceIp"],
      "version":data["version"],
      "sign":data["sign"],
      "token": myToken,
      "file":  await MultipartFile.fromFile(imageFile.path, filename: name)
    });
    var response =  await Dio().post("https://gateway.wuxigf.com/apiv2/", data:formData);
    print("9999999999-------------------------------");
    print(response.data);
    return response.data["result"]["imgUrl"];


  }

  /* 单图片压缩 与 flie存图*/
  static Future<FormData> _saveImage(File file) async {
    File imageFile = await FlutterImageCompress.compressAndGetFile(
      file.absolute.path,
      Directory.systemTemp.path +
          '/userava' +
          DateTime.now().millisecondsSinceEpoch.toString() +
          '.jpg',
      quality: 50,
    );
    print('压缩后图片文件大小:' + imageFile.lengthSync().toString());
    FormData formData = FormData.fromMap({
      'file': await MultipartFile.fromFile(imageFile.path,
          filename: imageFile.path.substring(
              imageFile.path.lastIndexOf("/") + 1, imageFile.path.length))
    });
    return formData;
  }
  // /*拍照*/
  _takePhoto(item,state) async {
    // ignore: deprecated_member_use
    var image = await ImagePicker.pickImage(source: ImageSource.camera);
    print(image.path);
    var imgUrl = await  _upLoadImage(image);


    var resUlt = await Utils().request({
      "method": "user.delivery.photo",
      "biz_content": convert.jsonEncode({"id": item["id"], "url":imgUrl}),
      "token": myToken
    });
    print(resUlt);

    _review(item,state);


  }


  Future<List<int>> testCompressFile(File file) async {
    final result = await FlutterImageCompress.compressWithFile(
      file.absolute.path,
      minWidth: 2300,//压缩后的最小宽度
      minHeight: 1500,//压缩后的最小高度
      quality: 20,//压缩质量
      rotate: 0,//旋转角度
    );
    return result;
  }

  // /*相册*/
  _openGallery() async {
    // ignore: deprecated_member_use
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      _imgPath = image as String;
    });
  }

  Widget build(BuildContext context) {
    //设置适配尺寸 (填入设计稿中设备的屏幕尺寸) 此处假如设计稿是按iPhone6的尺寸设计的(iPhone6 750*1334)
    ScreenUtil.init(context, designSize: Size(750, 1334), allowFontScaling: false);
    return EasyRefresh.custom(

      enableControlFinishRefresh: false,
      enableControlFinishLoad: true,
      controller: _controller,
      header: ClassicalHeader(
          refreshText:'下拉刷新',
          refreshReadyText:"下拉刷新",
          refreshingText:"刷新中...",
          refreshedText: "刷新完成",
          showInfo:false
      ),
      footer: ClassicalFooter(
        loadedText:"没有更多数据",
      ),

      ///下拉刷新
      onRefresh: () async {
        this.siteList = [];
        setState(() {
          _page = 1;
        });
        _getSiteListData(1);
        _controller.resetLoadState();
      },

      ///上拉加载更多数据
      onLoad: () async {
        print("@22");
        // await Future.delayed(
        //
        //     Duration(seconds: 2)
        // );

        setState(() {
          _page = _page++;
        });

        if (this.listpage > this._page) {
          _getSiteListData(this._page+=1);
        }else{
          _controller.resetLoadState();
        }
      },
      slivers: <Widget>[
        SliverList(
          delegate: SliverChildBuilderDelegate(
                (context, index) {
              return Container(
                child: Column(
                  children: [
                    Container(
                      width: 750.ssp,
                      padding: EdgeInsets.fromLTRB(0, 100.ssp, 0, 110.ssp),
                      color: Color(0xFF54CF7A),
                      child: Row(
                        children: [
                          Container(
                            padding:
                            EdgeInsets.fromLTRB(33.ssp, 0, 0, 0),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(75),
                              child: Image.network(
                                'http://wuxigf.oss-cn-shanghai.aliyuncs.com/app/logo.png',
                                width: 150.ssp,
                                height: 150.ssp,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Container(
                            height: 150.ssp,
                            width: 500.ssp,
                            padding:
                            EdgeInsets.fromLTRB(33.ssp, 0, 0, 0),
                            child: Column(
                              crossAxisAlignment:
                              CrossAxisAlignment.start,
                              mainAxisAlignment:
                              MainAxisAlignment.center,
                              children: [
                                Text(
                                  "督导员：${this.userInfo['name'] != null ? this.userInfo['name'] : '----'}",
                                  style: TextStyle(
                                      color: Color(0xFFFFFFFF),
                                      fontSize: 36.ssp),
                                ),
                                Container(
                                  height: 20.ssp,
                                ),
                                Text(
                                  "账号：${this.userInfo['username'] != null ? this.userInfo['username'] : '----'}",
                                  style: TextStyle(
                                    color: Color(0xFFFFFFFF),
                                    fontSize: 26.ssp,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    //  投递数据
                    Container(
                        transform: Matrix4.translationValues(0, -90.ssp, 0),
                        padding: EdgeInsets.fromLTRB(0, 32.ssp, 0, 20.ssp),
                        decoration: new BoxDecoration(
                            border: new Border.all(
                                color: Color(0xFFFFFFFF), width: 0.5),
                            color: Color(0xFFFFFFFF),
                            boxShadow: [
                              BoxShadow(
                                color: Color(0xFFF5F5F5),
                                spreadRadius: 2.ssp,
                                offset: Offset(1.ssp, 1.ssp),
                              ),
                            ],
                            borderRadius:
                            new BorderRadius.circular((20.0))),
                        // height: 230.ssp,
                        width: 700.ssp,
                        alignment: Alignment.center,
                        child: Column(
                          children: [
                            Row(
                                mainAxisAlignment:
                                MainAxisAlignment.center,
                                children: [
                                  Image.network(
                                    'http://wuxigf.oss-cn-shanghai.aliyuncs.com/applet/index/addressIcon.png',
                                    width: 34.ssp,
                                    height: 34.ssp,
                                    fit: BoxFit.cover,
                                  ),
                                  Container(
                                    margin:
                                    EdgeInsets.only(left: 10.ssp),
                                    child: Text(
                                      '${this.userInfo['siteName'] != null ? this.userInfo['siteName'] : '----'}',
                                      style: TextStyle(
                                        fontSize: 36.ssp,
                                        color: Color(0xFF54CF7A),
                                      ),
                                    ),
                                  )
                                ]),
                            Container(
                              margin: EdgeInsets.only(top: 30.ssp),
                              child: Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceAround,
                                children: [
                                  Column(
                                    children: [
                                      Text(
                                        "今日投递次数",
                                        style: TextStyle(
                                            fontSize: 28.ssp,
                                            color: Color(0xFF666666)),
                                      ),
                                      Container(
                                        margin: EdgeInsets.only(
                                            top: 20.ssp),
                                        child: Text(
                                          "${this.userInfo['todayTotalDelivery'] != null ? this.userInfo['todayTotalDelivery'] : '0'}次",
                                          style: TextStyle(
                                              fontSize: 36.ssp,
                                              color:
                                              Color(0xFF333333)),
                                        ),
                                      )
                                    ],
                                  ),
                                  Column(
                                    children: [
                                      Text(
                                        "今日正确投递",
                                        style: TextStyle(
                                            fontSize: 28.ssp,
                                            color: Color(0xFF666666)),
                                      ),
                                      Container(
                                        margin: EdgeInsets.only(
                                            top: 20.ssp),
                                        child: Text(
                                          "${this.userInfo['todayTotalRightDelivery'] != null ? this.userInfo['todayTotalRightDelivery'] : '0'}次",
                                          style: TextStyle(
                                              fontSize: 36.ssp,
                                              color:
                                              Color(0xFF333333)),
                                        ),
                                      )
                                    ],
                                  ),
                                  Column(
                                    children: [
                                      Text(
                                        "今日发放积分",
                                        style: TextStyle(
                                            fontSize: 28.ssp,
                                            color: Color(0xFF666666)),
                                      ),
                                      Container(
                                        margin: EdgeInsets.only(
                                            top: 20.ssp),
                                        child: Text(
                                          "${this.userInfo['todayTotalPoint'] != null ? this.userInfo['todayTotalPoint'] : '0'}",
                                          style: TextStyle(
                                              fontSize: 36.ssp,
                                              color:
                                              Color(0xFF333333)),
                                        ),
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            )
                          ],
                        )),
                  ],
                ),
              );
            },
            childCount: 1,
          ),
        ),
        SliverList(
          delegate: SliverChildBuilderDelegate(
                (context, i) {
              return GestureDetector(
                child: Container(
                  // width: 700.ssp,
                  margin: EdgeInsets.only(bottom: 20.ssp,left: 30.ssp,right: 30.ssp),
                  padding: EdgeInsets.all(30.ssp),
                  height: 320.ssp,
                  decoration: new BoxDecoration(
                      border: new Border.all(
                          color: this.siteList[i]["state"] == 0
                              ? Color(0xFF54D07A)
                              : Color(0xFFF2F2F2F2),
                          width: 2.ssp),
                      color: Color(0xFFF2F2F2F2),
                      borderRadius:
                      new BorderRadius.circular((20.ssp))),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text(
                          "家庭：${this.siteList[i]["community"]}${this.siteList[i]["build"]}${this.siteList[i]["room"]}",
                          style: TextStyle(
                              fontSize: 28.ssp,
                              color: Color(0xFF666666))),
                      Text("垃圾桶编号：${this.siteList[i]["trashNo"]}",
                          style: TextStyle(
                              fontSize: 28.ssp,
                              color: Color(0xFF666666))),
                      this.siteList[i]["state"] == 0
                          ? Row(
                        mainAxisAlignment:
                        MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                            child: Container(
                              width: 290.ssp,
                              height: 80.ssp,
                              child: Center(
                                child: Text(
                                  "正确投递",
                                  style: TextStyle(
                                      fontSize: 28.ssp,
                                      color: Color(0xFFFFFFFF)),
                                ),
                              ),
                              decoration: new BoxDecoration(
                                  color: Color(0xFF54CF7A),
                                  borderRadius:
                                  new BorderRadius.circular(
                                      (20.ssp))),
                            ),
                            onTap: () {
                              _review(this.siteList[i], 1);
                            },
                          ),
                          GestureDetector(
                            child: Container(
                              width: 290.ssp,
                              height: 80.ssp,
                              child: Center(
                                child: Text(
                                  "错误投递",
                                  style: TextStyle(
                                      fontSize: 28.ssp,
                                      color: Color(0xFFFFFFFF)),
                                ),
                              ),
                              decoration: new BoxDecoration(
                                  color: Color(0xFFFF7B10),
                                  borderRadius:
                                  new BorderRadius.circular(
                                      (20.ssp))),
                            ),
                            onTap: () {
                              _takePhoto(this.siteList[i], 2);
                              // _review(this.siteList[i], 2);
                            },
                          )
                        ],
                      )
                          : Row(
                        mainAxisAlignment:
                        MainAxisAlignment.spaceBetween,
                        children: [
                          this.siteList[i]["state"] == 1
                              ? (Text(
                            "正确投递",
                            style: TextStyle(
                                fontSize: 28.ssp,
                                color: Color(0xFF54D07A)),
                          ))
                              : (Text("错误投递")),
                          Row(
                            children: [
                              Text("授予积分："),
                              Text(
                                "${this.siteList[i]["point"]}",
                                style: TextStyle(
                                    fontSize: 28.ssp,
                                    color: this.siteList[i]
                                    ["state"] ==
                                        1
                                        ? Color(0xFF54D07A)
                                        : Color(0xFF666666)),
                              )
                            ],
                          )
                        ],
                      )
                    ],
                  ),
                ),
                onTapDown: (event) {

                  if (this.siteList[i]["state"] == 0 &&
                      this.activeIndex == -1) {
                    setState(() {
                      this.activeIndex = i;
                    });
                  } else {
                    setState(() {
                      this.activeIndex = -1;
                    });
                  }
                  print(this.activeIndex);
                },
              );
            },
            childCount: this.siteList.length,
          ),
        ),
      ],
    );
  }


}
