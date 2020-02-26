<%@ Page Language="C#" AutoEventWireup="true" CodeFile="机器人告警查询.aspx.cs" Inherits="pages_机器人告警查询" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
<title>机器人告警查询</title>
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
    <style>
        .l-bar-selectpagesize{
            display:none !important;
        }
    </style>
    <script>
         var taskType = "qmxj";
         var public_token = "<%=public_token %>";
         var grid = null;
         var bodyHeight = document.documentElement.clientHeight; //页面高度

         $(function () {
            grid = $("#maingrid").ligerGrid({
                    columns: [
                        { display: '数据源',   name: 'source', width: 400 },
                        { display: '告警等级', name: 'level', width: 400 },
                        { display: '告警内容', name: 'detail', width: 400},
                        { display: '告警时间', name: 'time', width: 400},
                        { display: '审核状态', name: 'isDealed', width: 400}
                    ]
                    , pageSize: 30
                    , checkbox: false
                    , width: '100%'
                    , height: bodyHeight - 100
                    , onDblClickRow : function (rowdata, rowindex, rowDomElement) {
                      
                    var selected = grid.getSelectedRow();

                       // detail(selected)
                       
               }    
            });
        });

        function searchDB() {
           
         //var vList = f_getCheckedNodes("N");
    
            //暂时用这个 正式替换为 下面注释掉的ajax 
            var  stratTime = $("#beginDt").val();
            var endTime = $("#endDt").val();

            //alert(stratTime);
            $.ajax({
                type: "get",
                url: "../handler/InterFace.ashx?r=" + Math.random(),
                data: {
                    method: "http_getGridMethod_expend2"
                    ,MethodUrl: "/systemAlarms?startTime=" + stratTime + "&endTime=" + endTime + " 23:59:59"
                    ,token: public_token
                },
                dataType: "json",
                success: function (data) {
                    if (data.success != true) {
                        layer.msg(data.detail);
                        return;
                    }
                    //data = data.data;
                    console.log(data);
                    if (data.Rows == 0) {
                        layui.layer.msg('请求失败');
                    } else {
                        for (var i = 0; i < data.Rows.length; i++){
                            if (data.Rows[i].isDealed) { data.Rows[i].isDealed = '已审核'; }
                            else {
                                data.Rows[i].isDealed = '未审核';
                            }
                        }
                        grid.set({ data: data });
                    }
                    

                },
                error: function (XMLHttpRequest, textStatus, errorThrown) {
                    alert(111);
                    alert(XMLHttpRequest.readyState);
                    console.log(data);
                 } 
            });

        }
         function resetDB() {
            window.location.reload();
        }

        //加载layui 复选框
         layui.use(['layer', 'form', 'laydate'], function () {
                var form = layui.form;
                layer = layui.layer;
                var laydate = layui.laydate;
                laydate.render({
                    elem: '#beginDt' //指定元素
                    , value: getCurrentAddDayYMD(-7)
                });
                laydate.render({
                    elem: '#endDt' //指定元素
                    , value: getCurrentAddDayYMD(0)
                });
        });

        function detail(selected) {
            console.log(selected);
            $("#detail-describ").html(selected.a);
            $("#detail-value").val(selected.d);
            $("#detail-result").html(selected.c);
            $("#detail-warn").val(selected.e);
            var detail_dingqi = $.ligerDialog.open({
                target: $("#div_detail"),
                title: "任务审核",
                width: 700, top: 150,
                buttons: [
                {
                    text: '保存', onclick: function () {
                       
                        //{{url}}/doTaskTempletRegular
                        //{taskType,robotId,doTaskType,doTime,spaceType}
                        //$.ajax({
                        //    type: "get",
                        //    url: "../handler/InterFace.ashx",
                        //    data: {
                        //        method: "doTask"

                        //       , token: public_token
                        //        , taskType: taskType
                        //        , robotId: ""
                        //        , doTime: $("lj_time").val()
                        //        , taskId: DB_DATA.Rows[rowid].taskId
                        //         , doTaskType: "doTaskTempletNow1"
                        //    },
                        //    dataType: "json",
                        //    success: function (data) {
                        //        //处理返回值
                        //        if (data.success) {
                        //            detail_dingqi.hide();
                        //            $.ligerDialog.success('设定成功');
                        //            grid.loadData();
                        //        }
                        //        else $.ligerDialog.error('设定失败');
                        //    }
                        //});

                    }
                },
                { text: '取消', onclick: function () { detail_dingqi.hide(); } }
                ]
            });

        }

    </script>
