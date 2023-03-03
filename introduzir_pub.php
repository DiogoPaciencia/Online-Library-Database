<html>
<meta http-equiv="Content-Type" content="text/html;charset=UTF-8">
<head><title>BD Biblioteca - Introduzir</title>
</head>
<body style="background-color:black">
<h1 style="color:#746cc0;font-weight:bold;font-family:verdana;">Biblioteca Universitária ISCTE-IUL</h1>

<?php
require('BDBiblioteca.php');

$publicacoes = new PublicacoesBiblioteca;
$publicacoes->PublicacoesBiblioteca();
$publicacoes->novaPublicacao($_POST["id"], $_POST["nome"], $_POST["nome_abr"], $_POST["codigo"], $_POST["data_pub"],$_POST["ano_pub"], $_POST["nr_pags"], $_POST["capa"], $_POST["capa_min"], $_POST["qtd_emp"], $_POST["qtd_acc"], $_POST["data_aq"], $_POST["area"], $_POST["rel"]);
$publicacoes->fecharBDBiblioteca();
?>
<br>
<p><h3 style="color:#FFFFFF;font-weight:bold;font-family:verdana;">Publicação inserida com sucesso!</h3></p>
<br><br>
<a href="bibliotecaiscte.html">voltar ao menu</a>
</body>
</html>