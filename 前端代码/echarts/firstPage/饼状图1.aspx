<%@ Page Language="C#" AutoEventWireup="true" CodeFile="饼状图1.aspx.cs" Inherits="echarts_firstPage_饼状图1" %>

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
    <script>


        $(function () {
            var main = document.getElementById("main");
            var aa="<%=height%>";
            main.style.height = aa;

            myChart = echarts.init(document.getElementById('main'));

            option = {
                title: {
                    text: '阀平衡占比',
                    x: 'center',
                    textStyle: {
                        color: "#FFFFFF"
                    }
                },
                tooltip: {
                    trigger: 'item',
                    formatter: "{a} <br/>{b} : {c} ({d}%)"
                },
                legend: {
                    orient: 'vertical',
                    x: 'left',
                    textStyle:{
                        color:"#FFFFFF",
                    },
                    data: ['平衡阀数量', '未平衡阀数量']

                },
                toolbox: {
                    show: true,
                    feature: {
                        mark: { show: true },
                        dataView: { show: true, readOnly: false },
                        magicType: {
                            show: true,
                            type: ['pie', 'funnel'],
                            option: {
                                funnel: {
                                    x: '25%',
                                    width: '50%',
                                    funnelAlign: 'left',
                                    max: 1548
                                }
                            }
                        }
                    }
                },
                calculable: true,
                series: [
                    {
                        name: '访问来源',
                        type: 'pie',
                        radius: '55%',
                        center: ['50%', '60%'],
                        itemStyle: {
                            normal: {
                                //好，这里就是重头戏了，定义一个list，然后根据所以取得不同的值，这样就实现了，
                                color: function (params) {
                                    // build a color map as your need.
                                    var colorList = [
                              '#8dc1a9', '#E87C25', '#c33733',
                               '#91c7ae', '#9BCA63', '#FAD860', '#F3A43B', '#60C0DD',
                               '#D7504B', '#C6E579', '#F4E001', '#F0805A', '#26C0C0'
                            ];
                                    return colorList[params.dataIndex]
                                }
                            }
                        },
                        data: [
                            { value: 335, name: '平衡阀数量' },
                            { value: 310, name: '未平衡阀数量' }
                        ]
                    }
                ]
            };
         

            myChart.setOption(option, true);

        });

    </script>

</head>
<body>
    <form id="form1" runat="server">
         <div id="main" style="width:100%;height:300px;"></div>
    </form>
</body>
</html>

