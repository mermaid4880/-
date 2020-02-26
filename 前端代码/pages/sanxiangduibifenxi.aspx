<%@ Page Language="C#" AutoEventWireup="true" CodeFile="sanxiangduibifenxi.aspx.cs" Inherits="pages_sanxiangduibifenxi" %>


<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title>三相对比分析</title>
    <link href="../lib/ligerUI/skins/Aqua/css/ligerui-all.css" rel="stylesheet" type="text/css" />
    <link href="../lib/ligerUI/skins/Gray2014/css/all.css" rel="stylesheet" type="text/css" />
    <script src="../js/jquery-1.8.3.min.js" type="text/javascript"></script>
    <script src="../lib/ligerUI/js/core/base.js" type="text/javascript"></script>

    <link href="../js/layui/css/layui.css" rel="stylesheet" type="text/css" />
    <script src="../js/layer/layer.js" type="text/javascript"></script>

    <script src="../lib/ligerUI/js/plugins/ligerLayout.js" type="text/javascript"></script>
    <script src="../lib/ligerUI/js/plugins/ligerGrid.js" type="text/javascript"></script>
    <script src="../lib/ligerUI/js/ligerui.min.js"></script>
    <script src="../js/layui/layui.all.js"></script>
    <script src="../js/echarts.min.js"></script>
    <style type="text/css">
        body {
            padding: 10px;
            margin: 0;
        }

        #layout1 {
            width: 100%;
            margin: 40px;
            height: 400px;
            margin: 0;
            padding: 0;
        }

        #accordion1 {
            height: 270px;
        }

        h4 {
            margin: 20px;
        }

        #divHead p {
            height: 30px;
        }
    </style>

    <script type="text/javascript">
        var taskType = "qmxj";
        var public_token = "<%=public_token %>";
        var grid = null;
        var bodyHeight = document.documentElement.clientHeight; //页面高度
        $(function () {

            $("#layout1").ligerLayout({ leftWidth: 300, topHeight: 0, rightWidth: 800 });


            //装载树结构
            $("#ftree").attr("src", "../tree/allTree.aspx");
            //这里装载grid

            grid = $("#maingrid").ligerGrid({
                columns: [
                    { display: '识别时间', name: 'a', align: 'left', width: 150 },
                    { display: '点位名称', name: 'b', width: 150 },
                    { display: '识别结果', name: 'c', width: 150, align: 'left' }
                    , { display: '采集信息', name: 'd', width: 150, align: 'left' }

                ]
                , pageSize: 30
                , width: '100%'
                , height: bodyHeight - 500
                ,
                onSelectRow: function (rowdata, rowindex, rowDomElement) {

                    var selected = grid.getSelected();
                    //
                    //接口获取数据
                    //渲染页面
                    $(`<div style="width:200px;height:200px;border:1px solid #ccc;float:left;"><img src=""/></div>`
                        + `<div style="width:200px;height:200px;border:1px solid #ccc;float:left;"><img src=""/></div>`
                        + `<div style="width:250px;height:250px;float:left;line-height:250px;padding-top:70px;">`
                        + `<audio id="detail-audio" src="http://www.w3school.com.cn/i/horse.ogg" controls="controls"></audio></div>` + `<div style="width:200px;height:200px;border:1px solid #ccc;float:left;"><img src=""/></div>`
                        + `<div style="width:200px;height:200px;border:1px solid #ccc;float:left;"><img src=""/></div>`
                        + `<div style="width:250px;height:250px;float:left;line-height:250px;padding-top:70px;">`
                        + `<audio id="detail-audio" src="http://www.w3school.com.cn/i/horse.ogg" controls="controls"></audio></div>` + `<div style="width:200px;height:200px;border:1px solid #ccc;float:left;"><img src=""/></div>`
                        + `<div style="width:200px;height:200px;border:1px solid #ccc;float:left;"><img src=""/></div>`
                        + `<div style="width:250px;height:250px;float:left;line-height:250px;padding-top:70px;">`
                        + `<audio id="detail-audio" src="http://www.w3school.com.cn/i/horse.ogg" controls="controls"></audio></div>`).appendTo($("#detailview").empty());
                    //渲染图表
                }
            });





        });




        //这里是筛选方法
        function oncheckselected(thisv) {

            var boolv = thisv.prop("checked");
            var vTreeObject = ftree.contentWindow.zTreeObj;
            var node = vTreeObject.getNodeByParam("name", thisv.attr("data"), null);
            boolv ? vTreeObject.checkNode(node, true, true) : vTreeObject.checkNode(node, false, true);


        }

        var DB_DATA = {};

        function searchDB() {
            DB_DATA = {};
            var vList = f_getCheckedNodes("N");
            console.log(vList);
            //暂时用这个 正式替换为 下面注释掉的ajax getTaskTempletList
            //$.ajax({
            //    type: "get",
            //    url: "../handler/InterFace.ashx",
            //    data: {
            //        method: "getTaskTempletList"

            //       , token: public_token
            //        , taskType: taskType
            //    },
            //    dataType: "json",
            //    success: function (data) {
            //DB_DATA = data;
            //        grid.set({ data: DB_DATA });

            //    }
            //});
            var data = {
                "Total": 5,
                "Rows": [{ "c": "无", "b": "点位名称234234", "a": "2018-10-20 20:21:10" },
                    { "c": "无", "b": "点位名称34535", "a": "2018-10-20 21:21:10" },
                    { "c": "无", "b": "点位名称456456", "a": "2018-10-20 22:21:10" },
                    { "c": "无", "b": "点位名称456456", "a": "2018-10-20 23:21:10" },
                    { "c": "无", "b": "点位名称456456", "a": "2018-10-20 23:21:10" }
                ]
            }
            DB_DATA = data;
            grid.set({ data: DB_DATA });




        }


        function resetDB() {
            window.location.reload();
        }

        function f_getCheckedNodes(level) {
            var nodes = ftree.contentWindow.zTreeObj.getCheckedNodes();
            var names = "";
            var count = 0;
            for (var i = 0; i < nodes.length; i++) { node = nodes[i]; if (node.no.substring(0, 1) == level && !node.getCheckStatus().half) { names += node.no + ","; count += 1; } }
            if (count > 0) { names = names.substr(0, names.length - 1); }
            return names;
        }


    </script>

