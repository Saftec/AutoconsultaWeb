<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Inicio.aspx.cs" Inherits="Inicio" %>
<%@ Register Assembly="Microsoft.ReportViewer.WebForms, Version=12.0.0.0, Culture=neutral, PublicKeyToken=89845dcd8080cc91" Namespace="Microsoft.Reporting.WebForms" TagPrefix="rsweb" %>
<%@ Import namespace="Microsoft.Reporting.WebForms" %>

<!DOCTYPE html>

<script runat="server">

    void Page_Load(object sender, EventArgs e)
    {
        //Cargo el evento del botón manualmente
        //EmptyReport();
        btnReport.Click += new EventHandler(this.btnReport_OnClick);
    }
    private void EmptyReport()
    {
        try
        {
            // Set the processing mode for the ReportViewer to Local
            reportViewer.ProcessingMode = ProcessingMode.Local;
            LocalReport localReport = reportViewer.LocalReport;

            // Cargo el reporte
            localReport.ReportPath = "Reporte/Report.rdlc";

            DataSetEmpty dataset = new DataSetEmpty();
            ReportTools rpt = new ReportTools();

            // Creo un DataSource vacío y se lo cargo al reporte //
            dataset = rpt.GetData(string.Empty, DateTime.Now, DateTime.Now);
            ReportDataSource dsRegis = new ReportDataSource();
            dsRegis.Name = "DataSetReporte";
            dsRegis.Value = dataset.Tables["DataSetReporte"];
            localReport.DataSources.Add(dsRegis);

            // Busco los parametros //
            ReportParameter rpRazonSocial = new ReportParameter();
            ReportParameter rpFechaDesde = new ReportParameter();
            ReportParameter rpFechaHasta = new ReportParameter();
            string rs = string.Empty;
            rs = rpt.GetRazonSocial();
            rpRazonSocial.Name = "RazonSocial";
            rpRazonSocial.Values.Add(rs);
            rpFechaDesde.Name = "FechaDesde";
            rpFechaDesde.Values.Add(DateTime.Now.ToString("dd/MM/yyyy"));
            rpFechaHasta.Name = "FechaHasta";
            rpFechaHasta.Values.Add(DateTime.Now.ToString("dd/MM/yyyy"));

            //Agrego los parametros//
            localReport.SetParameters(new ReportParameter[] { rpRazonSocial, rpFechaDesde, rpFechaHasta });
        }
        catch (AppException appex)
        {
            Session["Titulo"] = "Ha ocurrido un error en el servidor.";
            Session["Mensaje"] = appex.Message;
            Session["Exception"] = appex.Ex;
            Response.Redirect("Error.aspx");
        }
        catch (Exception ex)
        {
            Session["Titulo"] = "Ha ocurrido un error inesperado en el servidor.";
            Session["Mensaje"] = ex.Message;
            Session["Exception"] = ex;
            Response.Redirect("Error.aspx");
        }
    }
    void btnReport_OnClick(object sender, EventArgs e)
    {
        if (!Page.IsValid) //Ejecuta los field validators.
        {
            return;
        }
        DateTime fechaDesde=DateTime.MinValue, fechaHasta=DateTime.MinValue, parse;
        string legajo= string.Empty;

        try
        {
            // Recupero valores de los controles //
            legajo = Legajo.Text;
            legajo = legajo.PadLeft(5, '0');

            if(DateTime.TryParse(FecDesde.Text, out parse))
            {
                fechaDesde = parse;
            }else
            {
                throw new AppException("Error al intentar recuperar la fecha de inicio.");
            }

            if (DateTime.TryParse(FecHasta.Text, out parse))
            {
                fechaHasta = parse;
            }
            else
            {
                throw new AppException("Error al intentar recuperar la fecha de fin.");
            }
            ReportTools rpt = new ReportTools();
            if (!rpt.VerificarLegajo(legajo))
            {
                string mensaje = "No se encontró el legajo ingresado. Puede que no exista, esté dado de baja o no tenga registros.";
                ClientScript.RegisterStartupScript(this.GetType(), "myalert", "alert('" + mensaje + "');", true);
                return;
            }
        }
        catch(AppException appex)
        {
            Session["Titulo"] = "Ha ocurrido un error inesperado en el servidor.";
            Session["Mensaje"] = appex.Message;
            Session["Exception"] = appex.Ex;
            Response.Redirect("Error.aspx");
        }
        catch(Exception ex)
        {
            Logger.WriteFatal(ex.StackTrace);
            Session["Titulo"] = "Ha ocurrido un error inesperado en el servidor.";
            Session["Mensaje"] = ex.Message;
            Session["Exception"] = ex;
            Response.Redirect("Error.aspx");
        }

        // Guardo datos para reporte en la sesión //
        Session["Legajo"] = legajo;
        Session["FecDesde"] = fechaDesde;
        Session["FecHasta"] = fechaHasta;

        // Redirijo a página de reporte //
        Response.Redirect("Report.aspx");
    }
