<%@ Page Language="C#" AutoEventWireup="true" CodeFile="地图选点.aspx.cs" Inherits="pages_地图选点" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title>主接线展示</title>
    <link href="../js/layui/css/layui.css" rel="stylesheet" type="text/css" />
    <script src="../js/layer/layer.js" type="text/javascript"></script>
    <script src="../js/layui/layui.js" type="text/javascript"></script>
    <script src="../js/jquery-1.8.3.min.js" type="text/javascript"></script>
    <script>
        var public_token = "<%=public_token %>";
    </script>
</head>
<body>
    <form id="form1" runat="server">
        <div>
             <div class="layui-form-item" >
                    <div class="layui-form-item" style="padding-top: 10px;">

                        
                        <div class="layui-input-inline" style="margin-left:10px;">
                            <input type="text" class="layui-input" id="txtPhoneNum" placeholder="请输入间隔名称" >
                        </div>
                       
                        <div class="layui-input-inline" style="width: 80px">
                            <input type="button" class="layui-btn"  value="查询" onclick="searchDB()">
                        </div>
                                           

                    </div>
                </div>
            
        </div>
        <div style="padding:10px 100px 0px 100px;margin:10px 0 10px 0; height:700px;" >
            <img src="../images/主接线展示.jpg" style="height:700px;width:97%" />
        </div>
    </form>
</body>
</html>
