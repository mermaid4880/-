$(function(){
	
	$(".submit-btn").click(login);
	$(document).keydown(function(e){
		if(e.which==13){
			login();
		}
	});
});

/**
 * 李健威
 * [如果是集控端登录，则自动登录]
 * @return {[type]} [description]
 */
autologin();
function autologin() {
    //window.location.search 从问号 (?) 开始的 URL（查询部分）
	if(window.location.search.indexOf("autoLogin")!=-1){
	    $.ajax({
	        type: "post",
	        url: "handler/Validate.ashx?time=" + new Date().getTime(),
            data: { "Action": "Login", "username": "admin", "password": "admin" },
            //同步请求
	        async: false,
	        success: function (data) {

	            alert(data);
	            if (data == "10") {
	                window.location.href = "index.aspx?d=" + Math.random();
	            }
	            else {
	                alert("账号或密码错误！");
	            }

	        },
	        error: function (e) {
	            alert("单站登录失败！");

	        }
	    });
	}
}

/**
 * 登录任务
 * @returns {Boolean}
 */
function login(){
	
	//检查用户名是否为空
	if($("#userNameId").val()==""){
		//jquery tips 提示插件 jquery.tips.js v0.1beta；

        //$(“#loginname”).tips({   //#loginname为jquery的id选择器
        //    msg: ‘your messages!‘,    //你的提示消息  必填
        //    side: 1,  //提示窗显示位置  1，2，3，4 分别代表 上右下左 默认为1（上） 可选
        //    color: ‘#FFF‘, //提示文字色 默认为白色 可选
        //    bg: ‘#F00‘,//提示窗背景色 默认为红色 可选
        //    time: 2,//自动关闭时间 默认2秒 设置0则不自动关闭 可选
        //    x: 0,//横向偏移  正数向右偏移 负数向左偏移 默认为0 可选
        //    y: 0,//纵向偏移  正数向下偏移 负数向上偏移 默认为0 可选
        //})
		 $("#userNameId").tips({
			side:1,
           msg:'用户名不得为空',
           bg:'#AE81FF',
           time:3
       }); 
		//聚焦到$("#userNameId")这个元素
		$("#userNameId").focus();
		return false;
    } else {
        //jQuery.trim($("#userNameId").val())去除字符串两边的空格 
		$("#userNameId").val(jQuery.trim($("#userNameId").val()));
	}
	
	
	//检查密码是否为空
	if($("#passwordId").val()==""){
		
		$("#passwordId").tips({
			side:1,
            msg:'密码不得为空',
            bg:'#AE81FF',
            time:3
        });
		
		$("#passwordId").focus();
		return false;
	}
	
	
	
	$(".sign-in").tips({
		side:1,
        msg:'正在登录 , 请稍后 ...',
        bg:'#68B500',
        time:3
    });
	
	var username = $("#userNameId").val();
	var password = $("#passwordId").val();

	$.ajax({
	    type: "post",
	    url: "handler/Validate.ashx?time=" + new Date().getTime(),
	    data: { "Action": "Login", "username": username, "password": password, "OutHours": 10 },
	    success: function (data) {

            if (data == "10") {
                //跳转页面
	            window.location.href = "index.aspx?d=" + Math.random();

	        } else {

	            $(".sign-in").tips({
	                side: 1,
	                msg: "账号或密码错误！",
	                bg: '#68B500',
	                time: 3
	            });

	        }
	    },
	    error: function (e) {

	        $(".sign-in").tips({
	            side: 1,
	            msg: "登录失败！",
	            bg: '#68B500',
	            time: 3
	        });

	    }


	});	
	
}

