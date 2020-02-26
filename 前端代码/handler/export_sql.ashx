<%@ WebHandler Language="C#" Class="export_sql" %>

using System;
using System.Data;
using System.IO;
using System.Web;
using NPOI.HPSF;
using NPOI.HSSF.UserModel;
using NPOI.SS.UserModel;
using System.Web.SessionState;

using ICSharpCode.SharpZipLib.Zip;


public class export_sql : IHttpHandler, IRequiresSessionState{

    private static string cookieTage = PublicMethod.public_getConfigStr("cookieTage");
    
    string FunctionID;
    string view = "";//表或视图名
    string filename = "export";//导出文件名
    string User_name = "";//取得用户名
    string sortname;
    string sortorder = " asc";
    string wherea;
    string sheet_name = "sheet1";//工作表名
    string Field_class = "";
    public static int MAXLINE = 60000;
    string sPath = HttpContext.Current.Request.MapPath("~/") + "ExportXlsFiles\\";
    int count;

    string gridName = "";

    public void ProcessRequest(HttpContext context)
    {
        
        
        context.Response.ContentType = "text/plain";
        FunctionID = context.Request["FunctionID"];

        Field_class = context.Request["Field_class"];



        if (!string.IsNullOrEmpty(FunctionID))
        {
            try { User_name = DES_En_De.DesDecrypt(context.Request.Cookies[cookieTage]["d5hgj5jk7sfa"]); }//取得用户名
            catch { }
            
            sheet_name = GetFunctionInfo.GetFunction_name(FunctionID);
            filename = sheet_name + "_" + DateTime.Now.ToString("yyyy-MM-dd") + "_" + User_name;//取得文件名
            if (context.Request["gridName"] != null)
            {
                gridName = context.Request["gridName"].ToString();//取得表名 
            }

            if (context.Request["view"] != null)
            {
                view = context.Request["view"].ToString();//取得表名
            }
            else
            {
                view = GetFunctionInfo.GetTable_name(FunctionID, gridName);//取得表名 

            }

            export1(context);
        }
    }
    public void export1(HttpContext context)
    {

        HttpResponse response = context.Response;
        response.ContentType = "application/vnd.ms-excel";
        string UserAgent = context.Request.ServerVariables["http_user_agent"].ToLower();
        if (UserAgent.Contains("msie") || UserAgent.Contains("opera"))//火狐不一样
            filename = HttpUtility.UrlEncode(filename, System.Text.Encoding.UTF8);

        GenerateData(context);
        if (count > MAXLINE - 1)
        {
            response.AppendHeader("Content-Disposition", string.Format("attachment;filename={0}.zip", filename));
            response.Clear();
            string zipfile = sPath + filename + ".zip";
            CreateZipFile(sPath, zipfile);
            // 添加头信息，指定文件大小，让浏览器能够显示下载进度
            //FileInfo fileInfo = new FileInfo(zipfile);
            //response.AddHeader("Content-Length", fileInfo.Length.ToString());

            response.WriteFile("../ExportXlsFiles/" + filename + ".zip");
        }
        else
        {
            response.AppendHeader("Content-Disposition", string.Format("attachment;filename={0}.xls", filename));
            response.Clear();
            //response.WriteFile("../xls/" + filename + ".xls");

            WriteToStream().WriteTo(response.OutputStream);//这样省内存
        }
        response.End();
    }

