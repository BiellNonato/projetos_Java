<%@ page import="java.sql.*" %>
<%
  double preco1h = Double.parseDouble(request.getParameter("preco1h"));
  double precoExtra = Double.parseDouble(request.getParameter("precoExtra"));
  int totalVagas = Integer.parseInt(request.getParameter("totalVagas"));

  try {
    Class.forName("com.mysql.jdbc.Driver");
    Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/estacionamento", "root", "");

    Statement stmt = con.createStatement();
    stmt.executeUpdate("UPDATE configuracoes SET preco1h=" + preco1h + ", precoExtra=" + precoExtra + ", totalVagas=" + totalVagas);

    out.println("<script>alert('Configurações atualizadas!');location.href='configuracoes.html';</script>");
  } catch (Exception e) {
    out.println("Erro: " + e.getMessage());
  }
%>
