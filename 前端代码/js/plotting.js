//var canvas = document.getElementById('mycanvas'); // 得到画布
//var ctx = canvas.getContext('2d'); // 得到画布的上下文对象
//canvas.width=1350;
//canvas.height =400;
////判断鼠标是否点击地图,截取图片时的坐标（画布从图片那个点开始显示）  和  鼠标滚路滑过的距离  缩放率
//var flag=false, x=0, y= 0,add= 0,add1= 0,scale=1;
////鼠标每次抬起的坐标
//var x_end = 0; y_end = 0;
////创建背景图片对象
//var img = new Image();
//img.src = "";
////创建机器人图片对象
//var imgMan = new Image();
//imgMan.src = "";
////机器人坐标
//var aMAN = 0, bMAN = 0;
////给初始地图赋值
//$.ajax({
//    type: "get",
//    url: "../handler/InterFace.ashx",
//    data: {
//        method: "http_getMethod"
//        , token: public_token
//        , MethodUrl: "/robots/map/192.168.0.1"
//    },
//    dataType: "json",
//    success: function (data) {
//        //处理返回值
//        console.log(data);
//        //地图 地址 
//        img.src = data.mapImageURL;
//        //机器人地址
//        imgMan.src = data.robotImageURL
//        //机器人坐标
//        aMAN = data.robotX;
//        bMAN = data.robotY;
//        //机器人旋转角度
//        var  angle = data.angle;
//        //行进路线 以及 已完成的路线
//        var  taskPoints = data.taskPoints;
//    }
//});




////线路 对象数组
//var jObj = [{ x: 0, y: 0 }, { x: 200, y: 100 }, { x: 300, y: 300 }, { x: 500, y: 500 }, { x: 1000, y: 800 }];

//var Jq = [{ x: 200, y: 110 }, { x: 210, y: 120 }, { x: 220, y: 130 }, { x: 230, y: 140 }, { x: 240, y: 150 },
//          { x: 250, y: 160 }, { x: 260, y: 170 }, { x: 270, y: 180 }, { x: 280, y: 190 }, { x: 290, y: 200 },
//          { x: 300, y: 210 }, { x: 300, y: 220 }, { x: 300, y: 230 }, { x: 300, y: 240 }, { x: 300, y: 250 },
//          { x: 300, y: 260 }, { x: 300, y: 270 }, { x: 300, y: 280 }, { x: 300, y: 290 }, { x: 300, y: 300 },];


////加载机器人
//drawRobot();
//var transX = 0, transY = 0;
//function drawRobot() {
//    var color = '#a4ca39';
//    ctx.save(); //锁画布(为了保存之前的画布状态)

//    ctx.translate(transX, transY);//距离原位置起点的偏移
//    ctx.scale(scale, scale);//缩放图形
//    //可换为机器人图片的长宽的一半
//    ctx.rotate(Pi * Math.PI / 180);//画布旋转
//    ctx.translate(-15, -20);
//    ctx.fillStyle = color;

//    imgMan.onload = function () {
//        ctx.drawImage(imgMan, x, y);

//    }

//    ctx.restore();//把当前画布返回(调整)到上一个save()状态之前
//}
////加载背景地图
//img.onload = function () {
//    ctx.save();
//    ctx.drawImage(img,x,y);
//    if(canvas.addEventListener){

//        canvas.addEventListener("mousewheel",MouseWheelHandler,false);

//        canvas.addEventListener("DOMMouseScroll", MouseWheelHandler, false);
//    }
//    else{
//        Limg.attachEvent("onmousewheel", MouseWheelHandler);
//    }
//    console.count("执行次数，windos");
//    function MouseWheelHandler(e) {

//        // cross-browser wheel delta

//        var e = window.event || e; // old IE support
//        var delta = (Math.max(-1, Math.min(1, (e.wheelDelta || -e.detail))))*5;
//        add += img.width*delta/50;
//        add1 += img.height*delta/50;
//        canvas.height = canvas.height;
//        ctx.beginPath();
//        var moveX = addx;
//        var moveY = addY;
//        ctx.drawImage(img, x - moveX, y - moveY, img.width, img.height, 0, 0, img.width - add, img.height - add1);
//        //保留2位小数
//        scale = ((img.height-add1)/img.height).toFixed(2);
    
