<%@ Page Language="C#" AutoEventWireup="true" CodeFile="orderDetail.aspx.cs" Inherits="aboutOrder_orderDetail" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">

    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1">
    <title>抄表系统登录</title>
    <link rel="stylesheet" href="../plugins/layui/css/layui.css" media="all">
    <link rel="stylesheet" type="text/css" href="http://www.jq22.com/jquery/font-awesome.4.6.0.css">
    
    <link rel="stylesheet" href="../build/css/app.css" media="all">

    <script src="../plugins/layui/layui.js" type="text/javascript"></script>
    <script src="../js/jquery-1.5.2.min.js" type="text/javascript"></script>
    <script src="../js/basicJs.js" type="text/javascript"></script>


    <script>

        var table, laydate, layer;
        var si;
        var vCommandNum = "<%=commandNum %>";
        var vOrderClass = "<%=orderClass %>";

        $(function () {


            layui.use(['table', 'laydate'], function () {
                table = layui.table;
                laydate = layui.laydate;
                layer = layui.layer;

                //加载表格
                loadTable();
            });

            f_runCommand(vCommandNum, 2);
        });

        function loadTable() {

            if (vOrderClass == "1") {
                f_init();
            }
            else {
                command_init();
            }
        }
        
        function f_init() {

            table.render({
                id: 'idTest'
                    , elem: '#idTest'
                    , height: '500'
                    , url: '../handler/Grid.ashx?methodType=V&view=vw_Server_Manual_F_info&sortName=center_id,mpid' //数据接口
                    , cellMinWidth: 100
                    , cols: [[
                      { checkbox: true }

                      , { field: 'op_result', title: '处理结果', sort: true, width: 100, align: 'center' }
                      , { field: 'return_dt', title: '返回时间', sort: true, width: 180, align: 'center' }

                      , { field: 'F_no', title: '阀号', sort: true, width: 120, align: 'center' }
                      , { field: 'Mpid', title: '计量点', sort: true, width: 100, align: 'center' }
                      , { field: 'txztName', title: '通讯状态', sort: true, width: 100, align: 'center' }
                      , { field: 'Jswd', title: '进水温度', sort: true, width: 100, align: 'center' }
                      , { field: 'Hswd', title: '回水温度', sort: true, width: 100, align: 'center' }
                      , { field: 'Jhswc', title: '温度差', sort: true, width: 100, align: 'center' }
                      , { field: 'F_kd', title: '阀开度', sort: true, width: 100, align: 'center' }
                      , { field: 'f_module_orderName', title: '阀模式', sort: true, width: 100, align: 'center' }
                      , { field: 'F_canshu', title: '目标值', sort: true, width: 100, align: 'center' }
                      , { field: 'PIDP', title: 'PIDP', sort: true, width: 100, align: 'center' }
                      , { field: 'PIDI', title: 'PIDI', sort: true, width: 120, align: 'center' }
                      , { field: 'PIDD', title: 'PIDD', sort: true, width: 100, align: 'center' }
                      , { field: 'PIDT', title: 'PIDT', sort: true, width: 100, align: 'center' }
                      , { field: 'F_min_kd', title: '最小阀开度', sort: true, width: 120, align: 'center' }
                      , { field: 'F_max_kd', title: '最大阀开度', sort: true, width: 120, align: 'center' }
                      , { field: 'F_siqu', title: '滞死区', sort: true, width: 100, align: 'center' }

                    ]]
                    , page: true //开启分页
                    , done: function (res, curr, count) {
                        console.log(res);
                        //得到当前页码
                        console.log(curr);
                        //得到数据总量
                        console.log(count);
                    }
                    , where: {
                        commandNum: vCommandNum
                    }
                     , page: {
                         curr: 1 //重新从第 1 页开始
                     }

                 });

        }

        //命令表init
        function command_init() {

            table.render({
                id: 'idTest'
                    , elem: '#idTest'
                    , height: '500'
                    , url: '../handler/Grid.ashx?methodType=V&view=server_clientCommand&sortName=op_dt' //数据接口
                    , cellMinWidth: 100
                    , cols: [[
                      { checkbox: true }

                      , { field: 'op_man', title: '创建人', sort: true, width: 180, align: 'center' }
                      , { field: 'op_dt', title: '创建时间', sort: true, width: 180, align: 'center' }
                      , { field: 'device_no', title: '采集器号', sort: true, width: 180, align: 'center' }
                      , { field: 'pro_st', title: '命令号', sort: true, width: 180, align: 'center' }
                      , { field: 'set_content', title: '命令内容', sort: true, width: 180, align: 'center' }
                      , { field: 'op_result', title: '处理结果', sort: true, width: 120, align: 'center' }
                      , { field: 'return_dt', title: '返回时间', sort: true, width: 120, align: 'center' }
                      , { field: 'isRead', title: '是否读取', sort: true, width: 120, align: 'center' }
                     
                    ]]
                    , page: true //开启分页
                    , done: function (res, curr, count) {
                        console.log(res);
                        //得到当前页码
                        console.log(curr);
                        //得到数据总量
                        console.log(count);
                    }
                    , where: {
                        commandNum: vCommandNum
                    }
                     , page: {
                         curr: 1 //重新从第 1 页开始
                     }

            });

             }


        function search_Meter_Info() {
            table.reload('idTest', {
                where: {
                    commandNum: vCommandNum
                }
                , page: {
                    curr: 1 //重新从第 1 页开始
                }

            });    
        }



        function f_runCommand(postResult, vType) {

            layui.use('layer', function () {
                var layer = layui.layer;

                //这里开始显示进度条
                layer.open({
                    type: 1,
                    area: ['400px', '200px'],
                    content: $('#detail'),
                    cancel: function (index, layero) {
                        clearInterval(si);
                        //关闭进度条
                        layer.closeAll(index);
                        $("#detail").css("display", "none");
                        vTongXun = false;
                    }


                });

            });    


            
             document.getElementById("spanProgressText").innerHTML = "正在准备，请稍等……";

             vTongXun = true;
             $.post('set_f_order.ashx?method=getCommandAllCount&type=' + vType + '&commandNum=' + postResult, function (allCountResult) {
                 var iAllcount = parseInt(allCountResult);
                 if (iAllcount > 0) {
                     var vAllTime = 20 * iAllcount; //就是最多等待 每个操作等待10秒如果超过这个时间就认为失败
                     //这里每三秒读取一下已经获取的热表数量
                     //$.ligerDialog.warn('需要读取热表总数量：'+allCountResult)  ;
                     //每3秒扫描一下数据库
                     var vLastReadCount = 0; //记录上次已读表的次数

                     var vUsedSeconds = 0; //已经用过的时间
                     si = window.setInterval(function () {


                         $.post('set_f_order.ashx?method=getHasReadCommandCount&type=' + vType + '&commandNum=' + postResult, function (ReadCountResult) {

                             var iReadCountResult = parseInt(ReadCountResult);
                             //$.ligerDialog.warn('已读取热表数量：'+ReadCountResult)  ;

                             var vWith = parseFloat(iReadCountResult) * 280 / allCountResult;
                             var imgid = document.getElementById("imgProgress");
                             imgid.style.width = vWith + "px";
                             document.getElementById("spanProgressText").innerHTML = "正在操作(已用" + vUsedSeconds + "秒)！已操作数:" + iReadCountResult + "/总数:" + allCountResult;
                             if (iReadCountResult > vLastReadCount) {
                                 search_Meter_Info();
                                 vLastReadCount = iReadCountResult;
                             }

                             if (iReadCountResult >= iAllcount) {
                                 clearInterval(si);
                                 //关闭进度条
                                 layer.closeAll();
                                 $("#detail").css("display", "none");
                                 vTongXun = false;

                             }
                             else {
                                 if (vUsedSeconds >= vAllTime) {
                                     clearInterval(si);
                                     //关闭进度条
                                     layer.closeAll();
                                     $("#detail").css("display", "none");
                                     vTongXun = false;
                                     search_Meter_Info();
                                 }
                             }


                         });
                         vUsedSeconds = vUsedSeconds + 2; //这里每次都加2
                     }, 2000);
                 }
                 else {
                     alert('硬件总数量为0个');
                     //关闭进度条
                     layer.closeAll('loading'); //关闭加载层
                     vTongXun = false;
                 }
             });

         }

    </script>
</head>
<body>
    <form id="form1" runat="server">
     
     <div class="layui-btn-group">
        
            <div class="layui-btn layui-btn-sm" onclick="loadTable()"> <i class="layui-icon">&#xe640;</i>查询</div> |

          <div class="layui-btn layui-btn-sm" id="divExport"> <i class="layui-icon">&#xe640;</i>导出</div> |
          <div class="layui-btn layui-btn-warm" id="divImport"  > <i class="layui-icon">&#xe640;</i>数据入库</div>
        </div>

     <div>
        <table class="layui-table" id="idTest"  lay-data="{id: 'idTest'}" ></table>
     </div>
    </form>


     <div id="detail" style="display: none;text-align:center;margin:auto 0">
            <br />
            <div style="background-image:url(progress/imgProgress.png);background-repeat:repeat-x;height:9px;width:0px" id="imgProgress"></div>
            <br />
            <span id="spanProgressText" >硬件正在准备，请稍等……</span>
     </div>

</body>
</html>
