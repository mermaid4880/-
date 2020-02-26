var canvas = document.getElementById('mycanvas'); // 得到画布
var ctx = canvas.getContext('2d'); // 得到画布的上下文对象
canvas.width = 1800;
canvas.height = 600;
//判断鼠标是否点击地图,截取图片时的坐标（画布从图片那个点开始显示）  和  鼠标滚路滑过的距离  缩放率
var flag = false, x = 0, y = 0, add = 0, add1 = 0, scale = 1;
//鼠标每次抬起的坐标
var x_end = 0; y_end = 0;
var img = new Image();
img.src = '../images/control/pics01.png';
var huTu = false;

//机器人坐标
var aMAN = 200, bMAN = 110;
//模拟区域坐标
var quYu = [{ id: 1, Zb: [10, 10, 30, 30] },
            { id: 2, Zb: [50, 50, 80, 90] },
            { id: 3, Zb: [10, 110, 30, 130] },
            { id: 4, Zb: [100, 10, 150, 30] },
            { id: 5, Zb: [300, 200, 350, 230] },]
var size = quYu.length;
img.onload = function () { 
    ctx.drawImage(img, x, y);

    myCanvas(addx, addY);
    if (canvas.addEventListener) {

        canvas.addEventListener("mousewheel", MouseWheelHandler, false);

        canvas.addEventListener("DOMMouseScroll", MouseWheelHandler, false);
    }
    else {
        Limg.attachEvent("onmousewheel", MouseWheelHandler);
    }
    console.count("执行次数，windos");
    function MouseWheelHandler(e) {

        // cross-browser wheel delta

        var e = window.event || e; // old IE support
        var delta = (Math.max(-1, Math.min(1, (e.wheelDelta || -e.detail)))) * 5;
        add += img.width * delta / 50;
        add1 += img.height * delta / 50;
        canvas.height = canvas.height;
        ctx.beginPath();
        var moveX = addx;
        var moveY = addY;
        ctx.drawImage(img, x - moveX, y - moveY, img.width, img.height, 0, 0, img.width - add, img.height - add1);
        //保留2位小数
        scale = ((img.height - add1) / img.height).toFixed(2);

        myCanvas(moveX, moveY);
        $("h1").html("缩放率" + scale);
        return false;
    }
}


  

//鼠标落下时的坐标  和  鼠标滑动的距离  鼠标累计距离  判断过界
var nowX, nowY, moveX = 0, moveY = 0, addx = 0, addY = 0,Dx=0,Dy=0;
$(function () {
    //开关是关闭  可以拖拽地图
    $('canvas').mousedown(function (e) {
        if (1 == e.which) {
            flag = true;
            nowX = e.offsetX; // 鼠标落下时的X
            nowY = e.offsetY; // 鼠标落下时的Y
        }
        if (3 == e.which) {
            //右键 
            Dx = e.offsetX+50;
            Dy = e.offsetY;            
            $("#menu").css("display", "flex").css("top", Dy + "px").css("left", Dx + "px");
            
        }
    }).mouseup(function (e) {
        if (1 == e.which) {


            flag = false;

            if (!flag && !huTu) {
              
                
                addx += moveX;
                addY += moveY;
                myCanvas(addx, addY);
                console.log(addx + '' + addY + "," + moveX + "," + moveY);
            } if (huTu) {
                x_end = e.offsetX;
                y_end = e.offsetY;
                //console.log(nowX, nowY, x_end, y_end);
                saveZuoBiao();
            }
           
        }
    }).mousemove(function (e) {
        if (flag && !huTu) {
            
            //坐标差
            moveX = (e.offsetX - nowX) / scale / 5;
            moveY = (e.offsetY - nowY) / scale / 5;
            //画图方法
            myCanvas((moveX + addx), (moveY + addY));
        } else if (flag && huTu ) {
            drawRect(e);
        }
    });
});