//        myCanvas(moveX, moveY);

//        $("h1").html("缩放率"+scale);
//        return false;
//    }
//}

//$("#but").click(function () {
//    if($(this).hasClass("off")){
//        //点击画图
//        //class = on;
//        $(this).css("backgroundColor","red").addClass("on").removeClass("off");
//        //画图功能
//    }else{
//        //点击取消画图
//        //class = off;
//        $(this).css("backgroundColor","#00a0e9").addClass("off").removeClass("on");
//    }
//});
////鼠标落下时的坐标  和  鼠标滑动的距离  鼠标累计距离  判断过界
//var nowX,nowY,moveX=0,moveY=0,addx=0,addY= 0;
//$(function () {
//    //开关是关闭  可以拖拽地图
//    $('canvas').mousedown(function (e) {
//        if (1 == e.which) {
//            flag = true;
//            nowX = e.offsetX; // 鼠标落下时的X
//            nowY = e.offsetY; // 鼠标落下时的Y
//        }      
//        if (3 == e.which) {
//            //右键 
//            var Dx = e.offsetX + 42;
//            var Dy = e.offsetY + 172;
//            $("#menu").css("display", "flex").css("top", Dy+"px").css("left",Dx+"px");

//        }
//    }).mouseup(function (e) {
//        if (1 == e.which) {
           
            
//        flag = false;
        
//        if (!flag && $("#but").hasClass("off")) {
//            console.count("执行次数");
//            addx += moveX;
//            addY += moveY;
//            myCanvas(addx, addY);
//            console.log(addx + '' + addY + "," + moveX + "," + moveY);
//        }
//        x_end = e.offsetX;
//        y_end = e.offsetY;
//        console.log(nowX, nowY, x_end, y_end);
//        saveZuoBiao();
//        } 
//        }).mousemove(function (e) {
//        if(flag&&  $("#but").hasClass("off")){
//            //坐标差
//            moveX = (e.offsetX - nowX)/scale/5;
//            moveY = (e.offsetY - nowY)/scale/5;
//            //画图方法
//            myCanvas((moveX + addx), (moveY + addY)); 
//        }else if(flag&&  $("#but").hasClass("on")){
//            drawRect(e);
//        }
//    });
//});
//function myCanvas(moveX, moveY) {
//    if (x - moveX < 0) {
//        x = addx = 0.1;

//    } if (y - moveY < 0) {
//        y = addY = 0.1;
//    }

//    if (x - moveX >= 0 && y - moveY >= 0) {

    
//    //从新绘制
//    ctx.clearRect(0, 0, canvas.width, canvas.height);
//    ctx.beginPath();
//    ctx.drawImage(img, x - moveX, y - moveY, img.width, img.height, 0, 0, img.width - add, img.height - add1);
//    //显示观看数据
//    $("#myText").html("图片起始位置：" + (x - moveX) + '图片的宽：' + (img.width - add) +
//        "图片起始位置y" + (y - moveY) + '图片的高' + (img.height - add1));
//    //画线路
//    ctx.save();
//    ctx.beginPath();
//    for (var i = 0; i < jObj.length; i++) {
//        if (i == 0) {
//            ctx.moveTo(parseInt(jObj[i].x - (x - moveX)) * scale, parseInt(jObj[i].y - (x - moveY)) * scale);
//        }
//        ctx.lineTo(parseInt(jObj[i].x - (x - moveX)) * scale, parseInt(jObj[i].y - (x - moveY)) * scale);
//    }
//    //ctx.closePath();//闭合路径
//    //线路宽
//    ctx.lineWidth = 2 * scale;
//    //颜色
//    ctx.strokeStyle = "#ff0000";
//    //透明度
//    ctx.globalAlpha = 0.8;
//    ctx.stroke();
//    ctx.translate(moveX, moveY);
//    ctx.restore();

