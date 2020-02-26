<%@ Page Language="C#" AutoEventWireup="true" CodeFile="机器人管理.aspx.cs" Inherits="pages_机器人管理" %>


<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title>机器人管理</title>
    <link href="../lib/ligerUI/skins/Aqua/css/ligerui-all.css" rel="stylesheet" type="text/css" />
    <link href="../lib/ligerUI/skins/Gray2014/css/all.css" rel="stylesheet" type="text/css" />
    <script src="../js/jquery-1.8.3.min.js" type="text/javascript"></script>
    <script src="../lib/ligerUI/js/core/base.js" type="text/javascript"></script>

    <link href="../js/layui/css/layui.css" rel="stylesheet" type="text/css" />
    <script src="../js/layer/layer.js" type="text/javascript"></script>

    <script src="../lib/ligerUI/js/plugins/ligerLayout.js" type="text/javascript"></script>
    <script src="../lib/ligerUI/js/plugins/ligerGrid.js" type="text/javascript"></script>
    <script src="../lib/ligerUI/js/ligerui.min.js"></script>
    <script src="机器人管理.js" type="text/javascript"></script>
    
    <style type="text/css">
        body {
            padding: 0px;
            margin: 10px;
        }

        #layout1 {
            width: 100%;
            margin: 40px;
            height: 200px;
            margin: 0;
            padding: 0;
        }

        #accordion1 {
            height: 270px;
        }

        h4 {
            margin: 20px;
        }

        #divHead p {
            height: 30px;
        }

        .topmanage .list {
            display: inline-block;
            width: 200px;
            float: left;
        }

        .l-tab-links li a {
            color: #000 !important;
        }

        .l-tab-links li.l-selected {
            border: 1px solid RGBA(68,167,165,1) !important;
        }

        .l-tab-links li {
            border: 1px solid RGBA(68,167,165,1) !important;
        }

        canvas {
         cursor:pointer;
        }
        .list {
            width:200px;
            text-align:left;
            display:inline-block;
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
        .l-bar-selectpagesize{
            display:none !important;
        }

        #canvasBox{
            position: relative;
        }
        #mycanvas{
            position: absolute;
            top: 2px;
            left: 22px;
            z-index: 10;
            
        }
        #mycanvas1{
            position: absolute;
            top: 2px;
            left: 22px;
            z-index: 99;
            
        }
    </style>

    <script type="text/javascript">

        var intTabPage = 1;
        var public_token = "<%=public_token %>";
        var maingrid1 = null, maingrid2 = null, maingrid3 = null;
        var bodyHeight = document.documentElement.clientHeight; //页面高度
        var Public_isSelectedRoot = 0;//是否成功选择了机器人
        var public_lunxunSeconds = "<%=public_lunxunSeconds%>";//轮询的秒数.
        var public_robotIp = "";
        var rootArray = [];//装载机器人数组 [{"robotName":"室外巡检机器人","robotIP":"192.168.0.88","flirIP":"192.168.0.65","vlip":"192.168.0.64"}] 
        $(function () {
            //任务情况
            //开启轮询
            window.setInterval(function () {
                if (Public_isSelectedRoot == 1) {
                    load_xunjianrenwu(public_robotIp);//这是上面的巡检任务
                    if (intTabPage == 1) {
                        getdb1();
                    }
                    else if (intTabPage == 2) {
                        getdb2();
                    }
                    else if (intTabPage == 3) {
                        getdb3();
                    }
                }
            }, parseInt(public_lunxunSeconds));

            //$("#frameWebVideo1").attr("src", "../webVideo/webVideo1.aspx");
            //$("#frameWebVideo2").attr("src", "../webVideo/webVideo2.aspx");

            //装载机器人ip
            $.ajax({
                type: "get",
                url: "../handler/InterFace.ashx?r=" + Math.random(),
                data: {
                    method: "http_getMethod"
                    , token: public_token
                    , MethodUrl: "/robots"
                },
                dataType: "json",
                success: function (data) {
                    if (data.success != true) {
                        layer.msg(data.detail);
                        return;
                    }
                    data = data.data;
                    //处理返回值
                    if (data) {
                        //装载起来 [{"robotName":"室外巡检机器人","robotIP":"192.168.0.88","flirIP":"192.168.0.65","vlip":"192.168.0.64"}] 
                        if (data.length > 0) {
                            rootArray = data;//这里定义一下变量
                            var optionstring = "";
                            var firstJson = {};//第一个为默认机器人
                            for (var i = 0; i < data.length; i++) {
                                if (i == 0) {
                                    firstJson = data[i];
                                    optionstring += "<option value=\"" + data[i].robotIP + "\" >" + data[i].robotName + "</option>";
                                }
                                else {
                                    optionstring += "<option value=\"" + data[i].robotIP + "\" >" + data[i].robotName + "</option>";
                                }
                            }
                            $("#robot").html(optionstring); //获得要赋值的select的id，进行赋值  
                         
                            //这里进行 选择机器人
                            selectedRoot(firstJson.robotIP);
                            //这里连接视频
                            connectRootView(firstJson);
                            Public_isSelectedRoot = 1;//默认选择了机器人
                            public_robotIp = firstJson.robotIP;

                            //通过h5传值
                            localStorage.setItem("robotIp", firstJson.robotIP);
                            localStorage.setItem("flirIP", firstJson.flirIP);
                            localStorage.setItem("vlip", firstJson.vlip);
                        }
                    }
                }
            });

            //绑定机器人下拉框事件
            $("#robot").on("change", function () {
                var selectValue = $(this).val();
                alert(selectValue);
                if (selectValue) {

                    for (var i = 0; i < rootArray.length; i++) {
                        if (rootArray[i].robotIP == selectValue) {

                            //这里进行 选择机器人
                            selectedRoot(rootArray[i].robotIP);
                            public_robotIp = rootArray[i].robotIP;
                            //这里连接视频
                            connectRootView(rootArray[i]);

                            //通过h5传值
                            localStorage.setItem("robotIp", rootArray[i].robotIP);
                            localStorage.setItem("flirIP", rootArray[i].flirIp);
                            localStorage.setItem("vlip", rootArray[i].vlip);
                            break;
                        }
                    }
                }
            });

            maingrid1 = $("#maingrid1").ligerGrid({
                columns: [
                    { display: '识别时间', name: 'time', width: 300 },
                    { display: '点位名称', name: 'meterName', width: 548 },
                    { display: '识别类型', name: 'detectionType', width: 350 },
                    { display: '识别结果', name: 'detectionValue', width: 350 },
                    { display: '告警等级', name: 'detectionStatus', width: 300 }
                ]
                , pageSize: 5
                , pageSizeOptions: [5, 10, 20, 30, 50]
                , width: '100%'
                , height: 206
            });

            maingrid2 = $("#maingrid2").ligerGrid({
                columns: [
                    { display: '识别时间', name: 'time', width: 300 },
                    { display: '点位名称', name: 'meterName', width: 548 },
                    { display: '识别类型', name: 'detectionType', width: 350 },
                    { display: '识别结果', name: 'detectionValue', width: 350 },
                    { display: '告警等级', name: 'detectionStatus', width: 300 }
                ]
                , pageSize: 5
                , pageSizeOptions: [5, 10, 20, 30, 50]
                , width: '100%'
                , height: 206
            });

            maingrid3 = $("#maingrid3").ligerGrid({
                columns: [
                    { display: '报警时间', name: '', width: '400px' },
                    { display: '报警类型', name: '', width: '400px' },
                    { display: '报警内容', name: '', width: '950px' }

                ]
                , pageSize: 5
                , pageSizeOptions: [5, 10, 20, 30, 50]
                , width: '100%'
                , height: 206
            });
            console.log(bodyHeight);

            $("#layout1").ligerLayout({
                height: 930,
                rightWidth: 500,
                heightDiff: -80,
                allowRightCollapse: false,
                allowRightResize: false,
                bottomHeight: 240
            });
            $("#navtab1").ligerTab({
                onBeforeSelectTabItem: function (tabid) {

                },
                onAfterSelectTabItem: function (tabid) {
                    if (tabid === 'tabitem1') {
                        //
                        getdb1();
                        intTabPage = 1;
                    }
                    else if (tabid === 'tabitem2') {
                        //取数据
                        getdb2();
                        intTabPage = 2;
                    }
                    else if (tabid === 'tabitem3') {
                        //取数据
                        getdb3();
                        intTabPage = 3;
                    }
                }
            })
            //默认主动加载实时信息数据
            getdb1();
            //$("#divCamera").show();
        });
        //[{"robotName":"室外巡检机器人","robotIP":"192.168.0.88","flirIP":"192.168.0.65","vlip":"192.168.0.64"}]

        function setCookie(name, value)
        {
            var Days = 30; //此 cookie 将被保存 30 天
            var exp = new Date();
            exp.setTime(exp.getTime() + Days * 24 * 60 * 60 * 1000);
            document.cookie = name + "=" + escape(value) + ";expires=" + exp.toGMTString();
            //location.href = "机器人遥控.aspx";//接收页面.
        }

        
        

    </script>

