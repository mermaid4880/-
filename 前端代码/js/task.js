$(function(){
            
            $("#taskgrid-pic").ligerGrid({
                columns: [
                { display: '任务名称', name: 'taskName', align: 'center', width: "30%"},
                { display: '编辑时间', name: 'editTime', Width: "30%" },
                { display: '操作', name: 'selectOperation', Width: "30%" },
                ], dataAction: 'server', data: CustomersData, sortName: 'CustomerID',
                width: '80%', height: '250px', pageSize: 10,rownumbers:true,rowtitle:true,
                checkbox : true,
                //应用灰色表头
                cssClass: 'l-grid-gray', 
                heightDiff: -6
            });
            
            gridManagerPic = $("#taskgrid-pic").ligerGetGridManager();
            $("#pageloading").hide();
            var isextend=true;
            $(".shrinkage").click(function(){
                $(".extend-btn").show();
                $(".tree-col").hide();
                $(".tree .title").hide();
                $("#tree-ul").hide();
                $(".tree").hide();
                $(".task-compile").width($("body").width()-60);
            })
            $(".extend-btn").click(function(){
                $(".extend-btn").hide();
                $(".tree-col").show();
                $(".tree .title").show();
                $("#tree-ul").show();
                $(".tree").show();
                $(".task-compile").width($("body").width()-$(".tree").width()-61);
            })
})