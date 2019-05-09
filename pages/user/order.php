<!DOCTYPE html>

<?php
	include ('../../OpenConnection.php'); 
	session_start();
	$query = $conn->getQuery();
	
	if(isSet($_GET['cancelbutton'])){
		$idpemesanandihapus = $_GET['idpemesanandihapus'];
		
		$queryhapusorder = "CALL hapuspemesanan($idpemesanandihapus);";
		$conn->executeNonQuery($queryhapusorder);
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
			include ('../../header.php');
		?>
		<div class="middle">
			<?php
				include ('../../side.php');
			?>
			<div class="article">
				<div class="opening2"><p id="judul">Orders</p>
					<form class="pilihanCari" action="" method="get">
						<input type="text" name="textInput" placeholder="Search orders..." class="cari">
						<span class="cari" id="by"><pre> by </pre></span>
						<select name="pilihan" class="cari">
							<option value="buku">Book</option>
						</select>
						<input id="button" name="iSearch" type="submit" value="SEARCH" class="cari">
					</form>
				</div>
				<div class="main">
					<table>
						<tr><th>Book Title</th><th>Order Date</th><th>-</th><tr>
						<?php
							$emaillogin = $_SESSION['email'];
							$querypemesanan = "CALL semuapemesanan('WAITING','$emaillogin');";
							
							if(isset($_GET['iSearch'])){
								$keyword = $_GET['textInput'];
								$pilihanpencarian = $_GET['pilihan'];

								$querypemesanan = "CALL caripemesanan('$pilihanpencarian','$keyword','WAITING','$emaillogin');";
							}
							
							if($result = $query->query($querypemesanan)){
								while($row = $result->fetch_array()){
									echo "<form action='' method='get'>";
									
									echo "<tr>";
									echo "<td>" . $row['judulbuku'] . "</td>";
									echo "<td>" . $row['tglpemesanan'] . "</td>";
									echo "<td>" . $row['statuspemesanan'] . "</td>";
									echo "<input name='idpemesanandihapus' type='hidden' value='" . $row['idpemesanan'] . "'>";
									echo "<td><input name='cancelbutton' type='submit' value='CANCEL' class='iBForm'></td>";
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