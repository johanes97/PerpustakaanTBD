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
			if($_SESSION['tipe'] != 'user_biasa'){
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
				<div class="opening"><p id="judul">Free Journals</p></div>
				<div class="main" id="mainjournal">
					<a href="../../files/JOURNAL1.pdf" target="_blank">
						<p class="jurnal">Journal 1</p>
						<p class="writer">Writer 1</p>
						<p class="isijournal">Lorem ipsum dolor, sit amet consectetur adipisicing elit. 
							Dolor eligendi vitae cum, aut modi sint dicta alias reiciendis 
							voluptatibus repellendus aspernatur ipsum eaque quibusdam eum? 
							Ipsam odio dignissimos suscipit non?
						</p>
					</a>
					<a href="../../files/JOURNAL2.pdf" target="_blank">
						 <p class="jurnal">Journal 2</p>
						<p class="writer">Writer 2</p>
						<p class="isijournal">Lorem ipsum dolor, sit amet consectetur adipisicing elit. 
							Dolor eligendi vitae cum, aut modi sint dicta alias reiciendis 
							voluptatibus repellendus aspernatur ipsum eaque quibusdam eum? 
							Ipsam odio dignissimos suscipit non?
						</p>
					</a>
					<a href="../../files/JOURNAL3.pdf" target="_blank">
						<p class="jurnal">Journal 3</p>
						<p class="writer">Writer 3</p>
						<p class="isijournal">Lorem ipsum dolor, sit amet consectetur adipisicing elit. 
							Dolor eligendi vitae cum, aut modi sint dicta alias reiciendis 
							voluptatibus repellendus aspernatur ipsum eaque quibusdam eum? 
							Ipsam odio dignissimos suscipit non?
						</p>
					</a>
				</div>
				<div class="closing">
					<p>&copy; 2019 JFA - eLibrary for Database Technology</p>
				</div>
			</div>
		</div>
	</div>
</body>

</html>