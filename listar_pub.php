<html>
<head>
<meta http-equiv="Content-Type" content="text/html;charset=UTF-8">
<title>BD Biblioteca - Listar</title></head>
<body background=#ffffff>
<p><h3>Listagem de Publicações</h3></p>
<?php
require('BDBiblioteca.php');

$publicacoes = new PublicacoesBiblioteca;
$publicacoes->PublicacoesBiblioteca();
$publicacoes->listarPublicacoesBasico($_POST["Nome"]);
$publicacoes->fecharBDBiblioteca();
?>
<br>
<a href="bibliotecaiscte.html">voltar ao menu</a>
</body>
</html>