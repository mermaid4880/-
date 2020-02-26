<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Default.aspx.cs" Inherits="pages_Default" %>



<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title></title>
    
    <link href="../lib/ligerUI/skins/Aqua/css/ligerui-all.css" rel="stylesheet" type="text/css" />
    
    <script src="../lib/jquery/jquery-1.9.0.min.js" type="text/javascript"></script>
    <script src="../lib/ligerUI/js/core/base.js" type="text/javascript"></script>
    <script src="../lib/ligerUI/js/plugins/ligerLayout.js" type="text/javascript"></script>

      <style type="text/css">
        body{ padding:10px; margin:0;}
        #layout1{  width:100%; margin:40px;  height:400px;
                   margin:0; padding:0;}
        #accordion1 { height:270px;}
         h4{ margin:20px;}
    </style>

     <script type="text/javascript"> 
            $(function ()
            { 
 
                $("#layout1").ligerLayout({
                    onLeftToggle: function (isColl)
                    {
                        alert(isColl ? "收缩" : "显示");
                    },
                    onRightToggle: function (isColl)
                    {
                        alert(isColl ? "收缩" : "显示");
                    },
 
                });
            });
             
     </script> 

</head>
<body>
    <form id="form1" runat="server">

     <div id="layout1" class="l-layout" ligeruiid="layout1" style="height: 375px;">
         
         <div class="l-layout-left" style="left: 0px; width: 110px; top: 55px; height: 263px;"><div class="l-layout-header"><div class="l-layout-header-toggle"></div><div class="l-layout-header-inner"></div></div><div position="left" class="l-layout-content"></div></div>
        <div class="l-layout-center" style="width: 958px; top: 55px; left: 115px; height: 263px;"><div class="l-layout-header">标题</div><div position="center" title="" class="l-layout-content" style="height: 238px;">
        <h4>$("#layout1").ligerLayout(); </h4>
        默认为固定layout的高度百分一百
        </div></div>
        <div class="l-layout-right" style="width: 170px; top: 55px; height: 263px; left: 1078px;"><div class="l-layout-header"><div class="l-layout-header-toggle"></div><div class="l-layout-header-inner"></div></div><div position="right" class="l-layout-content"></div></div>
        <div class="l-layout-top" style="top: 0px; height: 50px;"><div position="top" class="l-layout-content"></div></div>
        <div class="l-layout-bottom" style="height: 50px; top: 323px;"><div position="bottom" class="l-layout-content"></div></div>
        <div class="l-layout-lock"></div><div class="l-layout-drophandle-left" style="display: block; left: 110px; height: 263px; top: 55px;"></div><div class="l-layout-drophandle-right" style="display: block; left: 1075px; height: 263px; top: 55px;"></div><div class="l-layout-drophandle-top" style="display: block; top: 50px; width: 1248px;"></div><div class="l-layout-drophandle-bottom" style="display: block; top: 320px; width: 1248px;"></div><div class="l-layout-dragging-xline"></div><div class="l-layout-dragging-yline"></div><div class="l-dragging-mask" style="height: 375px;"></div><div class="l-layout-collapse-left" style="display: none; top: 55px; height: 263px;"><div class="l-layout-collapse-left-toggle"></div></div><div class="l-layout-collapse-right" style="display: none; top: 55px; height: 263px;"><div class="l-layout-collapse-right-toggle"></div></div>
        
    </div> 
            

    </form>
</body>
</html>
