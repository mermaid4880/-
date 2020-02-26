var selecId = "您未选中任何一项模板！";
//
var manager = null;
var hismanager = null;
var messionName, editTime, operation;
var taskData = null;
//
var pathId = null;
var pathDesc = null;
var pathDevice = null;
var pathCreateTime = null;
var finishType = null;
var pathType = null;
var taskPathType = null;
//time
var taskYear = new Date().getFullYear();
var taskMon = new Date().getMonth() + 1;
var taskDay = new Date().getDate() ;
var taskHour = new Date().getHours();
var taskMin = new Date().getMinutes();
var taskSec = new Date().getSeconds();

/*var TaskShowData = "{Rows:[";*/

$(function(){
	//manager = $("#taskgrid").ligerGetGridManager();
	//调用中控接口显示所有的任务模板
	var tree = $("#tree-ul");
	
	 var temp = $(".input-radio input[type='radio']:checked").parent().text();
	 
	 if(temp == "全面巡检"){
		 taskPathType = 2;
	 }else if(temp == "例行巡检"){
		 taskPathType = 1;
	 }else if(temp == "专项巡检"){
		 taskPathType = 3;
	 }else if(temp == "特殊巡检"){
		 taskPathType = 4;
	 }else{		//没有选择的时候随便传一个
		 taskPathType = 2;
	 }
	getAllMession();
})

/**
 * liangqin
 * 获取所有的任务列表
 */
function getAllMession(){
	
	 if(taskPathType == null){
		 taskPathType = 2;
	 }
	$.ajax({
		type:"post",
		url:"dbTaskController/getTaskPathInfoByType.do?time=" + new Date().getTime(),
		async:false,
		data:{
			taskPathType : taskPathType
		},
		success:function(retData){
			taskData = retData.data;
			var TaskShowData = [];
			//获取模板
			for(var i = 0; i<retData.data.length; i++){
				
				pathId = retData.data[i].pathId;
				pathDesc = retData.data[i].pathDesc;
				pathDevice = retData.data[i].pathDevice;
				pathCreateTime = retData.data[i].pathCreateTime;
				finishType = retData.data[i].finishType;
				pathType = retData.data[i].pathType;
				
					TaskShowData.push({ taskName:pathDesc,
					editTime:pathCreateTime,
					Id:pathId,
					selectOperation:"<a href=javascript:rightNow("+pathId+")>立即执行</a> <a href=javascript:regularExec("+pathId+")>定期执行</a> <a href=javascript:cycleExec("+pathId+")>周期执行</a>",
					});
					
			}
/*		    TaskShowData = TaskShowData.substring(0, TaskShowData.length-1);
		    //console.log(TaskShowData);
			TaskShowData += "]}";
			TaskShowData = eval('(' + TaskShowData + ')');*/
			
			

            $("#taskgrid").ligerGrid({
                columns: [
                { display: '任务名称', name: 'taskName', align: 'center', width: "30%"},
                { display: '编辑时间', name: 'editTime', Width: "30%" },
                { display: '操作', name: 'selectOperation', Width: "40%" },
                ], dataAction: 'server', data: TaskShowData, sortName: 'display',
                width: '98%', height: '573px', pageSize: 10,rownumbers:true,rowtitle:true,
                checkbox : false,
                allowUnSelectRow:true,
                onSelectRow:function(data, rowindex, rowobj){
               		var showTreeTime;
               		showTreeTime=setInterval(function(){
	                	showTree(data.Id);
               			clearInterval(showTreeTime);
               		},1000);
                },
                //应用灰色表头
                cssClass: 'l-grid-gray', 
                heightDiff: -6
            });
            manager = $("#taskgrid").ligerGetGridManager();
            manager.loadData({Rows:TaskShowData,Total:TaskShowData.length});
            $("#pageloading").hide();
		},
		error:function(){alert("getTaskPathInfoByType--->error");}
 	});	
}
/**
 * liangqin
 * 选择自主充电或者原地待命
 */
function saveButton(){
	$.ligerDialog.confirm('选择‘是’则为自主充电，选择‘否’则为原地待命', function (type) { 
		if(type == true){
			finishType = 0;
			saveNewTask();
		}
		else{
			finishType = 1;
			saveNewTask();
		}
	});
}

/**
 * 判断是否有选中某个任务模板，如果没有选中任何模板，则新增一个模板，否则将修改已选中的模板
 */
function chooseFunc(){
	var rows = manager.getSelectedRow();
	var tName = $("#descId").val();
	if( tName !="" ){
		saveButton();
		
	}else{
		updateCheckedData();
	}
}

/**
 * liangqin
 * 保存任务
 */
