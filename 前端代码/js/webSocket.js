/**
 * Auhtor:Cuijiekun
 * Date	 :2016年8月28日08:31:29
 * Desc  :用于连接后台，接收机器人的给我们的webService发送的数据
 * 
 * 
 * 
 *  <script src="js/ligerDrag.js" type="text/javascript"></script>
    <script src="js/ligerDialog.js" type="text/javascript"></script>
    <script src="js/ligerResizable.js" type="text/javascript"></script>
	<script src="js/msgType.js" type="text/javascript"></script>
	<script src="js/webSocket.js" type="text/javascript"></script>
 */

var temp_x;
var temp_y;
var temp_angle;

var setLaserData_time = 4; //雷达的发送次数
var set_robot_alarm_info_Time = 0; //系统告警信息的发送次数

//机器人当前模式
var Robot_Now_Mode ="";

//机器人是否正在执行任务
var Is_Have_Task ="";

//缓存设备巡检信息
var maingridData=[];

//缓存设备巡检异常信息
var secondgridData=[];

//缓存机器人异常报文
var thirdgridData=[];

//报文信息未读条数
var realInfoUnread=0;

//告警信息未读条数
var deviceAlarmUnread=0;
var systemAlarmUnread=0;

//告警等级用于显示不同等级之间的颜色
var main_alarm_level_color="";
var device_alarm_level_color="";
var system_alarm_level_color="";

$(function(){
	
//	drawLine(0,0,100,100,"green");

	var webSocket = new WebSocket('ws://'+window.location.host+'/robot/robotService');

	webSocket.onerror = function(event) {
		alert("socket通信出现错误！");
	};

	webSocket.onopen = function(event) {

	};
	//接收到后台消息进行处理
	webSocket.onmessage = function(event) {
		
		
		var str = event.data;
		
	    //console.log("onmessage:" + str);
		
		var jsonData = JSON.parse(str);
		
		var msgType = jsonData.msgType;
	

		
		if(msgType == MsgType.set_robot_control_mode){
			Robot_Now_Mode = jsonData.data;
		}
		
		if(msgType == MsgType.set_current_task_status){
			
			
			console.log("Is_Have_Task:" + Is_Have_Task 
					+ ",jsonData.data.current_task_status:" + jsonData.data.current_task_status
					+ ",Robot_Now_Mode:" + Robot_Now_Mode);
			
			//这样说明是从任务模式切换到其他模式，清除路线
			/*if(Is_Have_Task == "1" && jsonData.data.current_task_status != "1"){
				
			} 
			
			//从其他状态切换到 任务状态，画出所有路线
			if(Is_Have_Task != "1" && jsonData.data.current_task_status == "1"){
				drawRunningPath();
			} */
			
			if(Is_Have_Task != jsonData.data.current_task_status && Robot_Now_Mode != "2"){
				clearDrawLine();
				drawRunningPath();
			}
			
			Is_Have_Task = jsonData.data.current_task_status;
		}
		
		if(msgType == MsgType.set_device_alarm_info){
			deviceAlarmSound(jsonData);
		}

		if(msgType == MsgType.set_robot_alarm_info){
			systemAlarmSound(jsonData); 
		}
		
		if ( $(".second").text() != "机器人遥控" && $(".second").text() != "巡检监控" && $(".second").text() !="机器人管理" ){
			
			return
		}
		
		if(msgType == MsgType.set_patrol_finish_edge){
			set_patrol_finish_edge(jsonData);
			
		}else if(msgType == MsgType.set_robot_pos){
			set_robot_pos(jsonData);
			
		}else if(msgType == MsgType.set_current_task_status){
			set_current_task_status(jsonData);
			
		}else if(msgType == MsgType.set_device_info){
			set_device_info(jsonData);
			
		}else if(msgType == MsgType.set_device_alarm_info){
			set_device_alarm_info(jsonData);
			
		}else if(msgType == MsgType.set_robot_alarm_info){
			set_robot_alarm_info_Time ++ ;
			if(set_robot_alarm_info_Time % 1==0){
				set_robot_alarm_info(jsonData);
			}
		}else if(msgType == MsgType.set_robot_long_time_pause){
			set_robot_long_time_pause(jsonData);
			
		}else if(msgType == MsgType.set_robot_long_time_idel){
			set_robot_long_time_idel(jsonData);
			
		}else if(msgType == MsgType.set_robot_control_mode){
			set_robot_control_mode(jsonData);
			
		}else if(msgType == MsgType.setLaserData){
			setLaserData_time ++ ;
			if(setLaserData_time % 1==0){
				if($(".second").text()=="机器人遥控"){
//					console.log(JSON.stringify(jsonData));
					setLaserData1(jsonData);
				}
			}
		}else if(msgType == MsgType.drawSoundPoint){
			if($(".second").text()=="机器人遥控"){
				drawSoundPoint(jsonData);
			}
		}

	};

});


