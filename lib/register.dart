import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'file:///C:/Users/86152/AndroidStudioProjects/flutter_app/lib/register.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'home.dart';
import 'dart:convert' as convert;
import 'package:crypto/crypto.dart';
import 'unit/request.dart';
import 'package:flutter/rendering.dart';
import 'package:toast/toast.dart';

void main()  {
  runApp(Register());
}
class Register extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return  MyHomePage();

  }
}

class MyHomePage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    //设置适配尺寸 (填入设计稿中设备的屏幕尺寸) 此处假如设计稿是按iPhone6的尺寸设计的(iPhone6 750*1334)
    ScreenUtil.init(context, designSize: Size(750, 1334), allowFontScaling: false);
    return ExampleWidget(title: 'FlutterScreenUtil 示例');
  }
}

class ExampleWidget extends StatefulWidget {
  const ExampleWidget({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _ExampleWidgetState createState() => _ExampleWidgetState();
}

class _ExampleWidgetState extends State<ExampleWidget> {

  void showToast(String msg, {int duration, int gravity}) {
    Toast.show(msg, context, duration: duration, gravity: gravity);
  }

  var userName = "";
  var passWord = "";
  var passWord1 = "";
  var name = "";




  ///获取TOKEN
  _loginSubmit() async{

    if(this.passWord != this.passWord1){
      showToast("两次输入的密码不一致", duration: Toast.LENGTH_LONG);
    }
    var resUlt = await Utils().request ({
      "method":"user.supervisor.register",
      "biz_content":convert.jsonEncode({
        "password":this.passWord,
        "username":this.userName,
        "name":this.name
      })
    });
    print(this.passWord);
    ///  "username":"18621708610"
    ///  "password":"123456",


    if(resUlt["code"] == "10000"){
      showToast("恭喜你注册成功！", duration: Toast.LENGTH_LONG);
      Navigator.of(context).pop();
      // Navigator.push(context, MaterialPageRoute(builder: (context) => IndexHome()));
    }else{
      // showToast(convert.jsonDecode(resUlt.toString())["msg"], duration: Toast.LENGTH_LONG);
      showToast(resUlt["result"]["sub_msg"], duration: Toast.LENGTH_LONG);
    }


    print(resUlt);
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: SingleChildScrollView(

        child: Column(
            children:<Widget>[
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
                child: Column(
                  children: [
                    Container(
                      alignment: AlignmentDirectional.topCenter,
                      padding:EdgeInsets.fromLTRB(0,100.ssp, 0, 0),
                      child:Image.network('http://wuxigf.oss-cn-shanghai.aliyuncs.com/app/titleImg.png',
                        width: 590.ssp,
                        height: 109.ssp,
                      ),
                    ),
                    Container(
                      alignment: AlignmentDirectional.topCenter,
                      padding:EdgeInsets.fromLTRB(30.ssp,100.ssp, 30.ssp, 0),
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
                            name = value;
                          });
                        },
                        style: new TextStyle(
                          color: Color(0xFFFFFFFF),
                        ), // 设置字体样式
                        textAlign: TextAlign.left, //输入的内容在水平方向如何显示
                        cursorColor:Color.fromRGBO(255, 255, 255, 0.6),
                        decoration: new InputDecoration(

                          labelStyle:TextStyle(color: Color.fromRGBO(255, 255, 255, 0.6),),
                          labelText: "请输入名字",
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
                      padding:EdgeInsets.fromLTRB(30.ssp,0.ssp, 30.ssp, 0),
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
                            Icons.mobile_screen_share,
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
                          labelText: "密码",
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
                            passWord1 = value;
                          });
                        },
                        decoration: new InputDecoration(
                          labelStyle:TextStyle(color: Color.fromRGBO(255, 255, 255, 0.6),),
                          labelText: "确认密码",
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
                        padding:EdgeInsets.fromLTRB(0,100.ssp, 0, 0),
                        child:MaterialButton(
                          minWidth:600.ssp,
                          height: 100.ssp,
                          color: Colors.white,
                          textColor: Colors.blue,
                          child: new Text('注册',
                            style: TextStyle(
                                fontSize: 36.ssp
                            ),
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50.ssp),
                          ),
                          onPressed: () {
                            _loginSubmit();
                          },
                        )

                    ),
                    Container(
                      alignment: AlignmentDirectional.topCenter,
                      padding:EdgeInsets.fromLTRB(0,30.ssp, 0, 0),
                      child:MaterialButton(
                        minWidth:600.ssp,
                        height: 100.ssp,

                        color: Color.fromRGBO(255, 255, 255, 0.3),

                        textColor: Colors.white,
                        child: new Text('已有登录账号',
                          style:TextStyle(
                              fontSize: 36.ssp
                          ) ,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50.ssp),
                        ),
                        onPressed: () {
                          Navigator.of(context).pop(this);
                        },
                      ),

                    ),
                  ],
                ),
              )

            ]

        ),
      ),

    );
  }


}