<%@ Page Language="C#" AutoEventWireup="true" CodeFile="巡检报告生成.aspx.cs" Inherits="pages_巡检报告生成" %>


<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title>巡检报告生成</title>
    <link href="../lib/ligerUI/skins/Aqua/css/ligerui-all.css" rel="stylesheet" type="text/css" />
    <link href="../lib/ligerUI/skins/Gray2014/css/all.css" rel="stylesheet" type="text/css" />
    <script src="../js/jquery-1.8.3.min.js" type="text/javascript"></script>
    <script src="../lib/ligerUI/js/core/base.js" type="text/javascript"></script>


    <link href="../js/layui/css/layui.css" rel="stylesheet" type="text/css" />
    <script src="../js/layui/layui.js" type="text/javascript"></script>
    <script src="../lib/ligerUI/js/ligerui.min.js" type="text/javascript"></script>

    <script src="../lib/ligerUI/js/plugins/ligerLayout.js" type="text/javascript"></script>
    <script src="../lib/ligerUI/js/plugins/ligerGrid.js" type="text/javascript"></script>

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

        #accordion1 {
            height: 270px;
        }

        h4 {
            margin: 20px;
        }

        #divHead p {
            height: 30px;
        }
        
        .l-bar-selectpagesize{
            display:none !important;
        }
    </style>

    <script type="text/javascript">
        var updateId = 0;
        var selectedId = -1;
        var taskType = "qmxj";
        var public_token = "<%=public_token %>";
        var grid = null;
        var bodyHeight = document.documentElement.clientHeight; //页面高度
        var layer;
        $(function () {

            layui.use(['laydate', 'form', 'layer'], function () {
                var form = layui.form;
                form.render();
                var laydate = layui.laydate;
                layer = layui.layer;
                laydate.render({
                    elem: '#beginDt'
                    , type: 'date'
                    ,value: getCurrentAddDayYMD(-30)
                });
                laydate.render({
                    elem: '#endDt'
                , type: 'date'
                , value: getCurrentAddDayYMD(0)
                });
                laydate.render({
                    elem: '#time3'
                , type: 'date'
                , value: getCurrentAddDayYMD(-30)
                });
                laydate.render({
                    elem: '#time4'
                , type: 'date'
                , value: getCurrentAddDayYMD(0)
                });
            });

            //装载巡检类型
            $.ajax({
                type: "post",
                url: "../handler/InterFace.ashx?r=" + Math.random(),
                data: {
                    method: "http_getMethod"
                    , token: public_token
                    , MethodUrl: "/taskTemplateTypes"
                },
                dataType: "json",
                success: function (data) {
                  
                    if (data && data.length > 0) {
                        $("#sel_xjlx").append("<option value='0'>-请选择-</option>");
                        $.each(data, function (i, json) {
                            $("#sel_xjlx").append("<option value='" + json.id + "'>" + json.name + "</option>");
                        });
                         
                    }
                }
            });
            
            //这里装载grid
            grid = $("#maingrid").ligerGrid({
                columns: [
                { display: '任务名称', name: 'taskInfoName', minWidth: 300 },
                { display: '任务状态', name: 'isFinished', width: 150 },
                { display: '任务开始时间', name: 'startTime', width: 200 },
                { display: '任务结束时间', name: 'endTime', width: 200 },
                //{ display: '总时长', name: 'endTime-startTime', width: 200 },
                { display: '总巡检点位', name: 'meterCount', width: 150},
                { display: '正常点位', name: 'meterFinishCount', width: 150 },
                { display: '告警点位', name: 'meterDetectionErrorCount', width: 150 },
                { display: '识别异常点位', name: 'meterAbnormalCount', width: 150 },
                { display: '是否审核', name: 'checkStatus', width: 150 }
                ]
                , onSelectRow: function (rowdata, rowid, rowobj) {
                    console.log(data);
                    selectedId = rowdata.id;  //待编辑的id锁定
                }
                , pageSize: 25
                , rownumbers: true
                , usePager: true
                , pageSizeOptions :[25]
                , width: '100%'
                , height: bodyHeight - 110
                , checkbox: false
                , delayLoad: true
                , url: "../handler/loadGrid.ashx?view=http_getGridMethod&methodName=taskReport&r=" + Math.random()

                //双击任务模板
                , onSelectRow: function (data, rowindex, rowobj) {
                    updateId = data.id;  //待编辑的id锁定
                    //alert(updateId);
                }
            });
        });

        function searchDB() {
            updateId = 0;

            var startTime = $("#beginDt").val();
       
            if(!startTime){
                layer.msg("请输入开始时间!");
                return;
            }
            var endTime = $("#endDt").val();
            if(!endTime){
                layer.msg("请输入结束时间!");
                return;
            }
            //这里是传参
            var vParaArray = [];
            vParaArray.push({ "key": "startDate", "value": startTime });
            vParaArray.push({ "key": "endTime", "value": endTime });
            grid.setParm("param1", JSON2.stringify(vParaArray));
            grid.reload();
            //显示一下数据 
          //  var vUrl = "/taskFinish/search/timeAndTypes?templateTypeIds=&startTime=" + startTime + "&endTime=" + endTime;
        }

        function resetDB() {  
            window.location.reload();
            layer.msg("重置完成!");
        }

     
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
            if (updateId == 0) {
                layer.msg("尚未选择要导出任务");
                return;
            }

            $("#show").html("");
            var vUrl = "/report/fields";
            $.ajax({
                type: "post",
                url: "../handler/InterFace.ashx?r=" + Math.random(),
                data: {
                        method: "http_PostMethod"
                    , token: public_token
                    , MethodUrl: vUrl
                    ,postData:''
                       
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


            var vUrl = "/report/task";
            var postData = "fields=" + strgetSelectValue + "&taskId=" + updateId;

            $.ajax({
                type: "post",
                url: "../handler/InterFace.ashx?r=" + Math.random(),
                data: {
                    method: "http_PostMethod"
                    ,token: public_token
                    ,MethodUrl: vUrl
                    ,postData: postData
                },
                dataType: "json",
                success: function (data) {
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
       

        //查看报表
        function detailDB() { 
        }
    </script>

</head>
<body>
    <form id="form1" runat="server">
        <div id="layout1">

            <%--<div id="div_export" style="display: none; text-align: left; line-height: 30px; padding-left: 50px;">
                    <p>任务模板： 
                        <select id="sel_wumb1" style="height:30px;font-size:14px;width:260px;">
                            <option value="1">漏点模板</option>
                        </select></p>
                    <p>图片类型： 
                        <select id="sel_tp1" style="height:30px;font-size:14px;width:260px;">
                            <option value="1">无图片</option>
                        </select></p>
            </div>--%>

            <div id="div_export" style="display: none; text-align: left; line-height: 30px; padding-left: 50px;">
                    <%--<p>起始时间：<input style="height: 30px; line-height: 30px;width:260px;" type="text" class="layui-input" id="time3" placeholder="yyyy-MM-dd HH:mm:ss"></p>--%>
                    <%--<p>图片模板类型：<br/>
                    <select id="" style="height:30px;font-size:14px;width:260px;" >
                        <option value="1">无图片</option>
                        <option value="2">有图片</option>
                    </select>
                </p>--%>
                <div class="layui-form" action="">
                    <div class="layui-form-item" id="show">
                        
                    </div>
                </div>
            </div>

            <div position="center" title="">

               <div class="layui-form" style="padding-top:8px;" >

                    <div class="layui-form-item">
                        <label class="layui-form-label">开始时间</label>
                        <div class="layui-input-inline" style="width:120px">
                                <input type="text" class="layui-input" id="beginDt">
                        </div>
                        <label class="layui-form-label">结束时间</label>
                        <div class="layui-input-inline" style="width:120px">
                                <input type="text" class="layui-input" id="endDt">
                        </div>
                        <%--<label class="layui-form-label">巡检类型</label>
                        <div class="layui-input-inline" style="width:120px">
                                <select id="sel_xjlx"></select>
                        </div>--%>

                         <div class="layui-input-inline" style="width:500px">
                        <%--     <input type="button" class="layui-btn layui-btn-sm layui-btn-primary" style="" value="查询" onclick="searchDB()"></input>
                             <input type="button" class="layui-btn layui-btn-sm layui-btn-primary" style="" value="重置" onclick="resetDB()"></input>
                             <input type="button" class="layui-btn layui-btn-sm layui-btn-primary" style="" value="查看报告" onclick="detailDB()"></input>  
                             <input type="button" class="layui-btn layui-btn-sm layui-btn-primary" style="" value="导出" onclick="exportDB()"></input>
                             <input type="button" class="layui-btn layui-btn-sm layui-btn-primary" style="" value="统计报表导出" onclick="exportBBDB()"></input>--%>
                             <div class="layui-input-inline" style="width: 80px">
                                <input type="button" class="layui-btn"  value="查询" onclick="searchDB()"></input>
                            </div>          

                            <div class="layui-input-inline" style="width: 80px">
                                <input type="button" class="layui-btn layui-btn-normal"  value="重置" onclick="resetDB()"></input>
                            </div>

                            <%--<div class="layui-input-inline" style="width: 110px">
                                <input type="button" class="layui-btn"   value="查看报告" onclick="detailDB()"></input>
                            </div>--%>

                            <div class="layui-input-inline" style="width: 80px">
                                <input type="button" class="layui-btn layui-btn-warm"   value="导出" onclick="export_excel()"></input>
                            </div>

                            <%-- <div class="layui-input-inline" style="width: 80px">
                                <input type="button" class="layui-btn layui-btn-warm"   value="统计报表导出" onclick="exportBBDB()"></input>
                            </div>--%>
                        </div>


                    </div>

                </div>

                <div id="maingrid" style="margin: 0; padding: 0"></div>


            </div>

        </div>

    </form>

</body>
</html>
