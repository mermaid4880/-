<%@ Page Language="C#" AutoEventWireup="true" CodeFile="仪表曲线1.aspx.cs" Inherits="echarts_firstPage_仪表曲线1" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <script src="../echarts.min.js" type="text/javascript"></script>
    <script src="../../js/jquery-1.8.3.min.js" type="text/javascript"></script>
   <style>
        body
        {
            background-color:#05577D;
            
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">

         <div id="main" style="width:100%;height:300px;"></div>

    </form>
</body>
</html>

<script>
    var myChart ;
    var timeTicket;
    $(function () {
        var main = document.getElementById("main");
        var aa = "<%=height%>";
        main.style.height = aa;

        // 基于准备好的dom，初始化echarts实例
        myChart = echarts.init(document.getElementById('main'));

        option = {
            tooltip: {
                formatter: "{a} <br/>{b} : {c}%"
            },
            title: {
                text: "  抄表成功率",
                textStyle: {
                    color: "#FFFFFF"
                },
                show: true
            },
            series: [
                {
                    name: '抄表成功率',
                    type: 'gauge',
                    detail: { formatter: '{value}%', color: "#FFFFFF" },
                    itemStyle: { color: "#FFFFFF" },
                    data: [{ value: 50}]
                }
            ]
        };

        option.series[0].data[0].value = 99.5;
        myChart.setOption(option, true);

    });

           


</script>
