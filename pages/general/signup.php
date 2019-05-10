<!DOCTYPE html>

<?php
	include ('../../OpenConnection.php'); 
	session_start();
	$query = $conn->getQuery();
?>

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
		<fieldset>
			<span id="judulForm">Create New Account</span>
			<form action="" method="POST">
				<div class="iForm"><input type="text" name="iEmail" placeholder="Email"></div>
				<div class="iForm"><input type="text" name="iName" placeholder="Name"></div>
				<div class="iForm"><input type="password" name="iPass" placeholder="Password"></div>
				<div class="iForm"><input type="password" name="iCoPass" placeholder="Confirm Password"></div>
				<div class="tombol">
					<div><input type="submit" value="REGISTER" class="iBForm" name="iRegister"></div>
					<div><input type="submit" value="CANCEL" class="iBForm" name="iCancel"></div>
				</div>
			</form>
		</fieldset>
	</div>

	<!-- The Modal ini 1 browser-->
	<div id="myModal" class="modal">
		<!-- Modal content kotak yg pop up nya-->
		<div class="modal-content">
			<?php
				echo "<p>You have registered as ".$_POST['iEmail']."</p>";
			?>
			<p>Please login to continue.</p>
			<div class="modal-footer">
				<pre><a href="login.php" id="login">LOGIN</a>  <a href="../../index.php" id="login">CANCEL</a></pre>
			</div>
		</div>
	</div>

	<script>
		var modal = document.getElementById('myModal');

		function startModal(){ //console.log('Masuk');
			modal.style.display = 'block';
		}
	</script>
</body>

</html>

<?php  
	if(isSet($_REQUEST['iRegister']) ){
		$email = $_REQUEST['iEmail'];
		$nama = $_REQUEST['iName'];
		$pass = $_REQUEST['iPass']; 
		$confirm = $_REQUEST['iCoPass'];

		$querySignUp ="CALL tambahanggota('$email','$nama','$pass','user_biasa')";
		$queryCekEmail = "CALL login('$email','$pass')";

		if($conn->executeQuery($queryCekEmail) != null){
			echo "<p class='hint'>Email already used,</p>
			<br><p class='hint'>please use another!</p>";
		}
		else if($pass != $confirm){
			echo "<p class='hint'>Password and confirm not equal!</p>";
		}
		else if($email!="" && $nama!="" && $pass!="" && $confirm!=""){
			$conn->executeNonQuery($querySignUp);
			echo '<script type="text/javascript">startModal();</script>';
		}
		else{
			echo "<p class='hint'>Please fill it all out!</p>";
		}
	}

	if(isSet($_REQUEST['iCancel']) ){
		header("Location: ../../index.php");
	}
?>