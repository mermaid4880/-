//全局变量定义
var m_iNowChanNo = -1;                           // 当前通道号
var m_iLoginUserId = -1;                         // 注册设备用户ID
var m_iChannelNum = -1;							 // 模拟通道总数
var m_bDVRControl = null;						 // OCX控件对象
var m_iProtocolType = 0;                         // 协议类型，0 – TCP， 1 - UDP
var m_iStreamType = 0;                           // 码流类型，0 表示主码流， 1 表示子码流
var m_iPlay = 0;                                 // 当前是否正在预览
var m_iRecord = 0;                               // 当前是否正在录像
var m_iTalk = 0;                                 // 当前是否正在对讲
var m_iVoice = 0;                                // 当前是否打开声音
var m_iAutoPTZ = 0;                              // 当前云台是否正在自转
var m_iPTZSpeed = 4;                             // 云台速度
var cameraIp;
var videoIp;
var cameraAdmin="admin";
var cameraPassword="admin12345";
var videoAdmin="admin";
var videoPassword="admin12345";

function ButtonPress(sKey)
{
	try
	{
		switch (sKey)
		{			
			case "LogoutDev":
			{
				if(m_bDVRControl.Logout())
				{
					LogMessage("注销成功！");
				}
				else
				{
					LogMessage("注销失败！");
				}
				break;
			}
			// 高清*3
			case "LoginDev":
			{
				var szDevIp = cameraIp; 
				var szDevPort = "8000"; 
 				var szDevUser = cameraAdmin; 
				var szDevPwd = cameraPassword; 
				
/*				var szDevUser = "admin"; 
				var szDevPwd = "admin12345";*/ 
				var getCurrentIp=window.location.hostname;
				if(getCurrentIp!="127.0.0.1" && getCurrentIp!="192.168.1.57" && getCurrentIp!="localhost"){
  					var szDevIp = getCurrentIp;
  					var szDevPort = "8113"; //如果是SDK访问则用8113端口，如果是网页访问则用9113端口
				}
				m_iLoginUserId = m_bDVRControl.Login(szDevIp,szDevPort,szDevUser,szDevPwd);
				
				if(m_iLoginUserId == -1)
				{
					
				}
				else
				{
					document.getElementById("HIKOBJECT1").SetUserID(m_iLoginUserId);
				}
				break;
			}
			// 红外*5
			case "LoginDev:red":
			{
				var szDevIp = videoIp; 
				var szDevPort = "8000"; 				
				var szDevUser = videoAdmin; 
				var szDevPwd = videoPassword; 
				
				var getCurrentIp=window.location.hostname;
				if(getCurrentIp!="127.0.0.1" && getCurrentIp!="192.168.1.57" && getCurrentIp!="localhost"){
  					var szDevIp = getCurrentIp;
  					var szDevPort = "8115";//如果是SDK访问则用8115端口，如果是网页访问则用9115端口
				}
				m_iLoginUserId = m_bDVRControl.Login(szDevIp,szDevPort,szDevUser,szDevPwd);
				if(m_iLoginUserId == -1)
				{
				}
				else
				{
					document.getElementById("HIKOBJECT2").SetUserID(m_iLoginUserId);
				}
				break;
			}
			case "getDevName":
			{
				var szDecName = m_bDVRControl.GetServerName();
				break;
			}
			case "getDevChan":
			{
				szServerInfo = m_bDVRControl.GetServerInfo();
				var xmlDoc = new ActiveXObject("Microsoft.XMLDOM");
				xmlDoc.async="false"
				xmlDoc.loadXML(szServerInfo)
				m_iChannelNum = parseInt(xmlDoc.documentElement.childNodes[0].childNodes[0].nodeValue);

				break;
			}
			case "Preview:start":
			{
				m_iNowChanNo = 0;  // 通道值如果是1，PTZ不可用
				if(m_iNowChanNo > -1)
				{
					if(m_iPlay == 1)
					{
						m_bDVRControl.StopRealPlay();
					}
					
					var bRet = m_bDVRControl.StartRealPlay(m_iNowChanNo,m_iProtocolType,m_iStreamType);
					if(bRet)
					{
						m_iPlay = 1;
					}
					else
					{
					}
				}
				break;
			}
			case "Preview:startRed":
			{
				m_iNowChanNo = 0;  // 通道值如果是1，PTZ不可用
				if(m_iNowChanNo > -1)
				{
					if(m_iPlay == 1)
					{
						m_bDVRControl.StopRealPlay();
					}
					
					var bRet = m_bDVRControl.StartRealPlay(m_iNowChanNo,m_iProtocolType,m_iStreamType);
					if(bRet)
					{
						m_iPlay = 1;
					}
					else
					{
					}
				}
				break;
			}
			case "Preview:stop":
			{
				
				if(m_bDVRControl.StopRealPlay())
				{
					LogMessage("停止预览成功！");
					m_iPlay = 0;
				}
				else
				{
					LogMessage("停止预览失败！");
				}
				break;
			}
			case "CatPic:bmp":
			{
				if(m_iPlay == 1)
				{
					if(m_bDVRControl.BMPCapturePicture("D:/CapImages_Test/",1))
					{
						alert("文件已保存至D:/CapImages_Test/");
						LogMessage("抓BMP图成功！");
					}
					else
					{
						LogMessage("抓BMP图失败！");
					}
				}
				else
				{
					LogMessage("请先预览！");
				}
				break;
			}
			case "CatPic:jpeg":
			{
				if(m_iPlay == 1)
				{	// m_iNowChanNo
					if(m_bDVRControl.JPEGCapturePicture(1,2,0,"D:/CapImages_Test/",1))
					{
						alert("文件已保存至D:/CapImages_Test/");
						LogMessage("抓JPEG图成功！");
					}
					else
					{
						LogMessage("抓JPEG图失败！");
					}
				}
				else
				{alert('请先预览');
					LogMessage("请先预览！");
				}
				break;
			}
			case "Record:start":
			{
				if(m_iPlay == 1)
				{
					if(m_iRecord == 0)
					{
						if(m_bDVRControl.StartRecord("D:/CapImages_Test/"))
						{
							m_iRecord = 1;
						}
						else
						{
							LogMessage("开始录像失败！");
						}
					}
				}
				else
				{
					LogMessage("请先预览！");
				}
				break;
			}
			case "Record:stop":
			{
				if(m_iRecord == 1)
				{
					if(m_bDVRControl.StopRecord(1))
					{
						alert("文件已保存至D:/CapImages_Test/");
						LogMessage("停止录像成功！");
						m_iRecord = 0;
					}
					else
					{
						LogMessage("停止录像失败！");
					}
				}
				break;
			}
			case "talk:start":
			{
				ChangeStatus(2);
				if(m_iLoginUserId > -1)
				{
					if(m_iTalk == 0)
					{
						if(m_bDVRControl.StartTalk(1))
						{
							LogMessage("开始对讲成功！");
							m_iTalk = 1;
						}
						else
						{
							var dRet = m_bDVRControl.GetLastError();
							LogMessage("开始对讲失败！错误号：" + dRet);
						}
					}
				}
				else
				{
					LogMessage("请注册设备！");
				}
				break;
			}
			case "talk:stop":
			{
				ChangeStatus(2);
				if(m_iTalk == 1)
				{
					if(m_bDVRControl.StopTalk())
					{
						LogMessage("停止对讲成功！");
						m_iTalk = 0;
					}
					else
					{
						LogMessage("停止对讲失败！");
					}
				}
				break;
			}
			case "voice:start":
			{
				ChangeStatus(2);
				if(m_iPlay == 1)
				{
					if(m_iVoice == 0)
					{
						if(m_bDVRControl.OpenSound(1))
						{
							LogMessage("打开声音成功！");
							m_iVoice = 1;
						}
						else
						{
							LogMessage("打开声音失败！");
						}
					}
				}
				else
				{
					LogMessage("请先预览！");
				}
				break;
			}
			case "voice:stop":
			{
				ChangeStatus(2);
				if(m_iVoice == 1)
				{
					if(m_bDVRControl.CloseSound(1))
					{
						LogMessage("关闭声音成功！");
						m_iVoice = 0;
					}
					else
					{
						LogMessage("关闭声音失败！");
					}
				}
				break;
			}
			case "PTZ:stop":
			{
				if(m_iPlay == 1)
				{
					if(m_bDVRControl.PTZCtrlStop(10,m_iPTZSpeed))
					{
						LogMessage("停止PTZ成功！");
						m_iAutoPTZ = 0;
					}
					else
					{
						LogMessage("停止PTZ失败！");
					}
				}
				break;
			}
			case "PTZ:wiperStart":
			{
				ChangeStatus(1);
				if(m_iPlay == 1)
				{
					if(m_iAutoPTZ == 1)
					{
						m_bDVRControl.PTZCtrlStop(10,m_iPTZSpeed);
						m_iAutoPTZ = 0;
					}
					if(m_bDVRControl.PTZCtrlStart(12,m_iPTZSpeed))
					{
						console.log("雨刷开启成功");
						LogMessage("雨刷开启成功！");
					}
					else
					{
						LogMessage("雨刷开启失败！");
					}
				}
				else
				{
					LogMessage("请先预览！");
				}
				break;
			}
			case "PTZ:wiperStop":
			{
				ChangeStatus(1);
				if(m_iPlay == 1)
				{
					if(m_bDVRControl.PTZCtrlStop(12,m_iPTZSpeed))
					{
						LogMessage("雨刷关闭成功！");
						m_iAutoPTZ = 0;
					}
					else
					{
						LogMessage("雨刷关闭失败！");
					}
				}
				break;
			}
			case "PTZ:lightStart":
			{
				ChangeStatus(1);
				if(m_iPlay == 1)
				{
					if(m_iAutoPTZ == 1)
					{
						m_bDVRControl.PTZCtrlStop(10,m_iPTZSpeed);
						m_iAutoPTZ = 0;
					}
					if(m_bDVRControl.PTZCtrlStart(11,m_iPTZSpeed))
					{
						LogMessage("补光灯开启成功！");
					}
					else
					{
						LogMessage("补光灯开启失败！");
					}
				}
				else
				{
					LogMessage("请先预览！");
				}
				break;
			}
			case "PTZ:lightStop":
			{
				ChangeStatus(1);
				if(m_iPlay == 1)
				{
					if(m_bDVRControl.PTZCtrlStop(11,m_iPTZSpeed))
					{
						LogMessage("补光灯关闭成功！");
						m_iAutoPTZ = 0;
					}
					else
					{
						LogMessage("补光灯关闭失败！");
					}
				}
				break;
			}
			case "PTZ:leftup":
			{
				if(m_iPlay == 1)
				{
					if(m_iAutoPTZ == 1)
					{
						m_bDVRControl.PTZCtrlStop(10,m_iPTZSpeed);
						m_iAutoPTZ = 0;
					}
					if(m_bDVRControl.PTZCtrlStart(13,m_iPTZSpeed))
					{
						LogMessage("PTZ左上成功！");
					}
					else
					{
						LogMessage("PTZ左上失败！");
					}
				}
				else
				{
					LogMessage("请先预览！");
				}
				break;
			}	
			case "PTZ:rightup":
			{
				if(m_iPlay == 1)
				{
					if(m_iAutoPTZ == 1)
					{
						m_bDVRControl.PTZCtrlStop(10,m_iPTZSpeed);
						m_iAutoPTZ = 0;
					}
					if(m_bDVRControl.PTZCtrlStart(14,m_iPTZSpeed))
					{
						LogMessage("PTZ右上成功！");
					}
					else
					{
						LogMessage("PTZ右上失败！");
					}
				}
				else
				{
					LogMessage("请先预览！");
				}
				break;
			}	
			case "PTZ:up":
			{
				ChangeStatus(1);
				if(m_iPlay == 1)
				{
					if(m_iAutoPTZ == 1)
					{
						m_bDVRControl.PTZCtrlStop(10,m_iPTZSpeed);
						m_iAutoPTZ = 0;
					}
					if(m_bDVRControl.PTZCtrlStart(0,m_iPTZSpeed))
					{
						LogMessage("PTZ向上成功！");
					}
					else
					{
						LogMessage("PTZ向上失败！");
					}
				}
				else
				{
					LogMessage("请先预览！");
				}
				break;
			}	
			case "PTZ:left":
			{
				ChangeStatus(1);
				if(m_iPlay == 1)
				{
					if(m_iAutoPTZ == 1)
					{
						m_bDVRControl.PTZCtrlStop(10,m_iPTZSpeed);
						m_iAutoPTZ = 0;
					}
					if(m_bDVRControl.PTZCtrlStart(2,m_iPTZSpeed))
					{
						LogMessage("PTZ向左成功！");
					}
					else
					{
						LogMessage("PTZ向左失败！");
					}
				}
				else
				{
					LogMessage("请先预览！");
				}
				break;
			}	
			case "PTZ:right":
			{
				ChangeStatus(1);
				if(m_iPlay == 1)
				{
					if(m_iAutoPTZ == 1)
					{
						m_bDVRControl.PTZCtrlStop(10,m_iPTZSpeed);
						m_iAutoPTZ = 0;
					}
					if(m_bDVRControl.PTZCtrlStart(3,m_iPTZSpeed))
					{
						LogMessage("PTZ向右成功！");
					}
					else
					{
						LogMessage("PTZ向右失败！");
					}
				}
				else
				{
					LogMessage("请先预览！");
				}
				break;
			}	
			case "PTZ:rightdown":
			{
				if(m_iPlay == 1)
				{
					if(m_iAutoPTZ == 1)
					{
						m_bDVRControl.PTZCtrlStop(10,m_iPTZSpeed);
						m_iAutoPTZ = 0;
					}
					if(m_bDVRControl.PTZCtrlStart(16,m_iPTZSpeed))
					{
						LogMessage("PTZ右下成功！");
					}
					else
					{
						LogMessage("PTZ右下失败！");
					}
				}
				else
				{
					LogMessage("请先预览！");
				}
				break;
			}	
			case "PTZ:leftdown":
			{
				if(m_iPlay == 1)
				{
					if(m_iAutoPTZ == 1)
					{
						m_bDVRControl.PTZCtrlStop(10,m_iPTZSpeed);
						m_iAutoPTZ = 0;
					}
					if(m_bDVRControl.PTZCtrlStart(15,m_iPTZSpeed))
					{
						LogMessage("PTZ左下成功！");
					}
					else
					{
						LogMessage("PTZ左下失败！");
					}
				}
				else
				{
					LogMessage("请先预览！");
				}
				break;
			}	
			case "PTZ:down":
			{
				ChangeStatus(1);
				if(m_iPlay == 1)
				{
					if(m_iAutoPTZ == 1)
					{
						m_bDVRControl.PTZCtrlStop(10,m_iPTZSpeed);
						m_iAutoPTZ = 0;
					}
					if(m_bDVRControl.PTZCtrlStart(1,m_iPTZSpeed))
					{
						LogMessage("PTZ向下成功！");
					}
					else
					{
						LogMessage("PTZ向下失败！");
					}
				}
				else
				{
					LogMessage("请先预览！");
				}
				break;
			}	
			case "PTZ:auto":
			{
				if(m_iPlay == 1)
				{
					if(m_bDVRControl.PTZCtrlStart(10,m_iPTZSpeed))
					{
						LogMessage("PTZ自转成功！");
						m_iAutoPTZ = 1;
					}
					else
					{
						LogMessage("PTZ自转失败！");
					}
				}
				else
				{
					LogMessage("请先预览！");
				}
				break;
			}		
			case "zoom:in":
			{
				ChangeStatus(1);
				if(m_iPlay == 1)
				{
					if(m_iAutoPTZ == 1)
					{
						m_bDVRControl.PTZCtrlStop(10,m_iPTZSpeed);
						m_iAutoPTZ = 0;
					}
					if(m_bDVRControl.PTZCtrlStart(4,m_iPTZSpeed))
					{
						LogMessage("焦距拉近成功！");
					}
					else
					{
						LogMessage("焦距拉近失败！");
					}
				}
				else
				{
					LogMessage("请先预览！");
				}
				break;
			}	
			case "zoom:out":
			{
				ChangeStatus(1);
				if(m_iPlay == 1)
				{
					if(m_iAutoPTZ == 1)
					{
						m_bDVRControl.PTZCtrlStop(10,m_iPTZSpeed);
						m_iAutoPTZ = 0;
					}
					if(m_bDVRControl.PTZCtrlStart(5,m_iPTZSpeed))
					{
						LogMessage("焦距拉远成功！");
					}
					else
					{
						LogMessage("焦距拉远失败！");
					}
				}
				else
				{
					LogMessage("请先预览！");
				}
				break;
			}
			// 停止拉近焦距
			case "zoom:instop":
			{
				ChangeStatus(1);
				if(m_iPlay == 1)
				{
					if(m_iAutoPTZ == 1)
					{
						m_bDVRControl.PTZCtrlStop(10,m_iPTZSpeed);
						m_iAutoPTZ = 0;
					}
					if(m_bDVRControl.PTZCtrlStop(4,m_iPTZSpeed))
					{
						LogMessage("焦距拉近停止成功！");
					}
					else
					{
						LogMessage("焦距拉近失败！");
					}
				}
				else
				{
					LogMessage("请先预览！");
				}
				break;
			}
			// 停止拉远焦距
			case "zoom:outstop":
			{
				ChangeStatus(1);
				if(m_iPlay == 1)
				{
					if(m_iAutoPTZ == 1)
					{
						m_bDVRControl.PTZCtrlStop(10,m_iPTZSpeed);
						m_iAutoPTZ = 0;
					}
					if(m_bDVRControl.PTZCtrlStop(5,m_iPTZSpeed))
					{
						LogMessage("焦距拉远停止成功！");
					}
					else
					{
						LogMessage("焦距拉远停止失败！");
					}
				}
				else
				{
					LogMessage("请先预览！");
				}
				break;
			}
			case "focus:in":
			{

				if(m_iPlay == 1)
				{
					if(m_iAutoPTZ == 1)
					{
						m_bDVRControl.PTZCtrlStop(10,m_iPTZSpeed);
						m_iAutoPTZ = 0;
					}
					if(m_bDVRControl.PTZCtrlStart(6,m_iPTZSpeed))
					{
						LogMessage("聚焦拉近成功！");
					}
					else
					{
						LogMessage("聚焦拉近失败！");
					}
				}
				else
				{
					LogMessage("请先预览！");
				}
				break;
			}	
			case "focus:out":
			{

				if(m_iPlay == 1)
				{
					if(m_iAutoPTZ == 1)
					{
						m_bDVRControl.PTZCtrlStop(10,m_iPTZSpeed);
						m_iAutoPTZ = 0;
					}
					if(m_bDVRControl.PTZCtrlStart(7,m_iPTZSpeed))
					{
						LogMessage("聚焦拉远成功！");
					}
					else
					{
						LogMessage("聚焦拉远失败！");
					}
				}
				else
				{
					LogMessage("请先预览！");
				}
				break;
			}
			// focus拉近停止成功
			case "focus:instop":
			{
				ChangeStatus(1);
				if(m_iPlay == 1)
				{
					if(m_iAutoPTZ == 1)
					{
						m_bDVRControl.PTZCtrlStop(10,m_iPTZSpeed);
						m_iAutoPTZ = 0;
					}
					if(m_bDVRControl.PTZCtrlStop(6,m_iPTZSpeed))
					{
						LogMessage("聚焦拉近停止成功！");
					}
					else
					{
						LogMessage("聚焦拉近停止失败！");
					}
				}
				else
				{
					LogMessage("请先预览！");
				}
				break;
			}
			// focus拉远停止成功
			case "focus:outstop":
			{
				ChangeStatus(1);
				if(m_iPlay == 1)
				{
					if(m_iAutoPTZ == 1)
					{
						m_bDVRControl.PTZCtrlStop(10,m_iPTZSpeed);
						m_iAutoPTZ = 0;
					}
					if(m_bDVRControl.PTZCtrlStop(7,m_iPTZSpeed))
					{
						LogMessage("聚焦拉远停止成功！");
					}
					else
					{
						LogMessage("聚焦拉远停止失败！");
					}
				}
				else
				{
					LogMessage("请先预览！");
				}
				break;
			}
			case "iris:in":
			{
				if(m_iPlay == 1)
				{
					if(m_iAutoPTZ == 1)
					{
						m_bDVRControl.PTZCtrlStop(10,m_iPTZSpeed);
						m_iAutoPTZ = 0;
					}
					if(m_bDVRControl.PTZCtrlStart(8,m_iPTZSpeed))
					{
						LogMessage("光圈大成功！");
					}
					else
					{
						LogMessage("光圈大失败！");
					}
				}
				else
				{
					LogMessage("请先预览！");
				}
				break;
			}	
			case "iris:out":
			{
				if(m_iPlay == 1)
				{
					if(m_iAutoPTZ == 1)
					{
						m_bDVRControl.PTZCtrlStop(10,m_iPTZSpeed);
						m_iAutoPTZ = 0;
					}
					if(m_bDVRControl.PTZCtrlStart(9,m_iPTZSpeed))
					{
						LogMessage("光圈小成功！");
					}
					else
					{
						LogMessage("光圈小失败！");
					}
				}
				else
				{
					LogMessage("请先预览！");
				}
				break;
			}
			case "getImagePar":
			{
				if(m_iPlay == 1)
				{
					var szXmlInfo = m_bDVRControl.GetVideoEffect();
					if(szXmlInfo != "")
					{
						var xmlDoc = new ActiveXObject("Microsoft.XMLDOM");
						xmlDoc.async="false"
						xmlDoc.loadXML(szXmlInfo)	
						document.getElementById("PicLight").value = xmlDoc.documentElement.childNodes[0].childNodes[0].nodeValue;
						document.getElementById("PicContrast").value = xmlDoc.documentElement.childNodes[1].childNodes[0].nodeValue;
						document.getElementById("PicSaturation").value = xmlDoc.documentElement.childNodes[2].childNodes[0].nodeValue;
						document.getElementById("PicTonal").value = xmlDoc.documentElement.childNodes[3].childNodes[0].nodeValue;
						LogMessage("获取图像参数成功！");
					}
					else
					{
						LogMessage("获取图像参数失败！");
					}
				}
				else
				{
					LogMessage("请先预览！");
				}
				break;
			}		
			case "setImagePar":
			{
				if(m_iPlay == 1)
				{
					var iL = parseInt(document.getElementById("PicLight").value);
					var iC = parseInt(document.getElementById("PicContrast").value);
					var iS = parseInt(document.getElementById("PicSaturation").value);
					var iT = parseInt(document.getElementById("PicTonal").value);
					var bRet = m_bDVRControl.SetVideoEffect(iL,iC,iS,iT);
					if(bRet)
					{
						LogMessage("设置图像参数成功！");
					}
					else
					{
						LogMessage("设置图像参数失败！");
					}
				}
				else
				{
					LogMessage("请先预览！");
				}
				break;
			}
			case "setPreset":
			{
				if(m_iPlay == 1)
				{
					var iPreset = parseInt(document.getElementById("Preset").value);
					var bRet = m_bDVRControl.PTZCtrlSetPreset(iPreset);
					if(bRet)
					{
						LogMessage("设置预置点成功！");
					}
					else
					{
						LogMessage("设置预置点失败！");
					}
				}
				else
				{
					LogMessage("请先预览！");
				}
				break;
			}
			case "goPreset":
			{
				if(m_iPlay == 1)
				{
					var iPreset = parseInt(document.getElementById("Preset").value);
					var bRet = m_bDVRControl.PTZCtrlGotoPreset(iPreset);
					if(bRet)
					{
						LogMessage("调用预置点成功！");
					}
					else
					{
						LogMessage("调用预置点成功！");
					}
				}
				else
				{
					LogMessage("请先预览！");
				}
				break;
			}
			default:
			{
				// Record:start setPreset
				break;
			}
		}		// switch
	}
	catch(err)
	{
		alert(err);
	}
}

