<html>
<head>
<meta http-equiv="Content-Type" content="text/html;charset=UTF-8">
<title>BD Biblioteca - Alterar</title>
</head>
<?php
require('BDBiblioteca.php');
$publicacoes = new PublicacoesBiblioteca;
$publicacoes->PublicacoesBiblioteca();
?>
<body style="background-color:black">
<h1 style="color:#746cc0;font-weight:bold;font-family:verdana;">Biblioteca Universitária ISCTE-IUL</h1>
<p><h2 style="color:#FFFFFF;font-weight:bold;font-family:verdana;">Alterar uma Publicação:</h2></p>
<form method="post" action="efetuar_alteracao.php">
  <label for="Nome">Título:</label><br/>
  <input type="text" name="Nome" value="<?php echo $publicacoes->devolveNome($_POST["Id"]) ?>">
  <br/><br/>
  <label for="data_pub">Data de Publicação:</label><br/>
  <input type="date" name="data_pub" value="<?php echo $publicacoes->devolveData($_POST["Id"]) ?>">
  <br/><br/>
  <label for="area">Área Temática:</label><br/>
  <input type="text" name="area" value="<?php echo $publicacoes->devolveArea($_POST["Id"]) ?>">
  <br/><br/>
  <input type=hidden name="Id" value="<?php echo $publicacoes->devolveID($_POST["Id"])?>">
  <br/><br/>
  <?php $publicacoes->fecharBDBiblioteca() ?>
  <input type="submit" name="Submit" value="Alterar">
	<input type="reset" name="Submit2" value="Limpar">
</form>
</body>
</html>