using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Net;
using System.Threading;
using System.Security.Cryptography.X509Certificates;
using System.IO;
using System.Drawing;
using System.Net.Security;

public class HttpHeader_new
{
    //剩余的属性
    public List<string> l_strp { get; set; }

}

public class HTMLHelper_new
{

    /// <summary>
    /// 获取html
    /// </summary>
    /// <param name="getUrl"></param>
    /// <param name="cookieContainer"></param>
    /// <param name="header"></param>
    /// <returns></returns>
    public static string GetHtml(string getUrl, HttpHeader_new header, CookieContainer cookieContainer)
    {
        Thread.Sleep(100);
        HttpWebRequest httpWebRequest = null;
        HttpWebResponse httpWebResponse = null;
        try
        {


            httpWebRequest = (HttpWebRequest)HttpWebRequest.Create(getUrl);
            httpWebRequest.CookieContainer = cookieContainer;

            if (header != null) {
                List<string> h_list = header.l_strp;
                if (h_list != null)
                {
                    if (h_list.Count > 0)
                    {
                        for (int i = 0; i < h_list.Count; i++)
                        {
                            httpWebRequest = setHeader(httpWebRequest, h_list[i]);
                        }
                    }
                }
            }
            

            httpWebRequest.Referer = getUrl;
            httpWebRequest.Timeout = 5000;//默认是30秒
            httpWebRequest.Method = "GET";
            httpWebResponse = (HttpWebResponse)httpWebRequest.GetResponse();
            Stream responseStream = httpWebResponse.GetResponseStream();
            StreamReader streamReader = new StreamReader(responseStream, Encoding.UTF8);
            string html = streamReader.ReadToEnd();
            streamReader.Close();
            responseStream.Close();
            httpWebRequest.Abort();
            httpWebResponse.Close();
            return html;
        }
        catch (Exception e)
        {
            if (httpWebRequest != null) httpWebRequest.Abort();
            if (httpWebResponse != null) httpWebResponse.Close();
            return string.Empty;
        }
    }
    /// <summary>
    /// 通过post方法获取到值
    /// </summary>
    /// <param name="loginUrl"></param>
    /// <param name="postdata"></param>
    /// <param name="header"></param>
    /// <returns></returns>
    public static string GetHtml_Post(string Url, string postdata, HttpHeader_new header, CookieContainer cs)
    {

        HttpWebRequest request = null;
        HttpWebResponse response = null;
        try
        {
            request = (HttpWebRequest)WebRequest.Create(Url);
            if (header != null) {
                List<string> h_list = header.l_strp;
                if (h_list != null)
                {
                    if (h_list.Count > 0)
                    {
                        for (int i = 0; i < h_list.Count; i++)
                        {
                            request = setHeader(request, h_list[i]);
                        }
                    }
                }
            }
            
            request.ServicePoint.Expect100Continue = false;
            request.AllowAutoRedirect = false;
            request.CookieContainer = cs;
            request.Timeout = 5000;//默认是15秒
            request.Method = "POST";
            byte[] postdatabyte = Encoding.UTF8.GetBytes(postdata);

            //////加上证书认证
            //ServicePointManager.CertificatePolicy = new AcceptAllCertificatePolicy();
            //提交请求
            Stream stream;
            stream = request.GetRequestStream();
            stream.Write(postdatabyte, 0, postdatabyte.Length);
            stream.Close();

            //接收响应
            response = (HttpWebResponse)request.GetResponse();
            response.Cookies = request.CookieContainer.GetCookies(request.RequestUri);
            //cs.Add(response.Cookies);

            Stream responseStream = response.GetResponseStream();
            StreamReader streamReader = new StreamReader(responseStream, Encoding.UTF8);
            string html = streamReader.ReadToEnd();

            return html;
        }
        catch (Exception ex)
        {

            return ex.Message;
        }
    }

    /// <summary>
    /// 通过Put方法获取到值
    /// </summary>
    /// <param name="loginUrl"></param>
    /// <param name="postdata"></param>
    /// <param name="header"></param>
    /// <returns></returns>
    public static string GetHtml_Put(string Url, string postdata, HttpHeader_new header, CookieContainer cs)
    {

        HttpWebRequest request = null;
        HttpWebResponse response = null;
        try
        {
            request = (HttpWebRequest)WebRequest.Create(Url);
            if (header != null)
            {
                List<string> h_list = header.l_strp;
                if (h_list != null)
                {
                    if (h_list.Count > 0)
                    {
                        for (int i = 0; i < h_list.Count; i++)
                        {
                            request = setHeader(request, h_list[i]);
                        }
                    }
                }
            }

            request.ServicePoint.Expect100Continue = false;
            request.AllowAutoRedirect = false;
            request.CookieContainer = cs;
            request.Timeout = 5000;//默认是15秒
            request.Method = "PUT";
            byte[] postdatabyte = Encoding.UTF8.GetBytes(postdata);

            //////加上证书认证
            //ServicePointManager.CertificatePolicy = new AcceptAllCertificatePolicy();
            //提交请求
            Stream stream;
            stream = request.GetRequestStream();
            stream.Write(postdatabyte, 0, postdatabyte.Length);
            stream.Close();

            //接收响应
            response = (HttpWebResponse)request.GetResponse();
            response.Cookies = request.CookieContainer.GetCookies(request.RequestUri);
            //cs.Add(response.Cookies);

            Stream responseStream = response.GetResponseStream();
            StreamReader streamReader = new StreamReader(responseStream, Encoding.UTF8);
            string html = streamReader.ReadToEnd();

            return html;
        }
        catch (Exception ex)
        {

            return ex.Message;
        }
    }

