import 'package:flutter/material.dart';
import 'package:flutter_app/unit/request.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'dart:convert' as convert;

// import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:toast/toast.dart';

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
    _getUserInfo();
    this.siteList = [];
    _getSiteListData(1);
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

  Widget build(BuildContext context) {
    //设置适配尺寸 (填入设计稿中设备的屏幕尺寸) 此处假如设计稿是按iPhone6的尺寸设计的(iPhone6 750*1334)
    ScreenUtil.init(context, designSize: Size(750, 1334), allowFontScaling: false);
    return Stack(
      children: [
        Column(
          children: [
            SizedBox(
              height: ScreenUtil().setHeight(1200.0),
              child: EasyRefresh.custom(
                enableControlFinishRefresh: false,
                enableControlFinishLoad: true,
                controller: _controller,
                header: ClassicalHeader(),
                footer: ClassicalFooter(),

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
                                          'http://wuxigf.oss-cn-shanghai.aliyuncs.com/app/huazi.jpg',
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
                                  padding: EdgeInsets.fromLTRB(0, 32.ssp, 0, 0),
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
                                              _review(this.siteList[i], 2);
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
              ),
            ),
          ],
        ),
      ],
    );
  }

}
