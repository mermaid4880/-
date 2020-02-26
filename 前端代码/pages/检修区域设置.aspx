<%@ Page Language="C#" AutoEventWireup="true" CodeFile="检修区域设置.aspx.cs" Inherits="pages_检修区域设置" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title>检修区域设置</title>
    <link href="../lib/ligerUI/skins/Aqua/css/ligerui-all.css" rel="stylesheet" type="text/css" />
    <link href="../lib/ligerUI/skins/Gray2014/css/all.css" rel="stylesheet" type="text/css" />
    <script src="../js/jquery-1.8.3.min.js" type="text/javascript"></script>
    <script src="../lib/ligerUI/js/core/base.js" type="text/javascript"></script>

    <link href="../js/layui/css/layui.css" rel="stylesheet" type="text/css" />
    <script src="../js/layer/layer.js" type="text/javascript"></script>
    <script src="../js/layui/layui.js"></script>

    <script src="../lib/ligerUI/js/plugins/ligerLayout.js" type="text/javascript"></script>
    <script src="../lib/ligerUI/js/plugins/ligerGrid.js" type="text/javascript"></script>
    <script src="../lib/ligerUI/js/ligerui.min.js"></script>
    <script>
        //阻止浏览器默认右键点击事件
        $("canvas").bind("contextmenu", function (e) {
            return false;
        });
    </script>

    <script language="javascript" id="clientEventHandlersJS"> 
        function document_oncontextmenu() { 
        return false; 
        } 
    </script> 

    <script language="javascript" event="oncontextmenu" for="document"> 
        return document_oncontextmenu() 
    </script>
    <style>

         canvas {
          cursor:pointer;
         }

         #menu {
            z-index:999;
            width:180px;
            height:150px;
            background-color:#ffffff;
            color:#808080;
            display:none;
            flex-direction:column;
            justify-content:space-between;
            position:fixed;
            top:0;
            left:0;
            border:1px #cccccc solid;
        }
        .menu_button{
            width:100%;height:20%;background-color:#ffffff;
        }
        .menu_button:hover {
          background-color: RGBA(68,167,165,1);
        }

        #closeD {
            z-index:999;
            width:130px;
           
            background-color:#ffffff;
            border:1px #cccccc solid;
            color:#808080;
            display:none;
            flex-direction:column;
            justify-content:space-around;
            align-items:center;
            position:fixed;
            top:0;
            left:0;
            border:1px #cccccc solid;
        }
        
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div>
             <h1 style="display:none"></h1>
             <input  type="button" id="but"  class="off" value="点我画图" style="width: 100px;height: 100px;background-color: #00a0e9;display:none"/>
             <input type="button"  id="but1" onclick="but1()" class="off"  style="width: 100px;height: 100px;background-color: #00a0e9;display:none" value="点我复位"/>
             <div id="myText" style="display:none"></div>
                    
             <!--这里是图片识别-->
             <div style="height: 200px; width: 100%;  padding-top: 20px;text-align:center;display:block;line-height:400px">                      
                 <div  id="mydiv" >
                      <canvas id="mycanvas" width="300"  height="300"  style="border: 1px #000000  solid"></canvas>
                 </div>
             </div>
        </div>
    </form>
    <div id ="menu" tabindex="-1">
        <input  class="menu_button" type="button" value="地图归位"  onclick="chushidingwei();"/>
        <input  class="menu_button" type="button" value="添加区域"  onclick="yijianfanhang();"/>
        <input  class="menu_button" type="button" value="删除区域"  onclick="zhantingfuwu();"/>
        <input  class="menu_button" type="button" value="清空区域"  onclick="quxiaorenwu();"/>
        <%--<input  class="menu_button" type="button" value="导出地图"  onclick="daochuditu();"/>--%>
        <input  class="menu_button" type="button" value="取消选择"  onclick="javascript: $('#menu').css('display', 'none'); huTu = false;window.location.reload(); "/>      
    </div>

    <%--弹出页面--%>
                <div id="divFormOpen" style="display:none;padding-top:20px"  class="layui-form" >

                    <div class="layui-form-item">
                        <label class="layui-form-label">区域名称</label>
                        <div class="layui-input-block" style="width: 200px;">
                          <input type="text" name="title" op="keyValue"  lay-verify="required" style="width: 200px;" placeholder="" autocomplete="off" class="layui-input">
                        </div>
                  </div>

                   <div class="layui-form-item">
                        <label class="layui-form-label">区域备注</label>
                        <div class="layui-input-block">
                          <input type="text" name="maxWd" op="keyValue"  lay-verify="required" style="width: 200px;" placeholder="" autocomplete="off" class="layui-input">
                        </div>
                  </div>

                  <div class="layui-form-item">
                        <label class="layui-form-label">区域功能</label>
                        <div class="layui-input-block">
                          <input type="text" name="minWd"  lay-verify="required" style="width: 200px;" placeholder="" autocomplete="off" class="layui-input">
                        </div>
                  </div>

                  <div class="layui-form-item" style ="display:none;">
                        <label class="layui-form-label">图形</label>
                        <div class="layui-input-block">
                          <input type="text" name="setType"  lay-verify="required" style="width: 200px;" placeholder="" autocomplete="off" class="layui-input">
                        </div>
                  </div>

                  <div class="layui-form-item" style ="display:none;">
                        <label class="layui-form-label">开始x坐标</label>
                        <div class="layui-input-block">
                          <input type="text" name="begin_x"  lay-verify="required" style="width: 200px;" placeholder="" autocomplete="off" class="layui-input">
                        </div>
                  </div>

                   <div class="layui-form-item" style ="display:none;">
                        <label class="layui-form-label">开始y坐标</label>
                        <div class="layui-input-block">
                          <input type="text" name="begin_y"  lay-verify="required" style="width: 200px;" placeholder="" autocomplete="off" class="layui-input">
                        </div>
                  </div>
           
                    <div class="layui-form-item" style ="display:none;">
                        <label class="layui-form-label">结束x坐标</label>
                        <div class="layui-input-block">
                          <input type="text" name="end_x"  lay-verify="required" style="width: 200px;" placeholder="" autocomplete="off" class="layui-input">
                        </div>
                  </div>

                   <div class="layui-form-item" style ="display:none;">
                        <label class="layui-form-label">结束y坐标</label>
                        <div class="layui-input-block">
                          <input type="text" name="end_y"  lay-verify="required" style="width: 200px;" placeholder="" autocomplete="off" class="layui-input">
                        </div>
                  </div>
                    
                  <div class="layui-form-item" style ="display:none;">
                        <label class="layui-form-label">设备别id</label>
                        <div class="layui-input-block">
                          <input type="text" name="deviceId"  lay-verify="required" style="width: 200px;" placeholder="" autocomplete="off" class="layui-input">
                        </div>
                  </div>
        
                </div> 
                <div id ="closeD" style ="display:none;">
                    <ul>

                    </ul>
                </div>
</body>
    <script src="../js/plotting_1.js"></script>
</html>