    HSSFWorkbook hssfworkbook;
    MemoryStream WriteToStream()
    {
        MemoryStream file = new MemoryStream();
        hssfworkbook.Write(file);
        return file;
    }
    private void CreateZipFile(string filesPath, string zipFilePath)
    {

        if (!Directory.Exists(filesPath))
        {
            Console.WriteLine("Cannot find directory '{0}'", filesPath);
            return;
        }

        try
        {
            string[] filenames = Directory.GetFiles(filesPath, filename + "*.xls");
            using (ZipOutputStream s = new ZipOutputStream(File.Create(zipFilePath)))
            {

                s.SetLevel(1); // 压缩级别 0-9 0为存储 9为最大压缩比 1比较合适
                //s.Password = "123"; //Zip压缩文件密码
                byte[] buffer = new byte[4096]; //缓冲区大小
                foreach (string file in filenames)
                {
                    ZipEntry entry = new ZipEntry(Path.GetFileName(file));
                    entry.DateTime = DateTime.Now;
                    s.PutNextEntry(entry);
                    using (FileStream fs = File.OpenRead(file))
                    {
                        int sourceBytes;
                        do
                        {
                            sourceBytes = fs.Read(buffer, 0, buffer.Length);
                            s.Write(buffer, 0, sourceBytes);
                        } while (sourceBytes > 0);
                    }
                    File.Delete(file);//删除excel文件
                    Console.WriteLine(file);
                }

                s.Finish();
                s.Close();
            }
        }
        catch (Exception ex)
        {
            Console.WriteLine("Exception during processing {0}", ex);
        }
    }
    void GenerateData(HttpContext context)
    {

        DataTable dt = new DataTable();
        string sessionSql = "sql_" + gridName + "_" + view;//session名称
        if (context.Session[sessionSql] != null)
        {
            System.Collections.Generic.List<object> l = (System.Collections.Generic.List<object>)context.Session[sessionSql];
            if (l.Count>0)
            {
                SQLHelper db_helper = new SQLHelper();
                if (l[0].ToString() == "V")//这是视图
                {
                    try
                    {
                        dt = db_helper.GetDataTable(l[1].ToString());
                    }
                    catch
                    {

                    }
                }
                else if (l[0].ToString() == "U")
                {
                    string up_name = l[1].ToString();
                    System.Data.SqlClient.SqlParameter[] commandParameters  = (System.Data.SqlClient.SqlParameter[])l[2];
                     DataSet ds=new DataSet();
                    try
                    {
                         ds = db_helper.RunProcedure(up_name, commandParameters, up_name);
                    }
                    catch(Exception ex)
                    {
                        string m = ex.Message;
                    }
                    if (ds != null)
                    {
                        dt = ds.Tables[0]; 
                    }
                }
                
                
                
            }
           
        }

        count = dt.Rows.Count;
        if (count < MAXLINE)
        {
            InitializeWorkbook();
            DataTable Table_info = new DataTable();
            if (!string.IsNullOrEmpty(Field_class)) { Table_info = GetFunctionInfo.Table_info(FunctionID, User_name, Field_class); }
            else { Table_info = GetFunctionInfo.Table_info(FunctionID, User_name); }
            ISheet sheet1 = hssfworkbook.CreateSheet(sheet_name);
            //Fzlb
            for (int i = 0; i < Table_info.Rows.Count; i++)
            {
                sheet1.SetColumnWidth(i, Convert.ToInt32(Table_info.Rows[i]["Field_width"]) * 256 / 8);
            }
            IRow row0 = sheet1.CreateRow(0);
            row0.HeightInPoints = 20;
            //设置页头字体格式
            IFont font1 = hssfworkbook.CreateFont();
            font1.FontName = "宋体";//字体
            font1.FontHeightInPoints = 14;//字号
            font1.Boldweight = 700;//粗体 
            ICellStyle style1 = hssfworkbook.CreateCellStyle();
            style1.IsLocked = true;
            style1.SetFont(font1);
            style1.Alignment = NPOI.SS.UserModel.HorizontalAlignment.CENTER;//对齐

            //尝试锁定
            HSSFCellStyle locked_title = (HSSFCellStyle)hssfworkbook.CreateCellStyle();
            locked_title.IsLocked = true;
            locked_title.SetFont(font1);
            locked_title.Alignment = NPOI.SS.UserModel.HorizontalAlignment.CENTER;//对齐
            HSSFCellStyle unlocked_title = (HSSFCellStyle)hssfworkbook.CreateCellStyle();
            unlocked_title.IsLocked = false;
            unlocked_title.SetFont(font1);
            unlocked_title.Alignment = NPOI.SS.UserModel.HorizontalAlignment.CENTER;//对齐

            //尝试锁定
            HSSFCellStyle locked = (HSSFCellStyle)hssfworkbook.CreateCellStyle();
            locked.IsLocked = true;
            HSSFCellStyle unlocked = (HSSFCellStyle)hssfworkbook.CreateCellStyle();
            unlocked.IsLocked = false;
            

            //execl表头 锁定也根据配置的地方

            for (int i = 0; i < Table_info.Rows.Count; i++)
            {
                if (Table_info.Rows[i]["Field_export_locked"].ToString().Trim() == "1")
                {
                    sheet1.SetDefaultColumnStyle(i, locked_title);
                    row0.CreateCell(i).SetCellValue(Table_info.Rows[i]["Field_display"].ToString());
                }
                else
                {
                    sheet1.SetDefaultColumnStyle(i, unlocked_title);
                    row0.CreateCell(i).SetCellValue(Table_info.Rows[i]["Field_display"].ToString());
                }
            }

            if (dt.Rows.Count == 0) //如果是空数据的时候，要求只锁定表头
            {
                for (int i = 0; i < 1; i++)
                {
                    IRow row = sheet1.CreateRow(i + 1);
                    for (int j = 0; j < Table_info.Rows.Count; j++)
                    {
                        sheet1.SetDefaultColumnStyle(j, unlocked);
                    }
                }


            }
            for (int i = 0; i < dt.Rows.Count; i++)
            {
                IRow row = sheet1.CreateRow(i + 1);

                for (int j = 0; j < Table_info.Rows.Count; j++)
                {
                    string columnName = Table_info.Rows[j]["Field_name"].ToString().Trim();
                    if (checkColumnIndt(columnName, dt))
                    {
                        string str = dt.Rows[i][columnName].ToString();
                        if (string.IsNullOrEmpty(str))
                        {
                            str = " "; 
                        }
                        if (Table_info.Rows[j]["Field_export_locked"].ToString() == "1")
                        {
                            sheet1.SetDefaultColumnStyle(j, locked);
                            row.CreateCell(j).SetCellValue(str);
                        }
                        else
                        {
                            sheet1.SetDefaultColumnStyle(j, unlocked);
                            row.CreateCell(j).SetCellValue(str);
                        }

                    }
                    else
                    {
                        sheet1.SetDefaultColumnStyle(j, unlocked);
                    }

                }
            }
            //sheet1.ProtectSheet("deer"); 

        }
        else
        {
            int now = 0;
            int num = 0;
            while (num < dt.Rows.Count)
            {
                InitializeWorkbook();
                DataTable Table_info = new DataTable();
                if (!string.IsNullOrEmpty(Field_class)) { Table_info = GetFunctionInfo.Table_info(FunctionID, User_name, Field_class); }
                else { Table_info = GetFunctionInfo.Table_info(FunctionID, User_name); }
                ISheet sheet1 = hssfworkbook.CreateSheet(sheet_name);
                for (int i = 0; i < Table_info.Rows.Count; i++)
                {
                    sheet1.SetColumnWidth(i, Convert.ToInt32(Table_info.Rows[i]["Field_width"]) * 256 / 8);
                }
                IRow row0 = sheet1.CreateRow(0);
                row0.HeightInPoints = 20;
                //设置页头字体格式
                IFont font1 = hssfworkbook.CreateFont();
                font1.FontName = "宋体";//字体
                font1.FontHeightInPoints = 14;//字号
                font1.Boldweight = 700;//粗体 
                ICellStyle style1 = hssfworkbook.CreateCellStyle();
                style1.SetFont(font1);
                style1.Alignment = NPOI.SS.UserModel.HorizontalAlignment.CENTER;//对齐
                //
                for (int i = 0; i < Table_info.Rows.Count; i++)
                {
                    row0.CreateCell(i).SetCellValue(Table_info.Rows[i]["Field_display"].ToString());
                    row0.Cells[i].CellStyle = style1;
                }

                for (int i = 0; i < MAXLINE + 1; i++)
                {
                    if (num >= dt.Rows.Count)
                    {
                        break;
                    }
                    IRow row = sheet1.CreateRow(i + 1);
                    for (int j = 0; j < Table_info.Rows.Count; j++)
                    {
                        string columnName = Table_info.Rows[j]["Field_name"].ToString().Trim();
                        if (checkColumnIndt(columnName, dt))
                        {
                            row.CreateCell(j).SetCellValue(dt.Rows[i][columnName].ToString());
                        }
                        else
                        {
                            row.CreateCell(j).SetCellValue("");
                        }

                        //row.CreateCell(j).SetCellValue(dt.Rows[num][Table_info.Rows[j]["Field_name"].ToString()].ToString());
                    }
                    num++;
                }

                now++;
                FileStream fs2 = File.Create(sPath + filename + now + ".xls");
                hssfworkbook.Write(fs2);
                fs2.Close();
            }
        }
    }

