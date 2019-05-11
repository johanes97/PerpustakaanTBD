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
			include('../../headerAdmin.php');
		?>
		<div class="middle">
			<?php
				include('../../sideAdmin.php');
			?>
			<div class="article">
				<div class="opening"><p id="judul">Welcome to JFA Library!</p></div>
				<div class="main">
					<p id="about">About Us</p>
					<p>JFA Library is a simple Library web where you can download journals for free and search the books you need. Let's give
						the best service to our members. Like all the members, you can download journals and see what's on today's news.
						if there is new administrators, please help them to register (administrators can't do self-register). Dont't
						forget to check our email regularly (click the bell icon) to help our members.
					</p>
				</div>
				<div class="closing">
					<p>&copy; 2019 JFA - eLibrary for Database Technology</p>
				</div>
			</div>
		</div>
	</div>
</body>

</html>