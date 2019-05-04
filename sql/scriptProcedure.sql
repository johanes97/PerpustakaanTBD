-- Procedure untuk sign up
CREATE DEFINER=`root`@`localhost` PROCEDURE `sign_up`(
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

-- Procedure untuk menambah pengarang

-- Procedure untuk menambah buku sekaligus kata, tag, dan pengarangnya

-- Procedure untuk menmabah eksemplar

-- Procedure untuk menambah denda

-- Procedure untuk mencari nilai IDF setiap kata

-- Procedure untuk menghitung bobot setiap kata berdasarkan IDF-nya

-- Procedure untuk mencari rekomendasi buku untuk member

-- Procedure untuk mendapatkan semua judul buku, nama pengarang, dan genre (bisa berdasarkan judul dan nama pengaang)

-- Procedure untuk mencari semua member

-- Procedure untuk mencari semua administrator

-- Procedure untuk melakukan peminjaman buku dengan judul buku dan eksemplar tertentu.

-- Procedure untuk melakukan pemesanan buku

-- Pengingat untuk mengembalikan buku

-- Melakukan perpanjangan masa pinjam buku

-- Menu feedback

