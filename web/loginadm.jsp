<%@ page import="java.sql.*" %>
<%@ page session="true" %>
<%
    String mensagem = "";
    if ("POST".equalsIgnoreCase(request.getMethod())) {
        String usuario = request.getParameter("usuario");
        String senha = request.getParameter("senha");

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/estacionamento", "root", "");
            PreparedStatement ps = con.prepareStatement("SELECT * FROM usuarios WHERE usuario = ? AND senha = ?");
            ps.setString(1, usuario);
            ps.setString(2, senha);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                String tipo = rs.getString("tipo");
                session.setAttribute("usuario", usuario);
                session.setAttribute("tipo", tipo);

                if ("admin".equals(tipo)) {
                    response.sendRedirect("home_adm.html");
                } else {
                    response.sendRedirect("home_operador.html");
                }
                return;
            } else {
                mensagem = "Usuário ou senha incorretos.";
            }
        } catch (Exception e) {
            mensagem = "Erro de conexão com o banco.";
        }
    }
%>
