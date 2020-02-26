<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Public_fgs.aspx.cs" Inherits="Organize_Public_fgs" %>

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

        var enhanceForm; //定义一个公共变量
        var table; //如果有多个table 请定义多个公共变量
        var table_url = "";
        var tableRowsCount = 0; //得到表格条数
        var Function_id = "<%=Function_id%>";
        $(function () {


            openPageLoadingDh();

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
                //加载表格
                table.render({
                    id: 'idTest'
                    , elem: '#idTest'
                    , height: 'full-160'
                    , url: '../handler/Grid.ashx?methodType=V&view=vw_public_fgs_form&sortName=fgs_id&sortorder=desc' //数据接口
                    , cellMinWidth: 100
               
                    , cols: [[
                      { checkbox: true }
                      , { field: 'rowId', title: '序号', sort: true, width: 80, align: 'center' }
                      , { field: 'Fgs_name', title: '分公司名称', sort: true, width: 200, align: 'center' }
                      , { field: 'Zgs_name', title: '总公司名称', sort: true, width: 200, align: 'center' }
                      , { field: 'Order_no', title: '排序', sort: true, width: 80, align: 'center' }
                      , { field: 'CreateDate', title: '创建时间', sort: true, width: 200, align: 'center' }
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
                    var Json = { "Fgs_name@like": "测试", "createDate@greaterorequal": "2017-1-1" };
                    var enhance2 = new enhanceForm({
                        elem: '#divCenterSearch' //表单选择器
                    });
                    //enhance2.filling(Json); //其中jsonData为表单数据的json对象
                }
                //装载下拉框
                $.post(
                    "../handler/select.ashx"
                    , { view: "vw_public_zgs_basic", idfield: "zgs_id", textfield: "zgs_name" }
                    , function (dataJson) {
                        if (dataJson) {
                            $("#zgs_id").append("<option value=''>请选择</option>");
                            for (var i = 0; i < dataJson.length; i++) {

                                $("#zgs_id").append("<option value=" + dataJson[i].id + ">" + dataJson[i].text + "</option>");
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

                var Json = { "fgs_name@comparisonEqu": "", "zgs_id@comparisonEqu": "", "Order_no": "", "CreateDate": "", "Remarks": "" };
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
                                typeName: "public"
                                        , method: "public_del_db"
                                        , tableName: "public_fgs"
                                        , sqlJson: JSON.stringify(data)
                            },
                            dataType: "json",
                            success: function (dataJson) {
                                //alert(JSON.stringify(dataJson));
                                if (dataJson) {
                                    if (dataJson.code == "1") {
                                        layer.closeAll();

                                        layer.msg("操作成功！", { icon: 1, time: 700 }, function () {
                                            grid_search("", "");
                                        });
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
                        document.getElementById("1").src = "../handler/export_sql.ashx?gridname=&view=vw_public_fgs_form&FunctionID=" + Function_id;
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
//                var aa = $('#zgs_id').val();
//                //var aa = form.data;
//                alert(aa)
                //监听提交
                form.on('submit(formDemo)', function (data) {
                    //layer.msg(JSON.stringify(data.field));
                    //添加修改数据
                    $.ajax({
                        type: "post",
                        url: "../handler/ajax.ashx",
                        data: {
                            typeName: "public"
                            , method: public_isAdd ? "public_add_db" : "public_update_db"
                            , tableName: "public_fgs"
                            , sqlJson: JSON.stringify(data.field)
                            //, function_id: Function_id
                        },
                        dataType: "json",
                        success: function (dataJson) {
                            //alert(JSON.stringify(dataJson));
                            if (dataJson) {
                                if (dataJson.code == "1") {
                                    layer.closeAll();
                                    layer.msg("操作成功！", { icon: 1,time:1000 }, function () {
                                        grid_search("", "");
                                    });
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
			        <label class="layui-form-mid">分公司名称：</label>
			        <div class="layui-input-inline" style="width: 120px;">
				        <input type="text" id="fgs_name" name="fgs_name@like" autocomplete="off" class="layui-input"/>
			        </div>
		        </div>
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
		        </div>
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
                  <input type="text" name="fgs_id@identity@comparisonNoEqu"   style="width: 200px;" placeholder="数据的id"  class="layui-input" >
                </div>
           </div>

           <div class="layui-form-item">
                <label class="layui-form-label">分公司名称</label>
                <div class="layui-input-block">
                  <input type="text" name="fgs_name@comparisonEqu"   lay-verify="required" style="width: 200px;" placeholder="请输入分公司名称" autocomplete="off" class="layui-input">
                </div>
          </div>

           <div class="layui-form-item">
                <label class="layui-form-label">所属总公司</label>
                <div class="layui-input-inline" style="width: 200px;">
				    <select name="zgs_id@comparisonEqu" id="zgs_id" lay-verify="required">
                    </select>
			    </div>
            </div>
            
            <div class="layui-form-item">
                <label class="layui-form-label">排序</label>
                <div class="layui-input-block">
                  <input type="text" name="Order_no"    style="width: 200px;" placeholder="排序" autocomplete="off" class="layui-input">
                </div>
          </div>
<%--           <div class="layui-form-item">
                <label class="layui-form-label">创建时间</label>
                <div class="layui-input-inline" style="width: 200px;">
				    <input type="text" name="CreateDate" id="CreateDate" autocomplete="off" class="layui-input" dateRange="1" placeholder=" 请选择时间 "/>
			    </div>
            </div>--%>

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

