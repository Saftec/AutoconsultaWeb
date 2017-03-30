<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Error.aspx.cs" Inherits="Error" %>

<!DOCTYPE html>

<link href="Style/Error.css" rel="stylesheet" type="text/css"/>
<link href="Content/bootstrap.css" rel="stylesheet" type="text/css" />
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title>Error</title>
</head>
<body>
    <form id="form1" runat="server">
     <div class="image-container">
     </div>
    <div>
        <asp:Label ID="Title" runat="server" CssClass="text-danger"></asp:Label><br />
        <asp:Label ID="Description" runat="server" CssClass="text-info"></asp:Label>       
    </div>
    <div>
        <h3>Más Información</h3>
        <asp:Label ID="Detalle" runat="server" CssClass="detalle"></asp:Label>
    </div>
    </form>
</body>
</html>
