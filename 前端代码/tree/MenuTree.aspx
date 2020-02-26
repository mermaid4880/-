<%@ Page Language="C#" AutoEventWireup="true" CodeFile="MenuTree.aspx.cs" Inherits="tree_MenuTree" %>


<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title></title>
    <link href="../plugins/zTree/css/zTreeStyle/zTreeStyle.css" rel="stylesheet" type="text/css" />
    <script src="../js/jquery-1.8.3.min.js" type="text/javascript"></script>

    <script src="../plugins/zTree/js/jquery.ztree.all-3.5.min.js" type="text/javascript"></script>
    <script src="../plugins/zTree/js/jquery.ztree.core-3.5.min.js" type="text/javascript"></script>
    <script src="../plugins/zTree/js/jquery.ztree.excheck-3.5.min.js" type="text/javascript"></script>
     <script src="../plugins/zTree/js/jquery.ztree.exhide-3.5.min.js"></script>

    
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
            check: { enable: true },
            callback: {
                onClick: zTreeOnClick,
                onCheck: onCheck

	        }
        };
       

        $(function () {
            zTreeObj = $.fn.zTree.init($("#treeObj"), setting, zNodes);
        });

        function getTreeObj() {

            return zTreeObj;
        }
        function zTreeOnClick(event, treeId, treeNode) {
            alert(treeNode.no + ", " + treeNode.name);
            //激发公共页面
            //parent.window.public_page_click(treeNode.no);
        };
    

        function oncheckselected(){
            
            console.log(1);
            var vLen=$("input[name='ck1']:checked").length;

            var treeObj = $.fn.zTree.getZTreeObj("treeObj");
            treeObj.checkAllNodes(false);

            $("input[name='ck1']:checked").each(function (index, item) {

                var node = treeObj.getNodeByParam("no", $(this).val(), null);
                if (node != null) {
                    treeObj.checkNode(node, true, true);
                }
            });

            console.log(vLen);
           
        
        }
        function onCheck(e, treeId, treeNode) {
            var treeObj = $.fn.zTree.getZTreeObj("treeObj"),
                nodes = treeObj.getCheckedNodes(true),
                v = [];
            console.log(nodes);
            for (var i = 0; i < nodes.length; i++) {
                v[i] = nodes[i].name;
                //alert(nodes[i].no); //获取选中节点的值
                
            }
            parent.window.public_page_onCheck(v);
        }
    </script>
</head>
<body>

   <ul id="treeObj" class="ztree"></ul>


</body>
</html>
