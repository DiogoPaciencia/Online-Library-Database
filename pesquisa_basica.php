<body style="background-color:black">
<h1 style="color:#746cc0;font-weight:bold;font-family:verdana;">Biblioteca Universitária ISCTE-IUL</h1>
<h2 style="color:#FFFFFF;font-weight:bold;font-family:verdana;">Pesquisa Básica</h2>

<head>
		<style type="text/css">
			table{
				border-collapse: collapse;
				width: 100%;
				color: #746cc0;
				font-family: verdana;
				font-size: 15px;
				text-align: left;
			}

			th {
				background-color: #746cc0;
				color: purple;
	        	}

			tr:nth-child(even) {background-color: #ededed}
		</style>
	</head>

<br><br><br><br><br><br><br>
<div class="topnav">
  align="center"
  <a style="color:#FFFFFF;">Título Da Publicação</a>
  &emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;
  <input type="text" name="Insert">
</div>


<br><br><br><br><br><br><br><br>

<div class="topnav">
  align="center"
  <input type="submit" name="Submit">
</div>

<br><br><br><br>


<table>
<tr>
  <th>título</th>
  <th>área temática</th>
  <th>capa</th>
  <th>data publicação</th>
  <th>número de empréstimos</th>
  <th>detalhes</th>
</tr>

<?php
$conn = mysqli_connect("localhost", "root", "", "bibliotecafinal");
if(isset($_POST['Submit'])){
  $title = $_POST['Insert'];
  $sql = "SELECT p.Titulo, p.Capa, p.Data_de_publicacao, p.Qtd_Emprestimos, at.Nome FROM publicacao p where p.Titulo=$title, area_tematica at where p.Area_Tematica_Id=at.Id";
  $result = $conn -> query($sql);

  if ($result -> num_rows > 0){
  	while($row = $result -> fetch_assoc()){
	echo "<tr><td>" . $row["Titulo"] . "</td><td>" . $row["Nome"] . "</td><td>" . $row["Capa"] . "</td><td>" . $row["Data_de_publicacao"] . "</td><td>" . $row["Qtd_Emprestimos"] . "</td></tr>";
  	}
  }else{
	echo "Empty";
  }
} 
  $conn -> close();  
?>
</table> 

<br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br>

<form>
  <input type="button" value="Pesquisar Publicações" onclick="history.back()">
</form>

<img align="right" src="library.jpg" alt="biblioteca">