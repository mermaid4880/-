/**
 * 间隔展示
 * add by Cuijiekun,
 * date:2016-10-28 14:52:35
 */

$(function(){
	
	$.ajax({
		type:"post",
		url:"substation/getShowArea.do?time=" + new Date().getTime(),
		async:false,
		success:function(data){
			
			var rootElem = $("#equipmentBlockId");
			
			for(var i = 0; i< data.data.firstArea.length ; i++){
				
				var pareatId = data.data.firstArea[i].areaId;
				
				
				var str = "<div class='equipment-display'>";
				str+=		"<div class='left col-lg-1 col-md-1 col-sm-1 col-xs-1'>" + data.data.firstArea[i].areaDesc + "</div>";
				str+= 		"<div class='right col-lg-11 col-md-11 col-sm-11 col-xs-11'>";
				
				for(var j=0 ; j< data.data.secondArea.length ; j++){
					
					if(data.data.secondArea[j].parentId == pareatId){
						str+= "	<span class='" + getColorByLevel(data.data.secondArea[j].stateLevel) + "' onclick=f_open('" + data.data.secondArea[j].areaDesc + "'" + ",'" + data.data.secondArea[j].areaId + "'" + ")>" + data.data.secondArea[j].areaDesc + "</span>" ;
					}
					
				}
				
				str+="		</div>";
				str+="</div>";
				
				rootElem.append(str);
				
			}
		},
		error:function(e){}
		
	});
});



/**
 * 根据告警等级获取颜色
 * @param level
 * @returns {String}
 */
function getColorByLevel(level){
	/*
	 * 0-正常
	 * 1-预警
	 * 2-一般警告
	 * 3-严重警告
	 * 4-危急警告
	 */
	
	if(level == "0"){
		return "green";
	}else if(level == "1"){
		return "blue";
	}else if(level == "2"){
		return "yellow";
	}else if(level == "3"){
		return "orange";
	}else if(level == "4"){
		return "red";
	}else{
		return "gray";
	}
}


//打开二级框
function f_open(title,areaId)
{
    var dialog=$.ligerDialog.open({
        height:600,
        width: 900,
        title : title,
        url: 'jsp/robot/result_affirm/dialog-interval-display.jsp', 
        showMax: false,
        showToggle: true,
        showMin: false,
        isResize: true,
        slide: false,
        data: {
        	'areaId': areaId,
        }
    });
    dialog.set('title', title); //设置标题
} 