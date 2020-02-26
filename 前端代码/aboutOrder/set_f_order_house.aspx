<%@ Page Language="C#" AutoEventWireup="true" CodeFile="set_f_order_house.aspx.cs" Inherits="aboutOrder_set_f_order_house" %>



<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
  


    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1">
    <title>抄表系统登录</title>
    <link rel="stylesheet" href="../plugins/layui/css/layui.css" media="all">
    <link rel="stylesheet" type="text/css" href="http://www.jq22.com/jquery/font-awesome.4.6.0.css">
    
    <link rel="stylesheet" href="../build/css/app.css" media="all">

    <script src="../plugins/layui/layui.js" type="text/javascript"></script>
    <script src="../js/jquery-1.5.2.min.js" type="text/javascript"></script>
    <script src="../js/basicJs.js" type="text/javascript"></script>


    <style>
        body
        {
            margin:5px;
        }
        
        .treeDivText
        {
             margin:0px;
             width:50px;
            }
            
        .treeDivText p{ height:30px; line-height:30px; width:50px; overflow:hidden; text-align:center }
    </style>

    <script>

        var table, laydate;


        var vTongXun = false;
        var detailWin;
        var si;

        $(function () {

            //初始化 layui环境

            layui.use(['table', 'laydate'], function () {
                table = layui.table;
                laydate = layui.laydate;

                laydate.render({
                    elem: '#begin_cj_time' //指定元素
                });
                laydate.render({
                    elem: '#end_cj_time' //指定元素
                });

                //加载表格
                table.render({
                    id: 'idTest'
                    , elem: '#idTest'
                    , height: 'full-280'
                    , url: '../handler/Grid.ashx?methodType=V&view=vw_equip_f_house&sortName=cjq_time' //数据接口
                    , cellMinWidth: 100
                    , cols: [[
                      { checkbox: true }
                      , { field: 'All_name', title: '地址', sort: true, width: 300, align: 'left' }
                      , { field: 'f_type', title: '阀类型', sort: true, width: 120, align: 'center' }
                      , { field: 'F_no', title: '阀号', sort: true, width: 120, align: 'center' }
                      , { field: 'Mpid', title: '计量点', sort: true, width: 80, align: 'center' }
                      , { field: 'Cjq_time', title: '采集时间', sort: true, width: 180, align: 'center' }
                      , { field: 'Snwd', title: '室内温度', sort: true, width: 100, align: 'center' }
                      , { field: 'Jswd', title: '进水温度', sort: true, width: 100, align: 'center' }
                      , { field: 'Hswd', title: '回水温度', sort: true, width: 100, align: 'center' }
                      , { field: 'Jhswc', title: '温度差', sort: true, width: 100, align: 'center' }
                      , { field: 'F_kd', title: '阀开度', sort: true, width: 100, align: 'center' }
                      , { field: 'F_kb', title: '阀开比', sort: true, width: 100, align: 'center' }
                      , { field: 'Mbwd', title: '目标温度', sort: true, width: 100, align: 'center' }
                      , { field: 'Qdmx', title: '启动门限', sort: true, width: 100, align: 'center' }
                      , { field: 'Jczq', title: '检测周期', sort: true, width: 100, align: 'center' }
                      , { field: 'Ljkftime', title: '累计开阀时间', sort: true, width: 100, align: 'center' }
                     



                    ]]
                    , page: true //开启分页
                    , done: function (res, curr, count) {
                        console.log(res);
                        //得到当前页码
                        console.log(curr);
                        //得到数据总量
                        console.log(count);

                    }
                });
                //以上是 layui 初始化功能
                layui.config({
                    base: '../build/js/'
                }).use(['app'], function () {
                    var app = layui.app,
                       $ = layui.jquery;

                    //主入口
                    app.set({
                        type: 'iframe'
                    }).init();

                    $(".kit-side-fold").on("click", treeOpen);

                    //$("#btnSetOrder").on("click", setOrder); //设定命令

                });

            });
            resizeTreeHeight();
            window.onresize = function () {
                resizeTreeHeight();
            }
            //设置模式
            var vjsonDate2 = [{ "id": "1", "text": "点抄阀数据" }, { "id": "3008", "text": "设置阀通断" }, { "id": "3009", "text": "设置温度" }, { "id": "3010", "text": "设置温度上下限" }
            , { "id": "02", "text": "进回水温差模式" }, { "id": "03", "text": "进回水均温模式" }, { "id": "04", "text": "回水温度模式"}];

            $("#sel_set").empty();
            for (var i = 0; i < vjsonDate2.length; i++) {

                $("#sel_set").append("<option value='" + vjsonDate2[i].id + "'>" + vjsonDate2[i].text + "</option>");

            }


        });

        //新添加 设置175阀门模式
        //把小数点 39 转换成 00,39 
        //把小数 39.20转换成 20,39
        function NumberToFormart(num) {

            var vFix2 = Number(num).toFixed(2);

            var vArray = vFix2.split('.');
            return vArray[1] + "," + vArray[0];

        }


        var vShow = true;
        function treeOpen() {

            if (vShow) {
                document.getElementById("divContent").style.left = "50px";
                document.getElementById("divTreeTitle").style.display = "inline";
                vShow = false;
            }
            else {
                document.getElementById("divContent").style.left = "200px";
                document.getElementById("divTreeTitle").style.display = "none";
                vShow = true;
            }
        }

        function btnSearch() {

            //var vStr = f_getLevelNodes();
            //alert(vStr);

        }


        layui.use('form', function () {
            var form = layui.form;

            //监听提交
            form.on('submit(centerSearch_form)', function (data) {

                //layer.msg(JSON.stringify(data.field));
                //这里进行传值查询
                //consloe.
                var vTree = f_getLevelNodes();
                console.log(vTree);
                var vStr = JSON.stringify(data.field);
                console.log(vStr);
                grid_search(vTree, vStr);
                return false;
            });

            form.on('submit(centerSet_form)', function (data) {




                var checkStatus = table.checkStatus('idTest')
                , data1 = checkStatus.data;

                //alert(JSON.stringify(data1));
                if (data1.length > 0) {
                    layer.confirm("确定要进行命令下发吗？", function (index) {
                        //do something
                        layer.close(index);
                        var vF_idList = "";
                        for (var i = 0; i < data1.length; i++) {
                            if (vF_idList) {
                                vF_idList += "," + data1[i].F_id;
                            }
                            else {
                                vF_idList = data1[i].F_id;
                            }
                        }

                        if (vTongXun) {
                            layer.msg("正在通讯请稍等", { icon: 2 });
                            return;
                        }
                        var vSelected = $("#sel_set").val();
                        var vText1 = $("#txtSet1").val();
                        var vText2 = $("#txtSet2").val();

                        var vText3 = $("#txtSet3").val();
                        var vText4 = $("#txtSet4").val();



                        var vOrderType = vSelected; //命令号
                        var vOrderContent = ""; //命令内容

                        if (vSelected == "1") {
                            vOrderType = "1"; //是读取阀信息
                        }

                        if (vSelected == "01") {
                            vOrderContent = vSelected + "," + NumberToFormart(vText1);
                        }

                        if (vSelected == "02" || vSelected == "03" || vSelected == "04") {
                            
                            vOrderType = "3024";
                            vOrderContent = vSelected + "," + NumberToFormart(vText1) + "," + NumberToFormart(vText2)+"," + NumberToFormart(vText3);
                        }

                        else if (vSelected == "3008") {
                            vOrderContent = $("#sel_value").val();
                        }
                        else if (vSelected == "44") {
                            vOrderContent = vSelected + "," + NumberToFormart(vText1) + "," + NumberToFormart(vText2);
                        }
                        else if (vSelected == "100") {
                            vOrderContent = vText1 + "," + vText2 + "," + vText3 + "," + vText4;
                            vOrderType = "3023"; //是读取阀信息

                        }
                        else {

                            vOrderType = vSelected;
                            vOrderContent = vText1 + "," + vText2 + "," + vText3;
                        }


                        sendOrder(vF_idList, vOrderType, vOrderContent);


                    });
                }
                else {
                    layer.msg("请选择行！", { icon: 2 });
                }

                //setOrder();
            });
            //发送命令
            function sendOrder(vF_idList, vOrderType, vContent) {


                $.post('set_f_order.ashx?method=set_f_order&f_idList=' + vF_idList + '&orderType=' + vOrderType + '&orderContent=' + vContent, function (postResult) {
                    if (postResult) {
                        if (postResult != "") {
                            //这里给服务端发消息
                            showLoading();
                            var vCommandText = "Deer^Search^server_clientCommand^" + postResult;
                            $.post("sendCommand.ashx?type=sendCommandTextWithCommandNum&commandNum=" + postResult + "&commandText=" + vCommandText, function (result) {
                                closeLoading();
                                if (result == "1")//表示发送命令成功，服务端开始进行读取数据
                                {
                                    open_orderDetail(postResult, vOrderType);
                                }
                                else if (result == "-5") {
                                    alert("连接服务器超时");
                                }
                                else {
                                    alert(result);
                                }
                            });
                        }
                        else {
                            alert('发生异常！')

                        }
                    }
                });
            }

            function open_orderDetail(vCommandNum, orderClass) {

                layer.open({
                    type: 2,
                    area: ['900px', '600px'],
                    content: "orderDetail_house.aspx?commandNum=" + vCommandNum + "&orderClass=" + orderClass,
                    cancel: function (index, layero) {

                    }
                });
            }

            function clearTextValue() {
                $("#txtSet1").val("");
                $("#txtSet2").val("");
                $("#txtSet3").val("");
                $("#txtSet4").val("");
            }


            //设置模式
            form.on('select(sel_setModuel)', function (data) {
                console.log(data.elem); //得到select原始DOM对象
                console.log(data.value); //得到被选中的值
                console.log(data.othis); //得到美化后的DOM对象

                //alert(data.value);
                if (data) {

                    var vSelectValue = data.value;
                    //alert(vSelectValue);
                    if (vSelectValue == "1") {

                        $("#divSet0").css("display", "none");
                        $("#divSet1").css("display", "none");
                        $("#divSet2").css("display", "none");
                        $("#divSet3").css("display", "none");
                        $("#divSet4").css("display", "none");


                        $("#txtSet1").removeAttr("lay-verify");
                        $("#txtSet2").removeAttr("lay-verify")
                        $("#txtSet3").removeAttr("lay-verify")
                        $("#txtSet4").removeAttr("lay-verify")

                        clearTextValue();
                    }
                    else if (vSelectValue == "3008") {

                        $("#divSet0").css("display", "inline-block");
                        $("#divSet1").css("display", "none");
                        $("#divSet2").css("display", "none");
                        $("#divSet3").css("display", "none");
                        $("#divSet4").css("display", "none");

                        $("#txtSet1").removeAttr("lay-verify");
                        $("#txtSet2").removeAttr("lay-verify");
                        $("#txtSet3").removeAttr("lay-verify");
                        $("#txtSet4").removeAttr("lay-verify");

                        clearTextValue();
                    }
                    else if (vSelectValue == "3009") {

                        $("#divSet0").css("display", "none");
                        $("#divSet1").css("display", "inline-block");
                        $("#divSet2").css("display", "inline-block");
                        $("#divSet3").css("display", "inline-block");
                        $("#divSet4").css("display", "none");

                        $("#txtSet1").attr("lay-verify", "required");
                        $("#txtSet2").attr("lay-verify", "required");
                        $("#txtSet3").attr("lay-verify", "required");
                        $("#txtSet4").removeAttr("lay-verify");

                        clearTextValue();

                        $("#txtSet1").attr("placeholder", "正常温度");
                        $("#txtSet2").attr("placeholder", "节能温度");
                        $("#txtSet3").attr("placeholder", "远程温度");


                    }
                    else if (vSelectValue == "3010") {

                        $("#divSet0").css("display", "none");
                        $("#divSet1").css("display", "inline-block");
                        $("#divSet2").css("display", "inline-block");
                        $("#divSet3").css("display", "inline-block");
                        $("#divSet4").css("display", "none");

                        $("#txtSet1").attr("lay-verify", "required");
                        $("#txtSet2").attr("lay-verify", "required");
                        $("#txtSet3").attr("lay-verify", "required");
                        $("#txtSet4").removeAttr("lay-verify");

                        clearTextValue();

                        $("#txtSet1").attr("placeholder", "上限温度");
                        $("#txtSet2").attr("placeholder", "下限温度");
                        $("#txtSet3").attr("placeholder", "低温保护");


                    }
                    else if (vSelectValue == "3024") {

                        $("#divSet0").css("display", "none");
                        $("#divSet1").css("display", "inline-block");
                        $("#divSet2").css("display", "inline-block");
                        $("#divSet3").css("display", "inline-block");
                        $("#divSet4").css("display", "none");

                        $("#txtSet1").attr("lay-verify", "required");
                        $("#txtSet2").attr("lay-verify", "required");
                        $("#txtSet3").attr("lay-verify", "required");
                        $("#txtSet4").removeAttr("lay-verify");

                        clearTextValue();

                        $("#txtSet1").attr("placeholder", "上限温度");
                        $("#txtSet2").attr("placeholder", "下限温度");
                        $("#txtSet3").attr("placeholder", "低温保护");
                    }
                    else if (vSelectValue == "02" || vSelectValue == "03" || vSelectValue == "04") {

                        $("#divSet0").css("display", "none");
                        $("#divSet1").css("display", "inline-block");
                        $("#divSet2").css("display", "inline-block");
                        $("#divSet3").css("display", "inline-block");
                        $("#divSet4").css("display", "none");

                        $("#txtSet1").attr("lay-verify", "required");
                        $("#txtSet2").attr("lay-verify", "required");
                        $("#txtSet3").attr("lay-verify", "required");
                        $("#txtSet4").removeAttr("lay-verify");

                        clearTextValue();

                        $("#txtSet1").attr("placeholder", "温度");
                        $("#txtSet2").attr("placeholder", "启动门限");
                        $("#txtSet3").attr("placeholder", "检测周期");


                    }

                    else {

                        $("#divSet0").css("display", "none");
                        $("#divSet1").css("display", "inline-block");
                        $("#divSet2").css("display", "inline-block");
                        $("#divSet3").css("display", "inline-block");
                        $("#divSet4").css("display", "none");

                        $("#txtSet1").attr("lay-verify", "required");
                        $("#txtSet2").attr("lay-verify", "required");
                        $("#txtSet3").attr("lay-verify", "required");
                        $("#txtSet4").removeAttr("lay-verify");

                        clearTextValue();

                    }
                }
            });



        });

        function search_Meter_Info(vCommandNum) {
            table.reload('idTest', {
                where: {
                    commandNum: vCommandNum
                }
                , page: {
                    curr: 1 //重新从第 1 页开始
                }
            });

        }

        function grid_search(where_leftStr, where_centerStr) {

            table.reload('idTest', {
                where: {
                    where_left: where_leftStr,
                    where_center: where_centerStr
                }
                , page: {
                    curr: 1 //重新从第 1 页开始
                }

            });
        }


        function f_getCheckedNodes(level) {

            var nodes = window.frames["frtree"].getTreeObj().getCheckedNodes(); ;
            var names = "";
            var count = 0;
            for (var i = 0; i < nodes.length; i++) { node = nodes[i]; if (node.no.substring(0, 1) == level && !node.getCheckStatus().half) { names += node.no + ","; count += 1; } }
            if (count > 0) { names = names.substr(0, names.length - 1); }
            return names;
        }
        function f_getLevelNodes() {
            //var names = "||||" + f_getCheckedNodes("E") + "|" + f_getCheckedNodes("F") + "|" + f_getCheckedNodes("G") + "|" + f_getCheckedNodes("H") + "|" + f_getCheckedNodes("I");
            var names = "||||" + f_getCheckedNodes("E") + "|" + f_getCheckedNodes("F") + "|" + f_getCheckedNodes("G") + "|" + f_getCheckedNodes("H") + "|" + f_getCheckedNodes("I");
            return names;
        }

        //重新制定树的高度
        function resizeTreeHeight() {
            var bodyHeight = document.documentElement.clientHeight;
            document.getElementById("frtree").style.height = (bodyHeight - 60) + "px";
        }
    </script>

