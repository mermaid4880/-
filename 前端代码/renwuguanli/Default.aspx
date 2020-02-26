<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Default.aspx.cs" Inherits="renwuguanli_Default" %>



<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title>全面巡检</title>
   
     <link href="../lib/ligerUI/skins/Aqua/css/ligerui-all.css" rel="stylesheet" type="text/css" />
    <link href="../lib/ligerUI/skins/Gray2014/css/all.css" rel="stylesheet" type="text/css" />
    <script src="../js/jquery-1.8.3.min.js" type="text/javascript"></script>
    <script src="../lib/ligerUI/js/core/base.js" type="text/javascript"></script>

    <link href="../js/layui/css/layui.css" rel="stylesheet" type="text/css" />
    <script src="../js/layui/layui.js" type="text/javascript"></script>

    <script src="../lib/ligerUI/js/plugins/ligerLayout.js" type="text/javascript"></script>
    <script src="../lib/ligerUI/js/ligerui.min.js" type="text/javascript"></script>
    <script src="../lib/ligerUI/js/plugins/ligerGrid.js" type="text/javascript"></script>

    <link href="../css/calendar/calendar-pro.css" rel="stylesheet" type="text/css" />
    <script src="../css/calendar/calendar-pro.js" type="text/javascript"></script>

    <script src="../lib/js/publicMethodJs.js" type="text/javascript"></script>
    <script src="public_getTreeJs.js" type="text/javascript"></script>



    <style type="text/css">
        body {
            padding: 10px;
            margin: 0;
        }

        #layout1 {
            width: 100%;
            margin: 40px;
            height: 400px;
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
        
        .l-layout-content {
            background-color:#f5f5f5;
        }
        .l-layout-top {
             background-color:#f5f5f5;
        }
         .l-layout-header {     
            background-color:RGB(203,233,231) !important;
            color:#000;
        }
        
        .titleSpan
        {
            width:100px;
            }

       
    </style>

    <script type="text/javascript">
        var taskType = "qmxj";
        var public_token = "<%=public_token %>";
        var public_type = "<%=public_type%>"; // 1 是全面巡检 2例行巡检 3专项巡检 4特殊巡检 5自定义巡检
        var public_miniType = "<%=public_miniType%>";
        var grid = null;
        var updateId = 0;
        var bodyHeight = document.documentElement.clientHeight; //页面高度
        $(function () {

            $("#layout1").ligerLayout({ leftWidth: 350, topHeight: 220 });

            //加载layui 复选框
            layui.use(['layer', 'form', 'laydate'], function () {
                var form = layui.form;
                console.log(form)
                layer = layui.layer;
                var laydate = layui.laydate;
                laydate.render({
                    elem: '#time1'
                    , type: 'time'
                });
                laydate.render({
                    elem: '#time2'
                    , type: 'time'
                });
                laydate.render({
                    elem: '#time3'
                    , type: 'datetime'
                });

            });

            //装载树结构
            $("#ftree").attr("src", "../tree/allTree.aspx");
            //这里装载grid


            grid = $("#maingrid").ligerGrid({
                columns: [
                    //{ display: '序号', name: 'taskId', align: 'center', width: 120 },
                    { display: '任务名称', name: 'taskName', minWidth: 60 },
                    { display: '编辑时间', name: 'createTime', width: 300 },
                    {
                        display: '操作', isSort: false, width: 400, render:
                            function (rowdata, rowindex, value) {
                                var h = '';
                                h += "<a href='javascript:liji_run(" + rowindex + ")'>立即执行</a> &nbsp&nbsp";
                                h += "<a href='javascript:dingqi_run(" + rowindex + ")'>定期执行</a> &nbsp&nbsp";
                                h += "<a href='javascript:zhouqi_run(" + rowindex + ")'>周期执行</a> ";
                                return h;
                            }    
                    }
                ]
                //双击任务模板
                , onDblClickRow: function (data, rowindex, rowobj) {
                    getTaskTempletDetail(data.id);
                    updateId = data.id;  //保存当前行任务id
                }
                , rownumbers:true
                , pageSize: 30
                , width: '100%'
                , checkbox: false
                , usePager: true
                , dataAction: "local"
                , height: bodyHeight - 367
            });

            
            //1装载巡检类型111112-----------------------------------
            $.ajax({
                type: "get",
                url: "../handler/InterFace.ashx",
                data: {
                    method: "http_getMethod"
                   , MethodUrl: "/taskTemplateTypes"
                   , token: public_token
                },
                dataType: "json",
                success: function (data) {
                    if (data) {
                        var vLen = data.length;
                        var vHtml = "<p>巡检类型：";
                        for (var i = 0; i < vLen; i++) {
                            if (data[i].id == public_type) {
                                if (data.name != "自定义巡检")
                                    vHtml += "<input  type='radio' name='xjName' value='" + data[i].id + "' style='margin-left:30px;' checked />" + data[i].name + " ";
                            }
                            else {
                                if (data.name != "自定义巡检")
                                    vHtml += "<input  type='radio' name='xjName' value='" + data[i].id + "' style='margin-left:30px;' disabled />" + data[i].name + " ";
                            }

                        }
                        vHtml += "</p>";
                        $("#divHead0").html(vHtml);
                    }
                }
            });


            //这里装载巡检子类型


            $.ajax({
                type: "get",
                url: "../handler/InterFace.ashx",
                data: {
                    method: "http_getMethod"
                   , MethodUrl: "/areas"
                   , token: public_token
                },
                dataType: "json",
                success: function (data) {
                    if (data) {
                        var vLen = data.length;
                        var vHtml = "<p>设备区域：";
                        for (var i = 0; i < vLen; i++) {
                            vHtml += "<input class='ever_areaName' data='" + data[i].areaName + "' type='checkbox' name='ck1' value='N" + data[i].id + "' style='margin-left:30px;'/>" + data[i].areaName + " ";
                        }
                        vHtml += "</p>";
                        $("#divHead1").html(vHtml);
                    }
                    $(".ever_areaName").click(function () {
                        oncheckselected($(this))
                    });
                    //alert(data);
                }
            });



            $.ajax({
                type: "get",
                url: "../handler/InterFace.ashx",
                data: {
                    method: "http_getMethod"
                   , MethodUrl: "/deviceTypes"
                   , token: public_token
                },
                dataType: "json",
                success: function (data) {

                    if (data) {
                        var vLen = data.length;
                        var vHtml = "<p>设备类型：";
                        for (var i = 0; i < vLen; i++) {
                            vHtml += "<input class='ever_deviceType' data='" + data[i].areaName + "' type='checkbox' name='ck1' value='N" + data[i].id + "' style='margin-left:30px;' />" + data[i].deviceType + " ";
                        }
                        vHtml += "</p>";
                        $("#divHead2").html(vHtml);
                    }
                    $(".ever_deviceType").click(function () {
                        oncheckselected($(this))
                    });
                }
            });



            $.ajax({
                type: "get",
                url: "../handler/InterFace.ashx",
                data: {
                    method: "http_getMethod"
                   , MethodUrl: "/detectionTypes"
                   , token: public_token
                },
                dataType: "json",
                success: function (data) {

                    if (data) {
                        var vLen = data.length;
                        var vHtml = "<p>识别类型：";
                        for (var i = 0; i < vLen; i++) {
                            vHtml += "<input class='ever_detectionName' data='" + data[i].detectionName + "' type='checkbox'  name='ck1' value='N" + data[i].id + "'  style='margin-left:30px;'/>" + data[i].detectionName + " ";
                        }
                        vHtml += "</p>";
                        $("#divHead3").html(vHtml);
                    }
                    $(".ever_detectionName").click(function () {
                        oncheckselectedProperty("detectionType", $(this))
                    });
                    //alert(data);
                }
            });

       
            $.ajax({
                type: "get",
                url: "../handler/InterFace.ashx",
                data: {
                    method: "http_getMethod"
                   , MethodUrl: "/meterTypes"
                   , token: public_token
                },
                dataType: "json",
                success: function (data) {

                    if (data) {
                        var vLen = data.length;
                        var vHtml = "<p>表计类型：";
                        for (var i = 0; i < vLen; i++) {
                            vHtml += "<input class='ever_meterType' data='" + data[i].meterType + "' type='checkbox' name='ck1' value='N" + data[i].id + "' style='margin-left:30px;' />" + data[i].meterType + " ";
                        }
                        vHtml += "</p>";
                        $("#divHead4").html(vHtml);
                    }
                    $(".ever_meterType").click(function () {
                        oncheckselectedProperty("meterType", $(this)); //通过属性来选择
                    });
                    //alert(data);
                }
            });

            searchDB();//装载grid

        });


        //这里是筛选方法
        function oncheckselected(thisv) {
            
            var vTreeObject = public_getTreeObject();
            var boolv = thisv.prop("checked");
            var node = vTreeObject.getNodeByParam("name", thisv.attr("data"), null);
            boolv ? vTreeObject.checkNode(node, true, true) : vTreeObject.checkNode(node, false, true);
        }


        //这里是筛选属性点筛选方法
        function oncheckselectedProperty(vType, thisv) {
            var boolv = thisv.prop("checked");
            var vTreeObject = public_getTreeObject();
            var vThisvText = thisv.attr("data"); //得到属性
            var vArray = ftree.contentWindow.fromMeterPropertyGetMeterIdList(vType, vThisvText);
            if (vArray.length > 0) {
                for (var i = 0; i < vArray.length; i++) {
                    var node = vTreeObject.getNodeByParam("no", vArray[i], null);
                    boolv ? vTreeObject.checkNode(node, true, true) : vTreeObject.checkNode(node, false, true);
                }
            }
        }

         //这里是根据id勾选左侧树的方法
        function selectedNodesOnTree(vArray) {

            if (vArray.length > 0) {

                var vTreeObject = public_getTreeObject();
                vTreeObject.checkAllNodes(false);//先默认都不选择
                for (var i = 0; i < vArray.length; i++) {
                    var node = vTreeObject.getNodeByParam("no", "N"+vArray[i], null);
                    vTreeObject.checkNode(node, true, true)
                }
            }
        }


        var DB_DATA = {};

        function searchDB() {

            var vUrl = "/taskTemplates?type=" + public_miniType + "&pageNum=1&pageSize=15&orderBy=id";

            $.ajax({
                type: "get",
                url: "../handler/InterFace.ashx",
                data: {
                    method: "http_getGridMethod_expend"
                   , MethodUrl: vUrl
                   , token: public_token
                   , ListName: "list"  
                },
                dataType: "json",
                success: function (data) {
                    dataAll = data;
                    console.log(data);
                    if (data.Rows == 0) {
                        layer.msg("没有符合条件的数据") 
                    } else {

                        grid.set({ data: data });
                        //DB_DATA = data;
                    }

                }
            });
        }

        //根据任务点位情况 过滤左侧多选点位树
        function getTaskTempletDetail(id) {
            //根据任务规划模板id 得到任务模板明细
            var vUrl = "/taskTemplates/" + id;
            var allMeters = [];
            console.log(id);
            $.ajax({
                type: "get",
                url: "../handler/InterFace.ashx",
                data: {
                    method: "http_getMethod"
                   , MethodUrl: vUrl
                   , token: public_token
                },
                dataType: "json",
                success: function (data) {
                    console.log(data);
                    if (data.Rows == 0) {
                        layer.msg("没有符合条件的数据") 
                    } else {
                        allMeters = data.meters.split(',');
                        //对左侧树进行筛选
                        console.log(allMeters);
                        selectedNodesOnTree(allMeters);
                    }

                }
            });
        }

        function saveDB() {
            var myDate = new Date();
            //$("#taskName").val("全面巡检任务" + myDate.toLocaleDateString().replace(/\//g, ''));
            var arra = [];
            var vTreeObject = public_getTreeObject();
            var objtemp = vTreeObject.getCheckedNodes();
            for (var i = 0, l = objtemp.length; i < l; i++) {

                if (!objtemp[i].isParent) {
                    arra.push(objtemp[i].no.replace("N", ""));
                }
            }
            if (objtemp.length <= 0) {
                $.ligerDialog.warn('请选择需要巡检的节点');
                return;
            }
            //
            var detail_task = $.ligerDialog.open({
                target: $("#div_task"),
                title: "保存任务模板",
                width: 300, top: 220,
                buttons: [
                {
                    text: '确定', onclick: function () {
                        console.log(arra);
                        vUrl = "/taskTemplates/" + updateId;
                        console.log(vUrl);
                        //taskName meters taskType
                        $.ajax({
                            type: "put",
                            url: "../handler/InterFace.ashx",
                            data: {
                                method: "http_PutMethod"
                                , MethodUrl: vUrl
                                , token: public_token
                                , data: "meters=" + arra
                            },
                            dataType: "json",
                            success: function (data) {
                                if (data.success) {
                                    $.ligerDialog.success('保存成功');
                                    grid.loadData();
                                } else {
                                    $.ligerDialog.error('保存失败');
                                }

                            }
                        });

                    }
                },
                { text: '取消', onclick: function () { detail_task.hide(); } }
                ]
            });


        }

        function resetDB() {
            window.location.reload();
        }

        function liji_run(rowid) {

            alert(DB_DATA.Rows[rowid].taskId)
            grid.loadData();
            $.ajax({
                type: "get",
                url: "../handler/InterFace.ashx",
                data: {
                    method: "doTask"

                   , token: public_token
                    , taskType: taskType
                    , robotId: ""
                    , doTime: $("lj_time").val()
                    , taskId: DB_DATA[rowid].taskId
                    , doTaskType: "doTaskTempletNow"
                },
                dataType: "json",
                success: function (data) {
                    //处理返回值
                    if (data.success) {
                        $.ligerDialog.success('执行成功');
                        grid.loadData();
                    }
                    else $.ligerDialog.error('设定失败');
                }
            });

        }
        function dingqi_run(rowid) {
            alert(DB_DATA.Rows[rowid].taskId)
            var detail_dingqi = $.ligerDialog.open({
                target: $("#div_dingqirun"),
                title: "定期执行",
                width: 500, top: 150,
                buttons: [
                {
                    text: '确定', onclick: function () {
                        //{{url}}/doTaskTempletRegular
                        //{taskType,robotId,doTaskType,doTime,spaceType}
                        alert(1);
                        $.ajax({
                            type: "get",
                            url: "../handler/InterFace.ashx",
                            data: {
                                method: "doTask"
                               , token: public_token
                                , taskType: taskType
                                , robotId: ""
                                , doTime: $("lj_time").val()
                                , taskId: DB_DATA.Rows[rowid].taskId
                                 , doTaskType: "doTaskTempletNow1"
                            },
                            dataType: "json",
                            success: function (data) {
                                //处理返回值
                                if (data.success) {
                                    detail_dingqi.hide();
                                    $.ligerDialog.success('设定成功');
                                    grid.loadData();
                                }
                                else $.ligerDialog.error('设定失败');
                            }
                        });

                    }
                },
                { text: '取消', onclick: function () { detail_dingqi.hide(); } }
                ]
            });

        }
        function zhouqi_run(rowid) {
            alert(DB_DATA.Rows[rowid].taskId)
            var detail_zhouqi = $.ligerDialog.open({
                target: $("#div_zhouqirun"),
                title: "周期执行",
                width: 500, top: 150,
                buttons: [
                {
                    text: '确定', onclick: function () {
                        //{{url}}/doTaskTempletRegular
                        $.ajax({
                            type: "get",
                            url: "../handler/InterFace.ashx",
                            data: {
                                method: "doTask"
                               , token: public_token
                                , taskType: taskType
                                , robotId: ""
                                , doTime: $("#zq_time").val()
                                , spaceType: $("#spaceType".val())
                                , taskId: DB_DATA.Rows[rowid].taskId
                                , doTaskType: "doTaskTempletNow2"
                            },
                            dataType: "json",
                            success: function (data) {
                                //处理返回值
                                if (data.success) {
                                    detail_zhouqi.hide();
                                    $.ligerDialog.success('设定成功');
                                    grid.loadData();
                                }
                                else $.ligerDialog.error('设定失败');
                            }
                        });
                    }
                },
                { text: '取消', onclick: function () { detail_zhouqi.hide(); } }
                ]
            });
        }
    </script>

