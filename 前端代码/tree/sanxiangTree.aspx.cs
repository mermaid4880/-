using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Text;
using Newtonsoft.Json.Linq;

public partial class tree_sanxiangTree : System.Web.UI.Page
{
    public StringBuilder seriesDataMenu = new StringBuilder();
    public StringBuilder MeterPropertyJsonArray = new StringBuilder();//这是 点位点 对应的属性
    List<MeterPropertyCls3> l_MeterProperty = new List<MeterPropertyCls3>();
    protected void Page_Load(object sender, EventArgs e)
    {
        int iTreeLevel = int.Parse(PublicMethod.public_getConfigStr("treeShowLevel"));


        string token = "";
        string cookieTage = PublicMethod.public_getConfigStr("cookieTage");
        try
        {
            token = System.Web.HttpContext.Current.Request.Cookies[cookieTage]["pi3djdg001Token"];
        }
        catch
        {
        }





        //这里获取设备树
        string Authorization = token;//这里是得到的token
        Authorization = "Authorization:Bearer " + Authorization;
        string url = PublicMethod.Public_GetWebConfigStr("interFaceUrl") + "/areas/treeOfThreeRelation";
        System.Collections.Generic.List<string> l = new System.Collections.Generic.List<string>();
        System.Net.CookieContainer cs = new System.Net.CookieContainer();
        l.Add(Authorization);
        HttpHeader_new hd = new HttpHeader_new();
        hd.l_strp = l;
        string html = HTMLHelper_new.GetHtml(url, hd, cs);
        /*
         
         * [{"id":35,"areaName":"**变电站","parentId":null},{"id":36,"areaName":" 110kV","parentId":35},{"id":37,"areaName":" 1主变","parentId":35},{"id":38,"areaName":" A线路","parentId":36},{"id":39,"areaName":" B线路","parentId":36}]
         * {"id":35,"areaName":"**变电站","parentId":null,"children":[{"id":36,"areaName":" 110kV","parentId":35,"children":[{"id":38,"areaName":" A线路","parentId":36,"children":null,"deviceGroupByTypes":[{"deviceTypeName":"避雷器","devices":[{"id":1,"deviceName":"避雷器A相","deviceType":"避雷器","areaId":38,"meters":[{"id":1,"meterName":"A线路避雷器A相_泄露电流表","meterType":"泄漏电流表","detectionType":"表计读取","saveType":"可见光图片","deviceId":1,"deviceName":"避雷器A相","deviceType":"避雷器","areaId":38},{"id":2,"meterName":"A线路避雷器A相_接头","meterType":"红外检测点","detectionType":"红外测温","saveType":"红外+可见光图片","deviceId":1,"deviceName":"避雷器A相","deviceType":"避雷器","areaId":38}]},{"id":2,"deviceName":"避雷器B相","deviceType":"避雷器","areaId":38,"meters":[{"id":3,"meterName":"A线路避雷器B相_接头","meterType":"红外检测点","detectionType":"红外测温","saveType":"红外+可见光图片","deviceId":2,"deviceName":"避雷器B相","deviceType":"避雷器","areaId":38}]}]},{"deviceTypeName":"断路器","devices":[{"id":4,"deviceName":"断路器A相","deviceType":"断路器","areaId":38,"meters":[{"id":5,"meterName":"A线路断路器A相_接头","meterType":"红外检测点","detectionType":"红外测温","saveType":"红外+可见光图片","deviceId":4,"deviceName":"断路器A相","deviceType":"断路器","areaId":38}]}]}]},{"id":39,"areaName":" B线路","parentId":36,"children":null,"deviceGroupByTypes":[{"deviceTypeName":"断路器","devices":[{"id":3,"deviceName":"断路器A相","deviceType":"断路器","areaId":39,"meters":[{"id":4,"meterName":"B线路断路器A相_接头","meterType":"红外检测点","detectionType":"红外测温","saveType":"红外+可见光图片","deviceId":3,"deviceName":"断路器A相","deviceType":"断路器","areaId":39}]}]}]}],"deviceGroupByTypes":[]},{"id":37,"areaName":" 1主变","parentId":35,"children":null,"deviceGroupByTypes":[]}],"deviceGroupByTypes":[]}
         */
        seriesDataMenu.Append("[");
        if (!string.IsNullOrEmpty(html))
        {
            //对应层级结构发生改变 20190429
            JObject o1 = JObject.Parse(html);
            JObject o = JObject.Parse(o1["data"].ToString());


            //JArray ja = JArray.Parse(o["children"][0]["children"][0]["deviceGroupByTypes"].ToString());

            //string a=get设备类型(ja, "");
            //seriesDataMenu.Append(a);
            string a = get变电所(o);
            seriesDataMenu.Append(a);
            if (l_MeterProperty.Count > 0)
            {
                MeterPropertyJsonArray.Append(Newtonsoft.Json.JsonConvert.SerializeObject(l_MeterProperty));
            }
        }





        seriesDataMenu.Append("]");
    }

