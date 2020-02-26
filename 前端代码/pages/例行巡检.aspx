<%@ Page Language="C#" AutoEventWireup="true" CodeFile="例行巡检.aspx.cs" Inherits="pages_例行巡检" %>


<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title>例行巡检</title>
    <link href="../lib/ligerUI/skins/Aqua/css/ligerui-all.css" rel="stylesheet" type="text/css" />
    <link href="../lib/ligerUI/skins/Gray2014/css/all.css" rel="stylesheet" type="text/css" />
    <script src="../js/jquery-1.8.3.min.js" type="text/javascript"></script>
    <script src="../lib/ligerUI/js/core/base.js" type="text/javascript"></script>

    <link href="../js/layui/css/layui.css" rel="stylesheet" type="text/css" />
    <script src="../js/layer/layer.js" type="text/javascript"></script>

    <script src="../lib/ligerUI/js/plugins/ligerLayout.js" type="text/javascript"></script>
    <script src="../lib/ligerUI/js/plugins/ligerGrid.js" type="text/javascript"></script>
    <script src="../lib/ligerUI/js/ligerui.min.js"></script>
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
    </style>

    <script type="text/javascript">
        var taskType = "qmxj";
        var public_token = "<%=public_token %>";
        var grid = null;
        var bodyHeight = document.documentElement.clientHeight; //页面高度
        $(function () {

            $("#layout1").ligerLayout({ leftWidth: 350, topHeight: 300 });


            //装载树结构
            $("#ftree").attr("src", "../tree/allTree.aspx");
            //这里装载grid

            grid = $("#maingrid").ligerGrid({
                columns: [
               { display: '任务编号', name: 'taskId', align: 'left', width: 120 },
               { display: '任务名称', name: 'taskName', minWidth: 60 },
               { display: '编辑时间', name: 'updateTime', width: 200, align: 'left' }
               , {
                   display: '操作', isSort: false, width: 300, render: function (rowdata, rowindex, value) {
                       var h = '';
                       h += "<a href='javascript:liji_run(" + rowindex + ")'>立即执行</a> ";
                       h += "<a href='javascript:dingqi_run(" + rowindex + ")'>定期执行</a> ";
                       h += "<a href='javascript:zhouqi_run(" + rowindex + ")'>周期执行</a> ";
                       return h;
                   }
               }
                ]
               , pageSize: 30
               , width: '100%'
               , height: bodyHeight - 430
            });

            getChecks();



        });


        function getChecks() {

            $.ajax({
                type: "get",
                url: "../handler/InterFace.ashx?r=" + Math.random(),
                data: {
                    method: "http_getMethod"
                   , MethodUrl: "/areas"
                   , token: public_token
                },
                dataType: "json",
                success: function (data) {
                     if (!data.success ) {
                                         layer.msg(data.detail);
                                        return;

                                     }
                    data = data.data;

                    if (data) {
                        var vLen = data.length;
                        var vHtml = "<p>设备区域：";
                        for (var i = 0; i < vLen; i++) {
                            vHtml += "<input class='ever_areaName' data='" + data[i].areaName + "' type='checkbox' name='ck1' value='N" + data[i].id + "' style='margin-left:15px;'/>" + data[i].areaName + " ";
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
                url: "../handler/InterFace.ashx?r=" + Math.random(),
                data: {
                    method: "http_getMethod"
                   , MethodUrl: "/deviceTypes"
                   , token: public_token
                },
                dataType: "json",
                success: function (data) {
                     if (!data.success ) {
                                         layer.msg(data.detail);
                                        return;

                                     }
                    data = data.data;
                    if (data) {
                        var vLen = data.length;
                        var vHtml = "<p>设备类型：";
                        for (var i = 0; i < vLen; i++) {
                            vHtml += "<input class='ever_deviceType' data='" + data[i].areaName + "' type='checkbox' name='ck1' value='N" + data[i].id + "' style='margin-left:15px;' />" + data[i].deviceType + " ";
                        }
                        vHtml += "</p>";
                        $("#divHead2").html(vHtml);
                    }
                    $(".ever_deviceType").click(function () {
                        oncheckselected($(this))
                    });
                    //alert(data);
                }
            });

            $.ajax({
                type: "get",
                url: "../handler/InterFace.ashx?r=" + Math.random(),
                data: {
                    method: "http_getMethod"
                   , MethodUrl: "/detectionTypes"
                   , token: public_token
                },
                dataType: "json",
                success: function (data) {
                    if (!data.success ) {
                                         layer.msg(data.detail);
                                        return;

                                     }
                    data = data.data;
                    if (data) {
                        var vLen = data.length;
                        var vHtml = "<p>识别类型：";
                        for (var i = 0; i < vLen; i++) {
                            vHtml += "<input class='ever_detectionName' data='" + data[i].areaName + "' type='checkbox'  name='ck1' value='N" + data[i].id + "'  style='margin-left:15px;'/>" + data[i].detectionName + " ";
                        }
                        vHtml += "</p>";
                        $("#divHead3").html(vHtml);
                    }
                    $(".ever_detectionName").click(function () {
                        oncheckselected($(this))
                    });
                    //alert(data);
                }
            });


            $.ajax({
                type: "get",
                url: "../handler/InterFace.ashx?r=" + Math.random(),
                data: {
                    method: "http_getMethod"
                   , MethodUrl: "/meterTypes"
                   , token: public_token
                },
                dataType: "json",
                success: function (data) {
                     if (!data.success ) {
                                         layer.msg(data.detail);
                                        return;

                                     }
                    data = data.data;
                    if (data) {
                        var vLen = data.length;
                        var vHtml = "<p>表计类型：";
                        for (var i = 0; i < vLen; i++) {
                            vHtml += "<input class='ever_meterType' data='" + data[i].areaName + "' type='checkbox' name='ck1' value='N" + data[i].id + "' style='margin-left:15px;' />" + data[i].meterType + " ";
                        }
                        vHtml += "</p>";
                        $("#divHead4").html(vHtml);
                    }
                    $(".ever_meterType").click(function () {
                        oncheckselected($(this))
                    });
                    //alert(data);
                }
            });
        }

        //这里是筛选方法
        function oncheckselected(thisv) {

            var boolv = thisv.prop("checked");
            var vTreeObject = ftree.contentWindow.zTreeObj;
            var node = vTreeObject.getNodeByParam("name", thisv.attr("data"), null);
            boolv ? vTreeObject.checkNode(node, true, true) : vTreeObject.checkNode(node, false, true);


        }

        var DB_DATA = {};

        function searchDB() {
            DB_DATA = {};
            var vList = f_getCheckedNodes("N");
            console.log(vList);
            //暂时用这个 正式替换为 下面注释掉的ajax getTaskTempletList
            //$.ajax({
            //    type: "get",
            //    url: "../handler/InterFace.ashx",
            //    data: {
            //        method: "getTaskTempletList"

            //       , token: public_token
            //        , taskType: taskType
            //    },
            //    dataType: "json",
            //    success: function (data) {
            //DB_DATA = data;
            //        grid.set({ data: DB_DATA });

            //    }
            //});
            var data = {
                "Total": 5,
                "Rows": [{ "taskId": 1121, "taskName": "任务1", "updateTime": "2018-10-20 20:21:10" },
                    { "taskId": 2342, "taskName": "任务2", "updateTime": "2018-10-20 21:21:10" },
                    { "taskId": 433, "taskName": "任务3", "updateTime": "2018-10-20 22:21:10" },
                    { "taskId":344, "taskName": "任务4", "updateTime": "2018-10-20 23:21:10" },
                    { "taskId": 345, "taskName": "任务5", "updateTime": "2018-10-20 23:21:10" }
                ]
            }
            DB_DATA = data;
            grid.set({ data: DB_DATA });

           


        }

        function saveDB() {
            var myDate = new Date();
            $("#taskName").val("全面巡检任务" + myDate.toLocaleDateString().replace(/\//g, ''));
            var arra = [];
            var vTreeObject = ftree.contentWindow.zTreeObj;
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
                title: "任务保存",
                width: 400, top: 150,
                buttons: [
                {
                    text: '确定', onclick: function () {
                        console.log(arra);
                        //taskName meters taskType
                        $.ajax({
                            type: "get",
                            url: "../handler/InterFace.ashx?r=" + Math.random(),
                            data: {
                                method: "createTaskTempletList"
                                , token: public_token
                                , taskName: $("#taskName").val()
                                , meters: "[" + arra.join(",") + "]"
                                , taskType: taskType
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

        function f_getCheckedNodes(level) {
            var nodes = ftree.contentWindow.zTreeObj.getCheckedNodes();
            var names = "";
            var count = 0;
            for (var i = 0; i < nodes.length; i++) { node = nodes[i]; if (node.no.substring(0, 1) == level && !node.getCheckStatus().half) { names += node.no + ","; count += 1; } }
            if (count > 0) { names = names.substr(0, names.length - 1); }
            return names;
        }

        function liji_run(rowid) {
    
            alert(DB_DATA.Rows[rowid].taskId)
            grid.loadData();
            $.ajax({
                type: "get",
                url: "../handler/InterFace.ashx?r=" + Math.random(),
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
                width: 400, top: 150,
                buttons: [
                {
                    text: '确定', onclick: function () {
                        //{{url}}/doTaskTempletRegular
                        //{taskType,robotId,doTaskType,doTime,spaceType}
                        $.ajax({
                            type: "get",
                            url: "../handler/InterFace.ashx?r=" + Math.random(),
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
                width: 400, top: 150,
                buttons: [
                {
                    text: '确定', onclick: function () {
                        //{{url}}/doTaskTempletRegular
                        $.ajax({
                            type: "get",
                            url: "../handler/InterFace.ashx?r=" + Math.random(),
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

            <div position="top" id="divHead">
                <div id="divHead0">
                    <p>
                        巡检类型：<input type="radio" style="margin-left: 15px;" checked />例行巡检
                        <input type="radio" disabled />全面巡检
                        <input type="radio" disabled />专项巡检
                        <input type="radio" disabled />特殊巡检
                    </p>
                </div>

                <div id="divHead1"></div>
                <div id="divHead2"></div>
                <div id="divHead3"></div>
                <div id="divHead4"></div>
               
            </div>
            <div position="left" title="点位树" style="padding-left: 10px">
                <iframe id="ftree" frameborder="0" height="600px" width="100%" src="kong.htm"></iframe>
            </div>

            <div position="center" title="任务编辑列表">
                <div id="div_dingqirun" style="display: none; text-align: left; line-height: 30px; padding-left: 50px;">
                    <p>定期描述：<input data-type="text" data-label="定期任务描述" style="height:20px;line-height:20px;"/></p>
                    <p>设定路线：<input data-type="text" data-label="设定路线" style="height:20px;line-height:20px;"/></p>
                    <p>任务时间：<input id="lj_time" data-type="text" data-label="设定任务时间" style="height:20px;line-height:20px;"/></p>
                    <p>是否启动：<input type="checkbox" checked class="liger-checkbox" />启动</p>
                    <p>优先级：<input data-type="text" data-label="优先级" style="height:20px;line-height:20px;"/></p>
                </div>
                <div id="div_zhouqirun" style="display: none; text-align: left; line-height: 30px; padding-left: 50px;">
                    <p>周期描述：<input data-type="text" data-label="定期任务描述" style="height:20px;line-height:20px;"/></p>
                    <p>设定路线：<input data-type="text" data-label="设定路线" style="height:20px;line-height:20px;"/></p>
                    <p>
                        重复类型：
                        <select id="spaceType">
                            <option value="hour">每小时</option>
                            <option value="day">每天</option>
                            <option value="week">每周</option>
                            <option value="month">每月</option>
                        </select>
                    </p>
                    <p>任务时间：<input id="zq_time" data-type="text" data-label="设定任务时间" style="height:20px;line-height:20px;"/></p>
                    <p>是否启动：<input type="checkbox" checked class="liger-checkbox" style="height:20px;line-height:20px;" />启动</p>
                    <p>优先级：<input data-type="text" data-label="优先级" style="height:20px;line-height:20px;"/></p>
                </div>
                <div id="div_task" style="display: none; text-align: left; line-height: 30px; padding-left: 50px;">
                    <p>任务名称：<input data-type="text" id="taskName" /></p>

                </div>
                <div class="layui-form" style="padding-top: 8px;">

                    <div class="layui-form-item">

                        <div class="layui-input-inline">
                            <input type="text" lay-verify="required" placeholder="" autocomplete="off" class="layui-input" style="height: 30px; line-height: 30px; margin: 0 10px;">
                        </div>

                        <div class="layui-input-inline" style="width: 80px">
                            <input type="button" class="layui-btn layui-btn-sm layui-btn-primary" style="height: 30px; line-height: 30px;" value="查询" onclick="searchDB()"></input>
                        </div>
                        <div class="layui-input-inline" style="width: 80px">
                            <input type="button" class="layui-btn layui-btn-sm layui-btn-primary" style="height: 30px; line-height: 30px;" value="保存" onclick="saveDB()"></input>
                        </div>
                        <div class="layui-input-inline" style="width: 80px">
                            <input type="button" class="layui-btn layui-btn-sm layui-btn-primary" style="height: 30px; line-height: 30px;" value="重置" onclick="resetDB()"></input>
                        </div>
                    </div>
                </div>

                <div id="maingrid" style="margin: 0; padding: 0"></div>


            </div>

        </div>

    </form>




</body>
</html>