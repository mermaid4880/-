<%@ Page Language="C#" AutoEventWireup="true" CodeFile="间隔展示.aspx.cs" Inherits="pages_间隔展示" %>

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
       .grid-demo_2 {
            padding: 10px;
            
            text-align: center;
            background-color:#bbdeca;
            color: #fff;
            height:100px;
            font-size:24px;
            line-height: 100px!important;
        }
        .layui-col-md8 {
            margin-right:20px;
        }
        .layui-btn {
            margin-right:70px;
            margin-left:0 !important;
            
        }
        .grid-demo {
            padding: 10px;
            line-height: 50px;
            
            background-color:#bbdeca;
            color: #fff;
        }
        
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div style="margin-top:10px;">
             <div class="layui-row  layui-col-space10">
                  <div class="layui-col-md3 " >
                      <div class="grid-demo grid-demo-bg1 grid-demo_2" >220KV</div>
                  </div>
                  
                  <div class="layui-col-md9" >
                      <div class="grid-demo grid-demo-bg1" >
                          <div>
                              <button class="layui-btn">主变220KV开</button>
                              <button class="layui-btn layui-btn-normal">主变220KV开</button>
                              <button class="layui-btn layui-btn-warm">主变220KV开</button>
                              <button class="layui-btn layui-btn-danger">主变220KV开</button>
                              <button class="layui-btn layui-btn-warm">主变220KV开</button>
                              <button class="layui-btn">主变220KV开</button>
                              <button class="layui-btn layui-btn-normal">主变220KV开</button>
                              <button class="layui-btn layui-btn-warm">主变220KV开</button>
                              <button class="layui-btn layui-btn-danger">主变220KV开</button>
                              <button class="layui-btn layui-btn-warm">主变220KV开</button>
                              <button class="layui-btn">主变220KV开</button>
                              <button class="layui-btn layui-btn-normal">主变220KV开</button>
                              <button class="layui-btn layui-btn-warm">主变220KV开</button>
                              <button class="layui-btn layui-btn-danger">主变220KV开</button>
                              
                          </div>
                      </div>
                  </div>
             </div>
             <div class="layui-row layui-col-space10">
                  <div class="layui-col-md3 " >
                      <div class="grid-demo grid-demo-bg1 grid-demo_2" >110KV</div>
                  </div>
                  
                  <div class="layui-col-md9" >
                      <div class="grid-demo grid-demo-bg1" >
                          <div>
                              <button class="layui-btn">主变110KV开</button>
                              <button class="layui-btn layui-btn-normal">主变110KV开</button>
                              <button class="layui-btn layui-btn-warm">主变110KV开</button>
                              <button class="layui-btn layui-btn-danger">主变110KV开</button>
                              <button class="layui-btn layui-btn-warm">主变110KV开</button>
                              <button class="layui-btn">主变110KV开</button>
                              <button class="layui-btn layui-btn-normal">主变110KV开</button>
                              <button class="layui-btn layui-btn-warm">主变110KV开</button>
                              <button class="layui-btn layui-btn-danger">主变110KV开</button>
                              <button class="layui-btn layui-btn-warm">主变110KV开</button>
                              <button class="layui-btn">主变110KV开</button>
                              <button class="layui-btn layui-btn-normal">主变110KV开</button>
                              <button class="layui-btn layui-btn-warm">主变110KV开</button>
                              <button class="layui-btn layui-btn-danger">主变110KV开</button>
                              
                              
                          </div>
                      </div>
                  </div>
             </div>
             <div class="layui-row layui-col-space10">
                  <div class="layui-col-md3 " >
                      <div class="grid-demo grid-demo-bg1 grid-demo_2" >35KV</div>
                  </div>
                  
                  <div class="layui-col-md9" >
                      <div class="grid-demo grid-demo-bg1" >
                          <div>
                              <button class="layui-btn">主变035KV开</button>
                              <button class="layui-btn layui-btn-normal">主变035KV开</button>
                              <button class="layui-btn layui-btn-warm">主变035KV开</button>
                              <button class="layui-btn layui-btn-danger">主变035KV开</button>
                              <button class="layui-btn layui-btn-warm">主变035KV开</button>
                              <button class="layui-btn">主变035KV开</button>
                              <button class="layui-btn layui-btn-normal">主变035KV开</button>
                              <button class="layui-btn layui-btn-warm">主变035KV开</button>
                              <button class="layui-btn layui-btn-danger">主变035KV开</button>
                              <button class="layui-btn layui-btn-warm">主变035KV开</button>
                              <button class="layui-btn">主变035KV开</button>
                              <button class="layui-btn layui-btn-normal">主变035KV开</button>
                              <button class="layui-btn layui-btn-warm">主变035KV开</button>
                              <button class="layui-btn layui-btn-danger">主变035KV开</button>
                              
                          </div>
                      </div>
                  </div>
             </div>          
        </div>
        
    </form>
</body>
</html>
