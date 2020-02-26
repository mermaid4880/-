<%@ Page Language="C#" AutoEventWireup="true" CodeFile="index.aspx.cs" Inherits="index" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta charset="UTF-8">
    <title>变电站智能巡检机器人标准化后台监控系统v1.0</title>
    <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no">
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    <meta name="renderer" content="webkit">
    <meta name="force-rendering" content="webkit">
    <meta http-equiv="X-UA-Compatible" content="IE=6">
    <script src="js/jquery/jquery-1.9.1.min.js" type="text/javascript"></script>
    <link href="css/ligerui-all.css" rel="stylesheet" type="text/css" />
    <link rel="stylesheet" type="text/css" href="css/style.css">
    <script type="text/javascript" src="js/html5shiv.min.js"></script>
    <script src="js/respond.min.js" type="text/javascript"></script>
    <script src="js/selectivizr.js" type="text/javascript"></script>

    <script src="js/layui/layui.js" type="text/javascript"></script>

    <script src="index.js" type="text/javascript"></script>
    <style>
        .l-menu {
            top:800px!important;
        }
        .l-tab-links {
            width:1800px !important;
        }
        .closeall {
            width: 80px;
            float: right;
            background: url(../images/layout/tabs-item-bg.gif);
            position: absolute;
            z-index: 999;
            right: 0;
            top: 97%;
            height: 28px;
            line-height: 30px;
            text-align: center
        }
    </style>
    <script>


        function closeall() {
            
            location.href = "/index.aspx";

        }
        var public_loginId = "<%=loginId%>";
        var public_loginName = "<%=loginName%>";
        var public_token = "<%=public_token%>";
        var public_accessIds = "<%=public_accessIds%>";

        $(function () {

            $("#spWecomText").html("欢迎您[" + public_loginName + "]");
            //装在系统第一界面
            $("#home").attr("src", "pages/机器人管理.aspx");

            $("#a_loginOut").on("click", function () {

                layui.use("layer", function () {
                    var layer = layui.layer; //获得layer模块
                    layer.confirm('确定要退出系统吗？', {
                        btn: ['确定', '取消'] //按钮
                    }, function () {
                        window.location = 'login.htm';
                    }, function () {

                    });

                })


            });

            //开始循环装载菜单
            getMenuDb();

        });

        function getMenuDb() {

            $.ajax({
                type: "get",
                url: "handler/InterFace.ashx",
                data: {
                    method: "http_getMethod"
                    , token: public_token
                    , MethodUrl: "/taskTemplateTypes?r=" + Math.random()
                },
                dataType: "json",
                success: function (data) {

                    console.log(data);
                    if (data.detail == "success") {

                        var array = [];

                        $.each(data.data, function (i, o) {

                            var jo = { title: "", childen: [] };
                            jo.title = o.name;
                            $.each(o.children, function (y, oy) {


                                jo.childen.push({
                                    "title": oy.name,
                                    "id": oy.name,
                                    "url": "pages/巡检模板.aspx?type=" + o.id + "&miniType=" + oy.id
                                });
                            })
                            array.push(jo);
                        })

                        array.push(
                             {
                                 "title": "地图选点",
                                 "childen": [{
                                     "title": "地图选点",
                                     "id": "7",
                                     "url": "pages/地图选点.aspx"
                                 }]
                             }
                        );
                        array.push(
                            {
		                        "title": "任务展示",
		                        "childen": [{
		                            "title": "任务展示",
		                            "id": "8",
		                            "url": "pages/任务展示.aspx"
		                        }]
		                    }
                        )

                        var json = {
                            "menuid": "2",
                            "imgSrc": "images/common/rwgl.png",
                            "menuText": "任务管理",
                            "url": "",
                            "subMenuClass": "task-manage",
                            "subMenu": array
                        }; //这里得到的数据
                        menuArray.splice(1, 0, json);
                        initMenu();

                    }
                }



            })
                   


        }

        function initMenu() {
            
            if (public_accessIds) {
                $(".nav-list").html("");
                var vHtml = '<li><img src="images/common/up01.png" alt=""></li>';

                var vMyMenuIdArray = public_accessIds.split(",");
                for (var i = 0; i < menuArray.length; i++) {

                    var json = menuArray[i];
                    var menuId = json.menuid;
                    if ($.inArray(menuId, vMyMenuIdArray) == -1) {
                        continue;
                    }

                    vHtml += '<li class="have-bg">';
                    vHtml += '<img src="' + json.imgSrc + '" alt="">';
                    if (json.subMenuClass == "") {

                        vHtml += '<div class="text ">';
                        vHtml += '<a href="javascript:void(0);" onclick=f_MyAddTab("' + json.menuid + '","' + json.url + '","' + json.menuText + '")>' + json.menuText + '</a>';
                        vHtml += '</div>';
                    }
                    else {
                       
                       //这是有子菜单的情况
                        vHtml += '<div class="text">';
                        vHtml += json.menuText;
                        vHtml += '</div>';
                        vHtml += '<ul class="' + json.subMenuClass + '">';
                        $.each(json.subMenu, function (j, json2) {
                            vHtml += '<li>';
                            vHtml += '<h4>' + json2.title + '</h4>';
                            $.each(json2.childen, function (w, json2Son) {

                                vHtml += '<span><a href="javascript:void(0);" onclick=f_MyAddTab("' + json2Son.id + '","' + json2Son.url + '","' + json2Son.title + '")>' + json2Son.title + '</a></span>';    
                            })
                            
                            vHtml += '</li>';

                        })
                        vHtml += '</ul>';

                    }
                    vHtml += "</li>";

                }
                vHtml += '<li><img src="images/common/down01.png" alt=""></li>';
                $(".nav-list").html(vHtml); //装载上

                $(".nav-list ul li").on("click", "span", function () {
                    var spanIndex = $(".have-bg span").index(this);
                    $(".header .crumbs .first").text($(".have-bg .text").eq(firstTextIndex).text());
                    $(".header .crumbs .second").text($(".have-bg span").eq(spanIndex).text());
                    navFadeToggle();
                });
                $(".nav-list .text").on("click", "a", function () {
                    var spanIndex = $(".have-bg span").index(this);
                    //$(".header .crumbs .first").text($(this).text());
                    $(".header .crumbs .second").text($(this).text());
                    navFadeToggle();
                });
            }
        }
    </script>

