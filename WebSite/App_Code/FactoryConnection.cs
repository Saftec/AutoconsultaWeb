using System;
using System.Data;
using System.Data.SqlClient;
using System.Web.Configuration;

/// <summary>
/// Descripción breve de FactoryConnection
/// </summary>
public class FactoryConnection
{
    private static FactoryConnection _instancia;

    public static FactoryConnection Instancia
    {
        get
        {
            if (_instancia == null)
            {
                _instancia = new FactoryConnection();
            }
            return _instancia;
        }
    }

    private SqlConnection conn;
    private int cantConn;

    private FactoryConnection()
    {
        cantConn = 0;
        conn = new SqlConnection();
    }

    public SqlConnection GetConn()
    {
        try
        {
            if (conn == null || conn.State == ConnectionState.Closed)
            {
                conn.ConnectionString = WebConfigurationManager.ConnectionStrings["SaftimeDB"].ConnectionString;
                conn.Open();
                cantConn++;
            }
        }
        catch(SqlException sqlex)
        {
            throw new AppException("Se produjo un error al intentar conectar a la base de datos.", "Error", sqlex);
        }
        catch (Exception ex)
        {
            throw new AppException("Ocurrió un error no controlado al intentar conectar a la base de datos.", "Fatal", ex);
        }
        return conn;
    }

    public void ReleaseConn()
    {
        try
        {
            cantConn--;
            if (cantConn == 0)
            {
                conn.Close();
            }
        }
        catch(SqlException sqlex)
        {
            throw new AppException("Error al intentar cerrar la conexión a la base de datos.", "Error", sqlex);
        }
        catch (Exception ex)
        {
            throw new AppException("Error no controlado al intentar cerrar la conexión a la base de datos.", "Fatal", ex);
        }
    }
}