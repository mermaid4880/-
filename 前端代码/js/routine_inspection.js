var tree = null;
var treeAche = [];

var setting = {
		view: {
			selectedMulti: false
		},
		check: {
			enable: true
		},
		data: {
			simpleData: {
				enable: true
			}
		}
	};

$(function(){	
	
	//识别类型的全选checkbox 
	$(".distinguish-type-selectall").prop('checked',false);
	$(".distinguish-type-selectall").attr("disabled",true);
	$(".distinguish-type-selectall").addClass("disabled");
	
	$("input:checkbox[value='红外测温']").prop('checked',false);
	$("input:checkbox[value='红外测温']").attr("disabled",true);
	$("input:checkbox[value='红外测温']").addClass("disabled");
	
	
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
						id:item.areaId,
						pId:item.parentId,
						name:item.areaDesc,
						//checked:true,
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
						id:10000+item.deviceId,
						pId:item.areaId,
						name:item.deviceDesc,
						//checked:true,
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
function getSearchDevice(){
	
	refreshSearchType();
	
	//清空所有已勾选
	f_cancelSelectNode();
	
	//将选中的id拼接成字符串，以,隔开
	var equipment_area = "";
	var equipment_type = "";
	var distinguish_type = "";
	var meter_type = "";
	var surface_type = "";
	
	var ignoreItem = "";
	
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
	
	
	//外观检查
	$(".surface-type:checkbox").each(function(i,item){
		if($(item).is(":checked")){
			meter_type = meter_type + $(item).attr("id") + ",";
		}
	});
	
	//去除最后一个 ,
	equipment_area = equipment_area.substring(0,equipment_area.length - 1);
	equipment_type = equipment_type.substring(0,equipment_type.length - 1);
	distinguish_type = distinguish_type.substring(0,distinguish_type.length - 1);
	meter_type = meter_type.substring(0,meter_type.length - 1);
	surface_type = surface_type.substring(0,surface_type.length - 1);
	
	
//	console.log("equipment_area:" +equipment_area );
//	console.log("equipment_type:" +equipment_type );
//	console.log("distinguish_type:" +distinguish_type );
//	console.log("meter_type:" +meter_type );
//	console.log("surface_type:" +surface_type );
	
	//如果某一个大项什么都没有勾选，则传1，
	
	ignoreItem += surface_type.length     > 0 ? "0":"1";
	ignoreItem += meter_type.length       > 0 ? "0":"1";
	ignoreItem += equipment_type.length   > 0 ? "0":"1";
	ignoreItem += distinguish_type.length > 0 ? "0":"1";
	ignoreItem += equipment_area.length   > 0 ? "0":"1";
	
	console.log("ingnoreItem：" + ignoreItem);

	//00000000 00000000 0000000 000  + ingnoreItem
	
	//发起筛选请求
	$.ajax({
		type:"post",
		url:"substation/getSearchDevice.do?time=" + new Date().getTime(),
		data:{
			"equipment_area":equipment_area,
			"equipment_type":equipment_type,
			"distinguish_type":distinguish_type,
			"meter_type":meter_type,
			"surface_type":surface_type,
			"ignoreItem":ignoreItem
		},
		success:function(retData){
 			if(retData.result == "1"){
 				displayDeviceIdList(retData.data);
 				
			}else{
				alert("获取满足筛选条件的所有设备id列表出错");
			}
		},
		error:function(){
			alert("获取满足筛选条件的所有设备id列表的请求出错");
		}
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
		return false;
	}
	
	for(var i=0 ; i<treeAche.length ; i++){
		treeAche[i].checked = false;
		treeAche[i].isHidden = true;
		treeAche[i].open = false;
	}
	
	//初始化数据
	for(var i=0 ; i < treeAche.length ; i++){
		if(treeAche[i].type == "device" && treeAche[i].name.indexOf(key) > 0){
			treeAche[i].checked = true;
			treeAche[i].isHidden = false;
			expendParent(treeAche,treeAche[i].pId);
		}
	}

	$("#treeDemo").html("");
	
	 tree = $.fn.zTree.init($("#treeDemo"), setting, treeAche);
	 	 
	 var nodes = tree.getNodesByParam("isHidden",true);
	 
	 for(var i = 0 ; i < nodes.length ; i++ ){
		tree.removeNode(nodes[i]);
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
/*function resetPage(){
	//getSearchDevice();
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

	// $(".l-tab-links").click();
}*/


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
	 	 
	 
	//联动勾选父节点 
	var nodes = tree.getCheckedNodes();
	for(var i= 0 ; i<nodes.length ; i++){
		tree.checkNode(nodes[i],true,true);
	}
	 
}





/**
 * 只<<<<<<<<<显示>>>>>>>deviceIdList中的设备
 * @param deviceIdList 设备的Id数组
 */
function displayDeviceIdList2(deviceIdList){
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
	 
	 
	//联动勾选父节点 
	var nodes = tree.getCheckedNodes();
	for(var i= 0 ; i<nodes.length ; i++){
		tree.checkNode(nodes[i],true,true);
	}
	 
}

