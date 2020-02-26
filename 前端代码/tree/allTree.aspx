<%@ Page Language="C#" AutoEventWireup="true" CodeFile="allTree.aspx.cs" Inherits="tree_allTree" %>


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
        var  MeterPropertyJsonArray= <%=MeterPropertyJsonArray.ToString() %>;//这里是个 json数组 格式 是[{"meterId":"N1","meterName":"A线路避雷器A相_泄露电流表","meterType":"泄漏电流表","detectionType":"表计读取"},{"meterId":"N2","meterName":"A线路避雷器A相_接头","meterType":"红外检测点","detectionType":"红外测温"},{"meterId":"N3","meterName":"A线路避雷器B相_接头","meterType":"红外检测点","detectionType":"红外测温"},{"meterId":"N5","meterName":"A线路断路器A相_接头","meterType":"红外检测点","detectionType":"红外测温"},{"meterId":"N4","meterName":"B线路断路器A相_接头","meterType":"红外检测点","detectionType":"红外测温"}]
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
        // zTree 的数据属性，深入使用请参考 API 文档（zTreeNode 节点数据详解）
        /// vType=meterType vTypeName=泄漏电流表
        function fromMeterPropertyGetMeterIdList(vType, vTypeName) {

            var idListArry = [];

            if (MeterPropertyJsonArray.length == 0) {
                return idListArry;
            }
           
            for (var i = 0; i < MeterPropertyJsonArray.length; i++) {
                var o = MeterPropertyJsonArray[i];
                if (o[vType] == vTypeName) {
                    idListArry.push(o["meterId"]);
                }
            }
            
            return idListArry;
        }

         // zTree 的数据属性，深入使用请参考 API 文档（zTreeNode 节点数据详解）
        /// vType=meterType vTypeName=泄漏电流表 //设备区域 
        function fromMeterPropertyGetMeterIdList2(vType, vTypeName,vDeviceAreas) {

            var idListArry = [];

            if (MeterPropertyJsonArray.length == 0) {
                return idListArry;
            }
            //如果没有选择区域的话，也返回空
            if(vDeviceAreas.length==0){
                idListArry;
            }
            
            for (var i = 0; i < MeterPropertyJsonArray.length; i++) {
                var o = MeterPropertyJsonArray[i];
                if (o[vType] == vTypeName) {
                    for(var j=0;j<vDeviceAreas.length;j++){
                        if(o["areaId"]==vDeviceAreas[j]){
                            idListArry.push(o["meterId"]);
                            break;
                        }
                    }
                    
                }
            }
            
            return idListArry;
        }


        $(function () {
            zTreeObj = $.fn.zTree.init($("#treeObj"), setting, zNodes);
        });

        function getTreeObj() {

            return zTreeObj;
        }
        function zTreeOnClick(event, treeId, treeNode) {
            //alert(treeNode.tId + ", " + treeNode.name);
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

        function searchTree() {

            var vKey = $("#title").val();
            if (vKey) {
                var treeObj = $.fn.zTree.getZTreeObj("treeObj");

                var nodes = treeObj.getNodesByFilter(Treefilter); // 查找节点集合
                for (var i = 0; i < nodes.length; i++) {

                    if (nodes[i].name.indexOf(vKey) < 0) {
                        treeObj.hideNode(nodes[i]);
                    }
                    else {
                        treeObj.showNode(nodes[i]);
                    }
                }
            }
            else {
                var treeObj = $.fn.zTree.getZTreeObj("treeObj");
                var nodes = treeObj.getNodesByFilter(Treefilter); // 查找节点集合
                treeObj.showNodes(nodes);
            }

        }
        function Treefilter(node) {
            return (node.no.indexOf("N") > -1);
        }

        function onCheck(e, treeId, treeNode) {
            var treeObj = $.fn.zTree.getZTreeObj("treeObj"),
                nodes = treeObj.getCheckedNodes(true),
                v = [];
            console.log(nodes);
            for (var i = 0; i < nodes.length; i++) {
                v[i]= nodes[i].no;
                //alert(nodes[i].no); //获取选中节点的值
               
            }
            //激发公公页面 给父页面传递勾选后的几点id的数组
             parent.window.public_page_click(v);
        }
    </script>
</head>
<body>
   <div id="searchBox">
       <div class="layui-input-inline"  style="width:130px">
            <input type="text" id="title" lay-verify="title" autocomplete="off" placeholder="关键字查询" class="layui-input">
            
        </div>

        <div class="layui-input-inline"  style="width:80px">
			<input type="button" class="layui-btn layui-btn-sm layui-btn-primary" value="查询" onclick="searchTree()" ></input>
		</div>
   </div>
   <ul id="treeObj" class="ztree"></ul>

    <div style="height:300px;width:500px">
   
   <div id="mydiv"></div>

   </div>

  
</body>
</html>
