using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Text;
using Newtonsoft.Json.Linq;
public partial class tree_systemTree : System.Web.UI.Page
{
    public StringBuilder seriesDataMenu = new StringBuilder();

    protected void Page_Load(object sender, EventArgs e)
    {
        int iTreeLevel = int.Parse(PublicMethod.public_getConfigStr("treeShowLevel"));

        string sql = "";
        SQLHelper sh = new SQLHelper();
        string icon = "../lib/silkicons/1_cb_cg.png";
        string icon2 = "../lib/silkicons/medal_gold_1.png";
        string icon3 = "../lib/silkicons/picture_add.png";
        seriesDataMenu.Append("[");


        //seriesDataMenu.AppendFormat("{{name:'{0}',no:'{1}',icon:'{2}',pId:'0',open:true}},", "供电公司", "A1", icon);

        //seriesDataMenu.AppendFormat("{{name:'{0}',no:'B1',icon:'{2}',pId:'A1',open:true}},", "山东省", "1", icon2);
        //seriesDataMenu.AppendFormat("{{name:'{0}',no:'B2',icon:'{2}',pId:'A1',open:true}},", "山西省", "1", icon2);

        //seriesDataMenu.AppendFormat("{{name:'{0}',no:'C1',icon:'{2}',pId:'B1',open:true}},", "设备1", "1", icon3);
        //seriesDataMenu.AppendFormat("{{name:'{0}',no:'C2',icon:'{2}',pId:'B2',open:true}},", "设备2", "1", icon3);

        if (Request.Cookies["token"] != null) {

            string token = Request.Cookies["token"].ToString(); ;

        }
        

        //这里获取设备树
        string Authorization = "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiI2MTMiLCJleHAiOjE1Mzk5NDA4OTMsInVzZXIiOiJ7XCJ1c2VySWRcIjpcIjIwNTJjZDE4ZmI0NTRlOWRhNTBiNjkxMjkzOTU4ZmZmXCIsXCJuYW1lXCI6XCJtb1wiLFwiYWNjZXNzSWRzXCI6XCIxLDIsM1wifSJ9.yb39Akfr7Vq-BIxG_7bal2MqrrL-WoBq9CoeDYiBv4E";//这里是得到的token
        Authorization = "Authorization:Bearer " + Authorization;
        string strReturn = "";//是否可以获取 token
        string url = PublicMethod.Public_GetWebConfigStr("interFaceUrl") + "/areas";
        System.Collections.Generic.List<string> l = new System.Collections.Generic.List<string>();
        System.Net.CookieContainer cs = new System.Net.CookieContainer();
        l.Add(Authorization);
        HttpHeader_new hd = new HttpHeader_new();
        hd.l_strp = l;
        string html = HTMLHelper_new.GetHtml(url, hd, cs);
        /*
         
         * [{"id":35,"areaName":"**变电站","parentId":null},{"id":36,"areaName":" 110kV","parentId":35},{"id":37,"areaName":" 1主变","parentId":35},{"id":38,"areaName":" A线路","parentId":36},{"id":39,"areaName":" B线路","parentId":36}]
         * 
         */
        if (!string.IsNullOrEmpty(html))
        {
            strReturn = html;
            
            try{
                //对应层级结构发生改变 20190429
                JObject o1 = JObject.Parse(html);
                JArray ja = JArray.Parse(o1["data"].ToString());
                if (ja.Count > 0) {
                    for (int i = 0; i < ja.Count; i++) {
                        
                        string parentId = "";
                        JObject o = JObject.Parse(ja[i].ToString());
                        if (o["parentId"] != null && o["parentId"].ToString() != "") {
                            parentId = o["parentId"].ToString();
                        }

                        seriesDataMenu.AppendFormat("{{name:'{0}',no:'{1}',icon:'{2}',pId:'{3}',open:true, isParent:true}},"
                            , o["areaName"].ToString()
                            , o["id"].ToString()
                            , parentId
                            , icon);
                        
                    }
                }
            }
            catch(Exception ex)
            {

            }
           

        }
        




        seriesDataMenu.Append("]");
    }
}