    private string get变电所(JObject o)
    {
        string icon = "../lib/silkicons/medal_silver_add.png";
        StringBuilder sb = new StringBuilder();
        string id = "A" + o["id"].ToString();
        string areaName = o["areaName"].ToString();
        sb.AppendFormat("{{name:'{0}',no:'{1}',pId:'{2}',icon:'{3}',open:true, isParent:true}},"
                          , areaName
                          , id
                          , ""
                          , icon);
        if (o["children"] != null)
        {
            JArray ja = JArray.Parse(o["children"].ToString());
            string a = get电压(ja, id);
            sb.Append(a);
        }

        return sb.ToString();
    }


    private string get电压(JArray ja, string pid)
    {
        string icon = "../lib/silkicons/paintcan.png";
        StringBuilder sb = new StringBuilder();
        if (ja.Count > 0)
        {
            for (int i = 0; i < ja.Count; i++)
            {
                try
                {
                    string id = "B" + ja[i]["id"].ToString();
                    JObject o = JObject.Parse(ja[i].ToString());
                    sb.AppendFormat("{{name:'{0}',no:'{1}',pId:'{2}',icon:'{3}',open:true, isParent:true}},"
                           , o["areaName"].ToString()
                           , id
                           , pid
                           , icon);

                    if (o["children"] != null)
                    {
                        JArray ja2 = JArray.Parse(o["children"].ToString());
                        if (ja2.Count > 0)
                        {
                            string rebiao = get线路(ja2, id);
                            sb.Append(rebiao);
                        }

                    }


                }
                catch
                {
                }


            }
        }

        return sb.ToString();
    }

    private string get线路(JArray ja, string pid)
    {
        string icon = "../lib/silkicons/shape_align_middle.png";
        StringBuilder sb = new StringBuilder();
        if (ja.Count > 0)
        {
            for (int i = 0; i < ja.Count; i++)
            {
                try
                {
                    string id = "C" + ja[i]["id"].ToString();
                    JObject o = JObject.Parse(ja[i].ToString());
                    sb.AppendFormat("{{name:'{0}',no:'{1}',pId:'{2}',icon:'{3}',open:true, isParent:true}},"
                           , o["areaName"].ToString()
                           , id
                           , pid
                           , icon);

                    if (o["children"] != null)
                    {
                        JArray ja2 = JArray.Parse(o["deviceGroupByTypes"].ToString());
                        if (ja2.Count > 0)
                        {
                            string rebiao = get设备类型(ja2, id);
                            sb.Append(rebiao);
                        }

                    }


                }
                catch
                {
                }


            }
        }

        return sb.ToString();
    }


