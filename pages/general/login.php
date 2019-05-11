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
</head>

<body>
	<div class="isi">
		<div class="top">
			<img src="../../img/banner2.jpg" alt="banner" class="gambar">
			<h1 class="judul">JFA Library</h1>
		</div>
		<fieldset id="fLogin">
			<span id="judulForm">Login</span>
			<form id="idForm" method="post">
				<div class="iForm"><input type="text" name="iEmail" placeholder="Email"></div>
				<div class="iForm"><input type="password" name="iPass" placeholder="Password"></div>
				<div class="tombol">
					<div><input type="submit" value="LOGIN" class="iBForm" name="iLogin"></div>
					<div><input type="submit" value="CANCEL" class="iBForm" name="iCancel"></div>
				</div>
			</form>
		</fieldset>
	</div>
	
	<div id="warning1" class="warning">
		<p>Please enter your email and password</p>
	</div>
	<div id="warning2" class="warning">
		<p>WRONG EMAIL</p>
	</div>
	<div id="warning3" class="warning">
		<p>WRONG PASSWORD</p>
	</div>

	<script>
		var warning1 = document.getElementById('warning1');
		var warning2 = document.getElementById('warning2');
		var warning3 = document.getElementById('warning3');

		function show(){ warning1.style.visibility = 'visible';}
		function show2(){ warning2.style.visibility = 'visible';}
		function show3(){ warning3.style.visibility = 'visible';}
	</script>
</body>

</html>

<?php
    if(isSet($_REQUEST['iLogin'])){
        $email = $_REQUEST['iEmail'];
		$pass = $_REQUEST['iPass'];
		$queryUser = "CALL login('$email','$pass');";
		$resultUser = $conn->executeQuery($queryUser);

		if($email == "" || $pass == ""){
			echo "<script>show()</script>";
		}
		else if($resultUser == null){
            echo "<script>show2()</script>";
		}
		else if($resultUser!=null){
			$emailExist = $resultUser[0]['validEmail'];
			$passwordTrue = $resultUser[0]['validPassword'];

			if($emailExist== 1 && $passwordTrue == 0){
	            echo "<script>show3()</script>";
			}
			else{
				$nama = $resultUser[0]['nama'];
				$tipe = $resultUser[0]['tipe'];
				
				$_SESSION['nama'] = $nama;
				$_SESSION['tipe'] = $tipe;
				$_SESSION['email'] = $email;
				
				if($tipe == "user_biasa"){
					header("Location: ../user/usr.php");
				}
				else{
					header("Location: ../admin/adm.php");
				}
			}
		}
	}
	if(isSet($_REQUEST['iCancel'])){
		header("Location: ../../index.php");
	}
?>