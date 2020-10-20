import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:local_cache_sync/local_cache_sync.dart';
import 'Tabs.dart';
import 'register.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'dart:convert' as convert;
import 'package:toast/toast.dart';
import 'unit/request.dart';
import 'package:flutter/rendering.dart';
class Login extends StatefulWidget {
  final editToken;
  const Login({Key key, this.editToken}) : super(key: key);
  @override
  _LoginState createState() => _LoginState();

}

class _LoginState extends State<Login> {

  @override
  // ignore: type_annotate_public_apis
  initState() {
    super.initState();
    // myToken = LocalCacheSync.userDefault.getWithKey<String>('token');
    // if(myToken != ""){
    //   Future.delayed(Duration.zero, () {
    //     Navigator.push(context,    MaterialPageRoute(
    //         builder: (context) => new Tabs()));
    //   });
    //   // Navigator.push(context, MaterialPageRoute(builder: (context) => Tabs()));
    // }


  }
  void showToast(String msg, {int duration, int gravity}) {
    Toast.show(msg, context, duration: duration, gravity: gravity);
  }
  var userName = "";
  var passWord = "";



///获取TOKEN
  _loginSubmit() async{
     var resUlt = await Utils().request ({
       "method":"user.supervisor.login",
       "biz_content":convert.jsonEncode({
         "password":this.passWord,
         "username":this.userName
       })
     });
     ///  "username":"18621708610"
     ///  "password":"123456",

     if(resUlt["code"] == "10000"){
       myToken = resUlt["result"]["token"];
       // LocalCacheSync.userDefault.setWithKey<String>('token',myToken);
       Navigator.push(context, MaterialPageRoute(builder: (context) => Tabs()));
       //  widget.editToken(myToken);
     }else{
       showToast(resUlt["result"]["sub_msg"], duration: Toast.LENGTH_LONG);
     }


  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, designSize: Size(750, 1334), allowFontScaling: false);
    printScreenInformation();