</head>
<body>
    <form id="form1" runat="server">
        <div id="layout1">
            <div position="left" title="点位树" style="padding-left: 10px; height: 100%;">
                <iframe id="ftree" frameborder="0" height="100%" width="100%" src="kong.htm"></iframe>
            </div>



            <div position="center" title="任务编辑列表">

                <div class="layui-form" style="padding-top: 8px;">

                    <div class="layui-form-item">

                        <div class="layui-inline" style="float: left;">
                            <label class="layui-form-label" style="height: 30px; line-height: 30px; padding: 0px;">开始时间：</label>
                            <div class="layui-input-inline">
                                <input style="height: 30px; line-height: 30px;" type="text" class="layui-input" id="time1" placeholder="yyyy-MM-dd HH:mm:ss">
                            </div>
                        </div>

                        <div class="layui-inline" style="float: left;">
                            <label class="layui-form-label" style="height: 30px; line-height: 30px; padding: 0px;">结束时间：</label>
                            <div class="layui-input-inline">
                                <input style="height: 30px; line-height: 30px;" type="text" class="layui-input" id="time2" placeholder="yyyy-MM-dd HH:mm:ss">
                            </div>
                        </div>

                        <div class="layui-input-inline" style="width: 80px">
                            <input type="button" class="layui-btn layui-btn-sm layui-btn-primary" style="height: 30px; line-height: 30px;" value="查询" onclick="searchDB()"></input>
                        </div>

                    </div>
                </div>

                <div id="maingrid" style="margin: 0; padding: 0"></div>

                <div id="main" style="width: 600px; height: 400px;"></div>
            </div>
            <div position="right" title="" id="detailview" style="padding-left: 10px">
            </div>
        </div>

    </form>
    <script>
        layui.use('laydate', function () {
            var laydate = layui.laydate;

            laydate.render({
                elem: '#time1',
                type: 'datetime'
            });
            laydate.render({
                elem: '#time2',
                type: 'datetime'
            });
        })

        // 基于准备好的dom，初始化echarts实例
        var myChart = echarts.init(document.getElementById('main'));

        // 指定图表的配置项和数据
        var option = {
            title: {
                text: ''
            },
            tooltip: {
                trigger: 'axis'
            },
            legend: {
                data: ['巡检数据']
            },
            grid: {
                left: '3%',
                right: '10%',
                bottom: '3%',
                containLabel: true
            },
            toolbox: {
                feature: {

                }
            },
            xAxis: {
                type: 'category',
                boundaryGap: false,
                data: ['2018-10-01', '2018-10-02', '2018-10-03', '2018-10-04', '2018-10-05', '2018-10-06', '2018-10-07']
            },
            yAxis: {
                type: 'value'
            },
            series: [
                {
                    name: 'A',
                    type: 'line',
                    stack: '总量',
                    data: [120, 132, 101, 134, 90, 230, 210]
                },
        {
            name: 'B',
            type: 'line',
            stack: '总量',
            data: [220, 182, 191, 234, 290, 330, 310]
        },
                {
                    name: 'C',
                    type: 'line',
                    stack: '总量',
                    data: [820, 932, 901, 934, 1290, 1330, 1320]
                }
            ]
        };

        // 使用刚指定的配置项和数据显示图表。
        myChart.setOption(option);
    </script>



</body>
</html>
