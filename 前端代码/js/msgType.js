/*
 * 对应MsgType.java
 * */
MsgType = {
	/*
	 * 361个激光点
	 */
	setLaserData : "0",
	/**
	 * 上传当前巡检任务已经经过的路径ID列表
	 */
	set_patrol_finish_edge : "1",

	/**
	 * 上传机器人当前位置（包括云台位置）
	 */
	set_robot_pos : "2",

	/**
	 * 上传某机器人当前正在执行的任务状态
	 */
	set_current_task_status : "3",

	/**
	 * 上传当前设备巡检信息
	 */
	set_device_info : "4",

	/**
	 * 获取当前设备巡检异常信息
	 */
	set_device_alarm_info : "5",

	/**
	 * 上传当前机器人异常报文
	 */
	set_robot_alarm_info : "6",

	/**
	 * 上传机器人长时间暂停信号
	 */
	set_robot_long_time_pause : "7",

	/**
	 * 上传机器人长时间空闲信号
	 */
	set_robot_long_time_idel : "8",

	/**
	 * 上传机器人当前控制模式
	 */
	set_robot_control_mode : "9",
	/**
	 * 超声
	 */
	drawSoundPoint : "10"
}