//1,上传当前巡检任务已经经过的路径ID列表
function set_patrol_finish_edge(jsonData){
	
	//console.log( "上传当前巡检任务已经经过的路径ID列表:" + JSON.stringify(jsonData));
	
	for(var i = 0 ; i < jsonData.data.length ; i++){
		var x1 = jsonData.data[i].startX;
		var y1 = jsonData.data[i].startY;
		var x2 = jsonData.data[i].endX;
		var y2 = jsonData.data[i].endY;
		
		var t_p1 = transPostionOnColor(x1,y1);
		
		var t_p2 = transPostionOnColor(x2,y2);
		
		//drawLine(x1,y1,x2,y2,"green");
		drawLine(t_p1.px_x,t_p1.px_y,t_p2.px_x,t_p2.px_y,"blue");
	}
	
}

//2,上传机器人当前位置（包括云台位置）
function set_robot_pos(jsonData){
		var x = jsonData.data.posX;
		var y = jsonData.data.posY;
		var px_pos = transPostionOnColor(x*1000,y*1000);
		var angle = jsonData.data.angle;
		robot_postion(px_pos.px_x,px_pos.px_y,angle);
		temp_x = px_pos.px_x;
		temp_y = px_pos.px_y;
		temp_angle = angle;	
		
		//console.log(JSON.stringify(jsonData));
		//console.log(JSON.stringify(px_pos));
		
		if($(".select_site_start").attr("data-site")=="false"){
			robot_position2(temp_x,temp_y,temp_angle);
		}
}




//3,上传某机器人当前正在执行的任务状态
function set_current_task_status(jsonData){
	$("#task_desc").text(jsonData.data.task_desc);
	$("#total_device_count").text(jsonData.data.total_device_count);
	$("#error_device_count").text(jsonData.data.error_device_count);
	$("#currnet_inspection_id").text(jsonData.data.currnet_inspection_id);
	
	//将时间转换为xx小时xx分钟xx秒的格式
	var total = jsonData.data.estimated_time;
	var hours = parseInt( total / 3600);
	var minutes = parseInt( (total-hours*3600) / 60 );
	var seconds = parseInt( total - hours*3600 - minutes*60 );
	var timeStr = hours + "小时" + minutes + "分钟" + seconds + "秒";
	
	$("#estimated_time").text(timeStr);
	
	$("#patrol_progress").text(jsonData.data.patrol_progress + "%");
	$("#finish_device_count").text(jsonData.data.finish_device_count);
	
	
	
	
	Is_Have_Task = jsonData.data.current_task_status;
	
	
	
}


/*
	重新打开机器人管理 机器人遥控 巡检监控 时加载报警信息
	在control.js初始加载报警信息表格时调用reloadAlarmIfo()
*/
function reloadAlarmIfo(){
	var maingridManager = $("#maingrid").ligerGetGridManager();
	var secondgridManager = $("#secondgrid").ligerGetGridManager();
	var thirdgridManager = $("#thirdgrid").ligerGetGridManager();
	maingridManager.loadData({Rows:maingridData,Total:maingridData.length});
	secondgridManager.loadData({Rows:secondgridData,Total:secondgridData.length});
	thirdgridManager.loadData({Rows:thirdgridData,Total:thirdgridData.length});
}
/* 
 * deviceAlarmSound()
 * systemAlarmSound()
 * 在任何一个页面都能播放报警声音
 * */
