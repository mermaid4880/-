/*require(
    [
        'echarts',
        'echarts/chart/line',
    ],
    function(ec) { //ec是包含echarts的对象，但不是echarts实例， comment by danielinbiti

        var map = ec.init(document.getElementById('echartsMap'));

          option = {
            tooltip : {
                trigger: 'axis'
            },
            legend: {
                data:['rData'],
                orient:'vertical',
                x: 'right',
                y: 'center',
            },
            toolbox: {
                show : true,
                feature : {
                    mark : {show: false},
                    dataView : {show: false, readOnly: false},
                    magicType : {show: false, type: ['line']},
                    restore : {show: false},
                    saveAsImage : {show: false}
                }
            },
            calculable : true,
            xAxis : [
                {
                    type : 'category',
                    boundaryGap : false,
                    data : ['2016-10-8','2016-10-9','2016-10-10','2016-10-11','2016-10-12','2016-10-13','2016-10-14']
                }
            ],
            yAxis : [
                {
                    type : 'value'
                }
            ],
            series : [

                {
                    name:'rData',
                    type:'line',
                    itemStyle: {
                        normal: {
                            label: {
                                show: true
                            },
                            borderColor: 'rgba(100,149,237,1)',
                            borderWidth: 0.5,
                            color:'green',
                            // areaStyle: {
                            //     color: '#fff'
                            // }
                        }
                    },
                    stack: '',
                    data:[30, 40, 30, 20, 38, 45, 50]
                }
            ]
        };
                    
        map.setOption(option); //option似乎参数，可以参见官网的各个实例设置方式
    })*/