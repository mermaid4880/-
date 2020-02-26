<%@ Page Language="C#" AutoEventWireup="true" CodeFile="设备告警查询确认.aspx.cs" Inherits="pages_设备告警查询确认" %>


<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title>设备告警查询确认</title>
    <link href="../lib/ligerUI/skins/Aqua/css/ligerui-all.css" rel="stylesheet" type="text/css" />
    <link href="../lib/ligerUI/skins/Gray2014/css/all.css" rel="stylesheet" type="text/css" />
    <script src="../js/jquery-1.8.3.min.js" type="text/javascript"></script>
    <script src="../lib/ligerUI/js/core/base.js" type="text/javascript"></script>

    <link href="../js/layui/css/layui.css" rel="stylesheet" type="text/css" />
    <script src="../js/layer/layer.js" type="text/javascript"></script>
    <script src="../js/layui/layui.js" type="text/javascript"></script>

    <script src="../lib/ligerUI/js/plugins/ligerLayout.js" type="text/javascript"></script>
    <script src="../lib/ligerUI/js/plugins/ligerGrid.js" type="text/javascript"></script>
    <script src="../lib/ligerUI/js/ligerui.min.js"></script>
    <script type="text/javascript" src="../js/jquery/jquery.tips.js"></script>

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
            height: 30px;
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
          .showMsgBox
        {
            
            width:1400px;
            height:400px;
            background-color:Gray;
            overflow:auto;
            }
        .imgStyle
        {
            width:300px;
            height:200px;
            margin:10px;
            
            }
        .spDivBox
        {
            position:absolute;
            bottom:0px;
            right:0px;
            width:120px;
            height:50px;
            }
        .l-bar-selectpagesize{
            display:none !important;
        }
    </style>


    <script type="text/javascript">
        var taskType = "qmxj";
        var public_token = "<%=public_token %>";
        var public_userName = "<%=public_userName%>";
        var grid = null;
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

                //console.log(public_treeJsonArray);

                for (var i = 0; i < public_treeJsonArray.length; i++) {
                    public_treeJsonArray[i].flag1 = 0; //给他们添加一个key 并复制
                    public_treeJsonArray[i].flag2 = 0; //给他们添加一个key 并复制
                    public_treeJsonArray[i].flag3 = 0; //给他们添加一个key 并复制
                    public_treeJsonArray[i].flag4 = 0; //给他们添加一个key 并复制
                }
               

                for (var i = 0; i < public_treeJsonArray.length; i++) {
                    if (vObjArray1.length > 0) {
                        for(var j=0;j<vObjArray1.length;j++){

                            var vId = $(vObjArray1[j]).val().replace('N',""); //这是获取id
                            //console.log(vId);
                            for (var x = 0; x < public_treeJsonArray[i].parentAreaIds.length; x++) {
                                //console.log(public_treeJsonArray[i].parentAreaIds[x].toString());
                                if (vId == public_treeJsonArray[i].parentAreaIds[x].toString()) {
                                    public_treeJsonArray[i].flag1 = 1; //说明有这个
                                    break;
                                }
                            }
                        }
                    }
                    if (vObjArray2.length > 0) {
                        for (var j = 0; j < vObjArray2.length; j++) {

                            var vId = $(vObjArray2[j]).val().replace('N', ""); //这是获取id
                            if (public_treeJsonArray[i].deviceType==vId) {
                                public_treeJsonArray[i].flag2 = 1; //说明有这个
                                break;

                            }
                        }
                    }
                    if (vObjArray3.length > 0) {
                        for (var j = 0; j < vObjArray3.length; j++) {

                            var vId = $(vObjArray3[j]).val().replace('N', ""); //这是获取id
                            if (public_treeJsonArray[i].detectionType == vId) {
                                public_treeJsonArray[i].flag3 = 1; //说明有这个
                                break;

                            }
                        }
                    }
                    if (vObjArray4.length > 0) {
                        for (var j = 0; j < vObjArray4.length; j++) {

                            var vId = $(vObjArray4[j]).val().replace('N', ""); //这是获取id
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
                url: "../handler/InterFace.ashx?r=" + Math.random(),
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
                        public_treeJsonArray = data; //装载进来
                    }
                }
            });

            $("#layout1").ligerLayout({ leftWidth: 350, topHeight: 220 });
            
            //装载树结构
            $("#ftree").attr("src", "../tree/allTree.aspx");

            //这里装载grid 绑定表格列
            grid = $("#maingrid").ligerGrid({
                columns: [
                    { display: '识别类型', name: 'saveType',   minWidth: 220 },
                    { display: '点位名称', name: 'meterName',  width: 370 },
                    { display: '识别结果', name: 'detectionValue', width: 220 },
                    { display: '告警等级', name: 'detectionStatus', width: 220 },
                    { display: '识别时间', name: 'time', width: 220  },
                    { display: '审核状态', name: 'checkStatus', width: 220  }
                ]
                , checkbox: true
                , pageSize: 15
                , usePager:true
                , pageSizeOptions:[15]//可指定每页页面大小
                , width: '100%'
                , height: bodyHeight - 370
                , url: "../handler/loadGrid.ashx?view=http_getGridMethod_expend&methodName=detectionDatas"
                //添加一个双击回调
                , onDblClickRow: function (data, rowindex, rowobj) {
                    detail(data)
                }
                , delayLoad: true
            });

            getChecks();

        });


        function getChecks() {

            //装载设备区域
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
                        var vHtml = "<div class='layui-input-inline' style='vertical-align:top;margin-top:5px;margin-right:5px;'>设备区域：</div><div class='layui-input-inline' style='width:95%'>";
                        for (var i = 0; i < vLen; i++) {
                            vHtml += "<div class='layui-input-inline' style='width:200px;margin-top:5px;margin-left:30px;'><input class='ever_areaName' data='" + data[i].areaName + "' type='checkbox' name='ck1' value='" + data[i].id + "' />" + data[i].areaName + " </div>";
                        }
                        vHtml += "</div>";
                        $("#divHead1").html(vHtml);
                    }
                    $(".ever_areaName").click(function () {
                        oncheckselectedProperty()
                    });
                    //alert(data);
                }
            });


            //装载设备类型
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
                        var vHtml = "<div class='layui-input-inline' style='vertical-align:top;margin-top:5px;margin-right:5px;'>设备类型：</div><div class='layui-input-inline' style='width:95%'>";
                        for (var i = 0; i < vLen; i++) {
                            vHtml += "<div class='layui-input-inline' style='width:200px;margin-top:5px;margin-left:30px;'><input class='ever_deviceType' data='" + data[i].areaName + "' type='checkbox' name='ck1' value='" + data[i].deviceType + "' />" + data[i].deviceType + " </div>";
                        }
                        vHtml += "</div>";
                        $("#divHead2").html(vHtml);
                    }
                    $(".ever_deviceType").click(function () {
                        oncheckselectedProperty()
                    });
                }
            });


            //装载设备类型
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
                        var vHtml = "<div class='layui-input-inline' style='vertical-align:top;margin-top:5px;margin-right:5px;'>识别类型：</div><div class='layui-input-inline'  style='width:95%'>";
                        for (var i = 0; i < vLen; i++) {
                            vHtml += "<div class='layui-input-inline' style='width:200px;margin-top:5px;margin-left:30px;'><input class='ever_detectionName' data='" + data[i].areaName + "' type='checkbox'  name='ck1' value='" + data[i].detectionName + "' />" + data[i].detectionName + " </div>";
                        }
                        vHtml += "</div>";
                        $("#divHead3").html(vHtml);
                    }
                    $(".ever_detectionName").click(function () {
                        oncheckselectedProperty()
                    });
                }
            });

            //装载表计类型
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
                        var vHtml = "<div class='layui-input-inline' style='vertical-align:top;margin-top:5px;margin-right:5px;'>表计类型：</div><div class='layui-input-inline'  style='width:95%'>";
                        for (var i = 0; i < vLen; i++) {
                            vHtml += "<div class='layui-input-inline' style='width:200px;margin-top:5px;margin-left:30px;'><input class='ever_meterType' data='" + data[i].areaName + "' type='checkbox' name='ck1' value='" + data[i].meterType + "' />" + data[i].meterType + " </div>";
                        }
                        vHtml += "</div>";
                        $("#divHead4").html(vHtml);
                    }
                    $(".ever_meterType").click(function () {
                        oncheckselectedProperty(); //通过属性来选择
                    });
                }
            });
        }

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

        //这里是筛选方法
        function oncheckselected(thisv) {

            var vTreeObject = public_getTreeObject();
            var boolv = thisv.prop("checked");
            //var vTreeObject = ftree.contentWindow.zTreeObj;
            var node = vTreeObject.getNodeByParam("name", thisv.attr("data"), null);
            boolv ? vTreeObject.checkNode(node, true, true) : vTreeObject.checkNode(node, false, true);

        }

        ////获取勾选的点位信息 陈毅
        //var Pid = [];
        //function public_page_click(v) {
        //    pid = v;
        //    alert(pid);
        //};


        function searchDB() {

            var  startTime = $("#beginDt").val();
            var endTime = $("#endDt").val();

            var meters = getAllMetersSelected();
            if (meters.length <= 0) {
                return;
            }
            //这里是传参
            var vParaArray = [];
            vParaArray.push({ "key": "startDate", "value": startTime });
            vParaArray.push({ "key": "endDate", "value": endTime });
            vParaArray.push({ "key": "meterIDs", "value": meters });
            vParaArray.push({ "key": "status", "value": getAllStatus() });
            grid.setParm("param1", JSON2.stringify(vParaArray));
            grid.reload( );

        }

        //加载layui 复选框
         layui.use(['layer', 'form', 'laydate'], function () {
                var form = layui.form;
                layer = layui.layer;
                var laydate = layui.laydate;
                laydate.render({
                    elem: '#beginDt' //指定元素
                    , value: getCurrentAddDayYMD(-30)
                });
                laydate.render({
                    elem: '#endDt' //指定元素
                    , value: getCurrentAddDayYMD(0)
                });
        });

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
                $.ligerDialog.warn('请选择节点');
                return "";
            }
            return arra.join(",");
        }


        //获取所有状态条件 URL转码了
        function getAllStatus() {
            var status = [];
            if ($("#checkbox1").attr("checked")) {
                status.push("正常");
            }
            if ($("#checkbox2").attr("checked")) {
                status.push("预警");
            }
            if ($("#checkbox3").attr("checked")) {
               status.push("一般告警");
            }
            if ($("#checkbox4").attr("checked")) {
                status.push("严重告警");
            }
            if ($("#checkbox5").attr("checked")) {
                status.push("危急告警");
            }
            strStatus = encodeURI(status.join(','));

            //alert(strStatus);
            return strStatus;
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

        //双击响应方法 弹出页面 显示单条巡检记录明细
        function detail(data) { 
            //巡检结果读取到界面
            if (data.meterName != null) {
                $("#detail-describ").html(data.meterName);
            }
            if (data.meterName != null) {
                $("#detail-img1").attr("src",data.irpath);
                $("#detail-img2").attr("src",data.valuePath);
                $("#detail-audio").attr("src",data.voicePath); 
            }
            if (data.detectionValue != null) {
                $("#detail-result").html(data.detectionValue);
            }
            if (data.detectionStatus != null) {
                $("detail-warn").val(data.detectionStatus);
            } else {
                $("detail-warn").val("");
            }
            

            //通过id获取审核数据 
            $.ajax({
                type: "post",
                url: "../handler/InterFace.ashx?r=" + Math.random(),
                data: {
                    method: "http_getMethod"
                    , token: public_token
                    , MethodUrl: "/checkDetectionDatas/" + data.id
                },
                dataType: "json",
                success: function (checkdata) {
                    if (!checkdata.success ) {
                    layer.msg(checkdata.detail);
                    return;
                    }
                    checkdata = checkdata.data;
                    //如果有审核数据 则读取到界面
                    if (checkdata) {
                        //读用户编辑后的真实值
                        if (checkdata.checkValue != null) {
                            $("#detail-value").attr("value", checkdata.checkValue);
                        } else {
                            $("#detail-value").attr("value", "");
                        }
                        //用表计数和编辑数对比 判断结果是否正确
                        //alert(checkdata.checkValue);
                        //alert(data.detectionValue);
                        if (checkdata.checkValue != null && checkdata.checkValue != "") {
                            if (data.detectionValue == null || data.detectionValue == "") {
                                $("input[name='shibie']").eq(1).click();
                            }
                            else {
                                if (data.detectionValue != checkdata.checkValue)
                                    $("input[name='shibie']").eq(1).click();
                                else
                                    $("input[name='shibie']").eq(0).click();
                            }
                        } else {
                            $("input[name='shibie']").eq(0).click();
                        }
                        //读取编辑后的状态 （覆盖原有状态）
                        if (checkdata.checkRiseStatus != null && checkdata.checkRiseStatus != "") {
                            $("#detail-warn").val(checkdata.checkRiseStatus);
                        } else {
                            $("#detail-warn").val("");
                        }
                    }

                    //正式打开刚才编辑的界面
                    var detail_dingqi = $.ligerDialog.open({
                        target: $("#div_detail"),
                        title: "任务审核",
                        width: 700, top: 0,
                        buttons: [
                        {
                            text: '保存', onclick: function () {
                                var vTrueValue = $("#detail-value").val();
                                var vTrueStatus = $("#detail-warn").find("option:selected").text(); 

                                var status = "已确认";
                                if (vTrueValue != null && vTrueValue != "")
                                    status = "已修改"
                                var postData = "state=" + encodeURI(status) + "&checkValue=" + vTrueValue + "&checkRiseStatus="
                                    + vTrueStatus + "&userName=" + public_userName + "&detectionDataId=" + data.id;
                                //alert(postData);
                                $.ajax({
                                    type: "post",
                                    url: "../handler/InterFace.ashx",
                                    data: {
                                        method: "http_PostMethod"
                                        , token: public_token
                                        , MethodUrl: "/checkDetectionDatas"
                                        , postData: postData
                                    },
                                    dataType: "json",
                                    success: function (data) {
                                        //{success:"true","detail": "xxx"}
                                        layer.msg(data.detail);
                                        detail_dingqi.hide();
                                    }
                                });
                            }
                        },
                        { text: '取消', onclick: function () { detail_dingqi.hide(); } }
                        ]
                    });
                }
            });
        }

        function confirmAll() {

            var vSelecteds = grid.getSelectedRows();
            if (vSelecteds.length == 0) {
                layer.msg("请选择需要批量处理的数据");
                return;
            }

            var vSelectValue = "";
            $.each(vSelecteds, function (i, n) {
                if(vSelectValue){
                    vSelectValue += ","+n.id;
                }
                else{
                    vSelectValue += n.id;
                }
            })
            if (!vSelectValue) {
                layer.msg("没有选择有效数据");
                return;
            }

            layer.confirm("确定要批量审批[" + vSelecteds.length + "]条数据吗？", {
                btn: ['确定', '取消'] //按钮
            }, function () {
                var postData = "detectionDataIds=" + vSelectValue + "&userName=" + public_userName;
                //alert(postData);
                $.ajax({
                    type: "post",
                    url: "../handler/InterFace.ashx",
                    data: {
                        method: "http_PostMethod"
                        , token: public_token
                        , MethodUrl: "/checkDetectionDatas/batch"
                        , postData: postData
                    },
                    dataType: "json",
                    success: function (data) {
                        //{success:"true","detail": "xxx"}
                        layer.msg(data.detail);
                    }
                });
                
            });

            

        }

    </script>

</head>
<body>
    <form id="form1" runat="server">
        <div id="layout1">
            

            <div position="top" id="divHead" >
                <div id="divHead1" style="margin-top:5px"></div>
                <div id="divHead2" style="margin-top:5px"></div>
                <div id="divHead3" style="margin-top:5px"></div>
                <div id="divHead4" style="margin-top:5px"></div>
                <div id="divHead5" style="margin-top:5px">
                    <div class='layui-input-inline' style='vertical-align:top;margin-top:5px;margin-right:30px;'>告警等级：</div>
                    <div class='layui-input-inline' style='width:226px;margin-top:5px'><input type="checkbox" id="checkbox1"  value="正常"/>正常</div>
                    <div class='layui-input-inline' style='width:226px;margin-top:5px'><input type="checkbox" id="checkbox2"  />预警</div>
                    <div class='layui-input-inline' style='width:226px;margin-top:5px'><input type="checkbox" id="checkbox3"  />一般告警</div>
                    <div class='layui-input-inline' style='width:226px;margin-top:5px'><input type="checkbox" id="checkbox4"  />严重告警</div>
                    <div class='layui-input-inline' style='width:226px;margin-top:5px'><input type="checkbox" id="checkbox5"  />危急告警</div>
                </div>
            </div> 


            <div position="left" title="点位树" style="padding-left: 10px">
                <iframe id="ftree" frameborder="0" height="593px" width="100%" src="kong.htm"></iframe>
            </div>

            <div position="center" title="巡检结果列表">
            </div>

            
            <div position="center" title="">
                <!--这里是弹出框-->
                <div id="div_detail" style="display: none; text-align: left; line-height: 30px; padding-left: 50px;">
                    <div style="width: 50%; float: left;">
                        <p>点位信息：<span id="detail-describ"></span></p>
                        <p>
                            可见光图片：<br />
                            <img id="detail-img1" src="" style="width: 192px; height: 108px;" />
                        </p>
                        <p>
                            红外图片：<br />
                            <img id="detail-img2" src="" style="width: 192px; height: 108px;" />
                        </p>
                        <p>
                            音频文件：<br />
                            <audio id="detail-audio" src="" style="width: 400px; height: 108px;" controls="controls"></audio>
                        </p>
                    </div>

                    <div style="width: 50%; float: left; margin-top: 50px;">
                        <p>
                            识别结果：<span  id="detail-result"></span>
                        </p>
                        <p style="margin-top:50px;" >
                            告警等级：
                            <select id="detail-warn">
                                    <option value="正常">正常</option>
                                    <option value="预警">预警</option>
                                    <option value="一般告警">一般告警</option>
                                    <option value="严重告警">严重告警</option>
                                    <option value="危急告警">危急告警</option>
                             </select>       
                        </p>
                        <p style="margin-top:50px;" >
                            <div class="layui-block">
                                识别正确
                                <input type="radio" name="shibie" value="识别正确" id="sbzq" title="识别正确" checked="checked">
                                    &nbsp;&nbsp;&nbsp;&nbsp;
                                识别错误
                                <input type="radio" name="shibie" value="识别错误" id="sbcw" title="识别错误" >
                            </div>
                        </p>
                        <p style="margin-top:50px;">
                            实际值：<input id="detail-value" data-type="text" data-label="实际值" style="height: 20px; line-height: 20px;" />
                        </p>
                    </div>
                </div>

                <div id="div_task" style="display: none; text-align: left; line-height: 30px; padding-left: 50px;">
                    <p>任务名称：<input data-type="text" id="taskName" /></p>
                </div>

                <div class="layui-form-item" >
                    <div class="layui-form-item" style="padding-top: 10px;">
                        <label class="layui-form-label">开始时间</label>
                        <div class="layui-input-inline" style="width:100px">
                                <input type="text" class="layui-input" id="beginDt">
                        </div>
                        <label class="layui-form-label">结束时间</label>
                        <div class="layui-input-inline" style="width:100px">
                                <input type="text" class="layui-input" id="endDt">
                        </div>

                        <div class="layui-input-inline" style="width: 80px">
                            <input type="button" class="layui-btn"  value="查询" onclick="searchDB()"></input>
                        </div>
                       
                        <div class="layui-input-inline" style="width: 110px">
                            <input type="button" class="layui-btn"   value="批量确认" onclick="confirmAll()"></input>
                        </div>

                        <div class="layui-input-inline" style="width: 80px">
                            <input type="button" class="layui-btn layui-btn-normal"  value="重置" onclick="resetDB()"></input>
                        </div>

                        <%--<div class="layui-input-inline" style="width: 80px">
                            <input type="button" class="layui-btn layui-btn-warm"   value="导出" onclick="export_excel()"></input>
                        </div>--%>

                    </div>
                </div>

                <div id="maingrid" style="margin: 0; padding: 0"></div>

            </div>

        </div>

    </form>




</body>
</html>
