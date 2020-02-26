var canvas = document.getElementById('mycanvas'); // 得到画布
var ctx = canvas.getContext('2d'); // 得到画布的上下文对象
canvas.width = 1400;
canvas.height = 320;
//判断鼠标是否点击地图,截取图片时的坐标（画布从图片那个点开始显示）  和  鼠标滚路滑过的距离  缩放率
var flag = false, x = 0, y = 0, add = 0, add1 = 0, scale = 1;
//鼠标每次抬起的坐标
var x_end = 0; y_end = 0;
var img = new Image();
img.src = '../images/control/pics01.png';
var huTu = false;

//机器人坐标
var aMAN = 200, bMAN = 110;
img.onload = function () {
    ctx.save();
    ctx.drawImage(img, x, y);
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
        $("h1").html("缩放率" + scale);
        return false;
    }
}


//鼠标落下时的坐标  和  鼠标滑动的距离  鼠标累计距离  判断过界
var nowX, nowY, moveX = 0, moveY = 0, addx = 0, addY = 0;
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
            var Dx = e.offsetX + 42;
            var Dy = e.offsetY + 172;
            $("#menu").css("display", "flex").css("top", Dy + "px").css("left", Dx + "px");

        }
    }).mouseup(function (e) {
        if (1 == e.which) {


            flag = false;

            if (!flag && !huTu) {
                console.count("执行次数");
                addx += moveX;
                addY += moveY;
                myCanvas(addx, addY);
                console.log(addx + '' + addY + "," + moveX + "," + moveY);
            }
            x_end = e.offsetX;
            y_end = e.offsetY;
            console.log(nowX, nowY, x_end, y_end);
            saveZuoBiao();
        }
    }).mousemove(function (e) {
        if (flag && !huTu) {
            //坐标差
            moveX = (e.offsetX - nowX) / scale / 5;
            moveY = (e.offsetY - nowY) / scale / 5;
            //画图方法
            myCanvas((moveX + addx), (moveY + addY));
        } else if (flag && $("#but").hasClass("on")) {
            drawRect(e);
        }
    });
});
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
        //显示观看数据
        $("#myText").html("图片起始位置：" + (x - moveX) + '图片的宽：' + (img.width - add) +
            "图片起始位置y" + (y - moveY) + '图片的高' + (img.height - add1));
           
    }
}

//画矩形
function drawRect(e) {
    //当鼠标按下时画图
    if (flag) {
        ctx.restore();
        ctx.clearRect(0, 0, canvas.width, canvas.height);
        ctx.drawImage(img, x - addx, y - addY, img.width, img.height, 0, 0, img.width - add, img.height - add1);
        ctx.strokeStyle = "#ffffff";
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


}
function but1() {
    ctx.drawImage(img, 0, 0, img.width, img.height, 0, 0, img.width - add, img.height - add1);
    x = moveX = addx = 0;
    y = moveY = addY = 0;
}


//循环
var num = 0;
var Pi = 150;
var interval = setInterval(function () {

   
    if (!flag) {
        huaXunHuanLuXian();

    }


}, 1000);

function huaXunHuanLuXian() {

    myCanvas(addx, addY);
}

//阻止浏览器默认右键点击事件
$("canvas").bind("contextmenu", function () {
    return false;
});


function chushidingwei() { $('#menu').css('display', 'none'); layer.msg("初始定位"); };
function yijianfanhang() {
    $('#menu').css('display', 'none'); layer.msg("添加区域");
    huTu = true;

};
function zhantingfuwu() { $('#menu').css('display', 'none'); layer.msg("暂停任务"); };
function quxiaorenwu() { $('#menu').css('display', 'none'); layer.msg("取消任务"); };
function daochuditu() { $('#menu').css('display', 'none'); layer.msg("导出地图"); };