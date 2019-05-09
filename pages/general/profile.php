<!DOCTYPE html>

<?php  
	include ('../../OpenConnection.php');
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
			session_start();
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
		$nama = $_REQUEST['iName'];
		$email = $_SESSION['email'];
		$pass = $_REQUEST['iPass'];
		$confirm = $_REQUEST['iCoPass']; 
		$tipe = "user_biasa";		
		
		if($pass != $confirm){
			echo "<script>show()</script>";
		}
		else{
			$ganti = false;
			if($pass != ""){
				$queryUpdate = "UPDATE anggota SET password = '$pass' WHERE email = '$email'";
				$conn->executeNonQuery($queryUpdate);
				$ganti=true;
			}
			if($nama !=""){
				$queryUpdate = "UPDATE anggota SET nama = '$nama' WHERE email = '$email'";
				$conn->executeNonQuery($queryUpdate);
				$ganti=true;
				$_SESSION['nama']=$nama;
				$tempText ="You are logged in as ".$nama;
				$tempText2=" Name: ".$nama;
				echo "<script>document.getElementById('log').innerHTML='$tempText'</script>";
				echo "<script>document.getElementById('namaForm').innerHTML='$tempText2'</script>";				
			}
			if($ganti==true){
				$print= "<p id='pUpdate' class='updated'>Profile Updated";
			}
			if($pass!=""){
				$print.="<br><span id='spanUpdate'>Please use your new password for the next login.</span></p>";
			}
			else{
				$print.="</p>";
			}
			echo $print;
		}
	}
?>