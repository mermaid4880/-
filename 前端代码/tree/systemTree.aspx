<%@ Page Language="C#" AutoEventWireup="true" CodeFile="systemTree.aspx.cs" Inherits="tree_systemTree" %>


<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title></title>
    <link href="../plugins/zTree/css/zTreeStyle/zTreeStyle.css" rel="stylesheet" type="text/css" />
    <script src="../js/jquery-1.8.3.min.js" type="text/javascript"></script>
    <%--<script src="../plugins/zTree/js/jquery.ztree.all-3.5.min.js" type="text/javascript"></script>--%>


    <script src="../plugins/zTree/js/jquery.ztree.core-3.5.min.js" type="text/javascript"></script>
    <script src="../plugins/zTree/js/jquery.ztree.excheck-3.5.min.js" type="text/javascript"></script>

    <link href="../plugins/layui/css/layui.css" rel="stylesheet" type="text/css" />

    
    <style>
        
        body
        {
            
            margin:0px;
            
            }
        
        #searchBox
        {
            
          
            width:300px;
            height:50px;
            line-height:50px;
            text-align:left;
            
            }
    
    </style>

    <script>

        var zNodes = <%=seriesDataMenu.ToString() %>;
        var zTreeObj;
        // zTree 的参数配置，深入使用请参考 API 文档（setting 配置详解）
        var setting = {
            view: { showIcon: true },
            data: { simpleData: { enable: true, idKey: "no", pIdKey: "pId", rootPId: 0} },
            check: { enable: false },
            callback: {
		        onClick: zTreeOnClick
	        }
        };
        // zTree 的数据属性，深入使用请参考 API 文档（zTreeNode 节点数据详解）
        


        $(function () {
            zTreeObj = $.fn.zTree.init($("#treeObj"), setting, zNodes);
        });

        function getTreeObj() {

            return zTreeObj;
        }
        function zTreeOnClick(event, treeId, treeNode) {
            //alert(treeNode.tId + ", " + treeNode.name);
            //激发公共页面
            parent.window.public_page_click(treeNode.no);
        };
    
    </script>
</head>
<body>
   
   <div id="searchBox">
       <div class="layui-input-inline"  style="width:130px">
            <input type="text" name="title" lay-verify="title" autocomplete="off" placeholder="关键字查询" class="layui-input">
            
        </div>

        <div class="layui-input-inline"  style="width:80px">
			<input type="button" class="layui-btn layui-btn-sm layui-btn-primary" value="查询"></input>
		</div>
   </div>

   <ul id="treeObj" class="ztree"></ul>
  
</body>
</html>
