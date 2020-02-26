	var spanLen=$(".have-bg span").length;
	var haveBgLen=$(".have-bg").length;
	var indexSpan=0;
	var indexHaveBg=0;
	var selectUrl="";
	//头部导航栏的展开收回
	var isExtend=false;

	var navtab = null;

	//iframe宽度计算
	function changeIframeHeight(){
		var bodyHeight=$("body").height();
		$(".iframe").css({"height":bodyHeight-92,"overflow-y":"auto","overflow-x":"hidden"});
	}
	changeIframeHeight();
	window.onresize=changeIframeHeight;

	$(function () {

	    navtab = $("#navtab").ligerGetTabManager();

	    $(".nav-box").click(function () {
	       
	        if (isExtend) {
	            $(this).attr("src", "images/common/navup.png");
	            isExtend = false;
	        } else {
	            $(this).attr("src", "images/common/navdown.png");
	            isExtend = true;
	        }
	        navFadeToggle();
	    })
	    $(".cover").click(function () {
	        navFadeToggle();
	    })

	    //这里装置一下
	    //f_MyAddTab(100, "pages/机器人管理.aspx", "机器人管理");

	})


	/*
	*控制头部导航部分面包屑(网站地图)的变化2016.9.8
	*/
	var firstTextIndex=0;
	$(".have-bg").mousemove(function(){
		firstTextIndex=$(".have-bg").index(this);	
	})
	$(".have-bg").eq(0).click(function(){
		$(".header .crumbs .first").text($(".have-bg").eq(0).text());	
		$(".header .crumbs .second").text($(".have-bg").eq(0).text());
		navFadeToggle();
	})
    $(".have-bg span").click(function () {
        var spanIndex = $(".have-bg span").index(this);
        $(".header .crumbs .first").text($(".have-bg .text").eq(firstTextIndex).text());
        $(".header .crumbs .second").text($(".have-bg span").eq(spanIndex).text());
        navFadeToggle();
    });

    
	

    var iframeHeight=$(".iframe").height();
    var loadHtml="<span style='width:100%;font-size:25px;line-height:"+iframeHeight+"px;text-align:center;display:inline-block;'><img src='images/common/bigloading.gif'></span>";
	
     //开启一个新的页面
    function f_MyAddTab(tabid, url, text) {
            
        if(navtab.isTabItemExist(tabid)){
            navtab.selectTabItem(tabid);
        }else{
            navtab.addTabItem({ tabid: tabid, text: text, url: url });
        }
        //这里关闭
        navFadeToggle();
       
    }

    function f_click(type,url,tabid)
        {
            switch (type)
            {
                case "moveToPrevTabItem":
                    navtab.moveToPrevTabItem();
                    break;
                case "moveToNextTabItem": 
                    navtab.moveToNextTabItem();
                    break;
                case "moveToLastTabItem":
                    navtab.moveToLastTabItem();
                    break;
                case "getTabItemCount":
                    alert(navtab.getTabItemCount());
                    break;
                case "getSelectedTabItemID":
                    alert(navtab.getSelectedTabItemID());
                    break;
                case "removeSelectedTabItem":
                    navtab.removeSelectedTabItem();
                    break;
                case "removeSelectedTabItem":
                    navtab.removeSelectedTabItem();
                    break;
                case "removeSelectedTabItem":
                    navtab.removeSelectedTabItem();
                    break;
                case "overrideSelectedTabItem":
                    $.ligerDialog.prompt('请输入网址', 'http://www.baidu.com', function (yes, value)
                    {
                        if (yes) navtab.overrideSelectedTabItem({ url: value });
                    });
                    break;
                case "selectTabItem":
                    $.ligerDialog.prompt('请输入tabid', '', function (yes, value)
                    {
                        if (yes) navtab.selectTabItem(value);
                    });
                    break;
                case "isTabItemExist":
                    $.ligerDialog.prompt('请输入tabid', '', function (yes, value)
                    { 
                        if (yes) alert(navtab.isTabItemExist(value));
                    });
                    break;
                case "addTabItem":
                    {
                    	 if(navtab.isTabItemExist(tabid)){
                    	 	navtab.selectTabItem(tabid);
                    	 }else{
                            navtab.addTabItem({ tabid:tabid }); 
                    	 }
                         $.ajax({
                         	url:url,
                         	async:true,
                         	cache:false,
                         	success:function(data){
                         		$(".header .crumbs .second").text(tabid);
                         		$(".iframe").html(loadHtml);
                         		var robotTime;	
                         		robotTime=setInterval(function(){
                         			clearInterval(robotTime);
                         			$(".iframe").html(data);

                         		},1000);
                         		
                         	}
                         })
                    };
                    break;
                case "removeTabItem":
                    $.ligerDialog.prompt('请输入tabid', '', function (yes, value)
                    {
                        if (yes) navtab.removeTabItem(value);
                    });
                    break;
                case "removeOther":
                    $.ligerDialog.prompt('请输入tabid', '', function (yes, value)
                    {
                        if (yes) navtab.removeOther(value);
                    });
                    break;
                case "reload":
                    navtab.reload(navtab.getSelectedTabItemID());
                    break;
                case "removeAll":
                    navtab.removeAll();
                    break;
                case "hideTabItem":
                    navtab.hideTabItem("item2");
                    break;
                case "showTabItem":
                    navtab.showTabItem("item2");
                    break;
                    
            }
        }
       

