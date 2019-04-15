<!DOCTYPE html>
<html>
	<head>
		<title>eLibrary</title>
		<meta name="viewport" content="width=device-width, initial-scale=1">
		<!-- OPTIONAL -->
		<link rel="stylesheet" href="../../style/style.css">
	</head>
	<body>
		<div class="isi">
			<div class="top">
				<img src="../../img/banner2.jpg" alt="banner" class="gambar">
				<h1 class="judul">eLIBRARY</h1>
			</div>
			<fieldset id="fLogin">
				<span id="judulForm">Login</span>
				<form id="idForm" method="post">
					<div class="iForm"><input type="text" name="iUsername" placeholder="Username"></div>
					<div class="iForm"><input type="password" name="iPass" placeholder="Password"></div>
					<div class="tombol">
						<div><input type="submit" value="LOGIN" class="iBForm" name="iLogin"></div>
						<div><input type="submit" value="CANCEL" class="iBForm" name="iCancel"></div>
					</div>
				</form>
			</fieldset>
		</div>
		
		<div id="warning1" class="warning">
			<p>Please enter your username and password</p>
		</div>
		<div id="warning2" class="warning">
			<p>WRONG USERNAME</p>
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
	include ('../../OpenConnection.php'); 

    if(isSet($_REQUEST['iLogin'])){
        $userN = $_REQUEST['iUsername']; $pass = $_REQUEST['iPass'];
		$queryUser = "SELECT * FROM anggota WHERE username='$userN' ";
		$queryPass = "SELECT * FROM anggota WHERE username='$userN' and password='$pass' ";

		$resultUser = $conn->executeQuery($queryUser);
		$resultPass = $conn->executeQuery($queryPass);

		if($userN == "" || $pass == ""){
			echo "<script>show()</script>";
		}
        else if($resultUser == null){
            echo "<script>show2()</script>";
        }
        else if($resultUser != null && $resultPass == null){
            echo "<script>show3()</script>";
		}
		else{
			session_start();
			$_SESSION['username']=$userN;

			$nama = $resultUser[0]['nama_anggota'];
			$peran = $resultUser[0]['role'];
			$_SESSION['name']=$nama;
			$_SESSION['role']=$peran;
			if($peran == "user_biasa"){
				header("Location: ../user/usr.php?username=$userN ");
			}
			else{
				header("Location: ../admin/adm.php?username=$userN ");
			}
		}
	}
	if(isSet($_REQUEST['iCancel'])){
		header("Location: ../../index2.php");
	}
?>