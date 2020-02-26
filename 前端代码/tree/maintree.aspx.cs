using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Text;
using System.Data;

public partial class tree_maintree : System.Web.UI.Page
{
    public StringBuilder seriesDataMenu = new StringBuilder();
    protected void Page_Load(object sender, EventArgs e)
    {

        int iTreeLevel = int.Parse(PublicMethod.public_getConfigStr("treeShowLevel"));

        string sql = "";
        SQLHelper sh = new SQLHelper();
        string icon = "../lib/silkicons/1_Equip_jzq.png";
        string icon2 = "../lib/silkicons/medal_gold_1.png";
        string icon3 = "../lib/silkicons/picture_add.png";
        seriesDataMenu.Append("[");


        seriesDataMenu.AppendFormat("{{name:'{0}',no:'{1}',icon:'{2}',pId:'0',open:true}},", "地区名称", "A1", icon);

        seriesDataMenu.AppendFormat("{{name:'{0}',no:'B1',icon:'{2}',pId:'A1',open:true}},", "山东省", "1", icon2);
        seriesDataMenu.AppendFormat("{{name:'{0}',no:'B2',icon:'{2}',pId:'A1',open:true}},", "山西省", "1", icon2);

        seriesDataMenu.AppendFormat("{{name:'{0}',no:'C1',icon:'{2}',pId:'B1',open:true}},", "设备1", "1", icon3);
        seriesDataMenu.AppendFormat("{{name:'{0}',no:'C2',icon:'{2}',pId:'B2',open:true}},", "设备2", "1", icon3);





        seriesDataMenu.Append("]");
    }
}