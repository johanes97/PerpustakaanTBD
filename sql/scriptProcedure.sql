--Procedure untuk sign up (signup.php)
CREATE DEFINER=`root`@`localhost` PROCEDURE `signup`(
	IN emailInput varchar(100),
    IN nameInput varchar(100),
    IN passwordInput varchar(100),
    IN tipeInput varchar(100)
)
BEGIN
	if (select count(email) from anggota where email=emailInput)=0 then 
		insert into anggota values(emailInput,nameInput,passwordInput,tipeInput);
    end if;
END

-- Procedure untuk login (login.php)
CREATE DEFINER=`root`@`localhost` PROCEDURE `login`(
	IN emailInput varchar(100),
    IN sandiInput varchar(100)
)
BEGIN
	if (select count(email) from anggota where email=emailInput and sandi=sandiInput)>0 then 
        select *,1 as 'validEmail',1 as 'validPassword' from anggota where email=emailInput and sandi=sandiInput;
	elseif (select count(email) from anggota where email=emailInput)>0 then 
         select *,1 as 'validEmail',0 as 'validPassword' from anggota where email=emailInput;
    end if;
END

-- ADMIN

-- Procedure untuk menambah buku sekaligus kata, tag, dan pengarangnya
-- (Sudah dibuat sql biasa)

-- Procedure untuk menambah eksemplar

-- Procedure untuk menambah denda
	
-- Procedure untuk mencari nilai IDF setiap kata

-- Procedure untuk menghitung bobot setiap kata berdasarkan IDF-nya

--Procedure untuk mencari semua member (memberlist.php)
CREATE DEFINER=`root`@`localhost` PROCEDURE `semuaanggotabiasa`()
BEGIN
	select
		*
	from
		anggota
	where
		anggota.tipe like 'user_biasa';
END

-- Procedure untuk mencari semua administrator (adminlist.php)
CREATE DEFINER=`root`@`localhost` PROCEDURE `semuadmin`()
BEGIN
	select
		*
	from
		anggota
	where
		anggota.tipe like 'admin';
END

-- Procedure untuk melakukan perpanjangan masa pinjam buku

-- Procedure untuk laporan buku-buku yang sering dipinjam

-- Procedure untuk laporan buku-buku yang sering dipinjam berdasarkan pengarang

-- Procedure untuk laporan tag-tag dari buku-buku yang sering dipinjam.

-- Procedure untuk laporan tag-tag yang sering dipinjam oleh seorang anggota.

-- Procedure untuk laporan rekomendasi buku bagi seorang anggota.






--GENERAL

--BUKU: Mendapatkan daftar seluruh buku beserta pengarang, tag, kata, dan jumlah eksemplar (book.php books.php)(BELUM SELESAI)(BAGIAN TAG MASIH SALAH)
CREATE DEFINER=`root`@`localhost` PROCEDURE `semuabuku`()
BEGIN
	select distinct
		*
	from
		buku
		inner join bukupengarang on buku.idbuku = bukupengarang.idbuku
		inner join pengarang on pengarang.idpengarang = bukupengarang.idpengarang
	where
		buku.deleted = 0;
END

--BUKU: Mencari buku berdasarkan judul, pengarang, atau tag (book.php books.php)(BELUM SELESAI)(BAGIAN TAG MASIH SALAH, BELUM MENGGUNAKAN IDF/BOBOT)
CREATE DEFINER=`root`@`localhost` PROCEDURE `caribuku`(
	IN pilihanpencarian varchar(100),
    IN keyword varchar(100)
)
BEGIN
	set keyword = concat('%',keyword,'%');
	
	if (pilihanpencarian = 'judul') then
		
		select distinct
			*
		from
			buku
			inner join bukupengarang on buku.idbuku = bukupengarang.idbuku
			inner join pengarang on pengarang.idpengarang = bukupengarang.idpengarang
		where
			buku.deleted = 0,
			buku.judulbuku like keyword;
	
	elseif (pilihanpencarian = 'pengarang') then
	
		select distinct
			*
		from
			buku
			inner join bukupengarang on buku.idbuku = bukupengarang.idbuku
			inner join pengarang on pengarang.idpengarang = bukupengarang.idpengarang
		where
			buku.deleted = 0,
			pengarang.namapengarang like keyword;
	
	elseif (pilihanpencarian = 'tag') then
		
		select distinct
			*
		from
			buku;
	
	end if;
END

