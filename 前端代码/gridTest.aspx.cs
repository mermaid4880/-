using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class gridTest : System.Web.UI.Page
{
    public string public_token = "";
    protected void Page_Load(object sender, EventArgs e)
    {
        public_token = "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiI2MTMiLCJleHAiOjE1Mzk4MzMyMTQsInVzZXIiOiJ7XCJ1c2VySWRcIjpcIjIwNTJjZDE4ZmI0NTRlOWRhNTBiNjkxMjkzOTU4ZmZmXCIsXCJuYW1lXCI6XCJtb1wiLFwiYWNjZXNzSWRzXCI6XCIxLDIsM1wifSJ9.dVINwI2Z9JNH3OU3aCrUdxhKcJtouAuWF8vwn9SQFTE";
    }
}