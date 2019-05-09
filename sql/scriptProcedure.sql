--SEMUA DELIMITER //






--BUKU

--BUKU: Mendapatkan daftar seluruh buku beserta pengarang, tag, kata, dan jumlah eksemplar (book.php books.php)(BELUM SELESAI)(BAGIAN TAG MASIH SALAH)
CREATE DEFINER=`root`@`localhost` PROCEDURE `semuabuku`()
BEGIN
	select distinct *
	from bukupengarang
		inner join buku on buku.idbuku = bukupengarang.idbuku
		inner join pengarang on pengarang.idpengarang = bukupengarang.idpengarang
	where buku.deleted = 0;
END //

--BUKU: Mencari buku berdasarkan judul, pengarang, atau tag (book.php books.php)(BELUM SELESAI)(BAGIAN TAG MASIH SALAH, BELUM MENGGUNAKAN IDF/BOBOT)
CREATE DEFINER=`root`@`localhost` PROCEDURE `caribuku`(
	IN pilihanpencarian varchar(100),
    IN keyword varchar(100)
)
BEGIN
	set keyword = concat('%',keyword,'%');
	
	if (pilihanpencarian = 'judul') then
		
		select distinct *
		from bukupengarang
			inner join buku on buku.idbuku = bukupengarang.idbuku
			inner join pengarang on pengarang.idpengarang = bukupengarang.idpengarang
		where buku.deleted = 0 && buku.judulbuku like keyword;
	
	elseif (pilihanpencarian = 'pengarang') then
	
		select distinct *
		from bukupengarang
			inner join buku on buku.idbuku = bukupengarang.idbuku
			inner join pengarang on pengarang.idpengarang = bukupengarang.idpengarang
		where buku.deleted = 0 && pengarang.namapengarang like keyword;
	
	elseif (pilihanpencarian = 'tag') then
		
		select distinct *
		from buku;
	
	end if;
END //

--BUKU: menghapus buku berdasarkan id buku (Books.php)(TESTED)
CREATE DEFINER=`root`@`localhost` PROCEDURE `hapusbuku`(
	IN idbukudihapus int
)
BEGIN
	delete from pemesanan
	where pemesanan.idbuku = idbukudihapus;
	
	delete from bukupengarang
	where bukupengarang.idbuku = idbukudihapus;
	
	delete from bukutag
	where bukutag.idbuku = idbukudihapus;
		
	delete from bukukata
	where bukukata.idbuku = idbukudihapus;
		
	update eksemplar
	set deleted = 1
	where ekssemplar.idbuku = idbukudihapus;
	
	update buku
	set deleted = 1
	where buku.idbuku = idbukudihapus;
END //










--PEMESANAN (SELESAI)

--PEMESANAN: Mendapatkan daftar seluruh pemesanan, baik untuk anggota yang login maupun admin (order.php orders.php)(TESTED)
CREATE DEFINER=`root`@`localhost` PROCEDURE `semuapemesanan`(
	IN statusdicari varchar(100),
	IN emaillogin varchar(100)
)
BEGIN
	if (emaillogin not like '') then
		
		select *
		from pemesanan
			inner join buku on buku.idbuku = pemesanan.idbuku
			inner join anggota on pemesanan.email = anggota.email
		where anggota.email like emaillogin && pemesanan.statuspemesanan like statusdicari
		order by pemesanan.statuspemesanan desc, pemesanan.tglpemesanan asc;
		
	else
	
		select *
		from pemesanan
			inner join buku on buku.idbuku = pemesanan.idbuku
			inner join anggota on pemesanan.email = anggota.email
		where pemesanan.statuspemesanan like statusdicari
		order by pemesanan.statuspemesanan desc, pemesanan.tglpemesanan asc;
		
	end if;
END //

--PEMESANAN: Mencari daftar pemesanan, baik untuk anggota yang login maupun admin (order.php orders.php)(TESTED)
CREATE DEFINER=`root`@`localhost` PROCEDURE `caripemesanan`(
	IN pilihanpencarian varchar(100),
	IN keyword varchar(100),
	IN statusdicari varchar(100),
	IN emaillogin varchar(100)
)
BEGIN
	set keyword = concat('%',keyword,'%');

	if (emaillogin not like '') then
		
		select *
		from pemesanan
			inner join buku on buku.idbuku = pemesanan.idbuku
			inner join anggota on pemesanan.email = anggota.email
		where pemesanan.statuspemesanan like statusdicari && anggota.email like emaillogin && buku.judulbuku like keyword
		order by statuspemesanan desc, tglpemesanan asc;
		
	else
	
		if (pilihanpencarian like 'buku') then
		
			select *
			from pemesanan
				inner join buku on buku.idbuku = pemesanan.idbuku
				inner join anggota on pemesanan.email = anggota.email
			where pemesanan.statuspemesanan like statusdicari && buku.judulbuku like keyword
			order by statuspemesanan desc, tglpemesanan asc;
		
		elseif (pilihanpencarian like 'anggota') then
		
			select *
			from pemesanan
				inner join buku on buku.idbuku = pemesanan.idbuku
				inner join anggota on pemesanan.email = anggota.email
			where pemesanan.statuspemesanan like statusdicari && anggota.nama like keyword
			order by statuspemesanan desc, tglpemesanan asc;
			
		end if;
	
	end if;