function deviceAlarmSound(jsonData){
	deviceAlarmUnread++;
	$("#deviceAlarm")[0].play();
	for(var i = 0 ; i < jsonData.data.length ; i++){
		
		//告警等级：0正常，1,2,3,4分别代表预警、一般告警、严重告警、危急告警
		var alarm_level = jsonData.data[i].alarm_level;
		var alarm_level_str = null;
		
		if(alarm_level == '1'){
			alarm_level_str = '预警';
			device_alarm_level_color="#0F9BD8";
		}else if(alarm_level == '2'){
			alarm_level_str = '一般告警';
			device_alarm_level_color="#B7C70B";
		}else if(alarm_level == '3'){
			alarm_level_str = '严重告警';
			device_alarm_level_color="#E0CE86";
		}else if(alarm_level == '4'){
			alarm_level_str = '危急告警';
			device_alarm_level_color="#F70209";
		}else if(alarm_level == '0'){
			alarm_level_str = '正常';
			device_alarm_level_color="#000";
		}
		
		secondgridData.unshift({
	    	time:"<span style='color:"+device_alarm_level_color+"'>"+jsonData.data[i].time+"</span>",
	    	device_desc:"<span style='color:"+device_alarm_level_color+"'>"+jsonData.data[i].device_desc+"</span>",
	    	patrol_type:"<span style='color:"+device_alarm_level_color+"'>"+jsonData.data[i].patrol_type+"</span>",
	    	patrol_value:"<span style='color:"+device_alarm_level_color+"'>"+jsonData.data[i].patrol_value+"</span>",
	    	alarm_level:"<span style='color:"+device_alarm_level_color+"'>"+alarm_level_str+"</span>",
	    	device_id:jsonData.data[i].device_id,
	    	target_id:jsonData.data[i].target_id
	    });
	}
}
function systemAlarmSound(jsonData){
	systemAlarmUnread++;
	$("#systemAlarm")[0].play();
	for(var i = 0 ; i < jsonData.data.length ; i++){

		//告警等级：0正常，1,2,3,4分别代表预警、一般告警、严重告警、危急告警
		var alarm_level = jsonData.data[i].alarm_level;
		var alarm_level_str = null;
		
		if(alarm_level == '1'){
			alarm_level_str = '预警';
			system_alarm_level_color="#0F9BD8";
		}else if(alarm_level == '2'){
			alarm_level_str = '一般告警';
			system_alarm_level_color="#B7C70B";
		}else if(alarm_level == '3'){
			alarm_level_str = '严重告警';
			system_alarm_level_color="#E0CE86";
		}else if(alarm_level == '4'){
			alarm_level_str = '危急告警';
			system_alarm_level_color="#F70209";
		}else if(alarm_level == '0'){
			alarm_level_str = '正常';
			system_alarm_level_color="#000";
		}
		
		thirdgridData.unshift({
	    	time:"<span style='color:"+system_alarm_level_color+"'>"+jsonData.data[i].time+"</span>",
	    	alarm_context:"<span style='color:"+system_alarm_level_color+"'>"+jsonData.data[i].alarm_context+"</span>",
	    	alarm_level:"<span style='color:"+system_alarm_level_color+"'>"+alarm_level_str+"</span>"
	    });
	}
}