function saveNewTask(){
	var manager = $("#taskgrid").ligerGetGridManager();

	var nowDateTime = ""+taskYear+"-"+taskMon+"-"+taskDay+" "+taskHour+":"+taskMin+":"+taskSec+"";
	
	var rootName = tree.getNodes()[0].name;
	
	//获取所有勾选的设备
	var nodes = tree.getCheckedNodes();
	var str = 0;
	for(var i = 0; i < nodes.length; i++){
		var j = nodes[i].id;
		if(j > 10000){
			str = str + (nodes[i].id-10000) + ",";
		}
	}
	str = str.substring(0,str.length - 1);
	
	 var temp = $(".input-radio input[type='radio']:checked").parent().text();
	
	if(temp == "全面巡检"){
		 taskPathType = 2;
	 }else if(temp == "例行巡检"){
		 taskPathType = 1;
	 }else if(temp == "专项巡检"){
		 taskPathType = 3;
	 }else if(temp == "特殊巡检"){
		 taskPathType = 4;
	 }else{
		 taskPathType = null;
	 }
	 
	if(taskPathType == 1){
		taskType = "例行巡检";
	}else if(taskPathType == 2){
		taskType = "全面巡检";
	}else if(taskPathType == 3){
		taskType = "专项巡检";
	}else if(taskPathType == 4){
		taskType = "特殊巡检";
	}else if(taskPathType == null){
		taskType = $(".input-radio input[type='radio']:checked").parent().text();
		rootName = $("#descId").val();
	}
	 $.ajax({
			type:"post",
			url:"dbTaskController/addTaskPathInfo.do?time=" + new Date().getTime(),
			async:false,
			data:{
				"pathId":-1,
				"pathDesc":rootName+taskType+taskYear+'-'+taskMon+'-'+taskDay,
				"pathDevice":str,
				"pathCreateTime":nowDateTime,
				"finishType":finishType,
				"taskPathType":taskPathType
			},
			success:function(retData){
				$(".l-bar-btnload").click();
				if(taskPathType == null){
					manager.addRow({
						 taskName:rootName,
						 editTime:nowDateTime,
						 selectOperation:
							 "<a href='javascript:rightNow("+pathId+");'>"+"立即执行"+"</a>"+" "+
							 "<a href='javascript:regularExec("+pathId+");'>"+"定期执行"+"</a>"+" "+"<a href='javascript:cycleExec("+pathId+")'>"+"周期执行"+"</a>"
					    });
				}else{
					getAllMession();
				}				
			},
			error:function(){alert("adaTaskPathInfo--->error");}
		});	
	 
	 
	 $("#descId").val("");
	 getAllMession();
}

/**
 * liangqin
 * 立即执行
 */
function rightNow(id){
	
	if(Robot_Now_Mode == "2"){
		$.ligerDialog.confirm('当前是遥控模式，是否切换到任务模式并执行任务？', function (yes){
            if(yes){
            	
            	TASKMODE();
            	doTask(id);

            }
		});
	}else{
		doTask(id);
	}
}

	
/**
 * 执行任务
 */
function doTask(id){
	var temp = null;
	for(var i = 0; i < taskData.length; i++){
		if(taskData[i].pathId == id){
			temp = taskData[i];
			break;
		}
	}
	
	var str = null;
	for ( var i = 0; i < temp.pathDevice.length; i++) {
		str = str + temp.pathDevice[i] + ",";
	}
	
	 $.ajax({
			type:"post",
			url:"dbTaskController/startPatrolTaskByPath.do?time=" + new Date().getTime(),
			data:{
				pathId : temp.pathId,
				pathDesc : temp.pathDesc,
				str : str,
				pathCreateTime : temp.pathCreateTime,
				finishType : temp.finishType,
				taskPathType : taskPathType
			},
			success:function(retData){
				if(retData.result == "1"){
					alert("任务执行成功");
				}else{
					alert("任务执行失败");
				}
			},
			error:function(){alert("执行任务出错");}
		});	
}

/**
 * liangqin
 * 定期执行
 */
function regularExec(id){
	var temp = null;
	for(var i = 0; i < taskData.length; i++){
		if(taskData[i].pathId == id){
			temp = taskData[i];
			break;
		}
	}
	$.ligerDialog.open({
        height:340,
        width: 350,
        title : '提示',
        url: '/robot/jsp/robot/task_manage/regularExecute.jsp', 
        showMax: false,
        showToggle: false,
        showMin: false,
        isResize: false,
        slide: false,
        data: {
            id:temp.pathId,
            taskPathType:taskPathType,
            pathDesc:temp.pathDesc
        }
    });
}

/**
 * liangqin
 * 周期执行
 */
