<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Select_dz.aspx.cs" Inherits="Organize_Select_dz" %>

<!DOCTYPE html>

<html>
<head id="Head1" runat="server">
    <meta charset="utf-8">
    <title>layui</title>
    <meta name="renderer" content="webkit">
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1">
    <link rel="stylesheet" href="../plugins/layui/css/layui.css"  media="all">
     
    <script src="../plugins/layui/layui.js" type="text/javascript"></script>
    <script src="../js/jquery-1.8.3.min.js" type="text/javascript"></script>
    <script src="../js/json2.js" type="text/javascript"></script>

    <script src="../js/basicJs.js" type="text/javascript"></script>

    <style>
    
        body
        {
            margin:10px;
            }

        .contrlWidth
        {
            width:260px;
            
            
            }
    </style>
   
    <script language="javascript">
        var f_id;
        var f_name;
        var callbackdata = function () {
            var data = {
                f_id: f_id,
                f_name: f_name
            };
            return data;
        }

        var enhanceForm; //定义一个公共变量
        var table; //如果有多个table 请定义多个公共变量
        var table_url = "";
        var tableRowsCount = 0; //得到表格条数

        var Function_id = "<%=Function_id%>";
        $(function () {


            openPageLoadingDh();

            $.post(
                    "../handler/select.ashx"
                    , { view: "vw_public_hrz", idfield: "Hrz_name", textfield: "Hrz_name" }
                    , function (dataJson) {
                        if (dataJson) {
                            //alert(1);
                            $("#Hrz_name_select").append("<option value=''>请选择换热站</option>");
                            for (var i = 0; i < dataJson.length; i++) {
                                $("#Hrz_name_select").append("<option value=" + dataJson[i].id + ">" + dataJson[i].text + "</option>");
                            }

                        }
                    }, "json");

            $.post(
                    "../handler/select.ashx"
                    , { view: "vw_public_xq", idfield: "Xq_name", textfield: "Xq_name" }
                    , function (dataJson) {
                        if (dataJson) {
                            //alert(1);
                            $("#Xq_name_select").append("<option value=''>请选择小区</option>");
                            for (var i = 0; i < dataJson.length; i++) {
                                $("#Xq_name_select").append("<option value=" + dataJson[i].id + ">" + dataJson[i].text + "</option>");
                            }

                        }
                    }, "json");
            $.post(
                    "../handler/select.ashx"
                    , { view: "vw_public_lh", idfield: "Lh_name", textfield: "Lh_name" }
                    , function (dataJson) {
                        if (dataJson) {
                            //alert(1);
                            $("#Lh_name_select").append("<option value=''>请选择楼号</option>");
                            for (var i = 0; i < dataJson.length; i++) {
                                $("#Lh_name_select").append("<option value=" + dataJson[i].id + ">" + dataJson[i].text + "</option>");
                            }

                        }
                    }, "json");

            layui.config({
                base: '../plugins/layui/layui-expand/'
            }).extend({
                enhanceform: 'enhanceform'
            });
            layui.use(['enhanceform'], function () {
                enhanceForm = layui.enhanceform;
            });

            layui.use('form', function () {
                var form = layui.form;
                //监听提交
                form.on('submit(centerSearch_form)', function (data) {

                    //layer.msg(JSON.stringify(data.field));
                    //这里进行传值查询
                    //consloe.
                    var vStr = JSON.stringify(data.field);
                    console.log(vStr);
                    grid_search("", vStr);
                    return false;
                });
            });
            //初始化 layui环境
            layui.use(['table', 'element', 'laydate'], function () {
                table = layui.table;
                public_add()                
            });
        });
        function public_add() {
            var p_level = "<%=p_level%>";
            if (p_level == 8) {
                public_lh();
            }
            else if (p_level == 9) {
                public_dy();
            }
            else if (p_level == 10) {
                public_house();
            }
            else
            { alert("系统错误，请联系管理人员！")}
        }
        function public_lh() {
            //加载表格
            table.render({
                id: 'idTest'
                    , elem: '#idTest'
                    , height: 'full-60'
                    , url: '../handler/Grid.ashx?methodType=V&view=vw_Public_lh&sortName=Lh_id&sortorder=desc' //数据接口
                    , cellMinWidth: 100

                    , cols: [[
                      { checkbox: true }
                      , { field: 'rowId', title: '序号', sort: true, width: 50, align: 'center' }
                      , { field: 'Fgs_name', title: '分公司', sort: true, width: 150, align: 'center' }
                      , { field: 'K_name', title: '管理站', sort: true, width: 150, align: 'center' }
                    , { field: 'Hrz_name', title: '换热站', sort: true, width: 150, align: 'center' }
                    , { field: 'Xq_name', title: '小区', sort: true, width: 150, align: 'center' }
                    , { field: 'Lh_name', title: '楼号', sort: true, width: 150, align: 'center' }                    
                    ]]
                    , page: true //开启分页
                    , done: function (res, curr, count) {
                        console.log(res);
                        //得到当前页码
                        console.log(curr);
                        //得到数据总量
                        console.log(count);
                        tableRowsCount = count;
                        closePageLoadingDh(); //初始化完成，关闭这个页面的动画层
                    }
            });

            table.on('checkbox(test)', function (obj) {
                var checkStatus = table.checkStatus('idTest')
                var data = checkStatus.data;
                if (data.length == 1) {
                    f_id = data[0].Lh_id;
                    f_name = data[0].Lh_name;
                }
                else {
                    alert("请选择一行!")
                }
            });

        } function public_dy() {
            //加载表格
            table.render({
                id: 'idTest'
                    , elem: '#idTest'
                    , height: 'full-60'
                    , url: '../handler/Grid.ashx?methodType=V&view=vw_public_dy&sortName=Dy_id&sortorder=desc' //数据接口
                    , cellMinWidth: 100

                    , cols: [[
                      { checkbox: true }
                      , { field: 'rowId', title: '序号', sort: true, width: 50, align: 'center' }
                      , { field: 'Fgs_name', title: '分公司', sort: true, width: 150, align: 'center' }
                      , { field: 'K_name', title: '管理站', sort: true, width: 150, align: 'center' }
                    , { field: 'Hrz_name', title: '换热站', sort: true, width: 150, align: 'center' }
                    , { field: 'Xq_name', title: '小区', sort: true, width: 150, align: 'center' }
                    , { field: 'Lh_name', title: '楼号', sort: true, width: 150, align: 'center' }
                    , { field: 'Dy_name', title: '单元', sort: true, width: 120, align: 'center' }
                    ]]
                    , page: true //开启分页
                    , done: function (res, curr, count) {
                        console.log(res);
                        //得到当前页码
                        console.log(curr);
                        //得到数据总量
                        console.log(count);
                        tableRowsCount = count;
                        closePageLoadingDh(); //初始化完成，关闭这个页面的动画层
                    }
            });

            table.on('checkbox(test)', function (obj) {
                var checkStatus = table.checkStatus('idTest')
                var data = checkStatus.data;
                if (data.length == 1) {
                    f_id = data[0].Dy_id;
                    f_name = data[0].Dy_name;
                }
                else {
                    alert("请选择一行!")
                }
            });

        } function public_house() {
            //加载表格
            table.render({
                id: 'idTest'
                    , elem: '#idTest'
                    , height: 'full-60'
                    , url: '../handler/Grid.ashx?methodType=V&view=vw_public_house_form&sortName=House_id&sortorder=desc' //数据接口
                    , cellMinWidth: 100

                    , cols: [[
                      { checkbox: true }
                      , { field: 'rowId', title: '序号', sort: true, width: 50, align: 'center' }
                      , { field: 'Fgs_name', title: '分公司', sort: true, width: 150, align: 'center' }
                      , { field: 'K_name', title: '管理站', sort: true, width: 150, align: 'center' }
                    , { field: 'Hrz_name', title: '换热站', sort: true, width: 150, align: 'center' }
                    , { field: 'Xq_name', title: '小区', sort: true, width: 150, align: 'center' }
                    , { field: 'Lh_name', title: '楼号', sort: true, width: 150, align: 'center' }
                    , { field: 'Dy_name', title: '单元', sort: true, width: 120, align: 'center' }
                    , { field: 'House_name', title: '住户名', sort: true, width: 120, align: 'center' }
                //, { field: 'Dy_id', title: '单元id', sort: true, width: 120, align: 'hidden' }
                    ]]
                    , page: true //开启分页
                    , done: function (res, curr, count) {
                        console.log(res);
                        //得到当前页码
                        console.log(curr);
                        //得到数据总量
                        console.log(count);
                        tableRowsCount = count;
                        closePageLoadingDh(); //初始化完成，关闭这个页面的动画层
                    }
            });

            table.on('checkbox(test)', function (obj) {
                var checkStatus = table.checkStatus('idTest')
                var data = checkStatus.data;
                if (data.length == 1) {
                    f_id = data[0].House_id;
                    f_name = data[0].House_name;
                }
                else {
                    alert("请选择一行!")
                }
            });

        }

        function grid_search(where_leftStr, where_centerStr) {        
            showLoading();
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
        

    </script>

</head> 
<body>
    <form id="form1" runat="server">

        <%--查询条件--%>
        <div id="divCenterSearch" class="layui-form" >
            <div class="layui-form-item">

                           <div class="layui-inline">
			        <label class="layui-form-mid">换热站：</label>
			        <div class="layui-input-inline" style="width: 120px;">
                        <select name="Hrz_name" id="Hrz_name_select" >                                                
                        </select>

			        </div>
		        </div>

                <div class="layui-inline">
			        <label class="layui-form-mid">小区：</label>
			        <div class="layui-input-inline" style="width: 120px;">
                        <select name="Xq_name" id="Xq_name_select" >                                                
                        </select>

			        </div>
		        </div>

               <div class="layui-inline">
			        <label class="layui-form-mid">楼号：</label>
			        <div class="layui-input-inline" style="width: 120px;">
                        <select name="Lh_name" id="Lh_name_select" >                                                
                        </select>

			        </div>
		        </div>

		        <div class="layui-inline">
			        <div class="layui-input-inline">
				        <button class="layui-btn" type="button" lay-submit lay-filter="centerSearch_form" ><i class="layui-icon">&#xe615;</i>查询</button>
			        </div>
		        </div>
	        </div>
        </div>



        <%--表格--%>
        <div>
            <table class="layui-table" id="idTest"  lay-data="{id: 'idTest'}" lay-filter="test" ></table>
        </div>

        
    
    </form>
    <iframe name="1" id="1" style="visibility: hidden; height: 0px;"></iframe>
</body>
</html>