$("#navtab").ligerTab({
            changeHeightOnResize:true,
			showSwitch: true,
            ShowSwitchInTab: true,
            contextmenu: false,
			onBeforeSelectTabItem: function (tabid)
	        {
				$(".l-tab-windowsswitch").remove(); //移除tab列表switch
            }, 
            onAfterRemoveTabItem: function (tabid) {
               
                for (var i = 0; i < tabItems.length; i++) {
                    var o = tabItems[i];
                    if (o.tabid == tabid) {
                        tabItems.splice(i, 1);
                        saveTabStatus();
                        break;
                    }
                }
            },
            //onReload: function (tabdata) {
            //    alert(333);
            //    var tabid = tabdata.tabid;
            //    addFrameSkinLink(tabid);
            //}
		});		
		var navtab = $("#navtab").ligerGetTabManager();
		$(".l-tab-links").click(function(e){
			if(e.pageX>12 && e.pageX<1908){
					var tabLen=$(".l-tab-links-item-close").length;
					var tabIdText=$(".l-tab-links li").eq(tabLen).find("a").eq(0).text();
					var selectTabId=navtab.getSelectedTabItemID();
					if(tabIdText==selectTabId){
				        forSelect(tabIdText);
					}else{
						forSelect(selectTabId);
					}
			        if(selectTabId=="机器人管理"){
				       $(".first").text($(".have-bg").eq(0).text());
					   $(".second").text(selectTabId);
				       selectUrl=$(".have-bg").eq(0).find("a").eq(0).attr("data-url");
                    } 
	                $.ajax({
	                  	url:selectUrl,
	                   	async:true,
	                   	cache:false,
	                  	success:function(data){
	                 		$(".iframe").html(loadHtml);
	                 		var robotTimeTab;	
	                 		robotTimeTab=setInterval(function(){
	                     	
	                 			clearInterval(robotTimeTab);
	                 			$(".iframe").html(data);
	                 			
	                 		},1000);
	                  	}
	                })
			}
		})
		
		//itemSwidth显示与隐藏
		$(".l-tab-itemswitch").click(function(){
			var aLen=$(".l-tab-windowsswitch a").length;
			var mT=-56-24*(aLen-1);
			$(".l-tab-windowsswitch").css({"marginTop":mT+"px","marginLeft":"15px"});
		})

		//查找tabid在have-bg类下的索引，修改网站地图
		function forSelect(text){
	        for(var j=1;j<haveBgLen;j++){
	        	 for(var i=0;i<spanLen;i++){
	        		var spanVal=$(".have-bg").eq(j).find("span").eq(i).text();
	        		
	        		//如果tabid与菜单栏中have-bg类下的span对上,则获取到have-bg的索引
	        		if(text==spanVal){
	        			indexSpan=i;
	        			indexHaveBg=j;
				        $(".first").text($(".have-bg").eq(indexHaveBg).find(".text").text());
				        $(".second").text(text);
				        
				        selectUrl=$(".have-bg").eq(indexHaveBg).find("a").eq(indexSpan).attr("data-url");//获取选择的tabid的url值
				        break; //退出第二层for
	        		}
	        	}
	       }
		}
		function navFadeToggle(){		
			$(".OCXBody").stop(true,false).fadeToggle();
			$(".cover").stop(true,false).fadeToggle();
			$(".nav-list").stop(true,false).slideToggle();
		}

 
