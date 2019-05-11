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
	<link rel="stylesheet" href="../../lib/w3.css">
	<link rel="stylesheet" href="../../lib/w3-theme-riverside.css">
	<link rel="stylesheet" href="../../style/style.css">
</head>

<body>
	<div class="isi">
		<div class="top">
			<img src="../../img/banner.jpg" alt="banner">
			<h1>eLIBRARY</h1>
		</div>
		<p id="signout"><b>You have succesfully logged out.</b></p>
		<div class="bottom">
			<div class="nButton">
				<div class="button"><a href="signup.php">SIGN UP</a></div>
				<div class="button"><a href="login.php">LOGIN</a></div>
			</div>
		</div>
	</div>
</body>

</html>

<?php
	session_unset();
	session_destroy();
?>