function cycleExec(id){
	var temp = null;
	for(var i = 0; i < taskData.length; i++){
		if(taskData[i].pathId == id){
			temp = taskData[i];
			break;
		}
	}
	$.ligerDialog.open({
        height:360,
        width: 350,
        title : '提示',
        url: '/robot/jsp/robot/task_manage/cycleExecute.jsp', 
        showMax: false,
        showToggle: false,
        showMin: false,
        isResize: false,
        slide: false,
        data: {
            id:temp.pathId,
            taskPathType:taskPathType,
            pathDesc:temp.pathDesc
        }
    });
}

/**
 * liangqin
 * 删除任务
 */
function removeCheckedData(){
	var rows = manager.getCheckedRows();
	var pid = "";
	$(rows).each(function(){
		pid = this.Id;
	});
	 $.ajax({
			type:"post",
			async:false,
			url:"dbTaskController/delTaskPathInfo.do?time=" + new Date().getTime(),
			data:{
				pathId : pid,
			},
			success:function(retData){
				$(".l-bar-btnload").click();
				getAllMession();
			},
			error:function(){alert("startPatrolTaskByPath--->error");}
		});	
}

function showTree(id){
	var temp = null;
	for(var i = 0; i < taskData.length; i++){
		if(taskData[i].pathId == id){
			temp = taskData[i];
			break;
		}
	}
	displayDeviceIdList(temp.pathDevice);
}

function updateCheckedData(){	
	
	var pid = "";
	var rows = manager.getCheckedRows();
	$(rows).each(function(){
		pid = this.Id;
		pathDesc = this.taskName;
	});
	
	var temp = null;
	for(var i = 0; i < taskData.length; i++){
		if(taskData[i].pathId == pid){
			temp = taskData[i];
			break;
		}
	}
	
	if(temp.finishType == 0){
		var stateStr = "自主充电";
	}else{
		var stateStr = "原地待命";
	}
	
	$.ligerDialog.confirm('原来的状态为: '+stateStr+'  ,选择‘是’则为自主充电，选择‘否’则为原地待命', function (type) { 
		if(type == true){
			finishType = 0;
			tempFunc();
		}
		else{
			finishType = 1;
			tempFunc();
		}
	});
}

function tempFunc(){
	
	var rows = manager.getCheckedRows();
	var pid = "";
	var pathDesc = "";
	$(rows).each(function(){
		pid = this.Id;
		pathDesc = this.taskName;
	});
	
	//如果没有树形菜单,nodes会为0,substring会报错!
	//获取所有勾选的设备
	var nodes = tree.getCheckedNodes();
	var str = "";
	for(var i = 0; i < nodes.length; i++){
		var j = nodes[i].id;
		if(j > 10000){
			str = str + (nodes[i].id-10000) + ",";
		}
	}
	str = str.substring(0,str.length - 1);
	
	var nowDateTime = ""+taskYear+"-"+taskMon+"-"+taskDay+" "+taskHour+":"+taskMin+":"+taskSec+"";
	
	$.ajax({
			type:"post",
			url:"dbTaskController/editTaskPathInfo.do?time=" + new Date().getTime(),
			data:{
				pathId:pid,
				pathDesc:pathDesc,
				str : str,
				pathCreateTime : nowDateTime,
				finishType : finishType,
				taskPathType : taskPathType
			},
			success:function(retData){
				alert("修改成功");
				$(".l-bar-btnload").click();
				getAllMession();
			},
			error:function(){alert("startPatrolTaskByPath--->error");}
		});	
}

function goToImport(){
	
	$.ajax({
		type:"post",
		url:"dbTaskController/getTaskPathByTime.do?time=" + new Date().getTime(),
		async:false,
		data:{
			startTime:-1,
			endTime:-1,
			name:-1
		},
		success:function(retData){
			taskData = retData.data;
			var TaskShowData = "{Rows:[";
			//获取模板
			for(var i = 0; i<retData.data.length; i++){
				
				pathId = retData.data[i].pathId;
				pathDesc = retData.data[i].pathDesc;
				pathDevice = retData.data[i].pathDevice;
				pathCreateTime = retData.data[i].pathCreateTime;
				finishType = retData.data[i].finishType;
				if(finishType == 0){
					var finiType = "自主充电";
				}else if(finishType == 1){
					var finiType = "原地待命";
				}
				pathType = retData.data[i].pathType;
				if(pathType == 1 || pathType == "ROUTINE"){
					pathType = "例行巡检";
				}else if(pathType == 2 || pathType == "OVERALL"){
					pathType = "全面巡检";
				}else if(pathType == 3 || pathType == "SPECIAL"){
					pathType = "专项巡检";
				}else if(pathType == 4 || pathType == "PECUILAR"){
					pathType = "特殊巡检";
				}
								
					TaskShowData += "{ taskName:'"+ pathDesc 
					+"', editTime:'"+pathCreateTime
					+"', Id:'"+ pathId
					+"',selectOperation:'"+"<a href=javascript:rightNow("+pathId+")>立即执行</a> <a href=javascript:regularExec("+pathId+")>定期执行</a> <a href=javascript:cycleExec("+pathId+")>周期执行</a>"
					//+"',selectOperation:'"+"<a href=javascript:seeDetail("+pathId+")>查看详情</a>"
					+"' },";
			}
		    TaskShowData = TaskShowData.substring(0, TaskShowData.length-1);
			TaskShowData += "]}";
			TaskShowData = eval('(' + TaskShowData + ')');
			var fn = $.ligerui.getPopupFn({
		        top : 120,
		        onSelect: function (e) {
		        	manager.addRows(e.data);
		        },
		        grid: {
		            columns: [
	                      { display: '任务名称', name: 'taskName', width: 170},
	                      { display: '编辑时间', name: 'editTime', width: 170},
	                      { display: '操作', name: 'selectOperation', width: 290},
		            ], isScroll: false, checkbox: true,
		            data: TaskShowData,
		            width: '95%'
		        } 
		    });

		    fn();
		},
		error:function(){alert("getTaskPathByTime--->error");}
	});		
	
}

	

