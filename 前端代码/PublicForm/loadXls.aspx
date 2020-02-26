<%@ Page Language="C#" AutoEventWireup="true" CodeFile="loadXls.aspx.cs" Inherits="PublicForm_loadXls" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <script src="../js/json2.js" type="text/javascript"></script>


</head>
<body>
    <form id="form1" runat="server">
    <div id="divContent" style="width:100%;border:1px solid red;">
        <img src="excel.png" style="width:50px;height:45px" /><a href="#" title="#">文件名称</a>
    </div>
    </form>
</body>
</html>

    <script>

        var public_execlInfo = "<%=public_execlInfo %>";
        if (public_execlInfo) {

            var json = JSON2.parse(public_execlInfo);
            var vHtml = '<img src="excel.png" style="width:50px;height:45px" /><a href="#" title="">文件名称</a>';
            document.getElementById("divContent").innerHTML = vHtml
            
        }
    
    </script>
