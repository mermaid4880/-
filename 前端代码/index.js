var menuArray=
[{
    "menuid": "1",
    "imgSrc": "images/common/sbgj.png",
    "menuText": "机器人管理",
    "url": "pages/机器人管理.aspx",
    "subMenuClass": "",
    "subMenu": []
},
{
    "menuid": "3",
    "imgSrc": "images/common/ssjk.png",
    "menuText": "实时监控",
    "url": "",
    "subMenuClass": "realtime-monitor",
    "subMenu": [
        {
        "title": "巡检监控",
        "childen": [{
            "title": "巡检监控",
            "id": "1900",
            "url": "pages/巡检监控.aspx"
        }]

    },
         {
             "title": "机器人遥控",
            "childen": [{
                "title": "机器人遥控",
            "id": "2000",
            "url": "pages/机器人遥控.aspx"}
            ]
        }]
}, {
    "menuid": "4",
    "imgSrc": "images/common/xtgjcx.png",
    "menuText": "巡检结果确认",
    "url": "",
    "subMenuClass": "inspection-results-confirm",
    "subMenu": [{
        "title": "设备告警信息确认",
        "childen": [{
            "title": "设备告警查询确认",
            "id": "2100",
            "url": "pages/设备告警查询确认.aspx"
        }, {
            "title": "主接线展示",
            "id": "2200",
            "url": "pages/主接线展示.aspx"
        }, {
            "title": "间隔展示",
            "id": "2300",
            "url": "pages/间隔展示.aspx"
        }]

    }, 
    {
        "title": "巡检结果浏览",
        "childen": [{
            "title": "巡检结果浏览",
            "id": "2400",
            "url": "pages/巡检结果浏览.aspx"
        }]

    }
    ,
    {
        "title": "巡检报告生成",
        "childen": [{
            "title": "巡检报告生成",
            "id": "2500",
            "url": "pages/巡检报告生成.aspx"
        }]

    }
    ]
}
, {
    "menuid": "5",
    "imgSrc": "images/common/xjjgfx.png",
    "menuText": "巡检结果分析",
    "url": "",
    "subMenuClass": "inspection-results-analyze",
    "subMenu": [{
        "title": "对比分析",
        "childen": [{
            "title": "对比分析页面",
            "id": "2600",
            "url": "pages/对比分析页面.aspx"
        }, {
            "title": "三相对比分析",
            "id": "2700",
            "url": "pages/三相对比分析.aspx"
        }]

    },
    {
        "title": "生成报表",
        "childen": [{
            "title": "生成报表",
            "id": "2800",
            "url": "pages/生成报表.aspx"
        }]

    }]
}
,{
    "menuid": "6",
    "imgSrc": "images/common/yhsz.png",
    "menuText": "用户设置",
    "url": "",
    "subMenuClass": "user-settings",
    "subMenu": [{
        "title": "告警设置",
        "childen": [{
            "title": "告警阈值设置",
            "id": "2900",
            "url": "pages/告警阈值设置.aspx"
        }, {
            "title": "告警信息订阅",
            "id": "3000",
            "url": "pages/告警信息订阅.aspx"
        }]

    },
    {
        "title": "组织权限设置",
        "childen": [{
            "title": "组织权限设置",
            "id": "3050",
            "url": "pages/权限管理.aspx"
        }]

    },
    {
        "title": "点位设置",
        "childen": [{
            "title": "典型巡检点位库",
            "id": "3100",
            "url": "pages/典型巡检点位库.aspx"
        },
        {
            "title": "巡检点位设置",
            "id": "3120",
            "url": "pages/巡检点位设置.aspx"
        }]

    },
    {
        "title": "检修区域设置",
        "childen": [{
            "title": "检修区域设置",
            "id": "3150",
            "url": "pages/检修区域设置.aspx"
        }]

    }]
}
, {
    "menuid": "7",
    "imgSrc": "images/common/cjsz.png",
    "menuText": "机器人系统调试维护",
    "url": "",
    "subMenuClass": "debugging-maintenance",
    "subMenu": [{
        "title": "巡检地图设置",
        "childen": [{
            "title": "巡检地图设置",
            "id": "3200",
            "url": "pages/巡检地图设置.aspx"
        }]

    },
    {
        "title": "软件设置",
        "childen": [{
            "title": "软件设置",
            "id": "3300",
            "url": "pages/软件设置.aspx"
        }]

    },
    {
        "title": "机器人设置",
        "childen": [{
            "title": "机器人设置",
            "id": "3400",
            "url": "pages/机器人设置.aspx"
        },
        {
            "title": "状态显示",
            "id": "3450",
            "url": "pages/状态显示.aspx"
        }]

    },
    {
        "title": "机器人告警查询",
        "childen": [{
            "title": "机器人告警查询",
            "id": "3500",
            "url": "pages/机器人告警查询.aspx"
        },
        {
            "title": "识别异常点位查询",
            "id": "3600",
            "url": "pages/识别异常点位查询.aspx"
        }]

    }]
}

]