var tree = null;
var treeAche = [];

//在table选择行的时候缓存该行的数据
var tableSelectrowData =null;

var setting = {
		view: {
			selectedMulti: false
		},
		check: {
			enable: false,
			chkboxType:{"Y":"ps","N":"ps"}
		},
		callback:{
			onClick:treeOnClick
		},
		data: {
			simpleData: {
				enable: true
			}
		}
	};

$(function(){		
	defaultTime();
	createTree();
});


/**
 * 创建overall-rounds.jsp左下角的树
 * author:Cuijiekun
 */
function createTree(){
	
	var treeData = [];
	
	//获取所有区域信息
	$.ajax({
		type:"post",
		url:"substation/getAreaInfo.do?time=" + new Date().getTime(),
		async:false,
		success:function(data){
			if(data.result == "1"){
				$(data.data).each(function(i,item){
					
					//console.log(JSON.stringify(item));
					
					treeData.push({
						falg_str:1,
						id:item.areaId,
						pId:item.parentId,
						name:item.areaDesc,
						checked:true,
						type:"area"});
				});
			}else{
				alert("获取所有区域信息出错");
			}
		},
		error:function(e){
			alert("获取所有区域信息的请求出错");
		}
	});
	
	
	//获取所有设备信息
	$.ajax({
		type:"post",
		url:"substation/getAreaDeviceInfo.do?time=" + new Date().getTime(),
		async:false,
		success:function(data){
			if(data.result == "1"){
				$(data.data).each(function(i,item){
					var color = "";
					//1,2,3,4分别代表预警、一般告警、严重告警、危急告警
					if(item.deviceStatus == 0){
						color = "images/task/green.jpg";
					}
					else if(item.deviceStatus == 1){
						color = "images/task/blue.jpg";
					}
					else if(item.deviceStatus == 2){
						color = "images/task/yellow.jpg";
					}
					else if(item.deviceStatus == 3){
						color = "images/task/orange.jpg";
					}
					else if(item.deviceStatus == 4){
						color = "images/task/red.jpg";
					}
					treeData.push({
						falg_str:1,
						id:10000+item.deviceId,
						pId:item.areaId,
						name:item.deviceDesc,
						checked:true,
						type:"device",
						icon:color});
					
				});
			}else{
				alert("获取所有设备信息出错");
			}
		},
		error:function(e){
			alert("获取所有设备信息的请求出错");
		}
	});

	
	tree = $.fn.zTree.init($("#treeDemo"), setting, treeData);
    treeAche = treeData;
}

/**
 * 根据勾选的条件查询相关的设备，并在树中打上勾
 */
function searchData(){
	
	var startTime = $("#start").val()+" 00:00:01";
	var endTime = $("#stop").val()+" 23:59:59";
	
	$.ajax({
		type:"post",
		url:"dbHistory/getSearchTaskFinishInfo.do?time=" + new Date().getTime(),
		async:false,
		data:{
			"startTime":startTime,
			"endTime":endTime
		},
		success:function(data){
			
			var tableData=[];
			
			if(data.data.length > 0){
				for(var i = 0 ; i < data.data.length ; i++ ){
					tableData.push({
						"taskName":data.data[i].taskName,
					    "taskFinishState":data.data[i].taskFinishState,
					    "startTime":data.data[i].startTime,
					    "endTime":data.data[i].endTime,
					    "allDeviceCount":data.data[i].allDeviceCount,
					    "alarmDeviceCount":data.data[i].alarmDeviceCount,
					    "identifyErrorCount":data.data[i].identifyErrorCount,
					    "infraredErrorCount":data.data[i].infraredErrorCount,
					    "taskId":data.data[i].taskId
					});
				}
			}
			
			createTaskTable(tableData);
			
		},
		error:function(error){}
	});
	
}


/**
 * 清空所有已选择
 */
function f_cancelSelectNode(){
	
	for(var i=0 ; i<treeAche.length ; i++){
		treeAche[i].checked = false; 
	}
	
	$("#treeDemo").html("");
	
	 tree = $.fn.zTree.init($("#treeDemo"), setting, treeAche);
}

/**
 * 根据关键字搜索，并展开树节点,
 * @param key
 */
