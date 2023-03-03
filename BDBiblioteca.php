<?php
class BDBiblioteca {
  var $conn;

   function ligarBD() {
      $this->conn = mysqli_connect("localhost", "root", "", "bibliotecafinal");
	  if(!$this->conn){
		return -1;
	  }
	}
 
  function executarSQL($sql_command) {
    $resultado = mysqli_query( $this->conn, $sql_command);
    return $resultado;
 }
 
 function numero_tuplos($tabela) {
     $tuplos=0;
	 $rs=$this->executarSQL("SELECT * FROM $tabela");
	 return mysqli_num_rows($rs);  
 }
 
 function fecharBD() {
   mysqli_close($this->conn);
 }

}

class PublicacoesBiblioteca extends BDBiblioteca {
 var $db_biblioteca;

 function PublicacoesBiblioteca() {
    $this->db_biblioteca = new BDBiblioteca;
	$this->db_biblioteca->ligarBD(); 
 }
 
 function novaPublicacao($id, $nome, $nome_abr, $codigo, $data_pub, $ano_pub, $nr_pags, $capa, $capa_min, $qtd_emp, $qtd_acc, $data_aq, $area, $rel) {
    $data_publicacao = str_replace('-','',$data_pub);
    $data_aquisicao = str_replace('-','',$data_aq);
    $sql = "INSERT INTO publicacao VALUES ('$id', '$nome', '$nome_abr', '$codigo', $data_publicacao, '$ano_pub', '$nr_pags', '$capa', '$capa_min', '$qtd_emp', '$qtd_acc', $data_aquisicao, '$area', '$rel')";
    $this->db_biblioteca->executarSQL($sql);
 }
 
  function apagarPublicacao($id) {
    $sql = "DELETE FROM publicacao WHERE Id = '$id'";
    $this->db_biblioteca->executarSQL($sql);
  }

  function alterarPublicacao($nome, $data_pub, $area, $id) {
    $data_publicacao = str_replace('-','',$data_pub);
    $area_id = "SELECT Id FROM area_tematica WHERE Nome = '$area'";
    $sql = "UPDATE publicacao SET Nome = '$nome', Area_Tematica_Id = $area_id, Data_de_publicacao = $data_publicacao WHERE Id = $id";
    $this->db_biblioteca->executarSQL($sql);
  }

  function listarPublicacoesBasico($Nome) {
    echo "<table border=1 cellpadding=0 cellspacing=0>\n";
    $result_set = $this->db_biblioteca->executarSQL("SELECT * FROM publicacao WHERE Nome = '$Nome'");
    $tuplos = $this->db_biblioteca->numero_tuplos("publicacao WHERE Nome = '$Nome'");
    for($registo=0; $registo<$tuplos; $registo++) {
    echo "<tr>\n";
    $row = mysqli_fetch_assoc($result_set);
    $this->escrevePublicacao($row["Nome"], $row["Id"], $row["Area_Tematica_Id"], $row["Capa"], $row["Data_de_publicacao"], $row["Qtd_Emprestimos"]);
    echo "</tr>\n";    }
  }

  function listarPublicacoesAvancado($Nome, $Tag, $Area_Tematica_Id, $relevancia, $Data_de_publicacao) {
    $data_pub = str_replace('-','',$Data_de_publicacao);
    echo "<table border=1 cellpadding=0 cellspacing=0>\n";
    $result_set = $this->db_biblioteca->executarSQL("SELECT * FROM publicacao p, palavra_chave_descreve_publicacao c WHERE p.Nome = '$Nome' AND c.Palavra_chave_ = '$Tag' AND p.Area_Tematica_Id = $Area_Tematica_Id AND p.relevancia = $relevancia AND p.Data_de_publicacao = $data_pub AND p.Id=c.Publicacao_Id_");
    $tuplos = $this->db_biblioteca->numero_tuplos("publicacao p, palavra_chave_descreve_publicacao c WHERE p.Nome = '$Nome' AND c.Palavra_chave_ = '$Tag' AND p.Area_Tematica_Id = $Area_Tematica_Id AND p.relevancia = $relevancia AND p.Data_de_publicacao = $data_pub AND p.Id=c.Publicacao_Id_");
    for($registo=0; $registo<$tuplos; $registo++) {
    echo "<tr>\n";
    $row = mysqli_fetch_assoc($result_set);
    $this->escrevePublicacao($row["Nome"], $row["Id"], $row["Area_Tematica_Id"], $row["Capa"], $row["Data_de_publicacao"], $row["Qtd_Emprestimos"]);
    echo "</tr>\n";    }
  }
  
  function escrevePublicacao($Nome, $Id, $area, $capa, $data_pub, $num_emp) {
    printf("<td>$Nome</td><td>$area</td><td>$capa</td><td>$data_pub</td><td>$num_emp</td><form action=\"apagar_pub.php\" method=post><td><input type=hidden name=Id value=$Id><input type=submit value=Apagar></td></form><form action=\"alterar_pub.php\" method=post><td><input type=hidden name=Id value=$Id><input type=submit value=Alterar></td></form><form action=\"info_pub.php\" method=post><td><input type=hidden name=Id value=$Id><input type=submit value=Detalhes></td></form>\n");
  }

