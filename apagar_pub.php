<html>
<head>
<meta http-equiv="Content-Type" content="text/html;charset=UTF-8">
<title>BD Biblioteca - Apagar</title></head>
<body style="background-color:black">
<h1 style="color:#746cc0;font-weight:bold;font-family:verdana;">Biblioteca Universitária ISCTE-IUL</h1>
<p><h2 style="color:#FFFFFF;font-weight:bold;font-family:verdana;">Apagar Publicações </h2></p>

<?php
require('BDBiblioteca.php');
$publicacoes = new PublicacoesBiblioteca;
$publicacoes->PublicacoesBiblioteca();
$publicacoes->apagarPublicacao($_POST["Id"]);
$publicacoes->fecharBDBiblioteca();
?>
<br>
<p><h3 style="color:#FFFFFF;font-weight:bold;font-family:verdana;">Publicação removida com sucesso!</h3></p>
<br><br>
<a href="bibliotecaiscte.html">voltar ao menu</a>
</body>
</html>