//    //200  100  代表机器人的实际位置
//    transX = (moveX + aMAN) * scale, transY = (moveY + bMAN) * scale;
//    drawRobot();

//    //画行走过的路线
//    ctx.save();
//    ctx.beginPath();
//    for (var i = 0; i < jObj.length; i++) {
//        if (i == 0) {
//            ctx.moveTo(parseInt(jObj[i].x - (x - moveX)) * scale, parseInt(jObj[i].y - (x - moveY)) * scale);
//        }
//        ctx.lineTo(parseInt(jObj[i].x - (x - moveX)) * scale, parseInt(jObj[i].y - (x - moveY)) * scale);
//        if (i < jObj.length - 1) {

//            var x1 = jObj[i].x;
//            var y1 = jObj[i].y;
//            var x2 = jObj[i + 1].x;
//            var y2 = jObj[i + 1].y;
//            if (aMAN <= x2 && aMAN >= x1 && bMAN <= y2 && bMAN >= y1) {
//                ctx.lineTo(parseInt(aMAN - (x - moveX)) * scale, parseInt(bMAN - (x - moveY)) * scale);
//                break;
//            }
//        }
//    }
//    //ctx.closePath();//闭合路径
//    ctx.lineWidth = 5 * scale;
//    ctx.strokeStyle = "#000000";
//    ctx.globalAlpha = 1;
//    ctx.stroke();
//    ctx.translate(moveX, moveY);
//    ctx.restore();
//    //画路线结束

//  }
//}

////画矩形
//function drawRect(e) {
//    //当鼠标按下时画图
//    if (flag) {
//        ctx.restore();
//        ctx.clearRect(0, 0, canvas.width, canvas.height);
//        ctx.drawImage(img,x-addx,y-addY,img.width,img.height,0,0,img.width-add,img.height-add1);
//        ctx.strokeStyle="#ffffff";
//        ctx.beginPath();
//        //画矩形方法
//        var a = canvas.width/(img.width-add);
//        var b = canvas.width/(canvas.height+canvas.width);
//        ctx.strokeRect(nowX, nowY, (e.offsetX - nowX), (e.offsetY - nowY));
//    }
//}
//function saveZuoBiao(){
//    //保存最后画上去的坐标
//    //把坐标还原到1:1的比例  当前比例画的的图除以缩放系数
//    var r1 = nowX/scale+x-addx;
//    var r2 = nowY/scale+y-addY;
//    var r3 = x_end/scale+x-addx;
//    var r4 = y_end/scale+y-addY;


//}
//function but1(){
//    ctx.drawImage(img,0,0,img.width,img.height,0,0,img.width-add,img.height-add1);
//    x = moveX=addx=0;
//    y = moveY=addY=0;
//}


////循环
//var num = 0;
//var Pi = 150;
//var interval = setInterval(function () {

//    if (num < Jq.length - 1) {
//        num++;
//        aMAN = Jq[num].x;
//        bMAN = Jq[num].y;
//        if (num == 10) {
//            Pi = 180;
//        }
//    }
//    if (!flag) {
//        huaXunHuanLuXian();
       
//    }
   

//},1000);

//function huaXunHuanLuXian() {
  
//    myCanvas(addx, addY);
//}

////阻止浏览器默认右键点击事件
//$("canvas").bind("contextmenu", function () {
//    return false;
//});


//var URL;
//function chushidingwei() { $('#menu').css('display', 'none'); layer.msg("初始定位"); window.location.reload(); };
////一键返航
//function yijianfanhang() {
//    $('#menu').css('display', 'none');
//    URL = "/taskManager/goHome";
//    if (!aJax()) {
//        layer.msg("一键返航操作失败");
//    } else {
//        layer.msg("一键返航操作成功");
//    }
   