    /// <summary>
    /// "deviceTypeName":"避雷器",  EFGHI J  KM NO
    /// </summary>
    /// <param name="ja"></param>
    /// <returns></returns>
    private string get设备类型(JArray ja, string pid)
    {
        string strReturn = "";
        string icon = "../lib/silkicons/table_relationship.png";
        StringBuilder sb = new StringBuilder();
        if (ja.Count > 0)
        {
            for (int i = 0; i < ja.Count; i++)
            {
                try
                {
                    string id = "K" + (pid).ToString() + (i).ToString();
                    JObject o = JObject.Parse(ja[i].ToString());
                    sb.AppendFormat("{{name:'{0}',no:'{1}',pId:'{2}',icon:'{3}',open:true, isParent:true}},"
                           , o["deviceTypeName"].ToString()
                           , id
                           , pid
                           , icon);

                    if (o["devices"] != null)
                    {
                        JArray ja2 = JArray.Parse(o["devices"].ToString());
                        if (ja2.Count > 0)
                        {
                            string rebiao = ge热表信息(ja2, id);
                            sb.Append(rebiao);
                        }

                    }


                }
                catch
                {
                }


            }
        }

        return sb.ToString();
    }


    /// <summary>
    /// "deviceTypeName":"避雷器",   KM N 
    /// </summary>
    /// <param name="ja"></param>
    /// <returns></returns>
    private string ge热表信息(JArray ja, string pid)
    {
        string icon = "../lib/silkicons/pilcrow.png";
        StringBuilder sb = new StringBuilder();
        if (ja.Count > 0)
        {
            for (int i = 0; i < ja.Count; i++)
            {
                try
                {

                    JObject o = JObject.Parse(ja[i].ToString());
                    string id = "M" + o["id"].ToString();
                    sb.AppendFormat("{{name:'{0}',no:'{1}',pId:'{2}',icon:'{3}',open:true, isParent:true}},"
                           , o["deviceName"].ToString()
                           , id
                           , pid
                           , icon);

                    if (o["meters"] != null)
                    {
                        JArray ja2 = JArray.Parse(o["meters"].ToString());
                        if (ja2.Count > 0)
                        {
                            string dianwei = get点位信息(ja2, id);
                            sb.Append(dianwei);
                        }

                    }


                }
                catch
                {
                }


            }
        }

        return sb.ToString();
    }

    /// <summary>
    /// "deviceTypeName":"避雷器",   KM N 
    /// </summary>
    /// <param name="ja"></param>
    /// <returns></returns>
    private string get点位信息(JArray ja, string pid)
    {
        string icon = "../lib/silkicons/1_cb_cg.png";
        StringBuilder sb = new StringBuilder();
        if (ja.Count > 0)
        {
            for (int i = 0; i < ja.Count; i++)
            {
                try
                {
                    JObject o = JObject.Parse(ja[i].ToString());
                    sb.AppendFormat("{{name:'{0}',no:'{1}',pId:'{2}',icon:'{3}',open:true, isParent:false}},"
                           , o["meterName"].ToString()
                           , "N" + o["id"].ToString()
                           , pid
                           , icon);

                    //这里把点位的信息 保存到数组里面
                    MeterPropertyCls3 mpc = new MeterPropertyCls3();
                    mpc.meterId = "N" + o["id"].ToString();//点位id
                    mpc.meterName = o["meterName"].ToString();//点位名称
                    mpc.meterType = o["meterType"].ToString();//点位
                    mpc.detectionType = o["detectionType"].ToString();
                    l_MeterProperty.Add(mpc);

                }
                catch
                {
                }


            }
        }

        return sb.ToString();
    }

}
/// <summary>
/// 点位属性类
/// </summary>
class MeterPropertyCls3
{
    public string meterId
    {
        get;
        set;
    }
    public string meterName
    {
        get;
        set;
    }

    public string meterType
    {
        get;
        set;
    }
    //红外测温 表计读取
    public string detectionType
    {
        get;
        set;
    }
}