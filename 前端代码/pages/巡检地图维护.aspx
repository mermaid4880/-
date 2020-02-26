<%@ Page Language="C#" AutoEventWireup="true" CodeFile="巡检地图维护.aspx.cs" Inherits="pages_巡检地图维护" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title>巡检地图维护</title>
      
    <script src="../js/jquery-1.8.3.min.js" type="text/javascript"></script>
    <link href="../js/layui/css/layui.css" rel="stylesheet" type="text/css" />
    <script src="../js/layer/layer.js" type="text/javascript"></script>
    <script src="../js/layui-v2.4.3/layui/layui.js" type="text/javascript"></script>

    <script src="../js/layui/layui.js" type="text/javascript"></script>
    <script>
        //  
        var public_token = "<%=public_token %>";

        //$.ajax({
        //        type: "get",
        //        url: "../handler/InterFace.ashx",
        //        data: {
        //            method: "http_getMethod"
        //           , token: public_token
        //            , MethodUrl: "/robots/map/192.168.0.1"
        //        },
        //        dataType: "json",
        //        success: function (data) {
        //            //处理返回值
        //            console.log(data);
        //            //地图 地址 
        //            mapImageURL = data.mapImageURL;
        //            //机器人地址
        //            robotImageURL = data.robotImageURL
        //            //机器人坐标
        //            robotX = data.robotX;
        //            robotY = data.robotY;
        //            //机器人旋转角度
        //            angle = data.angle;
        //            //行进路线 以及 已完成的路线
        //            taskPoints = data.taskPoints;
        //        }
        //     });
        
    </script>
</head>
<body>
    <form id="form1" runat="server">
        <div style="text-align: center;width:1900px;">
            <canvas id="mycanvas" width="300"  height="300"  style="border: 1px #000000  solid;margin:100px auto  100px  auto ;">
                你的浏览器不支持h5
            </canvas>
        </div>
    </form>
</body>
    <script src="../js/plotting.js"></script>
</html>
