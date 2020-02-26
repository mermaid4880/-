 //改变机器人控制按钮的hover改变图片
 var carImgSrc,cloudImgSrc;
$(".console-btn .car").mouseover(function(){
	carImgSrc=$(this).attr("src");
	var imgSrcReplace=carImgSrc.replace("1","2");
	$(this).attr("src",imgSrcReplace);
}).mouseout(function(){
	$(this).attr("src",carImgSrc);
})
$(".console-btn .cloud").mouseover(function(){
	cloudImgSrc=$(this).attr("src");
	var imgSrcReplace=cloudImgSrc.replace("1","2");
	$(this).attr("src",imgSrcReplace);
}).mouseout(function(){
	$(this).attr("src",cloudImgSrc);
})


function bodyLoad() {
 	setTarget();
 }
 function turnUp() {
 	var x = 0.3;
 	var y = 0;
 	var w = 0;
 	RobotRemoteControl.RobotSpeedControl(x,y,w);
 	console.log("向上");
 }
 function turnLeft() {
 	var x = 0;
 	var y = 0;
 	var w = 0.2;
 	RobotRemoteControl.RobotSpeedControl(x, y, w);
 	console.log("向左");
 }
 function turnRight() {
 	var x = 0;
 	var y = 0;
 	var w = -0.2;
 	RobotRemoteControl.RobotSpeedControl(x, y, w);
 	console.log("向右");
 }
 function turnDown() {
 	var x = -0.3;
 	var y = 0;
 	var w = 0;
 	RobotRemoteControl.RobotSpeedControl(x, y, w);
 	console.log("向下");
 }
 function setTarget() {
 	// RobotRemoteControl.SpeedControlTarget(16777343, 10088); 127.0.0.1
 	RobotRemoteControl.SpeedControlTarget(956410048, 10088); //192.168.1.57
 	
 }
function stopRobot(){
    var x = 0;
        var y = 0;
        var w = 0;
        RobotRemoteControl.RobotSpeedControl(x, y, w);
}
 	bodyLoad();

 //车体控制定时器
 var carTime;
 var controlModelImg;
 var controlModelImgLen;
 function getImgSrc(){
 	 controlModelImg=$("#htykmsID").attr("src").split("/");
 	 controlModelImgLen=controlModelImg.length;
 }
 function isMouseUp(){
	 stopRobot();
	 getImgSrc();
	 if(controlModelImg[controlModelImgLen-1]=="htykms2.png"){
		 clearInterval(carTime);
	 }
 }

 $(".car-a").mousedown(function(){
 	 getImgSrc();
	 if(controlModelImg[controlModelImgLen-1]=="htykms2.png"){
		 carTime=setInterval("turnLeft()",100);
	 }else{
		 alert("请先选择后台遥控模式");
	 }
 }).mouseup(function(){
	 isMouseUp();
 }).mouseout(function(){
	 isMouseUp();
 }) 
 
 $(".car-d").mousedown(function(){
	 getImgSrc();
	 if(controlModelImg[controlModelImgLen-1]=="htykms2.png"){
		 carTime=setInterval("turnRight()",100);
	 }else{
		 alert("请先选择后台遥控模式");
	 }
 }).mouseup(function(){
	 isMouseUp();
 }).mouseout(function(){
	 isMouseUp();
 })
 
 $(".car-w").mousedown(function(){
	 getImgSrc();
	 if(controlModelImg[controlModelImgLen-1]=="htykms2.png"){
		 carTime=setInterval("turnUp()",100);
	 }else{
		 alert("请先选择后台遥控模式");
	 }
 }).mouseup(function(){
	 isMouseUp();
 }).mouseout(function(){
	 isMouseUp();
 })
 
 $(".car-s").mousedown(function(){
	 getImgSrc();
	 if(controlModelImg[controlModelImgLen-1]=="htykms2.png"){
		 carTime=setInterval("turnDown()",100);
	 }else{
		 alert("请先选择后台遥控模式");
	 }
 }).mouseup(function(){
	 isMouseUp();
 }).mouseout(function(){
	 isMouseUp();
 })
 
 

var imgSrc="images/control/";
//录音功能
var voicestart=false;
$(".voice-start").click(function(){
	if(voicestart){
		ButtonPress('voice:stop');
		$(this).attr("src",imgSrc+'ly1.png');
		$(this).attr("title",'录音开始');
		voicestart=false;
	}else{
		ButtonPress('voice:start');
		$(this).attr("src",imgSrc+'ly2.png');
		$(this).attr("title",'录音结束');
		voicestart=true;
	}
})

//录像功能
var recordstart=false;
$(".record-start").click(function(){
	if(recordstart){
		ButtonPress('Record:stop');
		$(this).attr("src",imgSrc+'lx1.png');
		$(this).attr("title",'录像开始');
		recordstart=false;
	}else{
		ButtonPress('Record:start');
		$(this).attr("src",imgSrc+'lx2.png');
		$(this).attr("title",'录像结束');
		recordstart=true;
	}
})

//对讲功能
var talkstart=false;
$(".talk-start").click(function(){
	if(talkstart){
		ButtonPress('talk:stop');
		$(this).attr("src",imgSrc+'yydj1.png');
		$(this).attr("title",'对讲开始');
		talkstart=false;
	}else{
		ButtonPress('talk:start');
		$(this).attr("src",imgSrc+'yydj2.png');
		$(this).attr("title",'对讲结束');
		talkstart=true;
	}
})

//截图功能
var hover=false;
$(".catpic-start").hover(function(){

	if(hover){
		$(this).attr("src",imgSrc+'zp1.png');
		hover=false;
	}else{
		$(this).attr("src",imgSrc+'zp2.png');
		hover=true;
	}

}).click(function(){
	ButtonPress('CatPic:bmp');
})

//雨刷功能
var wiper=false;
$(".wiper").click(function(){
	if(wiper){
		ButtonPress('PTZ:wiperStop');
		$(this).attr("src",imgSrc+'ck1.png');
		$(this).attr("title",'雨刷开启');
		wiper=false;

	}else{
		ButtonPress('PTZ:wiperStart');
		$(this).attr("src",imgSrc+'ck2.png');
		$(this).attr("title",'雨刷关闭');
		wiper=true;
	}
})

//补光灯功能
var light=false;
$(".light").click(function(){
	if(light){
		ButtonPress('PTZ:lightStart');
		$(this).attr("src",imgSrc+'jqrkz1.png');
		$(this).attr("title",'补光灯开启');
		light=false;

	}else{
		ButtonPress('PTZ:lightStop');
		$(this).attr("src",imgSrc+'jqrkz2.png');
		$(this).attr("title",'补光灯关闭');
		light=true;
	}
})
//按键监听事件 都是大写的ascii码
//W 87
//A 65
//S 83
//D 68

//a 97
//s 115 
//w 119
//d 100
$(document).keydown(function(event){
	if($(".second").text()=="机器人遥控"){
		getImgSrc();
		if(controlModelImg[controlModelImgLen-1]=="htykms2.png"){
				if(event.keyCode==87){
					turnUp();
				}else if(event.keyCode==65){
					turnLeft();
				}else if(event.keyCode==83){
					turnDown();
				}else if(event.keyCode==68){
					turnRight();
				}
		}else if(event.keyCode==87 || event.keyCode==65 || event.keyCode==83 || event.keyCode==68){
			 alert("请先选择后台遥控模式");
		}
	}
}).keyup(function(){
	if($(".second").text()=="机器人遥控"){
		stopRobot();
	}
});