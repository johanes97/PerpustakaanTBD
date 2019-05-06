<!DOCTYPE html>

<?php
	include ('../../OpenConnection.php');
	session_start();
	
	if(isSet($_GET['acceptbutton'])){
		$idpemesananditerima = $_GET['idpemesananditerima'];
		
		$queryterimapemesanan = "CALL terimapemesanan($idpemesananditerima);";
		$conn->executeNonQuery($queryterimapemesanan);
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
			include ('../../headerAdmin.php');
		?>
		<div class="middle">
			<?php
				include ('../../sideAdmin.php');
			?>
			<div class="article">
				<div class="opening2"><p id="judul">Order List</p></div>
				<div class="main">
					<table>
						<tr><th>Book Title</th><th>Member</th><th>Order Date</th><th>-</th>
						<?php										
							$queryShowPeminjaman = "CALL semuapemesananwaiting();";
							$query = $conn->getQuery();
							
							if($result = $query->query($queryShowPeminjaman)){
								while($row = $result->fetch_array()){
									echo "<form action='' method='get'>";
									
									echo "<tr>";
									echo "<td>" . $row['judulbuku'] . "</td>";
									echo "<td>" . $row['nama'] . "</td>";
									echo "<td>" . $row['tglpemesanan'] . "</td>";
									echo "<input name='idpemesananditerima' type='hidden' value='" . $row['idpemesanan'] . "'>";
									echo "<td><input name='acceptbutton' type='submit' value='ACCEPT' class='iBForm'></td>";
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
</body>

</html>