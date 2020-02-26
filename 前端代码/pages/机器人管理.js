function connectRootView(vRootJson) {
    
    var vlip = vRootJson.vlip;//视频1
    var flirIP = vRootJson.flirIP;//视频2 

    var url1 = "../webVideo/webVideo1.aspx?ip=" + vlip;
    document.getElementById("frameWebVideo1").src = url1;

    var url2 = "../webVideo/webVideo2.aspx?ip=" + flirIP;
    document.getElementById("frameWebVideo2").src = url2;
}

//装载巡检任务 注意 只有选中机器人后才能调用这些
function load_xunjianrenwu(robotIp) {
    $.ajax({
        type: "get",
        url: "../handler/InterFace.ashx?r=" + Math.random(),
        data: {
            method: "http_getMethod"
            , token: public_token
            , MethodUrl: "/robots/testmap" 
        },
        dataType: "json",
        success: function (data) {
            if (!data.success) {
                layer.msg(data.detail);
                return;
            }
            
            data = JSON.parse(data.data);
            
            //{"taskFinishId":null,"taskName":null,"meterCount":0,"inspectMeterCount":0,"abnormalMeterCount":0,"nowMeterName":null,"totalTime":null,"progress":null}
            if (data) {
                ////把值列举进去
                //$("#taskName").text(data.taskName);
                //// taskstate.date.totalDeviceNum
                //$("#totalDeviceNum").text(data.meterCount);
                //// taskstate.date.abnormalMeterCount
                //$("#warningDevcieNum").text(data.abnormalMeterCount);
                //// taskstate.date.CurDeviceNum
                //$("#CurDeviceNum").text(data.nowMeterName);
                //// taskstate.date.ExpWasteTime
                //$("#ExpWasteTime").text(data.totalTime);
                //// taskstate.date.percent
                //$("#percent").text(data.progress);
                //// taskstate.date.doneDeviceNum
                //$("#doneDeviceNum").text(data.abnormalMeterCount);
                console.log(data);

                setting.past = data["finishedPoints"];
                setting.next = data["leftPoints"];
                console.log(setting.past);
                console.log(setting.next);

                $("#totalDeviceNum").text(data["finishedPoints"].length + data["leftPoints"].length);
                $("#CurDeviceNum").text(data["currentPoint"]["devicename"]);
                $("#percent").text(data["progressString"]);
                $("#doneDeviceNum").text(data["finishedPoints"].length );
            }
        }
    });
}

//发送请求 选定机器人
function selectedRoot(vIp) {

    $.ajax({
        type: "post",
        url: "../handler/InterFace.ashx?r=" + Math.random(),
        data: {
            method: "http_PostMethod"
            , token: public_token
            , MethodUrl: "/robots/" 
            , postData: "robotIP=" + vIp
        },
        dataType: "json",
        success: function (data) {
            
            //{success:"true","detail": "xxx"}
            if (data) {
                if (data.success) {
                    //layer.msg("选定机器人[" + vIp + "]完成!");
                    Public_isSelectedRoot = 1;
                    load_xunjianrenwu(vIp);//***********装载巡检任务 注意 只有选中机器人后才能调用这些

                    //获得机器人地图
                    getMap();
                }
                else {
                    layer.msg("选定机器人[" + vIp + "]失败!");
                }
            }
        },
        error: function (XMLHttpRequest, textStatus, errorThrown) {
            //alert(XMLHttpRequest.status);
        }
    });
}

function getMap() {
   
    $.ajax({
        type: "get",
        url: "../handler/InterFace.ashx?r=" + Math.random(),
        data: {
            method: "http_getMethod"
            , token: public_token
            , MethodUrl: "/robots/mapURL"

        },
        dataType: "json",
        success: function (data) {
            if (data) {
                if (data.success) {
                    setting.map = data.data;
                   //让画布显示url
                   // board.init();
                }
                else {
                    layer.msg("加载地图失败");
                }
            }
        },
        error: function (XMLHttpRequest, textStatus, errorThrown) {
            //alert(XMLHttpRequest.status);
        }
    });
}

function getdb1() {

    $.ajax({
        type: "get",
        url: "../handler/InterFace.ashx?r=" + Math.random(),
        data: {
            method: "http_getGridMethod"
            , token: public_token
            , MethodUrl: "/detectionDatas/latest"
        },
        dataType: "json",
        success: function (data) {
            if (!data.success) {
                layer.msg(data.detail);
                return;
            }
            maingrid1.set({ data: data });
        }
    });
}

function getdb2() {
    $.ajax({
        type: "get",
        url: "../handler/InterFace.ashx?r=" + Math.random(),
        data: {
            method: "http_getGridMethod"
            , token: public_token
            , MethodUrl: "/detectionDatas/latest"
        },
        dataType: "json",
        success: function (data) {
            if (!data.success) {
                layer.msg(data.detail);
                return;
            }
            var jsonObj = JSON.parse(data.Rows); 
            var jsonArr = [];
            for (var i = 0; i < jsonObj.length; i++) {
                if (jsonObj[i]["detectionStatus"] != "正常") {
                    jsonArr.push(jsonObj[i]);
                }
            }
            data.Rows = jsonArr;
            data.Total = jsonArr.length;
            maingrid2.set({ data: data });
        }
    });
}

function getdb3() {
    $.ajax({
        type: "get",
        url: "../handler/InterFace.ashx?r=" + Math.random(),
        data: {
            method: "http_getGridMethod"
            , token: public_token
            , MethodUrl: "/systemAlarms/latest"
        },
        dataType: "json",
        success: function (data) {
            if (!data.success) {
                layer.msg(data.detail);
                return;
            }
            maingrid1.set({ data: data });
        }
    });
}