</head>
<body>
    <form id="form1" runat="server">
        <div>
            <div class="layui-form" style="padding-top: 8px;">
                    <div id="div_detail" style="display: none; text-align: left; line-height: 30px; padding-left: 50px;">
                    <div style="width: 50%; float: left;">
                        <p>点位信息：<span id="detail-describ"></span></p>
                        <p>
                            可见光图片：<br />
                            <img id="detail-img1" src="" style="width: 200px; height: 200px;" />
                        </p>
                        <p>
                            巡检图片：<br />
                            <img id="detail-img2" src="" style="width: 200px; height: 200px;" />
                        </p>
                        <p>
                            音频文件：<br />
                            <audio id="detail-audio" src="http://www.w3school.com.cn/i/horse.ogg" controls="controls"></audio>
                        </p>
                    </div>
                    <div style="width: 50%; float: left; margin-top: 30px;">
                        <p>识别结果：<span  id="detail-result"></span></p>
                        <p style="height: 100px;margin-top:30px;" >
                            告警等级：
                            <select style="height: 30px; line-height: 30px;" id="detail-warn">
                                <option value="正常">正常</option>
                                <option value="预警">预警</option>
                                <option value="异常">异常</option>
                            </select>
                        </p>
                        <p>
                            <div class="layui-block">
                               
                                    识别正确
                                <input type="radio" name="shibie" value="识别正确" title="识别正确" checked="">
                             
                                    &nbsp;&nbsp;&nbsp;&nbsp;
                                识别错误
                                <input type="radio" name="shibie" value="识别错误" title="识别错误">
                                
                            </div>
                        </p>
                        <p style="margin-top:30px;">实际值：<input id="detail-value" data-type="text" data-label="实际值" style="height: 20px; line-height: 20px;" /></p>
                    </div>
                </div>
                    

                    <div class="layui-form-item">

                        <div class="layui-inline" style="float: left; height: 30px; line-height: 30px;">
                            <label class="layui-form-label" style="padding: 0px;">开始时间：</label>
                            <div class="layui-input-inline">
                                <input style="height: 30px; line-height: 30px;" type="text" class="layui-input" id="beginDt" placeholder="yyyy-MM-dd HH:mm:ss">
                            </div>
                        </div>
                        <div class="layui-inline" style="float: left; height: 30px; line-height: 30px;">
                            <label class="layui-form-label" style="padding: 0px;">截至时间：</label>
                            <div class="layui-input-inline">
                                <input style="height: 30px; line-height: 30px;" type="text" class="layui-input" id="endDt" placeholder="yyyy-MM-dd HH:mm:ss">
                            </div>
                        </div>

                        <div class="layui-input-inline" style="width: 80px">
                           
                            <input type="button" class="layui-btn"  value="查询" onclick="searchDB()"></input>
                        </div>
                        
                        <div class="layui-input-inline" style="width: 80px">
                             <input type="button" class="layui-btn layui-btn-normal"  value="重置" onclick="resetDB()"></input>
                        </div>
                     <%--   <div class="layui-input-inline" style="width: 100px">
                            <input type="button" class="layui-btn layui-btn-sm layui-btn-primary" style="height: 30px; line-height: 30px;" value="查看报告" onclick="detailDB()"></input>
                        </div>
                        <div class="layui-input-inline" style="width: 80px">
                            <input type="button" class="layui-btn layui-btn-sm layui-btn-primary" style="height: 30px; line-height: 30px;" value="导出" onclick="exportDB()"></input>
                        </div>
                        <div class="layui-input-inline" style="width: 80px">
                            <input type="button" class="layui-btn layui-btn-sm layui-btn-primary" style="height: 30px; line-height: 30px;" value="统计报表导出" onclick="exportBBDB()"></input>
                        </div>--%>
                    </div>
                </div>
            <div id="maingrid" style="margin:0; padding:0"></div>
        </div>
    </form>
</body>
</html>
