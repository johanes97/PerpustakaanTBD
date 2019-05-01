<!DOCTYPE html>

<?php
	include ('../../OpenConnection.php');
?>

<?php
	$queryShowBook="SELECT DISTINCT
						*
					FROM 
						buku
						inner join bukupengarang on buku.idbuku = bukupengarang.idbuku
						inner join pengarang on pengarang.idpengarang = bukupengarang.idpengarang;";
	$query = $conn->getQuery();

	if(isset($_GET['iSearch'])){
		$textInput = $_GET['textInput'];
		$pilihan = $_GET['pilihan'];

		$queryCari="";
		if($pilihan == 'judul'){
			$queryCari = " WHERE judulbuku = '$textInput'";

		}
		else if($pilihan == 'tag'){
			$queryCari = " WHERE namatag = '$textInput'";

		}
		else if($pilihan == 'pengarang'){
			$queryCari = " WHERE namapengarang = '$textInput'";
			
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
						<input type="text" name="textInput" placeholder="Search books..." class="cari">
						<span class="cari" id="by"><pre> by </pre></span>
						<select name="pilihan" class="cari">
							<option value="judul">Title</option>
							<option value="tag">Tag</option>
							<option value="pengarang">Author</option>
						</select>
						<input id="button" name="iSearch" type="submit" value="SEARCH" class="cari">
					</form>
				</div>
				<div class="main">
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
</body>

</html>