--BUKU: menghapus buku (Books.php)
CREATE DEFINER=`root`@`localhost` PROCEDURE `hapusbuku`(
	IN idbukudihapus int
)
BEGIN
	delete from bukupengarang
	where idbuku = idbukudihapus;
	
	delete from bukutag
	where idbuku = idbukudihapus;
		
	delete from bukukata
	where idbuku = idbukudihapus;
		
	update eksemplar
	set deleted = 1
	where idbuku = idbukudihapus;
	
	update buku
	set deleted = 1
	where idbuku = idbukudihapus;
END

--PEMESANAN: mendapatkan daftar seluruh pemesanan, dapat berfungsi sebagai laporan (order.php orders.php)
CREATE DEFINER=`root`@`localhost` PROCEDURE `semuapemesanan`()
BEGIN
	select
		*
	from
		buku
		inner join pemesanan on buku.idbuku = pemesanan.idbuku
		inner join anggota on pemesanan.email = anggota.email
	order by
		statuspemesanan desc, tglpemesanan asc;
END

--PEMESANAN: mendapatkan daftar seluruh pemesanan yang masih berstatus WAITING (orders.php)
CREATE DEFINER=`root`@`localhost` PROCEDURE `semuapemesananwaiting`()
BEGIN
	select
		*
	from
		buku
		inner join pemesanan on buku.idbuku = pemesanan.idbuku
		inner join anggota on pemesanan.email = anggota.email
	where
		statuspemesanan like 'WAITING'
	order by
		statuspemesanan desc, tglpemesanan asc;
END

--PEMESANAN: mendapatkan daftar pemesanan anggota yang login (order.php)
CREATE DEFINER=`root`@`localhost` PROCEDURE `caripemesanan`(
	IN emaillogin varchar(100)
)
BEGIN
	select
		*
	from
		buku
		inner join pemesanan on buku.idbuku = pemesanan.idbuku
		inner join anggota on pemesanan.email = anggota.email
	where
		anggota.email like emaillogin
	order by
		statuspemesanan desc, tglpemesanan asc;
END

--PEMESANAN: menambahkan pemesanan sesuai anggota yang login (book.php)
CREATE DEFINER=`root`@`localhost` PROCEDURE `tambahpemesanan`(
	IN emailpemesan varchar(100),
	IN idbukudipesan int
)
BEGIN
	insert into pemesanan(email,idbuku,tglpemesanan,statuspemesanan)
	values (emailpemesan,idbukudipesan,now(),'WAITING');
END

--PEMESANAN: menerima pemesanan anggota (orders.php)
CREATE DEFINER=`root`@`localhost` PROCEDURE `terimapemesanan`(
	IN idpemesananditerima int
)
BEGIN
	update
		pemesanan 
	set
		statuspemesanan = 'ACCEPTED'
	where
		idpemesanan = idpemesananditerima;
END

--PEMINJAMAN: mendapatkan daftar seluruh peminjaman, dapat berfungsi sebagai laporan (borrow.php borrows.php)(BELUM SELESAI)
CREATE DEFINER=`root`@`localhost` PROCEDURE `semuapemesanan`()
BEGIN
	select
		*
	from
		eksemplar
		inner join peminjaman on eksemplar.idbuku = peminjaman.idbuku
		inner join anggota on peminjaman.email = anggota.email
	order by
		bataspengembalian asc;
END

--Procedure untuk mengupdate profil (profil.php)
CREATE DEFINER=`root`@`localhost` PROCEDURE `updateprofil`(
	IN emaillogin varchar(100),
	IN namabaru varchar(100),
	IN sandibaru varchar(100)
)
BEGIN		
	if (namabaru != '') then
		update
			anggota
		set
			nama = namabaru
		where
			email like emaillogin;
	end if;
	
	if (sandibaru != '') then
		update
			anggota
		set
			sandi = sandibaru
		where
			email like emaillogin;
	end if;
END







-- MEMBER

--Procedure untuk mencari rekomendasi buku untuk member

-- Procedure untuk melakukan peminjaman buku dengan judul buku dan eksemplar tertentu.

-- Procedure untuk melakukan pemesanan buku

-- Procedure untuk mencari semua pengembalian buku
-- (Sudah dibuat sql biasa)

-- Procedure untuk mencari semua pemesanan buku
-- (Sudah dibuat sql biasa)

-- Procedure untuk mengingatkan pengembalian buku

-- Procedure menu feedback