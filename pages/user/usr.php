<?php
	include ('../../OpenConnection.php'); 	
?>
<!DOCTYPE html>
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
				include ('../../header.php');
			?>
			<div class="middle">
				<?php
					include ('../../side.php');
				?>
				<div class="article">
					<div class="opening"><p id="judul">Welcome to eLibrary!</p></div>
					<div class="main">
						<p id="about">About Us</p>
						<p>eLibrary is a simple Library web where you can download journals for free and search the books you need. You were
							automatically registered as a member when you sign up. Look for the books you need in the book list before you come
							to our library and borrow the books. We also provide you with today's news, just click the newspaper icon.
							If you have any question, please contact us by e-mail (click the message icon).
						</p>
					</div>
					<div class="closing">
						<p>&copy; 2016 Maria Veronica - eLibrary fow Web Based Programming</p>
					</div>
				</div>
			</div>
		</div>
	</body>
</html>