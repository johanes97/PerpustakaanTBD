<!DOCTYPE html>

<?php
	include ('../../OpenConnection.php'); 
?>

<?php
	$email = $_SESSION['email'];
	$queryShowPeminjaman = "SELECT
								*
							FROM 
								buku
								inner join pemesanan on buku.idbuku = pemesanan.idbuku
								inner join anggota on pemesanan.email = anggota.email
							WHERE
								anggota.email LIKE '$email'
							ORDER BY
								tglpemesanan asc;";
	$query = $conn->getQuery();
?>

<html>

<head>
	<title>eLibrary</title>
	<meta name="viewport" content="width=device-width, initial-scale=1">
	<!-- OPTIONAL -->
	<link rel="stylesheet" href="../../style/style.css">
	<link rel="stylesheet" href="../../lib/font-awesome.min.css">
	<link rel="stylesheet" href="../../lib/font-awesome.css">
</head>

<body>
	<div class="isi">
		<?php
			session_start();
			include ('../../header.php');
		?>
		<div class="middle">
			<?php
				include ('../../side.php');
			?>
			<div class="article">
				<div class="opening2"><p id="judul">Order</p>
					<form class="pilihanCari" action="">
						<input id="button2" name="iAdd" type="submit" value="ADD ORDER" class="cari">
					</form>
				</div>
				<div class="main">
					<table>
						<tr><th>Book Title</th><th>Order Date</th>
						<?php
							if($result = $query->query($queryShowPeminjaman)){
								while($row = $result->fetch_array()){
									echo "<tr>";
									echo "<td>" . $row['judulbuku'] . "</td>";
									echo "<td>" . $row['tglpemesanan'] . "</td>";
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
				<span id="judulForm">Order Info</span>
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