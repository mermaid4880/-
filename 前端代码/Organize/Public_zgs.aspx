<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Public_zgs.aspx.cs" Inherits="Organize_Public_zgs" %>

<!DOCTYPE html>

<html>
<head runat="server">
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
            background-color:#FEFEFE;
            }

        .contrlWidth
        {
            width:260px;
            
            
            }
    </style>
   
    <script language="javascript">

        var enhanceForm; //定义一个公共变量
        var table;//如果有多个table 请定义多个公共变量
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

            //初始化下拉框
            $.post("../handler/select.ashx"
                    , { view: "vw_Public_jt_basic", idfield: "jt_id", textfield: "jt_name" }
                    , function (dataJson) {
                        if (dataJson) {
                            $("#Jt_id").append("<option value=''>请选择</option>");
                            $("#jt_id_search").append("<option value=''>请选择</option>");
                            for (var i = 0; i < dataJson.length; i++) {
                                $("#Jt_id").append("<option value=" + dataJson[i].id + ">" + dataJson[i].text + "</option>");
                                $("#jt_id_search").append("<option value=" + dataJson[i].id + ">" + dataJson[i].text + "</option>");

                            }

                           

                        }
                    }, "json");

            //初始化 layui环境
            layui.use(['table', 'element', 'laydate'], function () {
                table = layui.table;
                var element = layui.element;
                var laydate = layui.laydate;

                //执行一个laydate实例 加载时间空间
                laydate.render({
                    elem: '#createDate_begin_search' //指定元素
                });
                laydate.render({
                    elem: '#createDate_end_search' //指定元素
                });

                //加载表格
                table.render({
                    id: 'idTest'
                    , elem: '#idTest'
                    , height: 'full-140'
                    , url: '../handler/Grid.ashx?methodType=V&view=vw_Public_zgs_form&sortName=Zgs_id&sortorder=desc' //数据接口
                    , cellMinWidth: 100

                    , cols: [[
                      { checkbox: true }
                     , { field: 'rowId', title: '序号', sort: true, width: 80, align: 'center' }
                      , { field: 'Zgs_name', title: '总公司名称', sort: true, width: 200, align: 'center' }
                      , { field: 'Jt_name', title: '集团名称', sort: true, width: 200, align: 'center' }
                      , { field: 'Order_no', title: '排序', sort: true, width: 80, align: 'center' }
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

                //装载下拉框

                //以下是查询条件进行初始化 例如默认值 加载下来框等
                if (enhanceForm) {
                    var Json = { "Zgs_name_search": "ss", "jt_id_search": "4", "createDate_begin_search": "2017-1-1", "createDate_end_search": "2017-1-2" };
                    var enhance2 = new enhanceForm({
                        elem: '#divCenterSearch' //表单选择器
                    });
                    enhance2.filling_fromId(Json); //其中jsonData为表单数据的json对象
                }

                //
                //以上是初始化 例如默认值 加载下来框等
            });


            var public_isAdd = true; //定义是否是添加，还是修改

            //这里是 jqure功能 注册控件方法
            $("#divAdd").on("click", function () {
                //请完成对应事件
                //alert(1);
                public_isAdd = true;
                LayerOpenDiv("信息添加", true);
                var Json = {};
                if (enhanceForm) {
                    var enhance = new enhanceForm({
                        elem: '#divFormOpen' //表单选择器
                    });
                    //enhance.filling(Json); //其中jsonData为表单数据的json对象
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
                    LayerOpenDiv("信息修改", false);
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


                    var sqlKey = "zgs_id";
                    var sqlValue = "0";
                    for (var i = 0; i < data.length; i++) {
                        sqlValue += data[i].Zgs_id;
                    }

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
                                        , tableName: "public_zgs"
                                        , sqlKey: sqlKey
                                        , sqlValue: sqlValue
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
                        document.getElementById("1").src = "../handler/export_sql.ashx?gridname=&view=vw_Public_zgs_form&FunctionID=" + Function_id;
                        layer.closeAll();
                    }
                     );
                }
            })
            $("#divImport").on("click", function () {

                layer.msg("这里进行导入功能实现", { icon: 6 });
            })
            //以上是 jqure功能 注册控件方法


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

        function LayerOpenDiv(vTitle,vAdd) {
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
                        sumitSave(vAdd);
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

        function searchDb() {

            var vJsonArray = getJsonListSearch($("#divCenterSearch"))
            console.log(JSON2.stringify(vJsonArray));
            grid_search("", JSON2.stringify(vJsonArray));
            return false;
        }

        function sumitSave(public_isAdd) {

            var vJsonArray = getJsonListOpenDiv($("#divFormOpen"))
            console.log(JSON2.stringify(vJsonArray));
            //grid_search("", JSON2.stringify(vJsonArray));
            $.ajax({
                type: "post",
                url: "../handler/ajax.ashx",
                data: {
                    typeName: "public"
                    , method: public_isAdd ? "public_add_db" : "public_update_db"
                    , tableName: "public_zgs"
                    , sqlJson: JSON2.stringify(vJsonArray)
                },
                dataType: "json",
                success: function (dataJson) {
                    if (dataJson) {
                        if (dataJson.code == "1") {
                            layer.closeAll();
                            layer.msg("操作成功！", { icon: 1, time: 500 }, function () {
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
        }

    </script>

</head> 
<body>
    <form id="form1" runat="server">

        <%--查询条件--%>
        <div id="divCenterSearch" class="layui-form" >
            <div class="layui-form-item">

		        <div class="layui-inline">
			        <label class="layui-form-mid">总公司名称：</label>
			        <div class="layui-input-inline" style="width: 120px;">
				        <input type="text" id="Zgs_name_search"  name="Zgs_name"  op="like"  autocomplete="off" class="layui-input"/>
			        </div>
		        </div>

                 <div class="layui-inline">
			        <label class="layui-form-mid">所属集团：</label>
			        <div class="layui-input-inline" style="width: 120px;">
				          <select name="jt_id" id="jt_id_search" op="equal"  lay-verify="required"> </select>
			        </div>
		        </div>


                 <div class="layui-inline">
			        <label class="layui-form-mid">时间开始：</label>
			        <div class="layui-input-inline" style="width: 120px;">
				        <input type="text" id="createDate_begin_search"  name="createDate"  op="greaterorequal"  autocomplete="off" class="layui-input"/>
			        </div>
		        </div>

                <div class="layui-inline">
			        <label class="layui-form-mid">时间结束：</label>
			        <div class="layui-input-inline" style="width: 120px;">
				        <input type="text" id="createDate_end_search"  name="createDate"  op="lessorequal"  autocomplete="off" class="layui-input"/>
			        </div>
		        </div>

		       
		        <div class="layui-inline">
			        <div class="layui-input-inline">
				        <button class="layui-btn" type="button" onclick="searchDb()" ><i class="layui-icon">&#xe615;</i>查询</button>
			        </div>
		        </div>
	        </div>
        </div>

        <%--功能按钮--%>
        <div class="layui-btn-group">
          <div class="layui-btn layui-btn-sm" id="divAdd" > <i class="layui-icon">&#xe608;</i>添加</div> |
          <div class="layui-btn layui-btn-normal" id="divModify" > <i class="layui-icon">&#xe642;</i>修改</div>|
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
                  <input type="text"  name="Zgs_id" op="keyId"   style="width: 200px;" placeholder="数据的id" value="0"  class="layui-input" >
                </div>
           </div>

           <div class="layui-form-item">
                <label class="layui-form-label">总公司名称</label>
                <div class="layui-input-block">
                  <input type="text" name="Zgs_name" op="keyValue"  lay-verify="required" style="width: 200px;" placeholder="请输入总公司名称" autocomplete="off" class="layui-input">
                </div>
          </div>

           <div class="layui-form-item">
                <label class="layui-form-label">所属集团</label>
                <div class="layui-input-inline" style="width: 200px;">
				    <select name="Jt_id" id="Jt_id" op="keyValue" lay-verify="required">
                    </select>
			    </div>
            </div>

            <div class="layui-form-item">
                <label class="layui-form-label">排序</label>
                <div class="layui-input-block">
                  <input type="text" name="Order_no"   lay-verify="required" style="width: 200px;" placeholder="排序" autocomplete="off" class="layui-input">
                </div>
          </div>

           <div class="layui-form-item layui-form-text">
              <label class="layui-form-label">备注</label>
              <div class="layui-input-inline" style="width: 300px;">
                <textarea name="Remarks" placeholder="请输入内容" class="layui-textarea"></textarea>
              </div>
            </div>

           
        </div>
    
    </form>
    <iframe name="1" id="1" style="visibility: hidden; height: 0px;"></iframe>
</body>
</html>
