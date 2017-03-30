using System;

public partial class Error : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        string titulo = string.Empty;
        string mensaje = string.Empty;
        string detalle = string.Empty;
        Exception ex = null;

        titulo = Session["Titulo"].ToString();
        mensaje = Session["Mensaje"].ToString();
        ex = (Exception)Session["Exception"];
        if (ex != null)
        {
            detalle = "Mensaje: " + ex.Message + "\n Origen: " + ex.StackTrace;
        }
        else
        {
            detalle = "No se pudo recuperar los detalles del error.";
        }
        

        Title.Text = titulo;
        Description.Text = mensaje;
        Detalle.Text = detalle;
    }
}