var quYu = [{ id: 1, Zb: [10, 10, 30, 30] },
{ id: 2, Zb: [50, 50, 80, 90] },
{ id: 3, Zb: [10, 110, 30, 130] },
{ id: 4, Zb: [100, 10, 150, 30] },
{ id: 5, Zb: [300, 200, 350, 230] },]
var size = quYu.length;
//具体画图方法  控制坐标  大小  等
function myCanvas(moveX, moveY) {
    if (x - moveX < 0) {
        x = addx = 0.1;

    } if (y - moveY < 0) {
        y = addY = 0.1;
    }

    if (x - moveX >= 0 && y - moveY >= 0) {

        //从新绘制
        ctx.clearRect(0, 0, canvas.width, canvas.height);
        ctx.beginPath();
        ctx.drawImage(img, x - moveX, y - moveY, img.width, img.height, 0, 0, img.width - add, img.height - add1);
       //绘制区域
        ctx.save();
        ctx.beginPath();    
        //ctx.closePath();//闭合路径
        //线路宽
        ctx.lineWidth = 2 * scale;
        //颜色
        ctx.strokeStyle = "#333333";
        //透明度
        ctx.globalAlpha = 1;
        ctx.translate(moveX * scale, moveY * scale);
        for (var i = 0; i < size; i++) {
            var zbx = quYu[i].Zb[0] * scale;
            var zby = quYu[i].Zb[1] * scale;
            var zbenx = (quYu[i].Zb[2] - quYu[i].Zb[0]) * scale;
            var zbendy = (quYu[i].Zb[3] - quYu[i].Zb[1]) * scale;
            console.log(zbx+','+ zby+','+ zbenx+','+ zbendy);
            ctx.strokeRect(zbx, zby, zbenx, zbendy);

        }
        
        ctx.restore();

    }
}




//画矩形
function drawRect(e) {
    //当鼠标按下时画图
    if (flag) {
        ctx.restore();
        ctx.clearRect(0, 0, canvas.width, canvas.height);
        ctx.drawImage(img, x - addx, y - addY, img.width, img.height, 0, 0, img.width - add, img.height - add1);
        ctx.strokeStyle = "#333333";
        ctx.beginPath();
        //画矩形方法
        var a = canvas.width / (img.width - add);
        var b = canvas.width / (canvas.height + canvas.width);
        ctx.strokeRect(nowX, nowY, (e.offsetX - nowX), (e.offsetY - nowY));
    }
}
function saveZuoBiao() {
    //保存最后画上去的坐标
    //把坐标还原到1:1的比例  当前比例画的的图除以缩放系数
    var r1 = nowX / scale + x - addx;
    var r2 = nowY / scale + y - addY;
    var r3 = x_end / scale + x - addx;
    var r4 = y_end / scale + y - addY;
    //调用弹出框
    $().getFuc();
    alert(r1 + "," + r2 + "," + r3 + "," + r4);
}
function but1() {
    ctx.drawImage(img, 0, 0, img.width, img.height, 0, 0, img.width - add, img.height - add1);
    x = moveX = addx = 0;
    y = moveY = addY = 0;
}


//循环
//var num = 0;
//var Pi = 150;
//var interval = setInterval(function () {

   
//    if (!flag) {
//        huaXunHuanLuXian();

//    }


//}, 1000);

function huaXunHuanLuXian() {

    myCanvas(addx, addY);
}


function chushidingwei() { $('#menu').css('display', 'none'); layer.msg("地图归位"); window.location.reload();};
function yijianfanhang() {
    $('#menu').css('display', 'none'); layer.msg("添加区域");
    huTu = true;

};
function zhantingfuwu() {
    $('#menu').css('display', 'none');
    layer.msg("删除区域");
    //弹出动态删除菜单
    closeD();

};
function quxiaorenwu() { $('#menu').css('display', 'none'); layer.msg("清空区域"); };
function daochuditu() { $('#menu').css('display', 'none'); layer.msg("导出地图"); };




var public_isAdd = true; //定义是否是添加，还是修改

//这里是 jqure功能 注册控件方法

$(function () {

    //阻止浏览器默认右键点击事件
    //$("#mycanvas").contextmenu(function () {

    //    return false;
    //});

    $("#mycanvas").bind('contextmenu', function (ev) {//向画布元素添加一个contextmenu事件，触发点击菜单屏蔽   ？？？
        //名字为getFuc的jQuery方法
        $.fn.getFuc = function () {

            public_isAdd = true;
            LayerOpenDiv("设备信息添加", true);
            var Json = {};
            if (enhanceForm) {
                var enhance = new enhanceForm({
                    elem: '#divFormOpen' //表单选择器
                });
                //enhance.filling(Json); //其中jsonData为表单数据的json对象
            }


        }
        return false;
    });

   
});