    /// <summary>
    /// 通过del方法获取到值
    /// </summary>
    /// <param name="loginUrl"></param>
    /// <param name="postdata"></param>
    /// <param name="header"></param>
    /// <returns></returns>
    /// <summary>
    /// 获取html
    /// </summary>
    /// <param name="getUrl"></param>
    /// <param name="cookieContainer"></param>
    /// <param name="header"></param>
    /// <returns></returns>
    public static string GetHtml_DELETE(string getUrl, HttpHeader_new header, CookieContainer cookieContainer)
    {
        Thread.Sleep(100);
        HttpWebRequest httpWebRequest = null;
        HttpWebResponse httpWebResponse = null;
        try
        {


            httpWebRequest = (HttpWebRequest)HttpWebRequest.Create(getUrl);
            httpWebRequest.CookieContainer = cookieContainer;

            if (header != null)
            {
                List<string> h_list = header.l_strp;
                if (h_list != null)
                {
                    if (h_list.Count > 0)
                    {
                        for (int i = 0; i < h_list.Count; i++)
                        {
                            httpWebRequest = setHeader(httpWebRequest, h_list[i]);
                        }
                    }
                }
            }


            httpWebRequest.Referer = getUrl;
            httpWebRequest.Timeout = 5000;//默认是30秒
            httpWebRequest.Method = "DELETE";
            httpWebResponse = (HttpWebResponse)httpWebRequest.GetResponse();
            Stream responseStream = httpWebResponse.GetResponseStream();
            StreamReader streamReader = new StreamReader(responseStream, Encoding.UTF8);
            string html = streamReader.ReadToEnd();
            streamReader.Close();
            responseStream.Close();
            httpWebRequest.Abort();
            httpWebResponse.Close();
            return html;
        }
        catch (Exception e)
        {
            if (httpWebRequest != null) httpWebRequest.Abort();
            if (httpWebResponse != null) httpWebResponse.Close();
            return string.Empty;
        }
    }



    private bool ValidateServerCertificate(object sender, X509Certificate certificate, X509Chain chain, SslPolicyErrors sslPolicyErrors)
    {
        return true;
    }

    /*
     Accept	由 Accept 属性设置。
Connection	由 Connection 属性和 KeepAlive 属性设置。
Content-Length	由 ContentLength 属性设置。
Content-Type	由 ContentType 属性设置。
Expect	由 Expect 属性设置。
Date	由系统设置为当前日期。
Host	由系统设置为当前主机信息。
If-Modified-Since	由 IfModifiedSince 属性设置。
Range	由 AddRange 方法设置。
Referer	由 Referer 属性设置。
Transfer-Encoding	由 TransferEncoding 属性设置（SendChunked 属性必须为 true）。
User-Agent	由 UserAgent 属性设置。
     */
    public static HttpWebRequest setHeader(HttpWebRequest header, string strProperty)
    {
        if (strProperty != "")
        {
            int iIndex = strProperty.IndexOf(':');
            string headerParm = strProperty.Substring(0, iIndex);
            string parmValue = strProperty.Substring(iIndex + 1, strProperty.Length - iIndex - 1);
            #region
            if (headerParm == "Accept")
            {
                header.Accept = parmValue;
            }
            else if (headerParm == "Method")
            {
                header.Method = parmValue;
            }
            else if (headerParm == "Connection" || headerParm == "Proxy-Connection")
            {
                if (parmValue == "keep-alive")
                {
                    header.KeepAlive = true;
                }
                else
                {
                    header.KeepAlive = false;
                }

            }
            else if (headerParm == "Content-Length")
            {
                header.ContentLength = long.Parse(parmValue);
            }
            else if (headerParm == "Content-Type")
            {
                header.ContentType = parmValue;
            }
            else if (headerParm == "Expect")
            {
                header.Expect = parmValue;
            }
            else if (headerParm == "Date")
            {
                header.Date = DateTime.Parse(parmValue);
            }
            else if (headerParm == "Host")
            {
                header.Host = parmValue;
            }
            else if (headerParm == "If-Modified-Since")
            {
                header.IfModifiedSince = DateTime.Parse(parmValue);
            }
            else if (headerParm == "Range")
            {
                header.AddRange(int.Parse(parmValue));
            }
            else if (headerParm == "Referer")
            {
                header.Referer = parmValue;
            }
            else if (headerParm == "User-Agent")
            {
                header.UserAgent = parmValue;
            }
            else
            {
                header.Headers.Add(strProperty);
            }
            #endregion
        }
        return header;
    }

}
