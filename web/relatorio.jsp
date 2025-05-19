<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html lang="pt">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Histórico de Veículos</title>
    <style>
        /* Estilização da tabela */
        table {
            border-collapse: collapse;
            width: 100%;
            margin-top: 20px;
            font-family: Arial, sans-serif;
        }

        /* Cabeçalho da tabela */
        th {
            background-color: #007BFF;
            color: white;
            padding: 12px;
            text-align: left;
        }

        /* Linhas alternadas */
        tr:nth-child(even) {
            background-color: #f2f2f2;
        }

        /* Células da tabela */
        td {
            padding: 10px;
            border: 1px solid #ddd;
        }

        /* Realce ao passar o mouse */
        tr:hover {
            background-color: #d1e7ff;
            transition: 0.3s;
        }
    </style>
</head>
<body>
    <h2>Histórico de Veículos</h2>
    <%
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/estacionamento", "root", "");
            Statement st = con.createStatement();
            ResultSet rs = st.executeQuery("SELECT * FROM veiculos ORDER BY entrada DESC");
    %>
            <table>
                <tr>
                    <th>Placa</th>
                    <th>Entrada</th>
                    <th>Saída</th>
                    <th>Valor Pago</th>
                </tr>
    <%
            while (rs.next()) {
    %>
                <tr>
                    <td><%= rs.getString("placa") %></td>
                    <td><%= rs.getTimestamp("entrada") %></td>
                    <td><%= rs.getTimestamp("saida") %></td>
                    <td><%= rs.getDouble("valor_pago") %></td>
                </tr>
    <%
            }
    %>
            </table>
    <%
        } catch (Exception e) {
            out.println("Erro: " + e.getMessage());
        }
    %>
</body>
</html>
