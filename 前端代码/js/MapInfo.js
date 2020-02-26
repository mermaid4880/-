/**
 * liangqin
 * min_x	int	地图最小点x坐标，单位：mm
 * min_y	int	地图最小点y坐标，单位：mm
 * max_x	int	地图最大点x坐标，单位：mm
 * max_y	int	地图最大点y坐标，单位：mm
 * resolution	int	分辨率
 */

MapInfo = {
		
		min_x : 0,
		
		min_y : 0,
		
		max_x : 0,
		
		max_y : 0,
		
		resolution : 0,
		
		map_width : 0,
		
		map_height : 0
		
}


/**
 * 实际距离坐标与彩图上像素坐标的转换
 * 输入参数x,y表示实际距离坐标
 * t_x, t_y表示实际的距离差值
 * px_x,px_y表示像素值的坐标点位
 */
function transPostionOnColor(x, y)
{
	var t_x = Math.abs(x - MapInfo.min_x);
	var t_y = Math.abs(y - MapInfo.min_y);
	
	t_y = Math.abs(t_y - MapInfo.map_height);
	
	var image_width = $("#draw-line").attr("width");
	var image_height = $("#draw-line").attr("height");
	
	var px_x = t_x * (image_width / MapInfo.map_width);
	var px_y = t_y * (image_height / MapInfo.map_height);
	var px_pos = {"px_x" : px_x, "px_y" : px_y};
	return px_pos;
}

/**
 * 实际距离坐标与初始定位上像素坐标的转换
 * 输入参数x,y表示实际距离坐标
 * t_x, t_y表示实际的距离差值
 * px_x,px_y表示像素值的坐标点位
 */
function transPostionOnMap(x, y)
{
	var t_x = Math.abs(x - MapInfo.min_x);
	var t_y = Math.abs(y - MapInfo.min_y);
	
	var image_width = $("#laser-dot").attr("width");
	var image_height = $("#laser-dot").attr("height");
	
	var px_x = t_x * (image_width / MapInfo.map_width);
	var px_y = t_y * (image_height / MapInfo.map_height);
	var px_pos = {"px_x" : px_x, "px_y" : px_y};
	return px_pos;
}