</head>
<body class="overflowX" style="overflow: hidden;">
    <form id="form1" runat="server">
    </form>

    <div class="full">
        <div class="full">
            <!-- start header -->
            <header class="header">
                <div class="top">
                    <span>
                        <a href="#">
                            <img src="images/common/home.png" alt="首页">首页</a>
                    </span>
                    <span>
                        <img src="images/common/help.png" alt="帮助"><a href="#" id="a_sysHelp">帮助</a></span>
                    <span>
                        <img src="images/common/exit.png" alt="退出"><a href="#" id="a_loginOut">退出</a></span>
                    <span id="spWecomText">欢迎您</span>
                </div>
                <div class="bottom">
                    <div class="nav-box">
                        <img class="nav-img" src="images/common/navup.png" alt="">
                        <ul class="nav-list">
                            
                        </ul>
                    </div>
                    <div class="crumbs">
                        <span class="first">机器人管理</span> > <span class="second">机器人管理</span>
                        <input type="hidden" id="url">
                    </div>
                    
                </div>
                <div class="cover"></div>
            </header>
            <!-- end header -->
            
            
            <div id="navtab">
                <ul class="closeall"><li onclick="closeall()">关闭所有
                      
                </li></ul> 
                <div tabid="机器人管理" title="机器人管理" lselected="true" >
                    <iframe frameborder="0" name="home" id="home" src="kong.htm"></iframe>
                   
                </div>
              
            </div>
              
            <input type="hidden" id="robotIp">
            <input type="hidden" id="cameraIp">
            <input type="hidden" id="flirIp">
            <input type="hidden" id="videoIp">
            <input type="hidden" id="sickIp">
            <input type="hidden" id="cameraAdmin">
            <input type="hidden" id="cameraPassword">
            <input type="hidden" id="videoAdmin">
            <input type="hidden" id="videoPassword">
        </div>
    </div>

</body>
</html>


<script src="js/jquery.min.js" type="text/javascript"></script>
<script src="js/bootstrap.min.js" type="text/javascript"></script>
<script src="js/ligerui.min.js" type="text/javascript"></script>
<script src="js/header.js?v=345345" type="text/javascript"></script>


<script src="js/drawline.js"></script>
<script src="js/MapInfo.js"></script>
<script src="js/msgType.js" type="text/javascript"></script>

<!-- 这部分转移到这里，这样就会只建立一个通信socket -->
<!--<script src="js/webSocket.js" type="text/javascript"></script>-->


<script>
    var iframeHeight = $(".iframe").height();
    var loadHtml = "<span style='width:100%;font-size:25px;line-height:" + iframeHeight + "px;text-align:center;display:inline-block;'><img src='images/common/bigloading.gif'></span>";
    //$(".iframe").html(loadHtml);


</script>