</head>
<body>
    <form id="form1" runat="server">
        <div id="layout1">

            <div position="top" id="divHead" style="margin-top:5px">
                <div id="divHead0">
                    <p style="margin-top:5px">
                        巡检类型：
                        <input type="radio" value="1" style="margin-left: 30px;"/>全面巡检
                        <input type="radio" disabled style="margin-left: 30px;"/>例行巡检
                        <input type="radio" disabled style="margin-left: 30px;"/>专项巡检
                        <input type="radio" disabled style="margin-left: 30px;"/>特殊巡检
                    </p>
                </div>
                <div id="divHead5" style="margin-top:5px">
                    <p style="margin-top:5px">
                        细分类型：
                        <input type="radio" name="zileixing" style="margin-left: 30px;"/>细分类型
                        <input type="radio" name="zileixing" style="margin-left: 30px;"/>细分类型
                        <input type="radio" name="zileixing" style="margin-left: 30px;"/>细分类型
                        <input type="radio" name="zileixing" style="margin-left: 30px;"/>细分类型
                    </p>
                </div>
                <div id="divHead1" style="margin-top:5px"></div>
                <div id="divHead2" style="margin-top:5px"></div>
                <div id="divHead3" style="margin-top:5px"></div>
                <div id="divHead4" style="margin-top:5px"></div>

            </div>
            <div position="left" title="点位树" style="padding-left: 10px">
                <iframe id="ftree" frameborder="0" height="595px" width="100%" src="kong.htm"></iframe>
            </div>

            <div position="center" title="任务编辑列表">
                
                <div id="div_dingqirun" style="display: none; text-align: left; line-height: 30px; padding-right: 30px;">
                    <div class="layui-form" action="">
                        <div class="layui-form-item">
                            <label class="layui-form-label">定期描述</label>
                            <div class="layui-input-block">
                                <input type="text" name="title" lay-verify="title" autocomplete="off" placeholder="请输入定期描述" class="layui-input">
                            </div>
                        </div>

                        <div class="layui-form-item">
                            <label class="layui-form-label">设定路线</label>
                            <div class="layui-input-block">
                                <input type="text" name="title" lay-verify="title" autocomplete="off" placeholder="请输入设定路线" class="layui-input">
                            </div>
                        </div>
                        <div class="layui-form-item">
                            <label class="layui-form-label">任务时间</label>
                            <div class="layui-input-block">
                                <input type="text" class="layui-input" id="time1" placeholder="HH:mm:ss" lay-key="5">
                            </div>
                        </div>
                        <div class="layui-form-item">
                            <label class="layui-form-label">是否启动</label>
                            <div class="layui-input-block">
                                <input type="checkbox" name="like[qidong]" title="是否启动" checked>
                            </div>
                        </div>
                        <div class="layui-form-item">
                            <label class="layui-form-label">优先级</label>
                            <div class="layui-input-block">
                                <input type="text" name="title" lay-verify="title" autocomplete="off" placeholder="请输入优先级" class="layui-input">
                            </div>
                        </div>
                    </div>
                </div>
                <div id="div_zhouqirun" style="display: none; text-align: left; line-height: 30px; padding-right: 30px;">
                    <div class="layui-form" action="">
                        <div class="layui-form-item">
                            <label class="layui-form-label">周期描述</label>
                            <div class="layui-input-block">
                                <input type="text" name="title" lay-verify="title" autocomplete="off" placeholder="请输入周期描述" class="layui-input">
                            </div>
                        </div>

                        <div class="layui-form-item">
                            <label class="layui-form-label">设定路线</label>
                            <div class="layui-input-block">
                                <input type="text" name="title" lay-verify="title" autocomplete="off" placeholder="请输入设定路线" class="layui-input">
                            </div>
                        </div>
                        <div class="layui-form-item">
                            <label class="layui-form-label">重复类型</label>
                            <div class="layui-input-inline">
                                <select name="modules" lay-verify="required" lay-search="">
                                    <option value="hour">每小时</option>
                                    <option value="day">每天</option>
                                    <option value="week">每周</option>
                                    <option value="month">每月</option>
                                </select>
                            </div>
                        </div>
                        <div class="layui-form-item">
                            <label class="layui-form-label">任务时间</label>
                            <div class="layui-input-block">
                                <input type="text" class="layui-input" id="time2" placeholder="HH:mm:ss" lay-key="5">
                            </div>
                        </div>
                        <div class="layui-form-item">
                            <label class="layui-form-label">是否启动</label>
                            <div class="layui-input-block">
                                 <input type="checkbox" name="like1[write]" lay-skin="primary" title="写作" checked>
                            </div>
                        </div>
                        <div class="layui-form-item">
                            <label class="layui-form-label">优先级</label>
                            <div class="layui-input-block">
                                <input type="text" name="title" lay-verify="title" autocomplete="off" placeholder="请输入优先级" class="layui-input">
                            </div>
                        </div>
                    </div>
                </div>
                <div id="div_zhouqirun2" style="display: none; text-align: left; line-height: 30px; padding-left: 50px;">
                    <p>周期描述：<input data-type="text" data-label="定期任务描述" style="height: 20px; line-height: 20px;" /></p>
                    <p>设定路线：<input data-type="text" data-label="设定路线" style="height: 20px; line-height: 20px;" /></p>
                    <p>
                        重复类型：
                        <select id="spaceType">
                            <option value="hour">每小时</option>
                            <option value="day">每天</option>
                            <option value="week">每周</option>
                            <option value="month">每月</option>
                        </select>
                    </p>
                    <p>任务时间：<input id="zq_time" data-type="text" data-label="设定任务时间" style="height: 20px; line-height: 20px;" /></p>
                    <p>是否启动：<input type="checkbox" checked class="liger-checkbox" style="height: 20px; line-height: 20px;" />启动</p>
                    <p>优先级：<input data-type="text" data-label="优先级" style="height: 20px; line-height: 20px;" /></p>
                </div>
                <div id="div_task" style="display: none; text-align: left; line-height: 30px; padding-left: 50px;">
                    <p>确定保存任务模板的修改吗?</p>

                </div>
                <div class="layui-form" style="padding-top: 8px;">

                    <div class="layui-form-item">

         <%--               <div class="layui-input-inline" style="width: 210px;">
                            <input type="text" name="renwuming" placeholder="任务名" autocomplete="off" class="layui-input" style="width:200px;margin-left:10px">
                        </div>--%>

       <%--                 <div class="layui-input-inline" style="width: 80px">
                            <input type="button" class="layui-btn"  value="查询" onclick="searchDB()"></input>
                        </div>--%>

                        <div class="layui-input-inline" style="width: 80px;padding-left:20px">
                            <input type="button" class="layui-btn layui-btn-warm" value="保存" onclick="saveDB()" ></input>
                        </div>

                        <div class="layui-input-inline" style="width: 80px">
                            <input type="button" class="layui-btn layui-btn-normal"  value="重置" onclick="resetDB()"></input>
                        </div>
                    </div>
                </div>

                <div id="maingrid" style="margin: 0; padding: 0"></div>


            </div>

        </div>

    </form>




</body>
</html>
