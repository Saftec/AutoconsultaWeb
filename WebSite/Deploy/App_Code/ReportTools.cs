using System;
using System.Data.SqlClient;

/// <summary>
/// Descripción breve de ReportTools
/// </summary>
public class ReportTools
{

    public DataSetEmpty GetData(string legajo, DateTime fecDesde, DateTime fecHasta)
    {
        DataSetEmpty ds = new DataSetEmpty();
        SqlDataAdapter da = null;
        string query = "SELECT legajo, ent, sal, comentario, modo, modoSal, nombre, nombres, apellido, tarjeta FROM Vi_WebReport WHERE legajo='" + legajo + "' AND (ent BETWEEN '"+ fecDesde.ToString("dd/MM/yyyy") + " 00:00" + "' AND '"+ fecHasta.ToString("dd/MM/yyyy") + " 23:59" + "');";

        try
        {
            da = new SqlDataAdapter(query, FactoryConnection.Instancia.GetConn());
            da.Fill(ds, "DataSetReporte");
        }
        catch(AppException appex)
        {
            throw appex;
        }
        catch (SqlException sqlex)
        {
            throw new AppException("Se produjo un error al consultar los datos a la base de datos.", "Error", sqlex);
        }
        catch (Exception ex)
        { 
            throw new AppException("Ocurrió un error no controlado al intentar obtener los datos.", "Fatal", ex);
        }
        finally
        {
            try
            {
                if (da != null)
                {
                    da.Dispose();
                }
                FactoryConnection.Instancia.ReleaseConn();
            }
            catch(AppException appex)
            {
                throw appex;
            }
            catch (Exception ex)
            {
                throw new AppException("Ocurrió un error no controlado al intentar cerrar la conexión.", "Fatal", ex);
            }
        }
        return ds;
    }

    public string GetRazonSocial()
    {
        string rs = string.Empty;
        string query = "SELECT valorCorr FROM Config WHERE ConfigId=8;";
        SqlCommand cmd = null;
        SqlDataReader dr = null;
        try
        {
            cmd = new SqlCommand(query, FactoryConnection.Instancia.GetConn());
            dr = cmd.ExecuteReader();
            if (dr.Read())
            {
                rs=dr.GetString(0);
            }
        }
        catch(AppException appex)
        {
            throw appex;
        }
        catch(SqlException sqlex)
        {
            throw new AppException("Se produjo un error al consultar la razón social de la base de datos.", "Error", sqlex);
        }
        catch(Exception ex)
        {
            throw new AppException("Se produjo un error no controlado al intentar obtener la razón social", "Fatal", ex);
        }
        finally
        {
            try
            {
                if (dr != null)
                {
                    dr.Close();
                }
                if (cmd != null)
                {
                    cmd.Dispose();
                }
                FactoryConnection.Instancia.ReleaseConn();
            }
            catch(AppException appex)
            {
                throw appex;
            }
            catch(Exception ex)
            {
                throw new AppException("Ocurrió un error no controlado al intentar cerrar la conexión.", "Fatal", ex);
            }
        }
        return rs;
    }

    public bool VerificarLegajo(string legajo)
    {
        SqlDataReader dr = null;
        SqlCommand cmd = null;
        bool result = false;
        string query = "SELECT TOP 1 legajo FROM Vi_WebReport WHERE legajo='" + legajo + "';";
        try
        {
            cmd = new SqlCommand(query, FactoryConnection.Instancia.GetConn());
            dr = cmd.ExecuteReader();
            if (dr.Read())
            {
                result = true;
            }
        }
        catch(AppException appex)
        {
            throw appex;
        }
        catch (SqlException sqlex)
        {
            throw new AppException("Se produjo un error al intentar consultar datos del legajo", "Error", sqlex);
        }
        catch (Exception ex)
        {
            throw new AppException("Ocurrió un error al consultar los datos del legajo.", "Fatal", ex);
        }
        finally
        {
            try
            {
                if (dr != null)
                {
                    dr.Close();
                }
                if (cmd != null)
                {
                    cmd.Dispose();
                }
                FactoryConnection.Instancia.ReleaseConn();
            }
            catch (Exception ex)
            {
                throw new AppException("Ocurrió un error inesperado al intentar cerrar la conexión.", "Fatal", ex);
            }
        }
        return result;
    }
}