function searchByText(){
	
	var key = $("#searchId").val();
	
	if(key == null || key == ""){
		tree = $.fn.zTree.init($("#treeDemo"), setting, treeAche);
		return;
	}	
	
	var treeNodes = tree.getNodesByParam("falg_str",1);
	
	//初始化数据
	for(var i=0 ; i < treeNodes.length ; i++){
		if(treeNodes[i].type == "device" && treeNodes[i].name.indexOf(key) < 0){
			tree.removeNode(treeNodes[i]);
		}
	}
	$("#searchId").val("");
}



/**
 * 递归将所有的父节点展开（包括父节点的父节点的父节点...）
 * @param tData
 * @param pid
 */
function expendParent(tData,pid){
	for(var i=0 ; i<tData.length ; i++){
		if( tData[i].id == pid){
			if(tData[i].open){
				return;
			}else{
				tData[i].open = true;
				tData[i].isHidden = false;
				expendParent(tData,tData[i].pId);
				return;
			}
		}
	}
}


/**
 * 根据所选的条件搜索树
 */
function resetPage(){
	//getSearchDevice();
	$(".l-tab-links").click();
}


/**
 * 只<<<<<<<勾选>>>>>>>deviceIdList中的设备
 * @param deviceIdList 设备的Id数组
 */
function displayDeviceIdList(deviceIdList){
	for(var i=0 ; i<treeAche.length ; i++){
		treeAche[i].checked = false;
		treeAche[i].isHidden = true;
		treeAche[i].open = false;
	}
	
	//初始化数据
	for(var i=0 ; i < treeAche.length ; i++){
		if(treeAche[i].type == "device"){
			for(var j = 0; j < deviceIdList.length ; j++){
				if(deviceIdList[j] == (treeAche[i].id - 10000) ){
					treeAche[i].checked = true;
					treeAche[i].isHidden = false;
					expendParent(treeAche,treeAche[i].pId);
				}
			}
		}
	}

	$("#treeDemo").html("");
	
	 tree = $.fn.zTree.init($("#treeDemo"), setting, treeAche);
	 
	 var nodes = tree.getNodesByParam("isHidden",true);
	 
	 for(var i = 0 ; i < nodes.length ; i++ ){
		tree.removeNode(nodes[i]);
	 }
	 	 
}

/**
 * 生成任务的表格数据
 * @param tableData
 * 
 * "taskName",
    "taskFinishState",
    "startTime",
    "endTime",
    "allDeviceCount",
    "alarmDeviceCount",
    "identifyErrorCount",
    "infraredErrorCount",
    "taskId"
 */
function createTaskTable(tableData){
	
	var datas = {Rows:tableData,Total:66};
	
	 $("#inspectiongrid").ligerGrid({
         columns: [
	         { display: '任务名称', name: 'taskName', align: 'center', width: "20%"},
	         { display: '开始时间', name: 'startTime', Width: "15%" },
	         { display: '结束时间', name: 'endTime', Width: "15%" },
	         { display: '任务状态', name: 'taskFinishState', Width: "10%" },
	         { display: '设备总数', name: 'allDeviceCount', Width: "10%" },
	         { display: '异常总数', name: 'alarmDeviceCount', Width: "10%" },
	         { display: '表计异常总数', name: 'identifyErrorCount', Width: "10%" },
	         { display: '红外异常总数', name: 'infraredErrorCount', Width: "10%" }
         ], dataAction: 'server', data:datas,sortName: 'startTime',
         width: '100%', height: '585px', pageSize: 20,rownumbers:true,rowtitle:true,
         checkbox : false,
         allowUnSelectRow:true,
         onSelectRow:function(data, rowindex, rowobj){
        	tableSelectrowData = data;
         	showTaskDevice(data);
         },
         //应用灰色表头
         cssClass: 'l-grid-gray', 
         heightDiff: -6
     });
}

/**
 * 点击树的节点
 * @param event
 * @param treeId
 * @param treeNode
 * @returns
 */