//};
////暂停任务
//function zhantingfuwu() {
//    $('#menu').css('display', 'none'); /*layer.msg("暂停任务");*/
//    URL = "/taskManager/pause";
//    if (!aJax()) {
//        layer.msg("暂停任务操作失败");
//    } else {
//        layer.msg("暂停任务操作成功");
//    }
//};
////取消任务
//function quxiaorenwu() {
//    $('#menu').css('display', 'none'); /*layer.msg("取消任务");*/
//    URL = "/taskManager/terminate-all";
//    if (!aJax()) {
//        layer.msg("取消任务操作失败");
//    } else {
//        layer.msg("取消任务操作成功");
//    }
//};
//function daochuditu() {
//    $('#menu').css('display', 'none'); layer.msg("导出地图");

//};

//function aJax() {
//    $.ajax({
//        type: "post",
//        url: "../handler/InterFace.ashx", 
//        dataType: "json",
//        data: {
//            method: "http_PostMethod"
//            , token: public_token
//            , MethodUrl: URL
//            , postData: ""
//        },
//        success: function (data) {
//            console.log(data);
//            return data.success;
//        },
//        error: function () {
//            alert('错误');
//        }
//    });



//}

/**
 * Created by Thinkpad on 2019/5/5.
 * 右键点击效果是否还要？
 */
$(window).ready(function () {
    board.init();
});

var setting = {//设置类
    past: [],//已经行进过的线路  临时的测试坐标
    next: [],//还未行进过的线路
    map: '',//地图的地址
    autoMan: { x: 50, y: 50, pi: 30 },//机器人实时坐标
    autoManPhoe: '',//机器人图片地址
    seed: 1000,//请求间隔/ms
    spleed: 1.0,//地图缩放率
    width: 1350,//画布的宽高
    height: 440
};


