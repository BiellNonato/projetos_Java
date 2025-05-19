<%@ page import="java.sql.*, java.time.*" %>
<html>
    <head>
        <title>Registro de Entrada</title>
    </head>
    <body>

        <%
            String placa = request.getParameter("placa");
            String numero_vaga = request.getParameter("vagas");
            String mensagem = "";

            boolean placaValida = placa != null && placa.matches("^[A-Z]{3}\\d{1}[A-Z0-9]{1}\\d{2}$");

            if (placaValida && numero_vaga != null && !numero_vaga.isEmpty()) {
                try {
                    Class.forName("com.mysql.cj.jdbc.Driver");
                    Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/estacionamento", "root", "");

                    // Verifica vagas ocupadas no sistema
                    PreparedStatement vagaCheck = con.prepareStatement("SELECT COUNT(*) FROM veiculos WHERE saida IS NULL");
                    ResultSet rs = vagaCheck.executeQuery();
                    rs.next();
                    int ocupadas = rs.getInt(1);

                    if (ocupadas < 30) {
                        // Verifica se a vaga está livre
                        PreparedStatement verificaVaga = con.prepareStatement("SELECT STATUS FROM vagas WHERE numero_vaga = ?");
                        verificaVaga.setInt(1, Integer.parseInt(numero_vaga));
                        ResultSet rsVaga = verificaVaga.executeQuery();

                        if (rsVaga.next() && "Livre".equalsIgnoreCase(rsVaga.getString("STATUS"))) {
                            // Registra o veículo e atualiza a vaga como ocupada
                            PreparedStatement ps = con.prepareStatement("INSERT INTO veiculos (placa, entrada) VALUES (?, NOW())");
                            ps.setString(1, placa.toUpperCase());
                            ps.executeUpdate();

                            PreparedStatement atualizarVaga = con.prepareStatement("UPDATE vagas SET placa = ?, STATUS = 'Ocupada' WHERE numero_vaga = ?");
                            atualizarVaga.setString(1, placa.toUpperCase());
                            atualizarVaga.setInt(2, Integer.parseInt(numero_vaga));
                            atualizarVaga.executeUpdate();

                            mensagem = "<p>Entrada registrada com sucesso na vaga " + numero_vaga + "!</p>";
                        } else {
                            mensagem = "<p>Erro: A vaga já está ocupada!</p>";
                        }

                        // Fechando conexões
                        rsVaga.close();
                        verificaVaga.close();
                    } else {
                        mensagem = "<p>Estacionamento Lotado!</p>";
                    }

                    rs.close();
                    vagaCheck.close();
                    con.close();

                } catch (Exception e) {
                    mensagem = "<p>Erro ao acessar o banco de dados.</p>";
                    e.printStackTrace();
                }
            } else {
                mensagem = "<p>Placa ou vaga inválida! Verifique os dados.</p>";
            }
        %>

        <%= mensagem %>

    </body>
</html>