function LogMessage(msg)
{

}
/*******************************************************************************
 * Function: ArrangeWindow Description: 画面分割为几个窗口 Input: x : 窗口数目 Output: 无
 * return: 无
 ******************************************************************************/
function ArrangeWindow(x)
{
	var iMaxWidth = document.getElementById("OCXBody").offsetWidth;
	var iMaxHeight = document.getElementById("OCXBody").offsetHeight;
	for(var i = 1; i <= 4; i ++)
	{
		if(i <= x)
		{
			document.getElementById("NetPlayOCX" + i).style.display = "";
		}
		else
		{
			document.getElementById("NetPlayOCX" + i).style.display = "none";	
		}
	}
	var d = Math.sqrt(x);
	var iWidth = iMaxWidth/d;
	var iHight = iMaxHeight/d;
	for(var j = 1; j <= x; j ++)
	{
		document.getElementById("NetPlayOCX" + j).style.width = iWidth;
		document.getElementById("NetPlayOCX" + j).style.height = iHight;
	}
	if(x == 1)
	{

	}
	else if(x == 4)
	{
		
	}
	else
	{
		//	
	}
}
/*******************************************************************************
 * Function: ChangeStatus Description: 选中窗口时，相应通道的状态显示 Input: iWindowNum : 选中窗口号
 * Output: 无 return: 无
 ******************************************************************************/
