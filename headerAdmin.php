<!DOCTYPE html>

<div class="top">
    <img src="../../img/banner2.jpg" alt="banner" class="gambar">
    <h1 class="judul">eLIBRARY</h1>
</div>

<div class="topNav">
    <?php
        //session_start();
        $nama = $_SESSION['nama'];
        if($nama != null){
            echo "<p id='log'>You are logged in as ".$nama."</p>";
        }
        else{
            header("Location:../general/login.php");
        }
    ?>
    <ul>	
        <li><a href="../general/logout.php" class="symbol"><i class="fa fa-sign-out"></i></a></li>			
        <li><a href="../general/profile.php" class="symbol"><i class="fa fa-user"></i></a></li>
        <li><a href="#bell" class="symbol"><i class="fa fa-bell"></i></a></li>
        <?php
            if(isset($_SESSION['tipe'])){
                $tipe = $_SESSION['tipe'];
                if($tipe=="user_biasa"){
                    echo "<li><a href='../user/usr.php' class='symbol'><i class='fa fa-home'></i></a></li>";
                }
                else{
                    echo "<li><a href='../admin/adm.php' class='symbol'><i class='fa fa-home'></i></a></li>";
                }
			}
        ?>
    </ul>
</div>