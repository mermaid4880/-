//发现ie和chrome不兼容
function public_getTreeObject() {

    var vTreeObject = null;
    if (navigator.userAgent.indexOf('Chrome') != -1) {
        vTreeObject = ftree.contentWindow.zTreeObj;
    }
    else {
        vTreeObject = ftree.window.zTreeObj; //ie
    }
    return vTreeObject;
}
