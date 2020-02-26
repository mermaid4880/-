var gridManager;
//此处创建导出的json数据
var PreviewData = "{Rows:[]}";
var TaskReportData=[];
// 页面初始化，表格数据
$(document).ready(function() {
	$("#startTime").ligerDateEditor( {
        label: '开始时间',
        labelWidth: 100,
        showTime :false,
        labelAlign: 'center',
        cancelable : false
	});
	
	$("#endTime").ligerDateEditor( {
	        label: '结束时间',
	        labelWidth: 100,
	        showTime :false,
	        labelAlign: 'center',
	        cancelable : false
	});

	
	defaultTime(); //给startTime，endTime 默认值
	
	
	
	initGrid({Rows:TaskReportData});
	
	foundTaskGrid();
});
//根据时间查询获得表格数据
function foundTaskGrid(){
    waiting();
	var startTime = $("#startTime").val()+" 00:00:01";
	var endTime = $("#endTime").val()+" 23:59:59";
	$.ajax({
        type: "get",
        url: "printExcleController/getAllReviewTaskInfo.do?time=" + new Date().getTime(),
        data: {
            "startTime": startTime,
            "endTime": endTime
        },
        success: function(result) {
        	debugger
//        	alert(result.result[0].startTime);
        	var taskName,taskId,startTime,endTime,needTime,taskFinishState, allDeviceCount, alarmDeviceCount,identifyErrorCount,infraredErrorCount,reviewState;
        	//TaskReportData += "{Rows:[";
        	TaskReportData=[];
        	for(var i = 0 ; i < result.result.length ; i ++){
        		
        		taskId = result.result[i].taskId;
        		taskName = result.result[i].taskName;
        		taskFinishState = result.result[i].taskFinishState;
        		startTime = result.result[i].startTime;
        		endTime = result.result[i].endTime;
        		allDeviceCount = result.result[i].allDeviceCount;
        		alarmDeviceCount = result.result[i].alarmDeviceCount;
        		identifyErrorCount = result.result[i].identifyErrorCount;
        		infraredErrorCount = result.result[i].infraredErrorCount;
        		needTime = GetDateDiff(startTime,endTime);

                if(result.result[i].isReview){
                    reviewState="已审核";
                }else{
                    reviewState="未审核";
                }
        		
        		
        		TaskReportData.push({
        			"task_desc":taskName, 
                	"taskId":taskId ,
                	"start_time":startTime ,
                	"end_time":endTime,
                	"need_time":needTime,
                	"task_finish_state":taskFinishState ,
                	"all_device_count":allDeviceCount ,
                	"alarm_device_count":alarmDeviceCount,	
                	"identify_error_count":identifyErrorCount,  
                	"infrared_error_count":infraredErrorCount,
                	"reviewState":reviewState
        		});
        	}
//            alert('选择的是:        ' + TaskReportData);
        	//TaskReportData = eval('(' + TaskReportData + ')');
        	//initGrid();
        	gridManager.loadData({Rows:TaskReportData});
            gridManager.changePage("first");
        	closeWaitDialog();
        }
    });
}

function initGrid(datas){
	//定义数据表格数据字段，样式，导入数据
	$("#alarmgrid").ligerGrid({
	    columns: [
	    { display: 'id', name: 'taskId', hide:true},
	    { display: '任务名称', name: 'task_desc',width:'20%'  },
	    { display: '任务状态', name: 'task_finish_state',width:'5%' },
	    { display: '任务开始时间', name: 'start_time',width:'10%'  },
	    { display: '任务结束时间', name: 'end_time',width:'10%' },
	    { display: '总时长', name: 'need_time',width:'10%' },
	    { display: '总巡检点位', name: 'all_device_count',width:'10%'  },
	    { display: '正常点位', name: 'identify_error_count',width:'10%'  },
	    { display: '告警点位', name: 'alarm_device_count',width:'10%'  },
	    { display: '识别异常点位', name: 'infrared_error_count',width:'10%'  },
	    { display: '是否审核', name: 'reviewState',width:'5%'  },
	    ], dataAction: 'server', data: datas, sortName: 'id',
	    

	    width: '98%', height: '100%', pageSize: 26,rownumbers:true,rowtitle:true,
	    checkbox : true,pageSizeOptions:[26,36,46,56,66],isSingleCheck:true,
	    //应用灰色表头
	    cssClass: 'l-grid-gray2014', 
	    heightDiff: -6,
	    onCheckRow: function (checked, data, rowindex, rowobj)
	    {
	    	localStorage.taskId=data.taskId;
	       // checked && $.ligerDialog.alert('选择的是' + data.task_desc);
	    }
	});
	gridManager = $("#alarmgrid").ligerGetGridManager();
	$("#pageloading").hide();     

}