</head>
<body >

    <form id="form1" runat="server">
        <div id="layout1">
            <div position="center" >
                <div style="height: 550px; width: 100%;">
                    <div style="height: 120px; width: 100%;background-color:RGB(212,236,234); padding: 10px;">
                        <p style="margin:10px">
                            机器人：<select id="robot" style="font-size:12px;height:20px" > </select>&nbsp;&nbsp;&nbsp;<span class="list">巡检任务名称：<span id="taskName">空闲</span></span>
                        </p>
                        <p style="margin:10px">

                            <span class="list" style="width:450px">巡检节点总数：<span id="totalDeviceNum"></span> </span>
                            <span class="list" style="width:450px">异常巡检点数：<span id="warningDevcieNum"></span> </span>
                            <span class="list" style="width:450px">当前巡检点：<span id="CurDeviceNum"></span></span>
                        </p>

                        <p style="margin:10px">

                            <span class="list" style="width:450px">预计巡检时间：<span id="ExpWasteTime"></span></span>
                            <span class="list" style="width:450px">巡检进度：<span id="percent"></span></span>
                            <span class="list" style="width:450px">已巡检点数：<span id="doneDeviceNum"></span></span>
                        </p>
                    </div>
                    
                    <h1 style="display:none"></h1>
                    <input  type="button" id="but"  class="off" value="点我画图" style="width: 100px;height: 100px;background-color: #00a0e9;display:none"/>
                    <input type="button"  id="but1" onclick="but1()" class="off"  style="width: 100px;height: 100px;background-color: #00a0e9;display:none" value="点我复位"/>
                    <div id="myText" style="display:none"></div>
                    
                    <!--这里是图片识别-->
                    <div style="height: 200px; width: 100%;  padding-top: 20px;text-align:center;display:block;line-height:400px">
                        
                        <div id="canvasBox">
                            <canvas id="mycanvas"></canvas>
                            <canvas id="mycanvas1"></canvas>
                        </div>
                    </div>
                </div>
            </div>
            <div position="right" title="视频实时监控" >

                <div id="divCamera" class="camera" style="width:100%;height:592px" >
                    <div id="webvidio1" >
                        <iframe frameborder="0" style="width:500px;height:281px;overflow:hidden;z-index:10"  name="frameWebVideo1" id="frameWebVideo1" src="kong.htm"></iframe>
                    </div>
                    <div id="webvidio2" >
                       <iframe frameborder="0" style="width:500px;height:281px;overflow:hidden;;z-index:10" name="frameWebVideo2" id="frameWebVideo2" src="kong.htm"></iframe>
                    </div>

                </div>

            </div>

            <div position="bottom" style="height:500;">

                <div id="navtab1" style="width: 100%;background-color: RGB(212,236,234); color: #000;" >
                    <div title="实时信息">
                        <div id="info">
                            <div id="maingrid1" style="margin: 0; padding: 0"></div>
                        </div>
                    </div>
                    <div title="设备告警信息">
                        <div id="warninfo">
                            <div id="maingrid2" style="margin: 0; padding: 0"></div>
                        </div>
                    </div>
                    <div title="系统告警信息">
                        <div id="syswarninfo">
                            <div id="maingrid3" style="margin: 0; padding: 0"></div>
                        </div>
                    </div>
                </div>
            </div>


        </div>
    </form>
    <div id ="menu" tabindex="-1">
        <input  class="menu_button" type="button" value="初始定位"  onclick="chushidingwei();"/>
        <input  class="menu_button" type="button" value="一键返航"  onclick="yijianfanhang();"/>
        <input  class="menu_button" type="button" value="暂停任务"  onclick="zhantingfuwu();"/>
        <input  class="menu_button" type="button" value="取消任务"  onclick="quxiaorenwu();"/>
        <input  class="menu_button" type="button" value="导出地图"  onclick="daochuditu();"/>
        <input  class="menu_button" type="button" value="取消选择"  onclick="javascript: $('#menu').css('display', 'none'); "/>      
    </div>
</body>
<script src="../js/plotting.js"></script>
<script src="机器人管理.js"></script>

</html>


