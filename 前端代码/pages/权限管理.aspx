<%@ Page Language="C#" AutoEventWireup="true" CodeFile="权限管理.aspx.cs" Inherits="pages_权限管理" %>


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
    <script src="../js/layui/layui.js" type="text/javascript"></script>

    <script src="../lib/ligerUI/js/plugins/ligerLayout.js" type="text/javascript"></script>
    <script src="../lib/ligerUI/js/plugins/ligerGrid.js" type="text/javascript"></script>
    <script src="../lib/ligerUI/js/ligerui.min.js"></script>

    <script type="text/javascript" src="../js/jquery/jquery.tips.js"></script>

    <script src="../lib/js/publicMethodJs.js" type="text/javascript"></script>
    <script src="public_getTreeJs.js" type="text/javascript"></script>
    <script src="../js/json2.js" type="text/javascript"></script>


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

        .l-layout-top  .l-layout-content {
            background-color:#f5f5f5;
        }
        .l-layout-top {
             background-color:#f5f5f5;
        }
         .l-layout-header {     
            background-color:RGB(203,233,231) !important;
            color:#000;
        }
         .l-bar-selectpagesize{
            display:none !important;
        }

    </style>


    <script type="text/javascript">
        var dataAll;
        var taskType = "qmxj";
        var public_token = "<%=public_token %>";
        var public_userName = "<%=public_userName%>";
        var public_userId = "<%=public_userId%>";
        var grid = null;
        var bodyHeight = document.documentElement.clientHeight; //页面高度
        $(function () {

            $("#layout1").ligerLayout({ leftWidth: 400});
            
            //装载树结构
            $("#ftree").attr("src", "../tree/MenuTree.aspx");

            //这里装载grid 绑定表格列
            grid = $("#maingrid").ligerGrid({
                columns: [
                    { display: '姓名', name: 'username',  width: 480 },
                    { display: '显示姓名', name: 'showname', width: 480 },
                    { display: '操作', isSort: false, width: 490, render: function (rowdata, rowindex, value) {
                        var h ="<a href='javascript:passW(" + rowindex + ")'>修改密码</a>&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp <a href='javascript:editDB(" + rowindex + ")'>修改权限</a>&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp <a href='javascript:delDB(" + rowindex + ")'>删除用户</a>";
                        return h;
                    }
                    }
                ]
                //, checkbox: true
                , pageSize: 100
                //, usePager:true
                , pageSizeOptions: [100]//可指定每页页面大小
                , width: '100%'
                , height: bodyHeight - 155
                , delayLoad: true
                //, url: "../handler/loadGrid.ashx?view=http_getGridMethod&methodName=getUser&r=" + Math.random()
                //添加一个双击回调
                , onDblClickRow: function (data, rowindex, rowobj) {
                    getdetail(data, rowindex, rowobj)
                }
            });

        });

        function getdetail(data, rowindex, rowobj) {
            console.log(data);
            var allMeters = [];
            allMeters = data.accessIds.split(',');
            //对左侧树进行筛选
            console.log(allMeters);
            selectedNodesOnTree(allMeters);
        }

        //还原权限所有节点
        function selectedNodesOnTree(vArray) {

            if (vArray.length > 0) {
                var vTreeObject = public_getTreeObject();
                vTreeObject.checkAllNodes(false); //先默认都不选择
                for (var i = 0; i < vArray.length; i++) {
                    var node = vTreeObject.getNodeByParam("no",vArray[i] + "0");
                    console.log(node);
                    vTreeObject.checkNode(node, true, true);
                }
            }
        }

        var Data = [];
        //修改密码
        function passW(index){
            
             //这里弹出修改界面
            var detail_exportDB = $.ligerDialog.open({
                target: $("#div_create_1"),
                title: "修改密码",
                width: 400, top: 150,
                buttons: [
                    {
                        text: '确定', onclick: function () {
                            if ($("#txtPsw_Create_1").val() == "" || $("#txtPswConfirm_Create_1").val() == "") {
                                layer.msg("必填消息，不能为空");
                            }
                            else if ($("#txtPsw_Create_1").val() != $("#txtPswConfirm_Create_1").val()) {
                                layer.msg("前后密码不一致");
                                return;
                            } else {
                                var Username = Data[index].username;
                                var userid = Data[index].id;
                                var Password = $("#txtPsw_Create_1").val();
                                detail_exportDB.hide();
                                var strPost = "username=" + Username + "&password=" + Password;
                                $.ajax({
                                type: "post",
                                url: "../handler/InterFace.ashx?r=" + Math.random(),
                                data: {
                                    method: "http_PutMethod"
                                    , token: public_token
                                    , MethodUrl: "/users/" + userid 
                                    , postData: strPost
                                },
                                dataType: "json",
                                success: function (data) {
                                    //{success:"true","detail": "xxx"}
                                    if (data) {
                                     
                                        if (data.success == true) {
                                        
                                            layer.msg("[" + Username + "]提交成功!");
                                            searchDB();
                                            window.location.reload();
                                        }
                                        else {
                                            layer.msg(data.detail);
                                        }
                                    }
                                }
                            });
                             }
                        }
                    },
                    { text: '取消', onclick: function () { detail_exportDB.hide(); } }
                ]
            });

        }

        var Quanxianbianhao = ["机器人管理","任务管理","实时监控","巡检结果确认","巡检结果分析","用户设置","机器人系统调试维护"];
        //修改权限
        function editDB(rowindex) {
            
            var menu = getAllMenuSelected();

            if (!menu) {
                return;
            }

            var Username = Data[rowindex].username;
            //Username = encodeURI(Username);

            var userId = Data[rowindex].id;
            //Username = encodeURI(Username);

            var detail_task = $.ligerDialog.open({
                target: $("#div_update"),
                title: "修改用户权限",
                width: 300, top: 220,
                buttons: [
                {
                    text: '确定', onclick: function () {
                        
                        detail_task.hide()
                        
                        var postData = "username=" + Username + "&accessIds=" + menu;
                        $.ajax({
                            type: "post",
                            url: "../handler/InterFace.ashx?r=" + Math.random(),
                            data: {
                                method: "http_PutMethod"
                                , token: public_token
                                , MethodUrl: "/users/" + userId
                                , postData: postData
                            },
                            dataType: "json",
                            success: function (data) {
                                //{success:"true","detail": "xxx"}
                                if (data) {
                                    if (data.success == true) {
                                        layer.msg("保存成功!");
                                        searchDB();
                                        window.location.reload();
                                    }
                                    else {
                                        layer.msg(data.detail);
                                    }
                                }
                            }
                        });
                        detail_task.hide();
                    }
                },
                { text: '取消', onclick: function () { detail_task.hide(); } }
                ]
            });
        }

        //得到选中
        function getAllMenuSelected() {
            //var arra = [];
            //var vTreeObject = public_getTreeObject();
            //var objtemp = vTreeObject.getCheckedNodes();
            //for (var i = 0, l = objtemp.length; i < l; i++) {

            //    if (!objtemp[i].isParent) {
            //        arra.push(objtemp[i].name.replace("N", ""));
            //    }
            //}
            if (quanxian.length <= 0) {
                $.ligerDialog.warn('请选择需要修改的权限');
                return false;
            }
           
            var k = "";
            for (var i = 0; i < Quanxianbianhao.length; i++){
                  for (var j = 0; j < quanxian.length; j++) {
                      if (Quanxianbianhao[i] == quanxian[j]) {
                             //alert(quanxian[j]);
                             if (j != quanxian.length - 1) {
                                k += (i + 1) + ",";
                             } else {
                                     k += (i + 1);
                                }
                             }
                      }

             }
            
            return k;
        }

        //删除用户
        function delDB(index) {
            console.log("111"+index);
            var detail_exportDB = $.ligerDialog.open({
                target: $("#div_del"),
                title: "删除用户",
                width: 400, top: 150,
                buttons: [
                {
                    text: '确定', onclick: function () {
                        var userid = Data[index].id;
                        //alert(userid);
                        detail_exportDB.hide();
                            
                        $.ajax({
                            type: "get",
                            url: "../handler/InterFace.ashx?r=" + Math.random(),
                            data: {
                                method: "http_DelMethod"
                                , token: public_token
                                , MethodUrl: "/users/" + userid
                                , postData: ""
                            },
                            dataType: "json",
                            success: function (data) {
                                //{success:"true","detail": "xxx"}
                                if (data) {
                                        
                                    if (data.success == true) {
                                       
                                        layer.msg("删除成功!");
                                        searchDB();
                                        
                                        //parent.window.queryData();
                                        window.location.reload();
                                    }
                                    else {
                                        layer.msg("删除失败!");
                                    }
                                }
                            }
                        });
                    }
                },
                { text: '取消', onclick: function () { detail_exportDB.hide(); } }
                ]
            });
        }

        function createDB() {
            if (quanxian.length > 0) {
            //这里弹出添加界面
            var detail_exportDB = $.ligerDialog.open({
                target: $("#div_create"),
                title: "新增用户",
                width: 400, top: 150,
                buttons: [
                {
                        text: '确定', onclick: function () {
                            

                            if ($("#txtPsw_Create").val() == "" || $("#txtPswConfirm_Create").val() == "" ||

                                $("#txtName_Create").val() == ""||$("#txtShowname_Create").val()=="") {
                                layer.msg("以上内容为必填消息，均不能为空");

                            }
                            else if ($("#txtPsw_Create").val() != $("#txtPswConfirm_Create").val()) {

                                layer.msg("前后密码不一致");
                                return;
                            } else {
                                //空格验证
                                var nbsp = /^\s+|\s+$/;
                                //整数验证
                                var Phone = /[0-9]/; 
                                //特殊字符
                                var regEn = /[`~!@#$%^&*()_+<>?:"{},.\/;'[\]]/im,
                                    regCn = /[·！#￥（——）：；“”‘、，|《。》？、【】[\]]/im;

                                if(regEn.test($("#txtName_Create").val()) || regCn.test($("#txtName_Create").val())||nbsp.test($("#txtName_Create").val())) {
                                    layer.msg("对不起，名称不能包含特殊字符和空格");
                                    return;
                                }
                                if (regEn.test($("#txtShowname_Create").val()) || regCn.test($("#txtName_Create").val())||nbsp.test($("#txtName_Create").val())) {
                                    layer.msg("对不起，显示姓名不能包含特殊字符和空格");
                                    return;
                                }
                                //if(regEn.test($("#txtPhoneNum_Create").val()) || regCn.test($("#txtName_Create").val())||nbsp.test($("#txtName_Create").val())) {
                                //    layer.msg("对不起，电话号码不能包含特殊字符和空格");
                                //    return;
                                //}
                                //if (!Phone.test($("#txtPhoneNum_Create").val())) {
                                //    layer.msg("对不起，电话号码必须为整形数字");
                                //    return;
                                //}

                                var postData = "";
                               
                                var k = "";
                                for (var i = 0; i < Quanxianbianhao.length; i++){
                                    for (var j = 0; j < quanxian.length; j++) {
                                        if (Quanxianbianhao[i] == quanxian[j]) {
                                            //alert(quanxian[j]);
                                            if (j != quanxian.length - 1) {
                                                k += (i + 1) + ",";
                                            } else {
                                                k += (i + 1);
                                            }
                                            
                                        }
                                    }

                                }
                                //alert(k);
                                //新用户的账号 密码  呢称  电话  权限
                                var Username = $("#txtName_Create").val();
                                var Password = $("#txtPsw_Create").val();
                                var Showname = $("#txtShowname_Create").val();
                                var AccessIds = k;//还未获取
                                //var PhoneNum = $("#txtPhoneNum_Create").val();
                                //layer.msg("添加新用户成功");
                                var vid = "?username=" + Username + "&password=" + Password + "&showname=" + Showname + "&accessIds=" + AccessIds;
                                vid = encodeURI(vid);
                                console.log("/users" + vid);
                                detail_exportDB.hide();

                            }

                            $.ajax({
                                type: "post",
                                url: "../handler/InterFace.ashx?r=" + Math.random(),
                                data: {
                                    method: "http_PostMethod"
                                    , token: public_token
                                    , MethodUrl: "/users" + vid
                                    , postData: postData
                                },
                                dataType: "json",
                                success: function (data) {
                                    //{success:"true","detail": "xxx"}
                                    if (data) {
                                        if (data.success == true) {
                                            layer.msg("用户[" + Username + "]创建成功!");
                                            searchDB();
                                            //parent.window.queryData();
                                            window.location.reload();
                                        }
                                        else {
                                            layer.msg(data.detail);
                                       
                                        }
                                    }
                                }
                            });

                    }
                },
                { text: '取消', onclick: function () { detail_exportDB.hide(); } }
                ]
            });

             } else {
                 layer.msg("请先点击左侧树选定用户权限");
            }

        }

        searchDB();

        function searchDB() {

           //这里是传参
            //var vParaArray = [];
            //vParaArray.push({ "key": "username", "value": "" });
            ////vParaArray.push({ "key": "endTime", "value": endTime });
            ////vParaArray.push({ "key": "taskStatus", "value": strstatus });
            ////vParaArray.push({ "key": "taskName", "value": taskName });
            //grid.setParm("param1", JSON2.stringify(vParaArray));
            //grid.reload();

            //quanxian = encodeURI(quanxian);
            //var phone = $("#txtPhoneNum").val();
            //var name = $("#txtName").val();
            
            var vUrl = "getUser";
            //alert(vUrl);
            $.ajax({
                type: "get",
                url: "../handler/loadGrid.ashx?r=" + Math.random(),
                data: {
                    view: "http_getGridMethod"
                    , methodName: vUrl
                    , token: public_token
                    //, ListName: ""
                },
                dataType: "json",
                success: function (data) {
                    console.log(data);
                    if (!data.success ) {
                        layer.msg(data.detail);
                        return;
                    }

                    dataAll = data;

                    if (data.Rows == 0) {
                        layer.msg("没有符合条件的数据")
                    } else {
                        //console.log(data);
                        Data = data.Rows;
                        grid.set({ data: data });
                    }

                }
            });

        


        }

        //加载layui 
         layui.use(['layer', 'form', 'laydate'], function () {
             var form = layui.form;
             //form.render();
             layer = layui.layer;
        });


        


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

        //var quanxian = "";
        var quanxian = [];
        function public_page_onCheck(v) {         
            //每次清空数组，方便放入新的值
            quanxian.splice(0,quanxian.length);
            // 把获取的值转换成字符串
            //for (var i = 1; i < v.length; i++) {
            //    if (i == v.length - 1) {
            //        quanxian += v[i];
            //        break;
            //    }
            //    quanxian += v[i]+",";
            //}

            //把获取的值转换为数组
           for (var i = 1; i < v.length; i++) {
                
                    quanxian[i]= v[i];
              
            }
        }
       

        

    </script>

</head>
<body>
    <form id="form1" runat="server">
        <div id="layout1" style="height:80px">
            
            <div position="left" title="菜单树" style="padding-left: 10px;height:820px">
                <iframe id="ftree" frameborder="0" height="820px" width="100%" src="kong.htm"></iframe>
            </div>

            <div position="center" title="用户列表">
            </div>

            
            <div position="center" title="">
                <div class="layui-form-item" >
                    <div class="layui-form-item" style="padding-top: 10px;">

                        <label class="layui-form-label">手机号</label>
                        <div class="layui-input-inline">
                            <input type="text" class="layui-input" id="txtPhoneNum">
                        </div>
                        <label class="layui-form-label">姓名</label>
                        <div class="layui-input-inline">
                            <input type="text" class="layui-input" id="txtName">
                        </div>

                        <div class="layui-input-inline" style="width: 80px">
                            <input type="button" class="layui-btn"  value="查询" onclick="searchDB()">
                        </div>
                       
                        <div class="layui-input-inline" style="width: 80px">
                            <input type="button" class="layui-btn"  value="增加" onclick="createDB()">
                        </div>

                    </div>
                </div>
                <div id="maingrid" style="margin: 0; padding: 0"></div>
            </div>

        </div>



        <div id="div_create" style="display:none;padding-top:10px;"  class="layui-form"  >
                  
            <div class="layui-form-item">
                <label class="layui-form-label">姓名</label>
                <div class="layui-input-block">
                    <input type="text" class="layui-input"  style="width:200px" placeholder="请输入姓名" id="txtName_Create">
                </div>
            </div>

            <%--<div class="layui-form-item">
                <label class="layui-form-label">手机号</label>
                <div class="layui-input-block">
                    <input type="text" class="layui-input"  style="width:200px" placeholder="请输入手机号" id="txtPhoneNum_Create">
                </div>
            </div>--%>

            <div class="layui-form-item">
                <label class="layui-form-label">显示姓名</label>
                <div class="layui-input-block">
                    <input type="text" class="layui-input"  style="width:200px" placeholder="请输入显示姓名" id="txtShowname_Create">
                </div>
            </div>

            <div class="layui-form-item">
                <label class="layui-form-label">密码</label>
                <div class="layui-input-block">
                    <input type="password" class="layui-input"  style="width:200px" placeholder="请输入密码" id="txtPsw_Create">
                </div>
            </div>

            <div class="layui-form-item">
                <label class="layui-form-label">确认密码</label>
                <div class="layui-input-block">
                    <input type="password" class="layui-input"  style="width:200px" placeholder="请再次输入密码" id="txtPswConfirm_Create">
                </div>
            </div>


           <%-- <div class="layui-form-item layui-form-text">
                <label class="layui-form-label">备注</label>
                <div class="layui-input-inline" style="width: 200px;">
                <textarea name="Remarks"  placeholder="请输入内容" class="layui-textarea"></textarea>
                </div>
            </div>--%>

           
        </div>


         <div id="div_create_1" style="display:none;padding-top:10px;"  class="layui-form"  >
                  

            <div class="layui-form-item">
                <label class="layui-form-label">密码</label>
                <div class="layui-input-block">
                    <input type="password" class="layui-input"  style="width:200px" placeholder="请输入密码" id="txtPsw_Create_1">
                </div>
            </div>

            <div class="layui-form-item">
                <label class="layui-form-label">确认密码</label>
                <div class="layui-input-block">
                    <input type="password" class="layui-input"  style="width:200px" placeholder="请确认输入密码" id="txtPswConfirm_Create_1">
                </div>
            </div>


          

           
        </div>

        <div id="div_update" style="display: none; text-align: left; line-height: 30px; padding-left: 50px;">
            <p>确定修改权限吗?</p>
        </div>
        <div id="div_del" style="display: none; text-align: left; line-height: 30px; padding-left: 50px;">
            <p>确定删除该用户吗?</p>
        </div>
    </form>




</body>
</html>