//4,上传当前设备巡检信息
function set_device_info(jsonData){
	var manager = $("#maingrid").ligerGetGridManager();
	for(var i = 0 ; i < jsonData.data.length ; i++){
		
		//告警等级：0正常，1,2,3,4分别代表预警、一般告警、严重告警、危急告警
		var alarm_level = jsonData.data[i].alarm_level;
		var alarm_level_str = null;
		
		if(alarm_level == '1'){
			alarm_level_str = '预警';
			main_alarm_level_color="#0F9BD8";
		}else if(alarm_level == '2'){
			alarm_level_str = '一般告警';
			main_alarm_level_color="#B7C70B";
		}else if(alarm_level == '3'){
			alarm_level_str = '严重告警';
			main_alarm_level_color="#E0CE86";
		}else if(alarm_level == '4'){
			alarm_level_str = '危急告警';
			main_alarm_level_color="#F70209";
		}else if(alarm_level == '0'){
			alarm_level_str = '正常';
			main_alarm_level_color="#000";
		}
		
		
		//报文信息未读条数判断显示
		if($(".real-info-unread").text()=="0" && !$(".real-info-unread").parent().hasClass("active")){
			realInfoUnread++;
			$(".real-info-unread").text(realInfoUnread).show();
		}else if($(".real-info-unread").text()!="0" && !$(".real-info-unread").parent().hasClass("active")){
			realInfoUnread++;
			$(".real-info-unread").text(realInfoUnread).show();
		}

		
		maingridData.unshift({
	    	time:"<span style='color:"+main_alarm_level_color+"'>"+jsonData.data[i].time+"</span>",
	    	device_desc:"<span style='color:"+main_alarm_level_color+"'>"+jsonData.data[i].device_desc+"</span>",
	    	patrol_type:"<span style='color:"+main_alarm_level_color+"'>"+jsonData.data[i].patrol_type+"</span>",
	    	patrol_value:"<span style='color:"+main_alarm_level_color+"'>"+jsonData.data[i].patrol_value+"</span>",
	    	alarm_level:"<span style='color:"+main_alarm_level_color+"'>"+alarm_level_str+"</span>",
	    	device_id:jsonData.data[i].device_id,
	    	target_id:jsonData.data[i].target_id
	    });
	    manager.loadData({Rows:maingridData,Total:maingridData.length});

	}
	
}

//5,获取当前设备巡检异常信息
function set_device_alarm_info(jsonData){
	
	var manager = $("#secondgrid").ligerGetGridManager();
	for(var i = 0 ; i < jsonData.data.length ; i++){
		
		//告警等级：0正常，1,2,3,4分别代表预警、一般告警、严重告警、危急告警
		var alarm_level = jsonData.data[i].alarm_level;
		var alarm_level_str = null;
		
		if(alarm_level == '1'){
			alarm_level_str = '预警';
		}else if(alarm_level == '2'){
			alarm_level_str = '一般告警';
		}else if(alarm_level == '3'){
			alarm_level_str = '严重告警';
		}else if(alarm_level == '4'){
			alarm_level_str = '危急告警';
		}else if(alarm_level == '0'){
			alarm_level_str = '正常';
		}
		device_alarm_level_color=alarm_level;
		
		//设备巡检异常信息未读条数判断显示
		if($(".device-alarm-unread").text()=="0" && !$(".device-alarm-unread").parent().hasClass("active")){
			/*deviceAlarmUnread=1;*/
			$(".device-alarm-unread").text(deviceAlarmUnread).show();
		}else if($(".device-alarm-unread").text()!="0" && !$(".device-alarm-unread").parent().hasClass("active")){
			/*deviceAlarmUnread++;*/
			$(".device-alarm-unread").text(deviceAlarmUnread).show();
		}
		
		
		if(alarm_level != '0'){
			$("#deviceAlarm")[0].play();
		}

		if($(".device-alarm-unread").parent().hasClass("active")){
			var deviceAlarmTime=setInterval(function(){
				$("#deviceAlarm")[0].pause();
				clearInterval(deviceAlarmTime);
			},10000);
		}
		
/*		secondgridData.push({
	    	time:jsonData.data[i].time,
	    	device_desc:jsonData.data[i].device_desc,
	    	patrol_type:jsonData.data[i].patrol_type,
	    	patrol_value:jsonData.data[i].patrol_value,
	    	alarm_level:alarm_level_str
	    });*/
		manager.loadData({Rows:secondgridData,Total:secondgridData.length});
	}
	
}

