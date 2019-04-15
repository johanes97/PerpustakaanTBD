<?php
	include ('../../OpenConnection.php'); 
	$queryShowAnggota="SELECT
						* 
					FROM 
						anggota 
					WHERE 
						role = 'user_biasa' ";

	if(isset($_GET['iSearch'])){
		$textInput = $_GET['textInput'];
		$pilihan = $_GET['pilihan'];

		$queryCari="";
		if($pilihan == 'id'){
			$queryCari .= " AND id_anggota = '$textInput'";

		}
		else if($pilihan == 'nama'){
			$queryCari .= " AND nama_anggota = '$textInput'";

		}
		if($textInput == "") $queryCari="";
		$queryShowAnggota .= $queryCari;
	}
	
	$query = $conn->getQuery();
?>
<!DOCTYPE html>
<html>
	<head>
		<title>eLibrary</title>
		<meta name="viewport" content="width=device-width, initial-scale=1">
		<link rel="stylesheet" href="../../style/style.css">
		<link rel="stylesheet" href="../../lib/font-awesome.min.css">
		<link rel="stylesheet" href="../../lib/font-awesome.css">
	</head>
	<body class="w3-theme-d5">
	<div class="isi">
			<?php
				session_start();
				include ('../../headerAdmin.php');
			?>
			<div class="middle">
				<?php
					include ('../../sideAdmin.php');
				?>
				<div class="article">
					<div class="opening2"><p id="judul">Member List</p>
						<form class="pilihanCari" action="">
							<input type="text" name="textInput" placeholder="Search member.." class="cari">
							<span class="cari" id="by"><pre> by </pre></span>
							<select name="pilihan" class="cari">
								<option value="id">ID</option>
								<option value="nama">Name</option>
							</select>
							<input id="button" name="iSearch" type="submit" value="SEARCH" class="cari">
						</form>
					</div>
					<div class="main">
						<table>
							<tr><th>ID</th><th>Name</th><th>Phone</th><th>Address</th>
							<?php
								if($result = $query->query($queryShowAnggota)){
									while($row = $result->fetch_array()){
										echo "<tr>";
										echo "<td>".$row['id_anggota']."</td>";
										echo "<td>".$row['nama_anggota']."</td>";
										echo "<td>".$row['no_hp']."</td>";
										echo "<td>".$row['alamat']."</td>";
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
