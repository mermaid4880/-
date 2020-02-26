
function connectRootView(vlip, flirIP) {

   

}
//装载巡检任务 注意 只有选中机器人后才能调用这些
function load_xunjianrenwu(robotIp) {
    //$.ajax({
    //    type: "get",
    //    url: "../handler/InterFace.ashx?r=" + Math.random(),
    //    data: {
    //        method: "http_getMethod"
    //        , token: public_token
    //        , MethodUrl: "/taskFinish/now/" + robotIp
    //    },
    //    dataType: "json",
    //    success: function (data) {
    //        if (data.success != true) {
    //            layer.msg(data.detail);
    //            return;
    //        }
    //        data = data.data;
    //        console.log(data.data);
    //        //{"taskFinishId":null,"taskName":null,"meterCount":0,"inspectMeterCount":0,"abnormalMeterCount":0,"nowMeterName":null,"totalTime":null,"progress":null}
    //        if (data) {
    //            //把值列举进去
    //            $("#taskName").text(data.taskName);
    //            // taskstate.date.totalDeviceNum
    //            $("#totalDeviceNum").text(data.meterCount);
    //            // taskstate.date.abnormalMeterCount
    //            $("#warningDevcieNum").text(data.abnormalMeterCount);
    //            // taskstate.date.CurDeviceNum
    //            $("#CurDeviceNum").text(data.nowMeterName);
    //            // taskstate.date.ExpWasteTime
    //            $("#ExpWasteTime").text(data.totalTime);
    //            // taskstate.date.percent
    //            $("#percent").text(data.progress);
    //            // taskstate.date.doneDeviceNum
    //            $("#doneDeviceNum").text(data.abnormalMeterCount);
    //            //
                
    //        }
    //    }
    //});
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
                console.log("123123");
                console.log(data);
                console.log("123123");

                setting.past = data["finishedPoints"];
                setting.next = data["leftPoints"];
                console.log(setting.past);
                console.log(setting.next);

                $("#totalDeviceNum").text(data["finishedPoints"].length + data["leftPoints"].length);
                $("#CurDeviceNum").text(data["currentPoint"]["devicename"]);
                $("#percent").text(data["progressString"]);
                $("#doneDeviceNum").text(data["finishedPoints"].length);
            }
        }
    });
}

//发送请求 选定机器人
//function selectedRoot(vIp) {

//    $.ajax({
//        type: "post",
//        url: "../handler/InterFace.ashx?r=" + Math.random(),
//        data: {
//            method: "http_PostMethod"
//            , token: public_token
//            , MethodUrl: "/robots/" + vIp
//            , postData: ""
//        },
//        dataType: "json",
//        success: function (data) {
           