    return Scaffold(
      // appBar: AppBar(
      //   title: Text(widget.title),
      // ),
      resizeToAvoidBottomInset:false,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(ScreenUtil().setWidth(10)),
              width: ScreenUtil().setWidth(750),
              height: ScreenUtil().setHeight(1334),
              constraints: BoxConstraints(minHeight: 1334.ssp),
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF18ef5a), Color(0xFF56d27c)],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  )),
              child:Column(
                  children:<Widget>[
                    Container(
                      alignment: AlignmentDirectional.topCenter,
                      padding:EdgeInsets.fromLTRB(0,280.ssp, 0, 0),
                      child:Image.network('http://wuxigf.oss-cn-shanghai.aliyuncs.com/app/titleImg.png',
                        width: 590.ssp,
                        height: 109.ssp,
                      ),
                    ),
                    Container(
                      alignment: AlignmentDirectional.topCenter,
                      padding:EdgeInsets.fromLTRB(30.ssp,200.ssp, 30.ssp, 0),
                      child:new TextField(
                        autocorrect: false, // 是否自动校正
                        autofocus: false, //自动获取焦点
                        enabled: true, // 是否启用
                        inputFormatters: [], //对输入的文字进行限制和校验
                        keyboardType: TextInputType.text, //获取焦点时,启用的键盘类型
                        onEditingComplete: () {
                          print('test');
                        },
                        onChanged: (value) {
                          setState(() {
                            userName = value;
                          });
                        },
                        style: new TextStyle(
                          color: Color(0xFFFFFFFF),
                        ), // 设置字体样式
                        textAlign: TextAlign.left, //输入的内容在水平方向如何显示
                        cursorColor:Color.fromRGBO(255, 255, 255, 0.6),
                        decoration: new InputDecoration(

                          labelStyle:TextStyle(color: Color.fromRGBO(255, 255, 255, 0.6),),
                          labelText: "请输入账号",
                          prefixIcon: const Icon(
                            Icons.person,
                            color: Colors.white,
                          ),
                          contentPadding: EdgeInsets.all(10.0),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: Color.fromRGBO(255, 255, 255, 0.6),
                              width: 1,
                              // style: BorderStyle.none, // 隐藏边框
                            ),
                          ),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: Color.fromRGBO(255, 255, 255, 0.6),
                              width: 1.ssp,
                              // style: BorderStyle.none, // 隐藏边框
                            ),

                          ),
                        ),
                      ),

                    ),
                    Container(
                      alignment: AlignmentDirectional.topCenter,
                      padding:EdgeInsets.fromLTRB(30.ssp,20.ssp, 30.ssp, 0),
                      child:new TextField(
                        autocorrect: false, // 是否自动校正
                        autofocus: false, //自动获取焦点
                        enabled: true, // 是否启用
                        inputFormatters: [], //对输入的文字进行限制和校验
                        keyboardType: TextInputType.text, //获取焦点时,启用的键盘类型
                        style: new TextStyle(
                            color: Color(0xFFFFFFFF)
                        ), // 设置字体样式
                        textAlign: TextAlign.left, //输入的内容在水平方向如何显示
                        cursorColor:Color.fromRGBO(255, 255, 255, 0.6),
                        obscureText:true,
                        onChanged: (value) {
                          setState(() {
                            passWord = value;
                          });
                        },
                        decoration: new InputDecoration(
                          labelStyle:TextStyle(color: Color.fromRGBO(255, 255, 255, 0.6),),
                          labelText: "请输入密码",
                          prefixIcon: const Icon(
                            Icons.lock,
                            color: Colors.white,
                          ),
                          contentPadding: EdgeInsets.all(10.0),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: Color.fromRGBO(255, 255, 255, 0.6),
                              width: 1,
                              // style: BorderStyle.none, // 隐藏边框
                            ),
                          ),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: Color.fromRGBO(255, 255, 255, 0.6),
                              width: 1.ssp,
                              // style: BorderStyle.none, // 隐藏边框
                            ),
                          ),
                        ),
                      ),

                    ),

                    Container(
                      alignment: AlignmentDirectional.topCenter,
                      padding:EdgeInsets.fromLTRB(0,80.h, 0, 0),
                      child:MaterialButton(
                        minWidth:600.ssp,
                        height: 100.ssp,
                        color: Colors.white,
                        textColor: Colors.blue,
                        child: new Text('登录',
                          style:TextStyle(
                              fontSize: 36.ssp
                          ) ,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50.ssp),
                        ),
                        onPressed: () {

                          _loginSubmit();



                        },
                      ),

                    ),
                    Container(
                        alignment: AlignmentDirectional.topCenter,
                        padding:EdgeInsets.fromLTRB(0,30.ssp, 0, 0),
                        child:MaterialButton(
                          minWidth:600.ssp,
                          height: 100.ssp,
                          color: Color.fromRGBO(255, 255, 255, 0.3),
                          textColor: Colors.white,
                          child: new Text('注册',
                            style: TextStyle(
                                fontSize: 36.ssp
                            ),
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50.ssp),
                          ),
                          onPressed: () {
                            // ...
                            Navigator.push(context, MaterialPageRoute(builder: (context) => Register()));



                          },
                        )

                    ),

                  ]

              ),




            ),

            // Text('设备宽度:${ScreenUtil().screenWidthPx}px'),
            // Text('设备高度:${ScreenUtil().screenHeightPx}px'),
            // Text('设备宽度:${ScreenUtil().screenWidth}dp'),
            // Text('设备高度:${ScreenUtil().screenHeight}dp'),
            // Text('设备的像素密度:${ScreenUtil().pixelRatio}'),
            // Text('底部安全区距离:${ScreenUtil().bottomBarHeight}dp'),
            // Text('状态栏高度:${ScreenUtil().statusBarHeight}dp'),
            // Text(
            //   '实际宽度的dp与设计稿px的比例:${ScreenUtil().scaleWidth}',
            //   textAlign: TextAlign.center,
            // ),
            // Text(
            //   '实际高度的dp与设计稿px的比例:${ScreenUtil().scaleHeight}',
            //   textAlign: TextAlign.center,
            // ),
            // SizedBox(
            //   height: 100.h,
            // ),
            //
            // Text('系统的字体缩放比例:${ScreenUtil().textScaleFactor}'),
            // Column(
            //   crossAxisAlignment: CrossAxisAlignment.start,
            //   children: <Widget>[
            //     Text(
            //       '我的文字大小在设计稿上是24px，不会随着系统的文字缩放比例变化',
            //       style: TextStyle(
            //         color: Colors.black,
            //         fontSize: 24.sp,
            //       ),
            //     ),
            //     Text(
            //       '我的文字大小在设计稿上是24px，会随着系统的文字缩放比例变化',
            //       style: TextStyle(
            //         color: Colors.black,
            //         fontSize: 24.ssp,
            //       ),
            //     ),
            //   ],
            // )
          ],
        ),
      ),
      // floatingActionButton: FloatingActionButton(
      //   child: Icon(Icons.title),
      //   onPressed: () {
      //     ScreenUtil.init(
      //       context,
      //       designSize: Size(750, 1334),
      //       allowFontScaling: false,
      //     );
      //     setState(() {});
      //   },
      // ),
    );
  }



  void printScreenInformation() {
    // print('设备宽度:${ScreenUtil().screenWidth}'); //Device width
    // print('设备高度:${ScreenUtil().screenHeight}'); //Device height
    // print('设备的像素密度:${ScreenUtil().pixelRatio}'); //Device pixel density
    // print(
    //   '底部安全区距离:${ScreenUtil().bottomBarHeight}dp',
    // ); //Bottom safe zone distance，suitable for buttons with full screen
    // print(
    //   '状态栏高度:${ScreenUtil().statusBarHeight}dp',
    // ); //Status bar height , Notch will be higher Unit px
    //
    // print('实际宽度的dp与设计稿px的比例:${ScreenUtil().scaleWidth}');
    // print('实际高度的dp与设计稿px的比例:${ScreenUtil().scaleHeight}');
    //
    // print(
    //   '宽度和字体相对于设计稿放大的比例:${ScreenUtil().scaleWidth * ScreenUtil().pixelRatio}',
    // );
    // print(
    //   '高度相对于设计稿放大的比例:${ScreenUtil().scaleHeight * ScreenUtil().pixelRatio}',
    // );
    // print('系统的字体缩放比例:${ScreenUtil().textScaleFactor}');
    //
    // print('屏幕宽度的0.5:${0.5.wp}');
    // print('屏幕高度的0.5:${0.5.hp}');
  }
}