</head>
<body>
    <form id="form1" runat="server">

     <div class="layui-layout  kit-layout-content">
       

       <div class="layui-side layui-bg-white_border kit-side " >
            <div class="layui-side-scroll ">
                <div class="kit-side-fold" style="background-color:#E6EAEC;color:#282B33" ><i class="fa fa-tree" aria-hidden="true" ></i></div>
                <!-- 左侧导航区域（可配合layui已有的垂直导航） -->
                <div id="divTreeTitle" class="treeDivText" style="display:none;"><br><br><p>组</p><p>织</p><p>树</p><p>结</p><p>构</p></div>
                <ul  lay-filter="kit-one-level" kit-navbar class="ztree form-left-tree">
                    <iframe name="frtree" id="frtree" src="../tree/maintree.aspx"  width="98%" height="440px" frameborder="0"></iframe>
                </ul>
                
            </div>
        </div>


        
        <div class="layui-body" style="padding:15px;" id="divContent" >
            
            <div id="divCenterSearch" class="layui-form" >
            <div class="layui-form-item">
                
                <div class="layui-collapse">
                  <div class="layui-colla-item">
                    <h2 class="layui-colla-title">查询条件</h2>
                    <div class="layui-colla-content layui-show">
                    
                        
                       
                      


		                <div class="layui-inline">
			                <label class="layui-form-mid" style="width:80px;text-align:right">回水温度>=</label>
			                <div class="layui-input-inline"  style="width: 80px;">
				                 <input type="text" id="Text1" name="hswd@greaterorequal" autocomplete="off" class="layui-input" placeholder="回水温度"/>
			                </div>
		                </div>

                         <div class="layui-inline">
			                <label class="layui-form-mid" style="width:80px;text-align:right">回水温度<=</label>
			                <div class="layui-input-inline"  style="width: 80px;">
				                 <input type="text" id="Text3" name="hswd@lessorequal" autocomplete="off" class="layui-input" placeholder="回水温度"/>
			                </div>
		                </div>

                         <div class="layui-inline">
			                <div class="layui-input-inline">
				                <button class="layui-btn " type="button" lay-submit lay-filter="centerSearch_form" ><i class="layui-icon">&#xe615;</i>查询</button>
			                </div>
		                </div>

                        
                    </div>
                  </div>
                </div>
		        


		       
	        </div>
        </div>

            <fieldset class="layui-elem-field">
              <legend>设置模式</legend>
              <div class="layui-field-box">
            

                <div id="div1" class="layui-form" >
                    <div class="layui-form-item">

                      

                        <div class="layui-inline">
			                <label class="layui-form-label">设置模式</label>
                            <div class="layui-input-inline" style="width: 200px;">
				                <select  id="sel_set" lay-filter="sel_setModuel"  lay-verify="required">
                                <option value="1">读取阀数据</option>
                                <option value="3008">设置阀通断</option>
                                <option value="3009">进回水平均温度设置</option>
                                <option value="3010">回水温度设置</option>
                                <option value="3024">设置阀门模式</option>
                                <option value="02">进回水温差模式</option>
                                <option value="03">进回水均温模式</option>
                                <option value="04">回水温度模式</option>

                                </select>
			                </div>
		                </div>

                        <div class="layui-inline" id="divSet0" style="display:none">
                            <div class="layui-input-inline" style="width: 200px;">
				                <select id="sel_value" >
                                <option value="55">强制开阀</option>
                                <option value="99">强制关阀</option>
                                <option value="FF">自由控制</option>
                                <option value="66">单次开阀</option>
                                <option value="77">单次关阀</option>
                                </select>
			                </div>
		                </div>


                        <div class="layui-inline" id="divSet1" style="display:none">
			                <div class="layui-input-inline" style="width: 80px;" >
				                <input type="text" id="txtSet1"  autocomplete="off"  class="layui-input" placeholder="设定值"/>
			                </div>
		                </div>
                        
                        <div class="layui-inline" id="divSet2" style="display:none">
			                 <div class="layui-input-inline" style="width: 80px;" >
				                <input type="text" id="txtSet2"  autocomplete="off"  class="layui-input" placeholder="设定值"/>
			                </div>

		                </div>

                         <div class="layui-inline" id="divSet3" style="display:none">
			                <div class="layui-input-inline" style="width: 80px;" >
				                <input type="text" id="txtSet3"  autocomplete="off"  class="layui-input" placeholder="设定值"/>
			                </div>
		                </div>

                         <div class="layui-inline" id="divSet4" style="display:none">
			                <div class="layui-input-inline" style="width: 80px;" >
				                <input type="text" id="txtSet4"  autocomplete="off"  class="layui-input" placeholder="设定值"/>
			                </div>
		                </div>



                        <div class="layui-inline">
			                <div class="layui-input-inline">
				                <button class="layui-btn  layui-btn-danger" type="button" lay-submit  lay-filter="centerSet_form" ><i class="layui-icon">&#xe620;</i>下发设定</button>
			                </div>
		                </div>

	            </div>
                </div>
              </div>
            </fieldset>


            <div>
                <table class="layui-table" id="idTest"  lay-data="{id: 'idTest'}" ></table>
            </div>
            
        </div>


       
    </div>

   
        
    </form>

    

</body>
</html>

    