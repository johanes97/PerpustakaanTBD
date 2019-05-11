<!DOCTYPE html>

<?php
	include ('../../OpenConnection.php');
	session_start();
	$query = $conn->getQuery();
?>

<html>

<head>
	<title>JFA Library</title>
	<meta name="viewport" content="width=device-width, initial-scale=1">
	<link rel="stylesheet" href="../../style/style.css">
	<link rel="stylesheet" href="../../lib/font-awesome.min.css">
	<link rel="stylesheet" href="../../lib/font-awesome.css">
</head>

<body class="w3-theme-d5">
	<div class="isi">
		<?php
			include ('../../headerAdmin.php');
		?>
		<div class="middle">
			<?php
				include ('../../sideAdmin.php');
			?>
			<div class="article">
				<div class="opening2"><p id="judul">Reports</p>
				</div>
				<div class="main">
					<p id="notice"></p>
					<table>
						<tr><th>Most Borrowed Books</th><th>Most Borrowed Authors</th><th>Most Borrowed Tags</th></tr>
						<form action="" method="get">
						<tr>
							<th><input id="button" name="btncekbuku" type="submit" value="CEK" class="cari"></th>
							<th><input id="button" name="btncekpengarang" type="submit" value="CEK" class="cari"></th>
							<th><input id="button" name="btncektag" type="submit" value="CEK" class="cari"></th>
						</tr>
						</form>
					</table>
				</div>
				<div class="closing">
					<p>&copy; 2019 JFA - eLibrary for Database Technology</p>
				</div>
			</div>
		</div>
	</div>
	
	<!--Modal laporan buku-->
	<div id="myModal" class="modal">

		<!-- Modal content kotak yg pop up nya-->
		<div class="modal2-content">
			<fieldset>
				<span onclick="document.getElementById('myModal').style.display='none'" class="close">&times;</span>
				<span id="judulForm">
				<?php
					if(isset($_GET['btncekbuku'])){
						echo "Most Borrowed Books";
					}else if(isset($_GET['btncekpengarang'])){
						echo "Most Borrowed Authors";
					}else if(isset($_GET['btncektag'])){
						echo "Most Borrowed Tags";
					}
				?>
				</span>
				<table>
					<tr><th>Buku</th><th>Jumlah Peminjaman</th></tr>
					<?php
						if(isset($_GET['btncekbuku'])){
							$querylaporan = "CALL laporanbuku('');";
							
							if($result = $query->query($querylaporan)){
								while($row = $result->fetch_array()){
									echo "<tr>";
									echo "<td>" . $row['bukudipinjam'] . "</td>";
									echo "<td>" . $row['jumlahpeminjaman'] . "</td>";
									echo "</tr>";
								}
							}
						}
						else if(isset($_GET['btncekpengarang'])){
							$querylaporan = "CALL laporanpengarang('');";
							
							if($result = $query->query($querylaporan)){
								while($row = $result->fetch_array()){
									echo "<tr>";
									echo "<td>" . $row['pengarangdipinjam'] . "</td>";
									echo "<td>" . $row['jumlahpeminjaman'] . "</td>";
									echo "</tr>";
								}
							}
						}
						else if(isset($_GET['btncektag'])){
							$querylaporan = "CALL laporantag('');";
							
							if($result = $query->query($querylaporan)){
								while($row = $result->fetch_array()){
									echo "<tr>";
									echo "<td>" . $row['tagdipinjam'] . "</td>";
									echo "<td>" . $row['jumlahpeminjaman'] . "</td>";
									echo "</tr>";
								}
							}
						}
					?>
				</table>
			</fieldset>
		</div>
	</div>

	<script>
		var modalbuku = document.getElementById('myModal');
		function modalOn(){
			modalbuku.style.display = 'block';
		}
	</script>
	
</body>

</html>

<?php
	if(isset($_GET['btncekbuku'])){
		echo "<script>modalOn();</script>";
	}
	
	if(isset($_GET['btncekpengarang'])){
		echo "<script>modalOn();</script>";
	}
	
	if(isset($_GET['btncektag'])){
		echo "<script>modalOn();</script>";
	}
?>