<%@ Page Language="C#" AutoEventWireup="true" CodeFile="饼状图2.aspx.cs" Inherits="echarts_firstPage_饼状图2" %>


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
                    text: '最近报警比例图',
                     textStyle: {
                        color: "#FFFFFF"
                    }
                },
                tooltip: {
                    trigger: 'item',
                    formatter: "{a} <br/>{b} : {c}个",
                    y:"bottom"
                },
                toolbox: {
                    feature: {
                        dataView: { readOnly: false },
                        restore: {},
                        saveAsImage: {}
                    }
                },
                legend: {
                    textStyle:{
                        color:"#FFFFFF",
                    },
                    y:"bottom",
                    data: ['温差过大', '压力过大', '阀无压力', '其他']
                },
                calculable: true,
                series: [
                    {
                        name: '漏斗图',
                        type: 'funnel',
                        left: '10%',
                        top: 60,
                        //x2: 80,
                        bottom: 60,
                        width: '80%',
                        // height: {totalHeight} - y - y2,
                        min: 0,
                        max: 100,
                        minSize: '0%',
                        maxSize: '100%',
                        sort: 'descending',
                        gap: 2,
                        label: {
                            normal: {
                                show: true,
                                position: 'inside'
                            },
                            emphasis: {
                                textStyle: {
                                    fontSize: 20
                                }
                            }
                        },
                        labelLine: {
                            normal: {
                                length: 10,
                                lineStyle: {
                                    width: 1,
                                    type: 'solid'
                                }
                            }
                        },
                        itemStyle: {
                            normal: {
                                //好，这里就是重头戏了，定义一个list，然后根据所以取得不同的值，这样就实现了，
                                color: function (params) {
                                    // build a color map as your need.
                                    var colorList = [
                             '#e69d87', '#759aa0', '#8dc1a9', '#E87C25', '#c33733',
                               '#91c7ae', '#9BCA63', '#FAD860', '#F3A43B', '#60C0DD',
                               '#D7504B', '#C6E579', '#F4E001', '#F0805A', '#26C0C0'
                            ];
                                    return colorList[params.dataIndex]
                                }
                            }
                        },
                        data: [
                            { value: 60, name: '阀无压力' },
                            { value: 20, name: '其他' },
                            { value: 80, name: '压力过大' },
                            { value: 100, name: '温差过大' }
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

