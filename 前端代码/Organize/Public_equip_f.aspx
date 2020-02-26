<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Public_equip_f.aspx.cs" Inherits="Organize_Public_equip_f" %>


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

    <%--<script src="../js/jquery-1.8.3.min.js" type="text/javascript"></script>--%>
    <script src="../js/json2.js" type="text/javascript"></script>
    <script src="../js/jquery-1.9.0.min.js" type="text/javascript"></script>
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

        var enhanceForm; //定义一个公共变量
        var table; //如果有多个table 请定义多个公共变量
        var table_url = "";
        var tableRowsCount = 0; //得到表格条数
        var f_dy_id = 0;
        var p_level = 0;

        function fun_p_level() {
            var options = document.getElementById('P_level');
            p_level = options.value;
            if (!p_level) {
                alert("请先选择所属层级！")
            }
            else{
                opentab(p_level);
            }           
        }
        function opentab(p_level) { //打开一个层选择所属单元
            layer.open({
                type: 2 //此处以iframe举例
                , title: '请选择所属地址'
                , area: ['60%', '60%']
                , shade: 0
                , maxmin: true
                , content: "Select_dz.aspx?p_level=" + p_level
                , btn: ['确定', '关闭'] //只是为了演示
                , yes: function (index) {
                    var res = window["layui-layer-iframe" + index].callbackdata();
                    //打印返回的值，看是否有我们想返回的值。
                    //alert(res.username)
                    document.getElementById("Dy_id").value = res.f_name;
                    f_dy_id = res.f_id;
                    if (!f_dy_id) {
                        alert("请勾选所属地址")
                        return;
                    }

                    layer.close(layer.index);
                    //console.log(res);
                    //最后关闭弹出层
                    //layer.close(index);
                }
                , btn2: function () {
                    layer.close(layer.index);
                    //layer.closeAll();
                }

                , zIndex: layer.zIndex //重点1
                , success: function (layero) {
                    layer.setTop(layero); //重点2
                }
            });
        }        
        var Function_id = "<%=Function_id%>";
        $(function () {
            openPageLoadingDh();

            $.post(
                    "../handler/select.ashx"
                    , { view: "equip_f_type", idfield: "F_name", textfield: "F_name" }
                    , function (dataJson) {
                        if (dataJson) {
                            //alert(1);
                            $("#F_type_name").append("<option value=''>请选择类型</option>");
                            for (var i = 0; i < dataJson.length; i++) {
                                $("#F_type_name").append("<option value=" + dataJson[i].id + ">" + dataJson[i].text + "</option>");
                            }

                        }
                    }, "json");

            $.post(
                    "../handler/select.ashx"
                    , { view: "sys_f_shap", idfield: "name", textfield: "name" }
                    , function (dataJson) {
                        if (dataJson) {
                            //alert(1);
                            $("#F_Shap_name").append("<option value=''>请选择形状</option>");
                            for (var i = 0; i < dataJson.length; i++) {
                                $("#F_Shap_name").append("<option value=" + dataJson[i].id + ">" + dataJson[i].text + "</option>");
                            }

                        }
                    }, "json");
            $.post(
                    "../handler/select.ashx"
                    , { view: "sys_f_caizhi", idfield: "name", textfield: "name" }
                    , function (dataJson) {
                        if (dataJson) {
                            //alert(1);
                            $("#F_Caizhi_name").append("<option value=''>请选择材质</option>");
                            for (var i = 0; i < dataJson.length; i++) {
                                $("#F_Caizhi_name").append("<option value=" + dataJson[i].id + ">" + dataJson[i].text + "</option>");
                            }

                        }
                    }, "json");
            $.post(
                    "../handler/select.ashx"
                    , { view: "vw_equip_center_basic", idfield: "Center_name", textfield: "Center_name" }
                    , function (dataJson) {
                        if (dataJson) {
                            //alert(1);
                            $("#Center_name").append("<option value=''>请选择采集器</option>");
                            for (var i = 0; i < dataJson.length; i++) {
                                $("#Center_name").append("<option value=" + dataJson[i].id + ">" + dataJson[i].text + "</option>");
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



            //初始化 layui环境
            layui.use(['table', 'element', 'laydate'], function () {
                table = layui.table;
                var element = layui.element;
                var laydate = layui.laydate;

                //执行一个laydate实例 加载时间空间
                laydate.render({
                    elem: '#createDate_begin' //指定元素
                });
                laydate.render({
                    elem: '#createDate_end' //指定元素
                });
                laydate.render({
                    elem: '#CreateDate' //指定元素
                });
                laydate.render({
                    elem: '#Az_date' //指定元素
                });


                //加载表格
                table.render({
                    id: 'idTest'
                    , elem: '#idTest'
                    , height: 'full-140'
                    , url: '../handler/Grid.ashx?methodType=V&view=vw_equip_f_form&sortName=CreateDate' //数据接口
                    , cellMinWidth: 100
                    , cols: [[
                      { checkbox: true }
                      , { field: 'F_no', title: '阀号', sort: true, width: 150, align: 'center' }
                      , { field: 'Jz_name', title: '机组名称', sort: true, width: 150, align: 'center' }
                      , { field: 'p_level_name', title: '所属层级', sort: true, width: 150, align: 'center' }
                      , { field: 'Dy_name', title: '位置', sort: true, width: 150, align: 'center' }
                      , { field: 'F_type_name', title: '类型', sort: true, width: 120, align: 'center' }
                      , { field: 'F_shap_name', title: '形状', sort: true, width: 120, align: 'center' }
                      , { field: 'F_caizhi_name', title: '材质', sort: true, width: 120, align: 'center' }
                      , { field: 'F_az_postionNum', title: '安装位置', sort: true, width: 120, align: 'center' }
                      , { field: 'F_anzhuanghuanjing_name', title: '安装环境', sort: true, width: 120, align: 'center' }
                      , { field: 'F_haiba_id', title: '海拔', sort: true, width: 120, align: 'center' }
                      , { field: 'Center_name', title: '采集器名称', sort: true, width: 120, align: 'center' }
                      , { field: 'Mpid', title: '计量点', sort: true, width: 120, align: 'center' }
                      , { field: 'F_module_name', title: '模式', sort: true, width: 120, align: 'center' }
                      , { field: 'F_canshu', title: '参数', sort: true, width: 120, align: 'center' }
                      , { field: 'Az_date', title: '安装日期', sort: true, width: 200, align: 'center' }
                      , { field: 'Remarks', title: '备注', sort: true, width: 300, align: 'center' }
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
                //以上是 layui 初始化功能

                //以下是初始化 例如默认值 加载下来框等

                if (enhanceForm) {
                    var Json = { "zgs_name@like": "", "createDate@greaterorequal": "2017-1-1" };
                    var enhance2 = new enhanceForm({
                        elem: '#divCenterSearch' //表单选择器
                    });
                    //enhance2.filling(Json); //其中jsonData为表单数据的json对象
                }

                //装载下拉框
                $.post(
                    "../handler/select.ashx"
                    , { view: "vw_core_jz_basic", idfield: "jz_id", textfield: "jz_name" }
                    , function (dataJson) {
                        if (dataJson) {
                            $("#Jz_id").append("<option value=''>请选择所属机组</option>");
                            for (var i = 0; i < dataJson.length; i++) {
                                $("#Jz_id").append("<option value=" + dataJson[i].id + ">" + dataJson[i].text + "</option>");
                            }

                        }
                    }, "json");
                $.post(
                    "../handler/select.ashx"
                    , { view: "vw_p_level", idfield: "p_id", textfield: "p_name" }
                    , function (dataJson) {
                        if (dataJson) {
                            $("#P_level").append("<option value=''>请选择所属层级</option>");
                            for (var i = 0; i < dataJson.length; i++) {
                                $("#P_level").append("<option value=" + dataJson[i].id + ">" + dataJson[i].text + "</option>");
                            }

                        }
                    }, "json");

                $.post(
                    "../handler/select.ashx"
                    , { view: "equip_f_type", idfield: "F_type_id", textfield: "F_name" }
                    , function (dataJson) {
                        if (dataJson) {
                            $("#F_type_id").append("<option value=''>请选择类型</option>");
                            for (var i = 0; i < dataJson.length; i++) {
                                $("#F_type_id").append("<option value=" + dataJson[i].id + ">" + dataJson[i].text + "</option>");
                            }

                        }
                    }, "json");




                $.post(
                    "../handler/select.ashx"
                    , { view: "sys_f_shap", idfield: "id", textfield: "name" }
                    , function (dataJson) {
                        if (dataJson) {
                            $("#F_Shap_id").append("<option value=''>请选择形状</option>");
                            for (var i = 0; i < dataJson.length; i++) {
                                $("#F_Shap_id").append("<option value=" + dataJson[i].id + ">" + dataJson[i].text + "</option>");
                            }

                        }
                    }, "json");

                $.post(
                    "../handler/select.ashx"
                    , { view: "sys_f_caizhi", idfield: "id", textfield: "name" }
                    , function (dataJson) {
                        if (dataJson) {
                            $("#F_Caizhi_id").append("<option value=''>请选择材质</option>");
                            for (var i = 0; i < dataJson.length; i++) {
                                $("#F_Caizhi_id").append("<option value=" + dataJson[i].id + ">" + dataJson[i].text + "</option>");
                            }

                        }
                    }, "json");

                $.post(
                    "../handler/select.ashx"
                    , { view: "sys_f_anzhuanghuanjing", idfield: "id", textfield: "name" }
                    , function (dataJson) {
                        if (dataJson) {
                            $("#F_anzhuanghuanjing_id").append("<option value=''>请选择安装环境</option>");
                            for (var i = 0; i < dataJson.length; i++) {
                                $("#F_anzhuanghuanjing_id").append("<option value=" + dataJson[i].id + ">" + dataJson[i].text + "</option>");
                            }

                        }
                    }, "json");

                $.post(
                    "../handler/select.ashx"
                    , { view: "vw_equip_center_basic", idfield: "Center_id", textfield: "Center_name" }
                    , function (dataJson) {
                        if (dataJson) {
                            $("#Center_id").append("<option value=''>请选择采集器</option>");
                            for (var i = 0; i < dataJson.length; i++) {
                                $("#Center_id").append("<option value=" + dataJson[i].id + ">" + dataJson[i].text + "</option>");
                            }

                        }
                    }, "json");

                $.post(
                    "../handler/select.ashx"
                    , { view: "sys_f_module", idfield: "id", textfield: "name" }
                    , function (dataJson) {
                        if (dataJson) {
                            $("#F_module_id").append("<option value=''>请选择模式</option>");
                            for (var i = 0; i < dataJson.length; i++) {
                                $("#F_module_id").append("<option value=" + dataJson[i].id + ">" + dataJson[i].text + "</option>");
                            }

                        }
                    }, "json");

                //
                //以上是初始化 例如默认值 加载下来框等
            });


            var public_isAdd = true; //定义是否是添加，还是修改

            //这里是 jqure功能 注册控件方法
            $("#divAdd").on("click", function () {
                //请完成对应事件
                //alert(1);
                public_isAdd = true;
                LayerOpenDiv("信息添加");

                var Json = { "F_no": "", "Jz_id": "", "P_level": "", "Dy_id": "", "F_type_id": "", "F_Shap_id": "3", "F_Caizhi_id": "3",
                    "F_az_postionNum": "", "F_anzhuanghuanjing_id": "", "F_haiba_id": "", "Center_id@comparisonEqu": "",
                    "Mpid@comparisonEqu": "", "F_module_id": "1", "F_canshu": "80", "Az_date": "", "Remarks": ""
                };
                if (enhanceForm) {
                    var enhance = new enhanceForm({
                        elem: '#divFormOpen' //表单选择器
                    });
                    enhance.filling(Json); //其中jsonData为表单数据的json对象
                }

            });

            $("#divModify").on("click", function () {
                //请完成对应事件
                public_isAdd = false;
                var checkStatus = table.checkStatus('idTest')
                , data = checkStatus.data;
                //alert(JSON.stringify(data));

                if (data.length == 1) {
                    //这里对表单进行赋值
                    LayerOpenDiv("信息修改");
                    //这里进行赋值
                    if (enhanceForm) {
                        var enhance = new enhanceForm({
                            elem: '#divFormOpen' //表单选择器
                        });
                        enhance.filling(data[0]); //其中jsonData为表单数据的json对象
                    }

                }
                else {
                    layer.msg("请选择一行进行修改！", { icon: 2 });
                }
            });
            //这里是删除
            $("#divDel").on("click", function () {

                var checkStatus = table.checkStatus('idTest')
                , data = checkStatus.data;

                if (data.length > 0) {

                    var vMsg = "确定要删除[" + data.length + "]条数据吗？";
                    layer.confirm(vMsg, {
                        btn: ['确定', '取消'] //按钮
                    }, function () {
                        //这里进行删除操作
                        $.ajax({
                            type: "post",
                            url: "../handler/ajax.ashx",
                            data: {
                                typeName: "equip_f"
                                        , method: "public_del_f"
                                        , tableName: "Equip_f"
                                        , sqlJson: JSON.stringify(data)
                            },
                            dataType: "json",
                            success: function (dataJson) {
                                //alert(JSON.stringify(dataJson));
                                if (dataJson) {
                                    if (dataJson.code == "1") {
                                        layer.closeAll();
                                        grid_search("", "");
                                        layer.msg("操作成功！", { icon: 1 });
                                    }
                                    else {
                                        layer.msg(dataJson.msg, { icon: 2 });
                                    }
                                }
                                else {
                                    layer.msg("操作发生异常！", { icon: 2 });
                                }
                            }
                        });
                        layer.closeAll();
                    }

                    );
                }
                else {
                    layer.msg("请选择一个或多个进行修改！", { icon: 3 });
                }


            })

            $("#divExport").on("click", function () {

                if (tableRowsCount <= 0) {
                    //
                    layer.msg("没有数据可以导出哦！", { icon: 2 });
                }
                else {
                    var vMsg = "确定要导出[" + tableRowsCount + "]条数据吗？";
                    layer.confirm(vMsg, {
                        btn: ['确定', '取消'] //按钮
                    }, function () {
                        document.getElementById("1").src = "../handler/export_sql.ashx?gridname=&view=vw_equip_f_form&FunctionID=" + Function_id;
                        layer.closeAll();

                    }
                     );
                }
            })
            $("#divImport").on("click", function () {

                layer.msg("这里进行导入功能实现", { icon: 6 });
            })
            //以上是 jqure功能 注册控件方法


            layui.use('form', function () {
                var form = layui.form;
                //监听提交
                form.on('submit(formDemo)', function (data) {
                    //layer.msg(JSON.stringify(data.field));
                    //添加修改数据                                        
                    $.ajax({
                        type: "post",
                        url: "../handler/ajax.ashx",
                        data: {
                            typeName: "equip_f"
                            , method: public_isAdd ? "public_add_f" : "public_update_f"
                            , tableName: "Equip_f"
                            , sqlJson: JSON.stringify(data.field)
                            , dy_id: f_dy_id
                            , p_level: p_level
                        },
                        dataType: "json",
                        success: function (dataJson) {
                            //alert(JSON.stringify(dataJson));
                            if (dataJson) {
                                if (dataJson.code == "1") {
                                    layer.closeAll();
                                    grid_search("", "");
                                    f_dy_id = 0; //每次更新阀信息时 dy_id变为0  方法里判断如果是0  不更新dy_id  因为不更新单元  前台捕捉不到id
                                    p_level = 0;
                                    layer.msg("操作成功！", { icon: 1 });
                                }
                                else {
                                    layer.msg(dataJson.msg, { icon: 2 });
                                }
                            }
                            else {
                                layer.msg("操作发生异常！", { icon: 2 });
                            }
                        }
                    });

                    return false;
                });
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




        });

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

        function LayerOpenDiv(vTitle) {
            layui.use(['layer'], function () {
                var layer = layui.layer;
                layer.open({
                    title: vTitle,
                    type: 1,
                    anim: 1,
                    area: ['480px', '500px'],
                    skin: 'layui-layer-rim', //加上边框
                    content: $('#divFormOpen'),
                    btn: ["确定", "取消"],
                    yes: function (index, layero) {
                        $("#btnOk").click();
                        return false;
                    },
                    btn2: function (index, layero) {
                        layer.close(index);
                        return false;
                    }
                });
                renderForm();
            });
        }
        function renderForm() {
            layui.use('form', function () {
                var form = layui.form; //高版本建议把括号去掉，有的低版本，需要加()
                form.render();
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
			        <label class="layui-form-mid">阀号：</label>
			        <div class="layui-input-inline" style="width: 120px;">
				        <input type="text" id="F_no" name="F_no@like" autocomplete="off" class="layui-input"/>                   
			        </div>
		        </div>

               <div class="layui-inline">
			        <label class="layui-form-mid">类型：</label>
			        <div class="layui-input-inline" style="width: 120px;">
                        <select name="F_type_name" id="F_type_name" >                                                
                        </select>

			        </div>
		        </div>

               <div class="layui-inline">
			        <label class="layui-form-mid">形状：</label>
			        <div class="layui-input-inline" style="width: 120px;">
                        <select name="F_Shap_name" id="F_Shap_name" >                                                
                        </select>

			        </div>
		        </div>

                <div class="layui-inline">
			        <label class="layui-form-mid">材质：</label>
			        <div class="layui-input-inline" style="width: 120px;">
                        <select name="F_Caizhi_name" id="F_Caizhi_name" >                                                
                        </select>

			        </div>
		        </div>

               <div class="layui-inline">
			        <label class="layui-form-mid">采集器：</label>
			        <div class="layui-input-inline" style="width: 120px;">
                        <select name="Center_name" id="Center_name" >                                                
                        </select>

			        </div>
		        </div>

<%--
		        <div class="layui-inline">
			        <label class="layui-form-mid">开始时间：</label>
			        <div class="layui-input-inline"  style="width: 120px;">
				        <input type="text" id="createDate_begin" name="createDate@greaterorequal" autocomplete="off" class="layui-input" dateRange="1" placeholder=" 请选择时间 "/>
			        </div>
		        </div>
                <div class="layui-inline">
			        <label class="layui-form-mid">结束时间：</label>
			        <div class="layui-input-inline"  style="width: 120px;">
				        <input type="text" id="createDate_end" name="createDate@lessorequal" autocomplete="off" class="layui-input" dateRange="1" placeholder=" 请选择时间 "/>
			        </div>
		        </div>--%>


		        <div class="layui-inline">
			        <div class="layui-input-inline">
				        <button class="layui-btn" type="button" lay-submit lay-filter="centerSearch_form" ><i class="layui-icon">&#xe615;</i>查询</button>
			        </div>
		        </div>
	        </div>
        </div>

        <%--功能按钮--%>
        <div class="layui-btn-group">
          <div class="layui-btn layui-btn-sm" id="divAdd" > <i class="layui-icon">&#xe608;</i>添加</div> |
          <div class="layui-btn layui-btn-normal" id="divModify"> <i class="layui-icon">&#xe642;</i>修改</div>|
          <div class="layui-btn layui-btn-danger" id="divDel"> <i class="layui-icon">&#xe640;</i>删除</div> |
          <div class="layui-btn layui-btn-sm" id="divExport"> <i class="layui-icon">&#xe640;</i>导出</div> |
          <div class="layui-btn layui-btn-warm" id="divImport" style="display:none" > <i class="layui-icon">&#xe640;</i>数据导入</div>
        </div>

        <%--表格--%>
        <div>
            <table class="layui-table" id="idTest"  lay-data="{id: 'idTest'}" ></table>
        </div>
        

        <%--弹出页面--%>
        <div id="divFormOpen" style="display:none;padding-top:20px"  class="layui-form" >
        

            <div class="layui-form-item" style="display:none">
                <label class="layui-form-label">id</label>
                <div class="layui-input-block">
                  <input type="text" name="F_id@identity@comparisonNoEqu"   style="width: 200px;" placeholder="数据的id"  class="layui-input" >
                </div>
           </div>


            <div class="layui-form-item">
                <label class="layui-form-label">阀号</label>
                <div class="layui-input-block">
                  <input type="text" name="F_no" lay-verify="required" style="width: 300px;" placeholder="阀号" autocomplete="off" class="layui-input">
                </div>
            </div>

           <div class="layui-form-item">
                <label class="layui-form-label">所属机组</label>
                <div class="layui-input-inline" style="width: 300px;">
				    <select name="Jz_id" id="Jz_id" >
                    </select>
			    </div>
            </div>           
            
            <div class="layui-form-item">
                <label class="layui-form-label">所属层级</label>
                <div class="layui-input-inline" style="width: 300px;">
				    <select name="P_level" id="P_level" >
                    </select>
			    </div>
            </div>  

            <div class="layui-form-item">
                <label class="layui-form-label">所属地址</label>
                <div class="layui-input-inline" style="width: 300px;">				                        
                    <input type="text" id="Dy_id" name="Dy_name" style="width: 300px;" placeholder="点击选择（请先选择层级）" autocomplete="off" class="layui-input" onclick="fun_p_level()">
                    </select>
			    </div>
            </div>

            <div class="layui-form-item">
                <label class="layui-form-label">类型</label>
                <div class="layui-input-inline" style="width: 300px;">
				    <select name="F_type_id" id="F_type_id" >
                    </select>
			    </div>
            </div>           
                        
            <div class="layui-form-item">
                <label class="layui-form-label">形状</label>
                <div class="layui-input-inline" style="width: 300px;">
				    <select name="F_Shap_id" id="F_Shap_id" >
                    </select>
			    </div>
            </div>

            <div class="layui-form-item">
                <label class="layui-form-label">材质</label>
                <div class="layui-input-inline" style="width: 300px;">
				    <select name="F_Caizhi_id" id="F_Caizhi_id" >
                    </select>
			    </div>
            </div>           
            
            <div class="layui-form-item">
                <label class="layui-form-label">安装位置</label>
                <div class="layui-input-block">
                  <input type="text" name="F_az_postionNum"    style="width: 300px;" placeholder="安装位置" autocomplete="off" class="layui-input">
                </div>
            </div>

            <div class="layui-form-item">
                <label class="layui-form-label">安装环境 </label>
                <div class="layui-input-inline" style="width: 300px;">
				    <select name="F_anzhuanghuanjing_id" id="F_anzhuanghuanjing_id" >
                    </select>
			    </div>
            </div>

            <div class="layui-form-item">
                <label class="layui-form-label">海拔</label>
                <div class="layui-input-block">
                  <input type="text" name="F_haiba_id"  style="width: 300px;" placeholder="海拔" autocomplete="off" class="layui-input">
                </div>
            </div>

            <div class="layui-form-item">
                <label class="layui-form-label">采集器号</label>
                <div class="layui-input-inline" style="width: 300px;">
				    <select name="Center_id@comparisonEqu" id="Center_id" lay-verify="required">
                    </select>
			    </div>
            </div>         
              
            <div class="layui-form-item">
                <label class="layui-form-label">计量点</label>
                <div class="layui-input-block">
                  <input type="text" name="Mpid@comparisonEqu" id="Mpid" lay-verify="required" style="width: 300px;" placeholder="计量点" autocomplete="off" class="layui-input">
                </div>
            </div>

            <div class="layui-form-item">
                <label class="layui-form-label">模式</label>
                <div class="layui-input-inline" style="width: 300px;">
				    <select name="F_module_id" id="F_module_id">
                    </select>
			    </div>
            </div>
            
            <div class="layui-form-item">
                <label class="layui-form-label">参数</label>
                <div class="layui-input-block">
                  <input type="text" name="F_canshu"  style="width: 300px;" placeholder="参数" autocomplete="off" class="layui-input">
                </div>
            </div>

<%--            <div class="layui-form-item">
                <label class="layui-form-label">测试</label>
                <div class="layui-input-block">
                  <input type="text" id="ceshi" name="ceshi" lay-verify="required" style="width: 300px;" placeholder="点击选择" autocomplete="off" class="layui-input" onclick="opentab()">
                  
                </div>
            </div>--%>

            <div class="layui-form-item">
                <label class="layui-form-label">安装日期</label>
                <div class="layui-input-inline" style="width: 300px;">
				    <input type="text" name="Az_date" id="Az_date" autocomplete="off" class="layui-input" dateRange="1" placeholder=" 请选择日期 "/>
			    </div>
            </div>       
                      
            <div class="layui-form-item layui-form-text">
              <label class="layui-form-label">备注</label>
              <div class="layui-input-inline" style="width: 300px;">
                <textarea name="Remarks" placeholder="请输入内容" class="layui-textarea"></textarea>
              </div>
            </div>
                        

            <%--这里进行隐藏一些按键命令--%>
           <div class="layui-form-item">
                <div class="layui-input-block">                
                  <button class="layui-btn" lay-submit lay-filter="formDemo" style="display:none" id="btnOk" >立即提交</button>
                </div>
            </div>
        </div>
    
    </form>
    <iframe name="1" id="1" style="visibility: hidden; height: 0px;"></iframe>
</body>
</html>
