<%@ Page Language="C#" AutoEventWireup="true" CodeFile="曲线1.aspx.cs" Inherits="echarts_firstPage_曲线1" %>


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

            alert("曲线1："+aa);

            myChart = echarts.init(document.getElementById('main'));


            option = {
                title: {
                    text: "  用户完成仪表曲线",
                    textStyle: {
                        color: "#FFFFFF"
                    },
                    show: true
                },

                tooltip: {
                    trigger: 'axis',
                    axisPointer: {            // 坐标轴指示器，坐标轴触发有效
                        type: 'shadow'        // 默认为直线，可选为：'line' | 'shadow'
                    }
                },
                legend: {
                    textStyle:{
                        color:"#FFFFFF",
                    },
                    data: ['利润', '支出', '收入']
                },
                grid: {
                    left: '3%',
                    right: '4%',
                    bottom: '3%',
                    containLabel: true

                },
                xAxis: [
                    {
                        type: 'value'
                        ,axisLabel: {
                            textStyle: {
                            color: '#FFFFFF'
                            }
                            }
                    }
                ],
                yAxis: [
                    {
                        type: 'category',
                        axisTick: { show: false },                        
                        data: ['周一', '周二', '周三', '周四', '周五', '周六', '周日']
                        ,axisLabel: {
                            textStyle: {
                            color: '#FFFFFF'
                            }
                            }
                    }
                ],
                series: [

                    {
                        name: '利润',
                        type: 'bar',
                        label: {
                            normal: {
                                show: true,
                                position: 'inside'
                            }
                        },
                        itemStyle: {
                            normal: {
                               color: '#e69d87'
                            }
                        },  
                        data: [200, 170, 240, 244, 200, 220, 210]
                    },
                    {
                        name: '收入',
                        type: 'bar',
                        stack: '总量',
                        label: {
                            normal: {
                                show: true
                            }
                        },
                        itemStyle: {
                            normal: {
                                color: '#E87C25'
                            }
                        },  
                        data: [320, 302, 341, 374, 390, 450, 420]
                    },
                    {
                        name: '支出',
                        type: 'bar',
                        stack: '总量',
                        label: {
                            normal: {
                                show: true,
                                position: 'left'
                            }
                        },
                        itemStyle: {
                            normal: {
                                color: '#8dc1a9'
                            }
                        },  
                        data: [-120, -132, -101, -134, -190, -230, -210]
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

