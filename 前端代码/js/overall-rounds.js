$(function(){
		
	var tree = null;
	var treeManager =null;
	
	//缓存所有的树节点
	var treeAche = [];
	
	createTree();
		
	$(".equipment-area,.equipment-type,.distinguish-type,.meter-type").attr("onchange","getSearchDevice()");
	
})


/**
 * 用于显示更多的checkbox的onchange事件
 * @param a checkbox的id
 * @param b	需要隐藏，显示的checkbox的name属性
 */
function displayMore(a,b){
    if( $("#" + a).is(":checked") ){
		$("span[name='" + b + "']").css("display","inline-block");	
	}else{
		$("span[name='" + b + "']").hide();
	}
}


/**
 * 全选的checkbox
 * @param a
 * @param b
 */
function selectAll(a,b){
	 if( $("." + a + ":checkbox").is(":checked") ){
		 $("." + b + ":checkbox").prop('checked',"checked");
	 }else{
		 $("." + b + ":checkbox").removeAttr("checked");
	 }
	 
	 
	 getSearchDevice();
}


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
					treeData.push({
						id:item.areaId,
						pid:item.parentId,
						text:item.areaDesc,
						ischecked:true});
				});
			}else{
				alert("获取所有区域信息出错")
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
					treeData.push({
						id:"d"+item.deviceId,
						pid:item.areaId,
						text:item.deviceDesc,
						ischecked:true});
				});
			}else{
				alert("获取所有设备信息出错");
			}
		},
		error:function(e){
			alert("获取所有设备信息的请求出错");
		}
	});
	
	
	
	
	 tree = $("#tree-ul").ligerTree({  
	             data:treeData, 
	             idFieldName :'id',
	             slide : false,
	             parentIDFieldName :'pid'
             });
     treeManager = $("#tree-ul").ligerGetTreeManager();
     
   //  treeManager.expandAll();
     treeAche = treeData;
}



/**
 * 根据勾选的条件查询相关的设备，并在树中打上勾
 */
function getSearchDevice(){
	
	//清空所有已勾选
	f_cancelSelectNode();
	
	//将选中的id拼接成字符串，以,隔开
	var equipment_area = "";
	var equipment_type = "";
	var distinguish_type = "";
	var meter_type = "";
	
	//设备区域
	$(".equipment-area:checkbox").each(function(i,item){
		if($(item).is(":checked")){
			equipment_area = equipment_area + $(item).attr("id") + ",";
		}
	});
	
	//设备类型
	$(".equipment-type:checkbox").each(function(i,item){
		if($(item).is(":checked")){
			equipment_type = equipment_type + $(item).attr("id") + ",";
		}
	});
	
	//识别类型
	$(".distinguish-type:checkbox").each(function(i,item){
		if($(item).is(":checked")){
			distinguish_type = distinguish_type + $(item).attr("id") + ",";
		}
	});
	
	//表计类型
	$(".meter-type:checkbox").each(function(i,item){
		if($(item).is(":checked")){
			meter_type = meter_type + $(item).attr("id") + ",";
		}
	});
	
	//去除最后一个 ,
	equipment_area = equipment_area.substring(0,equipment_area.length - 1);
	equipment_type = equipment_type.substring(0,equipment_type.length - 1);
	distinguish_type = distinguish_type.substring(0,distinguish_type.length - 1);
	meter_type = meter_type.substring(0,meter_type.length - 1);
	
	
	//发起筛选请求
	$.ajax({
		type:"post",
		url:"substation/getSearchDevice.do?time=" + new Date().getTime(),
		data:{
			"equipment_area":equipment_area,
			"equipment_type":equipment_type,
			"distinguish_type":distinguish_type,
			"meter_type":meter_type
		},
		success:function(retData){
 			if(retData.result == "1"){
 				for(var i = 0 ; i<retData.data.length ; i++){
 					f_selectNode(retData.data[i]);
 					
 					//for(var i=)
 					
 				}
			}else{
				alert("获取满足筛选条件的所有设备id列表出错");
			}
 			
 			 tree.refreshTree();
		},
		error:function(){
			alert("获取满足筛选条件的所有设备id列表的请求出错");
		}
	});
	
}


/**
 * 勾上左下侧树上 id == nodeId 的 节点
 * @param nodeId
 */
function f_selectNode(nodeId){
     var parm = function (data){
         return data.id == nodeId;
     };
     tree.selectNode(parm);
     
    
 }


/**
 * 清空所有已选择
 */
function f_cancelSelectNode(){
	
	for(var i=0 ; i<treeAche.length ; i++){
		treeAche[i].children=null;
		treeAche[i].ischecked = false; 
	}
	
	$("#tree-ul").html("");
	
	 tree = $("#tree-ul").ligerTree({   
         data:treeAche, 
         idFieldName :'id',
         slide : false,
         parentIDFieldName :'pid'
     });
	 
	 treeManager = $("#tree-ul").ligerGetTreeManager();
}


/**
 * 根据关键字搜索，并展开树节点
 * @param key
 */
function searchByText(){
	
	var key = $("#searchId").val()
	
	if(key == null || key == ""){
		return false;
	}
	
	//初始化数据
	for(var i=0 ; i<treeAche.length ; i++){
		treeAche[i].children=null;
		treeAche[i].ischecked = false;
		treeAche[i].isExpand = false; 
	}
	
	
	
	for(var i=0 ; i<treeAche.length ; i++){
		if( treeAche[i].text.indexOf(key) >= 0 ){
			treeAche[i].ischecked = true;
			expendParent(treeAche,treeAche[i].pid);
		}
	}
	
	
	$("#tree-ul").html("");
	
	tree = $("#tree-ul").ligerTree({   
        data:treeAche, 
        idFieldName :'id',
        slide : false,
        parentIDFieldName :'pid',
        isExpand:false
    });
	
	tree.refreshTree();
}


/**
 * 将所有的父节点展开（包括父节点的父节点的父节点...）
 * @param tData
 * @param pid
 */
function expendParent(tData,pid){
	for(var i=0 ; i<tData.length ; i++){
		if( tData[i].id == pid){
			tData[i].isExpand = true;
			expendParent(tData,tData[i].pid);
		}
	}
}
