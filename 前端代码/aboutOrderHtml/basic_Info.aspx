<%@ Page Language="C#" AutoEventWireup="true" CodeFile="basic_Info.aspx.cs" Inherits="aboutOrderHtml_basic_Info" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta charset="utf-8">
    <title>layui</title>
    <meta name="renderer" content="webkit">
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1">
    <link rel="stylesheet" href="../plugins/layui/css/layui.css"  media="all">
    <script src="../plugins/layui/layui.js" type="text/javascript"></script>
    <script src="../js/jquery-1.8.3.min.js" type="text/javascript"></script>
    <script src="../js/json2.js" type="text/javascript"></script>
    <script src="../js/basicJs.js" type="text/javascript"></script>
<style>
        .input1
        {
            background:#05577D;
            color:#B2DFEE;
            }
</style>
<script>
    $(function () {
        $("#Old_Pwd").val(1+"个");

    })
</script>
</head>


<script>
    <%=height %>
    var height =height;
   var main =document.getElementById("main");
   main.style.height =height;
</script>
<body>
    <form id="form1" runat="server">
       
    <div id="main" style="width:100%;height:300px;"  class="layui-form" >
     <div class="layui-btn-group"></div>
         <div class="layui-form-item" style="margin-top:30px">
                <label class="layui-form-label"style="width:100px">当前阀体个数：</label>
                <div class="layui-input-block">
                  <input type="text" name="Old_Pwd" id="Old_Pwd"   lay-verify="required" style="width: 250px;border:0;background:#05577D;" placeholder="请输入原密码" autocomplete="off" class="layui-input">
                </div>
          </div>
            <div class="layui-form-item">
                <label class="layui-form-label"style="width:100px"> 在线个数：</label>
                <div class="layui-input-block ">
                  <input type="password" name="New_Pwd" id="New_Pwd"    lay-verify="required" style="width: 250px;";font-color:"green";" placeholder="请输入新密码" autocomplete="off" class="layui-input">
                </div>
          </div>
            <div class="layui-form-item">
                <label class="layui-form-label"style="width:100px">供水平均温度：</label>
                <div class="layui-input-block">
                  <input type="password" name="Old_Pwd" id="Password1"   lay-verify="required" style="width: 250px;" placeholder="请输入原密码" autocomplete="off" class="layui-input">
                </div>
          </div>
            <div class="layui-form-item">
                <label class="layui-form-label"style="width:100px"> 回水平局温度：</label>
                <div class="layui-input-block">
                  <input type="password" name="New_Pwd" id="Password2"  lay-verify="required" style="width: 250px;";font-color:"green";" placeholder="请输入新密码" autocomplete="off" class="layui-input">
                </div>
            </div>
        
    </div>
    </form>
</body>
</html>
