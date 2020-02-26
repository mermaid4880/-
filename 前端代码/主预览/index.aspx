<%@ Page Language="C#" AutoEventWireup="true" CodeFile="index.aspx.cs" Inherits="主预览_index" %>


<!DOCTYPE html>

<html>
<head id="Head1" runat="server">
    <meta charset="utf-8">
    <title>layui</title>
    <meta name="renderer" content="webkit">
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1">
    <link rel="stylesheet" href="../plugins/layui/css/layui.css"  media="all">
     
    <script src="../plugins/layui/layui.js" type="text/javascript"></script>
    <script src="../js/jquery-1.8.3.min.js" type="text/javascript"></script>
    <script src="../js/json2.js" type="text/javascript"></script>

    <script src="../js/basicJs.js" type="text/javascript"></script>

    <style>
    
        .boxBorder
        {
            
            border: 1px solid #BFBFBF;
            line-height:500px;
            height:500px;
            text-align:center;
            
            }
       
    </style>
   
    <script>
    
    </script>

</head> 
<body>
    <form id="form1" runat="server">
     

     
     <div class="layui-row" style="margin-top:5px;" id="div1">

        <div class="layui-col-xs2 showBox1">
          
            <div class="layui-row">
                

                  <div class="layui-col-md12">
                        <iframe id="iframe1" style="height:150px;width:300px;" scrolling="no" marginwidth="0" marginheight="0" frameborder="0"  src="../tree/tree1.aspx"></iframe>
                  </div>

                  <div class="layui-col-md12">
                       <div style="width:200px;margin-left:10px; height:60px;line-height:60px;text-align:center;border:1px solid #BFBFBF">工具栏</div>
                  </div>

                  <div class="layui-col-md12">
                    <img style="margin-left:10px;" src="../img/caozuo.png" />
                  </div>


            
            </div>

        </div>


        <div class="layui-col-xs10 " style="margin-top:10px;">
          
                
                <div class="layui-row layui-col-space10">
                  <div class="layui-col-md6  layui-col-space10 boxBorder" >
                    红外线图片1
                  </div>
                  <div class="layui-col-md6 layui-col-space10 boxBorder">
                    红外线图片2
                  </div>
               
                </div>
          </div>

     </div>


            
       

       
    
    </form>
</body>
</html>
