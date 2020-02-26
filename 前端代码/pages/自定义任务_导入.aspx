<%@ Page Language="C#" AutoEventWireup="true" CodeFile="自定义任务_导入.aspx.cs" Inherits="pages_自定义任务_导入" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>

     <link href="../lib/ligerUI/skins/Aqua/css/ligerui-all.css" rel="stylesheet" type="text/css" />
    <link href="../lib/ligerUI/skins/Gray2014/css/all.css" rel="stylesheet" type="text/css" />
    <script src="../js/jquery-1.8.3.min.js" type="text/javascript"></script>
    <script src="../lib/ligerUI/js/core/base.js" type="text/javascript"></script>


    <link href="../js/layui/css/layui.css" rel="stylesheet" type="text/css" />
    <script src="../js/layui/layui.js" type="text/javascript"></script>
    <script src="../lib/ligerUI/js/plugins/ligerGrid.js" type="text/javascript"></script>

    <script src="../lib/js/publicMethodJs.js" type="text/javascript"></script>
<script>

    var public_token = "<%=public_token %>";

    $(function () {


        layui.use(['layer', 'form', 'laydate'], function () {
            var form = layui.form;
            console.log(form)
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

            grid = $("#maingrid_importTemplet").ligerGrid({
            columns: [
                   {display: '任务名称', name: 'meterName', minWidth: 60 },
                   { display: '执行时间', name: 'time', width: 400 }
                ]
                , rownumbers: true
                , checkbox: false
                , pageSize: 15
                , pageSizeOptions: [15]
                , width: "98%"
                , height: "400"
        });
    });

    function searchDB() {

        //var vUrl = "/taskPlans?taskStatus=" + encodeURI("已完成") + "&startTime="
        //    + $("#beginDt").val() + "&endTime=" + $("#endDt").val() + "&taskName=" + $("#txtName").val() + "&pageNum=1&pageSize=15&orderBy="
        //请求没返回值 用的假得先

        var vUrl = "/detectionDatas?taskID=1,2&startDate=2018-05-15 12:30:00&endDate=2018-11-15 12:30:00&status&meterIDs=1,2,3,4&pageNum=1&pageSize=2&orderBy";
        //alert(vUrl);
        $.ajax({
            type: "get",
            url: "../handler/InterFace.ashx?r=" + Math.random(),
            data: {
                method: "http_getGridMethod_expend"
                , MethodUrl: vUrl
                , token: public_token
                , ListName: "list"
                    
            },
            dataType: "json",
            success: function (data) {
                if (!data.success ) {
                                         layer.msg(data.detail);
                                        return;

                                     }
                    data = data.data;
                console.log(data.Rows.length);
                if (data.Rows.length == 0) {
                    layer.msg("没有符合条件的数据") 
                } else {
                    grid.set({ data: data });
                }

            }
        });
    }

    function getSelectedRow() {
        return grid.getSelectedRow();
    }


</script>

</head>
<body>
    <form id="form1" runat="server">
        
     <div class="layui-form" style="margin:5px" action="">
        <div class="layui-form-item">
            <label class="layui-form-label">开始时间</label>
            <div class="layui-input-inline" style="width:100px">
                    <input type="text" class="layui-input" id="beginDt">
            </div>
            <label class="layui-form-label">结束时间</label>
            <div class="layui-input-inline" style="width:100px">
                    <input type="text" class="layui-input" id="endDt">
            </div>
        </div>
        <div class="layui-form-item">
            <label class="layui-form-label">任务名称</label>
            <div class="layui-input-inline">
                <input type="text" class="layui-input" id="txtName">
            </div>

            <div class="layui-input-inline">
                <input type="button" class="layui-btn" value="查询" onclick="searchDB()" />
            </div>
        </div>
    </div>

     <div id="maingrid_importTemplet" style="margin-left:10px"></div>


    </form>
</body>
</html>
