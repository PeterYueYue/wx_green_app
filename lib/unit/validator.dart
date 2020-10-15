class Validator {
  static checkMobile(value){
    if(value.isEmpty){
      return "请输入手机号";
    }
    RegExp reg = new RegExp(r'^d{11}$');
    if (!reg.hasMatch(value)) {
      return "请输入11位手机号码";
    }
    return true;
  }
}