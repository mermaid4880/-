using System;
using System.Text;
using System.IO;
using System.Security.Cryptography;
using System.Collections.Generic;

/// <summary>
///DES加解密
/// </summary>
public static class DES_En_De
{
    //密钥
    //private static string key = "Deer" + DateTime.Now.ToString("yyyy-MM-dd") + "163218168";//Deer20140516163218168
    private static string key = "Deer20180319";//Deer20140516163218168

    #region 对称加密解密的密钥
    /// <summary>
    /// 对称加密解密的密钥
    /// </summary>
    public static string Key
    {
        get
        {
            return key;
        }
        set
        {
            key = value;
        }
    }
    #endregion

    #region DES加密
    /// <summary>
    /// DES加密
    /// </summary>
    /// <param name="encryptString"></param>
    /// <returns></returns>
    public static string DesEncrypt(string encryptString)
    {
        if (PublicMethod.public_getConfigStr("OpenEncrypt") == "1")
        {
        }
        else
        { 
        }

        byte[] keyBytes = Encoding.UTF8.GetBytes(key.Substring(0, 8));
        byte[] keyIV = keyBytes;
        byte[] inputByteArray = Encoding.UTF8.GetBytes(encryptString);
        DESCryptoServiceProvider provider = new DESCryptoServiceProvider();
        MemoryStream mStream = new MemoryStream();
        CryptoStream cStream = new CryptoStream(mStream, provider.CreateEncryptor(keyBytes, keyIV), CryptoStreamMode.Write);
        cStream.Write(inputByteArray, 0, inputByteArray.Length);
        cStream.FlushFinalBlock();
        return Convert.ToBase64String(mStream.ToArray());
    }
    #endregion

    #region DES解密
    /// <summary>
    /// DES解密
    /// </summary>
    /// <param name="decryptString"></param>
    /// <returns></returns>
    public static string DesDecrypt(string decryptString)
    {
        decryptString = decryptString.Replace(" ", "+");//通过地址栏会把 +号换成 空格，这里替换回来 %3d
        decryptString = decryptString.Replace("%2b", "+");
        decryptString = decryptString.Replace("%3d", "=");

        byte[] keyBytes = Encoding.UTF8.GetBytes(key.Substring(0, 8));
        byte[] keyIV = keyBytes;
        byte[] inputByteArray = Convert.FromBase64String(decryptString);
        DESCryptoServiceProvider provider = new DESCryptoServiceProvider();
        MemoryStream mStream = new MemoryStream();
        CryptoStream cStream = new CryptoStream(mStream, provider.CreateDecryptor(keyBytes, keyIV), CryptoStreamMode.Write);
        cStream.Write(inputByteArray, 0, inputByteArray.Length);
        cStream.FlushFinalBlock();
        return Encoding.UTF8.GetString(mStream.ToArray());
    }
    #endregion

    #region MD5--32位加密
    /// MD5--32位加密
    /// </summary>
    /// <param name="str"></param>
    /// <returns></returns>
    public static string UserMd5(string str)
    {
        string cl = str;
        string pwd = "";
        MD5 md5 = MD5.Create();//实例化一个md5对像
        // 加密后是一个字节类型的数组，这里要注意编码UTF8/Unicode等的选择　
        byte[] s = md5.ComputeHash(Encoding.UTF8.GetBytes(cl));
        // 通过使用循环，将字节类型的数组转换为字符串，此字符串是常规字符格式化所得
        for (int i = 0; i < s.Length; i++)
        {
            // 将得到的字符串使用十六进制类型格式。格式后的字符是小写的字母，如果使用大写（X）则格式后的字符是大写字符
            pwd = pwd + s[i].ToString("X");
        }
        return pwd;
    }
    #endregion



}