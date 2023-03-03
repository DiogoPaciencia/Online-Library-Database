<html>
<head>
<meta http-equiv="Content-Type" content="text/html;charset=UTF-8">
<title>BD Biblioteca - Listar</title><style type="text/css">
			table{
				border-collapse: collapse;
				width: 100%;
				color: #FFFFFF;
				font-family: verdana;
				font-size: 15px;
				text-align: left;
			}

			th {
				background-color: #746cc0;
				color: purple;
	        	}

			tr:nth-child(even) {background-color: #ededed}
		</style></head>
<body style="background-color:black">
<h1 style="color:#746cc0;font-weight:bold;font-family:verdana;">Biblioteca Universitária ISCTE-IUL</h1>
<p><h2 style="color:#FFFFFF;font-weight:bold;font-family:verdana;">Listagem de Publicações</h2></p>
<?php
require('BDBiblioteca.php');

$publicacoes = new PublicacoesBiblioteca;
$publicacoes->PublicacoesBiblioteca();
$publicacoes->listarPublicacoesAvancado($_POST["Nome"], $_POST["Tag"], $_POST["Area_Tematica_Id"], $_POST["relevancia"], $_POST["Data_de_publicacao"]);
$publicacoes->fecharBDBiblioteca();
?>
<br>
<a href="bibliotecaiscte.html">voltar ao menu</a>
</body>
</html>