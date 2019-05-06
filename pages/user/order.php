<!DOCTYPE html>

<?php
	include ('../../OpenConnection.php'); 
	session_start();
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
			include ('../../header.php');
		?>
		<div class="middle">
			<?php
				include ('../../side.php');
			?>
			<div class="article">
				<div class="opening2"><p id="judul">Order</p>
				</div>
				<div class="main">
					<table>
						<tr><th>Book Title</th><th>Order Date</th><th>Status</th>
						<?php
							$email = $_SESSION['email'];
							$queryShowPeminjaman = "CALL caripemesanan('$email');";
							$query = $conn->getQuery();
							
							if($result = $query->query($queryShowPeminjaman)){
								while($row = $result->fetch_array()){
									echo "<tr>";
									echo "<td>" . $row['judulbuku'] . "</td>";
									echo "<td>" . $row['tglpemesanan'] . "</td>";
									echo "<td>" . $row['statuspemesanan'] . "</td>";
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