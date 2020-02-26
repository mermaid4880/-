<%@ Page Language="C#" AutoEventWireup="true" CodeFile="对比分析页面.aspx.cs" Inherits="pages_对比分析页面" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>对比分析</title>

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
            height:auto;
            /*background-color:Gray;*/
            overflow:auto;
            }
        .imgStyle
        {
            width:230px;
            height:128px;
            margin:0px;
            
            }

        .class4 {
            width: 400px; height: 225px;margin:15px;
        }
          .class9 {
            width: 250px; height:141px;margin:20px;
        }
         .class16 {
            width: 180px; height: 102px;margin:20px;
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
        #showMsg {
        
        }
      .l-bar-selectpagesize{
            display:none !important;
        }
       .l-grid-body-inner {
        width:600px !important;
       }
        #radio{
            /*修改radio样式*/
        }
          label input[type="radio"] {
            appearance: none;
            -webkit-appearance: none;
            outline: none;
            margin: 0;
        }

        label input[type="radio"]:after {
            display: block;
            content: "";
            width: 12px;
            height: 12px;
            background: #fff;
            border-radius: 50%;
            border: 2px solid #009688;
        }

        label input[type="radio"]:checked:after {
            background: #009688;
             width: 20px;
            height: 20px;
            border: 2px solid #fff;
        }

    </style>
    <script>
        vvid = 9;
        function public_page_click1(vId) {
            vvid = vId;
            $(".l-bar-selectpagesize").html(vvid);
        }     
        //正常
        var grid = null;
        var bodyHeight = document.documentElement.clientHeight; //页面高度
        var public_token = "<%=public_token %>";
        var public_userName = "<%=public_userName%>";
        var myChart;
        var public_selectedNode = "";
        var public_dectionId = "";
        $(function () {

            $("#layout1").ligerLayout({ leftWidth: 300, rightWidth: 920 });
            //装载树结构
            $("#ftree").attr("src", "../tree/allTree_nocheckbox.aspx");

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
                   {display: "识别时间", name: "time", width: 160 },
                   { display: '点位名称', name: 'meterName', width: 220 },
                   { display: '识别结果', name: 'detectionValue', width: 100 },
                   { display: '采集信息', name: 'saveType', width: 155 }
                ]
                ,url:"../handler/InterFace.ashx?r=" + Math.random()+"/meters/" + public_selectedNode + "/detectionDatas"
                , checkbox:false
                , pageSize: 10
                , pageSizeOptions:[vvid]
                , usePager: false
                , width: '100%'
                , height: bodyHeight - 450
                , onDblClickRow : function (data, rowindex, rowobj)
                {
                    showmsg(data);
                    // console.log(data.meterName);
                    // parent.window.public_page_click(data.meterName);
                    detail(data);
                    //public_dectionId = data.id;
                }
                , onAfterShowData: function (data) {
                    console.log(data);
                    $("#pagesize").html("共有&nbsp;" + data.Total +"&nbsp;条数据&nbsp;&nbsp;&nbsp;&nbsp");

                }
            });
           
          
        });
      

        function turnDate(input) {
            var fullDate = input.split(" ")[0].split("-");
            var fullTime = input.split(" ")[1].split(":");
            return new Date(fullDate[0], fullDate[1] - 1, fullDate[2], (fullTime[0] != null ? fullTime[0] : 0), (fullTime[1] != null ? fullTime[1] : 0), (fullTime[2] != null ? fullTime[2] : 0));
        }
        //显示echar组件
        function char() {
            $(".showMsgBox").height(bodyHeight - 80);
            $("#ftree").height(bodyHeight - 68);
            $("#echart").height(300);

           

            myChart = echarts.init(document.getElementById('echart'));
            var beginDt = $("#beginDt").val();
            var endDt = $("#endDt").val();
            var vUrl = "/meters/" + public_selectedNode + "/detectionDatas?startDate=" + beginDt + "&endDate=" + endDt + "&status=&orderBy";
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
                     // console.log(data);
                    if (data.success != true) {
                        layer.msg(data.detail);
                        return;
                    }

                    var time =[];
                    var detectionValue = [];
                    for (var k = 0; k < data.Total; k++) {

                        time[k] = turnDate(data.Rows[k].time); 
                           
                        detectionValue[k]=parseInt(data.Rows[k].detectionValue);
                       
                          
                    } 
                   
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
                      console.log(hash);
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
                    data: hash
                  
                    , axisLabel: {
                         rotate: 60,
                        textStyle: {
                            fontSize:10,
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
                        name: '',
                        type: 'line',
                        itemStyle: {
                            normal: {
                                color: '#6cc1a9'
                            }
                        },  
                        data: detectionValue
                       
                    }
                    
                   
                ]
            };  
            myChart.setOption(option, true);
                   // grid.set({ data: data });
                }//

            
            });
           

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
        function search(id, checkPoint) {
            //alert(checkPoint);
            if (!checkPoint) {
                return;
            }
            clearRight();
            if(!public_selectedNode && checkPoint){
                layer.msg("请先选择查询点位！");
                return;
            }
            //暂时用这个 正式替换为 下面注释掉的ajax 
            var beginDt = $("#beginDt").val();
            var endDt = $("#endDt").val();
            var vUrl = "/meters/" + public_selectedNode + "/detectionDatas?startDate=" + beginDt + "&endDate=" + endDt + "&status=&orderBy";
           // console.log(vUrl);
            //var vParaArray = [];
            //vParaArray.push({ "key": "startDate", "value": beginDt });
            //vParaArray.push({ "key": "endDate", "value": endDt });
            //vParaArray.push({ "key": "status", "value": getAllStatus() });
            //grid.setParm("param1", JSON2.stringify(vParaArray));
            //grid.reload();
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
                    console.log(data);
                    if (data.success != true) {
                        layer.msg(data.detail);
                        return;
                    }

                    grid.set({ data: data });
                    char();//调用

                    showright(data, 4);
                    showright(data, 9);
                    showright(data, 16);
                }
            });
        }

        function detail(data) {
       
           // console.log("data" + JSON.stringify(data));
            //清空之前的结果
          //clearRight();
            ////巡检结果读取到界面
            //if (data.meterName != null) {
            //    $("#detail-describ").html(data.meterName);
            //}
            //if (data.meterName != null) {
            //    $("#meterName").html(data.meterName);
            //    $("#detail-img1").val(data.filepath + ".jpg");
            //     $("#detail-img2").val(data.filepath + "_结果.jpg");
            //    $("#detail-audio").val(data.filepath + ".wav"); 
            //}
            //if (data.detectionValue != null) {
            //    $("#detail-result").html(data.detectionValue);
            //}
            //if (data.detectionStatus != null) {
            //    $("detail-warn").val(data.detectionStatus);
            //}
             var msg = "";
            var vUrl = "/detectionData4Three?meterId=" + public_selectedNode + "&pageNum=1&pageSize=12&orderBy" + "&taskId="+data;
            // console.log(vUrl);
            
          
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
                    // console.log("checkdata" + JSON.stringify(checkdata));
                    console.log(22); checkdata = checkdata.data;
                 console.log(checkdata);
                    if (checkdata) {
                      
                        if (checkdata.checkRiseStatus != null && checkdata.checkRiseStatus != "") {
                           
                             document.getElementsByName("detail-warn")[0].value=checkdata.checkRiseStatus;
                        } else {
                             document.getElementsByName("detail-warn")[0].value="正常";
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
                + vTrueStatus + "&userName=" + public_userName + "&detectionDataId=" + public_dectionId;
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


        function id4(checkPoint) {
            $("#showMsgBox4").css({ "display": "block" });
            $("#showMsgBox9").css({ "display": "none" });
            $("#showMsgBox16").css({ "display": "none" });
           // public_page_click1(4);
           
            search(4,checkPoint);
        }

        function id9(checkPoint) {
            $("#showMsgBox4").css({ "display": "none" });
            $("#showMsgBox16").css({ "display": "none" });
            $("#showMsgBox9").css({ "display": "block" });
            //public_page_click1(9);
         
           search(9,checkPoint);
        }

        function id16(checkPoint) {
            $("#showMsgBox4").css({ "display": "none" });
            $("#showMsgBox9").css({ "display": "none" });
            $("#showMsgBox16").css({ "display": "block" });
            //public_page_click1(16);

             search(16,checkPoint);
        }
      
        function load() {
            id9(false);
            $("#showMsg").css({ "display": "none" });
        }
     
        function showmsg(data) {
         
            layer.open({
                type: 1,
                area: ['600px', '420px'],
                shadeClose: true, //点击遮罩关闭
                content: $('#showMsg'),
                success: function () {
                    
                    console.log(data);
                    $("#detail-img1").attr("src", data.vlpath);
                    $("#detail-img2").attr("src", data.valuePath);
                    $("#detail-audio").attr("src", data.voicePath);
                    $("#detail-result").html(data.detectionValue);
             
                    $("#detail-warn").val(data.detectionStatus);
                    $("#meterName").html(data.meterName);                    
            }

            });
      
        }
        function showright(data, id) {
             $("#showMsgBox"+id+"").html("");
          var msg = "";
         for (var k = 0; k < data.Total; k++) {
    
             msg = "<div class='layui-input-inline' >";
             
                         
             msg += "<img id='detail-rimg"+id+"' src='"+data.Rows[k].vlpath+"' onclick='showmsg(" + JSON.stringify(data.Rows[k])+ ");'  class='class"+id+"'/> </div> ";
             $("#showMsgBox"+id+"").append(msg);
            }
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

            alert(strStatus);
            return strStatus;
        }
        
    </script>
</head>
<body onload="load()">
    <form id="form1" runat="server">
     <div id="layout1">
            <div  position="left" title="设备树" >
                <iframe id="ftree" frameborder=0 width="350px" height="850px" src="kong.htm" ></iframe>
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
                                 <input type="button" class="layui-btn" value="查询"  onclick="search(9,true)" />
                            </div>

                       </div>
                    </div>
                 <div id="maingrid" style="margin:0; padding:0">
                     
                 </div>
                 <div id="pagesize">
                  
                 </div>
                 <div id="echart" style="margin:0; padding:0"></div>
                
            </div>
           <div position="right" title="图片 | 视频">

<label><input type="radio" onclick="id4(true)" id="radio" name="a" />两列 &nbsp;&nbsp;</label>
    <label><input type="radio" id="radio" name="a" onclick="id9(true)"  checked/>三列 &nbsp;&nbsp;</label>
              <label> <input type="radio" id="radio"  name="a" onclick="id16(true)"/>四列</label>


<%--     <% --4排位-- %>--%>

               
               <div title='展示图片' class='showMsgBox' id='showMsgBox4'> </div>
         <%--      <%-9排位- %>--%>
                <div title="展示图片" class="showMsgBox" id="showMsgBox9"></div>
                 <%--<%-16排位- %>--%>
                <div title="展示图片" class="showMsgBox" id="showMsgBox16"></div>


          
            </div>
       </div>
    </form>


   <%-- 点击显示的弹出框开始--%>
      
     <div id="showMsg" style="display: none; text-align: left; line-height: 30px; padding-left: 50px;">
                    <div style="width: 50%; float: left;">
                        <p>点位信息：<span id="meterName"></span></p>
                        <p>
                            可见光图片：<br />
                            <img id="detail-img1" src="" style="width: 192px; height: 108px;" />
                        </p>
                        <p>
                            红外图片：<br />
                            <img id="detail-img2" src="" style="width: 192px; height: 108px;" />
                        </p>
                       
                    </div>

                    <div style="width: 50%; float: left; margin-top: 50px;">
                        <p>
                            识别结果：<span  id="detail-result"></span>
                        </p>
                        <p style="margin-top:50px;" >
                            告警等级：  
                            <select id="detail-warn" name="detail-warn">
                                    <option value="正常" >正常</option>
                                    <option value="预警" >预警</option>
                                    <option value="一般告警">一般告警</option>
                                    <option value="严重告警" >严重告警</option>
                                    <option value="危急告警">危急告警</option>
                             </select>       
                        </p>
                         <p  style="margin-top:50px;">
                            音频文件：<br />
                            <audio id="detail-audio" src="" style="width: 260px; height: 50px;" controls="controls"></audio>
                        </p>
                        <%-- <p style="margin-top:50px;" >
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
                        </p>--%>
                    </div>
                </div>
   <%-- 点击显示框结束--%>
</body>
</html>
