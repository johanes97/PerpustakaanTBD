-- Procedure untuk sign up
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

-- Procedure untuk login
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

-- Procedure untuk mencari semua member
-- (Sudah dibuat sql biasa)

-- Procedure untuk mencari semua administrator

-- Procedure untuk melakukan perpanjangan masa pinjam buku

-- Procedure untuk laporan buku-buku yang sering dipinjam

-- Procedure untuk laporan buku-buku yang sering dipinjam berdasarkan pengarang

-- Procedure untuk laporan tag-tag dari buku-buku yang sering dipinjam.

-- Procedure untuk laporan tag-tag yang sering dipinjam oleh seorang anggota.

-- Procedure untuk laporan rekomendasi buku bagi seorang anggota.



--GENERAL
--BUKU: Mendapatkan daftar seluruh buku beserta pengarang, tag, kata, dan jumlah eksemplar (SUDAH DI SOURCE CODE)(BELUM SELESAI)
CREATE DEFINER=`root`@`localhost` PROCEDURE `semuabuku`()
BEGIN
	select distinct
		*
	from
		buku
		inner join bukupengarang on buku.idbuku = bukupengarang.idbuku
		inner join pengarang on pengarang.idpengarang = bukupengarang.idpengarang;
END

--BUKU: Mencari buku berdasarkan judul, pengarang, atau tag (BELUM SELESAI)(BAGIAN TAG MASIH SALAH)
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
			buku.judulbuku like keyword;
	
	elseif (pilihanpencarian = 'pengarang') then
	
		select distinct
			*
		from
			buku
			inner join bukupengarang on buku.idbuku = bukupengarang.idbuku
			inner join pengarang on pengarang.idpengarang = bukupengarang.idpengarang
		where
			pengarang.namapengarang like keyword;
	
	elseif (pilihanpencarian = 'tag') then
		
		select distinct
			*
		from
			buku;
	
	end if;
END

--PEMESANAN: mendapatkan daftar seluruh pemesanan (SUDAH DI SOURCE CODE)
CREATE DEFINER=`root`@`localhost` PROCEDURE `semuapemesanan`()
BEGIN
	select
		*
	from
		buku
		inner join pemesanan on buku.idbuku = pemesanan.idbuku
		inner join anggota on pemesanan.email = anggota.email
	order by
		tglpemesanan asc;
END

--PEMESANAN: mendapatkan daftar pemesanan anggota yang login (SUDAH DI SOURCE CODE)
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
		tglpemesanan asc;
END

-- Procedure untuk laporan history peminjaman buku.

-- Procedure untuk laporan history pemesanan buku.

-- Procedure untuk mengupdate profil
-- (Sudah dibuat sql biasa)



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