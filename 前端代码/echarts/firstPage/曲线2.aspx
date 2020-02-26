<%@ Page Language="C#" AutoEventWireup="true" CodeFile="曲线2.aspx.cs" Inherits="echarts_firstPage_曲线2" %>


<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
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
                    text: "最近一周温度曲线",
                    textStyle: {
                        color: "#FFFFFF"
                    },
                    show: true
                },
                tooltip: {
                    trigger: 'axis'
                },
                legend: {
                    textStyle:{
                        color:"#FFFFFF",
                    },
                    data: ['最高气温', '最低气温']
                },
               
                xAxis: {
                    type: 'category',
                    boundaryGap: false,
                    data: ['周一', '周二', '周三', '周四', '周五', '周六', '周日']
                    ,axisLabel: {
                            textStyle: {
                            color: '#FFFFFF'
                            }
                            }
                },
                yAxis: {
                    type: 'value',
                    axisLabel: {
                        formatter: '{value} °C'
                    }
                    ,axisLabel: {
                            textStyle: {
                            color: '#FFFFFF'
                            }
                            }
                },
                series: [
                    {
                        name: '最高气温',
                        type: 'line',
                        itemStyle: {
                            normal: {
                                color: '#E87C25'
                            }
                        },  
                        data: [11, 11, 15, 13, 12, 13, 10],
                        markPoint: {
                            data: [
                                { type: 'max', name: '最大值' },
                                { type: 'min', name: '最小值' }
                            ]
                        },
                        markLine: {
                            data: [
                                { type: 'average', name: '平均值' }
                            ]
                        }
                    },
                    {
                        name: '最低气温',
                        type: 'line',
                        itemStyle: {
                            normal: {
                                color: '#8dc1a9'
                            }
                        },  
                        data: [1, -2, 2, 5, 3, 2, 0],
                        markPoint: {
                            data: [
                                { name: '周最低', value: -2, xAxis: 1, yAxis: -1.5 }
                            ]
                        },
                        markLine: {
                            data: [
                                { type: 'average', name: '平均值' },
                                [{
                                    symbol: 'none',
                                    x: '90%',
                                    yAxis: 'max'
                                }, {
                                    symbol: 'circle',
                                    label: {
                                        normal: {
                                            position: 'start',
                                            formatter: '最大值'
                                        }
                                    },
                                    type: 'max',
                                    name: '最高点'
                                }]
                            ]
                        }
                    }
                ]
            };


            myChart.setOption(option, true);

        });

    </script>

</head>
<body>
    <form id="form1" runat="server">
         <div id="main" style="width:100%;height:320px;"></div>
    </form>
</body>
</html>