var board = {//画布类
    init: function () {
        
        board.canvas = document.getElementById('mycanvas'); // 得到画布
        board.txt = board.canvas.getContext('2d');
        board.canvas.width = setting.width;
        board.canvas.height = setting.height;

        board.canvas1 = document.getElementById('mycanvas1'); // 得到线路画布
        board.txt1 = board.canvas1.getContext('2d');
        board.canvas1.width = setting.width;
        board.canvas1.height = setting.height;
        mouse.init();//绑定鼠标事件
        board.zoom();//绑定滚轮事件
        board.requestMap();//获取地图
        board.qingQiu();//循环请求
        board.loadImage();//绘图
    },

    requestMap: function () {
        $.ajax({//请求地图
            type: "get",
            url: "../handler/InterFace.ashx?r=" + Math.random(),
            data: {
                method: "http_getMethod"
                , token: public_token
                , MethodUrl: "/robots/mapURL"

            },
            dataType: "json",
            success: function (data) {

                //{success:"true","detail": "xxx"}
                if (data) {
                    if (data.success) {
                        setting.map = data.data;
                        //console.log('请求成功------');
                        board.loadImage();
                    }
                    else {
                        layer.msg("加载地图失败");
                    }
                }
            },
            error: function (XMLHttpRequest, textStatus, errorThrown) {
                //alert(XMLHttpRequest.status);
            }
        });
    },

    zoom: function () {
        if (board.canvas1.addEventListener) {

            board.canvas1.addEventListener("mousewheel", MouseWheelHandler, false);

            board.canvas1.addEventListener("DOMMouseScroll", MouseWheelHandler, false);
        }
        else {
            Limg.attachEvent("onmousewheel", MouseWheelHandler);
        }
        function MouseWheelHandler(e) {

            // cross-browser wheel delta

            var e = window.event || e; // old IE support
            var delta = (Math.max(-1, Math.min(1, (e.wheelDelta || -e.detail))));
            if (delta > 0) {
                setting.spleed += 0.1
            } else {
                setting.spleed -= 0.1
            }
            setting.spleed = Math.floor(setting.spleed * 10) / 10;
            console.log('delta:' + delta);
            console.log(setting.spleed);
            if (setting.spleed <= 1.0) {
                setting.spleed = 1.0;
            } else if (setting.spleed >= 3.0) {
                setting.spleed = 3.0;
            }
            board.draw();
        }

    },

    loadImage: function () {//地图加载类
        board.img = new Image();
        board.img.src = setting.map;
        board.img.onload = function () {       
            board.canvas.height = board.canvas.height;
            board.txt.drawImage(board.img,
                mouse.mouse_x , mouse.mouse_y , board.img.width, board.img.height,
                0, 0, board.img.width * setting.spleed, board.img.height * setting.spleed);          
        }
    },

    loadManImage: function () {//加载并显示机器人图片
        board.imgMan = new Image();
        board.imgMan.src = setting.autoManPhoe;
       
        board.imgMan.onload = function () {
            board.txt1.save(); 
            var x = (setting.autoMan.x - mouse.mouse_x-10) * setting.spleed;
            var y = (setting.autoMan.y - mouse.mouse_y-10) * setting.spleed;
            var pi = setting.autoMan.pi;
            var w = 20 * setting.spleed;         
            board.txt1.translate(x+0.5*w, y+0.5*w);
            board.txt1.rotate(pi * Math.PI / 180);
            board.txt1.translate(-(x + 0.5 * w), -(y + 0.5 * w));
            board.txt1.drawImage(board.imgMan,
                0, 0, board.imgMan.width, board.imgMan.height,
                x, y, w, w);
            
            console.log(x + 0.5 * w);
            board.txt1.restore();
           
        }
       
       
    },

    qingQiu: function () {//请求获取数据
        setTimeout(function () {
            console.count('几次');
            board.ajax();//循环请求
            board.drawAutoMen();
            //setting.past.shift();
            //console.log('这是请求循环体');
            board.qingQiu();
        }, setting.seed);
    },

    drawAutoMen: function () {//绘制机器人的类和绘制路线
        var p = setting.past;//走过的路线
        var m = setting.autoMan;//机器人坐标
        //board.txt1.save();
        board.txt1.fillStyle = '#ffffff';
        if (p.length > 0) {
            //先清空上一次的显示
            board.txt1.clearRect(0, 0, board.canvas1.width, board.canvas1.height);
            //先画行进过的路线
            board.past();
            //在画未行进过的路线
            board.next();
            //在画机器人图标
            board.autoMan();
          
           
        }

        //board.txt1.restore();


    },
    past: function () {
        var p = setting.past;//走过的路线
        var m = setting.autoMan;//机器人坐标
        board.txt1.save();
        if (p.length > 0) {
            board.txt1.fillStyle = 'blue';
            for (var i = 0, len = p.length; i < len; i++) {
                board.txt1.beginPath();
                board.txt1.arc((p[i].x + 4 - mouse.mouse_x) * setting.spleed, (p[i].y + 4 - mouse.mouse_y) * setting.spleed, 5 * setting.spleed, Math.PI * 2, 0, true);
                board.txt1.fill();
            }
           
        }
        board.txt1.restore();

    },
    next: function () {
        var n = setting.next;//未走过的路线
        var m = setting.autoMan;//机器人坐标
        
        board.txt1.save();
        if (n.length > 0) {
           
            board.txt1.fillStyle = 'yellow';
            for (var i = 0, len = n.length; i < len; i++) {
                board.txt1.beginPath();
                board.txt1.arc((n[i].x + 4 - mouse.mouse_x) * setting.spleed, (n[i].y + 4 - mouse.mouse_y) * setting.spleed, 5 * setting.spleed, Math.PI * 2, 0, true);
                board.txt1.fill()
            }

            
        }
        board.txt1.restore();
    },
    autoMan: function () {
        var m = setting.autoMan;//机器人坐标
        board.txt1.save();
        if (m) {

        }
        board.txt1.restore();

    },
    ajax: function () {
                
        $.ajax({//请求机器人坐标
            type: "get",
            url: "../handler/InterFace.ashx?r=" + Math.random(),
            data: {
                method: "http_getMethod"
                , token: public_token
                , MethodUrl: "/robots/map"

            },
            dataType: "json",
            success: function (data) {

                //{success:"true","detail": "xxx"}
                if (data) {
                    if (data.success) {
                        setting.autoManPhoe = data.data.robotImageURL;
                        setting.autoMan.x = data.data.robotX;
                        setting.autoMan.y = data.data.robotY;
                        setting.autoMan.pi = data.data.angle;
                        //console.log('请求成功------');
                        board.loadManImage();
                        
                    }
                    else {
                        layer.msg("加载地图失败");
                    }
                }
            },
            error: function (XMLHttpRequest, textStatus, errorThrown) {
                //alert(XMLHttpRequest.status);
            }
        });
        
    },

    draw: function () {//重绘
        board.canvas.height = board.canvas.height;
        board.drawAutoMen();
        board.txt.save();
        board.txt.beginPath();
        board.txt.drawImage(board.img,
        mouse.mouse_x , mouse.mouse_y , board.img.width, board.img.height,
        0, 0, board.img.width * setting.spleed, board.img.height * setting.spleed);
        board.txt.beginPath();
        board.txt.fillStyle = 'red';
        board.txt.font = '900 30px Arial';
        board.txt.fillText('缩放系数' + setting.spleed, 10, 40);
        board.txt.restore();
    },

};