//6,上传当前机器人异常报文
function set_robot_alarm_info(jsonData){
	var manager = $("#thirdgrid").ligerGetGridManager();
	
	for(var i = 0 ; i < jsonData.data.length ; i++){
		
		//告警等级：0正常，1,2,3,4分别代表预警、一般告警、严重告警、危急告警
		var alarm_level = jsonData.data[i].alarm_level;
		var alarm_level_str = null;
		
		if(alarm_level == '1'){
			alarm_level_str = '预警';
		}else if(alarm_level == '2'){
			alarm_level_str = '一般告警';
		}else if(alarm_level == '3'){
			alarm_level_str = '严重告警';
		}else if(alarm_level == '4'){
			alarm_level_str = '危急告警';
		}else if(alarm_level == '0'){
			alarm_level_str = '正常';
		}
		system_alarm_level_color=alarm_level;

		//机器人异常报文信息未读条数判断显示
		if($(".system-alarm-unread").text()=="0" && !$(".system-alarm-unread").parent().hasClass("active")){
			/*systemAlarmUnread=1;*/
			$(".system-alarm-unread").text(systemAlarmUnread).show();
		}else if($(".system-alarm-unread").text()!="0" && !$(".system-alarm-unread").parent().hasClass("active")){
			/*systemAlarmUnread++;*/
			$(".system-alarm-unread").text(systemAlarmUnread).show();
		}
		
		
		if(alarm_level != '0'){
			$("#systemAlarm")[0].play();
		}
		if($(".system-alarm-unread").parent().hasClass("active")){
			var systemAlarmTime=setInterval(function(){
				$("#systemAlarm")[0].pause();
				clearInterval(systemAlarmTime);
			},10000);
		}

/*		thirdgridData.push({
	    	time:jsonData.data[i].time,
	    	alarm_context:jsonData.data[i].alarm_context,
	    	alarm_level:alarm_level_str
	    })*/
	    manager.loadData({Rows:thirdgridData,Total:thirdgridData.length});

	}
}

//7,上传机器人长时间暂停信号
function set_robot_long_time_pause(jsonData){
	 $.ligerDialog.open({
         height:150,
         width: 400,
         title : '提示',
         url: 'MessageBoxForPause.jsp', 
         showMax: false,
         showToggle: false,
         showMin: false,
         isResize: false,
         slide: false,
         data: {
             content:"机器人已经长时间暂停,是否恢复任务？ time秒后将自动恢复任务..."
         }
     });

}

//8,上传机器人长时间空闲信号
function set_robot_long_time_idel(jsonData){
	$.ligerDialog.open({
        height:150,
        width: 400,
        title : '提示',
        url: 'MessageBoxForIdel.jsp', 
        showMax: false,
        showToggle: false,
        showMin: false,
        isResize: false,
        slide: false,
        data: {
            content:"机器人已经长时间处于空闲状态，time秒后将自动返航..."
        }
    });
}