//后面需要完善该功能(加上按时间查询功能)
function findHistory(){
	var startTime = $("#startTime").val();
	var endTime = $("#endTime").val();
	var name = $("#keyWord").val();
	
	$.ajax({
		type:"post",
		url:"dbTaskController/getTaskPathByTime.do?time=" + new Date().getTime(),
		async:false,
		data:{
			startTime:startTime,
			endTime:endTime,
			name:name
		},
		success:function(retData){
			taskData = retData.data;
			var TaskShowData = "{Rows:[";
			//获取模板
			for(var i = 0; i<retData.data.length; i++){
				
				pathId = retData.data[i].pathId;
				pathDesc = retData.data[i].pathDesc;
				pathDevice = retData.data[i].pathDevice;
				pathCreateTime = retData.data[i].pathCreateTime;
				finishType = retData.data[i].finishType;
				if(finishType == 0){
					var finiType = "自主充电";
				}else if(finishType == 1){
					var finiType = "原地待命";
				}
				pathType = retData.data[i].pathType;
				if(pathType == 1 || pathType == "ROUTINE"){
					pathType = "例行巡检";
				}else if(pathType == 2 || pathType == "OVERALL"){
					pathType = "全面巡检";
				}else if(pathType == 3 || pathType == "SPECIAL"){
					pathType = "专项巡检";
				}else if(pathType == 4 || pathType == "PECUILAR"){
					pathType = "特殊巡检";
				}
								
					TaskShowData += "{ taskName:'"+ pathDesc 
					+"', editTime:'"+pathCreateTime
					+"', Id:'"+ pathId
					+"', Type:'"+pathType
					+"', finType:'" + finiType
					+"' },";				

					
			}
		    TaskShowData = TaskShowData.substring(0, TaskShowData.length-1);
			TaskShowData += "]}";
			TaskShowData = eval('(' + TaskShowData + ')');
			
			 $("#taskhistory").ligerGrid({
	                columns: [
	      	        { display: '任务类型', name: 'Type', Width: "25%" },
	                { display: '任务名称', name: 'taskName', align: 'center', width: "25%"},	                
	                { display: '编辑时间', name: 'editTime', Width: "25%" },
	                { display: '执行类型', name: 'finType', Width: "25%" },
	                //{ display: '任务编号', name: 'Id', Width: "1%" },
	                ], dataAction: 'server', data: TaskShowData, sortName: 'display',
	                width: '650px', height: '550px', pageSize: 10,rownumbers:true,rowtitle:true,
	                checkbox : false,
	                allowUnSelectRow:true,
	                onSelectRow:function(data, rowindex, rowobj){
	                	selecId = data.Id;
	                },
	                //应用灰色表头
	                cssClass: 'l-grid-gray', 
	                heightDiff: -6
	            });
			 hismanager = $("#taskhistory").ligerGetGridManager();
	            $("#pageloading").hide();
			},
			error:function(){alert("getTaskPathByTime--->error");}
 	});	
}

function resetPage(){
	//getSearchDevice();
	// $(".l-tab-links").click();
	var text=$(".second").text();
	var url=$(".header .have-bg ul li span a:contains('"+text+"')").attr("data-url");
	var iframeHeight=$(".iframe").height();
	var loadHtml="<span style='width:100%;font-size:25px;line-height:"+iframeHeight+"px;text-align:center;display:inline-block;'><img src='images/common/bigloading.gif'></span>";
	//页面初始化
	$.ajax({
		url:url,
     	async:false,
     	cache:false,
		success:function(data){
       		$(".iframe").html(loadHtml);
       		var robotTime;
       			
       		robotTime=setInterval(function(){
       		    clearInterval(robotTime);
           		$(".iframe").html(data);

       		},1000);
		}
	})
}