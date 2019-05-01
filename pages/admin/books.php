<!DOCTYPE html>

<?php
	include('../../OpenConnection.php'); 
?>

<?php
	$queryShowBook="SELECT DISTINCT
						*
					FROM 
						buku
						inner join bukupengarang on buku.idbuku = bukupengarang.idbuku
						inner join pengarang on pengarang.idpengarang = bukupengarang.idpengarang";
	$query = $conn->getQuery();

	if(isset($_GET['iSearch'])){
		$textInput = $_GET['textInput'];
		$pilihan = $_GET['pilihan'];

		$queryCari="";
		if($pilihan == 'judul'){
			$queryCari = " WHERE judulbuku LIKE '%$textInput%'";
		}
		else if($pilihan == 'pengarang'){
			$queryCari = " WHERE namapengarang LIKE '%$textInput%'";	
		}
		else if($pilihan == 'tag'){
			$queryCari = " WHERE namatag LIKE '%$textInput%'";
		}
		if($textInput == "") $queryCari="";
		$queryShowBook .= $queryCari;
	}
?>

<html>

<head>
	<title>eLibrary</title>
	<meta name="viewport" content="width=device-width, initial-scale=1">
	<link rel="stylesheet" href="../../style/style.css">
	<link rel="stylesheet" href="../../lib/font-awesome.min.css">
	<link rel="stylesheet" href="../../lib/font-awesome.css">
</head>

<body>
	<div class="isi">
		<?php
			session_start();
			include ('../../headerAdmin.php');
		?>
		<div class="middle">
			<?php
				include ('../../sideAdmin.php');
			?>
			<div class="article">
				<div class="opening2"><p id="judul">Book List</p>
					<form class="pilihanCari" action="">
						<input type="text" name="textInput" placeholder="Search books." class="cari">
						<span class="cari" id="by"><pre> by </pre></span>
						<select name="pilihan" class="cari">
							<option value="judul">Title</option>
							<option value="kategori">Tag</option>
							<option value="pengarang">Author</option>
						</select>
						<input id="button" name="iSearch" type="submit" value="SEARCH" class="cari">
						<input id="button2" name="iAdd" type="submit" value="ADD BOOK" class="cari">
					</form>
				</div>
				<div class="main">
					<p id="tambahBuku"></p>
					<table>
						<tr><th>Book ID</th><th>Book Title</th><th>Author</th></tr>
						<?php
							if($result = $query->query($queryShowBook)){
								while($row = $result->fetch_array()){
									echo "<tr>";
									echo "<td>" . $row['idbuku'] . "</td>";
									echo "<td>" . $row['judulbuku'] . "</td>";
									echo "<td>" . $row['namapengarang'] . "</td>";
									echo "</tr>";
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
					<div class="iForm"><input type="text" name="pengarang" placeholder="Author"></div>
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
			
			$queryGetIdBuku = "SELECT buku.idbuku
								FROM buku
								WHERE judulbuku LIKE '$judulbuku'";
			$queryGetIdPengarang = "SELECT pengarang.idpengarang
								FROM pengarang
								WHERE namapengarang LIKE '$namapengarang'";
			
			$result = $query->query($queryGetIdBuku);
			$row = $result->fetch_array();
			$idbuku = $row['idbuku'];
			
			$result = $query->query($queryGetIdPengarang);
			$row = $result->fetch_array();
			$idpengarang = $row['idpengarang'];
			
			$queryInsertBukuPengarang = "INSERT INTO bukupengarang(idbuku,idpengarang) VALUES($idbuku,$idpengarang);";
			$conn->executeNonQuery($queryInsertBukuPengarang);

			//$idKate = $conn->executeQuery("SELECT id_kategori FROM kategori WHERE nama_kategori = '$kategori'")[0][0];
			//$queryInsertKategori = "INSERT INTO kategori_buku 
			//		VALUES ('$idBuku','$idKate')";
			//$conn->executeNonQuery($queryInsertKategori); 

			echo "<script>document.getElementById('tambahBuku').innerHTML = 'Book Added'</script>";
		}
	}
?>