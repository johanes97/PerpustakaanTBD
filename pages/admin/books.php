<!DOCTYPE html>

<?php
	include('../../OpenConnection.php'); 
	session_start();
	$query = $conn->getQuery();
	
	if(isSet($_GET['deletebutton'])){
		$idbukudihapus = $_GET['idbukudihapus'];
		
		$queryhapusbuku = "CALL hapusbuku($idbukudihapus);";
		$conn->executeNonQuery($queryhapusbuku);
		
		echo "<script>modalOn();</script>";
	}
?>

<html>

<head>
	<title>JFA Library</title>
	<meta name="viewport" content="width=device-width, initial-scale=1">
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
				<div class="opening2"><p id="judul">Books</p>
					<form class="pilihanCari" action="">
						<input type="text" name="textInput" placeholder="Search books." class="cari">
						<span class="cari" id="by"><pre> by </pre></span>
						<select name="pilihan" class="cari">
							<option value="judul">Title</option>
							<option value="kategori">Tag</option>
							<option value="pengarang">Author</option>
						</select>
						<input id="button" name="iSearch" type="submit" value="SEARCH" class="cari">
						<input id="button2" name="iAdd" type="submit" value="ADD" class="cari">
					</form>
				</div>
				<div class="main">
					<p id="tambahBuku"></p>
					<table>
						<tr><th>Book ID</th><th>Book Title</th><th>Author</th><th>Tag</th><th>Eksemplar Tersedia</th><th>-</th></tr>
						<?php
							$querysemuabuku = "CALL semuabuku()";

							if(isset($_GET['iSearch'])){
								$keyword = $_GET['textInput'];
								$pilihanpencarian = $_GET['pilihan'];

								$querysemuabuku = "CALL caribuku('$pilihanpencarian','$keyword');";
							}
								
							if($result = $query->query($querysemuabuku)){
								while($row = $result->fetch_array()){
									echo "<form action='' method='get'>";
									
									echo "<tr>";
									echo "<td>" . $row['idbuku'] . "</td>";
									echo "<td>" . $row['judulbuku'] . "</td>";
									echo "<td>" . $row['namapengarang'] . "</td>";
									echo "<td>" . "</td>";
									echo "<td>" . "</td>";
									echo "<input name='idbukudihapus' type='hidden' value='" . $row['idbuku'] . "'>";
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
				<span id="judulForm">Book Data</span>
				<form method="get">
					<div class="iForm"><input type="text" name="judul" placeholder="Title"></div>
					<div class="iForm">
						<select name="pengarang">
						  <?php
							// if($result = $query->query($queryShowBook)){
							// 	while($row = $result->fetch_array()){
									echo "<option value='audi' selected>Audi</option>";
								// }
							//}
						?>
						</select>
					</div>
					<div class="tombol">
						<div><input type="submit" value="ADD" class="iBForm" name="add"></div>
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
	if(isset($_GET['iAdd'])){
		echo "<script>modalOn();</script>";
	}
	if(isset($_GET['add'])){ 
		$judulbuku = $_GET['judul'];
		$namapengarang = $_GET['pengarang'];
		//$tag = $_GET['kategori'];

		if($judulbuku!="" && $namapengarang!=""){
			$queryInsertBook = "INSERT INTO buku(judulbuku) VALUES('$judulbuku');";
			$queryInsertPengarang = "INSERT INTO pengarang(namapengarang) VALUES('$namapengarang');";
			$conn->executeNonQuery($queryInsertBook);
			$conn->executeNonQuery($queryInsertPengarang);
			
			$queryGetIdBukuIdPengarang = "call search_id_book_and_id_author('$judulbuku','$namapengarang')";
			
			$resultIdBukuIdPengarang = $query->query($queryGetIdBukuIdPengarang);
			$rowIdBukuIdPengarang = $resultIdBukuIdPengarang->fetch_array();
			$idbuku = $rowIdBukuIdPengarang['idBuku'];

			$idpengarang = $rowIdBukuIdPengarang['idPengarang'];

			$conn->freeResult();

			$queryInsertBukuPengarang = "call insert_book_author($idbuku,$idpengarang)";
			$conn->executeNonQuery($queryInsertBukuPengarang);

			//$idKate = $conn->executeQuery("SELECT id_kategori FROM kategori WHERE nama_kategori = '$kategori'")[0][0];
			//$queryInsertKategori = "INSERT INTO kategori_buku 
			//		VALUES ('$idBuku','$idKate')";
			//$conn->executeNonQuery($queryInsertKategori); 

			echo "<script>document.getElementById('tambahBuku').innerHTML = 'Book Added'</script>";
		}
	}
?>