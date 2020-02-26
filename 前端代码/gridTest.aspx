<%@ Page Language="C#" AutoEventWireup="true" CodeFile="gridTest.aspx.cs" Inherits="gridTest" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <link href="lib/ligerUI/skins/Aqua/css/ligerui-all.css" rel="stylesheet" type="text/css" />
     <script src="js/jquery-1.8.3.min.js" type="text/javascript"></script>
    <script src="lib/ligerUI/js/ligerui.min.js" type="text/javascript"></script>
    <script src="js/json2.js" type="text/javascript"></script>


    <script>
        var maingrid1;
        $(function () {

            maingrid1 = $("#maingrid1").ligerGrid({
                columns: [
                    { display: '识别时间', name: 'time', width: 300 },
                    { display: '点位名称', name: 'meterName', width: 548 },
                    { display: '识别类型', name: 'detectionType', width: 350 },
                    { display: '识别结果', name: 'detectionValue', width: 350 },
                    { display: '告警等级', name: 'detectionStatus', width: 350 }
                ]
                , pageSize: 2
                , pageSizeOptions: [2]
                , width: '100%'
                , height: 206
                , url: "handler/loadGrid.ashx?view=http_getGridMethod_expend&methodName=detectionDatas"
            });
        })

        function search() {

            var text1 = $("#txt1").val();
            var vPassJson = {};
            vPassJson.text1 = text1;
            vPassJson.text2 = "2";
            maingrid1.set({ parms: [{ name: "parm1", value: JSON2.stringify(vPassJson)}] });
            maingrid1.reload();
        }
    </script>

</head>
<body>
    <form id="form1" runat="server">
    <div>
     参数  <input  type="text" value="" id="txt1" />
     <input type="button" value="查询" id="btn1" onclick="search()" />
     <div id="maingrid1" style="margin: 0; padding: 0"></div>
    </div>
    </form>
</body>
</html>
