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
        .l-bar-selectpagesize{
            display:none !important;
        }
        .l-grid-body-inner {
        width:600px !important;
        }
         #pagesize {
           padding-right:20px; 
           padding:0;height:20px;
           width:100%;text-align:right;
           background: #F5F5F5 url(../images/ui/gridbar.jpg) repeat-x;
           height: 30px;
           line-height: 30px;
           overflow: hidden;
           border-top: 1px solid #D6D6D6;
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

            alldata=[];
            //显示表格
            grid = $("#maingrid").ligerGrid({
                columns: [
                   {display: "识别时间", name: "time", width: 160 },
                   { display: '点位名称', name: 'meterName', width: 220 },
                   { display: '识别结果', name: 'detectionValue', width: 100 },
                   { display: '采集信息', name: 'saveType', width: 150 },
                   { display: '任务ID', name: 'taskId', width:150,hide:true  }
                ]
                , checkbox:false
                , pageSize: 3
                , usePager: false               //, pageSizeOptions: [10,30,50]
               //, pageSizeOptions: [3]
                , width: '100%'
                , height: bodyHeight - 450
                , groupColumnName: 'taskId', groupColumnDisplay:'任务ID'
                , onDblClickRow : function (data, rowindex, rowobj)
                {
                    //onlySelectedSameTaskId(data.taskId);
                    public_taskId = data.taskId;//记录选中数据的巡检任务id
                    //alert(public_taskId);
                    $("#taskidne").html("任务ID:"+ public_taskId);
                    var jsonArr = [];
                    for (var i = 0; i < alldata.length; i++) {
                        if (alldata[i]["taskId"] == public_taskId) {
                            jsonArr.push(alldata[i]);
                        }
                    }
                   
                   // console.log(jsonArr);
                    select3Data(jsonArr); //一下选择3相
               
                    
                    //char(public_taskId);
                } 
                ,onSelectRow: function (data, rowindex, rowobj){
                }
                , onAfterShowData: function (data) {
                    alldata=data.Rows;
                   //  console.log(alldata);
                    $("#pagesize").html("共有&nbsp;" + data.Total +"&nbsp;条数据&nbsp;&nbsp;&nbsp;&nbsp");

                }
                
            });
            
            
        });

        function turnDate(input) {
            var fullDate = input.split(" ")[0].split("-");
            var fullTime = input.split(" ")[1].split(":");
            return new Date(fullDate[0], fullDate[1] - 1, fullDate[2], (fullTime[0] != null ? fullTime[0] : 0), (fullTime[1] != null ? fullTime[1] : 0), (fullTime[2] != null ? fullTime[2] : 0));
        }

        function char(id) {
            
            $(".showMsgBox").height(bodyHeight - 80);
            $("#ftree").height(bodyHeight - 68);
            $("#echart").height(300);


            myChart = echarts.init(document.getElementById('echart'));
            var beginDt = $("#beginDt").val();
            var taskId = id;
            var endDt = $("#endDt").val();
            //正式版
            //  var vUrl = "/meters/" + public_selectedNode + "/detectionDatas?startDate=" + beginDt + "&endDate=" + endDt + "&status=&pageNum=1&pageSize=10&orderBy&taskId=" + taskId;
            //测试版
           var vUrl = "/detectionData4Three?meterId=" + public_selectedNode + "&startTime=" + beginDt + "&endTIme=" + endDt + " 23:59:59" + "&orderBy";
           
            $.ajax({
                type: "get",
                url: "../handler/InterFace.ashx?r=" + Math.random(),
                data: {
                    method: "http_getGridMethod_expend"
                    , token: public_token
                    , MethodUrl: vUrl
                    , ListName: "list"
                },
                dataType: "json",
                success: function (data) {
                if (!data.success ) {
                                         layer.msg(data.detail);
                                        return;

                    }
                    var arr = data.Rows;
                   var time = [];
                   var detectionValue = [];
                   for(var i=0;i<arr.length;i++){
                       time[i] = turnDate(arr[i].time);                    
                      // time[i] = arr[i].time.substr(0, 10).replace(/-/g, '/');
                       detectionValue[i] = arr[i].detectionValue;
                    
                   }
                    //time.sort((a, b) => a.localeCompare(b) || a.localeCompare(b));//对时间排序,兼容模式

                    time.sort();
 
                    time.sort(function (m, n) {
                     if (m < n) return -1
                     else if (m > n) return 1
                     else return 0
                    });
                    //对格式化的时间转换成能看懂的那种
                
                    var timeuse = [];
                    for (var i = 0; i < time.length;i++) { 

                        timeuse[i] = time[i].getFullYear() + '-' + (( time[i].getMonth() + 1) >=10 ? (time[i].getMonth() + 1) : "0"
                        + (time[i].getMonth() + 1)) + '-' + (time[i].getDate() < 10 ? "0" + time[i].getDate() : time[i].getDate());
                      
                    }
         
                     var hash=[];//时间去重
                     for (var i = 0; i < timeuse.length; i++) {
                         if(timeuse.indexOf(timeuse[i])==i){
                              hash.push(timeuse[i]);
                          }
                      }
                      // console.log(hash); 
                    var data4 = [];
                    for(var n=0;n<arr.length/3;n++){

                          data4.push(arr[n]);

                    }
                       
                   // 根据日期排，没有数据为空,每条数据都是五个元素，
                    var d4 = [];
                    for (var c = 0; c < hash.length; c++) {
                        for (var i = 0; i < data4.length; i++) {
                           
                            if (hash[c] == data4[i].time.substr(0, 10)) {
                               
                                d4[c] = data4[i].detectionValue;
                                break;
                            }else{
                                 d4[c] = "";
                             } 
                        }         
                    }
                 
                    var data5 = [];
                      for(var n=arr.length/3;n<(arr.length/3)*2;n++){
                      
                          data5.push(arr[n]);

                    }
                    var d5 = [];
                    for (var c = 0; c < hash.length; c++) {
                        for (var i = 0; i < data5.length; i++) {
                           
                            if (hash[c] == data5[i].time.substr(0, 10)) {
                               
                                d5[c] = data5[i].detectionValue;
                                break;
                            }else{
                                 d5[c] = "";
                             } 
                        }         
                    }
                  
                    var data6 = [];
                      for(var n=(arr.length/3)*2;n<arr.length;n++){
  
                          data6.push(arr[n]);

                     
                    }
                    var d6 = [];
                     for (var c = 0; c < hash.length; c++) {
                        for (var i = 0; i < data6.length; i++) {
                          
                            if (hash[c] == data6[i].time.substr(0, 10)) {
                               
                                d6[c] = data6[i].detectionValue;
                                break;
                            }else{
                                 d6[c] = "";
                             } 
                        }         
                    }
               
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
                        data: [ 'A相', 'B相', 'C相']
                    },
               
                    xAxis: {
                        type: 'category',
                        boundaryGap: false,
                        data: hash,
                        axisLabel: {
                             rotate: 60,
                            textStyle: {
                                fontSize:10,
                           
                                }
                        },
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
       
                            connectNulls: true,
                            name: 'A相',
                            type: 'line',
                            itemStyle: {
                                normal: {
                                    color: '#ff6633'
                                }
                            },  
                            data: d4
                       
                        }
                        ,
                        {
                            connectNulls: true,
                            name: 'B相',
                            type: 'line',
                            itemStyle: {
                                normal: {
                                    color: '#6cc1a9' 
                                }
                            },  
                            data: d5                    
                        }
                        ,
                        {connectNulls: true,//断点连续
                            name: 'C相',
                            type: 'line',
                            itemStyle: {
                                normal: {
                                    color: '#8d21a9'
                                }
                            },  
                             data: d6
                       
                        }
                    ]
                };
                myChart.setOption(option, true);
                }
            });
            
        }
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
            // 正式用：
            //var vUrl = "/detectionData4Three?meterId=" + public_selectedNode + "&startTime=" + beginDt + "&endTIme=" + endDt + "&pageNum=1&pageSize=12&orderBy";
            var vUrl = "/detectionData4Three?meterId=" + public_selectedNode + "&startTime=" + beginDt + "&endTIme=" + endDt + " 23:59:59" + "&orderBy";
           //console.log(vUrl);

            $.ajax({
                type: "get",
                url: "../handler/InterFace.ashx?r=" + Math.random(),
                data: {
                    method: "http_getGridMethod_expend"
                    , token: public_token
                    , MethodUrl: vUrl
                    , ListName: "list"
                },
                dataType: "json",
                success: function (data) {
                    if (!data.success ) {
                                         layer.msg(data.detail);
                                        return;

                                     }
                   
                 // console.log(JSON.stringify(data));
                    grid.set({ data: data });
                    char();
                }
            });
        }

        function detail(data) {
            // console.log("data" + JSON.stringify(data));
          
          
                    console.log(data);
                  
                   // console.log(JSON.stringify(data));
                 //   grid.set({ data: data });
                    //   console.log(data.Rows);//获取到json数组以及单条数据
                 //  msg = $("#showMsg").html();
            for (var k = 0; k < 3; k++) {
                        checktrue(data[k].id,k);
                        //$("#ddd").html(data.Rows[k].meterName);
                        if (data[k].detectionStatus == null) {
                            data[k].detectionStatus = "正常";
                        }
                        
                        msg = "<div class='layui-input-inline'><img class='detail-img1' src='" + data[k].vlpath + "' style='width: 192px; height: 108px;' /></div>";
                        msg += "<div class='layui-input-inline'> <img class='detail-img2' src='" + data[k].valuePath + "' style='width: 192px; height: 108px;' /></div>";
                        msg += "<div class='layui-input-inline'><audio class='detail-audio' class='imgStyle' src='" + data[k].voicePath + "'  controls='controls'></audio></div>";
                        msg+="<div class='layui-input-inline' style='width:160px;height:128px;margin-left:10px'>";
                        msg += "<p style=' margin-top 10px;'> 识别结果：<span class='detail-result' id='detail-result"+k+"'>" + data[k].detectionValue + "</span> </p>";
                        msg += "<p style=' margin-top 12px;'> 告警等级：";
                        msg += "<select class='detail-warn' id='detail-warn"+k+"'>";
                        if (data[k].detectionStatus == '正常') {
                            msg += "<option value='正常' selected>正常</option>";
                            msg +="<option value='预警'>预警</option>";
                            msg += "<option value='一般告警'>一般告警</option>";
                            msg +="<option value='严重告警'>严重告警</option>";
                            msg +="<option value='危急告警'>危急告警</option>";
                        }if (data[k].detectionStatus == '预警') {
                            msg += "<option value='正常'>正常</option>";
                            msg +="<option value='预警' selected>预警</option>";
                            msg += "<option value='一般告警'>一般告警</option>";
                            msg +="<option value='严重告警'>严重告警</option>";
                            msg +="<option value='危急告警'>危急告警</option>";
                        }
                        if (data[k].detectionStatus == '一般告警') {
                            msg += "<option value='正常'>正常</option>";
                            msg +="<option value='预警'>预警</option>";
                            msg += "<option value='一般告警'selected>一般告警</option>";
                            msg +="<option value='严重告警'>严重告警</option>";
                            msg +="<option value='危急告警'>危急告警</option>";
                        }
                        if (data[k].detectionStatus == '严重告警') {
                            msg += "<option value='正常'>正常</option>";
                            msg +="<option value='预警'>预警</option>";
                            msg += "<option value='一般告警'>一般告警</option>";
                            msg +="<option value='严重告警'selected>严重告警</option>";
                            msg +="<option value='危急告警'>危急告警</option>";
                        }
                        if (data[k].detectionStatus == '危急告警') {
                            msg += "<option value='正常' >正常</option>";
                            msg +="<option value='预警'>预警</option>";
                            msg += "<option value='一般告警'>一般告警</option>";
                            msg +="<option value='严重告警'>严重告警</option>";
                            msg +="<option value='危急告警' selected>危急告警</option>";
                        }
                        msg+="</select></p>";
                        msg+="<p style=' margin-top 12px;'><div class='layui-block'>";
                        msg+="<input type='radio' name='shibie"+k+"' value='识别正确' class='sbzq' title='识别正确' checked='checked'>识别正确  &nbsp;&nbsp;";
                        msg+="<input type='radio' name='shibie"+k+"' value='识别错误' class='sbcw' title='识别错误'>识别错误 </div></p>"; 
                        msg+="<p style='margin-top:12px;'>实际值：<input class='detail-value' data-type='text' data-label='实际值' id='detail-value"+k+"' style='width:40px;height: 20px; line-height: 20px;' />";
                        msg+=" &nbsp;&nbsp;&nbsp;&nbsp;<input type='button' class='layui-input-inline' value='提交' style='width:40px;height:25px' onclick='sumitShenHe("+data[k].id+","+k+")' /></p></div>"; 
                        $("#showMsg").append(msg);
                  
                    }
                    
          
       
            
            //清空之前的结果
            clearRight();
            ////巡检结果读取到界面
            //if (data.meterName != null) {
            //    $("#detail-describ").html(data.meterName);
            //}
        
        }
        function checktrue(data,k) {


              $.ajax({
                type: "post",
                url: "../handler/InterFace.ashx?r=" + Math.random(),
                data: {
                    method: "http_getMethod"
                    , token: public_token
                    , MethodUrl: "/checkDetectionDatas/" + data
                },
                dataType: "json",
                success: function (checkdata) {
                    if (!checkdata.success) {
                        layer.msg(checkdata.detail);
                        return;
                    }
                   
                    checkdata = checkdata.data;
                     console.log(checkdata);
                    //如果有审核数据 则读取到界面
                    if (checkdata) {
                        //读用户编辑后的真实值
                        detectionValue = $("#detail-result" + k).html();
                       
                        if (checkdata.checkValue != null && checkdata.checkValue != "") {
                            if (detectionValue == null || detectionValue == "") {
                                $("input[name='shibie"+k+"']").eq(1).click();
                            }
                            else {
                                if (detectionValue != checkdata.checkValue)
                                    $("input[name='shibie"+k+"']").eq(1).click();
                                else
                                    $("input[name='shibie"+k+"']").eq(0).click();
                            }
                        } else {
                            $("input[name='shibie']").eq(0).click();
                        }
                        //读取编辑后的状态 （覆盖原有状态）
                        if (checkdata.checkValue != null && checkdata.checkValue != "") {
                            $("#detail-value" + k).val(checkdata.checkValue);
                        } else {
                            $("#detail-value" + k).val("");
                        }
                         if (checkdata.checkRiseStatus != null && checkdata.checkRiseStatus != "") {
                            $("#detail-warn" + k).val(checkdata.checkRiseStatus);
                        } else {
                            $("#detail-warn" + k).val("");
                        }
                    }
                }
            });

        }
        function sumitShenHe(data,k) {
         
            //计算下正误 显示给客户 没什么用
            console.log(data);
          
                    var vTrueValue = $('#detail-value' + k).val();

                    var vTrueStatus = $("#detail-warn" + k).find("option:selected").text();

                    var status = "已确认";
                    if (vTrueValue != null && vTrueValue != "")
                        status = "已修改"
                    var postData = "state=" + encodeURI(status) + "&checkValue=" + vTrueValue + "&checkRiseStatus=" + vTrueStatus + "&userName=" + public_userName + "&detectionDataId=" + data;
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
                
            
                    //通过id获取审核数据 
            
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
                <iframe id="ftree" frameborder=0 width="270px" height="850px" src="kong.htm" ></iframe>
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
                 <div id="pagesize">
                  
                 </div>
                 <div id="echart" style="margin:0; padding:0"></div>
                
            </div>
           <div position="right" title="图片 | 视频">
               <div id="taskidne"></div>
                <%--第一相--%> 
                <div title="展示图片" class="showMsgBox" id="showMsg" >
                
                 </div>         
            </div>
       </div>
    </form>
                 
</body>
</html>
