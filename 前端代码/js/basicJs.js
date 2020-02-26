/*

*/

function showLoading() {
    layui.use('layer', function () {
        var layer = layui.layer;

        layer.load(2); //风格1的加载
    });   

   
}

function closeLoading() {

    layui.use('layer', function () {
        var layer = layui.layer;

        layer.closeAll('loading'); //关闭加载层
    });   

    
}

//关闭初始化表格动画
function openPageLoadingDh() {
    layui.use(['layer'], function () {
        var layer = layui.layer;
        layer.open({
            title:"",
            type: 2,
            closeBtn:0,
            anim: 0,
            resize:false,
            content: "../PublicForm/waitForm.htm"
                    
        });
    });
}
function closePageLoadingDh() {
    //$("#tabInitDh").css("display", "none");
     layui.use(['layer'], function () {
        var layer = layui.layer;
        layer.closeAll(); //关闭加载层
    });
    
}
//关闭初始化表格动画
//从页面中获取input 转换成 json格式
function getJsonListSearch(form) {
    if (!form) return null;
    var group = [];
    $(":input", form).not(":submit, :reset, :image,:button, [disabled]")
        .each(function () {
            if (!this.name) return;
            if ($(this).val() == null || $(this).val() == "") return;
            var op = $(this).attr("op") || "equal";
            var value = $(this).val();
            var name = this.name;
            group.push({
                name: name,
                value: value,
                op: op
            });
        });
    return group;
}

//关闭初始化表格动画
//从页面中获取input 转换成 json格式
function getJsonListOpenDiv(form) {
    if (!form) return null;
    var group = [];
    $(":input", form).not(":submit, :reset, :image,:button, [disabled]")
        .each(function () {
            if (!this.name) return;
            if ($(this).val() == null || $(this).val() == "") return;
            var op = $(this).attr("op") || "putong";
            var value = $(this).val();
            var name = this.name;
            group.push({
                name: name,
                value: value,
                op: op
            });
        });
    return group;
}
