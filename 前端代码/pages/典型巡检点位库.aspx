<%@ Page Language="C#" AutoEventWireup="true" CodeFile="典型巡检点位库.aspx.cs" Inherits="pages_典型巡检点位库" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title>典型巡检点位库维护</title>
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
    <style>
        #row1{
            margin:10px 0 0 10px;
            display:flex;
            flex-direction:row;
        }
        #row2{
            display:flex;
            flex-direction:row;
            flex-wrap:wrap;
            justify-content:flex-start;
        }
        .l-bar-selectpagesize{
            display:none !important;
        }
       
    </style>
    <script type="text/javascript">
        var taskType = "qmxj";
        var public_token = "<%=public_token %>";
        var grid = null;
        var bodyHeight = document.documentElement.clientHeight; //页面高度
        $(function () {

            $("#layout1").ligerLayout({ leftWidth: 350, topHeight: 110 });



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

            getChecks();
            //装载树结构
            $("#ftree").attr("src", "../tree/allTree.aspx");
            //这里装载grid
           
            grid = $("#maingrid").ligerGrid({
                columns: [
               { display: '序号', name: 'areaId', align: 'left', width: 30 },
               { display: '设备类型', name: 'deviceType', minWidth: 200 },
               { display: '小类设备', name: 'deviceName',  minWidth: 200 },
               { display: '点位名称', name: 'meterName', minWidth: 200 },
               { display: '识别类型', name: 'detectionType',minWidth: 200 },
               { display: '表计类型', name: 'meterType',minWidth: 200 },
               { display: '发热类型', name: 'feverType',minWidth: 200 },
               { display: '保存类型', name: 'saveType',minWidth: 200}    
               , {
                   display: '操作', isSort: false, width: 300, render: function (rowdata, rowindex, value) {
                       var h = '';
                       
                       h += "<a href='javascript:dingqi_run(" + rowindex + ")'>修改</a> ";
                       h += "<a href='javascript:zhouqi_run(" + rowindex + ")'>删除</a> ";
                       return h;
                   }
               }
                ]  
               , pageSize: 30
               , width: '100%'
               , height: bodyHeight - 270
            });

            getChecks();



        });


        function getChecks() {

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
                    if (data.success != true) {
                         layer.msg(data.detail);
                        return;

                     }
                    data = data.data;
                    if (data) {
                        var vLen = data.length;
                        var vHtml = "<div id='row1'><p style='width:100px'>设备类型：</p><div  id='row2' style='width:90%'>";
                        for (var i = 0; i < vLen; i++) {
                            vHtml += "<p style='width:200px;'><input class='ever_deviceType' data='" + data[i].deviceType + "' type='checkbox' name='ck1' value='N" + data[i].id + "'/><span>" + data[i].deviceType + "</span></p> ";
                        }
                        vHtml += "</div></div>";
                        $("#divHead2").html(vHtml);
                    }
                    $(".ever_deviceType").click(function () {
                        oncheckselected($(this))
                    });
                    //alert(data);
                }
            });      
        }

        //这里是筛选方法
        function oncheckselected(thisv) {
            if (thisv.attr('checked') == 'checked') {
                var num = thisv.attr('value').substring(1, thisv.attr('value').length);
                vUrl[num] = thisv.attr('data');
            } else {
                var num = thisv.attr('value').substring(1, thisv.attr('value').length);
                vUrl[num] = 0;
            }
            
            //var vTreeObject = public_getTreeObject();
            //var boolv = thisv.prop("checked");//返回是否存在 是 true  否  false            
            //var node = vTreeObject.getNodeByParam("name", thisv.attr("data"), null);
            //alert(node);
            //boolv ? vTreeObject.checkNode(node, true, true) : vTreeObject.checkNode(node, false, true);


        }
         //这里是筛选属性点筛选方法
        function oncheckselectedProperty(vType,thisv) {
            
            var vTreeObject = public_getTreeObject();
            var boolv = thisv.prop("checked");
            var vThisvText = thisv.attr("data");//得到属性
            var vArray = ftree.contentWindow.fromMeterPropertyGetMeterIdList(vType, vThisvText);
            if (vArray.length > 0) {
                for (var i = 0; i < vArray.length; i++) {
                    var node = vTreeObject.getNodeByParam("no", vArray[i], null);
                    boolv ? vTreeObject.checkNode(node, true, true) : vTreeObject.checkNode(node, false, true);
                }
            }
        }

        var vUrl = [];
        for (var i = 0; i < 100; i++) {
            vUrl[i] = 0;
        }
        function searchDB() {
            var lUrl=''
           for (var i = 0; i < 100; i++) {
                if (vUrl[i] != 0) {
                   lUrl +=  'deviceType='+vUrl[i]+'&';
                }
        }           
            //暂时用这个 正式替换为 下面注释掉的ajax
            if (lUrl.length != 0) {
                lUrl = lUrl.substring(0, lUrl.length - 1);
            } else {
                layer.msg("请先勾选上方的设备类型");
                return;
            }
            
            lUrl = encodeURI(lUrl);
            
            console.log('/meters/search/deviceType?'+lUrl);
            $.ajax({
                type: "get",
                url: "../handler/InterFace.ashx?r=" + Math.random(),
                data: {
                   method: "http_getGridMethod"
                   , MethodUrl: '/meters/search/deviceType?'+lUrl
                   , token: public_token
                   , ListName: "list"  
                },
                dataType: "json",
                success: function (data) {
                    //dataAll = data; 未修改
                    console.log(data);
                    if (data.Rows == 0) {
                        grid.set({ data: [] });
                        layer.msg("没有符合条件的数据") 
                    } else {
                        grid.set({ data: data });
                    }

                }
            });
        }

        function saveDB() {
            var myDate = new Date();
            $("#taskName").val("全面巡检任务" + myDate.toLocaleDateString().replace(/\//g, ''));
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
            var vTreeObject = public_getTreeObject();
            var nodes = vTreeObject.getCheckedNodes();
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
                width: 500, top: 150,
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
                        ,postData:''
                       
                    },
                    dataType: "json",
                  success: function (data) {
                            if (data.success != true) {
                                 layer.msg(data.detail);
                                return;

                             }
                            data = data.data;
                           
                            var mm = "";
                            
                                for (var j = 0; j < data.length; j++) {

                                   // mm += "<input id='ddzx' type='checkbox' name='ddzx' title='"+data[j].fieldName+"'  value="+data[j].fieldLabel+" checked=''><div class='layui-unselect layui-form-checkbox' lay-skin=''><span>"+data[j].fieldName+"</span><i class=''layui-icon'></i></div>";
                                    
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

                                        var colName = daochu(); //取得要导出的列
                                        //if (colName.length > 0) {
                                            //根据已经得到的任务id selectedId 发送导出请求 


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


              var vUrl = "/report/point" ;
           console.log(strgetSelectValue);

            $.ajax({
                type: "post",
                url: "../handler/InterFace.ashx?r=" + Math.random(),
                data: {
                    method: "http_PostMethod"
                    ,token: public_token
                    ,MethodUrl: vUrl
                    , postData: { strstatus:strstatus,url:"http://47.107.94.142:8080/detectionDatas"}
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
                        //返回结果装载  
                       
                        grid.set({ data: data });
                    }
                    else {
                        $.ligerDialog.error('获取任务失败');
                    }     
                }
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

       
    </style>
</head>
<body>
    <form id="form1" runat="server" >
        <div id="layout1">

            <div position="top" id="divHead">              
                
                <div id="divHead2"></div>
                
            </div>
            

            <div position="center" title="任务编辑列表">
           
                <div class="layui-form" style="padding-top: 8px;">

                    <div class="layui-form-item " style="padding-left:20px;">

                        <div class="layui-input-inline" style="width: 80px">
                                <input type="button" class="layui-btn"  value="查询" onclick="searchDB()"></input>
                        </div>  
                        <div class="layui-input-inline" style="width: 80px">
                            <input type="button" class="layui-btn layui-btn-warm " value="添加" onclick="saveDB()"></input>
                        </div>
                        <div class="layui-input-inline" style="width: 80px">
                            <input type="button" class="layui-btn layui-btn-normal"  value="重置" onclick="resetDB()"></input>
                        </div>
                        <div class="layui-input-inline" style="width: 80px">
                            <input type="button" class="layui-btn  "  value="导出" onclick="export_excel()"></input>
                        </div>
                        
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
