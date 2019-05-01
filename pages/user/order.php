<!DOCTYPE html>

<?php
	include ('../../OpenConnection.php'); 
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

				$queryShowPeminjaman = "SELECT
											*
										FROM 
											buku
											inner join peminjaman on buku.idbuku = peminjaman.idbuku
											inner join anggota on peminjaman.email = anggota.email";
				$query = $conn->getQuery();
			?>
			<div class="article">
				<div class="opening2"><p id="judul">Borrowing History</p></div>
				<div class="main">
					<table>
						<tr><th>Book ID</th><th>Book Title</th><th>Member</th><th>Order Date</th>
						<?php
							if($result = $query->query($queryShowPeminjaman)){
								while($row = $result->fetch_array()){
									echo "<tr>";
									echo "<td>".$row['idbuku']."</td>";
									echo "<td>".$row['judulbuku']."</td>";
									echo "<td>".$row['nama']."</td>";
									echo "<td>".$row['tglpeminjaman']."</td>";
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