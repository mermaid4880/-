<%@ Page Language="C#" AutoEventWireup="true" CodeFile="巡检模板.aspx.cs" Inherits="pages_巡检模板" %>



<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title>巡检模板</title>
   
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
    <script src="../js/json2.js" type="text/javascript"></script>


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
            height: 25px;
            
        }
        .l-layout-top  .l-layout-content {
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

       .l-bar-selectpagesize{
            display:none !important;
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

        var public_treeJsonArray = [];
        //[{"id":1,"meterName":"A线路避雷器A相_泄露电流表","meterType":"泄漏电流表","detectionType":"表计读取","saveType":"可见光图片","deviceId":1,"deviceName":"避雷器A相","deviceType":"避雷器","areaId":38,"feverType":null,"parentAreaIds":[36,35]},{"id":2,"meterName":"A线路避雷器A相_接头","meterType":"红外检测点","detectionType":"红外测温","saveType":"红外+可见光图片","deviceId":1,"deviceName":"避雷器A相","deviceType":"避雷器","areaId":38,"feverType":"电压致热型","parentAreaIds":[36,35]},{"id":3,"meterName":"A线路避雷器B相_接头","meterType":"红外检测点","detectionType":"红外测温","saveType":"红外+可见光图片","deviceId":2,"deviceName":"避雷器B相","deviceType":"避雷器","areaId":38,"feverType":"电压致热型","parentAreaIds":[36,35]},{"id":6,"meterName":"A线路避雷器C相_接头","meterType":"红外检测点","detectionType":"红外测温","saveType":"红外+可见光图片","deviceId":2,"deviceName":"避雷器B相","deviceType":"避雷器","areaId":38,"feverType":"电压致热型","parentAreaIds":[36,35]},{"id":4,"meterName":"B线路断路器A相_接头","meterType":"红外检测点","detectionType":"红外测温","saveType":"红外+可见光图片","deviceId":3,"deviceName":"断路器A相","deviceType":"断路器","areaId":39,"feverType":"电压致热型","parentAreaIds":[36,35]},{"id":5,"meterName":"A线路断路器A相_接头","meterType":"红外检测点","detectionType":"红外测温","saveType":"红外+可见光图片","deviceId":4,"deviceName":"断路器A相","deviceType":"断路器","areaId":38,"feverType":"电压致热型","parentAreaIds":[36,35]}]
        function from_treeJsonArrayGetMeterIdList() {


            var meter_idList =[];

            var vObjArray1 = $(".ever_areaName:checked");
            var vObjArray2 = $(".ever_deviceType:checked");
            var vObjArray3 = $(".ever_detectionName:checked");
            var vObjArray4 = $(".ever_meterType:checked");

            if (vObjArray1.length == 0) {

                return meter_idList;
            }


            //第一层 //层级
            if (public_treeJsonArray.length > 0) {


                for (var i = 0; i < public_treeJsonArray.length; i++) {
                    public_treeJsonArray[i].flag1 = 0; //给他们添加一个key 并复制
                    public_treeJsonArray[i].flag2 = 0; //给他们添加一个key 并复制
                    public_treeJsonArray[i].flag3 = 0; //给他们添加一个key 并复制
                    public_treeJsonArray[i].flag4 = 0; //给他们添加一个key 并复制
                }
               

                for (var i = 0; i < public_treeJsonArray.length; i++) {
                    if (vObjArray1.length > 0) {
                        for(var j=0;j<vObjArray1.length;j++){

                            var vId = $(vObjArray1[j]).val(); //这是获取id
                            for (var x = 0; x < public_treeJsonArray[i].parentAreaIds.length; x++) {
                                if (vId == public_treeJsonArray[i].parentAreaIds[x].toString()) {
                                    public_treeJsonArray[i].flag1 = 1; //说明有这个
                                    break;
                                }
                            }
                        }
                    }
                    if (vObjArray2.length > 0) {
                        for (var j = 0; j < vObjArray2.length; j++) {

                            var vId = $(vObjArray2[j]).val(); //这是获取id
                            if (public_treeJsonArray[i].deviceType==vId) {
                                public_treeJsonArray[i].flag2 = 1; //说明有这个
                                break;

                            }
                        }
                    }
                    if (vObjArray3.length > 0) {
                        for (var j = 0; j < vObjArray3.length; j++) {

                            var vId = $(vObjArray3[j]).val(); //这是获取id
                            if (public_treeJsonArray[i].detectionType == vId) {
                                public_treeJsonArray[i].flag3 = 1; //说明有这个
                                break;

                            }
                        }
                    }
                    if (vObjArray4.length > 0) {
                        for (var j = 0; j < vObjArray4.length; j++) {

                            var vId = $(vObjArray4[j]).val(); //这是获取id
                            if (public_treeJsonArray[i].meterType == vId) {
                                public_treeJsonArray[i].flag4 = 1; //说明有这个
                                break;

                            }
                        }
                    }
                }

                //这里是
                var iflag1 = 0;
                if (vObjArray1.length > 0) {
                    iflag1 = 1;
                }
                var iflag2 = 0;
                if (vObjArray2.length > 0) {
                    iflag2 = 1;
                }
                var iflag3 = 0;
                if (vObjArray3.length > 0) {
                    iflag3 = 1;
                }
                var iflag4 = 0;
                if (vObjArray4.length > 0) {
                    iflag4 = 1;
                }

                for (var i = 0; i < public_treeJsonArray.length; i++) { 
                    
                    var vJson=public_treeJsonArray[i];
                    if (vJson.flag1 == iflag1 && vJson.flag2 == iflag2 && vJson.flag3 == iflag3 && vJson.flag4== iflag4) {
                        meter_idList.push(vJson.id);
                    }

                }
            }
            return meter_idList;
        }
        $(function () {


            $.ajax({
                type: "get",
                url: "../handler/InterFace.ashx?r="+Math.random(),
                data: {
                    method: "http_getMethod"
                   , MethodUrl: "/meters"
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

                        console.log(JSON2.stringify(data));
                        public_treeJsonArray = data; //装载进来

                    }
                }
            });

            $("#layout1").ligerLayout({ leftWidth: 350, topHeight: 240 });

            //加载layui 复选框
            layui.use(['layer', 'form', 'laydate'], function () {
                var form = layui.form;
                console.log(form)
                layer = layui.layer;
                var laydate = layui.laydate;
                laydate.render({
                    elem: '#time1'
                    , type: 'datetime'
                });
                laydate.render({
                    elem: '#time2'
                    , type: 'datetime'
                });

            });



            //装载树结构
            $("#ftree").attr("src", "../tree/allTree.aspx");
            //这里装载grid


            grid = $("#maingrid").ligerGrid({
                columns: [
                //{ display: '序号', name: 'taskId', align: 'center', width: 120 },
                    {display: '任务名称', name: 'taskName', minWidth: 60 },
                    { display: '编辑时间', name: 'createTime', width: 300 },
                    {
                        display: '操作', isSort: false, width: 400, render:
                            function (rowdata, rowindex, value) {
                                var h = '';
                                h += "<a href='javascript:liji_run(" + rowdata.id + ")'>立即执行</a> &nbsp&nbsp";
                                h += "<a href='javascript:dingqi_run(" + rowdata.id + ")'>定期执行</a> &nbsp&nbsp";
                                h += "<a href='javascript:zhouqi_run(" + rowdata.id + ")'>周期执行</a> ";
                                return h;
                            }
                    }
                ]
                //双击任务模板
                , onDblClickRow: function (data, rowindex, rowobj) {
                    getTaskTempletDetail(data.id);
                    updateId = data.id;  //保存当前行任务id
                }
                , rownumbers: true
                , pageSize: 15
                , pageSizeOptions: [15]
                , width: '100%'
                , checkbox: false
                , usePager: true
                , height: bodyHeight - 400
                , isSingleCheck: true
                , delayLoad: true
                , url: "../handler/loadGrid.ashx?view=http_getGridMethod_expend&methodName=taskTemplates&r=" + Math.random()
            });
            //这里是传参
            var vParaArray = [];
            vParaArray.push({ "key": "type", "value": public_miniType });
            grid.setParm("param1", JSON2.stringify(vParaArray));
            grid.reload();
            //显示一下数据

            //装载巡检类型
            $.ajax({
                type: "get",
                url: "../handler/InterFace.ashx?r="+Math.random(),
                data: {
                    method: "http_getMethod"
                   , MethodUrl: "/taskTemplateTypes"
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
                        var vHtml = "<p>巡检类型：";
                        var vHtml_mini = "<p>子巡检类型"
                        for (var i = 0; i < vLen; i++) {
                            if (data[i].id == public_type) {
                                if (data[i].name != "") {

                                    if (data[i].id == 1) {
                                        vHtml += "<input  type='radio' name='xjName' value='" + data[i].id + "' style='margin-left:35px;' checked />" + data[i].name + " ";
                                    } else {
                                        vHtml += "<input  type='radio' name='xjName' value='" + data[i].id + "' style='margin-left:157px;' checked />" + data[i].name + " ";
                                    }

                                    //这里装载子类型
                                    for (var j = 0; j < data[i].children.length; j++) {
                                        if (data[i].children[j].id == public_miniType) {
                                            if (public_miniType == 4) {
                                                vHtml_mini += "<input  type='radio' name='xjName_mini' value='" + data[i].children[j].id + "' style='margin-left:157px;' checked />" + data[i].children[j].name + " ";
                                            } else {
                                                vHtml_mini += "<input  type='radio' name='xjName_mini' value='" + data[i].children[j].id + "' style='margin-left:35px;' checked />" + data[i].children[j].name + " ";
                                            }

                                        }
                                        else {
                                            if (public_miniType == 4) {
                                                vHtml_mini += "<input  type='radio' name='xjName_mini' value='" + data[i].children[j].id + "' style='margin-left:35px;' disabled />" + data[i].children[j].name + " ";
                                            } else {
                                                vHtml_mini += "<input  type='radio' name='xjName_mini' value='" + data[i].children[j].id + "' style='margin-left:157px;' disabled />" + data[i].children[j].name + " ";
                                            }

                                        }
                                    }

                                    vHtml_mini += "</p>";
                                }
                            }
                            else {
                                if (data[i].name != "")
                                    if (data[i].id == 1) {
                                        vHtml += "<input  type='radio' name='xjName' value='" + data[i].id + "' style='margin-left:35px;' disabled />" + data[i].name + " ";
                                    } else {
                                        vHtml += "<input  type='radio' name='xjName' value='" + data[i].id + "' style='margin-left:157px;' disabled />" + data[i].name + " ";
                                    }
                            }
                        }

                        vHtml += "</p>";
                        $("#divHead0").html(vHtml);
                        $("#divHead5").html(vHtml_mini);
                    }
                }
            });



            //装载设备区域
            $.ajax({
                type: "get",
                url: "../handler/InterFace.ashx?r="+Math.random(),
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
                        var vHtml = "<div class='layui-input-inline' style='vertical-align:top;margin-top:5px;margin-right:5px;'>设备区域：</div><div class='layui-input-inline' style='width:95%'>";
                        for (var i = 0; i < vLen; i++) {
                            vHtml += "<div class='layui-input-inline' style='width:200px;margin-top:5px;margin-left:30px;'><input class='ever_areaName' type='checkbox' name='ck1' value='" + data[i].id + "' />" + data[i].areaName + " </div>";
                        }
                        vHtml += "</div>";
                        $("#divHead1").html(vHtml);
                    }
                    $(".ever_areaName").click(function () {
                        oncheckselectedProperty();
                    });
                    //alert(data);
                }
            });


            //装载设备类型
            $.ajax({
                type: "get",
                url: "../handler/InterFace.ashx?r="+Math.random(),
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
                        var vHtml = "<div class='layui-input-inline' style='vertical-align:top;margin-top:5px;margin-right:5px;'>设备类型：</div><div class='layui-input-inline' style='width:95%'>";
                        for (var i = 0; i < vLen; i++) {
                            vHtml += "<div class='layui-input-inline' style='width:200px;margin-top:5px;margin-left:30px;'><input class='ever_deviceType'  type='checkbox' name='ck1' value='" + data[i].deviceType + "' />" + data[i].deviceType + " </div>";
                        }
                        vHtml += "</div>";
                        $("#divHead2").html(vHtml);
                    }
                    $(".ever_deviceType").click(function () {
                        oncheckselectedProperty();
                    });
                }
            });


            //装载设备类型
            $.ajax({
                type: "get",
                url: "../handler/InterFace.ashx?r="+Math.random(),
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
                        var vHtml = "<div class='layui-input-inline' style='vertical-align:top;margin-top:5px;margin-right:5px;'>识别类型：</div><div class='layui-input-inline'  style='width:95%'>";
                        for (var i = 0; i < vLen; i++) {
                            vHtml += "<div class='layui-input-inline' style='width:200px;margin-top:5px;margin-left:30px;'><input class='ever_detectionName'  type='checkbox'  name='ck1' value='" + data[i].detectionName + "' />" + data[i].detectionName + " </div>";
                        }
                        vHtml += "</div>";
                        $("#divHead3").html(vHtml);
                    }
                    $(".ever_detectionName").click(function () {
                        oncheckselectedProperty();
                    });
                }
            });

            //装载表计类型
            $.ajax({
                type: "get",
                url: "../handler/InterFace.ashx?r="+Math.random(),
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
                        var vHtml = "<div class='layui-input-inline' style='vertical-align:top;margin-top:5px;margin-right:5px;'>表计类型：</div><div class='layui-input-inline'  style='width:95%'>";
                        for (var i = 0; i < vLen; i++) {
                            vHtml += "<div class='layui-input-inline' style='width:200px;margin-top:5px;margin-left:30px;'><input class='ever_meterType'  type='checkbox' name='ck1' value='" + data[i].meterType + "' />" + data[i].meterType + " </div>";
                        }
                        vHtml += "</div>";
                        $("#divHead4").html(vHtml);
                    }
                    $(".ever_meterType").click(function () {
                        oncheckselectedProperty();
                    });
                }
            });
            //searchDB();//装载grid

        });


        //这里是筛选属性点筛选方法
        function oncheckselectedProperty() {

            var vTreeObject = public_getTreeObject();
            vTreeObject.checkAllNodes(false);
            var vArray = from_treeJsonArrayGetMeterIdList();
            console.log(vArray);
            if (vArray.length > 0) {
                for (var i = 0; i < vArray.length; i++) {
                    var node = vTreeObject.getNodeByParam("no", "N"+vArray[i], null);
                    vTreeObject.checkNode(node, true, true);
                }
            }
        }




        //这里是根据表计id勾选左侧树的方法 既还原任务所有节点
        function selectedNodesOnTree(vArray) {

            if (vArray.length > 0) {

                var vTreeObject = public_getTreeObject();
                vTreeObject.checkAllNodes(false); //先默认都不选择
                for (var i = 0; i < vArray.length; i++) {
                    var node = vTreeObject.getNodeByParam("no", "N" + vArray[i], null);
                    vTreeObject.checkNode(node, true, true)
                }
            }
        }


        //查询符合条件的任务模板
        function searchDB() {

            //var vUrl = "/taskTemplates?type=" + public_miniType + "&pageNum=1&pageSize=15&orderBy=id";
            //$.ajax({
            //    type: "get",
            //    url: "../handler/InterFace.ashx?r="+Math.random(),
            //    data: {
            //        method: "http_getGridMethod_expend"
            //       , MethodUrl: vUrl
            //       , token: public_token
            //       , ListName: "list"  
            //    },
            //    dataType: "json",
            //    success: function (data) {
            //        dataAll = data;
            //        console.log(data);
            //        if (data.Rows == 0) {
            //            layer.msg("没有符合条件的数据") 
            //        } else {
            //            grid.set({ data: data });
            //        }

            //    }
            //});
        }

        //根据任务点位情况 过滤左侧多选点位树
        function getTaskTempletDetail(id) {
            //根据任务规划模板id 得到任务模板明细
            var vUrl = "/taskTemplates/" + id;
            var allMeters = [];
            console.log(id);
            $.ajax({
                type: "get",
                url: "../handler/InterFace.ashx?r="+Math.random(),
                data: {
                    method: "http_getMethod"
                   , MethodUrl: vUrl
                   , token: public_token
                },
                dataType: "json",
                success: function (data) {
                     if (!data.success ) {
                                         layer.msg(data.detail);
                                        return;

                                     }
                    data = data.data;
                    console.log(data);
                    //alert(data.meters);
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
            if (updateId == null || updateId == 0) {
                layer.msg("未选定任务");
                return;
            }

            
            var detail_task = $.ligerDialog.open({
                target: $("#div_task_save"),
                title: "保存任务模板",
                width: 300, top: 220,
                buttons: [
                {
                    text: '确定', onclick: function () {
                        var meters = getAllMetersSelected(); //得到所有的点位
                        //alert(meters);
                        var postData = "meters=" + meters;
                        $.ajax({
                            type: "post",
                            url: "../handler/InterFace.ashx?r="+Math.random(),
                            data: {
                                method: "http_PutMethod"
                                , token: public_token
                                , MethodUrl: "/taskTemplates/" + updateId
                                , postData: postData
                            },
                            dataType: "json",
                            success: function (data) {
                                //{success:"true","detail": "xxx"}
                                if (data) {
                                    if (data.success == true) {
                                        layer.msg("保存成功");
                                    }
                                    else {
                                        layer.msg(data.detail);
                                    }
                                }
                            }
                        });
                        detail_task.hide();
                    }
                },
                { text: '取消', onclick: function () { detail_task.hide(); } }
                ]
            });


        }


        //得到所有选取的点
        function getAllMetersSelected() {
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
            return arra.join(",");
        }


        function resetDB() {
            window.location.reload();
        }

        //立即执行任务设置
        function liji_run(taskTempletId) {

            var detail_task = $.ligerDialog.open({
                target: $("#div_task_create"),
                title: "提示",
                width: 300, top: 220,
                buttons: [
                {
                    text: '确定', onclick: function () {
                        //var postData = "taskTemplateId=" + taskTempletId + "&StartTime=" + CurentTime() + "&circle=0&repeat=0&isStart=1";
                        var postData = "";
                        $.ajax({
                            type: "post",
                            url: "../handler/InterFace.ashx?r="+Math.random(),
                            data: {
                                method: "http_PostMethod"
                                , token: public_token
                                , MethodUrl: "/taskManager/send/" + taskTempletId
                                , postData: postData
                            },
                            dataType: "json",
                            success: function (data) {
                                console.log(data);
                                //{success:"true","detail": "xxx"}
                                if (data) {
                                    if (data.success == true) {
                                        layer.msg("任务设定成功");
                                    }
                                    else {
                                        layer.msg(data.detail);
                                    }
                                }
                            }
                        });
                        detail_task.hide();
                    }
                },
                { text: '取消', onclick: function () { detail_task.hide(); } }
                ]
            });

        }

        function CurentTime() { 

            var now = new Date();
        
            var year = now.getFullYear();       //年
            var month = now.getMonth() + 1;     //月
            var day = now.getDate();            //日
        
            var hh = now.getHours();            //时
            var mm = now.getMinutes();          //分
            var ss = now.getSeconds();           //秒
        
            var clock = year + "-";
        
            if(month < 10)
                clock += "0";
        
            clock += month + "-";
        
            if(day < 10)
                clock += "0";
            
            clock += day + " ";
        
            if(hh < 10)
                clock += "0";
            
            clock += hh + ":";
            if (mm < 10) clock += '0'; 
            clock += mm + ":"; 
         
            if (ss < 10) clock += '0'; 
            clock += ss; 
            return(clock); 
         }

        //定期任务设置
        function dingqi_run(taskTempletId) {
            //首先根据任务模板id 读取任务模板信息到界面
            $.ajax({
                type: "get",
                url: "../handler/InterFace.ashx?r="+Math.random(),
                data: {
                    method: "http_getMethod"
                   , MethodUrl: "/taskTemplates/" + taskTempletId
                   , token: public_token
                },
                dataType: "json",
                success: function (data) {
                    if (!data.success ) {
                    layer.msg(data.detail);
                    return;
                    }
                    data = data.data;
                    console.log(data);
                    if (data.Rows == 0) {
                        layer.msg("没有符合条件的数据")
                    } else {
                        //把任务显示到新界面
                        console.log(data.taskName);
                        $("#TaskName_dingqi").val(data.taskName);
                        $("#TaskName_dingqi").attr("disabled",true);

                        var detail_dingqi = $.ligerDialog.open({
                            target: $("#div_dingqirun"),
                            title: "定期执行设定",
                            width: 500, top: 150,
                            buttons: [
                            {
                                text: '确定', onclick: function () {
                                    if ($("#time1").val() == "") {
                                        layer.msg("任务时间必填");
                                        return;
                                    }
                                    
                                    //点击确定 发送post 设定定期任务
                                    var time = $("#time1").val();
                                    var start = 0;
                                    if ($("#start_dingqi").attr("checked") == "checked") //判断是否选择启动
                                        start = 1;

                                    var postData = "taskTemplateId=" + taskTempletId + "&StartTime=" + time + "&circle=0&repeat=0&isStart=" + start;
                                    //alert(postData);
                                    $.ajax({
                                        type: "post",
                                        url: "../handler/InterFace.ashx?r="+Math.random(),
                                        data: {
                                            method: "http_PostMethod"
                                            , token: public_token
                                            , MethodUrl: "/taskPlans"
                                            , postData: postData
                                        },
                                        dataType: "json",
                                        success: function (data) {
                                            //{success:"true","detail": "xxx"}
                                            if (data) {
                                                if (data.success == true) {
                                                    layer.msg("任务设定成功");
                                                }
                                                else {
                                                    layer.msg(data.detail);
                                                }
                                            }
                                        }
                                    });
                                    detail_dingqi.hide();
                                }
                            },
                            { text: '取消', onclick: function () { detail_dingqi.hide(); } }
                            ]
                        });
                        //把任务显示到新界面完
                    }
                }
            });

        }

        //周期执行任务设置
        function zhouqi_run(taskTempletId) {
            //首先根据任务模板id 读取任务模板信息到界面
            $.ajax({
                type: "get",
                url: "../handler/InterFace.ashx?r="+Math.random(),
                data: {
                    method: "http_getMethod"
                   , MethodUrl: "/taskTemplates/" + taskTempletId
                   , token: public_token
                },
                dataType: "json",
                success: function (data) {
                     if (!data.success ) {
                                         layer.msg(data.detail);
                                        return;

                                     }
                    data = data.data;
                    console.log(data);
                    if (data.Rows == 0) {
                        layer.msg("没有符合条件的数据");
                    } else {
                        //把任务显示到新界面
                        console.log(data.taskName);
                        $("#TaskName_zhouqi").val(data.taskName);
                        $("#TaskName_zhouqi").attr("disabled",true);
                        var detail_zhouqi = $.ligerDialog.open({
                            target: $("#div_zhouqirun"),
                            title: "周期执行设定",
                            width: 500, top: 150,
                            buttons: [
                            {
                                text: '确定', onclick: function () {
                                    if ($("#time2").val() == "") {
                                        layer.msg("任务时间必填");
                                        return;
                                    }
                                    if ($("#circleNum").val() == "") {
                                        layer.msg("间隔数必填");
                                        return;
                                    }
                                    //点击确定 发送post 设定定期任务
                                    var time = $("#time2").val(); //得到开始时间
                                    var hours = getCircleHours(); //得到间隔小时数
                                    var start = 0;
                                    if ($("#start_zhouqi").attr("checked") == "checked") //判断是否选择启动
                                        start = 1;

                                    var postData = "taskTemplateId=" + taskTempletId + "&StartTime=" + time + "&circle=" + hours + "&repeat=1&isStart=" + start;
                                    //alert(postData);
                                    $.ajax({
                                        type: "post",
                                        url: "../handler/InterFace.ashx?r="+Math.random(),
                                        data: {
                                            method: "http_PostMethod"
                                            , token: public_token
                                            , MethodUrl: "/taskPlans"
                                            , postData: postData
                                        },
                                        dataType: "json",
                                        success: function (data) {
                                            //{success:"true","detail": "xxx"}
                                            if (data) {
                                                if (data.success == true) {
                                                    layer.msg("任务设定成功");
                                                }
                                                else {
                                                    layer.msg(data.detail);
                                                }
                                            }
                                        }
                                    });
                                    detail_zhouqi.hide();
                                }
                            },
                            { text: '取消', onclick: function () { detail_zhouqi.hide(); } }
                            ]
                        });
                        //把任务显示到新界面完
                    }
                }
            });
        }

        //获得周期值（计算后的）
        function getCircleHours() {
            var hours = 0;

            var modules = $("#modules").val();
            var circleNum = $("#circleNum").val();

            if (modules == "hour") {
                hours = circleNum;
            }
            else if (modules == "day") {
                hours = circleNum * 24;
            }
            else if (modules == "week") {
                hours = circleNum * 24 * 7;
            }
            return hours;
        }
        
    </script>

</head>
<body>
    <form id="form1" runat="server">
        <div id="layout1">

            <div position="top" id="divHead" style="margin-top:5px">
                <div id="divHead0">
                    <p>
                        巡检类型：
                        <input type="radio" value="1" style="margin-left: 30px;"/>全面巡检
                        <input type="radio" disabled style="margin-left: 30px;"/>例行巡检
                        <input type="radio" disabled style="margin-left: 30px;"/>专项巡检
                        <input type="radio" disabled style="margin-left: 30px;"/>特殊巡检
                    </p>
                </div>
                <div id="divHead5" >
                    <p >
                        子巡检类型：
                        <input type="radio" name="zileixing" style="margin-left: 30px;"/>细分类型
                        <input type="radio" name="zileixing" style="margin-left: 30px;"/>细分类型
                        <input type="radio" name="zileixing" style="margin-left: 30px;"/>细分类型
                        <input type="radio" name="zileixing" style="margin-left: 30px;"/>细分类型
                    </p>
                </div>
                <div id="divHead1"></div>
                <div id="divHead2" style="margin-top:5px"></div>
                <div id="divHead3" style="margin-top:5px"></div>
                <div id="divHead4" style="margin-top:5px"></div>

            </div>
            <div position="left" title="点位树" style="padding-left: 10px">
                <iframe id="ftree" frameborder="0" height="565px" width="100%" src="kong.htm"></iframe>
            </div>

            <div position="center" title="任务编辑列表">
                
                <%--定期执行弹窗--%>
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
                                <input type="text" name="title" id="TaskName_dingqi" lay-verify="title" autocomplete="off" placeholder="请输入设定路线" class="layui-input">
                            </div>
                        </div>
                        <div class="layui-form-item">
                            <label class="layui-form-label">任务时间</label>
                            <div class="layui-input-block">
                                <input type="text" class="layui-input" id="time1" placeholder="HH:mm:ss" >
                            </div>
                        </div>
                        <div class="layui-form-item">
                            <label class="layui-form-label">是否启动</label>
                            <div class="layui-input-block">
                                <input type="checkbox" name="like[qidong]" id="start_dingqi" title="是否启动" checked>
                            </div>
                        </div>
                        <%--<div class="layui-form-item">
                            <label class="layui-form-label">优先级</label>
                            <div class="layui-input-block">
                                <input type="text" name="title" lay-verify="title" autocomplete="off" placeholder="请输入优先级" class="layui-input">
                            </div>
                        </div>--%>
                    </div>
                </div>

                <%--周期执行弹窗--%>
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
                                <input type="text" name="title" id="TaskName_zhouqi" lay-verify="title" autocomplete="off" placeholder="请输入设定路线" class="layui-input">
                            </div>
                        </div>
                        
                        <div class="layui-form-item">
                            <label class="layui-form-label">任务时间</label>
                            <div class="layui-input-block">
                                <input type="text" class="layui-input" id="time2" placeholder="HH:mm:ss" >
                            </div>
                        </div>

                        <div class="layui-form-item">
                            <label class="layui-form-label">重复类型</label>
                            <div class="layui-input-inline">
                                <select name="modules" id="modules" lay-verify="required" lay-search="">
                                    <option value="hour">小时</option>
                                    <option value="day">天</option>
                                    <option value="week">周</option>
                                    <%--<option value="month">每月</option>--%>
                                </select>
                            </div>
                        </div>

                        <div class="layui-form-item">
                            <label class="layui-form-label">间隔数</label>
                            <div class="layui-input-block">
                                <input type="text" name="circleNum" id="circleNum" lay-verify="title" autocomplete="off" placeholder="请输入间隔数" class="layui-input">
                            </div>
                        </div>

                        <div class="layui-form-item">
                            <label class="layui-form-label">是否启动</label>
                            <div class="layui-input-block">
                                 <input type="checkbox" name="like1[write]" id="start_zhouqi"  title="是否启动" checked>
                            </div>
                        </div>

                        <%--<div class="layui-form-item">
                            <label class="layui-form-label">优先级</label>
                            <div class="layui-input-block">
                                <input type="text" name="title" lay-verify="title" autocomplete="off" placeholder="请输入优先级" class="layui-input">
                            </div>
                        </div>--%>
                    </div>
                </div>

                <%--<div id="div_zhouqirun2" style="display: none; text-align: left; line-height: 30px; padding-left: 50px;">
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
                </div>--%>

                <div id="div_task_create" style="display: none; text-align: left; line-height: 30px; padding-left: 50px;">
                    <p>确定创建立即执行任务吗?</p>
                </div>


                <div id="div_task_save" style="display: none; text-align: left; line-height: 30px; padding-left: 50px;">
                    <p>确定保存任务模板吗?</p>
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
