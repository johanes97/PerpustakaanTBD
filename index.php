<!DOCTYPE html>

<?php
	include ('OpenConnection.php');
	session_start();
	$query = $conn->getQuery();
	
	//Redirect jika telah login
	if(isset($_SESSION['email'])){
		$tipepengguna = $_SESSION['tipe'];
		
		if($tipepengguna == "user_biasa"){
			header("Location: pages/user/usr.php");
		}
		else{
			header("Location: pages/admin/adm.php");
		}
	}
?>

<html>

<head>
	<title>eLibrary</title>
	<meta name="viewport" content="width=device-width, initial-scale=1">
	<!-- OPTIONAL -->
	<link rel="stylesheet" href="style/style.css">
</head>

<body>
	<div class="isi">
		<div class="top">
			<img src="img/banner.jpg" alt="banner">
			<h1 id="library">eLIBRARY</h1>
		</div>
		<div class="bottom">
			<div class="nButton">
				<div class="button"><a href="pages/general/signup.php">SIGN UP</a></div>
				<div class="button"><a href="pages/general/login.php">LOGIN</a></div>
			</div>
		</div>
	</div>
</body>

</html>