function LayerOpenDiv(vTitle, vAdd) {
    layui.use(['layer'], function () {

        var layer = layui.layer;
        layer.open({
            title: vTitle,
            type: 1,
            anim: 1,
            area: ['480px', '500px'],
            skin: 'layui-layer-rim', //加上边框
            content: $('#divFormOpen'),
            btn: ["确定", "取消"],
            yes: function (index, layero) {
                var tit = $("input[name='title']").val();
                var max = $("input[name='maxWd']").val();
                var min = $("input[name='minWd']").val();
                if (tit != "" && max != "" && min != "") {
                    //关闭画图
                    huTu = false;
                    sumitSave(vAdd);
                    return false;
                } else {
                    layer.msg("请填写完整信息");
                   
                }

            },
            btn2: function (index, layero) {
                huTu = false;
                huaXunHuanLuXian();
                layer.close(index);
                return false;
            }
        });


    });
}

function sumitSave(public_isAdd) {

    var vJsonArray = getJsonListOpenDiv($("#divFormOpen"))
    //console.log(JSON2.stringify(vJsonArray));
    //grid_search("", JSON2.stringify(vJsonArray));
    $.ajax({
        type: "post",
        url: "../handler/ajax.ashx",
        data: {
            typeName: "public"
            , method: public_isAdd ? "public_add_db" : "public_update_db"
            , tableName: "tb_device_bjSet"
            , sqlJson: JSON2.stringify(vJsonArray)
        },
        dataType: "json",
        success: function (dataJson) {
            if (dataJson) {
                if (dataJson.code == "1") {
                    layer.closeAll();
                    layer.msg("操作成功！", { icon: 1, time: 500 }, function () {
                        //grid_search("", "");
                        //成功后接下来的操作
                        huaXunHuanLuXian();
                    });
                }
                else {
                    layer.msg(dataJson.msg, { icon: 2 });
                }
            }
            else {
                layer.msg("操作发生异常！", { icon: 2 });
            }
        }
    });

    return false;
}

//删除区域方法
function closeD() {
    if (!bol()) {
        return layer.msg("请选择删除区域");
    } else {
    
    var html = "";
        for (var i = 0; i < size; i++) {
            if (quYu[i].id == bol()) {
                html += "<li><input  type=" + 'button' + "  class=" + 'closeD_li' +
                    " style=" + 'width:130px;height:30px;background-color:#ffffff;opacity:0.3;' + "  value ="+'这是第'+i+'条消息'+" ></input></li > ";

            }
    }
    
    $("#closeD").css("display", "flex").css("top", Dy + "px").css("left", Dx + "px");
    $("#closeD").html(html);
    //穿过
    $(".closeD_li").mouseover(
        function () {
           
            $(this).css("background-color", "#eeeeee");

            myCanvas(addx, addY);
            
            for (var i = 0; i < size; i++) {
                if (quYu[i].id == bol()) {
                    //绘制区域
                    ctx.save();
                    ctx.beginPath();
                    //ctx.closePath();//闭合路径
                    //线路宽
                    ctx.lineWidth = 2 * scale;
                    //颜色
                    ctx.strokeStyle = "red";
                    //透明度
                    ctx.globalAlpha = 1;
                    ctx.translate(addx * scale, addY * scale);
                  
                        var zbx = quYu[i].Zb[0] * scale;
                        var zby = quYu[i].Zb[1] * scale;
                        var zbenx = (quYu[i].Zb[2] - quYu[i].Zb[0]) * scale;
                        var zbendy = (quYu[i].Zb[3] - quYu[i].Zb[1]) * scale;
                        console.log(zbx + ',' + zby + ',' + zbenx + ',' + zbendy);
                        ctx.strokeRect(zbx, zby, zbenx, zbendy);       
                        ctx.restore();

                }
            }


        }
    );
    //离开
    $(".closeD_li").mouseout(
        function () {
            $(this).css("background-color", "#ffffff");
            myCanvas(addx, addY);
        }
        );

        $(".closeD_li").click(function () {
            //刷新当前页面
            window.location.reload();
        });

    }
}   

//判断是点选在删除位子上吗?
function bol() {
    for (var i = 0; i < size; i++) {
        var zbx = quYu[i].Zb[0] * scale;
        var zby = quYu[i].Zb[1] * scale;
        var zbenx = (quYu[i].Zb[2] - quYu[i].Zb[0]) * scale;
        var zbendy = (quYu[i].Zb[3] - quYu[i].Zb[1]) * scale;

        //判断是否在框内
        if ((Dx - 50) >= zbx && (Dx - 50) <= (zbx + zbenx) && Dy >= zby && Dy <= (zbendy + zby)) {
            return quYu[i].id;
        }

    }
    return false;
}