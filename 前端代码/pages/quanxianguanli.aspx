<%@ Page Language="C#" AutoEventWireup="true" CodeFile="quanxianguanli.aspx.cs" Inherits="pages_quanxianguanli" %>


<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title>权限管理</title>
    <link href="../lib/ligerUI/skins/Aqua/css/ligerui-all.css" rel="stylesheet" type="text/css" />
    <link href="../lib/ligerUI/skins/Gray2014/css/all.css" rel="stylesheet" type="text/css" />
    <script src="../js/jquery-1.8.3.min.js" type="text/javascript"></script>
    <script src="../lib/ligerUI/js/core/base.js" type="text/javascript"></script>

    <link href="../js/layui/css/layui.css" rel="stylesheet" type="text/css" />
    <script src="../js/layer/layer.js" type="text/javascript"></script>

    <script src="../lib/ligerUI/js/plugins/ligerLayout.js" type="text/javascript"></script>
    <script src="../lib/ligerUI/js/plugins/ligerGrid.js" type="text/javascript"></script>
    <script src="../lib/ligerUI/js/ligerui.min.js"></script>
    <script src="../js/layui/layui.all.js"></script>
  
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

        #divHead p {
            height: 30px;
        }
    </style>

    <script type="text/javascript">
        var taskType = "qmxj";
        var public_token = "<%=public_token %>";
        var grid = null;
        var bodyHeight = document.documentElement.clientHeight; //页面高度
        $(function () {

            $("#layout1").ligerLayout({ leftWidth: 500, topHeight: 0});


            //装载树结构
            $("#ftree").attr("src", "../tree/allTree.aspx");
            //这里装载grid

            grid = $("#maingrid").ligerGrid({
                columns: [
                    { display: '姓名', name: 'name', align: 'left', width:250 },
                    { display: '手机号', name: 'phone', width:250 },
                     {
                        display: '操作', isSort: false, width: 300, render: function (rowdata, rowindex, value) {
                            var h = '';
                            h += "<a href='javascript:changeDB(" + rowindex + ")'>修改权限</a> ";
                            h += "<a href='javascript:deleteDB(" + rowindex + ")'>删除用户</a> ";
                           
                            return h;
                        }
                    }
                ]
                , pageSize: 30
                , width: '100%'
                , height: bodyHeight - 100
               
            });





        });

        function changeDB(rowindex) {
            //DB_DATA.Rows[rowindex]
            var arra = [];
            var vTreeObject = ftree.contentWindow.zTreeObj;
            var objtemp = vTreeObject.getCheckedNodes();
            for (var i = 0, l = objtemp.length; i < l; i++) {

                if (!objtemp[i].isParent) {
                    arra.push(objtemp[i].no.replace("N", ""));
                }
            }
            if (objtemp.length <= 0) {
                $.ligerDialog.warn('请选择权限');
                return;
            }
            //ajax 接口执行
            $.ligerDialog.success('权限修改成功');
        }

        function deleteDB(rowindex) {
            //DB_DATA.Rows[rowindex]
            
            //
            $.ligerDialog.confirm('确定删除' + DB_DATA.Rows[rowindex].name + "?", function (yes) {
                if (yes) {
                    //ajax 接口执行
                    $.ligerDialog.success('删除成功');
                }
            });
    
        }
        //这里是筛选方法
        function oncheckselected(thisv) {

            var boolv = thisv.prop("checked");
            var vTreeObject = ftree.contentWindow.zTreeObj;
            var node = vTreeObject.getNodeByParam("name", thisv.attr("data"), null);
            boolv ? vTreeObject.checkNode(node, true, true) : vTreeObject.checkNode(node, false, true);


        }

        var DB_DATA = {};

        function searchDB() {
            DB_DATA = {};
            var vList = f_getCheckedNodes("N");
            console.log(vList);
            //暂时用这个 正式替换为 下面注释掉的ajax getTaskTempletList
            //$.ajax({
            //    type: "get",
            //    url: "../handler/InterFace.ashx",
            //    data: {
            //        method: "getTaskTempletList"

            //       , token: public_token
            //        , taskType: taskType
            //    },
            //    dataType: "json",
            //    success: function (data) {
            //if(!data['success']){    return;};
            //DB_DATA = data['data'];
            //        grid.set({ data: DB_DATA });

            //    }
            //});
            var data = {
                "Total": 5,
                "Rows": [{ "name": "阿瑟东", "phone": "123456789" },
                    { "name": "阿瑟东", "phone": "123456789" },
                   { "name": "阿瑟东", "phone": "123456789" },
                 { "name": "阿瑟东", "phone": "123456789" },
                    { "name": "阿瑟东", "phone": "123456789" }
                ]
            }
            DB_DATA = data;
            grid.set({ data: DB_DATA });




        }


        function resetDB() {
            window.location.reload();
        }

        function f_getCheckedNodes(level) {
            var nodes = ftree.contentWindow.zTreeObj.getCheckedNodes();
            var names = "";
            var count = 0;
            for (var i = 0; i < nodes.length; i++) { node = nodes[i]; if (node.no.substring(0, 1) == level && !node.getCheckStatus().half) { names += node.no + ","; count += 1; } }
            if (count > 0) { names = names.substr(0, names.length - 1); }
            return names;
        }


    </script>

</head>
<body>
    <form id="form1" runat="server">
        <div id="layout1">
            <div position="left" title="权限树" style="padding-left: 10px; height: 100%;">
                <iframe id="ftree" frameborder="0" height="100%" width="100%" src="kong.htm"></iframe>
            </div>



            <div position="center" title="账户列表">

                <div class="layui-form" style="padding-top: 8px;">

                    <div class="layui-form-item">

                        <div class="layui-inline" style="float: left;">
                            <label class="layui-form-label" style="height: 30px; line-height: 30px; padding: 0px;">手机号：</label>
                            <div class="layui-input-inline">
                                <input style="height: 30px; line-height: 30px;" type="text" class="layui-input" id="phone" >
                            </div>
                        </div>

                        <div class="layui-inline" style="float: left;">
                            <label class="layui-form-label" style="height: 30px; line-height: 30px; padding: 0px;">姓名：</label>
                            <div class="layui-input-inline">
                                <input style="height: 30px; line-height: 30px;" type="text" class="layui-input" id="name" >
                            </div>
                        </div>

                        <div class="layui-input-inline" style="width: 80px">
                            <input type="button" class="layui-btn layui-btn-sm layui-btn-primary" style="height: 30px; line-height: 30px;" value="查询" onclick="searchDB()"></input>
                        </div>
                         <div class="layui-input-inline" style="width: 80px">
                            <input type="button" class="layui-btn layui-btn-sm layui-btn-primary" style="height: 30px; line-height: 30px;" value="增加" onclick="addDB()"></input>
                        </div>
                    </div>
                </div>

                <div id="maingrid" style="margin: 0; padding: 0"></div>

            </div>
            
        </div>

    </form>
    <script>
        layui.use('laydate', function () {
            var laydate = layui.laydate;

            laydate.render({
                elem: '#time1',
                type: 'datetime'
            });
            laydate.render({
                elem: '#time2',
                type: 'datetime'
            });
        })

        
    </script>



</body>
</html>
