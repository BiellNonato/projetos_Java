<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html lang="pt">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Estacionamento - Vagas</title>
    <link rel="stylesheet" href="style.css">
    <style>
        /* aqui fizemos a "Estilização da tabela" */
        table {
            border-collapse: collapse;
            width: 100%;
            margin-top: 20px;
        }
        th, td {
            border: 1px solid #ddd;
            padding: 8px;
            text-align: center;
        }
        th {
            background-color: #f2f2f2;
        }
        /* Cores para os status */
        .livre {
            background-color: #a8e6cf;  /* Verde claro */
        }
        .ocupada {
            background-color: #ff8b94;  /* Vermelho claro */
        }
    </style>
</head>
<body>


    <h2>Vagas do Estacionamento</h2>
    <%
    
    /*aqui definimos as variaveis*/
        int vagasLivres = 0;
        int vagasOcupadas = 0;
    %>

    <table>
        <thead>
            <tr>
                <th>Número da Vaga</th>
                <th>Status</th>
                <th>Placa</th>
            </tr>
        </thead>
        <tbody>
            <%
                try {
                    Class.forName("com.mysql.cj.jdbc.Driver");
                    Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/estacionamento", "root", "");

                    // Consulta que pega os dados das vagas ordenados pelo número
                    PreparedStatement ps = con.prepareStatement("SELECT id_vagas, numero_vaga, placa, STATUS FROM vagas ORDER BY numero_vaga ASC");
                    ResultSet rs = ps.executeQuery();

                    while (rs.next()) {
                        int idVaga = rs.getInt("id_vagas");
                        int numero = rs.getInt("numero_vaga");
                        String status = rs.getString("STATUS");
                        String placa = rs.getString("placa");
                        String classe = status.equalsIgnoreCase("Livre") ? "livre" : "ocupada";

                        if (status.equalsIgnoreCase("Livre")) {
                            vagasLivres++;
                        } else {
                            vagasOcupadas++;
                        }
            %>
            <tr class="<%= classe %>">
                <td><%= numero %></td>
                <td><%= status %></td>
                <td><%= (placa == null || placa.isEmpty()) ? "-" : placa %></td>
            </tr>
            <%
                    }
                    rs.close();
                    ps.close();
                } catch(Exception e) {
            %>
            <tr>
                <td colspan="3">Erro ao acessar o banco de dados: <%= e.getMessage() %></td>
            </tr>
            <%
                    e.printStackTrace();
                }
            %>
        </tbody>
    </table>

    <p>Total de vagas livres: <%= vagasLivres %></p>
    <p>Total de vagas ocupadas: <%= vagasOcupadas %></p>

    <!-- Adicionando a lista de vagas disponíveis para uso no formulário -->
    <label for="vaga">Selecione uma vaga disponível:</label>
    <select id="vaga" name="vaga" required>
        <option value="" disabled selected>Escolha uma vaga</option>
        <%
            try {
                Class.forName("com.mysql.cj.jdbc.Driver");
                Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/estacionamento", "root", "");
                PreparedStatement vagasLivresPs = con.prepareStatement("SELECT id_vagas, numero_vaga FROM vagas WHERE STATUS = 'Livre' ORDER BY numero_vaga ASC");
                ResultSet rsVagas = vagasLivresPs.executeQuery();

                while (rsVagas.next()) {
        %>
                <option value="<%= rsVagas.getInt("id_vagas") %>">Vaga <%= rsVagas.getInt("numero_vaga") %></option>
        <%
                }
                rsVagas.close();
                vagasLivresPs.close();
                con.close();
            } catch(Exception e) {
        %>
                <option disabled>Erro ao carregar vagas disponíveis</option>
        <%
                e.printStackTrace();
            }
        %>
    </select>

</body>
</html>
