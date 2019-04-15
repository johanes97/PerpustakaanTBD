<?php
	include ('../../OpenConnection.php'); 
	$queryShowAnggota="SELECT
						* 
					FROM 
						anggota 
					WHERE 
						role = 'admin' ";

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
					<div class="opening2"><p id="judul">Administrator List</p>
						<form class="pilihanCari" action="">
							<input type="text" name="textInput" placeholder="Search member.." class="cari">
							<span class="cari" id="by"><pre> by </pre></span>
							<select name="pilihan" class="cari">
								<option value="id">ID</option>
								<option value="nama">Name</option>
							</select>
							<input id="button" name="iSearch" type="submit" value="SEARCH" class="cari">
							<input id="button2" name="iAdd" type="submit" value="ADD ADM." class="cari">
						</form>
					</div>
					<div class="main">
						<p id="tambahAdmin"></p>
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

		<!-- The Modal ini 1 browser-->
		<div id="myModal" class="modal">

			<!-- Modal content kotak yg pop up nya-->
			<div class="modal2-content">
				<fieldset>
					<span onclick="document.getElementById('myModal').style.display='none'" class="close">&times;</span>
					<span id="judulForm">New Administrator</span>
					<form action="">
						<div class="iForm"><input type="text" name="username" placeholder="Username"></div>
						<div class="iForm"><input type="text" name="nama" placeholder="Name"></div>
						<div class="iForm"><input type="date" name="tglLahir" placeholder="Birth Date"></div>
						<div class="iForm"><input type="text" name="nohp" placeholder="Phone"></div>
						<div class="iForm"><input type="text" name="alamat" placeholder="Address"></div>
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

		<?php
			function generatePass($length=8){
				$characters = '0a1q2E3p4hbK56F7ec8L9idUMoxyNgzXAnBCwrfDYTGsvkHItJOhPQujmRlVWSZ';
				$charactersLength = strlen($characters);
				$randomString = '';
				for($i = 0; $i < $length; $i++){
					$randomString .= $characters[rand(0,$charactersLength - 1)];
				}
				return $randomString;
			}

			if(isset($_GET['iAdd'])){
				echo "<script>modalOn();</script>";
			}
			if(isset($_GET['add'])){ 
				$password=generatePass();
				$username = $_GET['username']; $name = $_GET['nama']; 
				$tglLahir = $_GET['tglLahir'];$nohp = $_GET['nohp']; $alamat = $_GET['alamat'];

				$queryCek="SELECT * FROM anggota WHERE username = '$username'";
				$resCek = $conn->executeQuery($queryCek);

				if($resCek!=null){				
					echo "<script>document.getElementById('tambahAdmin').innerHTML = 'Username not available, please try again'</script>";
				}
				else{
					if($username!=""&& $name!="" && $tglLahir!="" && $nohp!="" &&$alamat!=""){
						$queryInsertAnggota = "INSERT INTO anggota 
							VALUES (NULL,'$username','$name','$password', '$alamat', $nohp, '$tglLahir','admin')";
						$conn->executeNonQuery($queryInsertAnggota);
	
					}
					$info = "Administrator added, temporary password: ".$password.". Please change it immediately.";
					echo "<script>document.getElementById('tambahAdmin').innerHTML = '$info'</script>";
				}
			}
		?>
	</body>
</html>