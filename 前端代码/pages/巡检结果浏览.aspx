<%@ Page Language="C#" AutoEventWireup="true" CodeFile="巡检结果浏览.aspx.cs" Inherits="pages_巡检结果浏览" %>

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

    <script src="../lib/js/publicMethodJs.js" type="text/javascript"></script>
    <script src="public_getTreeJs.js" type="text/javascript"></script>
    <script src="../js/json2.js" type="text/javascript"></script>
    <script src="../js/FileSaver.js" type="text/javascript"></script>

    <style>
        .showMsgBox
        {
            width:100%;
            height:600px;
            /*background-color:Gray;*/
            overflow:auto;
            }
        .imgStyle
        {
            width:396px;
            height:220px;
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
    <script>
        var excelUrl = ""; //定义导出excel需要的url 也就是请求的url 将url告诉后端 即可轻松导出
        var bodyHeight = document.documentElement.clientHeight; //页面高度
        var layer;
        var grid;
        var public_token = "<%=public_token%>";
        var public_userName = "<%=public_userName%>";

        $(function () {

            $("#txtUserName").val(public_userName);

            $("#layout1").ligerLayout({ leftWidth: 300});

            //装载树结构
            $("#ftree").attr("src", "../tree/allTree.aspx");


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
                    { display: '任务名称', name: 'taskInfoName', minWidth: 450 },
                    { display: '点位名称', name: 'meterName', width: 350 },
                    { display: '识别时间', name: 'time', width: 200 },
                    { display: '识别结果', name: 'detectionValue', width: 200 },
                    { display: '采集信息', name: 'saveType', width: 300 }
                ]
                , pageSize: 6
                , pageSizeOptions:[6]
                , width: '100%'
                , height: 260
                , checkbox: false
                , url: "../handler/loadGrid.ashx?view=http_getGridMethod_expend&methodName=detectionDatas"
                , delayLoad: true
                //添加一个双击回调
                , onDblClickRow: function (data, rowindex, rowobj) {
                    detail(data)
                }
                , onAfterShowData: function (data) {
                    showPic(data);
                }
            });

        });

       ////根据taskid过滤树结构
       //function filterTree(vTaskId) {

       //    if (vTaskId) {

       //        $.ajax({
       //            type: "post",
       //            url: "../handler/InterFace.ashx",
       //            data: {
       //                method: "http_getMethod"
       //                 , token: public_token
       //                 , MethodUrl: "/taskInfos/" + vTaskId + "/detectionDatas?status=&pageNum=1&pageSize=1&orderBy"
       //            },
       //            dataType: "json",
       //            success: function (data) {
       //                if (data) {

       //                    var meterIdList = [];
       //                    for (var i = 0; i < data.list.length; i++) {
       //                        meterIdList.push("N" + data.list[i].meterId);
       //                    }
       //                    //这里操作数
       //                    iframe1.window.public_filterTree(meterIdList)
       //                }
       //            }
       //        });
            
       //    }

       //}  

        function searchDB() {
            var vHtml = "";
            vHtml += "<div class='layui-input-inline' style='cursor:pointer' ><img src='' class='imgStyle'/><br/><span style='text-align: center;display:block;'></span></div>";
            $("#picBox").html(vHtml);

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
            grid.setParm("param1", JSON2.stringify(vParaArray));
            grid.reload();

            //记录url
            excelUrl = "http://47.107.94.142:8080" + "/detectionDatas?meterIDs=" + meters + "&startDate=" + startTime + "&endDate=" + endTime + "&status=&orderBy";
            //alert(excelUrl);
        }

        //图片显示
        function showPic(data) {
            console.log(data);

            if (data.Rows.length == 0) {
                //alert(1);
                layer.msg("没有符合条件的数据");
                
            } else {
                //alert(2);
                console.log(data.Rows.length);

                var vLen = data.Rows.length;
                var vHtml = "";
                for (var i = 0; i < vLen; i++) {
                    console.log(data.Rows[i]);
                    vHtml += "<div class='layui-input-inline' style='cursor:pointer' onclick='detai_ClicklPic(" + data.Rows[i].id + ")'><img src='" + data.Rows[i].valuePath + "' class='imgStyle'/><br/><span style='text-align: center;display:block;'>" + data.Rows[i].meterName + "</span></div>";
                }
               
                $("#picBox").html(vHtml);
                //grid.set({ data: data });
            }
                    
        }

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

        //点击图片div响应方法 
        function detai_ClicklPic(i) {
            //按id查询巡检记录
            $.ajax({
                type: "get",
                url: "../handler/InterFace.ashx?r=" + Math.random(),
                data: {
                    method: "http_getMethod"
                    , token: public_token
                    , MethodUrl: "/detectionDatas/" + i
                },
                dataType: "json",
                success: function (data) {
                    if (data.success != true) {
                        layer.msg(data.detail);
                        return;
                    }
                    data = data.data;
                    //有数据就装载数据并弹出详情
                    if (data.id != null && data.id != "") {
                        detail(data);
                    }
                }
                
            });
        }

        //双击响应方法 弹出页面 显示单条巡检记录明细
        function detail(data) {
            console.log(data);
            clearMenu();
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
  
        function clearMenu() {
            //右侧初始化
            $("#detail-img1").src = "";
            $("#detail-img2").src = "";
            $("#sbzq").attr("checked", "checked");
            $("#detail-warn").val("正常");
            $("#detail-result").html("");
            $("#detail-value").attr("value","");
        }


        function itemclick(item) {
            alert(item.text);
        }

        function chongzhi() {
            window.location.reload();
            //layui.use(['layer', 'form', 'laydate'], function () {
            //    var form = layui.form;
            //    layer = layui.layer;
            //    var laydate = layui.laydate;
            //    laydate.render({
            //        elem: '#beginDt' //指定元素
            //        , value: getCurrentAddDayYMD(-30)
            //    });
            //    laydate.render({
            //        elem: '#endDt' //指定元素
            //        , value: getCurrentAddDayYMD(0)
            //    });
            //});
            //layer.msg("重置完成");
        }

         function status(obj) {
            $(obj).children("div").toggleClass("layui-form-checked");
            var checkall = $(obj).children("input").is(':checked');
            console.log(checkall);
            if (checkall==true) {
                 $(obj).children("input").prop("checked",false);
            } else {
                $(obj).children("input").prop("checked",true);
            }
       
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
                    //alert(JSON.stringify(data));
                    //处理返回值
                    if (data) {
                        //alert("111");
                        console.log(data);
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

        //审核信息--获取
        function get_shenhexinxin(vId) {

            $.ajax({
                type: "post",
                url: "../handler/InterFace.ashx?r=" + Math.random(),
                data: {
                    method: "http_getMethod"
                    , token: public_token
                    , MethodUrl: "/checkDetectionDatas/" + vId
                },
                dataType: "json",
                success: function (data) {
                     
                    //这里装载一下 
                    if (data) {
                        console.log(data);
                        var vHtml = "";
                        vHtml += "<p style='margin-top:5px'>设备名称:<br/>压力表111</p>";
                        vHtml += "<p style='margin-top:5px'>识别时间:<br/>" + data.time + "</p>";
                        vHtml += "<p style='margin-top:5px'>识别值:<br/>" + data.checkValue + "</p>"
                        vHtml += "<p style='margin-top:5px'>阔值:<br/>" + data.checkRiseStatus + "</p>"
                        vHtml += "<hr/>";
                        $("#div_shenhe").html(vHtml);
                    }
                }
            });

        }

        function sumitShenHe() {
            //这里进行提交
            layer.msg("这里进行提交");
            var postData = "detectionDataId=2&state=1&checkValue=10&checkRiseStatus=2&userName=mozhichao";

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
                    if (data) {
                        layer.msg("提交："+data.detail);
                    }
                }
            });

        }

    </script>
