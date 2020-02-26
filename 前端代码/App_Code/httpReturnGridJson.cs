using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

/// <summary>
///httpReturnGridJson 的摘要说明
/// </summary>
public class httpReturnGridJson
{
	public httpReturnGridJson()
	{
		//
		//TODO: 在此处添加构造函数逻辑
		//
       
	}

    public int Total
    {
        get;
        set;
    }
    public object Rows
    {
        get;
        set;
    }

    public bool success
    {
        get;
        set;
    }

    public string detail
    {
        get;
        set;
    }
}