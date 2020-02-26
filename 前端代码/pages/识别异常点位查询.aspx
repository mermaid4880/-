<%@ Page Language="C#" AutoEventWireup="true" CodeFile="识别异常点位查询.aspx.cs" Inherits="pages_识别异常点位查询" %>


<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title>识别异常点位查询</title>
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
        .l-bar-selectpagesize{
            display:none !important;
        }

    </style>


    <script type="text/javascript">
        var excelUrl = ""; //定义导出excel需要的url 也就是请求的url 将url告诉后端 即可轻松导出
        var dataAll;
        var taskType = "qmxj";
        var public_token = "<%=public_token %>";
        var public_userName = "<%=public_userName%>";
        var grid = null;
        var bodyHeight = document.documentElement.clientHeight; //页面高度
        $(function () {

            $("#layout1").ligerLayout({ leftWidth: 400});
            
            //装载树结构
            $("#ftree").attr("src", "../tree/allTree.aspx");

            //这里装载grid 绑定表格列
            grid = $("#maingrid").ligerGrid({
                columns: [
                    //{ display: '序号', name: '',   width: 60 },
                    { display: '点位名称', name: 'meterName',  width: 400 },
                    { display: '识别类型', name: 'detectionType', width: 240 },
                    { display: '原始结果', name: 'detectionValue', width: 240 },
                    { display: '审核结果', name: 'checkDetectionData.checkValue', width: 240  },
                    { display: '采集信息', name: 'saveType', width: 240  }
                ]
                , rownumbers: true
                , checkbox: false
                , pageSize: 15
                , usePager:true
                , pageSizeOptions:[15,30,50,100]//可指定每页页面大小
                , width: '100%'
                , height: bodyHeight - 142
                , url: "../handler/loadGrid.ashx?view=http_getGridMethod&methodName=unusual"
                , delayLoad: true
                //添加一个双击回调
                , onDblClickRow: function (data, rowindex, rowobj) {
                  // detail(data)
                }
            });

        });


         function status(obj) {
          
           // $(obj).children("div").css({ "background": "red" });
            $(obj).children("div").toggleClass("layui-form-checked");
            var checkall = $(obj).children("input").is(':checked');
            console.log(checkall);
            if (checkall==true) {
                 $(obj).children("input").prop("checked",false);
            } else {
                $(obj).children("input").prop("checked",true);
            }

           
       
           // $(obj).css({ "background": "red" });
            // $(this).addClass("currentli").siblings().removeClass();
        }
         function export_excel() {
            $("#show").html("");
              var vUrl = "/report/fields";
              $.ajax({
                    type: "post",
                    url: "../handler/InterFace.ashx?r=" + Math.random(),
                    data: {
                         method: "http_PostMethod"
                        , token: public_token
                        , MethodUrl: vUrl
                        , postData:''
                       
                    },
                    dataType: "json",
                    success: function (data) {
                        if (!data.success) {
                            layer.msg(data.detail);
                            return;
                        }
                        data = data.data;
                        var mm = "";
                        for (var j = 0; j < data.length; j++) {    
                            mm += "<div class='layui-input-inline' style='width:150px' onclick='status(this)' ><input type='checkbox'  name='colName'  title='" + data[j].fieldName + "' value=" + data[j].fieldLabel + "   checked>";
                            mm += "<div class='layui-unselect layui-form-checkbox layui-form-checked'  lay-skin=''><span>" + data[j].fieldName + "</span><i class='layui-icon'></i></div></div>";
                        }

                        $("#show").append(mm);
                            var export_excel = $.ligerDialog.open({
                                target: $("#div_export"),
                                title: "选择导出列",
                                width: 1700, top: 150,
                                buttons: [
                                {
                                    text: '导出', onclick: function () {

                                    daochu(); 

                                    //导出完毕后关闭弹出框
                                    export_excel.hide();
                                    //} else { layer.msg("请选择导出列"); }
                         
                                    }
                                },
                                { text: '取消', onclick: function () { export_excel.hide(); } }
                                ]
                            });
                    }
               });
        }
        
        function daochu() {
            
            var strgetSelectValue="";
            var getSelectValueMenbers = $("input[name='colName']:checked").each(function(j) {
                if (j >= 0) {
                    strgetSelectValue += $(this).val() + ","
                }
            });

            if (strgetSelectValue == null || strgetSelectValue == "") {
                layer.msg("未选择任何列");
                return;
            }
            if (excelUrl == null || excelUrl == "") {
                layer.msg("请先搜索");
                return;
            }

            strgetSelectValue = strgetSelectValue.substring(0, strgetSelectValue.length - 1);
            //alert(strgetSelectValue);

            var vUrl = "/report/point";
            var postData = "fields=" + strgetSelectValue + "&url=" + excelUrl;
            //alert(postData);
            $.ajax({
                type: "post",
                url: "../handler/InterFace.ashx?r=" + Math.random(),
                data: {
                    method: "http_PostMethod"
                    ,token: public_token
                    , MethodUrl: vUrl
                    , postData: postData
                },
                dataType: "json",
                success: function (data) {
                    alert(JSON.stringify(data));
                    //处理返回值
                    if (data) {
                        if (!data.success) {
                            layer.msg(data.detail);
                            return;
                        }
                        var savaExcelUrl = data.data;
                        //下面保存 未完成
                        //alert(savaExcelUrl);

                        window.open(savaExcelUrl, '_parent');
                        //FileSaver.saveAs(savaExcelUrl, "a.xls");
                        //$("#excelDownload").trigger("click");
                    }
                    else {
                        $.ligerDialog.error(data.detail);
                    }     
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

        ////获取勾选的点位信息 陈毅
        //var Pid = [];
        //function public_page_click(v) {
        //    pid = v;
        //    alert(pid);
        //};


        function searchDB() {

            //var data = { "Total": 0, "Rows": [] };
            //grid.set({ data: data });

            //grid.reRender();
            //var  stratTime = $("#beginDt").val();
            //var endTime = $("#endDt").val();

            //var meters = getAllMetersSelected();
            //if (meters.length <= 0) {
            //    return;
            //}
            //这里是传参
            var vParaArray = [];
            //vParaArray.push({ "key": "startDate", "value": stratTime });
            //vParaArray.push({ "key": "endTime", "value": endTime });
            vParaArray.push({ "key": "status", "value": getAllStatus() });
            //vParaArray.push({ "key": "meterIDs", "value": meters });
            grid.setParm("param1", JSON2.stringify(vParaArray));
            grid.reload();
            //显示一下数据

            excelUrl = "http://47.107.94.142:8080" + "/meters/detectionDatas/latest?status=" + getAllStatus();

            ////暂时用这个 正式替换为 下面注释掉的ajax
            //var vUrl = "/detectionDatas?taskID=&startDate=" + stratTime + "&endDate=" + endTime + "&status=" + getAllStatus() + "&meterIDs=" + getAllMeters() + "&pageNum=1&pageSize=10000&orderBy";
            ////alert(vUrl);
            //$.ajax({
            //    type: "get",
            //    url: "../handler/InterFace.ashx",
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

        //加载layui 复选框
         layui.use(['layer', 'form', 'laydate'], function () {
             var form = layui.form;
             //form.render();
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

        function getAllMeters() {
            //这个方法返回所有被选中的点位
            return "1,2,3,4";
        }

        //获取所有状态条件 URL转码了
        function getAllStatus() {
            var status = "";
            if ($("#sbzc").attr("checked")) {
                status += ",正常";

            }
            if ($("#sbyc").attr("checked")) {
                status += ",异常";
            }
            if ($("#rgsb").attr("checked")) {
                status += ",人工";
            }
            status = encodeURI(status.substring(1, status.length));
            
            return status;
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
                $("#detail-img1").val(data.filepath + ".jpg");
                 $("#detail-img2").val(data.filepath + "_结果.jpg");
                $("#detail-audio").val(data.filepath + ".wav"); 
            }
            if (data.detectionValue != null) {
                $("#detail-result").html(data.detectionValue);
            }
            if (data.detectionStatus != null) {
                $("detail-warn").val(data.detectionStatus);
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
                  
                    //如果有审核数据 则读取到界面
                    if (checkdata) {
                        //读用户编辑后的真实值
                        if (checkdata.checkValue != null) {
                            $("#detail-value").html(checkdata.checkValue);
                        }
                        //用表计数和编辑数对比 判断结果是否正确
                        if (checkdata.checkValue != null) {
                             if (data.detectionValue != checkdata.checkValue)  
                                $("input[name='shibie']").eq(1).click();
                            else
                                $("input[name='shibie']").eq(0).click();
                        }
                        //读取编辑后的状态 （覆盖原有状态）
                        if (checkdata.checkRiseStatus != null) {
                             $("#detail-warn").val(checkdata.checkRiseStatus);
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
                                layer.msg("开始保存！");
                                var postData = "state=%E5%B7%B2%E4%BF%AE%E6%94%B9&checkValue=" + vTrueValue + "&checkRiseStatus="
                                    + vTrueStatus + "&userName=" + public_userName + "&detectionDataId=" + data.id;
                                //alert(postData);
                                $.ajax({
                                    type: "post",
                                    url: "../handler/InterFace.ashx?r=" + Math.random(),

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
                $.ajax({
                    type: "post",
                    url: "../handler/InterFace.ashx?r=" + Math.random(),
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
    <form id="form1" runat="server" class="layui-form">
        <div id="layout1" style="height:80px">
            
            <div position="left" title="点位树" style="padding-left: 10px;height:820px">
                <iframe id="ftree" frameborder="0" height="820px" width="100%" src="kong.htm"></iframe>
            </div>

            <div position="center" title="巡检结果列表">
            </div>

            
            <div position="center" title="">
                <div class="layui-form-item" >
                    <div class="layui-form-item" style="padding-top: 10px;">

                       <%-- <label class="layui-form-label">开始时间</label>
                        <div class="layui-input-inline" style="width:100px">
                                <input type="text" class="layui-input" id="beginDt">
                        </div>
                        <label class="layui-form-label">结束时间</label>
                        <div class="layui-input-inline" style="width:100px">
                                <input type="text" class="layui-input" id="endDt">
                        </div>--%>

                        <div class="layui-input-inline" style="padding-left: 50px; width:100px">
                            <input  id="sbzc"  type="checkbox" name="like[sbzc]" title="识别正常" checked>
                        </div>
                        <div class="layui-input-inline" style="padding-left: 20px; width:100px">
                            <input  id="sbyc" type ="checkbox" name="like[sbyc]" title="识别异常" checked>
                        </div>
                        <div class="layui-input-inline" style="padding-left: 20px; width:100px">
                            <input  id="rgsb" type="checkbox" name="like[rgsb]" title="人工识别" checked>
                        </div>


                        <div class="layui-input-inline" style="padding-left: 100px;width: 80px">
                            <input type="button" class="layui-btn"  value="查询" onclick="searchDB()">
                        </div>
                       
                        <div class="layui-input-inline" style="width: 80px">
                            <input type="button" class="layui-btn layui-btn-normal"  value="重置" onclick="resetDB()">
                        </div>

                        <%--<div class="layui-input-inline" style="width: 80px">
                            <input type="button" class="layui-btn layui-btn-warm"   value="导出" onclick="export_excel()">
                        </div>--%>

                    </div>
                </div>
                <div id="maingrid" style="margin: 0; padding: 0"></div>
            </div>

        </div>

    </form>

      <div id="div_export" style="display: none; text-align: left; line-height: 30px; padding-left: 50px;">
                 
                <div class="layui-form" action="">
                    <div class="layui-form-item" id="show">
                      
                      
                </div>
            </div>
    </div>


</body>
</html>
