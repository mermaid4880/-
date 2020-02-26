/*

*/

function showLoading() {
    layer.load(2); //风格1的加载
}

function closeLoading() {
    layer.closeAll();
}



function getCurrentYMD() {
    var myDate = new Date();
    var myY = myDate.getFullYear();    //获取完整的年份(4位,1970-????)
    var myM = myDate.getMonth() + 1;       //获取当前月份(0-11,0代表1月)
    var myD = myDate.getDate();        //获取当前日(1-31)
    var tm = myM > 9 ? myM.toString() : "0" + myM.toString();
    var td = myD > 9 ? myD.toString() : "0" + myD.toString();
    var tt = myY + "-" + tm + "-" + td;
    return tt;
}

function getCurrentAddDayYMD(dayadd) {

    var a = new Date();
    a = a.valueOf()
    a = a + dayadd * 24 * 60 * 60 * 1000

    var myDate = new Date(a)
    var myY = myDate.getFullYear();    //获取完整的年份(4位,1970-????)
    var myM = myDate.getMonth() + 1;       //获取当前月份(0-11,0代表1月)
    var myD = myDate.getDate();        //获取当前日(1-31)
    var tm = myM > 9 ? myM.toString() : "0" + myM.toString();
    var td = myD > 9 ? myD.toString() : "0" + myD.toString();
    var tt = myY + "-" + tm + "-" + td;
    return tt;
}

function getdefaulttime(defaultDate) {
    var myDate = new Date();
    var time;
    var myY = myDate.getFullYear();    //获取完整的年份(4位,1970-????)
    var myM = myDate.getMonth() + 1;       //获取当前月份(0-11,0代表1月)
    var myD = myDate.getDate();        //获取当前日(1-31)
    tt = myM + '-' + myD;

    if (myM == 10 || myM == 11 || myM == 12) {
        time = myY + '-' + defaultDate;
    } else {
        myY = myY - 1;
        time = myY + '-' + defaultDate;
    }
    return time;
}