//9,上传机器人当前控制模式
function set_robot_control_mode(jsonData){
	
	Robot_Now_Mode = jsonData.data;
	
	if(jsonData.data == "1"){//紧急定位模式
		
		$("#rwmsID").attr("src","images/control/rwms1.png");
		$("#jjdwmsID").attr("src","images/control/jjdwms2.png");
		$("#htykmsID").attr("src","images/control/htykms1.png");
		$("#scykmsID").attr("src","images/control/scykms1.png");
		
		$("#rwmsID").attr("onclick","TASKMODE()");
		$("#jjdwmsID").attr("onclick","EMERGENCYMODE()");
		$("#htykmsID").attr("onclick","LOCCONTROLMODE()");
		
	}else if(jsonData.data == "2"){//本地后台遥控模式
		
		$("#rwmsID").attr("src","images/control/rwms1.png");
		$("#jjdwmsID").attr("src","images/control/jjdwms1.png");
		$("#htykmsID").attr("src","images/control/htykms2.png");
		$("#scykmsID").attr("src","images/control/scykms1.png");
		
		
		//改变onlick事件
		$("#rwmsID").attr("onclick","TASKMODE()");
		$("#jjdwmsID").attr("onclick","EMERGENCYMODE()");
		$("#htykmsID").attr("onclick","LOCCONTROLMODE()");
		
	}else if(jsonData.data == "3"){//手持遥控模式
		
		
		$("#rwmsID").attr("src","images/control/rwms1.png");
		$("#jjdwmsID").attr("src","images/control/jjdwms1.png");
		$("#htykmsID").attr("src","images/control/htykms1.png");
		$("#scykmsID").attr("src","images/control/scykms2.png");
		
		//改变onlick事件
		$("#rwmsID").attr("onclick","TASKMODE()");
		$("#jjdwmsID").attr("onclick","EMERGENCYMODE()");
		$("#htykmsID").attr("onclick","LOCCONTROLMODE()");

	}else if(jsonData.data == "4"){//任务模式
		
		$("#rwmsID").attr("src","images/control/rwms2.png");
		$("#jjdwmsID").attr("src","images/control/jjdwms1.png");
		$("#htykmsID").attr("src","images/control/htykms1.png");
		$("#scykmsID").attr("src","images/control/scykms1.png");
		
		//改变onlick事件
		$("#rwmsID").attr("onclick","TASKMODE()");
		$("#jjdwmsID").attr("onclick","EMERGENCYMODE()");
		$("#htykmsID").attr("onclick","LOCCONTROLMODE()");
	}
	
}

//任务模式
function TASKMODE(){
	resetNavigationEdge();
	$.ajax({
		type:"post",
		url:"robotControlInfo/changeRobotControlMode.do?time=" + new Date().getTime(),
		async:false,
		data:{
			controlMode:"4"
		},
		success:function(retData){
			$("#rwmsID").attr("src","images/control/rwms2.png");
			$("#jjdwmsID").attr("src","images/control/jjdwms1.png");
			$("#htykmsID").attr("src","images/control/htykms1.png");
		},
		error:function(e){}
	});
	
	
	
	
}

//紧急定位模式
function EMERGENCYMODE(){
	
	if(Is_Have_Task == "1" || Is_Have_Task == "2"){
		if(confirm("当前有正在执行的任务,您确定取消任务并切换到紧急定位模式吗？")){
			cancelNowTask(); //menu.js中
		}else{
			return;
		}
	}
	
	
	resetNavigationEdge();
	$.ajax({
		type:"post",
		url:"robotControlInfo/changeRobotControlMode.do?time=" + new Date().getTime(),
		data:{
			controlMode:"1"
		},
		success:function(retData){
			$("#jjdwmsID").attr("src","images/control/jjdwms2.png");
			$("#htykmsID").attr("src","images/control/htykms1.png");
			$("#rwmsID").attr("src","images/control/rwms1.png");
		},
		error:function(e){}
	});
	
	

	$.ligerDialog.open({
        height:735,
        width: 500,
        title : '紧急定位模式',
        url: 'jsp/robot/task_manage/special-inspection-dialog.jsp', 
        showMax: false,
        showToggle: false,
        showMin: false,
        isResize: false,
        slide: false,
        onClosed:function(){
        	
        	setTimeout(drawRunningPath,3000);
        }
	/*,
        data: {
            content:"机器人已经长时间暂停,是否恢复任务？ time秒后将自动恢复任务..."
        }*/
    });
	
	
	
}



//后台遥控模式
function LOCCONTROLMODE(){
	//alert(Is_Have_Task);
	if(Is_Have_Task == "1" || Is_Have_Task == "2"){
		if(confirm("当前有正在执行的任务,您确定取消任务并切换到遥控模式吗？")){
			cancelNowTask(); //menu.js中
		}else{
			return;
		}
	}
	$.ajax({
		type:"post",
		url:"robotControlInfo/changeRobotControlMode.do?time=" + new Date().getTime(),
		data:{
			controlMode:"2"
		},
		success:function(retData){
			$("#htykmsID").attr("src","images/control/htykms2.png");
			$("#rwmsID").attr("src","images/control/rwms1.png");
			$("#jjdwmsID").attr("src","images/control/jjdwms1.png");
			
			//drawAllPath();
			setTimeout(drawAllPath,3000);
		},
		error:function(e){}
	});
	
}

