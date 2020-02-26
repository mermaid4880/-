<%@ Page Language="C#" AutoEventWireup="true" CodeFile="状态显示.aspx.cs" Inherits="pages_状态显示" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <link href="../js/layui/css/layui.css" rel="stylesheet" type="text/css" />
    <script src="../js/layui/layui.js" type="text/javascript"></script>

    <script src="../lib/jquery/jquery-1.8.3.min.js" type="text/javascript"></script>

    <style>
        #title p,.content_1{
          width:50%;         
          display:flex;
                
          border-right:2px #cccccc solid;
        }
        #title,#content {
          display:flex;
          flex-direction:row;
        }
        #title p {
          height:40px;
          background-color:#0099Af;
          font-size:26px;
          flex-direction:row;
          justify-content:center;
          align-items:center;  
        }
        .title_min {
          width:100%;
          display:flex;
          flex-direction:row;
          justify-content:center;
          align-items:center;  
          color:red;
          font-size:20px;
          height:40px;
        }
        .content_1 {
          flex-direction:column;
          justify-content:flex-start;
          align-items:center; 
        }
        .content_2 {
         width: 800px;
         
         border: 2px 	#77FFEE solid;
         color: #009FCC;
         font-size:20px;

        }
        .yunxinzhuangtai ,.tongxinzhuangtai,dianchizhuangtai,.jiqirenzisheng,.huanjingzhuangtai，{
            display:flex;
            flex-direction:row;
            justify-content:flex-start;
            align-items:center;
            flex-wrap:wrap;
            padding:10px 0 10px 0; 
        }
        .yunxinzhuangtai p {
            width:300px;
            height: 35px;
            
            margin-left:80px;
         }
        .tongxinzhuangtai p {
            width:220px;
            height: 35px;
            margin-left:40px;
        }
        .dianchizhuangtai p {
            width:220px;
            height: 50px;
            margin-left:80px;
            margin-top:15px;
        }
        
        .dianchizhuangtai img {
            width:80px;
            height:30px;
            
        }
        .jiqirenzisheng p{
            width:300px;
            height: 30px;
            
            margin-left:80px;
        }
        .jiqirenzisheng {
          border-bottom:2px 	#77FFEE  dashed;
        }
        .noneBot {
         border-bottom:none;
        }
        .huanjingzhuangtai p {
            width: 700px;
            height: 30px;
            margin-left:80px;
        }
        .kongzhizhuangtai {
            display:flex;
            flex-direction:row;
            justify-content:flex-start;
            align-items:center;
            flex-wrap:wrap;
            padding:23px 0 30px 0; 
        }
        .kongzhizhuangtai p {
            width: 400px;
            height: 80px;
            margin-left:80px;
            display:flex;
            flex-direction:row;
            justify-content:space-between;
            align-items:center;
        }
        .kongzhizhuangtai p span {
            font-size:14px;
            color:#cccccc;

            }
        .l-bar-selectpagesize{
            display:none !important;
        }
    </style>

    <script>
        
        layui.use(['form', 'layedit', 'laydate'], function () {
            var form = layui.form
                , layer = layui.layer
                , layedit = layui.layedit
                , laydate = layui.laydate;
        });

        $(function () {
            $(".kongzhizhuangtai img").click(function () {
                var alt = $(this).attr("alt");
                var src = $(this).attr("src");
                
                if (src.indexOf("off") != -1) {
                    //现在是关闭状态
                    $(this).attr("src", "../images/open.png");
                    layer.msg(alt+"  开");
                } else {
                    $(this).attr("src", "../images/off.png");
                    layer.msg(alt+"  关");
                }
            });

        });

    </script>
</head>
<body>
    <form id="form1" runat="server">
        <div id="title">
            <p>机器人状态</p>
            <p>机器人控制</p>
        </div>
        <div id="content">
            <div class="content_1">
                <div>
                    <p class="title_min">运行状态信息</p>
                    <div class="content_2 yunxinzhuangtai">
                        <p>机身温度：<span>36C</span></p>
                        <p>云台水平位置：<span>0.2</span></p>
                        <p>运行速度：<span>1.0m/s</span></p>
                        <p>云台垂直位置：<span>-2.8</span></p>
                        <p>相机倍数：<span>23</span></p>

                    </div>
                </div>
                <div>
                    <p class="title_min">通信状态信息</p>
                    <div class="content_2 tongxinzhuangtai">
                        <p>无线基站：<span><img src="../images/xhm.png" alt=""/></span></p>
                        <p>控制系统：<span><img src="../images/xhm.png" alt=""/></span></p>
                        <p>可见光摄像：<span><img src="../images/xhm.png" alt=""/></span></p>
                        <p>充电系统：<span><img src="../images/xhm.png" alt=""/></span></p>
                        <p>红外摄像：<span><img src="../images/xhm.png" alt=""/></span></p>
                    </div>
                </div>
                <div>
                    <p class="title_min">电池状态信息</p>
                    <div class="content_2 dianchizhuangtai" >
                        <p>当前电池电量：<span><img src="../images/dll.png" alt=""/></span></p>
                    </div>
                </div>
                <div>
                    <p class="title_min">机器人自身模块信息</p>
                    <div class="content_2">
                        <div>
                            <p class="title_min">驱动模块</p>
                            <div class="jiqirenzisheng">
                                <p>左轮：<span>1.0m/s</span></p>
                                <p>右轮：<span>1.0m/s</span></p>
                            </div>
                        </div>
                        <div>
                            <p class="title_min">电源模块</p>
                            <div class="jiqirenzisheng">
                                <p>外供电源：<span>1.51A 26.7V</span></p>
                                <p>充电状态：<span><img src="../images/dlcd.png" alt=""/></span></p>
                                <p>充电幅度：<span>29.80V</span></p>
                            </div>
                        </div>
                        <div>
                            <p class="title_min">系统模块</p>
                            <div class="jiqirenzisheng noneBot">
                                <p>运行里程：<span>60公里</span></p>
                                <p>运行时间：<span>50小时</span></p>
                                <p>巡检设备数量：<span>200个</span></p>
                                <p>发现曲线数量：<span>34个</span></p>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            
            <div class="content_1">
                <div>
                    <p class="title_min">环境状态信息</p>
                    <div class="content_2 huanjingzhuangtai">
                        <p>温度（℃）：<span>15</span></p>
                        <p>湿度（%RH）：<span>0.2</span></p>
                        <p>风速（M/S）：<span>4</span></p>
                    </div>
                </div>
                <div>
                    <p class="title_min">控制状态信息</p>
                    <div class="content_2 kongzhizhuangtai">
                        <p>红外功能：<span>开&nbsp;<img src="../images/off.png" alt="红外功能"/>&nbsp;关</span></p>
                        <p>可见光功能：<span>开&nbsp;<img src="../images/open.png" alt="可见光功能"/>&nbsp;关</span></p>
                        <p>雨刷状态：<span>开&nbsp;<img src="../images/open.png" alt="雨刷状态"/>&nbsp;关</span></p>
                        <p>避障功能：<span>开&nbsp;<img src="../images/open.png" alt="避障功能"/>&nbsp;关</span></p>
                        <p>车灯状态：<span>开&nbsp;<img src="../images/open.png" alt="车灯状态"/>&nbsp;关</span></p>
                        <p>充电房：<span>开&nbsp;<img src="../images/open.png" alt="充电房"/>&nbsp;关</span></p>
                        <p>机器人状态：<span>开&nbsp;<img src="../images/open.png" alt="机器人状态"/>&nbsp;关</span></p>
                    </div>
                </div>
            </div>
        </div>
        
          
          
    </form>
</body>
</html>