  function escreveLivro($Nome, $ISBN, $publicadora, $num, $livro_id) {
    printf("<td>$Nome</td><td>$ISBN</td><td>$publicadora</td><td>$num</td><td>$livro_id</td>");
  }

  function escreveRevista($EditNome, $ISSN, $Periodicidade_Nome, $Nr) {
    printf("<td>$EditNome</td><td>$ISSN</td><td>$Periodicidade_Nome</td><td>$Nr</td>");
  }

  function escreveMonografia($Tipo_de_monografia_Nome) {
    printf("<td>$Tipo_de_monografia_Nome</td>");
  }

  function devolveNome($id) {
    $sql="SELECT Nome FROM publicacao WHERE Id='$id'";
    $result_set = $this->db_biblioteca->executarSQL($sql);
    $row = mysqli_fetch_assoc($result_set);
    return $row["Nome"];
  }

  function devolveData($id) {
    $sql="SELECT Data_de_publicacao FROM publicacao WHERE Id='$id'";
    $result_set = $this->db_biblioteca->executarSQL($sql);
    $row = mysqli_fetch_assoc($result_set);
    return $row["Data_de_publicacao"];
  }

  function devolveArea($id) {
    $sql="SELECT a.Nome as area_tematica FROM publicacao p, area_tematica a WHERE p.Id = $id AND p.Area_Tematica_Id=a.Id";
    $result_set = $this->db_biblioteca->executarSQL($sql);
    $row = mysqli_fetch_assoc($result_set);
    return $row["area_tematica"];
  }

  function devolveID($id) {
    $sql="SELECT Id FROM publicacao WHERE Id='$id'";
    $result_set = $this->db_biblioteca->executarSQL($sql);
    $row = mysqli_fetch_assoc($result_set);
    return $row["Id"];
  }

  function pub_info_livro($Id) {
    echo "<table border=1 cellpadding=0 cellspacing=0>\n";
    $result_set = $this->db_biblioteca->executarSQL("SELECT a.Nome as aNome, l.ISBN, l.Numero, l.Livro_Id as idLivro, liv.Editora_Nome FROM edicao_de_livro l, autoria_de_livro al, autor a, livro liv WHERE l.Publicacao_Id = $Id AND l.Livro_Id = liv.Id AND liv.Id = al.Livro_Id_ AND al.Autor_id_ = a.id");
    $tuplos = $this->db_biblioteca->numero_tuplos("edicao_de_livro l, autoria_de_livro al, autor a, livro liv WHERE l.Publicacao_Id = $Id AND l.Livro_Id = liv.Id AND liv.Id = al.Livro_Id_ AND al.Autor_id_ = a.id");
    for($registo=0; $registo<$tuplos; $registo++) {
    echo "<tr>\n";
    $row = mysqli_fetch_assoc($result_set);
    $this->escreveLivro($row["aNome"], $row["ISBN"], $row["Editora_Nome"], $row["Numero"], $row["idLivro"]);
    echo "</tr>\n";    } 
  }

  function pub_info_revista($Id) {
    echo "<table border=1 cellpadding=0 cellspacing=0>\n";
    $result_set = $this->db_biblioteca->executarSQL("SELECT pe.Editora_Nome as EditNome, pe.ISSN, pe.Periodicidade_Nome, r.Qtd_edicoes_nao_emprestaveis FROM publicacao p, periodico pe, editora_ou_periodico e, revista r WHERE p.Id = '$Id' AND p.Nome = pe.Nome AND pe.Editora_ou_Periodico_Id = e.Id AND e.Id = r.Periodico_Editora_ou_Periodico_Id");
    $tuplos = $this->db_biblioteca->numero_tuplos("publicacao p, periodico pe, editora_ou_periodico e, revista r WHERE p.Id = '$Id' AND p.Nome = pe.Nome AND pe.Editora_ou_Periodico_Id = e.Id AND e.Id = r.Periodico_Editora_ou_Periodico_Id");
    for($registo=0; $registo<$tuplos; $registo++) {
    echo "<tr>\n";
    $row = mysqli_fetch_assoc($result_set);
    $this->escreveRevista($row["EditNome"], $row["ISSN"], $row["Periodicidade_Nome"], $row["Qtd_edicoes_nao_emprestaveis"]);
    echo "</tr>\n";    } 
  }

  function pub_info_monografia($Id) {
    echo "<table border=1 cellpadding=0 cellspacing=0>\n";
    $result_set = $this->db_biblioteca->executarSQL("SELECT Tipo_de_monografia_Nome FROM monografia WHERE Publicacao_Id = $Id");
    $tuplos = $this->db_biblioteca->numero_tuplos("monografia WHERE Publicacao_Id = $Id");
    for($registo=0; $registo<$tuplos; $registo++) {
    echo "<tr>\n";
    $row = mysqli_fetch_assoc($result_set);
    $this->escreveMonografia($row["Tipo_de_monografia_Nome"]);
    echo "</tr>\n";    } 
  }
  
  function fecharBDBiblioteca() {
    $this->db_biblioteca->fecharBD();
  }
}
?>