function REMOTECONTROLMODE(){
	
}

//361雷达数据
//setInterval("setLaserData1()",2000);
//setInterval("setLaserData1()",3000);
function setLaserData1(ladarData){
	var c=document.getElementById("container2");
	var cxt=c.getContext("2d");
	cxt.clearRect(0,0,150,150);
	
	//songliang
	var x = new Array();		// x
	var y = new Array();		// y
	var xy=new Array();
	// 初始角度
	var angle = -90;
	//console.log("before sort:" + ladarData.data);
	//对距离数据排序，若有小于临界点的坐标，则报警
	var temp =  new Array(ladarData.data.length);
	for(var j = 0 ; j<ladarData.data.length ;j++){
		temp[j] = ladarData.data[j];
	}
	
	var r = temp.sort();
	var alarmFlag = false;//警报flag
	//判断是否需要警报
	
	if(r[0]<2){
		if(!alarmFlag){
			//$("#musicID").attr("src","Twins.mp3").attr("loop","-1");
			alarmFlag = true;
		}
	}else{
		if(alarmFlag){
			//$("#musicID").removeAttr("src").removeAttr("loop");
			alarmFlag = false;
		}
	}
	
	for(var j = 0 ; j<=360 ;j++){
		//雷达点距离超过10米，按十米计算
		if(ladarData.data[j]>10){
			ladarData.data[j]=10;
		}
		//计算雷达点的坐标
		if (ladarData.data[j] != null){
			x[j] = 75+((ladarData.data[j]*1000)*Math.sin(angle*Math.PI/180)/200); 
			y[j] = 0+ ((ladarData.data[j]*1000)*Math.cos(angle*Math.PI/180)/200);
			angle = angle + 0.5;
			if(ladarData.data[j]<2){
				drawRadarPoint(x[j],y[j],"rgba(128, 0, 0, .8)");
			}
			if(ladarData.data[j]>=2&&ladarData.data[j]<3){
				drawRadarPoint(x[j],y[j],"rgba(128, 128, 0, .8)");
			}
			if(ladarData.data[j]>=3){
				drawRadarPoint(x[j],y[j],"rgba(0, 128, 0, .8)");
			}
		}
	}
	drowflag = true;
}

