using log4net;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

/// <summary>
/// Descripción breve de Logger
/// </summary>
public class Logger
{
    private static ILog log = log4net.LogManager.GetLogger("");

    public static void WriteError(string message)
    {
        log.Error(message);
    }

    public static void WriteInfo(string message)
    {
        log.Info(message);
    }

    public static void WriteFatal(string message)
    {
        log.Fatal(message);
    }
}