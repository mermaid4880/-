using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

/// <summary>
/// 
/// </summary>
public class RunSqlReturn_class
{

    private int ireturn=0;//sql 执行后返回的影响行数
    private int dbId = 0;//执行后影响的id 新增的id 或者 修改的id
    private string message="";//如果执行过程中有问题 返回的问题信息

    public int iReturn
    {
        get
        {
            return ireturn;
        }
        set
        {
            this.ireturn = value;
        }
    }

    public int DbID
    {
        get
        {
            return dbId;
        }
        set
        {
            this.dbId = value;
        }
    }

    public string Message
    {
        get
        {
            return message;
        }
        set
        {
            this.message = value;
        }
    }

	public RunSqlReturn_class()
	{
		//
		//TODO: 在此处添加构造函数逻辑
		//

       
	}
}