//雷达点显示
var drowflag = false;
function drawRadarPoint(x,y,pointColor){
	var c=document.getElementById("container2");
	var cxt=c.getContext("2d");
	drowflag=false;
	var p=new Array(2);
	p[0]=x;p[1]=y;
	cxt.beginPath();
	cxt.lineWidth=5;
	cxt.moveTo(p[0],p[1]);
	cxt.lineTo(p[0]+1,p[1]+1);
	cxt.strokeStyle=pointColor;
	cxt.stroke();
	cxt.closePath();
	
}
//超声
function drawSoundPoint(jsonData){
	var first,second,third,fourth,firstColor,secondColor,thirdColor,fourthColor;
	first = jsonData.data[0];
	second = jsonData.data[1];
	third = jsonData.data[2];
	fourth = jsonData.data[3];
	//此处判断雷达信号，设置相应区域的颜色
	if(first==0){
		firstColor = "rgba(0, 255, 0, .8)";
	}else if(first==1){
		firstColor = "rgba(255, 255, 0, .8)";
	}else if(first==11){
		firstColor = "rgba(255, 0, 0, .8)";
	}
	
	if(second==0){
		secondColor = "rgba(0, 255, 0, .8)";
	}else if(second==1){
		secondColor = "rgba(255, 255, 0, .8)";
	}else if(second==11){
		secondColor = "rgba(255, 0, 0, .8)";
	}
	
	if(third==0){
		thirdColor = "rgba(0, 255, 0, .8)";
	}else if(third==1){
		thirdColor = "rgba(255, 255, 0, .8)";
	}else if(third==11){
		thirdColor = "rgba(255, 0, 0, .8)";
	}

	if(fourth==0){
		fourthColor = "rgba(0, 255, 0, .8)";
	}else if(fourth==1){
		fourthColor = "rgba(255, 255, 0, .8)";
	}else if(fourth==11){
		fourthColor = "rgba(255, 0, 0, .8)";
	}
	
	$(".canvasBox canvas").remove();
	$(".canvasBox").append("<canvas id='container1' width='150' height='75'></canvas>");
	var c=document.getElementById("container1");
	var ctx=c.getContext("2d");
	//清除画布
	ctx.clearRect(0,0,150,75);
	//第一个扇形
	ctx.beginPath();
	// 位移到圆心，方便绘制
	ctx.translate(75, 75);
	// 移动到圆心
	ctx.moveTo(0, 0);
	ctx.rotate(180*Math.PI/180);
	// 绘制圆弧
	ctx.arc(0, 0, 50, 0, 0.25*Math.PI);
	// 闭合路径
	ctx.closePath();
	ctx.fillStyle=firstColor;
	ctx.fill();
	//第二个扇形
	ctx.beginPath();
	// 位移到圆心，方便绘制
	ctx.translate(0, 0);
	// 移动到圆心
	ctx.moveTo(0, 0);
	ctx.rotate(45*Math.PI/180);
	// 绘制圆弧
	ctx.arc(0, 0, 50, 0, 0.25*Math.PI );
	// 闭合路径
	ctx.closePath();
	ctx.fillStyle=secondColor;
	ctx.fill();
	//第三个扇形	
	ctx.beginPath();
	// 位移到圆心，方便绘制
	ctx.translate(0, 0);
	// 移动到圆心
	ctx.moveTo(0, 0);
	ctx.rotate(45*Math.PI/180);
	// 绘制圆弧
	ctx.arc(0, 0, 50, 0, 0.25*Math.PI );
	// 闭合路径
	ctx.closePath();
	ctx.fillStyle=thirdColor;
	ctx.fill();
	//第四个扇形
	ctx.beginPath();
	// 位移到圆心，方便绘制
	ctx.translate(0, 0);
	// 移动到圆心
	ctx.moveTo(0, 0);
	ctx.rotate(45*Math.PI/180);
	// 绘制圆弧
	ctx.arc(0, 0, 50, 0, 0.25*Math.PI);
	// 闭合路径
	ctx.closePath();
	ctx.fillStyle=fourthColor;
	ctx.fill();
}


/**
 * 画出所有路线
 */
function drawAllPath(){
	$.ajax({
		type:"post",
		async:false,
		url:"robotReportInfo/getStationEdgeInfo.do",
		success:function(data){
			for(var i = 0 ; i < data.data.length ; i++){
				
				var pos1 = transPostionOnColor(data.data[i].startX,data.data[i].startY);
				var pos2 = transPostionOnColor(data.data[i].endX,data.data[i].endY);
				
				
				drawLine(pos1.px_x,pos1.px_y,pos2.px_x,pos2.px_y,"red");
			}		
			
		},
		error:function(){
			alert("获取路径失败！");
		}
	});
}

/**
 * 画出 机器人当前的巡检路线
 */
function drawRunningPath(){
    	$.ajax({
    		type:"post",
    		async:false,
    		url:"robotReportInfo/getPatrolEdgeInfo.do",
    		success:function(data){
    			clearDrawLine();
    			for(var i = 0 ; i < data.data.length ; i++){
    								
    				var pos1 = transPostionOnColor(data.data[i].startX,data.data[i].startY);
    				var pos2 = transPostionOnColor(data.data[i].endX,data.data[i].endY);
    				
    				drawLine(pos1.px_x,pos1.px_y,pos2.px_x,pos2.px_y,"red");
    			}
    		},
    		error:function(){
    			alert("获取路径失败！");
    		}
    	});
}

/**
 * 重置导航边界
 */
function resetNavigationEdge(){
	$.ajax({
		type:"post",
		async:false,
		url:"robotControlInfo/resetNavigationEdge.do?time=" + new Date().getTime(),
		success:function(data){
			
		},
		error:function(){
		}
	});
}