    private void setToExecl_Public_Meter_Problem(DataTable dt, string cjq_time)
    {
        if (dt != null)
        {
            SQLHelper db_helper = new SQLHelper();
            int iLen = dt.Rows.Count;
            if (iLen > 0)
            {
                DataTable mydt = virTable();
                for (int i = 0; i < iLen; i++)
                {
                    DataRow row = mydt.NewRow();//代码1
                    row[0] = dt.Rows[i]["gnj"].ToString();
                    row[1] = dt.Rows[i]["Meter_id"].ToString();
                    row[2] = cjq_time;
                    row[3] = dt.Rows[i]["Txzt"].ToString();
                    mydt.Rows.Add(row);
                }
                if (mydt.Rows.Count > 0)
                {

                    db_helper.RunSqlNo(" truncate table Execl_Public_Meter_Problem");
                    System.Collections.Generic.Dictionary<String, String> dicList = new System.Collections.Generic.Dictionary<string, string>();
                    dicList.Add("gnj", "gnj");
                    dicList.Add("Meter_id", "Meter_id");
                    dicList.Add("cjq_time", "cjq_time");
                    dicList.Add("Reason", "Reason");
                    db_helper.DataTableToSQLServer(mydt, "Execl_Public_Meter_Problem", dicList);
                }
            }

        }
    }

