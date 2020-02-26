		
		/*
		 * 页面加载进来以后，将所有画布的长宽重置为图片背景图的长宽 10.16
		 * 
		 * */
		var initCanvasWidth=0;
		var sceneGraphImgWidth;
		var sceneGraphImgHeight;
		var data=[];
		var areaCanvas=document.getElementById("maintenance-area");
		var cxtArea=areaCanvas.getContext("2d");

		var laserGraph=document.getElementById("laserGraph");
		var changeCanvasX,changeCanvasY,changeCanvas=false;
		var pZoom=0;
		var sceneZoom=1;
		var standardHeight=false;

		var laserRobotWidth=$("#laserRobot").width();
		var laserRobotHeight=$("#laserRobot").height();
		function initLaserSize(){
			var laserGraph=document.getElementById("laserGraph");

			//sceneMapStandardW sceneMapStandardH来自index.jsp
			
			laserGraph.style.width=sceneMapStandardW;
			laserGraph.style.height=sceneMapStandardH;


			var newWidth=parseFloat(laserGraph.style.width);
			var newHeight=parseFloat(laserGraph.style.height);

			var laserRobot=document.getElementById("laserRobot");
			var robotLeft=parseFloat(laserRobot.style.left);			
			var robotTop=parseFloat(laserRobot.style.top);
			
			//用于drawline.js的全局变量
			pZoom=newWidth/initCanvasWidth;


			//画布改变大小
			var robotLeft=$("#laserRobot").css("left");
			var robotTop=$("#laserRobot").css("top");
			$("#laser-dot").css({"left":robotLeft,"top":robotTop,"marginTop":-sceneMapStandardH/2,"marginLeft":-sceneMapStandardW/2});
		}
		function initSceneSize(){
			var sceneGraph=document.getElementById("sceneGraph");

			//sceneMapStandardW sceneMapStandardH来自index.jsp
			
			sceneGraph.style.width=laserMapW;
			sceneGraph.style.height=laserMapH;


			var newWidth=parseFloat(sceneGraph.style.width);
			var newHeight=parseFloat(sceneGraph.style.height);

			var sceneRobot=document.getElementById("robot");
			var robotLeft=parseFloat($(".robot").css("left"));			
			var robotTop=parseFloat($(".robot").css("top"));
 
			sceneZoom=newWidth/initCanvasWidth;

			$("#draw-line").css({"width":laserMapW,"height":laserMapH});
			//$(".robot").css({"left":newWidth/oldWidth*robotLeft,"top":newWidth/oldWidth*robotTop});
		}
		$(function(){

			
/*			var oldmapwidth=$("#map").width();
			$("#map").css("height","450px");
			var scaleSize=$("#map").width()/oldmapwidth;
			$("#laserRobot").css({"width":laserRobotWidth*scaleSize,"height":laserRobotHeight*scaleSize});*/
			sceneGraphImgWidth=sceneMapStandardW;
			sceneGraphImgHeight=sceneMapStandardH;

			//console.log(sceneGraphImgWidth);
 
	
			$("#laserGraph").width(sceneGraphImgWidth).css("left",($("#contextmenu").width()-parseFloat(sceneMapStandardW))/2);
			$("#laserGraph").height(sceneGraphImgHeight);
			$("#laserGraph #cover").attr("width",sceneGraphImgWidth);
			$("#laserGraph #cover").attr("height",sceneGraphImgHeight);
			$("#laser-dot").attr("width",sceneGraphImgWidth);
			$("#laser-dot").attr("height",sceneGraphImgHeight);
			initCanvasWidth=$("#laserGraph").width();
 
			$("#maintenance-area").attr("width",sceneGraphImgWidth);
			$("#maintenance-area").attr("height",sceneGraphImgHeight);
			$("#draw-line").attr("width",sceneGraphImgWidth);
			$("#draw-line").attr("height",sceneGraphImgHeight); 
			$("#sceneGraph").width(parseFloat(laserMapW)).animate({"left":parseFloat($("#contextmenu").width()-parseFloat(laserMapW))/2},1000);
 
			$("#sceneGraph").height(laserMapH);
			$("#map").css("height","100%");
			$("#map").css("width","100%");


 			$(".fullScreen").click(function(){
 				if($(".fullScreen").text()=="退出全屏"){
 					$(".OCXBody").show();
 					$("#contextmenu").css({"position":"relative","z-index":"0","width":"auto","height":"450px"});
 					$(".fullScreen").text("全屏操作");
 				}else{	
 					$(".OCXBody").hide();
 					$("#contextmenu").css({"position":"fixed","top":"0px","left":"0px;","z-index":"1000","width":"100%","height":"100%"});
 					$(".fullScreen").text("退出全屏")
 				}
 				count=100;
				Resize(count);
				 			//开启全部显示地图的开关

 				$("#sceneGraph").css({"left":($("#contextmenu").width()-parseFloat(laserMapW))/2,"top":"0px"});
 				$("#laserGraph").css({"left":($("#contextmenu").width()-parseFloat(sceneMapStandardW))/2,"top":"0px"});
				initLaserSize(); 
				initSceneSize();
 			})
 
 			//开启全部显示地图的开关
			initLaserSize(); 
			initSceneSize();

 			//画出检修区域
 			 ajax_getArea();
		});
		//获取地图信息
		function getMapPos(){
			$.ajax({
				type:"POST",
				async:false,
				url:"robotReportInfo/getStationMapInfo.do",
				success:function(data){
					minX = data.data.minX;
					minY = data.data.minY ;
					maxX = data.data.maxX;
					maxY = data.data.maxY ;		
					resolution = data.data.resolution;
				}
			})
		}	

		//坐标与地图位置转换
		function posToMap(posX,posY){
			getMapPos();
			var proportion= (maxX-minX)/sceneGraphImgWidth;
			var x = (posX-minX)/proportion;
			var y = (maxY-posY)/proportion;
			x_y = {"x" : x, "y" : y}; 
			return x_y;
		}

		//重画检修区域
		function drawMaintenanceArea(){

			//清除画布
			clearCanvas();
			for(var i=0;i<data.length;i++){
				// alert(JSON.stringify(data[i]));
				var dataObj =  data[i] ;
				cxtArea.beginPath();
				cxtArea.strokeRect(dataObj.startX,dataObj.startY,dataObj.endX-dataObj.startX,dataObj.endY-dataObj.startY);
				cxtArea.strokeStyle="#348A11";
				cxtArea.lineWidth=2;	
				cxtArea.stroke();
				cxtArea.closePath();
			}
 
		}
		//清空区域
		function clearCanvas(){
			if($("#maintenance-area").width()<sceneGraphImgWidth || $("#maintenance-area").width()<sceneGraphImgHeight){
				cxtArea.clearRect(0,0,sceneGraphImgWidth,sceneGraphImgHeight);
			}else{
				cxtArea.clearRect(0,0,$("#maintenance-area").width(),$("#maintenance-area").height());
			}
		}
	 	//获取所有的检修区域
		function ajax_getArea(){
	   		$.ajax({
				type: "POST",
				async:false,
				url: "substation/getRepairAreaInfo.do?time=" + Math.random(),
				success: function(result){
					if(result.result==1){
						for(var i=0;i<result.data.length;i++){
		 
							//循环读取检修区域数组并将场地坐标转换成地图上的x,y
							var startPos=posToMap(result.data[i].startX,result.data[i].startY); //转换开始点坐标
							result.data[i].startX=startPos.x;  //将开始的两个点的坐标重新赋值为转换后的坐标
							result.data[i].startY=startPos.y;
							var endPos=posToMap(result.data[i].endX,result.data[i].endY); //转换结束点坐标
							result.data[i].endX=endPos.x;     //将结束的两个点的坐标重新赋值为转换后的坐标
							result.data[i].endY=endPos.y;
							data[i]=result.data[i];
		 
						}	
						// alert(JSON.stringify(result)); 
						drawMaintenanceArea();
						drawMaintenanceArea();
					}else{
						//alert("检修区域数据失败！");
					}

				},
				error:function(err){
					alert(err);
				}
			});
		}



		fnWheel(laserGraph,function (down,oEvent){

			var oldWidth=this.offsetWidth;
			var oldHeight=this.offsetHeight;
			var oldLeft=this.offsetLeft;
			var oldTop=this.offsetTop;



			var scaleX=(oEvent.clientX-oldLeft)/oldWidth;//比例
			var scaleY=(oEvent.clientY-oldTop)/oldHeight;



			//控制放大缩小0.1倍数
			if (down){
				this.style.width=this.offsetWidth*0.9+"px";
				this.style.height=this.offsetHeight*0.9+"px";
				// laserRobotWidth=$("#laserRobot").width();
				// laserRobotHeight=$("#laserRobot").height();
			 //  $("#laserRobot").css({"width":laserRobotWidth*0.9,"height":laserRobotHeight*0.9});
			}
			else{
				this.style.width=this.offsetWidth*1.1+"px";
				this.style.height=this.offsetHeight*1.1+"px";
				// laserRobotWidth=$("#laserRobot").width();
				// laserRobotHeight=$("#laserRobot").height();
			 //  $("#laserRobot").css({"width":laserRobotWidth*1.1,"height":laserRobotHeight*1.1});
			}



			var newWidth=parseFloat(this.offsetWidth);
			var newHeight=parseFloat(this.offsetHeight);

			var laserRobot=document.getElementById("laserRobot");
			var robotLeft=parseFloat(laserRobot.style.left);			
			var robotTop=parseFloat(laserRobot.style.top);
			
			//用于drawline.js的全局变量
			pZoom=newWidth/initCanvasWidth;
			
			 zoom=newWidth/oldWidth;
			 console.log("pZoom="+pZoom+",zoom="+zoom);




			laserRobot.style.left=zoom*robotLeft+"px";
			laserRobot.style.top=zoom*robotTop+"px";

			this.style.left=oldLeft-scaleX*(newWidth-oldWidth)+"px";
			this.style.top=oldTop-scaleY*(newHeight-oldHeight)+"px";
				//画布改变大小
				var robotLeft=$("#laserRobot").css("left");
				var robotTop=$("#laserRobot").css("top");
				$("#laser-dot").css({"left":robotLeft,"top":robotTop,"marginTop":-$("#laser-dot").height()/2,"marginLeft":-$("#laser-dot").width()/2});
//			}
			
		});
		fnWheel(sceneGraph,function (down,oEvent){

			var oldWidth=this.offsetWidth;
			var oldHeight=this.offsetHeight;
			var oldLeft=this.offsetLeft;
			var oldTop=this.offsetTop;



			var scaleX=(oEvent.clientX-oldLeft)/oldWidth;//比例
			var scaleY=(oEvent.clientY-oldTop)/oldHeight;



			//控制放大缩小0.1倍数
			if (down){
				this.style.width=this.offsetWidth*0.9+"px";
				this.style.height=this.offsetHeight*0.9+"px";
				$("#draw-line").css({"width":this.style.width,"height":this.style.height});
			}
			else{
				this.style.width=this.offsetWidth*1.1+"px";
				this.style.height=this.offsetHeight*1.1+"px";
				$("#draw-line").css({"width":this.style.width,"height":this.style.height});
			}



			var newWidth=parseFloat(this.offsetWidth);
			var newHeight=parseFloat(this.offsetHeight);

			var sceneRobot=document.getElementById("robot");
			var robotLeft=parseFloat($(".robot").css("left"));			
			var robotTop=parseFloat($(".robot").css("top"));
 
			sceneZoom=newWidth/initCanvasWidth;
 
			this.style.left=oldLeft-scaleX*(newWidth-oldWidth)+"px";
			this.style.top=oldTop-scaleY*(newHeight-oldHeight)+"px";
			$(".robot").css({"left":newWidth/oldWidth*robotLeft,"top":newWidth/oldWidth*robotTop});
 
		});
		//机器人运动区域移动事件
		var isDown = false;
		var rotate=true; //默认为true，能拖动地图不能旋转机器人
		var ctrl=false;  //默认为false，能拖动地图
		var ObjLeft, ObjTop, posX, posY, obj;
		drag("sceneGraph");
		function drag(element){
			obj = document.getElementById(element);
			obj.style.cursor="move";
			obj.style.cursor = "-webkit-grab";
			obj.onmousedown = down;
			obj.onmousemove = move;
			obj.onmouseup = up;
		}			

		function down(event) {
			if(event.which==1 && rotate){
			isDown = true;
			ObjLeft = obj.offsetLeft;
			ObjTop = obj.offsetTop;
			posX = parseInt(mousePosition(event).x);
			posY = parseInt(mousePosition(event).y);
			}
		}

		function move(event) {
			if (isDown == true) {
				var x = parseInt(mousePosition(event).x - posX + ObjLeft);
				var y = parseInt(mousePosition(event).y - posY + ObjTop);
				var w = document.documentElement.clientWidth - obj.offsetWidth;
				var h = document.documentElement.clientHeight - obj.offsetHeight;

				obj.style.left = x + 'px';
				obj.style.top = y + 'px';
			}
		}

		function up() {
		  isDown = false;
		}
		
		function mousePosition(evt) {
			var xPos, yPos;
			evt = evt || window.event;
			xPos = evt.pageX;
			yPos = evt.pageY;
			return {
				x: xPos,
				y: yPos
			}
		}


	//滚轮方法机器人运动区域	
	var count=100;
	function Counting(count){
		if(event.wheelDelta>=120){
			count=count+5;
		}
		else if(event.wheelDelta<=-120){
/*			if(count>90){
				count=count-5;
			}*/
			count=count-5;
		}
		return count;
	}
	function Picture(){

		count=Counting(count);
		Resize(count);
		return false;
	}
	function Resize(count){
		var sceneGraph=document.getElementById("sceneGraph");		
		sceneGraph.style.zoom=count+'%';
	}

	//laser-dot上面画点

	function drawPoint(x,y){
		flag=false;
		var p=new Array(2);
		p[0]=x;p[1]=y;
		cxt.beginPath();
		cxt.lineWidth=1;
		cxt.moveTo(p[0],p[1]);
		cxt.lineTo(p[0]+1,p[1]+1);
		cxt.strokeStyle="red";
		cxt.stroke();
		cxt.closePath();
	}
	var c=document.getElementById("laser-dot");
	var cxt=c.getContext("2d");
	
	//机器人后方361个点
	function showRadar361(){ 
		var laserRobotLeft=parseFloat($("#laserRobot").css("left"));
		var laserRobotTop=parseFloat($("#laserRobot").css("top"));
		var laserGraphWidth=parseFloat($("#laserGraph").css("width"));
		var laserGraphHeight=parseFloat($("#laserGraph").css("height"));
		foundRadarOne(laserRobotLeft,laserRobotTop,laserGraphWidth,laserGraphHeight);
		
	}
		var container = $$("laserRobot"), src = "images/control/robot.png",
		options = {
				// onPreLoad: function(){ container.style.backgroundImage = "url('loading.gif')"; },
				onLoad: function(){ container.style.backgroundImage = "images/control/robot.png"; },
		},
		it = new ImageTrans( container, options );
		it.load(src);

	//地图中机器人选点
	var mouseX,mouseY,offsetX,offsetY,_x,_y,zoom;
	var stopMove=true;
	var oldX=0;
	var oldY=0;
	var num=0;
	var robotRotate=false;
	$("#laserGraph").mousedown(function(e){
		if(e.which==1){
			robotRotate=true;
		}
		if(ctrl && e.which==1){
				mouseX=e.pageX;
				mouseY=e.pageY;
				offsetX=parseInt($(this).offset().left);
				offsetY=parseInt($(this).offset().top);
				//如果是IE浏览器
				//zoom=parseFloat($(this).css("zoom"))/100;		
				//如果是谷歌浏览器
				// zoom=parseFloat($(this).css("zoom"));
				_x=parseFloat(mouseX-offsetX);
				_y=parseFloat(mouseY-offsetY);

				changeCanvasX=_x;
				changeCanvasY=_y;
				changeCanvas=true;
				
				//当鼠标第二次单击的时候还在第一次单击的范围内就不移动机器人
/*				if(oldX>=_x-12.5 && oldX<=_x+12.5 && oldY>=_y-14 && oldY<=_y+14){
					stopMove=false;
				}else{*/
					$("#laserRobot").css({"left":_x+"px","top":_y+"px"});
					$("#laser-dot").css({"left":_x+"px","top":_y+"px","marginTop":-$("#laser-dot").height()/2,"marginLeft":-$("#laser-dot").width()/2});
					$("#rotate img").css({"left":_x+"px","top":_y+"px"});
/*				}*/
				oldX=_x;
				oldY=_y;

		}
	}).mousemove(function(){
		if(ctrl && robotRotate){

			rotate=false;
			$("#laserRobot").css("transform",$("#laserRobot img").css("transform"));
			$("#laser-dot").css("transform",$("#laserRobot img").css("transform"));
			//console.log($("#laserRobot img").css("transform"));
		}
	}).mouseup(function(){ 
		num++;
		robotRotate=false;
		if(ctrl && num>=2){
	 		//$(".select_site_start").text("开始选择");
			$(".select_site_start").text("开始定位");
			isSelect=false;
			ctrl=false; //开启地图拖动
			rotate=true; //关闭旋转功能
			changeCanvas=false;
			
			var laserGraphWidth=parseFloat($("#laserGraph").css("width"));
			var laserGraphHeight=parseFloat($("#laserGraph").css("height"));

			var laserRobotLeft=parseFloat($("#laserRobot").css("left"));
			var laserRobotTop=parseFloat($("#laserRobot").css("top"));
			//var degress = parseFloat(parameter/3.14*180); 
			var isSetRobotPos=setRobotPos(laserGraphWidth,laserGraphHeight,laserRobotLeft,laserRobotTop,parameter,0,0);
			if(isSetRobotPos){
				$(".select_site_start").attr("data-site","false");
			}
			num=0;
		}
	})

	//右键菜单禁用
	var menu=document.getElementById("contextmenu");
	menu.oncontextmenu=function(){
		return false;
	}
	//控制显示菜单
	$("#contextmenu").mousedown(function(e){
		if(e.which==3){
			mouseX=e.pageX;
			mouseY=e.pageY;
			offsetX=parseInt($(this).offset().left);
			offsetY=parseInt($(this).offset().top);
			_x=parseFloat(mouseX-offsetX);
			_y=parseFloat(mouseY-offsetY);
			$("#menu").css({"left":_x,"top":_y}).show();
/*			var contextmenuHeight=$("#contextmenu").height();
			var contextmenuWidth=$("#contextmenu").width();
			var menuWidth=$("#menu").width();
			var menuHeight=$("#menu").height();

			//设置快捷菜单位置，上下两边居中显示在鼠标的右侧
			$("#menu").css({"left":e.pageX,"top":(contextmenuHeight-menuHeight)/2}).show();

			//判断是否出右边边界
			var menuLeft=parseInt($("#menu").css("left"));
			if(menuLeft>(contextmenuWidth-menuWidth)){
				$("#menu").css("left",(contextmenuWidth-menuWidth)+"px");
			}*/
		}
	}).click(function(){
		$("#menu").hide();
	})

	$("body").click(function(){
		$("#menu").hide();
	}).keydown(function(e){ 
		if(e.which==27 && $(".fullScreen").text()=="退出全屏"){
			$(".OCXBody").show();
			$("#contextmenu").css({"position":"relative","z-index":"0","width":"auto","height":"450px"});
			$(".fullScreen").text("全屏操作");
			$("#sceneGraph").css({"left":($("#contextmenu").width()-parseFloat(sceneMapStandardW))/2,"top":"0px"});
			$("#laserGraph").css({"left":($("#contextmenu").width()-parseFloat(sceneMapStandardW))/2,"top":"0px"});
			initLaserSize(); 
			initSceneSize();
		}
	})

	//是否初始定位
	var isInitial=false;
	$(".initial_site").click(function(){
		if(isInitial){
			$("#sceneGraph").show();
			$("#laserGraph").hide();
			isInitial=false;
			$(this).text("初始定位");
			$("#menu .select_site_start").hide();
			count=100;
			Resize(count);
			rotate=true;
			drag("sceneGraph");
			//地图归位
			$("#sceneGraph").css({"left":($("#contextmenu").width()-parseFloat(laserMapW))/2,"top":"0px"});
			$("#laserGraph").css({"left":($("#contextmenu").width()-parseFloat(sceneMapStandardW))/2,"top":"0px"});
			initLaserSize(); 
			initSceneSize();
		}else{
			$("#sceneGraph").hide();
			$("#laserGraph").show();
			isInitial=true;
			$(this).text("结束定位");
			$(".select_site_start").show();
			drag("laserGraph");
			showRadar361();
			count=100;
			Resize(count);
			//地图归位
			$("#sceneGraph").css({"left":($("#contextmenu").width()-parseFloat(laserMapW))/2,"top":"0px"});
			$("#laserGraph").css({"left":($("#contextmenu").width()-parseFloat(sceneMapStandardW))/2,"top":"0px"});
			initLaserSize(); 
			initSceneSize();
		}
	})

