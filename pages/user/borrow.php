<!DOCTYPE html>

<?php
	include ('../../OpenConnection.php');
	session_start();
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
			include ('../../header.php');
		?>
		<div class="middle">
			<?php
				include ('../../side.php');
			?>
			<div class="article">
				<div class="opening2"><p id="judul">Borrows</p></div>
				<div class="main">
					<table>
						<tr><th>Book Title</th><th>Author</th><th>Borrow Date</th><th>Return Date</th><th>Overdue</th><th>Fine</th></tr>
						<?php
							$emaillogin = $_SESSION['email'];
							$querypeminjaman = "CALL semuapeminjaman('ACTIVE','$emaillogin');";
							
							if($result = $query->query($querypeminjaman)){
								while($row = $result->fetch_array()){
									echo "<tr>";
									echo "<td>" . $row['judulbuku'] . "</td>";
									echo "<td>" . $row['namapengarang'] . "</td>";
									echo "<td>" . $row['tglpeminjaman'] . "</td>";
									echo "<td>" . $row['bataspengembalian'] . "</td>";
									echo "<td>" . $row['durasihariterlambat'] . "</td>";
									echo "<td>" . $row['besardenda'] . "</td>";
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