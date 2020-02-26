<%@ Page Language="C#" AutoEventWireup="true" CodeFile="机器人设置.aspx.cs" Inherits="pages_机器人设置" %>


<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title>机器人设置</title>
    <link href="../lib/ligerUI/skins/Aqua/css/ligerui-all.css" rel="stylesheet" type="text/css" />
    <link href="../lib/ligerUI/skins/Gray2014/css/all.css" rel="stylesheet" type="text/css" />
    <script src="../js/jquery-1.8.3.min.js" type="text/javascript"></script>
    <script src="../lib/ligerUI/js/core/base.js" type="text/javascript"></script>

    <link href="../js/layui/css/layui.css" rel="stylesheet" type="text/css" />
    <script src="../js/layer/layer.js" type="text/javascript"></script>
    <script src="../js/layui-v2.4.3/layui/layui.js" type="text/javascript"></script>

    <script src="../lib/ligerUI/js/plugins/ligerLayout.js" type="text/javascript"></script>
    <script src="../lib/ligerUI/js/plugins/ligerGrid.js" type="text/javascript"></script>
    <script src="../lib/ligerUI/js/ligerui.min.js" type="text/javascript"></script>
    <style type="text/css">
        body {
            padding: 10px;
            margin: 0;
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
        .control p {
            height:30px;
            line-height:30px;
            margin:10px 50px 0 200px;
        }
        .control {
            padding-top:35px;
            padding-left:50px;
        }
        .layui-form-item {
         
         margin-bottom:30px;
        }
        form {
       
           display:flex;
           flex-direction: row ;
           justify-content:center;
        }
        .layui-form-item {
         display:flex;
         flex-direction: row ;
        }

        .layui-form-item {
            margin-bottom: 10px!important;
        }
        .botton_lay {
            margin-bottom:40px;
            margin-left:70px;
            margin-top:40px;
        }
        /*.kongzhizhuangtai {
            display:flex;
            flex-direction:row;
            justify-content:flex-start;
            align-items:center;
            flex-wrap:wrap;
            padding:40px 0 60px 0; 
        }*/
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
    </style>

    <script type="text/javascript">

          layui.use('form', function () {
                var form = layui.form;
             });

        var public_token = "<%=public_token %>";
        var grid = null;
        var bodyW = document.documentElement.clientWidth; //页面高度
        $(function () {

            $("#layout1").ligerLayout({ leftWidth: bodyW / 2 });
        })

         //加载layui 
        layui.use(['form', 'layedit', 'laydate'], function(){
          var form = layui.form
          ,layer = layui.layer
          ,layedit = layui.layedit
          ,laydate = layui.laydate;
  
          //日期
          //laydate.render({
          //  elem: '#date'
          //});
          //laydate.render({
          //  elem: '#date1'
          //});
  
          //创建一个编辑器
          var editIndex = layedit.build('LAY_demo_editor');
 
          //自定义验证规则
          form.verify({
            title: function(value){
              if(value.length < 5){
                return '标题至少得5个字符啊';
              }
            }
            ,pass: [/(.+){6,12}$/, '密码必须6到12位']
            ,content: function(value){
              layedit.sync(editIndex);
            }
          });
  
          //监听指定开关
            form.on('switch(switchTest)', function (data) {
                console.log(data);
                layer.msg('开关checked：' + (this.checked ? 'true' : 'false')+","+this.name, {

              offset: '6px'
            });
            layer.tips('温馨提示：请注意开关状态的文字可以随意定义，而不仅仅是ON|OFF', data.othis)
          });
  
          //监听提交
          form.on('submit(demo1)', function(data){
            layer.alert(JSON.stringify(data.field), {
              title: '最终的提交信息'
            })
            return false;
          });
 
          //表单初始赋值
         
  
  
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

    <div id="layout1">

      <form class="layui-form" action="">
        
        <div position="left" title="机器人参数设置" style="padding-left: 10px;padding-right:130px;border-right:1px #cccccc solid">
          <div style="padding-bottom: 20px; border-bottom: 1px solid #ccc;">
            <div style=" padding-top: 30px;padding-left:50px; line-height: 30px;">           
               <div class="layui-form-item" > 
                <label class="layui-form-label" style="width:150px">告警后执行机制</label>
                 <div class="layui-input-block">
                     <select name="interest" lay-filter="aihao">
                         <option value=""></option>
                         <option value="0">写作</option>
                         <option value="1" selected="">自动返航</option>
                         <option value="2">游戏</option>
                         <option value="3">音乐</option>
                         <option value="4">旅行</option>
                      </select>
                  </div>
                </div>

                <div class="layui-form-item">   
                  <label class="layui-form-label" style="width:150px">中断后执行机制</label>
                  <div class="layui-input-block">
                      <select name="interest" lay-filter="aihao">
                          <option value=""></option>
                          <option value="0">写作</option>
                          <option value="1" selected="">原地待命</option>
                          <option value="2">游戏</option>
                          <option value="3">音乐</option>
                          <option value="4">旅行</option>
                       </select>
                  </div>
                </div>
           </div>
                <div style="margin: 20px 0px; border-top: 1px solid #ccc;"></div>
                <p>
                    <div class="layui-form-item">
                        <label class="layui-form-label" style="width: 200px;">机器人行进速度：</label>
                        <div class="layui-input-block">
                            <input type="text" name="title" autocomplete="off" placeholder="" class="layui-input" style="width: 200px;">
                        </div>
                    </div>
                </p>
                <p>
                    <div class="layui-form-item">
                        <label class="layui-form-label" style="width: 200px;">雷达报警距离：</label>
                        <div class="layui-input-block">
                            <input type="text" name="title" autocomplete="off" placeholder="" class="layui-input" style="width: 200px;">
                        </div>
                    </div>
                </p>
                <p>
                    <div class="layui-form-item">
                        <label class="layui-form-label" style="width: 200px;">电池容量报警：</label>
                        <div class="layui-input-block">
                            <input type="text" name="title" autocomplete="off" placeholder="" class="layui-input" style="width: 200px;">
                        </div>
                    </div>
                </p>
                <p>
                    <div class="layui-form-item">
                        <label class="layui-form-label" style="width: 200px;">轮子直径：</label>
                        <div class="layui-input-block">
                            <input type="text" name="title" autocomplete="off" placeholder="" class="layui-input" style="width: 200px;">
                        </div>
                    </div>
                </p>
                <p>
                    <div class="layui-form-item">
                        <label class="layui-form-label" style="width: 200px;">机器人最高运行速度：</label>
                        <div class="layui-input-block">
                            <input type="text" name="title" autocomplete="off" placeholder="" class="layui-input" style="width: 200px;">
                        </div>
                    </div>
                </p>
                <p>
                    <div class="layui-form-item">
                        <label class="layui-form-label" style="width: 200px;">低电压报警：</label>
                        <div class="layui-input-block">
                            <input type="text" name="title" autocomplete="off" placeholder="" class="layui-input" style="width: 200px;">
                        </div>
                    </div>
                </p>
                <p style="text-align: right;">
                    <button class="layui-btn layui-btn-normal">保存</button>
                    <button class="layui-btn layui-btn-normal">重置</button>
                </p>
            </div>

            <div>
                云台控制
                <p>
                    <div class="layui-form-item">
                        <label class="layui-form-label" style="width: 200px;">X：</label>
                        <div class="layui-input-block">
                            <input type="text" name="title" autocomplete="off" placeholder="" class="layui-input" style="width: 200px;">
                        </div>
                    </div>
                </p>
                <p>
                    <div class="layui-form-item">
                        <label class="layui-form-label" style="width: 200px;">Y：</label>
                        <div class="layui-input-block">
                            <input type="text" name="title" autocomplete="off" placeholder="" class="layui-input" style="width: 200px;">
                        </div>
                    </div>
                </p>
                <p>
                    <div class="layui-form-item">
                        <label class="layui-form-label" style="width: 200px;">云台水平偏移量：</label>
                        <div class="layui-input-block">
                            <input type="text" name="title" autocomplete="off" placeholder="" class="layui-input" style="width: 200px;">
                        </div>
                    </div>
                </p>
                <p>
                    <div class="layui-form-item">
                        <label class="layui-form-label" style="width: 200px;">云台垂直便宜量：</label>
                        <div class="layui-input-block">
                            <input type="text" name="title" autocomplete="off" placeholder="" class="layui-input" style="width: 200px;">
                        </div>
                    </div>
                </p>
                <p style="text-align: right;">
                    <button class="layui-btn layui-btn-normal">保存</button>
                    <button class="layui-btn layui-btn-normal">重置</button>
                </p>
            </div>
        </div>

        <div position="center" title="机器人点位控制" class="control">
            
            <div class="layui-form-item">
                 <label class="layui-form-label" style="width:150px">中断后执行机制</label>
                 <div class="layui-input-block">
                      <select name="interest" lay-filter="aihao">
                          <option value=""></option>
                          <option value="0">写作</option>
                          <option value="1" selected="">全自动控制模式</option>
                          <option value="2">游戏</option>
                          <option value="3">音乐</option>
                          <option value="4">旅行</option>
                      </select>
                  </div>
            </div>

            <div class="content_2 kongzhizhuangtai">
                        <p>红外功能：<span>开&nbsp;<img src="../images/off.png" alt="红外功能"/>&nbsp;关</span></p>
                        <p>可见光功能：<span>开&nbsp;<img src="../images/open.png" alt="可见光功能"/>&nbsp;关</span></p>
                        <p>雨刷状态：<span>开&nbsp;<img src="../images/open.png" alt="雨刷状态"/>&nbsp;关</span></p>
                        <p>避障功能：<span>开&nbsp;<img src="../images/open.png" alt="避障功能"/>&nbsp;关</span></p>
                        <p>车灯状态：<span>开&nbsp;<img src="../images/open.png" alt="车灯状态"/>&nbsp;关</span></p>
                        <p>充电房：<span>开&nbsp;<img src="../images/open.png" alt="充电房"/>&nbsp;关</span></p>
                        <p>机器人状态：<span>开&nbsp;<img src="../images/open.png" alt="机器人状态"/>&nbsp;关</span></p>
            </div>
            
            
            <p style="text-align: right;" >
                    <button class="layui-btn layui-btn-normal">保存</button>
                    <button class="layui-btn layui-btn-normal">重置</button>
            </p>
        </div>
      </form>
    </div>
</body>
</html>