</script>

<link href="Style/Main.css" rel="stylesheet" type="text/css"/>
<!-- Bootstrap !-->
<!--<link href="Content/bootstrap.css" rel="stylesheet" type="text/css"/>!-->

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title>Autoconsulta Saftime</title>
</head>
<body>
<form id="form1" runat="server">
    <div id="div-menu" align="center">
            <table id="table-menu" align="center">
                <tr>
                    <td><asp:Label ID="lblFechaDesde" runat="server" CssClass="table-label">Fecha Desde:</asp:Label></td> 
                    <td><asp:TextBox ID="FecDesde" runat="server" TextMode="Date" CssClass="textbox"></asp:TextBox></td> 
                    <td><asp:Label ID="lblFechaHasta" runat="server" CssClass="table-label">Fecha Hasta:</asp:Label></td>
                    <td><asp:TextBox ID="FecHasta" runat="server" TextMode="Date" CssClass="textbox"></asp:TextBox></td>
                    <td><asp:Label ID="lblLegajo" runat="server" CssClass="table-label">Legajo:</asp:Label></td>
                    <td><asp:TextBox ID="Legajo" runat="server" TextMode="SingleLine" MaxLength="5" CssClass="textbox"></asp:TextBox></td>
                </tr>
                <tr>
                    <td><label></label></td>
                    <td><asp:RequiredFieldValidator ID="ValidatorFecDesde" runat="server" ErrorMessage="*Ingrese Fecha"
                    ControlToValidate="FecDesde" ForeColor="Red" Display="Dynamic" ValidationGroup="ReportDataGroup"></asp:RequiredFieldValidator></td>
                    <td><label></label></td>
                    <td><asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" ErrorMessage="*Ingrese Fecha"
                        ControlToValidate="FecDesde" ForeColor="Red" Display="Dynamic" ValidationGroup="ReportDataGroup"></asp:RequiredFieldValidator></td>
                    <td><label></label></td>
                    <td><asp:RequiredFieldValidator ID="RequiredFieldValidator2" runat="server" ErrorMessage="*Ingrese Legajo"
                        ControlToValidate="FecDesde" ForeColor="Red" Display="Dynamic" ValidationGroup="ReportDataGroup"></asp:RequiredFieldValidator></td>
                </tr>
            </table>   
            <asp:Button ID="btnReport" ValidationGroup="ReportDataGroup" runat="server" Text="Generar Reporte" OnClick="btnReport_OnClick" 
                CssClass="button" />
        </div>
    <div align="center" id="report-container">
        <asp:ScriptManager ID="ScriptManager1" runat="server"></asp:ScriptManager>
        <rsweb:ReportViewer ID="reportViewer" runat="server" Width="21cm" Height="29.7cm"></rsweb:ReportViewer>
    </div>
    </form>
<!--    <script>
        src="Scripts/jquery-1.10.2.min.js"
    </script>
    <script>
        src="Scripts/bootstrap.min.js"
    </script> !-->
</body>
</html>
