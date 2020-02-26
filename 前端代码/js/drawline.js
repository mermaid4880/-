	//机器人路线，画线

	//draw()调用在real-video.js文件的window.onload里
	function draw(){
		var c=document.getElementById("draw-line");
		var cxt=c.getContext("2d");
		cxt.beginPath();
		cxt.moveTo(68,255);
		cxt.lineTo(68,188);	
		cxt.lineTo(480,188);	
		cxt.lineTo(480,105);
		cxt.lineTo(550,105);
		cxt.strokeStyle="black";
		cxt.lineWidth=3;	
		cxt.stroke();
		cxt.closePath();
	}	
	
	//根据指定的参数画一条线
	function drawLine(x1,y1,x2,y2,color){
		var c=document.getElementById("draw-line");
		var cxt=c.getContext("2d");
		cxt.beginPath();
		cxt.moveTo(x1,y1);
		cxt.lineTo(x2,y2);	
		
		cxt.strokeStyle=color;
		cxt.lineWidth=5;	
		cxt.stroke();
		cxt.closePath();
	}
	
	//清空地图
	function clearDrawLine(){
		var c=document.getElementById("draw-line");
		var cxt=c.getContext("2d");
		
		cxt.clearRect(0,0,$("#draw-line").attr("width"),$("#draw-line").attr("height"));
	}

	//贝塞尔曲线图
	// cxt.beginPath();
	// cxt.moveTo(65,255);
	// cxt.bezierCurveTo(65,255,65,170,80,170);
	// cxt.bezierCurveTo(80,170,180,170,280,170);
	// cxt.strokeStyle="red";
	// cxt.lineWidth=3;	
	// cxt.stroke();
	// cxt.closePath();
	function laserPoint(){
		var laserRobotLeft=parseFloat($("#laserRobot").css("left"));
		var laserRobotTop=parseFloat($("#laserRobot").css("top"));
		var laserGraphWidth=parseFloat($("#laserGraph").css("width"));
		var laserGraphHeight=parseFloat($("#laserGraph").css("height"));
		//console.log("laserRobotLeft="+laserRobotLeft+",laserRobotTop="+laserRobotTop);
		foundRadarOne(laserRobotLeft,laserRobotTop,laserGraphWidth,laserGraphHeight);
		
	}
	/**
	 * liangqin
	 * 显示机器人图标
	 */
	 sceneZoom=1;
	function robot_postion(x, y,paramet){
		//在彩图上显示
/*		var c=document.getElementById("draw-line");
		var cxt=c.getContext("2d");
		cxt.beginPath();
		cxt.moveTo(x,y);
		cxt.lineTo(x,y);
		cxt.closePath();*/

		//传过来一个弧度来计算角度
		var degree=0;
		paramet=-paramet;

		if(paramet>0){
			degree=paramet*180/Math.PI+90;	
		}else{
			degree=paramet*180/Math.PI+90;
		}
 
 		if(sceneZoom){
			$(".robot").css({"left":x*sceneZoom,"top":y*sceneZoom,"transform":"rotate("+degree+"deg)"}); //改变机器人位置
		}
	}
	
	/**
	 * liangqin
	 * 初始定位上的机器人显示
	 */
	function robot_position2(x, y, paramet){	
		//在初始定位图上显示
/*		var d=document.getElementById("laser-dot");
		var cxtd=d.getContext("2d");
		cxtd.beginPath();
		cxtd.moveTo(x,y);
		cxtd.lineTo(x,y);
		cxtd.closePath();*/
		//传过来一个弧度来计算角度
		var degree=0;
		paramet=-paramet;

		if(paramet>0){
			degree=paramet*180/Math.PI+90;	
		}else{
			degree=paramet*180/Math.PI+90;
		}
		
		var laserDotWidth=$("#laser-dot").attr("width");
		var laserDotHeight=$("#laser-dot").attr("height");

		if(pZoom==0){
			$(".laserRobot").css({"left":x+"px","top":y+"px","transform":"rotate("+degree+"deg)"}); //改变机器人位置
			$("#laser-dot").css({"left":x+"px","top":y+"px","transform":"rotate("+degree+"deg)","marginLeft":-laserDotWidth/2+"px","marginTop":-laserDotHeight/2+"px"}); //改变激光点画布的位置
		}else{
			$(".laserRobot").css({"left":pZoom*x+"px","top":pZoom*y+"px","transform":"rotate("+degree+"deg)"}); //改变机器人位置
			$("#laser-dot").css({"left":pZoom*x+"px","top":pZoom*y+"px","transform":"rotate("+degree+"deg)","marginLeft":-pZoom*(laserDotWidth/2)+"px","marginTop":-pZoom*(laserDotHeight/2)+"px"}); //改变激光点画布的位置
		}
		//显示激光图，这样就只有一闪一闪的现象，不会出现移位的样子了
		$("#laser-dot").show();

	}
	
	
	
	
	
	
	
	//机器人运动
//	function robot(){
//		var c=document.getElementById("draw-line");
//		var cxt=c.getContext("2d");
//		cxt.beginPath();
//		cxt.moveTo(robotSiteX,robotSiteY);
//		if(robotSiteY>188){
//		  robotSiteY=robotSiteY-1;
//		}else{
//			robotSiteX=robotSiteX+1;
//		}
//
//		cxt.lineTo(robotSiteX,robotSiteY);
//		cxt.strokeStyle="green";
//		cxt.lineWidth=4;	
//		cxt.stroke();
//		cxt.closePath();
//		$(".robot").css({"left":robotSiteX,"top":robotSiteY}); //改变机器人位置
//	}
//	
//	var robotSiteX=68,robotSiteY=255;
//	var self=setInterval("robot()",1000);

