<%@ Page Language="C#" AutoEventWireup="true" CodeFile="告警阈值设置.aspx.cs" Inherits="pages_告警阈值设置" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title>间隔展示</title>
    <link href="../js/layui/css/layui.css" rel="stylesheet" type="text/css" />
    <script src="../js/layer/layer.js" type="text/javascript"></script>
    <script src="../js/layui/layui.js" type="text/javascript"></script>
    <script src="../js/jquery-1.8.3.min.js" type="text/javascript"></script>
    <script>
        var public_token = "<%=public_token %>";
    </script>
    <style>
        #body1 {
           height:900px;
           width:100%;
           background-color:RGB(212,236,234);
        }
        #body2 {
           height:90%;
           width:1200px;
           margin: 0 auto 10px auto; 
           background-color:RGB(212,236,234);
           display:flex;
           flex-direction:row;
           justify-content:space-between;
        }
        .mulu_1 {
           width:33%;
           background-color:#ffffff;
           display:flex;
           flex-direction:column;
           justify-content:space-between;
           border-radius: 10px;
           border:1px #333333 solid;
        } 
        .mulu_1-1 {
           width:33%;          
           display:flex;
           flex-direction:column;
           justify-content:space-between;
        }
        .mulu_1-2 {
           width:390px;  
           height:150px;
           background-color:#ffffff;
           display:flex;
           background-color:#ffffff;
           border-radius: 10px;
           border:1px #333333 solid;
           flex-direction:column;
           
        }
        .row_2 {
           display:flex;
           flex-direction:row;
           flex-wrap:wrap;
        }

        .title {
           border-top-left-radius:10px; 
           border-top-right-radius:10px;	       
           height:30px;
           line-height:30px;
           width:100%;
           background-color:RGB(212,236,234);
           
        }
        
        .boder_1 {
            border:1px #333333 solid;
            width:385px;
            margin-left:5px;
            margin-bottom:10px;
        }
        .guowang {
            
            height:150px;
           
        }
        .guowang_1 {
            height:100px;
        }
       
        .row_1 {
            display:flex;
            flex-direction:row;
            }

    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div id="body1">
            <div id ="body2">
                <%--装置列表--%>
                <div class="mulu_1">
                    <p class="title">&nbsp;&nbsp;装置列表</p>
                    <div>
                        <div >
                            <div class="layui-form-item" >
                                <div class="layui-form-item" style="padding-top: 10px;">

                        
                                    <div class="layui-input-inline" style="margin-left:5px;">
                                        <input type="text" class="layui-input" id="txtPhoneNum" placeholder="点位名称查询" >
                                    </div>
                       
                                    <div class="layui-input-inline" style="width: 80px">
                                        <input type="button" class="layui-btn"  value="查询" onclick="searchDB()">
                                    </div>
                                           

                                </div>
                            </div>
                        </div>
                        
                        <div class="boder_1 guowang">
                            <div style="padding:10px;">

                                <p>国网供电宁波公司</p>
                            </div>
                            
                        </div>
                        <div style="height:60px;margin-left:2px;border-bottom:1px #cccccc solid;width:380px;margin-bottom:10px;padding:10px;">
                            <p>点位：-</p>
                            <p>路径：-</p>
                        </div>
                        <div class="row_1" style="height:30px;margin-left:2px;width:380px;margin-bottom:10px;padding:10px;line-height:30px;">
                            <p>模板：</p>
                            <input type="button" class=""  value="删除"  style="background-color:#ffffff;border:1px #cccccc solid;width:80px;margin-left:5px;margin-left:80px;color:#cccccc;">
                            <input type="button" class=""  value="复制模板" style="background-color:#ffffff;border:1px #cccccc solid;width:80px;margin-left:5px;color:#cccccc;">
                            <input type="button" class=""  value="应用模板" style="background-color:#ffffff;border:1px #cccccc solid;width:80px;margin-left:5px;color:#cccccc;">                          
                        </div>
                        <div class="boder_1 guowang">

                        </div>
                        
                        <div class="row_1" style="height:30px;margin-left:2px;width:380px;margin-bottom:10px;padding:10px;line-height:30px;">
                            <p>量测量：</p>
                            
                            <input type="button" class=""  value="保存" style="background-color:#ffffff;border:1px #cccccc solid;width:40px;margin-left:5px;color:#cccccc;margin-left:230px;">
                            <input type="button" class=""  value="重置" style="background-color:#ffffff;border:1px #cccccc solid;width:40px;margin-left:5px;color:#cccccc;">                          
                        </div>
                        <div class="boder_1 guowang">

                        </div>

                    </div>
                </div>
                <%--表达式--%>
                <div class="mulu_1">
                    <p class="title">&nbsp;&nbsp;表达式</p>
                    <div>
                        <div class="row_1" style="height:25px;margin-left:2px;width:380px;margin-bottom:2px;line-height:20px;">
                            <input type="button" class=""  value="保存" style="background-color:#ffffff;border:1px #cccccc solid;width:40px;margin-left:5px;color:#cccccc;">
                            <input type="button" class=""  value="暂存" style="background-color:#ffffff;border:1px #cccccc solid;width:40px;margin-left:5px;color:#cccccc;">
                            <input type="button" class=""  value="验证" style="background-color:#ffffff;border:1px #cccccc solid;width:40px;margin-left:5px;color:#cccccc;">
                            <input type="button" class=""  value="清除" style="background-color:#ffffff;border:1px #cccccc solid;width:40px;margin-left:5px;color:#cccccc;">     
                        </div>

                        <div class="row_1" style="height:25px;margin-left:2px;width:380px;margin-bottom:2px;line-height:20px;">
                            <input type="button" class=""  value="预警" style="background-color:#eeeeee;border:1px #cccccc solid;width:95px;margin-left:5px;color:#333333;">
                            <input type="button" class=""  value="一般告警" style="background-color:#eeeeee;border:1px #cccccc solid;width:95px;margin-left:5px;color:#333333;">
                            <input type="button" class=""  value="严重告警" style="background-color:#eeeeee;border:1px #cccccc solid;width:95px;margin-left:5px;color:#333333;">
                            <input type="button" class=""  value="危急告警" style="background-color:#eeeeee;border:1px #cccccc solid;width:95px;margin-left:5px;color:#333333;">     
                        </div>
                        <div class="boder_1 guowang">

                        </div>
                        <div class="row_1" style="height:25px;margin-left:2px;width:380px;margin-bottom:2px;line-height:20px;">
                            <p>预警：</p>                           
                        </div>
                        <div class="boder_1 guowang_1">

                        </div>
                        <div class="row_1" style="height:25px;margin-left:2px;width:380px;margin-bottom:2px;line-height:20px;">
                            <p>一般告警：</p>                           
                        </div>
                        <div class="boder_1 guowang_1">

                        </div>
                        <div class="row_1" style="height:25px;margin-left:2px;width:380px;margin-bottom:2px;line-height:20px;">
                            <p>严重告警：</p>                           
                        </div>
                        <div class="boder_1 guowang_1">

                        </div>
                        <div class="row_1" style="height:25px;margin-left:2px;width:380px;margin-bottom:2px;line-height:20px;">
                            <p>危急告警：</p>                           
                        </div>
                        <div class="boder_1 guowang_1">

                        </div>
                    </div>
                </div>
                <%--运算符--%>
                <div class="mulu_1-1 ">
                    <div class="mulu_1-2 ">
                        <p class="title">&nbsp;&nbsp;运算符</p>
                        <div class="row_2">
                            <div style="width:300px;padding-top:4px;">
                                <input type="button" class=""  value="加" style="background-color:#ffffff;border:1px #bbbbbb solid;width:40px;margin-left:5px;color:#bbbbbb;height:23px;">
                                <input type="button" class=""  value="等于" style="background-color:#ffffff;border:1px #bbbbbb solid;width:60px;margin-left:5px;color:#bbbbbb;height:23px;">
                                <input type="button" class=""  value="不等于" style="background-color:#ffffff;border:1px #bbbbbb solid;width:80px;margin-left:5px;color:#bbbbbb;height:23px;">
                            </div>
                            <div style="width:300px;padding-top:4px;">
                                <input type="button" class=""  value="减" style="background-color:#ffffff;border:1px #bbbbbb solid;width:40px;margin-left:5px;color:#bbbbbb;height:23px;">
                                <input type="button" class=""  value="大于" style="background-color:#ffffff;border:1px #bbbbbb solid;width:60px;margin-left:5px;color:#bbbbbb;height:23px;">
                                <input type="button" class=""  value="大于等于" style="background-color:#ffffff;border:1px #bbbbbb solid;width:80px;margin-left:5px;color:#bbbbbb;height:23px;">
                            </div>
                            <div style="width:300px;padding-top:4px;">
                                <input type="button" class=""  value="乘" style="background-color:#ffffff;border:1px #bbbbbb solid;width:40px;margin-left:5px;color:#bbbbbb;height:23px;">
                                <input type="button" class=""  value="小于" style="background-color:#ffffff;border:1px #bbbbbb solid;width:60px;margin-left:5px;color:#bbbbbb;height:23px;">
                                <input type="button" class=""  value="小于等于" style="background-color:#ffffff;border:1px #bbbbbb solid;width:80px;margin-left:5px;color:#bbbbbb;height:23px;">
                            </div>
                            <div style="width:300px;padding-top:4px;">
                                <input type="button" class=""  value="除" style="background-color:#ffffff;border:1px #bbbbbb solid;width:40px;margin-left:5px;color:#bbbbbb;height:23px;">
                                <input type="button" class=""  value="括号" style="background-color:#ffffff;border:1px #bbbbbb solid;width:60px;margin-left:5px;color:#bbbbbb;height:23px;">
                                <input type="button" class=""  value="中括号" style="background-color:#ffffff;border:1px #bbbbbb solid;width:80px;margin-left:5px;color:#bbbbbb;height:23px;">
                            </div>                     
                        </div>
                    </div>
                    <div class="mulu_1-2 ">
                        <p class="title">&nbsp;&nbsp;逻辑运算符</p>
                        <div class="row_2">
                            <div style="width:300px;padding-top:6px;">
                                <input type="button" class=""  value="且" style="background-color:#ffffff;border:1px #bbbbbb solid;width:40px;margin-left:5px;color:#bbbbbb;height:23px;">
                                <input type="button" class=""  value="或" style="background-color:#ffffff;border:1px #bbbbbb solid;width:60px;margin-left:5px;color:#bbbbbb;height:23px;">                           
                            </div>
                            <div style="width:300px;padding-top:6px;">
                                <input type="button" class=""  value="包含" style="background-color:#ffffff;border:1px #bbbbbb solid;width:40px;margin-left:5px;color:#bbbbbb;height:23px;">
                                <input type="button" class=""  value="不包含" style="background-color:#ffffff;border:1px #bbbbbb solid;width:60px;margin-left:5px;color:#bbbbbb;height:23px;">                           
                            </div>
                            <div style="width:300px;padding-top:6px;">
                                <input type="button" class=""  value="在区间" style="background-color:#ffffff;border:1px #bbbbbb solid;width:60px;margin-left:5px;color:#bbbbbb;height:23px;">
                                <input type="button" class=""  value="不在区间" style="background-color:#ffffff;border:1px #bbbbbb solid;width:80px;margin-left:5px;color:#bbbbbb;height:23px;">                           
                            </div>

                        </div>
                    </div>
                    <div class="mulu_1-2 ">
                        <p class="title">&nbsp;&nbsp;元素</p>
                        <div class="row_2">
                            <div style="width:300px;padding-top:2px;">         
                                <input type="button" class=""  value="变化量" style="background-color:#ffffff;border:1px #bbbbbb solid;width:60px;margin-left:5px;color:#bbbbbb;height:20px;">
                                <input type="button" class=""  value="当前值" style="background-color:#ffffff;border:1px #bbbbbb solid;width:60px;margin-left:5px;color:#bbbbbb;height:20px;">                                
                            </div>
                            <div style="width:300px;padding-top:2px;">         
                                <input type="button" class=""  value="定值" style="background-color:#ffffff;border:1px #bbbbbb solid;width:60px;margin-left:5px;color:#bbbbbb;height:20px;">
                                <input type="button" class=""  value="初值" style="background-color:#ffffff;border:1px #bbbbbb solid;width:60px;margin-left:5px;color:#bbbbbb;height:20px;">                                
                            </div>
                            <div style="width:300px;padding-top:2px;">         
                                <input type="button" class=""  value="初始差绝对值" style="background-color:#ffffff;border:1px #bbbbbb solid;width:130px;margin-left:5px;color:#bbbbbb;height:20px;">                                
                            </div>
                            <div style="width:300px;padding-top:2px;">         
                                <input type="button" class=""  value="初始差" style="background-color:#ffffff;border:1px #bbbbbb solid;width:60px;margin-left:5px;color:#bbbbbb;height:20px;">
                                <input type="button" class=""  value="时间温差" style="background-color:#ffffff;border:1px #bbbbbb solid;width:60px;margin-left:5px;color:#bbbbbb;height:20px;">                                
                            </div>
                            <div style="width:300px;padding-top:2px;">         
                                <input type="button" class=""  value="变化率" style="background-color:#ffffff;border:1px #bbbbbb solid;width:60px;margin-left:5px;color:#bbbbbb;height:20px;">
                                                               
                            </div>
                            
                        </div>
                    </div>

                    <div class="mulu_1-2 ">
                        <p class="title">&nbsp;&nbsp;函数方法</p>
                        <div class="row_2">
                            <div style="width:300px;padding-top:5px;">         
                                <input type="button" class=""  value="绝对值" style="background-color:#ffffff;border:1px #bbbbbb solid;width:60px;margin-left:5px;color:#bbbbbb;height:20px;">                                
                            </div>
                        </div>
                    </div>

                    <div class="mulu_1-2 ">
                        <p class="title">&nbsp;&nbsp;图例</p>
                        <div class="row_2">
                            <div class="row_2">
                                <div style="width:300px;padding-top:10px;">         
                                   <p> &nbsp; &nbsp; &nbsp;系统默认模板</p>                            
                                </div>
                            </div>
                            <div class="row_2">
                                <div style="width:300px;padding-top:10px;">         
                                    <p>&nbsp; &nbsp; &nbsp;装置应用模板</p>                            
                                </div>
                            </div>
                            <div class="row_2">
                                <div style="width:300px;padding-top:10px;">         
                                    <p>&nbsp; &nbsp; &nbsp;参数已编辑表达式</p>                            
                                </div>
                            </div>
                            <div class="row_2">
                                <div style="width:300px;padding-top:10px;">         
                                    <p>&nbsp; &nbsp; &nbsp;未保存的表达式</p>                            
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </form>
</body>
</html>
