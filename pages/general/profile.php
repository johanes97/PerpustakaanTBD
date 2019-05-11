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
	<!-- OPTIONAL -->
	<link rel="stylesheet" href="../../style/style.css">
	<link rel="stylesheet" href="../../lib/font-awesome.min.css">
	<link rel="stylesheet" href="../../lib/font-awesome.css">
</head>

<body>
	<div class="isi">
		<?php
			if($_SESSION['tipe'] !='user_biasa'){
				include ('../../headerAdmin.php');
			}
			else{
				include ('../../header.php');
			}
		?>
		<div class="middle">
			<?php
				if($_SESSION['tipe']!='user_biasa'){
					include ('../../sideAdmin.php');
				}
				else{
					include ('../../side.php');
				}
			?>
			<div class="article">
				<div class="opening"><p id="judul">Profile</p></div>
				<img src="../../img/profile.jpg" alt="profil" id="profil">
				<div id="user">
					<button id="uUser" onclick="startModal()">UPDATE USER INFO</button>
				</div>
				<div class="closing">
					<p>&copy; 2019 JFA - eLibrary for Database Technology</p>
				</div>
			</div>
		</div>
	</div>

	<!-- The Modal -->
	<div id="myModal" class="modal">
		<!-- Modal content -->
		<fieldset class="modal2-content">
			<span onclick="document.getElementById('myModal').style.display='none'" class="close">&times;</span>
			<span id="judulForm">Update User Info</span>
			<?php
				echo "<pre><p id='namaForm'> Name: ".$nama."</p></pre>";
			?>
			<form action="" method="POST">
				<div class="iForm"><input type="text" name="iName" placeholder="Name"></div>
				<div class="iForm"><input type="password" name="iPass" placeholder="Password"></div>
				<div class="iForm"><input type="password" name="iCoPass" placeholder="Confirm Password"></div>
				<p>Kosongkan yang tidak ingin diubah</p>
				<div class="tombol">
					<div><input type="submit" value="UPDATE" class="iBForm" name="iUpdate"></div>
				</div>
			</form>
		</fieldset>
	</div>
	<p style="float:left" id="warningProfil" class="warning">Password confirmation doesn't match</p>

	<script>
		var warning = document.getElementById('warningProfil');
		function show(){ warning.style.visibility = 'visible';}

		var modal = document.getElementById('myModal');

		function startModal(){ //console.log('Masuk');
			modal.style.display = 'block';
		}
	</script>
</body>

</html>

<?php
	if(isSet($_REQUEST['iUpdate']) ){
		$emaillogin = $_SESSION['email'];
		$namabaru = $_REQUEST['iName'];
		$sandibaru = $_REQUEST['iPass'];
		$confirmsandi = $_REQUEST['iCoPass'];
		
		$berubah = false;
		
		if($sandibaru != $confirmsandi){
			echo "<script>show()</script>";
		}
		else{
			$queryupdateanggota = "CALL updateanggota('$emaillogin','$namabaru','$sandibaru');";
			$conn->executeNonQuery($queryupdateanggota);
			$berubah=true;
			
			if($namabaru != ""){
				$_SESSION['nama'] = $namabaru;
			}
			if($berubah == true){
				echo "<p id='pUpdate' class='updated'>Profile Updated!</p>";
			}
		}
	}
?>