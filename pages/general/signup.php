
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
			<fieldset>
				<span id="judulForm">Create New Account</span>
				<form action="" method="POST">
					<div class="iForm"><input type="text" name="iUsername" placeholder="Username"></div>
					<div class="iForm"><input type="password" name="iPass" placeholder="Password"></div>
					<div class="iForm"><input type="password" name="iCoPass" placeholder="Confirm Password"></div>
					<div class="iForm"><input type="text" name="iName" placeholder="Name"></div>
					<div class="iForm"><input type="date" name="iDate" placeholder="Date Birth"></div>
					<div class="iForm"><input type="text" name="iHP" placeholder="Phone Number"></div>
					<div class="iForm"><input type="text" name="iAddress" placeholder="Address"></div>
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
					echo "<p>You have registered as ".$_POST['iUsername']."</p>";
				?>
				<p>Please login to continue.</p>
				<div class="modal-footer">
					<pre><a href="login.php" id="login">LOGIN</a>  <a href="../../index2.php" id="login">CANCEL</a></pre>
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
	include ('../../OpenConnection.php'); 

	if(isSet($_REQUEST['iRegister']) ){
		$username = $_REQUEST['iUsername']; 
		$pass = $_REQUEST['iPass']; 
		$confirm = $_REQUEST['iCoPass']; 
		$name = $_REQUEST['iName'];
		$birthDate = $_REQUEST['iDate']; 
		$phone = $_REQUEST['iHP']; 
		$almt = $_REQUEST['iAddress']; 
		$role="user_biasa";

		$queryCekUsername ="SELECT 
								* 
							FROM 
								anggota 
							WHERE 
								username = '$username' ";
		if($conn->executeQuery($queryCekUsername) != null){
			echo "<p class='hint'>Username already exists, use another!</p>";
		}
		else if($pass != $confirm){
			echo "<p class='hint'>Password and confirm not equal!</p>";
		}
		else if($username!="" && $pass!="" && $confirm!="" && $name!="" && $birthDate!=NULL && $phone!="" && $almt!=""){
			$query= "INSERT INTO anggota VALUES ('$username', '$name', '$pass',
					'$almt', '$phone', '$birthDate','$role')";
			$conn->executeNonQuery($query);
			echo '<script type="text/javascript">startModal();</script>';
		}
		else{
			echo "<p class='hint'>Please fill it all out!</p>";
		}
	}

	if(isSet($_REQUEST['iCancel']) ){
		header("Location: ../../index2.php");
	}
?>