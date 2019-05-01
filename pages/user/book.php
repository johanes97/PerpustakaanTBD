<!DOCTYPE html>

<?php
	include ('../../OpenConnection.php');
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
					</form>
				</div>
				<div class="main">
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
</body>

</html>