//根据id 给PreviewData赋值
function getCheckedData(){
    var rows = gridManager.getCheckedRows();
    var id = new Array();
    var idcount = 0;
    //获得id 
    $(rows).each(function (){
    	id[idcount] = this.taskId;
    	idcount++;
    });
    
    
     $.ajax({
        type: "get",
        url: "printExcleController/getTaskReportInfo.do?time=" + new Date().getTime(),
        data: {
            "taskIdList": id.toString()
        },
        success: function(result) {
        	debugger
//        	window.location.href= "ExcelTest.jsp";
        	PreviewData = "{Rows:[" ;
        	    var taskDesc,startTime,endTime,needTime,totalCount,noramlCount,errorCount,identifyErrorCount,
        	    	envTemp,envHum,envWind,errorDeviceInfoList,identifyErrorDeviceInfoList,noarmalDeviceInfoList
        	    	,taskPathType,stationName;
        	    for(var i=0;i<result.result.length;i++){
        	    	taskDesc = result.result[i].taskDesc;
        	    	startTime = result.result[i].startTime;
        	    	endTime = result.result[i].endTime;
        	    	needTime = result.result[i].needTime;
        	    	totalCount = result.result[i].totalCount;
        	    	noramlCount = result.result[i].noramlCount;
        	    	errorCount = result.result[i].errorCount;
        	    	identifyErrorCount = result.result[i].identifyErrorCount;
        	    	envTemp = result.result[i].envTemp;
        	    	envHum = result.result[i].envHum;
        	    	envWind = result.result[i].envWind;
        	    	errorDeviceInfoList = result.result[i].errorDeviceInfoList;
        	    	identifyErrorDeviceInfoList = result.result[i].identifyErrorDeviceInfoList;
        	    	noarmalDeviceInfoList = result.result[i].noarmalDeviceInfoList;
        	    	taskPathType=result.result[i].taskPathType;
        	    	stationName=result.result[i].stationName;
        	    	PreviewData += "{ taskDesc:'"+ taskDesc 
        	    	+"', startTime:'"+startTime
        			+"', endTime:'"+endTime
        			+"', needTime:'"+needTime
        			+"', totalCount:'"+totalCount
        			+"', noramlCount:'"+noramlCount
        			+"', errorCount:'"+errorCount
        			+"', identifyErrorCount:'"+identifyErrorCount
        			+"', envTemp:'"+envTemp
        			+"', envHum:'"+envHum
        			+"', envWind:'"+envWind
        			+"', errorDeviceInfoList:'"+errorDeviceInfoList
        			+"', identifyErrorDeviceInfoList:'"+identifyErrorDeviceInfoList
        			+"', noarmalDeviceInfoList:'"+noarmalDeviceInfoList
        			+",taskPathType:'"+taskPathType
        			+",stationName:'"+stationName
        			+"' },";
        	    }
        	if(PreviewData.length != 7){
        		PreviewData = PreviewData.substring(0, PreviewData.length-1);
        	}
        	    PreviewData += "]}";
        	    //alert('选择的是:        ' + PreviewData);
        	    PreviewData = eval('(' + PreviewData + ')');
        	    //alert(PreviewData.Rows);
        }
    });
   
}

/**
 * 预览按钮
 */