END //

--PEMESANAN: menambahkan pemesanan anggota yang login (book.php)(TESTED)
CREATE DEFINER=`root`@`localhost` PROCEDURE `tambahpemesanan`(
	IN emailpemesan varchar(100),
	IN idbukudipesan int
)
BEGIN
	insert into pemesanan(email,idbuku,tglpemesanan,statuspemesanan)
	values (emailpemesan,idbukudipesan,now(),'WAITING');
END //

--PEMESANAN: menerima pemesanan anggota (orders.php)(TESTED)
CREATE DEFINER=`root`@`localhost` PROCEDURE `terimapemesanan`(
	IN idpemesananditerima int
)
BEGIN
	update pemesanan 
	set statuspemesanan = 'ACCEPTED'
	where idpemesanan = idpemesananditerima;
END //

--PEMESANAN: menghapus pemesanan anggota yang login (order.php)(TESTED)
CREATE DEFINER=`root`@`localhost` PROCEDURE `hapuspemesanan`(
	IN idpemesanandihapus int
)
BEGIN
	delete from pemesanan
	where idpemesanan = idpemesanandihapus;
END //









--PEMINJAMAN

--PEMINJAMAN: Mendapatkan seluruh peminjaman, baik untuk anggota yang login maupun admin (borrow.php borrows.php)(TESTED)
CREATE DEFINER=`root`@`localhost` PROCEDURE `semuapeminjaman`(
	IN statusdicari varchar(100),
	IN emaillogin varchar(100)
)
BEGIN
	if (emaillogin not like '') then
	
		select *
		from peminjaman
			inner join anggota on anggota.email = peminjaman.email
			inner join eksemplar on eksemplar.ideksemplar = peminjaman.ideksemplar
			inner join buku on buku.idbuku = eksemplar.idbuku
			inner join bukupengarang on bukupengarang.idbuku = buku.idbuku
			inner join pengarang on pengarang.idpengarang = bukupengarang.idpengarang
		where peminjaman.email like emaillogin && peminjaman.statuspeminjaman like statusdicari
		order by peminjaman.bataspengembalian asc;
	
	else
	
		select *
		from peminjaman
			inner join anggota on anggota.email = peminjaman.email
			inner join eksemplar on eksemplar.ideksemplar = peminjaman.ideksemplar
			inner join buku on buku.idbuku = eksemplar.idbuku
			inner join bukupengarang on bukupengarang.idbuku = buku.idbuku
			inner join pengarang on pengarang.idpengarang = bukupengarang.idpengarang
		where peminjaman.statuspeminjaman like statusdicari
		order by peminjaman.bataspengembalian asc;
	
	end if;
END //

--PEMINJAMAN: Menghitung denda (prosedur-semuapeminjaman)
CREATE DEFINER=`root`@`localhost` PROCEDURE `updatepeminjaman`()
BEGIN
	declare cursorpeminjaman cursor for
	select peminjaman.idpeminjaman, peminjaman.bataspengembalian
	from peminjaman;
	
	declare flagfinished int default 0;
	declare continue handler for not found set flagfinished = 1;
	
	declare vrbidpeminjaman int;
	declare vrbbataspengembalian date;
	
	open cursorpeminjaman;
	
		get_variabel: loop
			
			fetch cursorpeminjaman
			into vrbidpeminjaman, vrbbataspengembalian;
			
			if (flagfinished = 1) then
				leave get_variabel;
			end if;
	
			declare dateinterval int;
			set dateinterval = datediff(vrbbataspengembalian,curdate());
			
			if (dateinterval < 0) then
	
				update peminjaman
				set peminjaman.durasihariterlambat = abs(dateinterval)
				where peminjaman.idpeminjaman = vrbidpeminjaman;
				
				update peminjaman
				set peminjaman.besardenda = 1000*abs(dateinterval)
				where peminjaman.idpeminjaman = vrbidpeminjaman;
				
			end if;
	
		end loop get_variabel;
	
	close cursorpeminjaman;
END //

--PEMINJAMAN: Mencari seluruh peminjaman (borrows.php)
CREATE DEFINER=`root`@`localhost` PROCEDURE `caripeminjaman`(
	IN pilihanpencarian varchar(100),
	IN keyword varchar(100),
	IN statusdicari varchar(100)
)
BEGIN
	set keyword = concat('%',keyword,'%');

	if (pilihanpencarian like '') then
	
		select *
		from peminjaman
			inner join anggota on anggota.email = peminjaman.email
			inner join eksemplar on eksemplar.ideksemplar = peminjaman.ideksemplar
			inner join buku on buku.idbuku = eksemplar.idbuku
			inner join bukupengarang on bukupengarang.idbuku = buku.idbuku
			inner join pengarang on pengarang.idpengarang = bukupengarang.idpengarang
		where peminjaman.email like emaillogin && peminjaman.statuspeminjaman like statusdicari
		order by peminjaman.bataspengembalian asc;
	
	elseif (pilihanpencarian like '') then
	
		select *
		from peminjaman
			inner join anggota on anggota.email = peminjaman.email
			inner join eksemplar on eksemplar.ideksemplar = peminjaman.ideksemplar
			inner join buku on buku.idbuku = eksemplar.idbuku
			inner join bukupengarang on bukupengarang.idbuku = buku.idbuku
			inner join pengarang on pengarang.idpengarang = bukupengarang.idpengarang
		where peminjaman.statuspeminjaman like statusdicari
		order by peminjaman.bataspengembalian asc;
	
	end if;
