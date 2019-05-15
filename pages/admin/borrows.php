<!DOCTYPE html>

<?php
	include ('../../OpenConnection.php');
	session_start();
	$query = $conn->getQuery();
	
	if(isSet($_GET['deletebutton'])){
		$idpeminjamandihapus = $_GET['idpeminjamandihapus'];
		
		$queryhapuspeminjaman = "CALL hapuspeminjaman($idpeminjamandihapus);";
		$conn->executeNonQuery($queryhapuspeminjaman);
	}
	
	if(isset($_GET['add'])){ 
		$emailpeminjam = $_GET['emailpeminjam'];
		$idbukudipinjam = $_GET['idbukudipinjam']; 
		$bataspeminjaman = $_GET['bataspeminjaman'];
		
		$querytambahpeminjaman = "CALL tambahpeminjaman('$emailpeminjam',$idbukudipinjam,'$bataspeminjaman');";
		
		if($emailpeminjam != "" && $idbukudipinjam != "" && $bataspeminjaman != ""){
			$conn->executeNonQuery($querytambahpeminjaman);
		}
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
			include ('../../headerAdmin.php');
		?>
		<div class="middle">
			<?php
				include ('../../sideAdmin.php');
			?>
			<div class="article">
				<div class="opening2"><p id="judul">Borrows</p>
					<form class="pilihanCari" action="" method="get">
						<input type="text" name="textInput" placeholder="Search borrows..." class="cari">
						<span class="cari" id="by"><pre> by </pre></span>
						<select name="pilihan" class="cari">
							<option value="anggota">Member</option>
							<option value="buku">Book</option>
						</select>
						<input type="hidden" name="showAll" value="all">
						<input id="button" name="iSearch" type="submit" value="SEARCH" class="cari">
						<input id="button2" name="iAdd" type="submit" value="ADD" class="cari">
					</form>
				</div>
				<div class="main">
					<table>
						<tr><th>Borrower</th><th>Book Title</th><th>Author</th><th>Borrow Date</th><th>Return Date</th><th>Overdue</th><th>Fine</th><th>-</th></tr>
						<?php
							$queryupdatepeminjaman = "CALL updatepeminjaman();";
							$conn->executeNonQuery($queryupdatepeminjaman);
							
							$querypeminjaman = "CALL semuapeminjaman('ACTIVE','');";
							if(isset($_GET['showAll'])){
								$querypeminjaman = "CALL semuapeminjaman('','');";
							}
							
							if(isset($_GET['iSearch'])){
								$keyword = $_GET['textInput'];
								$pilihanpencarian = $_GET['pilihan'];

								$querypeminjaman = "CALL caripeminjaman('$pilihanpencarian','$keyword','ACTIVE');";
								if(isset($_GET['showAll'])){
									$querypeminjaman = "CALL caripeminjaman('$pilihanpencarian','$keyword','');";
								}
							}
							
							if($result = $query->query($querypeminjaman)){
								while($row = $result->fetch_array()){
									echo "<form action='' method='get'>";
									
									echo "<tr>";
									echo "<td>" . $row['nama'] . "</td>";
									echo "<td>" . $row['judulbuku'] . "</td>";
									echo "<td>" . $row['namapengarangConcat'] . "</td>";
									echo "<td>" . $row['tglpeminjaman'] . "</td>";
									echo "<td>" . $row['bataspengembalian'] . "</td>";
									echo "<td>" . $row['durasihariterlambat'] . "</td>";
									echo "<td>" . $row['besardenda'] . "</td>";
									echo "<input name='idpeminjamandihapus' type='hidden' value='" . $row['idpeminjaman'] . "'>";
									if(!isset($_GET['showAll'])){
										echo "<td><input name='deletebutton' type='submit' value='INACTIVATE' class='iBForm'></td>";
									}
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
	
	<!-- The Modal ini 1 browser-->
	<div id="myModal" class="modal">

		<!-- Modal content kotak yg pop up nya-->
		<div class="modal2-content">
			<fieldset>
				<span onclick="document.getElementById('myModal').style.display='none'" class="close">&times;</span>
				<span id="judulForm">New Borrow</span>
				<form action="">
					<div class="iForm"><input type="text" name="emailpeminjam" placeholder="Email peminjam..."></div>
					<div class="iForm"><input type="text" name="idbukudipinjam" placeholder="ID buku dipinjam..."></div>
					<div class="iForm"><p>Batas peminjaman:</p><input type="date" name="bataspeminjaman" placeholder="Tanggal wajib kembali..."></div>
					<div class="tombol">
						<div><input type="submit" value="REGISTER" class="iBForm" name="add"></div>
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
	if(isset($_REQUEST['iAdd'])){
		echo "<script>modalOn();</script>";
	}
?>