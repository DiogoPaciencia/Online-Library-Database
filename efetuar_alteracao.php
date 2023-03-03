<html>
<head>
<meta http-equiv="Content-Type" content="text/html;charset=UTF-8">
<title>BD Biblioteca - Alterar</title>
</head>
<body style="background-color:black">
<h1 style="color:#746cc0;font-weight:bold;font-family:verdana;">Biblioteca Universitária ISCTE-IUL</h1>

<?php
require('BDBiblioteca.php');
$publicacoes = new PublicacoesBiblioteca();
$publicacoes->alterarPublicacao($_POST["Nome"], $_POST["data_pub"], $_POST["area"], $_POST["Id"]);
$publicacoes->fecharBDBiblioteca();
?>
<br>
<p><h3 style="color:#FFFFFF;font-weight:bold;font-family:verdana;">Alteração efetuada com sucesso!</h3></p>
<br>
<br>
<a href="bibliotecaiscte.html">voltar ao menu</a>
</body>
</html>