END //

--PEMINJAMAN: Menambahkan peminjaman (borrows.php)(TESTED)
CREATE DEFINER=`root`@`localhost` PROCEDURE `tambahpeminjaman`(
	IN emailpeminjam varchar(100),
	IN idbukudipinjam int,
	IN bataspeminjaman date
)
BEGIN
	declare ideksemplardipinjam int;
	
	select eksemplar.ideksemplar
	into ideksemplardipinjam
	from eksemplar
		inner join buku on buku.idbuku = eksemplar.idbuku
	where buku.idbuku = idbukudipinjam;
	
	insert into peminjaman(email,ideksemplar,tglpeminjaman,bataspengembalian,durasihariterlambat,besardenda,statuspeminjaman)
	values (emailpeminjam,ideksemplardipinjam,now(),bataspeminjaman,0,0,'ACTIVE');
END //

--PEMINJAMAN: Menghapus peminjaman (borrows.php)(TESTED)
CREATE DEFINER=`root`@`localhost` PROCEDURE `hapuspeminjaman`(
	IN idpeminjamandihapus int
)
BEGIN
	update peminjaman
	set peminjaman.statuspeminjaman = 'INACTIVE'
	where peminjaman.idpeminjaman = idpeminjamandihapus;
	
	update peminjaman
	set peminjaman.tglpengembalian = now()
	where peminjaman.idpeminjaman = idpeminjamandihapus;
END //














--ANGGOTA (SELESAI)

--ANGGOTA: Mencari semua anggota berdasarkan tipe (memberlist.php adminlist.php)(TESTED)
CREATE DEFINER=`root`@`localhost` PROCEDURE `semuaanggota`(
	IN tipeanggota varchar(50)
)
BEGIN
	select *
	from anggota
	where anggota.tipe like tipeanggota;
END //

--ANGGOTA: Mencari anggota berdasarkan email atau nama, biasa atau admin (memberlist.php adminlist.php)(TESTED)
CREATE DEFINER=`root`@`localhost` PROCEDURE `carianggota`(
	IN pilihanpencarian varchar(100),
	IN keyword varchar(100),
	IN tipedicari varchar(100)
)
BEGIN
	set keyword = concat('%',keyword,'%');

	if (pilihanpencarian like 'email') then
	
		select *
		from anggota
		where anggota.tipe like tipedicari && anggota.email like keyword;
	
	elseif (pilihanpencarian like 'nama') then
	
		select *
		from anggota
		where anggota.tipe like tipedicari && anggota.nama like keyword;
	
	end if;
END //

--ANGGOTA: Procedure untuk login (login.php)(TESTED)
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
END //

--ANGGOTA: Menambah anggota (signup.php)(TESTED)
CREATE DEFINER=`root`@`localhost` PROCEDURE `tambahanggota`(
	IN emailInput varchar(100),
    IN nameInput varchar(100),
    IN passwordInput varchar(100),
    IN tipeInput varchar(100)
)
BEGIN
	if (select count(email) from anggota where email=emailInput)=0 then 
		insert into anggota values(emailInput,nameInput,passwordInput,tipeInput);
    end if;
END //

--ANGGOTA: Procedure untuk mengupdate profil (profil.php)(TESTED)
CREATE DEFINER=`root`@`localhost` PROCEDURE `updateanggota`(
	IN emaillogin varchar(100),
	IN namabaru varchar(100),
	IN sandibaru varchar(100)
)
BEGIN		
	if (namabaru not like '') then
		
		update anggota
		set nama = namabaru
		where email like emaillogin;
	
	end if;
	
	if (sandibaru not like '') then
	
		update anggota
		set sandi = sandibaru
		where email like emaillogin;
	
	end if;
END //







-- Procedure untuk menambah eksemplar

-- Procedure untuk menambah denda

-- Procedure untuk mencari nilai IDF setiap kata

-- Procedure untuk menghitung bobot setiap kata berdasarkan IDF-nya

-- Procedure untuk laporan buku-buku yang sering dipinjam

-- Procedure untuk laporan buku-buku yang sering dipinjam berdasarkan pengarang

-- Procedure untuk laporan tag-tag dari buku-buku yang sering dipinjam.

-- Procedure untuk laporan tag-tag yang sering dipinjam oleh seorang anggota.

-- Procedure untuk laporan rekomendasi buku bagi seorang anggota.

--Procedure untuk mencari rekomendasi buku untuk member

-- Procedure untuk melakukan peminjaman buku dengan judul buku dan eksemplar tertentu.

-- Procedure untuk mengingatkan pengembalian buku

-- Procedure menu feedback