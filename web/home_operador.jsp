<%@ page session="true" %>
<%
    String usuario = (String) session.getAttribute("usuario");
    String tipo = (String) session.getAttribute("tipo");

    if (usuario == null || !"operador".equals(tipo)) {
        response.sendRedirect("login.jsp");
        return;
    }
%>
