
import 'dart:convert';
import 'dart:math';
import 'package:flutter_app/unit/user.dart';
import 'package:http/http.dart' as http;
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'dart:convert' as convert;
import 'package:dio/dio.dart';

var myToken = "";


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

String getSign(Map parameter) {
  var Key = "0878b0d87e84486dad0a9856593fb7ac";
  /// 存储所有key
  List<String> allKeys = [];
  parameter.forEach((key,value){
    allKeys.add(key +"="+value+"&");
  });
  /// key排序
  allKeys.sort((obj1,obj2){
    return obj1.compareTo(obj2);
  });


  // /// 存储所有键值对
  // List<String> pairs = [];
  // /// 添加键值对
  // allKeys.forEach((key){
  //   pairs.add("$key${parameter[key]}");
  // });
  /// 数组转string
  String pairsString = allKeys.join("");
  ///字符串删除最后一个 &
  pairsString = pairsString.substring(0,pairsString.length - 1);
  /// 拼接 ABC 是你的秘钥
  String sign = pairsString + Key;
  print(sign);
  /// hash
  // String signString = generateMd5(sign).toUpperCase();
  String signString = md5.convert(utf8.encode(sign)).toString().toUpperCase();  //直接写也可以
  return signString;
}
/// md5加密
String generateMd5(String data) {
  var content = new Utf8Encoder().convert(data);
  var digest = md5.convert(content);
  // 这里其实就是 digest.toString()
  var hex;
  return hex.encode(digest.bytes);
}

class Utils extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    throw UnimplementedError();
  }

  /// 网络请求
  request  (Map parameter) async {

    var apiUrl = "https://gateway.wuxigf.com/apiv2/";
    var timestamp = new DateTime.now();
    print(timestamp.toString());
    var nonce = _randomBit(5);
    var app_id = "20200608719606620987850752";
    var microServiceIp = "10.9.0.4";
    parameter['timestamp'] = timestamp.toString();
    parameter['nonce'] = nonce;
    parameter['app_id'] = app_id;
    parameter['microServiceIp'] = microServiceIp;
    parameter['version'] = "1.0";
    /// 获取加密签名
    var sign = getSign(parameter);
    parameter['sign'] = sign;
    var dio = Dio();
    var response = await dio.post(apiUrl,data:parameter);
    print(response);
    return response.data;
  }

  void handle(error) {
    print(error);
  }




}














