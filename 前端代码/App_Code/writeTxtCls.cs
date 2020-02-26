using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.IO;

/// <summary>
///writeTxtCls 的摘要说明
/// </summary>
public class writeTxtCls
{
    private string Path = HttpContext.Current.Request.MapPath("~/") + "logText\\";
    /// <summary>
    /// 检测是否存在
    /// </summary>
    /// <param name="strFileName"></param>
    /// <returns></returns>
    public bool checkTxtFile(string strFileName)
    {
        if (File.Exists(strFileName))
        {
            return true;
        }
        else
        {
            return false;
        }
    }

    public void writeTxtToFile(string strFileName, string strText)
    {
        try
        {
            strFileName = Path + strFileName;
            //这是写
            FileStream fs = new FileStream(strFileName, FileMode.Append);
            StreamWriter sw = new StreamWriter(fs);
            //开始写入
            sw.Write(strText);
            //清空缓冲区
            sw.Flush();
            //关闭流
            sw.Close();
            fs.Close();
        }
        catch
        {
        }

    }

    public void writeTxtToFile( string strText)
    {
        string strFileName = "txtlog"+System.DateTime.Now.ToString("yyyyMMdd")+ ".txt";
        try
        {
            strFileName = Path + strFileName;
            //这是写
            FileStream fs = new FileStream(strFileName, FileMode.Append);
            StreamWriter sw = new StreamWriter(fs);
            //开始写入
            sw.Write(strText);
            //清空缓冲区
            sw.Flush();
            //关闭流
            sw.Close();
            fs.Close();
        }
        catch
        {
        }

    }

    public void writeTxtToCurrtFile(string strFileInfo, string strText)
    {
        try
        {
            //这是写
            FileStream fs = new FileStream(strFileInfo, FileMode.Append);
            StreamWriter sw = new StreamWriter(fs);
            //开始写入
            sw.Write(strText);
            //清空缓冲区
            sw.Flush();
            //关闭流
            sw.Close();
            fs.Close();
        }
        catch
        {
        }


    }

    public bool writeTxtToFileAndUpdate(string strFileName, string strPhone, string strText)
    {
        bool isHas = false;
        try
        {
            strFileName = Path + strFileName;

            string strAllText = "";


            if (checkTxtFile(strFileName))
            {
                #region
                //先读取该文件
                FileStream fs_Read = new FileStream(strFileName, FileMode.Open);
                StreamReader m_streamReader = new StreamReader(fs_Read);
                m_streamReader.BaseStream.Seek(0, SeekOrigin.Begin);

                string strLine = m_streamReader.ReadLine();
                while (strLine != null && strLine != "")
                {
                    int iIndexBegin = strLine.IndexOf("：");
                    int iIndexEnd = strLine.IndexOf("，");
                    if (iIndexBegin >= 0 && iIndexEnd > iIndexBegin + 5)
                    {
                        if (strLine.Substring(iIndexBegin + 1, iIndexEnd - iIndexBegin - 1) == strPhone)
                        {
                            isHas = true;
                            strAllText += strText;
                        }
                        else
                        {
                            strAllText += strLine + "\r\n";
                        }
                    }

                    strLine = m_streamReader.ReadLine();
                }
                //关闭流
                m_streamReader.Close();
                fs_Read.Close();
                #endregion
            }


            if (isHas == false)
            {
                //这是写
                FileStream fs = new FileStream(strFileName, FileMode.Append);
                StreamWriter sw = new StreamWriter(fs);
                //开始写入
                sw.Write(strText);
                //清空缓冲区
                sw.Flush();
                //关闭流
                sw.Close();
                fs.Close();
            }
            else
            {
                //这是写
                FileStream fs = new FileStream(strFileName, FileMode.OpenOrCreate);
                StreamWriter sw = new StreamWriter(fs);
                //开始写入
                sw.Write(strAllText);
                //清空缓冲区
                sw.Flush();
                //关闭流
                sw.Close();
                fs.Close();
            }
        }
        catch
        {
        }


        return isHas;
    }


}