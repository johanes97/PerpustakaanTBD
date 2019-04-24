<!DOCTYPE html>

<?php
	include('../../OpenConnection.php'); 
?>

<?php
	$queryShowBook="SELECT DISTINCT 
						* 
					FROM 
						buku left outer join kategori_buku 
						on kategori_buku.id_buku = buku.id_buku inner join kategori 
						on kategori_buku.id_kategori = kategori.id_kategori";
	$query = $conn->getQuery();

	if(isset($_GET['iSearch'])){
		$textInput = $_GET['textInput'];
		$pilihan = $_GET['pilihan'];

		$queryCari="";
		if($pilihan == 'judul'){
			$queryCari = " WHERE judul = '$textInput'";

		}
		else if($pilihan == 'kategori'){
			$queryCari = " WHERE nama_kategori = '$textInput'";

		}
		else if($pilihan == 'pengarang'){
			$queryCari = " WHERE pengarang = '$textInput'";
			
		}
		else if($pilihan == 'penerbit'){
			$queryCari = " WHERE penerbit = '$textInput'";
			
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
							<option value="judul">Tittle</option>
							<option value="kategori">Category</option>
							<option value="pengarang">Author</option>
							<option value="penerbit">Publisher</option>
						</select>
						<input id="button" name="iSearch" type="submit" value="SEARCH" class="cari">
						<input id="button2" name="iAdd" type="submit" value="ADD BOOK" class="cari">
					</form>
				</div>
				<div class="main">
					<p id="tambahBuku"></p>
					<table>
						<tr><th>Code</th><th>Title</th><th>Author</th><th>Publication Year</th>
						<th>Publisher</th><th>Nama Kategori</th></tr>
						<?php
							if($result = $query->query($queryShowBook)){
								while($row = $result->fetch_array()){
									echo "<tr>";
									echo "<td>".$row['id_buku']."</td>";
									echo "<td>".$row['judul']."</td>";
									echo "<td>".$row['pengarang']."</td>";
									echo "<td>".$row['tahun_terbit']."</td>";
									echo "<td>".$row['penerbit']."</td>";
									echo "<td>".$row['nama_kategori']."</td>";
									echo "</tr>";
								}
							}
						?>
					</table>
				</div>
				<div class="closing">
					<p>&copy; 2016 Maria Veronica - eLibrary fow Web Based Programming</p>
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
				<form action="">
					<div class="iForm"><input type="text" name="judul" placeholder="Title"></div>
					<div class="iForm"><input type="text" name="pengarang" placeholder="Author"></div>
					<div class="iForm"><input type="text" name="thnTerbit" placeholder="Publication Year"></div>
					<div class="iForm"><input type="text" name="penerbit" placeholder="Publisher"></div>
					<select name="kategori" class="iForm">
						<?php
						$queryKategori = "SELECT nama_kategori FROM kategori";
							if($result = $query->query($queryKategori)){
								while($row = $result->fetch_array()){
									$kate = $row['nama_kategori'];
									echo "<option value='$kate'>$kate</option>";
								}
							}
						?>
					</select>
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
	function generateCode($length=4){
		$characters = '0a1q2E3p4hbK56F7ec8L9idUMoxyNgzXAnBCwrfDYTGsvkHItJOhPQujmRlVWSZ';
		$charactersLength = strlen($characters);
		$randomString = '';
		for($i = 0; $i < $length; $i++){
			$randomString .= $characters[rand(0,$charactersLength - 1)];
		}
		return $randomString;
	}

	if(isset($_GET['iAdd'])){
		echo "<script>modalOn();</script>";
	}
	if(isset($_GET['add'])){ 
		$idBuku=generateCode();
		$judul = $_GET['judul']; $pengarang = $_GET['pengarang']; 
		$thnTerbit = $_GET['thnTerbit'];$penerbit = $_GET['penerbit']; $kategori = $_GET['kategori'];

		$queryCek="SELECT * FROM buku WHERE id_buku = $idBuku";
		$resCek = $conn->executeQuery($queryCek);

		if($resCek!=null){
			while($resCek!=null){
				$idBuku=generateCode();
				$queryCek="SELECT * FROM buku WHERE id_buku = $idBuku";
				$resCek = $conn->executeQuery($queryCek);
			}
		}

		if($judul!=""&& $pengarang!="" && $thnTerbit!="" && $penerbit!="" &&$kategori!=""){
			$queryInsertBook = "INSERT INTO buku 
				VALUES ('$idBuku','$judul', '$pengarang', $thnTerbit, '$penerbit')";
			$conn->executeNonQuery($queryInsertBook);

			$idKate = $conn->executeQuery("SELECT id_kategori FROM kategori WHERE nama_kategori = '$kategori'")[0][0];
			$queryInsertKategori = "INSERT INTO kategori_buku 
					VALUES ('$idBuku','$idKate')";
			$conn->executeNonQuery($queryInsertKategori); 

			echo "<script>document.getElementById('tambahBuku').innerHTML = 'Book Added'</script>";
		}
	}
?>