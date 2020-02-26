<%@ Page Language="C#" AutoEventWireup="true" CodeFile="三相对比分析.aspx.cs" Inherits="pages_三相对比分析" %>


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

    <script src="../lib/ligerUI/js/plugins/ligerLayout.js" type="text/javascript"></script>
    <script src="../lib/ligerUI/js/ligerui.min.js" type="text/javascript"></script>
    <script src="../lib/ligerUI/js/plugins/ligerGrid.js" type="text/javascript"></script>

    <script src="../lib/echarts/echarts.common.min.js" type="text/javascript"></script>

    <script src="../lib/js/publicMethodJs.js" type="text/javascript"></script>

    <style>
         .showMsgBox
        {
            
            width:900px;
            height:400px;
            /*background-color:Gray;*/
            overflow:auto;
            }
        .imgStyle
        {
            width:230px;
            height:128px;
            margin:0px;
            }
    </style>
    <script>
        var grid = null;
        var bodyHeight = document.documentElement.clientHeight; //页面高度
        var public_token = "<%=public_token %>";
        var public_userName = "<%=public_userName%>";
        var myChart;
        var public_selectedNode = "";
        var public_dectionId_click = ""; //用来记录双击的任务的巡检id
        var public_dectionId_A = ""; //用来记录A相位巡检id
        var public_dectionId_B = ""; //用来记录B相位巡检id
        var public_dectionId_C = ""; //用来记录C相位巡检id
        var public_taskId = ""; //用来记录任务id 寻找本次巡检的其他两个相位
        

        function onlySelectedSameTaskId(taskId){
            
            var gridLen=grid.rows.length;
            for(var i=0;i<gridLen;i++){
               if(grid.rows[i].taskId==taskId){
                    grid.select(grid.rows[i]);
                       
                }
                else{
                    grid.unselect(grid.rows[i]);
                }
            }
        }
        $(function () {

            $("#layout1").ligerLayout({ leftWidth: 300, rightWidth: 920 });
            //装载树结构
            $("#ftree").attr("src", "../tree/sanxiangTree.aspx");

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


            //显示表格
            grid = $("#maingrid").ligerGrid({
                columns: [
                   {display: "识别时间", name: "time", width: 130 },
                   { display: '点位名称', name: 'meterName', width: 220 },
                   { display: '识别结果', name: 'detectionValue', width: 100 },
                   { display: '采集信息', name: 'saveType', width: 180 },
                   { display: '任务ID', name: 'taskId', width: 0 ,hide:true }
                ]
                , checkbox:false
                , pageSize: 9
                //, pageSizeOptions: [10,30,50]
               , pageSizeOptions: [9]
                , width: '100%'
                , height: bodyHeight - 450
                , groupColumnName: 'taskId', groupColumnDisplay:'任务ID'
                , onDblClickRow : function (data, rowindex, rowobj)
                {
                    //onlySelectedSameTaskId(data.taskId);
                    public_taskId = data.taskId;//记录选中数据的巡检任务id
                  
                    select3Data(public_taskId); //一下选择3相
                } 
                ,onSelectRow: function (data, rowindex, rowobj){
                    
                    

                }
                
            });

            $(".showMsgBox").height(bodyHeight - 80);
            $("#ftree").height(bodyHeight - 68);
            $("#echart").height(300);


            myChart = echarts.init(document.getElementById('echart'));
            option = {
                title: {
                    text: "",
                    textStyle: {
                        color: "#000000"
                    },
                    show: true
                },
                tooltip: {
                    trigger: 'axis'
                },
                legend: {
                    textStyle:{
                        color:"#000000",
                    },
                    data: ['环境温度', 'A相', 'B相', 'C相']
                },
               
                xAxis: {
                    type: 'category',
                    boundaryGap: false,
                    data: ['周一', '周二', '周三', '周四', '周五', '周六', '周日']
                    ,axisLabel: {
                            textStyle: {
                            color: '#000000'
                            }
                            }
                },
                yAxis: {
                    type: 'value',
                    axisLabel: {
                        formatter: '{value} °C'
                    }
                    ,axisLabel: {
                            textStyle: {
                            color: '#000000'
                            }
                            }
                },
                series: [
                    {
                        name: '环境温度',
                        type: 'line',
                        itemStyle: {
                            normal: {
                                color: '#E87C25'
                            }
                        },  
                        data: [11, 11, 15, 13, 12, 13, 10]
                    },
                    {
                        name: 'A相',
                        type: 'line',
                        itemStyle: {
                            normal: {
                                color: '#8dd1a9'
                            }
                        },  
                        data: [1, -2, 2, 5, 3, 2, 0]
                       
                    }
                    ,
                    {
                        name: 'B相',
                        type: 'line',
                        itemStyle: {
                            normal: {
                                color: '#6cc1a9'
                            }
                        },  
                        data: [1, 10, 9, 5, 5, 2, 0]
                       
                    }
                    ,
                    {
                        name: 'C相',
                        type: 'line',
                        itemStyle: {
                            normal: {
                                color: '#8d21a9'
                            }
                        },  
                        data: [4, -5, 2, 5, 5, 2, 1]
                       
                    }
                ]
            };
            myChart.setOption(option, true);
        });

        function select3Data(data) {//选中三条数据
            $(this).css({"background-color":""});
            $("#showMsg").html("");   
            detail(data);
        }
        

        //点击树取得点位id
        function public_page_click(vId){
            //alert(vId);
            if (vId.indexOf("N") < 0)
                return;
            public_selectedNode = vId.replace("N", "");
            
            //search(); //点一下就切换 有点烦 没必要可以删了
        }

        //查询按钮
        function search() {
            if(!public_selectedNode){
                layer.msg("请先选择查询点位！");
                return;
            }
            //暂时用这个 正式替换为 下面注释掉的ajax 
            var beginDt = $("#beginDt").val();
            var endDt = $("#endDt").val();
            // 正式用：var vUrl = "/detectionData4Three?meterId=" + public_selectedNode + "&startTime=" + beginDt + "&endTIme=" + endDt + "&pageNum=1&pageSize=12&orderBy";
            var vUrl = "/detectionData4Three?meterId=" + public_selectedNode + "&pageNum=1&pageSize=12&orderBy";
           // console.log(vUrl);

            $.ajax({
                type: "get",
                url: "../handler/InterFace.ashx",
                data: {
                    method: "http_getGridMethod_expend"
                    , token: public_token
                    , MethodUrl: vUrl
                    , ListName: "list"
                },
                dataType: "json",
                success: function (data) {
                    console.log(JSON.stringify(data));
                    grid.set({ data: data });
                }
            });
        }

        function detail(data) {
            // console.log("data" + JSON.stringify(data));
            var msg = "";
            var vUrl = "/detectionData4Three?meterId=" + public_selectedNode + "&pageNum=1&pageSize=12&orderBy" + "&taskId="+data;
            // console.log(vUrl);
            
            $.ajax({
                type: "get",
                url: "../handler/InterFace.ashx",
                data: {
                    method: "http_getGridMethod_expend"
                    , token: public_token
                    , MethodUrl: vUrl
                    , ListName: "list"
                },
                dataType: "json",
                success: function (data) {
                    console.log(JSON.stringify(data));
                    grid.set({ data: data });
                    //   console.log(data.Rows);//获取到json数组以及单条数据
                 //  msg = $("#showMsg").html();
                    for (var k = 0; k < 3; k++) {
                        //$("#ddd").html(data.Rows[k].meterName);
                        msg = "<div class='layui-input-inline'><img id='detail-img1' src='" + data.Rows[k].vlpath + "' style='width: 192px; height: 108px;' /></div>";
                        msg += "<div class='layui-input-inline'> <img id='detail-img2' src='" + data.Rows[k].valuePath + "' style='width: 192px; height: 108px;' /></div>";
                        msg += "<div class='layui-input-inline'><audio id='detail-audio' class='imgStyle' src='" + data.Rows[k].voicePath + "'  controls='controls'></audio></div>";
                        msg+="<div class='layui-input-inline' style='width:160px;height:128px;margin-left:10px'>";
                        msg += "<p style=' margin-top 10px;'> 识别结果：<span id='detail-result'>" + data.Rows[k].detectionValue + "</span> </p>";
                        msg+="<p style=' margin-top 12px;'> 告警等级：";
                        msg+="<select id='detail-warn'><option value='正常' "+data+">正常</option>";
                        msg+="<option value='预警'>预警</option><option value='一般告警'>一般告警</option>";
                        msg+="<option value='严重告警'>严重告警</option><option value='危急告警'>危急告警</option></select></p>";
                        msg+="<p style=' margin-top 12px;'><div class='layui-block'>";
                        msg+="<input type='radio' name='shibie' value='识别正确' id='sbzq' title='识别正确' checked='checked'>识别正确  &nbsp;&nbsp;";
                        msg+="<input type='radio' name='shibie' value='识别错误' id='sbcw' title='识别错误'>识别错误 </div></p>"; 
                        msg+="<p style='margin-top:12px;'>实际值：<input id='detail-value' data-type='text' data-label='实际值' style='width:40px;height: 20px; line-height: 20px;' />";
                        msg+=" &nbsp;&nbsp;&nbsp;&nbsp;<input type='button' class='layui-input-inline' value='提交' style='width:40px;height:25px' onclick='sumitShenHe()' /></p></div>"; 
                        $("#showMsg").append(msg);
                  
                    }
                    
                }
            });
       
            
            //清空之前的结果
            clearRight();
            ////巡检结果读取到界面
            //if (data.meterName != null) {
            //    $("#detail-describ").html(data.meterName);
            //}
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
                url: "../handler/InterFace.ashx",
                data: {
                    method: "http_getMethod"
                    , token: public_token
                    , MethodUrl: "/checkDetectionDatas/" + data.id
                },
                dataType: "json",
                success: function (checkdata) {
                    //如果有审核数据 则读取到界面
                    console.log("checkdata" + JSON.stringify(checkdata));
                    if (checkdata) {
                        //读用户编辑后的真实值
                        if (checkdata.checkValue != null) {
                            $("#detail-value").attr("value",checkdata.checkValue);
                        }
                        //用表计数和编辑数对比 判断结果是否正确
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
                        }
                    }
                }
            });
        }

        function sumitShenHe() {
            //计算下正误 显示给客户 没什么用
            if ($("#detail-value").val() != null && $("#detail-value").val() != "") {
                if ($("#detail-result").html() == null || $("#detail-result").html() == "") {
                    $("input[name='shibie']").eq(1).click();
                }
                else {
                    if ($("#detail-result").html() != $("#detail-value").val())
                        $("input[name='shibie']").eq(1).click();
                    else
                        $("input[name='shibie']").eq(0).click();
                }
            } else {
                $("input[name='shibie']").eq(0).click();
            }

            var vTrueValue = $("#detail-value").val();
            var vTrueStatus = $("#detail-warn").find("option:selected").text(); 
            //layer.msg("开始保存！");
            var postData = "state=" + encodeURI("已修改") + "&checkValue=" + vTrueValue + "&checkRiseStatus="
                + vTrueStatus + "&userName=" + public_userName + "&detectionDataId=" + public_dectionId_click;
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
                    layer.msg(data.detail);
                }
            });
        }


        function f_getCheckedNodes(level) {
            var nodes = ftree.contentWindow.zTreeObj.getCheckedNodes();
            var names = "";
            var count = 0;
            for (var i = 0; i < nodes.length; i++) { node = nodes[i]; if (node.no.substring(0, 1) == level && !node.getCheckStatus().half) { names += node.no + ","; count += 1; } }
            if (count > 0) { names = names.substr(0, names.length - 1); }
            return names;
        }

        function clearRight() {
            //右侧初始化
            $("#detail-img1").src = "";
            $("#detail-img2").src = "";
            $("#sbzq").attr("checked", "checked");
            $("#detail-warn").val("正常");
            $("#detail-result").html("");
            $("#detail-value").attr("value","");
        }
    </script>
</head>
<body>
    <form id="form1" runat="server">
     <div id="layout1">
            <div  position="left" title="设备树" >
                <iframe id="ftree" frameborder=0 width="270px" height="600px" src="kong.htm" ></iframe>
            </div>
            <div position="center">
                
                 <div class="layui-form" style="padding-top:8px;" >

                       <div class="layui-form-item">
                            <label class="layui-form-label">开始时间</label>
                            <div class="layui-input-inline" style="width:110px">
                                 <input type="text" class="layui-input" id="beginDt">
                            </div>
                            <label class="layui-form-label">结束时间</label>
                            <div class="layui-input-inline" style="width:110px">
                                 <input type="text" class="layui-input" id="endDt">
                            </div>

                            <div class="layui-input-inline" style="width:110px">
                                 <input type="button" class="layui-btn" value="查询"  onclick="search()" />
                            </div>

                       </div>
                    </div>
                 <div id="maingrid" style="margin:0; padding:0"></div>
                 <div id="echart" style="margin:0; padding:0"></div>
                
            </div>
           <div position="right" title="图片 | 视频">
                <%--第一相--%> 
                <div title="展示图片" class="showMsgBox" id="showMsg" >
             
                 </div>         
            </div>
       </div>
    </form>
</body>
</html>
