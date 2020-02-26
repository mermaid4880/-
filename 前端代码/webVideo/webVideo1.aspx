<%@ Page Language="C#" AutoEventWireup="true" CodeFile="webVideo1.aspx.cs" Inherits="主预览_webVideo1" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title></title>
    <script src="../plugins/WebVideoCtrl/jquery-1.7.1.min.js"></script>
    <script src="../plugins/WebVideoCtrl/webVideoCtrl.js"></script>

    <script src="../js/layer/layer.js"></script>

    <style>

        body {
            margin:0px;
            padding:0px;

        }

    </style>
    <script>
        var public_ip = "<%=ip%>";//ip.
        var public_iPrototocol= 1;
        var public_port = 80;
        var public_username = "admin";
        var public_psw = "admin12345";
        var public_loadSuccess = false;//是否登录成功
        var g_iWndIndex = 0; //可以不用设置这个变量，有窗口参数的接口中，不用传值，开发包会默认使用当前选择窗口

        $(function () {
            // 检查插件是否已经安装过
            if (-1 == WebVideoCtrl.I_CheckPluginInstall()) {
                alert("您还未安装过插件，双击开发包目录里的WebComponents.exe安装！");
                return;
            }

            // 初始化插件参数及插入插件
            WebVideoCtrl.I_InitPlugin(500, 281, {
                iWndowType: 1,
                cbSelWnd: function (xmlDoc) {
                    //alert(XML2String(xmlDoc));
                },
                cbEvent: function (e1, e2, e3) {
                    //console.log(e2);
                    //alert(e2);
                }
            });
            WebVideoCtrl.I_InsertOBJECTPlugin("divPlugin1");
            if (public_ip) {
                login();
            }

            // 关闭浏览器
	        $(window).unload(function () {
		        WebVideoCtrl.I_Stop();
	        });

        });

        //开始登录
        function login() {

             layer.msg("开始登录！");
            if (public_ip) {

                var iRet = WebVideoCtrl.I_Login(public_ip, public_iPrototocol, public_port, public_username, public_psw, {
                    success: function (xmlDoc) {
                        //这里登录成功
                        layer.msg("登录成功！");
                        //这里开始播放
                        var iRet = WebVideoCtrl.I_StartRealPlay(public_ip);
                        //alert(iRet);
                        public_loadSuccess = true;//登录成功了
                    },
                    error: function () {
                        layer.msg("登录失败！");
                    }
                });

	            if (-1 == iRet) {
                     layer.msg("已登录过！");

	            }

            }
         }
         //拍照 、录像等
         function videoMethod(methodName) {
             console.log("1111");
             var vResult = "未登录成功";
             
             if (methodName == "拍照") {
                 var szPicName = "paizhao_" + new Date().getTime(); //照片名称
                 var iRet = WebVideoCtrl.I_CapturePic(szPicName);
                 if (0 == iRet) {
                     vResult = "抓图成功！";
                 } else {
                     vResult = "抓图失败！[" + iRet + "]";
                 }
             }
             else if (methodName == "录像开始") {
                 var szPicName = "luxiang_" + new Date().getTime(); //照片名称
                 var iRet = WebVideoCtrl.I_StartRecord(szPicName);
                 if (0 == iRet) {
                     vResult = "开始录像成功！";
                 } else {
                     vResult = "开始录像失败！[" + iRet + "]";
                 }
             }
             else if (methodName == "录像结束") {
                 var iRet = WebVideoCtrl.I_StopRecord();
                 if (0 == iRet) {
                     vResult = "停止录像成功！";
                 } else {
                     vResult = "停止录像失败！[" + iRet + "]";
                 }
             }
             else if (methodName == "录音开始") {
                 var iRet = WebVideoCtrl.I_StopRecord();
                 if (0 == iRet) {
                     vResult = "停止录像成功！";
                 } else {
                     vResult = "停止录像失败！[" + iRet + "]";
                 }
             }
             return vResult;
         }

    </script>
</head>
<body>
    <form id="form1" runat="server">
       <div id="divPlugin1" style="width:500px;height:281px"></div>
    </form>
</body>
</html>
