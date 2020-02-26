
/*

{"errno":16,"error":"unsuccess: TIME_OUT null"}//表示设备休眠或者功能码错误或者物联网平台问题
{"errno":3,"error":"auth failed"}//imei错误
{"errno":14,"error":"network latency: network latency or device offline"}//设备离线

*/

function getReturnMsg(code) { 
    var vMsg="";
    switch(code)
    {
      case 3:
            vMsg="imei错误";
            break;
      case 14:
          vMsg = "设备离线";
        break;
      case 16:
          vMsg = "表示设备休眠或者功能码错误或者物联网平台问题";
        break;
    }
    return vMsg;

}