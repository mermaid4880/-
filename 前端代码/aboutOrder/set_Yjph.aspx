<%@ Page Language="C#" AutoEventWireup="true" CodeFile="set_Yjph.aspx.cs" Inherits="aboutOrder_set_Yjph" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
  <meta name="renderer" content="webkit">
  <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
  <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1">
  <link href="../plugins/layui/css/layui.css" rel="stylesheet" type="text/css" />
<style>
      body
    {
        background-color:#242F45;
        }
    .showBox
    {
        margin:0px;
        height:100px;
        line-height:100px;
        text-align:center;
        }
   
   .showBox2
    {
        margin:0px;
        height:120px;
        line-height:120px;
        text-align:center;
        }
    
    .marginSet
    {
        margin:5px;
        height:320px;
        background-color:#05577D;
        }
    
     .setHeight300
    {
        height:100px;
        line-height:100px;
        margin:5px;
        }
   .setHeight350
    {
        height:120px;
        line-height:120px;
        margin:5px;
        }
        
    .boxRedColor
    {
        background-color:Red;
        } 
</style>
<script>
    function changeFrameHeight() {
        var vPageHeight = document.documentElement.clientHeight;
        vPageHeight = vPageHeight - 50;
        vPageHeight = vPageHeight / 2;
        vPageHeight = vPageHeight + "px";
        alert(vPageHeight)
        var div1 = document.getElementById("div1");
        var div2 = document.getElementById("div2");
        var iframe1 = document.getElementById("iframe1");
        var iframe2 = document.getElementById("iframe2");
        var iframe3 = document.getElementById("iframe3");
        var iframe4 = document.getElementById("iframe4");


        div1.style.height = vPageHeight;
        div2.style.height = vPageHeight;
        iframe1.style.height = vPageHeight;
        iframe2.style.height = vPageHeight;
        iframe3.style.height = vPageHeight;
        iframe4.style.height = vPageHeight;
        iframe1.src = "../aboutOrderHtml/basic_Info.aspx?height"+vPageHeight;
       
    }

</script>
</head>

<body onload="changeFrameHeight()">
    <div class="layui-row setHeight350" id="div1">
    <div class="layui-col-xs6 showBox">
      <div class="grid-demo grid-demo-bg1 marginSet" >
        <iframe id="iframe1"  scrolling="no" marginwidth="0" marginheight="0" frameborder="0"  src="../echarts/firstPage/kong.html"></iframe>
      </div>
    </div>
    <div class="layui-col-xs6 showBox">
      <div class="grid-demo marginSet">
        <iframe id="iframe2" style="height:300px;width:100%;" scrolling="no" marginwidth="0" marginheight="0" frameborder="0"  src="echarts/firstPage/kong.html"></iframe>
      </div>
    </div>
  </div>
    <div class="layui-row setHeight350" id="div2">
    <div class="layui-col-xs6 showBox2">
      <div class="grid-demo grid-demo-bg1 marginSet">
         <iframe id="iframe3" style="height:320px;width:100%;" scrolling="no" marginwidth="0" marginheight="0" frameborder="0"  src="echarts/firstPage/kong.html"></iframe>
      </div>
    </div>
    <div class="layui-col-xs6 showBox2">
      <div class="grid-demo marginSet">
         <iframe id="iframe4" style="height:320px;width:100%;" scrolling="no" marginwidth="0" marginheight="0" frameborder="0"  src="echarts/firstPage/kong.html"></iframe>
        <!-- <iframe id="iframe6" style="height:320px;width:100%;" scrolling="no" marginwidth="0" marginheight="0" frameborder="0"  src="echarts/firstPage/曲线2.aspx" ></iframe>-->
      </div>
    </div>
  </div> 
</body>
</html>
