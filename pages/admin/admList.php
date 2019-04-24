<!DOCTYPE html>

<?php
	include ('../../OpenConnection.php');
?>

<?php
	$queryShowAnggota="SELECT
						* 
					FROM 
						anggota 
					WHERE 
						tipe = 'admin' ";

	if(isset($_GET['iSearch'])){
		$textInput = $_GET['textInput'];
		$pilihan = $_GET['pilihan'];

		$queryCari="";
		if($pilihan == 'email'){
			$queryCari .= " AND email = '$textInput'";

		}
		else if($pilihan == 'nama'){
			$queryCari .= " AND nama = '$textInput'";

		}
		if($textInput == "") $queryCari="";
		$queryShowAnggota .= $queryCari;
	}
	
	$query = $conn->getQuery();
?>

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
							<option value="email">Email</option>
							<option value="nama">Name</option>
						</select>
						<input id="button" name="iSearch" type="submit" value="SEARCH" class="cari">
						<input id="button2" name="iAdd" type="submit" value="ADD ADM." class="cari">
					</form>
				</div>
				<div class="main">
					<p id="tambahAdmin"></p>
					<table>
						<tr><th>Email</th><th>Name</th>
						<?php
							if($result = $query->query($queryShowAnggota)){
								while($row = $result->fetch_array()){
									echo "<tr>";
									echo "<td>".$row['email']."</td>";
									echo "<td>".$row['nama']."</td>";
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

	<!-- The Modal ini 1 browser-->
	<div id="myModal" class="modal">

		<!-- Modal content kotak yg pop up nya-->
		<div class="modal2-content">
			<fieldset>
				<span onclick="document.getElementById('myModal').style.display='none'" class="close">&times;</span>
				<span id="judulForm">New Administrator</span>
				<form action="">
					<div class="iForm"><input type="text" name="email" placeholder="Email"></div>
					<div class="iForm"><input type="text" name="nama" placeholder="Name"></div>
					<div class="iForm"><input type="password" name="pass" placeholder="Password"></div>
					<div class="iForm"><input type="password" name="coPass" placeholder="Confirm Password"></div>
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
		if(isset($_GET['iAdd'])){
			echo "<script>modalOn();</script>";
		}
		
		if(isset($_GET['add'])){ 
			$email = $_GET['email'];
			$nama = $_GET['nama']; 
			$pass = $_GET['pass'];
			$confirm = $_GET['coPass'];
			$tipe = 'admin';
			
			if($pass != $confirm){
				echo "<p class='hint'>Password and confirm not equal!</p>";
			}

			$queryCek="SELECT * FROM anggota WHERE email = '$email'";
			$resCek = $conn->executeQuery($queryCek);

			if($resCek!=null){				
				echo "<script>document.getElementById('tambahAdmin').innerHTML = 'Email already used, please use another one'</script>";
			}
			else{
				if($email!=""&& $nama!=""){
					$queryInsertAnggota = "INSERT INTO anggota 
						VALUES ('$email','$nama','$pass','$tipe')";
					$conn->executeNonQuery($queryInsertAnggota);

				}
				$info = "Administrator added";
				echo "<script>document.getElementById('tambahAdmin').innerHTML = '$info'</script>";
			}
		}
	?>
</body>

</html>