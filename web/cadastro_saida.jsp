<%@ page import="java.sql.*, java.time.*, java.time.temporal.ChronoUnit" %>

<%
    String usuarioLogado = (String) session.getAttribute("usuario");

    if (usuarioLogado == null) {
        response.sendRedirect("index.html");
        return;
    }

    String placa = request.getParameter("placa");
    String dataSaidaStr = request.getParameter("dataSaida");
    String mensagem = "";

    if (placa != null && !placa.trim().isEmpty() && dataSaidaStr != null && !dataSaidaStr.trim().isEmpty()) {
        placa = placa.trim().toUpperCase();
        LocalDateTime saidaTime = LocalDateTime.parse(dataSaidaStr); // Converte a string para LocalDateTime
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection conecta = DriverManager.getConnection("jdbc:mysql://localhost:3306/estacionamento", "root", "");

           
            PreparedStatement ps = conecta.prepareStatement("SELECT id, entrada FROM veiculos WHERE placa = ? AND saida IS NULL ORDER BY entrada DESC LIMIT 1");
            ps.setString(1, placa);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                int id = rs.getInt("id");
                Timestamp entradaTS = rs.getTimestamp("entrada");
                LocalDateTime entradaTime = entradaTS.toLocalDateTime();

              
                long minutos = ChronoUnit.MINUTES.between(entradaTime, saidaTime);
                 double valor = 0.0;

                if (minutos <= 60) {
                    valor = 25.0;
                } 
                else {
                valor = 25.0; // valor base da 1ª hora
               long minutosExcedentes = minutos - 60;
               long horasAdicionais = (long) Math.ceil(minutosExcedentes / 60.0);
                 valor += horasAdicionais * 9.0;
               }
            
                PreparedStatement update = conecta.prepareStatement("UPDATE veiculos SET saida = ?, valor_pago = ? WHERE id = ?");
                update.setTimestamp(1, Timestamp.valueOf(saidaTime));
                update.setDouble(2, valor);
                update.setInt(3, id);
                int linhasAtualizadas = update.executeUpdate();
                update.close();

                if (linhasAtualizadas > 0) {
                 double horas = minutos / 60.0;
                mensagem = "Saída registrada com sucesso.<br>Tempo: " + String.format("%.2f", horas) + " hora(s)<br>Valor: R$ " + String.format("%.2f", valor);
                } else {
                    mensagem = "Erro ao atualizar saída.";
                }

            } else {
                mensagem = "Veículo não encontrado ou já saiu.";
            }

            rs.close();
            ps.close();
            conecta.close();
        } catch (Exception e) {
            mensagem = "Erro no banco: " + e.getMessage();
            e.printStackTrace();
        }
    } else {
        mensagem = "Erro: Placa ou data de saída inválida.";
    }
%>

<%= mensagem %>
