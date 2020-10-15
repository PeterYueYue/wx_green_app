import 'package:flutter/material.dart';
import 'package:flutter_app/unit/request.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'dart:convert' as convert;
import 'package:toast/toast.dart';
class MyPage extends StatefulWidget{
  MyPage({Key key}) : super (key:key);
  _MyPageState createState() => _MyPageState();

}

class _MyPageState extends State<MyPage>{
  void showToast(String msg, {int duration, int gravity}) {
    Toast.show(msg, context, duration: duration, gravity: gravity);
  }
  var passWord = "";
  var passWord1 = "";
  var oldPassWord = "";
  var userInfo = {};
  @override
  void initState() {
    super.initState();
    _getUserInfo();
  }
  ///获取督导员当前信息
  _getUserInfo() async {
    var resUlt = await Utils()
        .request({"method": "user.supervisor.info", "token": myToken});
    if (resUlt["code"] == "10000") {
      setState(() {
        userInfo = resUlt["result"];
      });
    } else {}
  }
  _changePassWord()async{
    var resUlt = await Utils().request({
      "method": "user.supervisor.changePassword",
      "biz_content":convert.jsonEncode({
        "password":this.passWord,
        "oldPassword":this.oldPassWord
      }),
      "token": myToken
    });
    print("------------------------");
    print(resUlt);
    if (resUlt["code"] == "10000") {

      showToast("修改成功！", duration: Toast.LENGTH_LONG);
      setState(() {
        passWord = "";
        oldPassWord = "";
      });


    }else{

      showToast(resUlt["result"]["sub_msg"], duration: Toast.LENGTH_LONG);
    }
  }
  @override
  Widget build(BuildContext context){

    //设置适配尺寸 (填入设计稿中设备的屏幕尺寸) 此处假如设计稿是按iPhone6的尺寸设计的(iPhone6 750*1334)
    ScreenUtil.init(context, designSize: Size(750, 1334), allowFontScaling: false);
    return Container(
        height: ScreenUtil().setHeight(1200),
      padding: EdgeInsets.fromLTRB(0, 100.ssp, 0, 110.ssp),
      color: Color(0xFF54CF7A),
      child: SingleChildScrollView(
        child:Column(

          children: [

            Container(

              padding: EdgeInsets.fromLTRB(0.ssp, 100.ssp, 0, 0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(75),
                child: Image.network(
                  'http://wuxigf.oss-cn-shanghai.aliyuncs.com/app/huazi.jpg',
                  width: 120.ssp,
                  height: 120.ssp,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Container(
              width: 700.ssp,
              alignment: AlignmentDirectional.topStart,
              padding:EdgeInsets.fromLTRB(60.ssp,100.ssp, 30.ssp, 0),
              child: Column(
                crossAxisAlignment:
                CrossAxisAlignment.start,
                children: [
                  Container(
                    padding:EdgeInsets.only(bottom: 30.ssp),
                    child: Text("用户姓名：${this.userInfo['name'] != null ? this.userInfo['name'] : '----'}",
                      style: TextStyle(fontSize: 32.ssp,color: Color.fromRGBO(255, 255, 255, 0.6)),
                    ),
                  ),
                  Text("登录账号：${this.userInfo['username'] != null ? this.userInfo['username'] : '----'}",
                    style: TextStyle(fontSize: 32.ssp,color: Color.fromRGBO(255, 255, 255, 0.6)),
                  ),
                ],
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
                style: new TextStyle(
                    color: Color(0xFFFFFFFF)
                ), // 设置字体样式
                textAlign: TextAlign.left, //输入的内容在水平方向如何显示
                cursorColor:Color.fromRGBO(255, 255, 255, 0.6),
                obscureText:true,
                onChanged: (value) {
                  setState(() {
                    oldPassWord = value;
                  });
                },
                decoration: new InputDecoration(
                  labelStyle:TextStyle(color: Color.fromRGBO(255, 255, 255, 0.6),),
                  labelText: "请输入旧密码",
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
              padding:EdgeInsets.fromLTRB(30.ssp,0.ssp, 30.ssp, 0),
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
                  labelText: "请输入新密码",
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
                  labelText: "请确认新密码",
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
                child: new Text('确认',
                  style:TextStyle(
                      fontSize: 36.ssp
                  ) ,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50.ssp),
                ),
                onPressed: () {
                  _changePassWord();
                },
              ),

            ),


          ],
        ) ,
      )


    );
  }

}