</head>
<body>
    <form id="form1" runat="server" >
      <div id="layout1" >
            <div position="left" title="点位树" style="padding-left: 10px">
                <iframe id="ftree" frameborder="0" height="828px" width="100%" src="kong.htm"></iframe>
            </div>
            <div position="center" title="">
                <div class="layui-form" style="padding-top:8px;" >

                    <div class="layui-form-item">
                        <label class="layui-form-label">开始时间</label>
                        <div class="layui-input-inline" style="width:100px">
                                <input type="text" class="layui-input" id="beginDt">
                        </div>
                        <label class="layui-form-label">结束时间</label>
                        <div class="layui-input-inline" style="width:100px">
                                <input type="text" class="layui-input" id="endDt">
                        </div>
                        <%--<label class="layui-form-label">巡检类型</label>
                        <div class="layui-input-inline" style="width:120px">
                                <select id="sel_xjlx"></select>
                        </div>--%>

                         <div class="layui-input-inline" style="width:300px">
                                <input type="button" class="layui-btn" value="查询"  onclick="searchDB()" />
                                <input type="button" class="layui-btn layui-btn-normal" value="重置"  onclick="chongzhi()" />
                                <input type="button" class="layui-btn layui-btn-warm" value="导出"  onclick="export_excel()" />
                        </div>


                    </div>

                </div>
                 <div id="maingrid" style="margin:0; padding:0"></div>
                    

                 <div title="展示图片" class="showMsgBox" id="picBox">
                    <div class="layui-input-inline"  id="renwu1" style="cursor:pointer">
                        <img src="" class="imgStyle" />
                        <br/><span style="text-align: center;display:block;"></span>
                    </div>
                 </div>

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
                
            </div>
          
       </div>
    </form>

    <div id="div_export" style="display: none; text-align: left; line-height: 30px; padding-left: 50px;">
                 
                <div class="layui-form" action="">
                    <div class="layui-form-item" id="show">
                      
                      
                </div>
            </div>
    </div>

<%--    <a href="/user/test/xxxx.txt">点击下载</a>--%>

</body>
</html>