    private DataTable virTable()
    {
        DataTable dt = new DataTable();
        dt.Columns.Add("gnj");
        dt.Columns.Add("Meter_id");
        dt.Columns.Add("cjq_time");
        dt.Columns.Add("Reason");
        return dt;
    }

    void InitializeWorkbook()
    {
        hssfworkbook = new HSSFWorkbook();
        DocumentSummaryInformation dsi = PropertySetFactory.CreateDocumentSummaryInformation();
        dsi.Company = "德尔自控技术有限公司";
        hssfworkbook.DocumentSummaryInformation = dsi;
        SummaryInformation si = PropertySetFactory.CreateSummaryInformation();
        si.Subject = filename;
        hssfworkbook.SummaryInformation = si;
    }
    public bool IsReusable
    {
        get
        {
            return false;
        }
    }
    /// <summary>
    /// 检测列名是否存在dt中
    /// </summary>
    /// <param name="columnName"></param>
    /// <param name="dt"></param>
    /// <returns></returns>
    private bool checkColumnIndt(string columnName, DataTable dt)
    {
        bool bHas = false;
        if (dt != null)
        {
            if (dt.Columns.Count > 0)
            {
                for (int i = 0; i < dt.Columns.Count; i++)
                {
                    if (columnName == dt.Columns[i].ToString())
                    {
                        bHas = true;
                        break;
                    }
                }
            }
        }
        return bHas;
    }
}