<%@ Page Language="C#" AutoEventWireup="true" CodeFile="机器人遥控.aspx.cs" Inherits="pages_机器人遥控" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">


<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title>机器人遥控</title>
    <link href="../lib/ligerUI/skins/Aqua/css/ligerui-all.css" rel="stylesheet" type="text/css" />
    <link href="../lib/ligerUI/skins/Gray2014/css/all.css" rel="stylesheet" type="text/css" />
    <script src="../js/jquery-1.8.3.min.js" type="text/javascript"></script>
    <script src="../lib/ligerUI/js/core/base.js" type="text/javascript"></script>

    <link href="../js/layui/css/layui.css" rel="stylesheet" type="text/css" />
    <script src="../js/layer/layer.js" type="text/javascript"></script>

    <script src="../lib/ligerUI/js/plugins/ligerLayout.js" type="text/javascript"></script>
    <script src="../lib/ligerUI/js/plugins/ligerGrid.js" type="text/javascript"></script>
    <script src="../lib/ligerUI/js/ligerui.min.js"></script>
    <script src="机器人遥控.js" type="text/javascript"></script>

    <style type="text/css">
        body {
            padding: 10px;
            margin: 0;
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
            width: 33%;
            float: left;
        }
            .l-tab-links li a {
                color: #000 !important;
            }

        canvas {
         cursor:pointer;
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
    </style>

    <script type="text/javascript">
        var intTabPage = 1;
        var public_token = "<%=public_token %>";
        //var robotIp = "";
        //var flirIp = "";
        //var vlip = "";
        var maingrid1 = null, maingrid2 = null, maingrid3 = null;
        var bodyHeight = document.documentElement.clientHeight; //页面高度
        var Public_isSelectedRoot = 0;//是否成功选择了机器人
        var public_lunxunSeconds = "<%=public_lunxunSeconds%>";//轮询的秒数

        $(function () {
            robotIp = localStorage.getItem("robotIp");
            flirIP = localStorage.getItem("flirIP");
            vlip = localStorage.getItem("vlip");

            var url1 = "../webVideo/webVideo1.aspx?ip=" + vlip;
            document.getElementById("frameWebVideo1").src = url1;

            var url2 = "../webVideo/webVideo2.aspx?ip=" + flirIP;
            document.getElementById("frameWebVideo2").src = url2;

            //因为首页必然选定，所以直接赋值vlip,flirIP
            Public_isSelectedRoot = 1;
            //开启轮询
            window.setInterval(function () {
                if (Public_isSelectedRoot == 1) {
                    load_xunjianrenwu(robotIp);//这是上面的巡检任务
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


            get_root_module();
            $(".topmanage").width(($(document).width() - 500) + "px");
            


            maingrid1 = $("#maingrid1").ligerGrid({
                columns: [
                    { display: '识别时间', name: 'time', width: 200 },
                    { display: '点位名称', name: 'meterName', width: 400 },
                    { display: '识别类型', name: 'detectionType', width: 200 },
                    { display: '识别结果', name: 'detectionValue', width: 200 },
                    { display: '告警等级', name: 'detectionStatus', width: 200 }
                ]
                , pageSize: 5
                , pageSizeOptions: [5, 10, 20, 30, 50]
                , width: '100%'
                , height: 206
            });
            maingrid2 = $("#maingrid2").ligerGrid({
                columns: [
                    { display: '识别时间', name: 'time', width: 200 },
                    { display: '点位名称', name: 'meterName', width: 400 },
                    { display: '识别类型', name: 'detectionType', width: 200 },
                    { display: '识别结果', name: 'detectionValue', width: 200 },
                    { display: '告警等级', name: 'detectionStatus', width: 200 }
                ]
                , pageSize: 5
                , pageSizeOptions: [5, 10, 20, 30, 50]
                , width: '100%'
                , height: 206
            });
            maingrid3 = $("#maingrid3").ligerGrid({
                columns: [
                    { display: '报警时间', name: '', width: 300},
                    { display: '报警类型', name: '', width: 300 },
                    { display: '报警内容', name: '', width: 600 }
                ]
                , pageSize: 5
                , pageSizeOptions: [5, 10, 20, 30, 50]
                , width: '100%'
                , height: 206
            });
            //$("#layout1").ligerLayout({ topHeight: bodyHeight - 340, centerHeight: 360 });
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

            //这里定义 设置模式
            $("img[name='img_task']").on("click", function () {

                //alert(11);
                var clickData = $(this).attr("data");
                var url = "";
                if (clickData == "task") {
                    url = "/robotMode/task";
                }
                else if (clickData == "location") {
                    url = "/robotMode/location";
                }
                else if (clickData == "backEndControl") {
                    url = "/robotMode/backEndControl";
                }
                else if (clickData == "handControl") {
                    url = "/robotMode/handControl";
                }
                $.ajax({
                    type: "post",
                    url: "../handler/InterFace.ashx?r=" + Math.random(),
                    data: {
                        method: "http_PostMethod"
                        , token: public_token
                        , MethodUrl: url
                        , postData: ""
                    },
                    dataType: "json",
                    success: function (data) {

                        //{success:"true","detail": "xxx"}
                        if (data) {
                            if (data.success == true) {
                                layer.msg("设置成功!");
                                rootModuel(clickData);
                            }
                            else {
                                layer.error("设置成功!");
                            }
                        }
                    }
                });
            })
            //对视频的操作 比如录拍等
            $(".img_vidio").click(function () {
                var clickData = $(this).attr("data");
                layer.msg(clickData);
                if (clickData) {
                    //这里激发视频方法
                    var webvideo1 = frameWebVideo1.window.videoMethod(clickData);
                    layer.msg("[" + clickData + "操作]结果：摄像头1:[" + webvideo1 + "]");

                    var webvideo2 = frameWebVideo2.window.videoMethod(clickData);
                    layer.msg("[" + clickData + "操作]结果：摄像头2:[" + webvideo2 + "]");
                }
            })

            //雨刷 照明  对焦
            $(".img_vidio_1").click(function () {
                var clickData = $(this).attr("data");
                var oldSrc = $(this).attr("src");
                var operation = "";
                //雨刷
                if (clickData == "雨刷") {
                    //layer.msg(clickData);
                    if (oldSrc.indexOf("1") != -1) {
                        //关闭状态
                        $(this).attr("src", "../images/control/jqrkz2.png");
                        operation = "ptz/wiperOn";
                    } else {
                        //开启状态
                        $(this).attr("src", "../images/control/jqrkz1.png");
                        operation = "ptz/wiperOff";
                    }
                }
                //照明
                if (clickData == "照明") {
                    //layer.msg(clickData);
                    if (oldSrc.indexOf("1") != -1) {
                        //关闭状态
                        $(this).attr("src", "../images/control/lx2.png");
                        operation = "ptz/headlampOn";
                    } else {
                        //开启状态
                        $(this).attr("src", "../images/control/lx1.png");
                        operation = "ptz/headlampOff";
                    }
                }
                //红外
                if (clickData == "红外") {
                    //layer.msg(clickData);                  
                        operation = "ir/focus";
                }

                //下面的是发送请求
                $.ajax({
                        type: "post",
                        url: "../handler/InterFace.ashx?r=" + Math.random(),
                        data: {
                            method: "http_PostMethod"
                            , token: public_token
                            , MethodUrl: "/control/" + operation
                            , postData: ""
                        },
                        dataType: "json",
                        success: function (data) {
                            
                            if (data) {
                                if (data.success == "true") {
                                    layer.msg("操作成功");
                                }
                                else {
                                    layer.msg("操作失败");
                                }
                            }
                        }
                    });
               
            })


        })//这是 装载函数完成
        //得到雷达信息
        function get_leida() {
            $.ajax({
                type: "post",
                url: "../handler/InterFace.ashx?r=" + Math.random(),
                data: {
                    method: "http_getMethod"
                    , token: public_token
                    , MethodUrl: "/laser/data"
                },
                dataType: "json",
                success: function (data) {
                    //获得雷达信息
                    alert(data);
                }
            });
        }
        //机器人模式--获取现在模式
        function get_root_module() {
            $.ajax({
                type: "get",
                url: "../handler/InterFace.ashx?r=" + Math.random(),
                data: {
                    method: "http_getMethod"
                    , token: public_token
                    , MethodUrl: "/robotMode/now"
                },
                dataType: "json",
                success: function (data) {
                    if (data.data) {
                        rootModuel(data.data);
                    }
                }
            });
        }
        //判断哪个按钮显示
        function rootModuel(rootResult) {
            if (rootResult == "task") {
                var vImageObj = $("img[name='img_task']");
                $(vImageObj[0]).attr("src", "../images/control/rwms2.png");
                $(vImageObj[1]).attr("src", "../images/control/jjdwms1.png");
                $(vImageObj[2]).attr("src", "../images/control/htykms1.png");
                $(vImageObj[3]).attr("src", "../images/control/scykms1.png");
            }
            else if (rootResult == "location") {
                var vImageObj = $("img[name='img_task']");
                $(vImageObj[0]).attr("src", "../images/control/rwms1.png");
                $(vImageObj[1]).attr("src", "../images/control/jjdwms2.png");
                $(vImageObj[2]).attr("src", "../images/control/htykms1.png");
                $(vImageObj[3]).attr("src", "../images/control/scykms1.png");
            }
            else if (rootResult == "backEndControl") {
                var vImageObj = $("img[name='img_task']");
                $(vImageObj[0]).attr("src", "../images/control/rwms1.png");
                $(vImageObj[1]).attr("src", "../images/control/jjdwms1.png");
                $(vImageObj[2]).attr("src", "../images/control/htykms2.png");
                $(vImageObj[3]).attr("src", "../images/control/scykms1.png");
            }
            else if (rootResult == "handControl") {
                var vImageObj = $("img[name='img_task']");
                $(vImageObj[0]).attr("src", "../images/control/rwms1.png");
                $(vImageObj[1]).attr("src", "../images/control/jjdwms1.png");
                $(vImageObj[2]).attr("src", "../images/control/htykms1.png");
                $(vImageObj[3]).attr("src", "../images/control/scykms2.png");
            }
        }

        function getCookie(name)
        {
　　        var arr =document.cookie.match(new RegExp("(^|)"+name+"=([^;]*)(;|$)"));
            if (arr != null)
                returnunescape(arr[2]);
            //return null;
        }
    </script>
    <style>
        .explain {
          position:relative;
        }
    </style>
</head>
<body>

    <form id="form1" runat="server" >
        <div id="layout1">
          <div position="center">
                <div style="height: 550px; " class="topmanage">
                    <div style="height: 120px; width: 100%; background-color:RGB(212,236,234); padding: 10px;">
                        <div>
                                            
                        </div>
                        <div style="margin-top: 10px;">巡检任务名称：<span id="taskName">空闲</span></div>
                        <div style="margin-top: 10px;height:20px">
                            <div class="list">巡检节点总数：<span id="totalDeviceNum"></span> </div>
                            <div class="list">异常巡检点数：<span id="warningDevcieNum"></span> </div>
                            <div class="list">当前巡检点：<span id="CurDeviceNum"></span></div>
                        </div> 
                        <div style="margin-top: 10px;">
                            <div class="list">预计巡检时间：<span id="ExpWasteTime"></span> </div>
                            <div class="list">巡检进度：<span id="percent"></span> </div>
                            <div class="list">已巡检点数：<span id="doneDeviceNum"></span></div>
                        </div>
                    </div>

                    <h1 style="display:none"></h1>
                    <input  type="button" id="but"  class="off" value="点我画图" style="width: 100px;height: 100px;background-color: #00a0e9;display:none"/>
                    <input type="button"  id="but1" onclick="but1()" class="off"  style="width: 100px;height: 100px;background-color: #00a0e9;display:none" value="点我复位"/>
                    <div id="myText" style="display:none"></div>
                    
                    <!--这里是图片识别-->
                    <div style="height: 200px; width: 94%;  padding-top: 20px;display:block;line-height:400px">
                        
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

            <div position="bottom" style="height:500px;">
                <div id="navtab1" style="float: left;background-color:RGB(212,236,234); color: #000;">
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
                <div id="navtab2" style="width: 610px; float: right;">
                    <p style="padding: 10px 0px 10px 20px;background-color: RGB(212,236,234);">
                        <a href="javascript:;" class="explain" alt="雨刷" >
                            <img src="../images/control/jqrkz1.png" alt="拍照"  class="img_vidio_1"  data="雨刷" title="雨刷"/></a>
                        <a href="javascript:;" class="explain" alt="拍照" >
                            <img src="../images/control/zp1.png" alt="拍照" data="拍照" class="img_vidio"  title="拍照"/></a>
                        <a href="javascript:;" class="explain" alt="录像开始" >
                            <img src="../images/control/ly1.png" alt="录像开始" data="录像开始" class="img_vidio"  title="录像开始"/></a>
                        <a href="javascript:;" class="explain" alt="照明" >
                            <img src="../images/control/lx1.png" alt="拍照" data="照明" class="img_vidio_1"  title="照明""/></a>
                        <a href="javascript:;" style="margin-left: 10px;"   alt="任务模式" class="explain" data="任务模式">
                            <img src="../images/control/rwms2.png"   data="task"  name="img_task" /></a>
                        <a href="javascript:;" class="explain" alt="紧急定位模式">
                            <img src="../images/control/jjdwms1.png" data="location" name="img_task" /></a>
                    </p>
                    <p style="padding: 0px 0px 0px 20px;background-color: RGB(212,236,234);">
                        <a href="javascript:;" class="explain" alt="录音" >
                            <img src="../images/control/yydj1.png" data="录音" data="录音" class="img_vidio" title="录音" /></a>
                        <a href="javascript:;" class="explain" alt="红外" >
                            <img src="../images/control/ck1.png"  data="红外" class="img_vidio_1" title="红外" /></a>
                        <a href="javascript:;" class="explain" alt="录像结束" >
                            <img src="../images/control/hf1.png" alt="录像结束" data="录像结束" class="img_vidio"  title="录像结束"/></a>
                        <a href="javascript:;" class="explain" alt="拍照" >
                            <img src="../images/control/hf1.png"  data="录音结束" class="img_vidio"  title="录音结束"/></a>
                        <a href="javascript:;" style="margin-left: 10px;"  alt="后台遥控模式"  class="explain" data="后台遥控模式">
                            <img src="../images/control/htykms1.png"   data="backEndControl" name="img_task" /></a>
                        <a href="javascript:;" class="explain" alt="手持遥控模式">
                            <img src="../images/control/scykms1.png" data="handControl" name="img_task" /></a>
                    </p>
                    <div style=" height: 10px; line-height: 40px; background-color: RGB(212,236,234);"></div>
                    <div style="padding: 0px 40px 20px 40px; text-align: center; position: absolute;top:90px;">
                        <div style="width: 170px; float: left; text-align: center;position:relative;">
                            <%--<span style="display: inline-block; width: 170px; height: 10px; line-height: 40px; background-color: RGB(179,223,208);">雷达</span>--%>
                            <image src="../images/control/leida.png"></image>
                            <canvas id="myCanvas2" width="150" height="150" style="position:absolute;top:0;right:10px;">
                                你的浏览器不支持h5
                            </canvas>
                            
                        </div>
                        <div style="width: 170px; float: left; text-align: center; border-right: 1px solid #ccc; border-left: 1px solid #ccc;">
                            <%--<span style="display: inline-block; width: 170px; height: 10px; line-height: 40px; background-color: RGB(179,223,208);">车体控制</span>--%>
                            <img src="../images/control/cheti_00.png">
                            <a href="javascript:;" class="yuntai" data="operation=left&speed=200" id="move_left">
                                <img src="../images/control/cheti_a1.png" style="position: relative; top: -90px; left: -3px;" /></a>
                            <a href="javascript:;" class="yuntai" data="operation=right&speed=200" id="move_right">
                                <img src="../images/control/cheti_d1.png" style="position: relative; top: -90px; left: 45px;" /></a>
                            <a href="javascript:;"  class="yuntai" data="operation=ahead&speed=200" id="move_ahead">
                                <img src="../images/control/cheti_w1.png" style="position: relative; top: -140px; left: -46px;" /></a>
                            <a href="javascript:;" class="yuntai" data="operation=back&speed=200" id="move_back">
                                <img src="../images/control/cheti_s1.png" style="position: relative; top: -80px;" /></a>
                        </div>
                        <div style="width: 170px; float: left; text-align: center;">
                            <%--<span style="display: inline-block; width: 170px; height: 10px; line-height: 40px; background-color: RGB(179,223,208);">云台控制</span>--%>
                            <img src="../images/control/yuntai_00.png" />
                            <a href="javascript:;" class="yuntai explain" data="ptz/up"   alt="上">
                                <img src="../images/control/yuntai_shang1.png" style="position: relative; top: -142px; left: 72px;" /></a>
                            <a href="javascript:;" class="yuntai explain" data="ptz/right"  alt="右">
                                <img src="../images/control/yuntai_you1.png" style="position: relative; top: -91px; left: 90px;" /></a>
                            <a href="javascript:;" class="yuntai explain" data="ptz/down"   alt="下">
                                <img src="../images/control/yuntai_xia1.png" style="position: relative; top: -40px; left: 13px;" /></a>
                            <a href="javascript:;" class="yuntai explain" data="ptz/left"  alt="左" >
                                <img src="../images/control/yuntai_zuo1.png" style="position: relative; top: -91px; left: -70px;" /></a>
                            <a href="javascript:;" class="yuntai" data="vl/zoom/in"  >
                                <img src="../images/control/yuntai_bianbei1.png" style="position: relative; top: -107px; left: -57px;" /></a>
                            <a href="javascript:;" class="yuntai" data="vl/zoom/out"  >
                                <img src="../images/control/yuntai_bianbei-1.png" style="position: relative; top: -107px; left: -60px;" /></a>
                            <a href="javascript:;" class="yuntai" data="vl/focus/out"  >
                                <img src="../images/control/yuntai_-1.png" style="position: relative; top: -111px; left: 27px;" /></a>
                            <a href="javascript:;" class="yuntai" data="vl/focus/in"  >
                                <img src="../images/control/yuntai_1.png" style="position: relative; top: -111px; left: -28px;" /></a>
                        </div>
                    </div>
                </div>
            </div>


            <script>
                $("#navtab1").css({ "width": ($(document).width() - 632) + "px" });

                //云台上 下 左 右 停 云台雨刷开 关 红外对焦		 变倍加减停		 都用这一个方法

                $(".yuntai").mousedown(function () {
                    var operation = $(this).attr("data");
                    $.ajax({
                        type: "post",
                        url: "../handler/InterFace.ashx?r=" + Math.random(),
                        data: {
                            method: "http_PostMethod"
                            , token: public_token
                            , MethodUrl: "/control/" + operation
                            , postData: ""
                        },
                        dataType: "json",
                        success: function (data) {
                            
                            if (data) {
                                if (data.success == "true") {
                                    layer.msg("操作成功");
                                }
                                else {
                                    layer.msg("操作失败");
                                }
                            }
                        }
                    });
                });

                //云台停止  相机停止
                $(".yuntai").mouseup(function () {
                    var operation = $(this).attr("data");

                    if (operation.indexOf("ptz") >= 0) {
                        operation = "ptz/stop";
                    }
                    else if(operation.indexOf("zoom") >= 0) {
                        operation = "vl/zoom/stop";
                    }
                    else if(operation.indexOf("focus") >= 0) {
                        operation = "vl/focus/stop";
                    }
                    else if(operation.indexOf("operation") >= 0) {
                        operation = "robot-motion?operation=stop&speed=200";
                    }
                    //layer.msg(operation);
                  
                    $.ajax({
                        type: "post",
                        url: "../handler/InterFace.ashx?r=" + Math.random(),
                        data: {
                            method: "http_PostMethod"
                            , token: public_token
                            , MethodUrl: "/control/" + operation
                            , postData: ""
                        },
                        dataType: "json",
                        success: function (data) {
                            //alert("ddd:"+data);
                            if (data) {
                                if (data.success == "true") {
                                    layer.msg("操作成功");
                                }
                                else {
                                    layer.msg(data.detail);
                                }
                            }
                        }
                    });
                });
            </script>
        </div>
    </form>
    <div id ="menu" >
        <input  class="menu_button" type="button" value="初始定位"  onclick="chushidingwei();"/>
        <input  class="menu_button" type="button" value="添加区域"  onclick="yijianfanhang();"/>
        <input  class="menu_button" type="button" value="暂停任务"  onclick="zhantingfuwu();"/>
        <input  class="menu_button" type="button" value="取消任务"  onclick="quxiaorenwu();"/>
        <input  class="menu_button" type="button" value="导出地图"  onclick="daochuditu();"/>
        <input  class="menu_button" type="button" value="取消选择"  onclick="javascript: $('#menu').css('display', 'none'); "/>      
    </div>

    <div id="explain" style="position:fixed;top:0px;left:0px;color:red;z-index:999;font-size:14px;line-height: 20px;text-align: center;width:80px;height:20px;opacity: 0.6;">
        
    </div>
</body>
    <script src="../js/plotting.js"></script> 
    <script>
        var canvas2 = document.getElementById("myCanvas2");
        var ctx2 = canvas2.getContext("2d");
        var yuquan = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, 52, 53, 54, 55, 56, 57, 58, 59, 60, 61, 62, 63, 64, 65, 66, 67, 68, 69, 70, 71, 72, 73, 74, 75, 76, 77, 78, 79, 80, 81, 82, 83, 84, 85, 86, 87, 88, 89, 90, 91, 92, 93, 94, 95, 96, 97, 98, 99, 100, 101, 102, 103, 104, 105, 106, 107, 108, 109, 110, 111, 112, 113, 114, 115, 116, 117, 118, 119, 120, 121, 122, 123, 124, 125, 126, 127, 128, 129, 130, 131, 132, 133, 134, 135, 136, 137, 138, 139, 140, 141, 142, 143, 144, 145, 146, 147, 148, 149, 150, 151, 152, 153, 154, 155, 156, 157, 158, 159, 160, 161, 162, 163, 164, 165, 166, 167, 168, 169, 170, 171, 172, 173, 174, 175, 176, 177, 178, 179, 180, 181, 182, 183, 184, 185, 186, 187, 188, 189, 190, 191, 192, 193, 194, 195, 196, 197, 198, 199, 200, 201, 202, 203, 204, 205, 206, 207, 208, 209, 210, 211, 212, 213, 214, 215, 216, 217, 218, 219, 220, 221, 222, 223, 224, 225, 226, 227, 228, 229, 230, 231, 232, 233, 234, 235, 236, 237, 238, 239, 240, 241, 242, 243, 244, 245, 246, 247, 248, 249, 250, 251, 252, 253, 254, 255, 256, 257, 258, 259, 260, 261, 262, 263, 264, 265, 266, 267, 268, 269, 270, 271, 272, 273, 274, 275, 276, 277, 278, 279, 280, 281, 282, 283, 284, 285, 286, 287, 288, 289, 290, 291, 292, 293, 294, 295, 296, 297, 298, 299, 300, 301, 302, 303, 304, 305, 306, 307, 308, 309, 310, 311, 312, 313, 314, 315, 316, 317, 318, 319, 320, 321, 322, 323, 324, 325, 326, 327, 328, 329, 330, 331, 332, 333, 334, 335, 336, 337, 338, 339, 340, 341, 342, 343, 344, 345, 346, 347, 348, 349, 350, 351, 352, 353, 354, 355, 356, 357, 358, 359];
        var img1 = new Image();
        img1.src = '../images/control/leida.png';

        img1.onload = function(){

        //ctx2.drawImage(img1, 0, 0);
        canvas2.height = img1.height;
        canvas2.width = img1.width;
        //画圆
        draw();

            function draw() {

                $.ajax({
                            type: "post",
                            url: "../handler/InterFace.ashx?r=" + Math.random(),
                            data: {
                                method: "http_getMethod"
                                , token: public_token
                                , MethodUrl: "/laser/data"
                            },
                            dataType: "json",
                            success: function (data) {
                                //获得雷达信息
                                if (data.detail) {
                                    yuquan = data.data;
                                } else {
                                    console.log('没有获取到雷达数据');
                                }
                                
                            }
                });
                 console.count('获取雷达数据次数');
                //ctx2.save();
                canvas2.height = canvas2.height;
                ctx2.globalAlpha = 10;
                ctx2.lineWidth = 2;
                ctx2.strokeStyle = 'red';
                for(var i =0;i<yuquan.length;i++){
                    var r = yuquan[i]*50/3000;
                    //180度被分为 yuquan.length份  第i份
                    var num = 360-(180/yuquan.length)*i;
            
                    ctx2.beginPath();
                    ctx2.arc(75,75,r,num* Math.PI/180,(num+2)* Math.PI/180);
                    ctx2.stroke();
                   }
                //ctx2.restore();
                setTimeout(function () {
                   
                    draw();

                }, 1000)



         };
        
          
            }
    </script>
</html>