//            //{success:"true","detail": "xxx"}
//            if (data) {
//                if (data.success == "true") {
//                    layer.msg("选定机器人[" + vIp + "]完成!");
//                    Public_isSelectedRoot = 1;
//                    load_xunjianrenwu(); //***********装载巡检任务 注意 只有选中机器人后才能调用这些
//                }
//                else {
//                    layer.msg("选定机器人[" + vIp + "]失败!");
//                }
//            }
//        }
//    });
//}


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
            maingrid1.set({ data: data })

            //if (data.Total == 0) {
            //    var jsonArray = [{ "id": 1, "meterId": 1, "taskId": 1, "time": "2018-08-14 11:21:16", "detectionValue": "1", "detectionStatus": "正常", "filepath": null, "meterName": "A线路避雷器A相_泄露电流表", "meterType": "泄漏电流表", "detectionType": "表计读取", "saveType": "可见光图片", "deviceId": 1, "taskInfoName": "红外巡检" }, { "id": 4, "meterId": 2, "taskId": 1, "time": "2018-08-15 15:50:24", "detectionValue": "2", "detectionStatus": "正常", "filepath": null, "meterName": "A线路避雷器A相_接头", "meterType": "红外检测点", "detectionType": "红外测温", "saveType": "红外+可见光图片", "deviceId": 1, "taskInfoName": "红外巡检" }, { "id": 7, "meterId": 1, "taskId": 3, "time": "2018-10-31 13:00:24", "detectionValue": "4", "detectionStatus": "预警", "filepath": null, "meterName": "A线路避雷器A相_泄露电流表", "meterType": "泄漏电流表", "detectionType": "表计读取", "saveType": "可见光图片", "deviceId": 1, "taskInfoName": null }, { "id": 8, "meterId": 2, "taskId": 3, "time": "2018-10-31 13:00:46", "detectionValue": "3.0", "detectionStatus": "一般告警", "filepath": null, "meterName": "A线路避雷器A相_接头", "meterType": "红外检测点", "detectionType": "红外测温", "saveType": "红外+可见光图片", "deviceId": 1, "taskInfoName": null }, { "id": 9, "meterId": 3, "taskId": 3, "time": "2018-10-31 13:01:22", "detectionValue": "1", "detectionStatus": "危急告警", "filepath": null, "meterName": "A线路避雷器B相_接头", "meterType": "红外检测点", "detectionType": "红外测温", "saveType": "红外+可见光图片", "deviceId": 2, "taskInfoName": null }, { "id": 10, "meterId": 4, "taskId": 3, "time": "2018-10-31 13:01:51", "detectionValue": "0.9", "detectionStatus": "严重告警", "filepath": null, "meterName": "B线路断路器A相_接头", "meterType": "红外检测点", "detectionType": "红外测温", "saveType": "红外+可见光图片", "deviceId": 3, "taskInfoName": null}];
            //    var json = { "Total": 6, Rows: jsonArray};
            //    maingrid1.set({ data: json });
            //}
            //else {
            //    maingrid1.set({ data: data });
            //}


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

            //if (data.Total == 0) {
            //    var jsonArray = '[{ "id": 1, "meterId": 1, "taskId": 1, "time": "2018-08-14 11:21:16", "detectionValue": "1", "detectionStatus": "正常", "filepath": null, "meterName": "A线路避雷器A相_泄露电流表", "meterType": "泄漏电流表", "detectionType": "表计读取", "saveType": "可见光图片", "deviceId": 1, "taskInfoName": "红外巡检" }, { "id": 4, "meterId": 2, "taskId": 1, "time": "2018-08-15 15:50:24", "detectionValue": "2", "detectionStatus": "正常", "filepath": null, "meterName": "A线路避雷器A相_接头", "meterType": "红外检测点", "detectionType": "红外测温", "saveType": "红外+可见光图片", "deviceId": 1, "taskInfoName": "红外巡检" }, { "id": 7, "meterId": 1, "taskId": 3, "time": "2018-10-31 13:00:24", "detectionValue": "4", "detectionStatus": "预警", "filepath": null, "meterName": "A线路避雷器A相_泄露电流表", "meterType": "泄漏电流表", "detectionType": "表计读取", "saveType": "可见光图片", "deviceId": 1, "taskInfoName": null }, { "id": 8, "meterId": 2, "taskId": 3, "time": "2018-10-31 13:00:46", "detectionValue": "3.0", "detectionStatus": "一般告警", "filepath": null, "meterName": "A线路避雷器A相_接头", "meterType": "红外检测点", "detectionType": "红外测温", "saveType": "红外+可见光图片", "deviceId": 1, "taskInfoName": null }, { "id": 9, "meterId": 3, "taskId": 3, "time": "2018-10-31 13:01:22", "detectionValue": "1", "detectionStatus": "危急告警", "filepath": null, "meterName": "A线路避雷器B相_接头", "meterType": "红外检测点", "detectionType": "红外测温", "saveType": "红外+可见光图片", "deviceId": 2, "taskInfoName": null }, { "id": 10, "meterId": 4, "taskId": 3, "time": "2018-10-31 13:01:51", "detectionValue": "0.9", "detectionStatus": "严重告警", "filepath": null, "meterName": "B线路断路器A相_接头", "meterType": "红外检测点", "detectionType": "红外测温", "saveType": "红外+可见光图片", "deviceId": 3, "taskInfoName": null }]';
            //    var jsonObj = JSON.parse(jsonArray);
            //    var jsonArr = [];
            //    for (var i = 0; i < jsonObj.length; i++) {
            //        if (jsonObj[i]["detectionStatus"] != "正常") {
            //            jsonArr.push(jsonObj[i]);
            //        }
            //    }
            //    var json = { "Total": 6, Rows: jsonArr };
            //    maingrid2.set({ data: json });
            //}
            //else {
            //    maingrid2.set({ data: data });
            //}
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
            maingrid1.set({ data: data })
            //if (data.Total == 0) {
            //    var jsonArray = [{ "id": 1, "meterId": 1, "taskId": 1, "time": "2018-08-14 11:21:16", "detectionValue": "1", "detectionStatus": "正常", "filepath": null, "meterName": "A线路避雷器A相_泄露电流表", "meterType": "泄漏电流表", "detectionType": "表计读取", "saveType": "可见光图片", "deviceId": 1, "taskInfoName": "红外巡检" }, { "id": 4, "meterId": 2, "taskId": 1, "time": "2018-08-15 15:50:24", "detectionValue": "2", "detectionStatus": "正常", "filepath": null, "meterName": "A线路避雷器A相_接头", "meterType": "红外检测点", "detectionType": "红外测温", "saveType": "红外+可见光图片", "deviceId": 1, "taskInfoName": "红外巡检" }, { "id": 7, "meterId": 1, "taskId": 3, "time": "2018-10-31 13:00:24", "detectionValue": "4", "detectionStatus": "预警", "filepath": null, "meterName": "A线路避雷器A相_泄露电流表", "meterType": "泄漏电流表", "detectionType": "表计读取", "saveType": "可见光图片", "deviceId": 1, "taskInfoName": null }, { "id": 8, "meterId": 2, "taskId": 3, "time": "2018-10-31 13:00:46", "detectionValue": "3.0", "detectionStatus": "一般告警", "filepath": null, "meterName": "A线路避雷器A相_接头", "meterType": "红外检测点", "detectionType": "红外测温", "saveType": "红外+可见光图片", "deviceId": 1, "taskInfoName": null }, { "id": 9, "meterId": 3, "taskId": 3, "time": "2018-10-31 13:01:22", "detectionValue": "1", "detectionStatus": "危急告警", "filepath": null, "meterName": "A线路避雷器B相_接头", "meterType": "红外检测点", "detectionType": "红外测温", "saveType": "红外+可见光图片", "deviceId": 2, "taskInfoName": null }, { "id": 10, "meterId": 4, "taskId": 3, "time": "2018-10-31 13:01:51", "detectionValue": "0.9", "detectionStatus": "严重告警", "filepath": null, "meterName": "B线路断路器A相_接头", "meterType": "红外检测点", "detectionType": "红外测温", "saveType": "红外+可见光图片", "deviceId": 3, "taskInfoName": null}];
            //    var json = { "Total": 10, Rows: jsonArray };
            //    maingrid3.set({ data: json });
            //}
            //else {
            //    maingrid3.set({ data: data });
            //}
            //console.log(data);
        }
    });
}