function treeOnClick(event,treeId,treeNode){
	
	if(treeNode.type != "device"){
		return;
	}
	
	var deviceId = treeNode.id - 10000;
	var taskId = tableSelectrowData.taskId;
	
	$.ajax({
		type:"post",
		url:"dbHistory/getTaskDeviceHistory.do",
		data:{
			"taskId":taskId,
			"deviceId":deviceId
		},
		success:function(data){
			
			if(data.data == null){
				return;
			}
			
			var scry="<div class='review' ><p>设备名称:<label>" + data.data.deviceName + 
						"</label></p><p>识别时间:<label>" + data.data.patrolTime + "</label></p><p>&nbsp;识别值:<label>" + data.data.patrolValue + 
						"</label></p><textarea class='form-control'></textarea><span>审查人员：</span><input type='text'>&nbsp;<a href='javascript:;' class='btn btn-primary'>提交</a>";
			var taskpicData = 
			{
					Rows:[
				       {
				    	   "gq":"<img src='" + data.data.imageFile + "'><p></p>",
				    	   "hw":"<img src='" + data.data.flirFile + "'><p></p>",
				    	   "sp":"<video controls width='100%' src='http://localhost:8080/file/demo/Twins.mp3'></video><p></p>",
				    	   "sc":scry
			    	   }
			       ], Total:66
			    };
			
			 $("#inspection-pic").ligerGrid({
		            columns: [
		            { display: '', name: 'gq', align: 'center', width: "25%"},
		            { display: '', name: 'hw', Width: "25%" },
		            { display: '', name: 'sp', Width: "25%" },
		            { display: '', name: 'sc', Width: "24%" },
		            ], dataAction: 'server', data: taskpicData, sortName: 'CustomerID',
		            width: '100%', height: '300px', pageSize: 10,rownumbers:false,rowtitle:false,
		            checkbox : false,
		            //应用灰色表头
		            cssClass: 'l-grid-gray', 
		            heightDiff: -6
		        });
		}
	});
	
	
}


/*
 * add By Cuijiekun
 * 根据任务列表中选择的任务记录，将此任务所巡检的设备在设备树中显示
 * date :2016-10-13 13:24:57
 * 
 * "deviceId",
    "deviceDesc",
    "areaId",
    "deviceStatus"
 */
function showTaskDevice(d){
	$.ajax({
		type:"post",
		url:"substation/getTaskDevice.do?time=" + new Date().getTime(),
		data:{"taskId":d.taskId},
		success:function(data){
			if(data.data != null){
				var deviceIdList=new Array(data.data.length);
				
				for(var i=0;i < data.data.length;i++){
					deviceIdList[i] = data.data[i].deviceId;
				}
				displayDeviceIdList(deviceIdList);
			}
		},
		error:function(e){}
	});
	
}

/**
 * 
 * @param status
 * @returns
 */
function getTaskFinishStatusStr(status){
	if(status == '1'){
		return "<font color='#008000'>"+'执行完成'+"</font>";
	}else if(status == '2'){
		return "<font color='#a0522d'>"+'中途终止'+"</font>";
	}else if(status == '3'){
		return "<font color='#ff0000'>"+"正在执行"+"</font>";
	}else if(status == '4'){
		return "<font color='#0000ff'>"+'等待执行'+"</font>";
	}else if(status == '5'){
		return "<font color='#ffff00'>"+'任务超期'+"</font>";
	}else{
		return "状态未定义【" + status + "】";
	}

}





/**
 * add by Cuijiekun 
 * 用于给startTime 和 endTime 默认值（当月的第一天和最后一天）
 * time:2016-10-11 10:28:13
 */
function defaultTime(){
	
	
	monthStart = new Date();

		var year = monthStart.getFullYear();
		var month = monthStart.getMonth() + 1;


	var days = 1;// 每个月的总天数
	// 设置当前月第一天时间
	switch (month) {
		case 1:
		case 3:
		case 5:
		case 7:
		case 8:
		case 10:
		case 12:
			days = 31;
			break;
		case 4:
		case 6:
		case 9:
		case 11:
			days = 30;
			break;
		case 2:
			if (isRun) {
				days = 29;
			} else {
				days = 28;
			}
			break;
		default:
			alert("输入月份不正确!!");
	}
	
	//月份小于10的处理
	var month_str = month > 9 ? month : "0" + month;
	
	$("#start").val(year + "-" + month_str + "-01 00:00:00" );
	$("#stop").val(year + "-" + month_str + "-" + days + " 23:59:59");
	
}