function ChangeStatus(iWindowNum)
{  
	m_bDVRControl = document.getElementById("HIKOBJECT" + iWindowNum);
	for(var i = 1; i <= 4; i ++)
	{
		if(i == iWindowNum)
		{
			 document.getElementById("NetPlayOCX" + i).style.border = "1px solid #f00";
		}
		else
		{
			 document.getElementById("NetPlayOCX" + i).style.border = "1px solid #EBEBEB";	
		}
	}
	LogMessage("当前选中窗口" + iWindowNum);
}
	

	// 显示实时视频信息            
	m_bDVRControl = document.getElementById("HIKOBJECT1");

	function cameraVideo(camera,video){
		ArrangeWindow(2);   // 预览窗口数为2
		cameraIp=camera;
		ButtonPress('LoginDev');        // 注册高清
		ButtonPress('getDevName');      // 获取设备名称
		ButtonPress('getDevChan');      // 获取通道
		ChangeStatus(1);                // 选择第一个窗口
		ButtonPress('Preview:start');   // 开始预览
		
		videoIp=video;
		ButtonPress('LoginDev:red');    // 注册红外
		ButtonPress('getDevName');      // 获取设备名称
		ButtonPress('getDevChan');      // 获取通道
		ChangeStatus(2);				// 选择第二个窗口
		ButtonPress('Preview:startRed');   // 开始预览
	}
	/**
	 * 获取所有的机器人
	 * 	robotIp		机器人IP
		cameraIp	高清相机IP
		flirIp	    红外热像仪IP
		videoIp		视频服务器IP
		sickIp	    激光IP
	 */
	if($("#robotIp").val()==""){
		//刚加载页面时获取机器人列表并把列表存储
		getAllRobot();
		$("#robotListSave").val($("#robot").html());
	}else if($(".second").text()=="机器人管理" && $("#robotIp").val()!=""){
		//如果是机器人管理页面并且当前机器人信息不为空时将存储的机器人列表信息导入到列表下拉框
		$("#robot").html($("#robotListSave").val());
	}
	function getAllRobot(){
		console.log("getAllRobot");
		$.ajax({
			type:"post",
			url:"robotReportInfo/getRobotDeviceInfo.do?time=" + new Date().getTime(),
			async:false,
			success:function(data){
				if(data.result == "1"){
					var dataLen=data.data.length;
					for(var i=0;i<dataLen;i++){
						//flirAdmin其实是下面用到的videoAdmin，视频服务器密码，只不过传过来的字段名字是flirAdmin，为了避免与cameraIp字段误解
						$("#robot").append("<option data-robotIp='"+data.data[i].robotIp+"' value='"+i+"' data-cameraIp='"+data.data[i].cameraIp+"' data-flirIp='"+data.data[i].flirIp+"' data-videoIp='"+data.data[i].videoIp+"' data-sickIp='"+data.data[i].sickIp+"' data-cameraAdmin='"+data.data[i].cameraAdmin+"' data-cameraPassword='"+data.data[i].cameraPassword+"' data-videoAdmin='"+data.data[i].flirAdmin+"' data-videoPassword='"+data.data[i].flirPassword+"' >"+data.data[i].robotIp+"</option>");
					}

				}else{
					alert("没有机器人在线！");
				}
			},
			error:function(e){}
		});
	}



	/**
	 * 设置你要控制的机器人
	 * @param robotIp	机器人IP
	 * @param cameraIp	高清相机IP
	 * @param flirIp	红外热像仪IP
	 * @param videoIp	视频服务器IP
	 * @param sickIp	激光IP
	 */
	function setRobotInfo(robotIp,cameraIp,flirIp,videoIp,sickIp){
		$.ajax({
			type:"post",
			url:"robotControlInfo/setRobotDeviceInfo.do?time=" + new Date().getTime(),
			async:false,
			data:{
				"robotIp":robotIp,
				"cameraIp":cameraIp,
				"flirIp":flirIp,
				"videoIp":videoIp,
				"sickIp":sickIp
			},
			success:function(data){
				if(data.result == "1"){
				}else{
					
				}
			},
			error:function(e){}
		});
	}
	function robotInti(intiIndex){
		var inputRobotIp=$("#robotIp").val();
		var inputCameraIp=$("#cameraIp").val();
		var inputFlirIp=$("#flirIp").val();
		var inputVideoIp=$("#videoIp").val();
		var inputSickIp=$("#sickIp").val();
		
		var inputcameraAdmin=$("#cameraAdmin").val();
		var inputcameraPassword=$("#cameraPassword").val();
		var inputvideoAdmin=$("#videoAdmin").val();
		var inputvideoPassword=$("#videoPassword").val();
		
		if(inputRobotIp!="" && inputCameraIp!="" && inputFlirIp!="" && inputVideoIp!="" && inputSickIp!=""){
			robotIp=inputRobotIp;
			cameraIp=inputCameraIp;
			flirIp=inputFlirIp;
			videoIp=inputVideoIp;
			sickIp=inputSickIp;
			
			cameraAdmin=inputcameraAdmin;
			cameraPassword=inputcameraPassword;
			videoAdmin=inputvideoAdmin;
			videoPassword=inputvideoPassword;
			
			cameraVideo(cameraIp,videoIp);
			ChangeStatus(1);
		}else{
			robotIp=$("#robot option").eq(intiIndex).attr("data-robotIp");
			cameraIp=$("#robot option").eq(intiIndex).attr("data-cameraIp");
			flirIp=$("#robot option").eq(intiIndex).attr("data-flirIp");
			videoIp=$("#robot option").eq(intiIndex).attr("data-videoIp");
			sickIp=$("#robot option").eq(intiIndex).attr("data-sickIp");
			
			cameraAdmin=$("#robot option").eq(intiIndex).attr("data-cameraAdmin");
			cameraPassword=$("#robot option").eq(intiIndex).attr("data-cameraPassword");
			videoAdmin=$("#robot option").eq(intiIndex).attr("data-videoAdmin");
			videoPassword=$("#robot option").eq(intiIndex).attr("data-videoPassword");
			
			$("#robotIp").val(robotIp);
			$("#cameraIp").val(cameraIp);
			$("#flirIp").val(flirIp);
			$("#videoIp").val(videoIp);
			$("#sickIp").val(sickIp);
			
			$("#cameraAdmin").val(cameraAdmin);
			$("#cameraPassword").val(cameraPassword);
			$("#videoAdmin").val(videoAdmin);
			$("#videoPassword").val(videoPassword);
			
			cameraVideo(cameraIp,videoIp);	
		}

	}
	function robotSelect(robotIndex){
			robotIp=$("#robot option").eq(robotIndex).attr("data-robotIp");
			cameraIp=$("#robot option").eq(robotIndex).attr("data-cameraIp");
			flirIp=$("#robot option").eq(robotIndex).attr("data-flirIp");
			videoIp=$("#robot option").eq(robotIndex).attr("data-videoIp");
			sickIp=$("#robot option").eq(robotIndex).attr("data-sickIp");
			
			cameraAdmin=$("#robot option").eq(robotIndex).attr("data-cameraAdmin");
			cameraPassword=$("#robot option").eq(robotIndex).attr("data-cameraPassword");
			videoAdmin=$("#robot option").eq(robotIndex).attr("data-videoAdmin");
			videoPassword=$("#robot option").eq(robotIndex).attr("data-videoPassword");
			
			$("#robotIp").val(robotIp);
			$("#cameraIp").val(cameraIp);
			$("#flirIp").val(flirIp);
			$("#videoIp").val(videoIp);
			$("#sickIp").val(sickIp);
			
			$("#cameraAdmin").val(cameraAdmin);
			$("#cameraPassword").val(cameraPassword);
			$("#videoAdmin").val(videoAdmin);
			$("#videoPassword").val(videoPassword);
			
			cameraVideo(cameraIp,videoIp);
	}
	var robotIp,cameraIp,flirIp,videoIp,sickIp;

	//选择列表里的第一个机器人
	robotInti(0);
	setRobotInfo(robotIp,cameraIp,flirIp,videoIp,sickIp);



	$("#robot").change(function(){
		var robotIndex=$(this).val();
   		var robotTime;	
   		robotTime=setInterval(function(){
   			robotSelect(robotIndex);
   			setRobotInfo(robotIp,cameraIp,flirIp,videoIp,sickIp);
   			clearInterval(robotTime);
   		},1000);

	})

	$(function(){
		// 原来这里用了window.onload=function(){}没有执行里面的代码！
		
		/**
		 * liangqin 获取变电站地图信息，主要为地图的区域范围及分辨率。
		 */
		$.ajax({
			type:"post",
			async:false,
			url:"robotReportInfo/getStationMapInfo.do",
			success:function(data){
				MapInfo.min_x = data.data.minX;
				MapInfo.min_y = data.data.minY;
				MapInfo.max_x = data.data.maxX;
				MapInfo.max_y = data.data.maxY;		
				MapInfo.resolution = data.data.resolution;
				MapInfo.map_width = Math.abs(MapInfo.max_x - MapInfo.min_x);
				MapInfo.map_height = Math.abs(data.data.maxY - data.data.minY);
				
				

			}
		});

		
		/**
		 * cuijiekun 加载所有路径
		 */
		$.ajax({
			type:"post",
			async:false,
			url:"robotReportInfo/getStationEdgeInfo.do",
			success:function(data){
				for(var i = 0 ; i < data.data.length ; i++){
					var pos1 = transPostionOnColor(data.data[i].startX,data.data[i].startY);
					var pos2 = transPostionOnColor(data.data[i].endX,data.data[i].endY);
				}		
				
			},
			error:function(){
				alert("获取路径失败！");
			}
		});
		
		/**
		 * liangqin 获取当前巡检任务所需要经过的巡检路径ID列表
		 */
		$.ajax({
			type:"post",
			async:false,
			url:"robotReportInfo/getPatrolEdgeInfo.do",
			success:function(data){
				
				for(var i = 0 ; i < data.data.length ; i++){
									
					var pos1 = transPostionOnColor(data.data[i].startX,data.data[i].startY);
					var pos2 = transPostionOnColor(data.data[i].endX,data.data[i].endY);
					
					drawLine(pos1.px_x,pos1.px_y,pos2.px_x,pos2.px_y,"red");
				}
			},
			error:function(){
				alert("获取路径失败！");
			}
		});
		
})
/**
 * soliang
 */
/**
 * 云台控制按键触发事件
 */
var Iskeydown=false;
var keydownOnce=0;
$(document).keydown(function(event){
	if($(".second").text()=="机器人遥控"){
		if(event.keyCode==38 && !Iskeydown){
			console.log("keydown");
			ButtonPress('PTZ:up');
			Iskeydown=true;
		}else if(event.keyCode==37){
			ButtonPress('PTZ:left');
			Iskeydown=true;
		}else if(event.keyCode==40){
			ButtonPress('PTZ:down');
			Iskeydown=true;
		}else if(event.keyCode==39){
			ButtonPress('PTZ:right');
			Iskeydown=true;
		}
	}
})
$(document).keyup(function(event){
	if(Iskeydown && $(".second").text()=="机器人遥控"){ 
		ButtonPress('PTZ:stop');
		Iskeydown=false;
	}
})
