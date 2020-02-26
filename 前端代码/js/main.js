// JavaScript Document
$(function(e) {
	$(".login-registration-content:first").css("display","block");
    $(".login-registration-title >a").click(function(){		
		    $(this).addClass("current").siblings().removeClass("current");
			$(".login-registration-content:eq("+$(this).index(".login-registration-title >a")+")").show().siblings().hide();	
			return false;		
		});
});

$(document).ready(function(){
    $(".checkbox").toggle(function(){
         $(".checkbox i").hide();
       },function(){
         $(".checkbox i").show();
       });
});
  
  