var mouse = {
    x: 0,//鼠标相对于画布的坐标
    y: 0,
    mouse_x: 0, //地图偏移的坐标
    mouse_y: 0,
    offsetX: 0,
    offsetY: 0,
    endX: 0,
    endY: 0,
    //鼠标左键是否按下
    buttonPressed: false,
    //鼠标是否在canvas区域内
    insideCanvas: false,

    init: function () {
        var $mouseCanvas = $("#mycanvas1");
        $mouseCanvas.mousemove(function (ev) {
            if (mouse.buttonPressed) {
                board.drawAutoMen();
                mouse.offsetX = ev.offsetX - mouse.x;
                mouse.offsetY = ev.offsetY - mouse.y;
                mouse.mouse_x = mouse.endX - mouse.offsetX;
                mouse.mouse_y = mouse.endY - mouse.offsetY;
                if (mouse.mouse_x < 0) {
                    mouse.mouse_x = mouse.offsetX = 0;
                }
                if (mouse.mouse_y< 0) {
                    mouse.mouse_y = mouse.offsetY = 0;
                }
                if (mouse.mouse_x > board.img.width * setting.spleed - board.canvas.width) {
                    mouse.offsetX = 0;
                    mouse.mouse_x = (board.img.width * setting.spleed - board.canvas.width);
                }
                if (mouse.mouse_y > board.img.height * setting.spleed - board.canvas.height) {
                    mouse.offsetY = 0;
                    mouse.mouse_y = (board.img.height * setting.spleed - board.canvas.height);
                }
                if (setting.past.length > 0) {
                    board.txt1.clearRect(0, 0, board.canvas1.width, board.canvas1.height);
                    board.txt1.fillRect(setting.past[0].x - 5 - mouse.mouse_x,
                        setting.past[0].y - 5 - mouse.mouse_y, 10, 10);
                }

                board.draw();
            }

        });



        $mouseCanvas.mousedown(function (ev) {

            mouse.buttonPressed = true;
            mouse.x = ev.offsetX;
            mouse.y = ev.offsetY;
            console.log(mouse.offsetX);
            console.log('偏移坐标' + mouse.mouse_x);
        });

        $mouseCanvas.mouseup(function (ev) {//抬起
            mouse.buttonPressed = false;
            mouse.endX = mouse.mouse_x;
            mouse.endY = mouse.mouse_y;

        });

        $mouseCanvas.mouseleave(function (ev) {//离开画布事件
            mouse.insideCanvas = false;//判断鼠标不再画布内
        });

        $mouseCanvas.mouseenter(function (ev) {//鼠标进入画布
            mouse.buttonPressed = false;// 关闭按下状态
            mouse.insideCanvas = true;//判断鼠标在画布内
        });
    }
};