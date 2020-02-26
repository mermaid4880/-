$(function(){ 
			//定义数据表格数据字段，样式，导入数据
            $("#maingrid").ligerGrid({
                columns: [
                { display: '识别时间', name: 'time', align: 'center', width: "20%"},
                { display: '点位名称', name: 'device_desc', Width: "20%" },
                { display: '识别类型', name: 'patrol_type', Width: "20%" },
                { display: '识别结果', name: 'patrol_value',width:"18%" },
                { display: '告警等级', name: 'alarm_level',width:"20%" }
                ], dataAction: 'server', data: CustomersData, sortName: 'time',
                width: '98%', height: '250px', pageSize: 6,rownumbers:true,rowtitle:true,
                checkbox : false,pageSizeOptions :[6,10,20,30,40],
                //应用灰色表头
                cssClass: 'l-grid-gray2014', 
                heightDiff: -6,
                onDblClickRow:function(data,rowindex,rowobj){
                	var deviceId = data.device_id;
                	var targetId = data.target_id;
                	
                	if(deviceId == "" || targetId == ""){
                		conlose.log("deviceId:" + deviceId + ",targetId:" + targetId);
                		return;
                	}
                	
                    f_click('addTabItem','dbHistory/inspectionDeviceResults.do?deviceId='+deviceId + "&targetId=" + targetId,'设备相关浏览');
                }
            });
            $("#secondgrid").ligerGrid({
                columns: [
                      { display: '识别时间', name: 'time', align: 'center', width: "20%"},
                      { display: '点位名称', name: 'device_desc', Width: "20%" },
                      { display: '识别类型', name: 'patrol_type', Width: "25%" },
                      { display: '识别结果', name: 'patrol_value',width:"18%" },
                      { display: '告警等级', name: 'alarm_level',width:"20%" }
                ], dataAction: 'server', data: CustomersData, sortName: 'time',
                width: '98%', height: '251px', pageSize: 6,rownumbers:true,rowtitle:true,
                checkbox : false,pageSizeOptions :[6,10,20,30,40],
                //应用灰色表头
                cssClass: 'l-grid-gray2014', 
                heightDiff: -6,
                onDblClickRow:function(data,rowindex,rowobj){
                	var deviceId = data.device_id;
                	var targetId = data.target_id;
                	
                	if(deviceId == "" || targetId == ""){
                		conlose.log("deviceId:" + deviceId + ",targetId:" + targetId);
                		return;
                	}
                	
                    f_click('addTabItem','dbHistory/inspectionDeviceResults.do?deviceId='+deviceId + "&targetId=" + targetId,'设备相关浏览');
                
                }
            });
            $("#thirdgrid").ligerGrid({
                columns: [
                { display: '识别时间', name: 'time',width:"35%" },
                { display: '告警内容', name: 'alarm_context',width:"30%" },
                { display: '告警等级', name: 'alarm_level',width:"35%" }
                ], dataAction: 'server', data: CustomersData, sortName: 'time',
                width: '98%', height: '251px', pageSize: 6,rownumbers:true,rowtitle:true,
                checkbox : false,pageSizeOptions :[6,10,20,30,40],
                //应用灰色表头
                cssClass: 'l-grid-gray2014', 
                heightDiff: -6,
                onDblClickRow:function(data,rowindex,rowobj){
                    f_click('addTabItem','alarmInquireController/goToalarmInquire.do','机器人告警查询');
                }
            });  
            gridManager = $("#maingrid").ligerGetGridManager();
 			gridManager = $("#secondgrid").ligerGetGridManager();
 			gridManager = $("#thirdgrid").ligerGetGridManager();
            $("#pageloading").hide();

            //控制标题单击事件显示不同的表格数据

			$(".info .title span").click(function(){
				var spanIndex=$(".info .title span").index(this);
				$(".info .title span").removeClass("active").eq(spanIndex).addClass("active");
				$(".info .grid").hide().eq(spanIndex).show();

                if(spanIndex==0 && realInfoUnread!=0){
                    $(".real-info-unread").text("0").hide();
                    realinfoUnread=0;
                }else if(spanIndex==1 && deviceAlarmUnread!=0){
                    $("#deviceAlarm")[0].pause();
					$(".device-alarm-unread").text("0").hide();
					deviceAlarmUnread=0;
				}else if(spanIndex==2 && systemAlarmUnread!=0){
                    $("#systemAlarm")[0].pause();
					$(".system-alarm-unread").text("0").hide();
					systemAlarmUnread=0;
				}
				
			})

			//加载报警信息未读条数
			if(deviceAlarmUnread!=0){
				$(".device-alarm-unread").text(deviceAlarmUnread).show();
			}
			if(systemAlarmUnread!=0){
				$(".system-alarm-unread").text(systemAlarmUnread).show();
			}

            //加载报警信息
            reloadAlarmIfo();
})
/*alarmInfoGoTo('robot-manage.jsp','设备告警查询确认');
            function alarmInfoGoTo(url,tabid){
                if(navtab.isTabItemExist(tabid)){
                    navtab.selectTabItem(tabid);
                }else{
                    navtab.addTabItem({ tabid:tabid }); 
                }
            }*/