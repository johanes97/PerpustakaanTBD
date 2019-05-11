<!DOCTYPE html>

<?php
	include ('../../OpenConnection.php');
	session_start();
	$query = $conn->getQuery();
	
	if(isSet($_GET['deletebutton'])){
		$tarifdendadihapus = $_GET['tarifdendadihapus'];
		
		$queryhapusdenda = "CALL hapusdenda($tarifdendadihapus);";
		$conn->executeNonQuery($queryhapusdenda);
	}
	
	if(isset($_GET['add'])){ 
		$jumlahhari = $_GET['jumlahhari'];
		$tarif = $_GET['tarif']; 
		
		$querytambahdenda = "CALL tambahdenda($tarif,$jumlahhari);";
		
		if($jumlahhari != 0 && $tarif != 0){
			$conn->executeNonQuery($querytambahdenda);
		}
	}
?>

<html>

<head>
	<title>JFA Library</title>
	<meta name="viewport" content="width=device-width, initial-scale=1">
	<!-- OPTIONAL -->
	<link rel="stylesheet" href="../../style/style.css">
	<link rel="stylesheet" href="../../lib/font-awesome.min.css">
	<link rel="stylesheet" href="../../lib/font-awesome.css">
</head>

<body>
	<div class="isi">
		<?php
			include ('../../headerAdmin.php');
		?>
		<div class="middle">
			<?php
				include ('../../sideAdmin.php');
			?>
			<div class="article">
				<div class="opening2"><p id="judul">Fines</p>
					<form class="pilihanCari" action="" method="get">
						<input id="button2" name="iAdd" type="submit" value="ADD" class="cari">
					</form>
				</div>
				<div class="main">
					<table>
						<tr><th>Days</th><th>Fine</th><th>-</th></tr>
						<?php										
							$querydenda = "CALL semuadenda();";
							
							if($result = $query->query($querydenda)){
								while($row = $result->fetch_array()){
									echo "<form action='' method='get'>";
									
									echo "<tr>";
									echo "<td>" . $row['jumlahhari'] . "</td>";
									echo "<td>" . $row['tarif'] . "</td>";
									echo "<input name='tarifdendadihapus' type='hidden' value='" . $row['tarif'] . "'>";
									echo "<td><input name='deletebutton' type='submit' value='DELETE' class='iBForm'></td>";
									echo "</tr>";
									
									echo "</form>";
								}
							}
						?>
					</table>
				</div>
				<div class="closing">
					<p>&copy; 2019 JFA - eLibrary for Database Technology</p>
				</div>
			</div>
		</div>
	</div>
	
	<!-- The Modal ini 1 browser-->
	<div id="myModal" class="modal">

		<!-- Modal content kotak yg pop up nya-->
		<div class="modal2-content">
			<fieldset>
				<span onclick="document.getElementById('myModal').style.display='none'" class="close">&times;</span>
				<span id="judulForm">New Fine</span>
				<form action="">
					<div class="iForm"><input type="text" name="jumlahhari" placeholder="Hari denda..."></div>
					<div class="iForm"><input type="text" name="tarif" placeholder="Besar tarif..."></div>
					<div class="tombol">
						<div><input type="submit" value="REGISTER" class="iBForm" name="add"></div>
					</div>
				</form>
			</fieldset>
		</div>
	</div>

	<script>
		var modal = document.getElementById('myModal');
		function modalOn(){
			modal.style.display = 'block';
		}
	</script>
	
</body>

</html>

<?php
	if(isset($_REQUEST['iAdd'])){
		echo "<script>modalOn();</script>";
	}
?>