function exportReport(){

    var rows = gridManager.getCheckedRows();
    var id = new Array();
    var idcount = 0;
    //获得id 
    $(rows).each(function (){
    	id[idcount] = this.taskId;
    	idcount++;
    });
    
    if( id.length == 0){
    	alert("请勾选一个任务！");
    	return;
    }
    waiting();
     $.ajax({
        type: "get",
        url: "printExcleController/getTaskReportInfo.do?time=" + new Date().getTime(),
        data: {
            "taskIdList": id.toString()
        },
        success: function(result) {
            debugger
                closeWaitDialog();
                //alert(JSON.stringify(result));
        	    $.ligerDialog.open({ url: 'jsp/robot/result_affirm/previewTask.jsp',
        	    	height: 600,
        	    	width:1300,
        	    	allowClose :true,
        	    	title :"巡检报告预览", 
        	    	buttons: [
		              { text: '导出', onclick: function (item, dialog) { ExcelPrint(); },cls:'l-dialog-btn-highlight' },
		              { text: '取消', onclick: function (item, dialog) { dialog.close(); } }
		           ], 
		           isResize: true,
		           data: result.result
		        });       	    
        	    
        },
        error:function() {
           closeWaitDialog();
        }
    });
   
}
//打印预览ifram
function f_open()
{
    $.ligerDialog.open({ url: 'jsp/robot/result_affirm/previewTask.jsp', height: 900,width:1300,allowClose :true,title :"打印预览", buttons: [
        { text: '导出', onclick: function (item, dialog) { location.href="ExcelTest.jsp"; },cls:'l-dialog-btn-highlight' },
        { text: '取消', onclick: function (item, dialog) { dialog.close(); } }
     ], isResize: true,data: {'PreviewData':PreviewData }
    });
}


/**
 * 导出 重定向到excle打印页面
 */
function ExcelPrint() {

	var rows = gridManager.getCheckedRows();
    var task_id = new Array();
    var i = 0;
    $(rows).each(function (){
    	task_id[i] = this.taskId;
    	i++;
    });
    
    if(task_id.length == 0){
    	alert("请勾选一个任务！");
    	return;
    }
    waiting();
    setTimeout(function(){
    	debugger
        var submitUserName=$("iframe").contents().find(".submitUserName").val();
        var submitSuggestionContent=$("iframe").contents().find(".submitSuggestionContent").val();
        var submitTime=$("iframe").contents().find(".submitTime").val();
/*        if(submitUserName=="" || submitUserName=="请输入审核人员姓名！"){
            alert("请输入审核人员姓名！");
            closeWaitDialog();
            return false;
        }
        if(submitSuggestionContent=="" || submitSuggestionContent=="请输入审核意见！"){
            alert("请输入审核意见！");
            closeWaitDialog();
            return false;
        }
        if(submitTime==""){
            alert("请输入审核时间！");
            closeWaitDialog();
            return false;
        }*/
        //获得数据
        $.ajax({
            type: "get",
            async:false,
            url: "printExcleController/getTaskReportInfo.do?time=" + new Date().getTime(),
            async:false,
            data: {
                "taskIdList": task_id.toString(),
                "submitUser":$("iframe").contents().find(".submitUserName").val(),
                "submitSuggestionContent":$("iframe").contents().find(".submitSuggestionContent").val(),
                "submitTime":$("iframe").contents().find(".submitTime").val()
            },
            success: function(result) {
            	
            	/*$.ajax({
                    type: "get",
                    url: "ExcelTaskTest.jsp?time=" + new Date().getTime(),
                    success: function(result) {
                    	 closeWaitDialog();
                    }
                })*/
                alert("正在导出...点击确认以后耐心等待！");
            	window.location.href= "ExcelTaskTest.jsp";
            	closeWaitDialog();
            }
        })
        
    },100);
}




//计算时间
function GetDateDiff(startDate,endDate){ 
	if(startDate==null||startDate==""){
		startDate = new Date().toString();
	}
	if(endDate==null||endDate==""){
		endDate = new Date().toString();
	}
    var startTime = new Date(Date.parse(startDate.replace(/-/g,   "/"))).getTime();     
    var endTime = new Date(Date.parse(endDate.replace(/-/g,   "/"))).getTime();     
    var dates = Math.abs((startTime - endTime));
    var date = new Date(dates);
	//计算出相差天数
	var days=Math.floor(dates/(24*3600*1000));
	//计算出小时数
	var leave1=dates%(24*3600*1000);    //计算天数后剩余的毫秒数
	var hours=Math.floor(leave1/(3600*1000));
	//计算相差分钟数
	var leave2=leave1%(3600*1000);        //计算小时数后剩余的毫秒数
	var minutes=Math.floor(leave2/(60*1000));
	//计算相差秒数
	var leave3=leave2%(60*1000);      //计算分钟数后剩余的毫秒数
	var seconds=Math.round(leave3/1000);
    var needTime='';
    needTime += days + "天" + hours+"时"+minutes+"分"+seconds+"秒";
    return  needTime;    
}