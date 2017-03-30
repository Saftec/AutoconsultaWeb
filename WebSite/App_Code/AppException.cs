using System;

/// <summary>
/// Descripción breve de AppException
/// </summary>
public class AppException:Exception
{
    private Exception _ex;

    public Exception Ex
    {
        get { return _ex; }
    }
    public AppException(string message): base(message)
    {     
    }

    public AppException() : base() { }

    public AppException(string message, string level, Exception ex) : base(message, ex)
    {
        ExType type = (ExType)Enum.Parse(typeof(ExType), level);
        switch (type)
        {
            case ExType.Error:
                Logger.WriteError("MESSAGE: " + ex.Message + "\n STACK TRACE: " + ex.StackTrace);
                break;
            case ExType.Fatal:
                Logger.WriteFatal(ex.Message + "\n STACK TRACE: " + ex.StackTrace);
                break;
        }
        _ex = ex;
    }

    private enum ExType
    {
        Error,
        Fatal
    }
}