//机器人位置选择
	$(".select_site_start").attr("data-site","false");
	var isSelect=false;
	$(".select_site_start").click(function(){
 
		ctrl=true;  //开始定位，地图锁定
		rotate=false; //定位中，开启旋转功能
		num=0; //判断机器人的单击次数
		
		$(".select_site_start").attr("data-site","true");
	})

	//ajax代码与后台交互



	/**
	 * 取消当前任务
	 */
	function cancelNowTask(){
   		$.ajax({
			type: "GET",
			url: "robotControlInfo/cancelTask.do?time=" + Math.random(),
			//beforeSend: validateData,
			async:false,
			success: function(data){
				/*alert(data.message);*/
				var canvasWidth=$("#laserGraph").width();
				var canvasHeight=$("#laserGraph").height();
				var c=document.getElementById("draw-line");
				var cxt=c.getContext("2d");
				cxt.clearRect(0,0,canvasWidth,canvasHeight);
			},
			error:function(){
				alert("error");
			}
		});
	}
	//画出返航路线
	function drawToStartLine(x1,y1,x2,y2,color){
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
	function toStartShowPath(){
		/**
		 * liangqin 获取当前巡检任务所需要经过的巡检路径ID列表
		 */
		$.ajax({
			type:"post",
			async:false,
			url:"robotReportInfo/getPatrolEdgeInfo.do",
			success:function(data){
				
				for(var i = 0 ; i < data.data.length ; i++){
									
					var pos1 = transPostionOnColor(data.data[i].startX,data.data[i].startY);
					var pos2 = transPostionOnColor(data.data[i].endX,data.data[i].endY);
					
					drawToStartLine(pos1.px_x,pos1.px_y,pos2.px_x,pos2.px_y,"red");
				}
			},
			error:function(){
				alert("获取路径失败！");
			}
		});
	}
	function isHaveTask(){
		//如果Is_Have_Task是4表示暂停状态，快捷菜单显示恢复任务 
		if(Is_Have_Task==4){
			$("#robot_topause").html("恢复任务"); 
			$("#robot_topause_value").val(0);
		}
	}
    //一键返航，自主充电任务
    $("#robot_tostart").click(function (){
    	TASKMODE();
		$.ajax({
   			type:"post",
			async:false,
			url: "robotControlInfo/autoChargeTask.do?time=" + Math.random(),
			//beforeSend: validateData,
			success: function(data){
				toStartShowPath();
			},
			error:function(){
				alert("error");
			}
		});
	});
	//暂停  恢复当前机器人任务 robotTopauseValue=1是暂停 robotTopauseValue=0是恢复
	isHaveTask(); //判断是否为暂停状态
	$("#robot_topause").click(function (){
       	var robotTopauseValue = $("#robot_topause_value").val();
   		$.ajax({
			type: "GET",
			url: "robotControlInfo/pauseTask.do?random=" + Math.random(),
	    	data: {"whetherServer":robotTopauseValue},
			dataType:'json',
			//beforeSend: validateData,
			success: function(data){
				if(data.result==1){

					if(robotTopauseValue==1){
						$("#robot_topause").html("恢复任务");
						$("#robot_topause_value").val(0);
						
					}else{
						$("#robot_topause").html("暂停任务");
						$("#robot_topause_value").val(1);
					}
				}else{
					alert("发生错误");
				}
			},
			error:function(){
				alert("error");
			}
		});
	});
	//取消终止当前机器人任务
	$("#robot_tostop").click(cancelNowTask);
	 	//修改机器人当前控制模式 robotTopauseValue=1是暂停 robotTopauseValue=0是恢复
	$(".robot_tochange_cantrol").click(function (){
		/*var robotTopauseValue = $(this).index()+1;
   		$.ajax({
					type: "GET",
					url: "robotControlInfo/changeRobotControlMode.do?random=" + Math.random(),
			    	data: {"controlMode":robotTopauseValue},
					dataType:'json',
					//beforeSend: validateData,
					success: function(data){
						if(data.result==1){
							alert(data.message);
						}else{
							alert(data.message);
						}
					},
					error:function(){
						alert("error");
					}
		});*/
	});
	
	
