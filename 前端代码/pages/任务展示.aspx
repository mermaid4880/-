<%@ Page Language="C#" AutoEventWireup="true" CodeFile="任务展示.aspx.cs" Inherits="pages_任务展示" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>

    <link href="../lib/ligerUI/skins/Aqua/css/ligerui-all.css" rel="stylesheet" type="text/css" />
    <link href="../lib/ligerUI/skins/Gray2014/css/all.css" rel="stylesheet" type="text/css" />
    <script src="../js/jquery-1.8.3.min.js" type="text/javascript"></script>
    <script src="../lib/ligerUI/js/core/base.js" type="text/javascript"></script>

    <link href="../js/layui/css/layui.css" rel="stylesheet" type="text/css" />
    <script src="../js/layer/layer.js" type="text/javascript"></script>
    <script src="../js/layui/layui.js" type="text/javascript"></script>

    <script src="../lib/ligerUI/js/plugins/ligerLayout.js" type="text/javascript"></script>
    <script src="../lib/ligerUI/js/ligerui.min.js" type="text/javascript"></script>
    <script src="../lib/ligerUI/js/plugins/ligerGrid.js" type="text/javascript"></script>

    <link href="../css/calendar/calendar-pro.css" rel="stylesheet" type="text/css" />
    <script src="../css/calendar/calendar-pro.js" type="text/javascript"></script>

    <script src="../lib/js/publicMethodJs.js" type="text/javascript"></script>
    <script src="../js/json2.js" type="text/javascript"></script>
    <script src="../js/Moment.js" type="text/javascript"></script>

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
        .alert{
            border:1px solid #009688;
            width:390px;
            line-height:40px;
            padding:20px;
           margin:5px;

        }
        #divHead p {
            height: 30px;
            /*<%-- background-color:Red;
            --%>*/
        }
         .l-bar-selectpagesize{
            display:none !important;
        }
    </style>
    <script>
        var public_token = "<%=public_token %>";
        var month = "<%=month %>";
        var bodyHeight = document.documentElement.clientHeight; //页面高度
        var layer;
        $(function () {

            $("#layout1").ligerLayout({ leftWidth: 800,allowLeftCollapse: false, allowLeftResize: false });
            //$("#time-year-month").val(yearMonth);

            $('.ht-rili-body').click(function () {
                //alert(1);
                var data = $('.calendar-box').calendarGetActive();
               // console.log(data);
                //alert(data.date + "--" + data.money);


            })


            //加载layui 复选框
            layui.use(['layer', 'form', 'laydate'], function () {
                var form = layui.form;
                layer = layui.layer;
                var laydate = layui.laydate;
                laydate.render({
                    elem: '#beginDt' //指定元素
                    , value: getCurrentAddDayYMD(0)
                });
                laydate.render({
                    elem: '#endDt' //指定元素
                    , value: getCurrentAddDayYMD(30)
                });
                laydate.render({
                    elem: '#time-year-month'
                    , type: 'month'
                });
                laydate.render({
                    elem: '#txt_zxtime'
                    , type: 'time'
                    ,value:"00:00:00"
                });
                laydate.render({
                  elem: '#newtime'
                 , type: 'datetime'
                 ,value:"yyyy-MM-dd 00:00:00"
                }); 
            });

            //显示表格
            grid = $("#maingrid").ligerGrid({
                columns: [
                    { display: '任务名称', name: 'taskName',  minWidth: 60 },
                    { display: '执行时间', name: 'time', width: 260 },
                    { display: '任务状态', name: 'status', width: 150},
                    {
                        display: '操作', isSort: false, width: 200, render: function (rowdata, rowindex, value) {
                           console.log(rowdata);
                            if (rowdata.status!="执行完成") {
                                  var h ="<a href='javascript:endEdit(" + rowdata.uid + ")'>修改</a> ";
                                  return h;
                            }
                        }
                    }
                ],
                toolbar: {
                    items: [
                        { text: '增加', click: itemclick, img: '../lib/silkicons/add.png' },
                        { line: true },
                        { text: '删除', click: itemclick, img: '../lib/silkicons/15.png' }
                    ]
                }
                , pageSize: 20
                , rownumbers: true
                , pageSizeOptions: [20]//可指定每页页面大小
                , width: '99%'
                , usePager: true
                , height: bodyHeight - 220
                , delayLoad: true
                , url: "../handler/loadGrid.ashx?view=http_getGridMethod_expend&methodName=taskPlans&r=" + Math.random()
            });


            //默认展示当前月份的任务
            $("#time-year-month").val(month);
            searchMonth(month);


        });

        function endEdit(vid) {
            //首先根据任务规划id 读取当时制定该规划时的规则  
            $.ajax({
                type: "get",
                url: "../handler/InterFace.ashx?r=" + Math.random(),
                data: {
                    method: "http_getMethod"   
                   , MethodUrl: "/taskPlans/" + vid
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
                    if (!data) {
                        layer.msg("没有符合条件的数据");
                    } else {
                        //把之前的设置方式还原到界面
                        //console.log(data.taskName);
                        $("#TaskName_zhouqi").val(data.taskTemplateName);
                        $("#TaskName_zhouqi").attr("disabled", true);
                        $("#circleNum").val(data.circle);

                        //$("#TaskName_dingqi").val(data.taskTemplateName);
                        $("#newtime").val(data.startTime);//得到任务开始时间

                        var detail_zhouqi = $.ligerDialog.open({
                            target: $("#div_zhouqirun"),
                            title: "周期执行设定",
                            width: 500, top: 150,
                            buttons: [
                            {
                                    text: '确定', onclick: function () {
                                        
                                        //点击确定 发送post 设定定期任务
                                        var taskTempletId = vid;
                                        var time = $("#newtime").val(); //得到开始时间
                                      
                                    var hours = getCircleHours(); //得到间隔小时数
                                    var start = 0;
                                    if ($("#start_zhouqi").attr("checked") == "checked") //判断是否选择启动
                                        start = 1;

                                    var postData = "taskTemplateId=" + taskTempletId + "&StartTime=" + time + "&circle=" + hours + "&repeat=1&isStart=" + start;
                                    //alert(postData);
                                    $.ajax({
                                        type: "post",
                                        url: "../handler/InterFace.ashx?r=" + Math.random(),
                                        data: {
                                            method: "http_PostMethod"
                                            , token: public_token
                                            , MethodUrl: "/taskPlans"
                                            , postData: postData
                                        },
                                        dataType: "json",
                                        success: function (data) {
                                            console.log(data);
                                            //{success:"true","detail": "xxx"}
                                            if (data) {
                                                if (data.success == true) {
                                                    layer.msg("设定任务成功!");
                                                }
                                                else {
                                                    layer.msg("设定任务失败!");
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
        
        function itemclick(item) {
            if (item.text === '删除') {
               
                var data_selected = grid.getSelectedRows();
               
                if (data_selected == null || data_selected.length <= 0) {
                    $.ligerDialog.warn('至少选择一行记录');
                    return;
                }

                var arr = [];
                for (var i = 0; i <data_selected.length; i++) {
                    arr.push(data_selected[i].uid);
                }
                var strArr = arr.join(',');

                //alert(strArr);
                $.ajax({
                    type: "post",
                    url: "../handler/InterFace.ashx?r=" + Math.random(),
                    data: {
                         method: "http_DelMethod"
                        , token: public_token
                        , MethodUrl: "/taskPlans/batch/" + strArr
                    },
                    dataType: "json",
                    success: function (data) {
                        //处理返回值
                        console.log(data);
                        if (data.success) {
                            $.ligerDialog.success('删除成功');
                            grid.loadData();
                        } else $.ligerDialog.error(data.detail);
                    }
                });
            }
            if (item.text === '增加') {   

               // parent.f_MyAddTab('1600', 'pages/自定义任务.aspx', '自定义任务');

                //parent.$(".second").html("自定义任务");
               window.location.href = "自定义任务.aspx";
            }
            if (item.text === '删除') {   
                //这里进行删除操作

            }
        }

        //获取任务规划列表
        function search() {
            //<input id="ddzx" type="checkbox" name="like[ddzx]" title="等待执行" checked>
            //               <input id="yzx" type="checkbox" name="like[yzx]" title="已执行">
            //               <input id="zzzx" type="checkbox" name="like[zzzx]" title="正在执行">
            //               <input id="zz" type="checkbox" name="like[zz]" title="中止">
            //               <input id="rwcq" type="checkbox" name="like[rwcq]" title="任务超期">
            //layer.msg("这里是查询");
            var status = [];
            if ($("#ddzx").prop("checked"))
                status.push($("#ddzx").attr("title"));
            if ($("#yzx").prop("checked"))
                status.push($("#yzx").attr("title"));
            if ($("#zzzx").prop("checked"))
                status.push($("#zzzx").attr("title"));
            if ($("#zz").prop("checked"))
                status.push($("#zz").attr("title"));
            if ($("#rwcq").prop("checked"))
                status.push($("#rwcq").attr("title"));
            //alert(states)
            var strstatus = encodeURI(status.join(','));

            var beginTime = $("#beginDt").val();
            var endTime = $("#endDt").val() + " 23:59:59";
            var taskName = $("#txtName").val();

            //这里是传参
            var vParaArray = [];
            vParaArray.push({ "key": "startTime", "value": beginTime });
            vParaArray.push({ "key": "endTime", "value": endTime });
            vParaArray.push({ "key": "taskStatus", "value": strstatus });
            vParaArray.push({ "key": "taskName", "value": taskName });
            grid.setParm("param1", JSON2.stringify(vParaArray));
            grid.reload();
            //显示一下数据 

        }
       
        function searchMonth() {
         
            month = $("#time-year-month").val() ? $("#time-year-month").val() : month;
           
            //以下是正式版 暂时没数据
            var d = moment($("#time-year-month").val(), "YYYY-MM"); //按照指定的年月字符串和格式解析出一个moment的日期对象
            var beginTime = d.startOf("month").format('YYYY-MM-DD HH:mm:ss'); //通过startOf函数指定取月份的开始即第一天
            var endTime = d.endOf("month").format('YYYY-MM-DD HH:mm:ss'); //通过startOf函数指定取月份的末尾即最后一天
            //var vUrl = "/taskPlans?taskStatus=&startTime=" + beginTime + "&endTime=" + endTime + "&taskName=&pageNum=&pageSize=&orderBy=";
            var vUrl = "/taskPlans?taskStatus=&startTime=" + beginTime + "&endTime=" + endTime;
          
            $.ajax({
                type: "get",
                url: "../handler/InterFace.ashx?r=" + Math.random(),
                data: {
                    method: "http_getGridMethod_expend"
                    , token: public_token
                    , ListName: "list"
                    , MethodUrl: vUrl
                },
                dataType: "json",
                success: function (data) {
                    if (!data.success ) {
                                         layer.msg(data.detail);
                                        return;

                                     }
                    
                    //处理返回值
                    //console.log(data);
                    if (data) {
                       // console.log(JSON.stringify(data));
                        if (data.Total == 0) {
                            //alert(0);
                            var vObj = $('.calendar-box');
                            vObj.empty(); //先清空
                            var vDate = month + "-01";//这里模拟一个
                            vObj.calendar({ ele: '.demo-box', title: '', data: [{ date: vDate, data: ""}] })
                        }
                        else {
                            
                            result(data);
                        }

                    }

                    else {
                        $.ligerDialog.error('获取月度任务列表失败');
                    }
                }
            });
        }
        function result(data) {
      
                // 没数据 临时先写着
            var data = data;
                var vdata = [];
                for (var i = 0; i < data.Total; i++) {
                    //{taskId: 1, taskName: "全面巡检任务20181020测试1", beginTime: "2018-10-20", states: "等待执行" }
                    time = /\d{4}-\d{1,2}-\d{1,2}/g.exec(data.Rows[i].time);
                    vdata.push({ date: time[0], data: data.Rows[i].taskName, status: data.Rows[i].status });
                    //alert(vdata);
            }
           
                //$("#time-year-month").val(month);
                $('.calendar-box').empty(); //先清空
                $('.calendar-box').calendar({
                    ele: '.demo-box', //依附
                    title: '',
                    data: vdata
                });

            $(".ht-rili-td").click(function () {              
                //点击后获取当前时间，然后重新查询
                //var date = new Date($(this).attr("data-date"));
                //var mon= date.getMonth()+1;
                ////var day = date.getDate() - 1;
                //var day = date.getDate();
                //var d =date.getFullYear()+"-"+mon+"-"+day;
                // beginTime = d + " 23:59:59";
                beginTime = $(this).attr("data-date") + " 00:00:00";
                endTime = $(this).attr("data-date") + " 23:59:59";
                var vUrl = "/taskPlans?taskStatus=&startTime=" + beginTime + "&endTime=" + endTime;
                //alert(vUrl);

                //console.log(vUrl);
                    $.ajax({
                        type: "get",
                        url: "../handler/InterFace.ashx?r=" + Math.random(),
                        data: {
                            method: "http_getGridMethod_expend"
                            , token: public_token
                            , ListName: "list"
                            , MethodUrl: vUrl
                        },
                        dataType: "json",
                        success: function (data) {
                             if (!data.success ) {
                                         layer.msg(data.detail);
                                        return;

                                     }
                    
                            //处理返回值
                            //console.log(data);
                            if (data.Total!=0) {
                                //layer.open({
                                //    type: 1,
                                //    area: ['600px', '360px'],
                                //    shadeClose: true, //点击遮罩关闭
                                //    content: "<div>data.Row</div>"
                                //});
                               
                                var mm ="";
                                for (var j = 0; j < data.Total; j++) {

                                    mm += "<div class='alert'><p>任务名称：" + data.Rows[j].taskName + "</p><p>创建时间：" + data.Rows[j].time + "</p><p>执行状态：" + data.Rows[j].status + "</p></div>"
                                }
                                layer.open({
                                    type: 1,
                                    area: ['455px', '455px'],
                                    shadeClose: true, //点击遮罩关闭
                                    content:mm
                                
                                  }); 
                            }

                            else {
                              // $.ligerDialog.error('暂无任务');
                            }
                        }
                    });
                    //alert($(this).children(".ht-rili-money").text());
                });
    }  

       
    </script>
</head>
<body>
    <form id="form1" runat="server">

        <div id="layout1">

            <div id="div_export" style="display: none; text-align: left; line-height: 30px; padding-left: 50px;">
                <p>功能描述： 
                    <input type="text" value="" style="width:200px" />
                    </p>
                <p>设定路线： 
                   <input type="text" value="" style="width:200px" />
                   </p>

                <p>执行时间： 
                    <input id="txt_zxtime" type="text" value="02:00" style="width:200px" />
                </p>
                   
                <p>是否启动： 
                    <input type="checkbox" checked style="width:100px" />
                </p>
                
                 <p>优先级： 
                    <input type="text" value="1" style="width:100px" />
                </p>
                 
            </div>


            <div position="left" title="任务执行时间表">
                <div class="layui-form">
                    <div class="layui-form-item" style="margin: 5px;">
                        <div class="layui-inline">
                            <label class="layui-form-label" style="width: 100px; padding: 5px 15px;">任务执行时间</label>
                            <div class="layui-input-inline">
                                <input style="height: 30px; line-height: 30px;" type="text" class="layui-input" id="time-year-month" placeholder="yyyy-MM" lay-key="3">
                            </div>
                            <div class="layui-input-inline">
                                <input type="button" class="layui-btn" value="查询" style="height: 30px; line-height: 30px;" onclick="searchMonth()" />
                            </div>
                        </div>

                    </div>
                </div>
                <div class="calendar-box demo-box" style="width: 100%; height: 680px"></div>
            </div>
            <div position="center">
                <div class="layui-form" style="padding-top: 8px;">
                    <div class="layui-form-item">
                        <label class="layui-form-label">任务状态</label>
                        <div class="layui-input-block">
                            <input id="ddzx" type="checkbox" name="like[ddzx]" title="等待执行" checked>
                            <input id="yzx" type="checkbox" name="like[yzx]" title="执行完成" checked>
                            <input id="zzzx" type="checkbox" name="like[zzzx]" title="正在执行" checked>
                            <input id="zz" type="checkbox" name="like[zz]" title="中途终止" checked>
                            <input id="rwcq" type="checkbox" name="like[rwcq]" title="任务超期" checked>
                        </div>
                    </div>
                    <div class="layui-form-item">
                        <label class="layui-form-label">开始时间</label>
                        <div class="layui-input-inline">
                            <input type="text" class="layui-input" id="beginDt">
                        </div>
                        <label class="layui-form-label">结束时间</label>
                        <div class="layui-input-inline">
                            <input type="text" class="layui-input" id="endDt">
                        </div>

                    </div>

                    <div class="layui-form-item">
                        <label class="layui-form-label">任务名称</label>
                        <div class="layui-input-inline">
                            <input type="text" class="layui-input" id="txtName">
                        </div>

                        <div class="layui-input-inline">
                            <input type="button" class="layui-btn" value="查询" onclick="search()" />
                        </div>

                    </div>


                </div>
                <div id="maingrid" style="margin: 0; padding: 0"></div>

                <%--定期执行弹窗--%>
        <div id="div_dingqirun" style="display: none; text-align: left; line-height: 30px; padding-right: 30px;">
            <div class="layui-form" action="">
                <div class="layui-form-item">
                    <label class="layui-form-label">定期描述</label>
                    <div class="layui-input-block">
                        <input type="text" name="titledesc" id="titledesc" lay-verify="titledesc" autocomplete="off" placeholder="请输入定期描述" class="layui-input">
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
<%--                        <input type="text" class="layui-input" id="time2" placeholder="HH:mm:ss" >--%>
                        <input type="text" class="layui-input" id="newtime" placeholder="HH:mm:ss" >
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
            </div>

        </div>
    </form>
</body>
</html>
