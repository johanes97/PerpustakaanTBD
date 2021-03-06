<!DOCTYPE html>

<?php
	include('../../OpenConnection.php');
	session_start();
	$query = $conn->getQuery();

	if(isSet($_GET['orderbutton'])){
		$emailpemesan = $_SESSION['email'];
		$idbukudipesan = $_GET['idbukudipesan'];
		
		$queryaddorder = "CALL tambahpemesanan('$emailpemesan',$idbukudipesan);";
		$conn->executeNonQuery($queryaddorder);
	}
?>

<html>

<head>
	<title>JFA Library</title>
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
				<div class="opening2"><p id="judul">Books</p>
					<form class="pilihanCari" action="" method="get">
						<input type="text" name="textInput" placeholder="Search books..." class="cari">
						<span class="cari" id="by"><pre> by </pre></span>
						<select name="pilihan" class="cari">
							<option value="judul">Title</option>
							<option value="pengarang">Author</option>
							<option value="tag">Tag</option>
						</select>
						<input id="button" name="iSearch" type="submit" value="SEARCH" class="cari">
					</form>
				</div>
				<div class="main">
					<table>
						<tr><th>Book ID</th><th>Book Title</th><th>Author</th><th>Tag</th><th>Copies Available</th><th>-</th></tr>
						<?php
							$querybuku="CALL semuabuku()";

							if(isset($_GET['iSearch'])){
								$keyword = $_GET['textInput'];
								$pilihanpencarian = $_GET['pilihan'];

								$querybuku = "CALL caribuku('$pilihanpencarian','$keyword');";
							}
							
							if($result = $query->query($querybuku)){
								while($row = $result->fetch_array()){
									echo "<form action='' method='get'>";
									
									echo "<tr>";
									echo "<td>" . $row['idbuku'] . "</td>";
									echo "<td>" . $row['judulbuku'] . "</td>";
									echo "<td>" . $row['namapengarangConcat'] . "</td>";
									echo "<td>" . $row['namatagConcat'] . "</td>";
									echo "<td>" . $row['ideksemplarConcat'] . "</td>";
									echo "<td>" . "</td>";
									echo "<input name='idbukudipesan' type='hidden' value='" . $row['idbuku'] . "'>";
									echo "<td><input name='orderbutton' type='submit' value='ORDER' class='iBForm'></td>";
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