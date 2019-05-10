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

--PEMINJAMAN: Menghitung denda (borrows.php)(TESTED)
CREATE DEFINER=`root`@`localhost` PROCEDURE `updatepeminjaman`()
BEGIN
	declare vrbidpeminjaman int;
	declare vrbbataspengembalian date;
	declare dateinterval int;
	
	declare flagfinished int default 0;
	
	declare cursorpeminjaman cursor for
	select peminjaman.idpeminjaman, peminjaman.bataspengembalian
	from peminjaman;
	
	declare continue handler for not found set flagfinished = 1;
	
	open cursorpeminjaman;
	
		get_variabel: loop
			
			fetch cursorpeminjaman
			into vrbidpeminjaman, vrbbataspengembalian;
			
			if (flagfinished = 1) then
				leave get_variabel;
			end if;
			
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

	if (pilihanpencarian like 'buku') then
	
		select *
		from peminjaman
			inner join anggota on anggota.email = peminjaman.email
			inner join eksemplar on eksemplar.ideksemplar = peminjaman.ideksemplar
			inner join buku on buku.idbuku = eksemplar.idbuku
			inner join bukupengarang on bukupengarang.idbuku = buku.idbuku
			inner join pengarang on pengarang.idpengarang = bukupengarang.idpengarang
		where buku.judulbuku like keyword && peminjaman.statuspeminjaman like statusdicari
		order by peminjaman.bataspengembalian asc;
	
	elseif (pilihanpencarian like 'anggota') then
	
		select *
		from peminjaman
			inner join anggota on anggota.email = peminjaman.email
			inner join eksemplar on eksemplar.ideksemplar = peminjaman.ideksemplar
			inner join buku on buku.idbuku = eksemplar.idbuku
			inner join bukupengarang on bukupengarang.idbuku = buku.idbuku
			inner join pengarang on pengarang.idpengarang = bukupengarang.idpengarang
		where anggota.nama like keyword && peminjaman.statuspeminjaman like statusdicari
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

-- Procedure untuk menambah buku sekaligus kata, tag, dan pengarangnya
-- (Sudah dibuat sql biasa)
CREATE DEFINER=`root`@`localhost` PROCEDURE `insert_book_author_tag_word`(
        IN judulBukuInput varchar(100),
        IN namaPengarangInput varchar(100),
        IN tagInput varchar(100)
)
BEGIN
    DECLARE countTempBukuPengarang INT DEFAULT 0;
    DECLARE countBukuPengarang INT DEFAULT 0;
    DECLARE countInnerJoinBukuPengarang INT DEFAULT 0;
    DECLARE flagBookExist INT DEFAULT 0;
    DECLARE flagBookExistAuthor INT DEFAULT 0;
    
    DECLARE tempIdBuku INT DEFAULT 0;
    DECLARE tempIdPengarang INT DEFAULT 0;
    DECLARE tempIdTag INT DEFAULT 0;
    DECLARE tempIdKata INT DEFAULT 0;
    
    DECLARE _next varchar(100) DEFAULT NULL;
    DECLARE _nextlen INT DEFAULT NULL;
    DECLARE _value varchar(100) DEFAULT NULL;
    DECLARE _counterKataTemp INT DEFAULT 1;
    
    DECLARE _idf FLOAT DEFAULT 0;
    DECLARE _jmlBuku INT DEFAULT 0;
    DECLARE _jmlBukuPunyaX INT DEFAULT 0;
    
    DECLARE flagFinished INTEGER DEFAULT 0;
    DECLARE tempCursorIdKata INTEGER DEFAULT 0;
    DECLARE tempCursorIdBuku INTEGER DEFAULT 0;
    DECLARE tempCursorJmlKemunculan INTEGER DEFAULT 0;
    
    DECLARE bobotEksemplarKata float DEFAULT 0;
    
     DECLARE bukuPengarangCursor CURSOR FOR
     Select idbuku,idpengarang
      from tempbukupengarang;
    
    DECLARE idfCursor CURSOR FOR 
    SELECT idkata
    FROM kata;
    
    DECLARE bobotCursor CURSOR FOR 
    SELECT idbuku, idkata, jmlkemunculan
    FROM bukukata;
    
    
     DECLARE CONTINUE HANDLER 
        FOR NOT FOUND SET flagFinished = 1;
    
    if((select idbuku from buku where judulBuku like judulBukuInput limit 1) is null) then
        INSERT INTO buku(judulbuku) VALUES(judulBukuInput);
        SET flagBookExist = 1;
    end if;
    
    SELECT buku.idbuku
    INTO tempIdBuku
    FROM buku
    WHERE judulbuku LIKE judulBukuInput
    ORDER BY buku.idbuku desc
    LIMIT 1;
    
    if(flagBookExist = 1) then
        INSERT INTO eksemplar(idbuku,status) values (tempIdBuku,1);
    end if;
   
    -- Hapus tanda ', ' di depan
    SET namaPengarangInput = INSERT(namaPengarangInput,1,2,'');
    SET tagInput = INSERT(tagInput,1,2,"");
    
    DROP TEMPORARY TABLE IF EXISTS tempBukuPengarang;
    create temporary table tempBukuPengarang as
        select *
        from bukupengarang
        LIMIT 0;
    
    -- Iterator Pengarang
    iterator:
    LOOP
            IF LENGTH(TRIM(namaPengarangInput)) = 0 OR namaPengarangInput IS NULL THEN
            LEAVE iterator;
             END IF;
            
            -- ambil 1 pengarang 
            SET _next = SUBSTRING_INDEX(namaPengarangInput,',',1);
            
            -- panjang next
            SET _nextlen = LENGTH(_next);
            
            -- hilangkan spasi
            SET _value = TRIM(_next);
        
        DROP TEMPORARY TABLE IF EXISTS pengarangTable;
        create temporary table pengarangTable as
        SELECT pengarang.idpengarang
        FROM pengarang
        WHERE namapengarang LIKE _value;
        
         if ((select idPengarang from pengarangTable) is null) then
             INSERT INTO pengarang(namapengarang) VALUES(_value);
        end if;
        
         SELECT pengarang.idpengarang
         INTO tempIdPengarang
         FROM pengarang
         WHERE namapengarang LIKE _value
         LIMIT 1;
        
        INSERT INTO tempBukuPengarang(idbuku,idpengarang) VALUES(tempIdBuku,tempIdPengarang);
        SET namaPengarangInput = INSERT(namaPengarangInput,1,_nextlen + 1,'');
    END LOOP;
    
    DROP TEMPORARY TABLE IF EXISTS outerJoinTable;
    create temporary table outerJoinTable as
    SELECT 
    tempBukuPengarang.idbuku as 'idbuku1', tempBukuPengarang.idpengarang as 'idpengarang1',
    bukupengarang.idbuku as 'idbuku2', bukupengarang.idpengarang as 'idpengarang2'
    FROM tempBukuPengarang left outer join bukupengarang on
    tempBukuPengarang.idbuku = bukupengarang.idbuku and
    tempBukuPengarang.idpengarang = bukupengarang.idpengarang;
    
    -- select * from outerJoinTable;
    
    if(flagBookExist=0) then
        
        SELECT count(idpengarang)
        INTO countBukuPengarang
        from bukupengarang
        WHERE idbuku = tempIdBuku;
        
        SELECT count(idPengarang)
        INTO countTempBukuPengarang
        from tempBukuPengarang;
        
        SELECT count(tempBukuPengarang.idbuku)
        INTO countInnerJoinBukuPengarang
        from tempBukuPengarang inner join bukuPengarang on 
        tempBukuPengarang.idPengarang = bukuPengarang.idPengarang and 
        tempBukuPengarang.idbuku = bukuPengarang.idBuku;
        
        select "tesssssss";
        select * from tempbukupengarang;
        select * from bukuPengarang;
        select * from tempBukuPengarang inner join bukuPengarang on 
        tempBukuPengarang.idPengarang = bukuPengarang.idPengarang and 
        tempBukuPengarang.idbuku = bukuPengarang.idBuku;
        
        select countTempBukuPengarang, countBukuPengarang, countInnerJoinBukuPengarang;
        
        if(countTempBukuPengarang>countInnerJoinBukuPengarang) then
            INSERT INTO buku(judulBuku) values (judulBukuInput);
            INSERT INTO eksemplar(idbuku,status) values (tempIdBuku+1,1);
            
            SET flagBookExistAuthor = 1;
            
        elseif(countTempBukuPengarang = countInnerJoinBukuPengarang) then
            if(countTempBukuPengarang=countBukuPengarang) then
                INSERT INTO eksemplar(idbuku,status) values (tempIdBuku,1);
                
                insert into bukupengarang
                select outerJoinTable.idbuku1, outerJoinTable.idpengarang1
                from outerJoinTable
                where outerJoinTable.idbuku2 is null and outerJoinTable.idpengarang2 is null;
            elseif(countTempBukuPengarang != countBukuPengarang) 
                then
                INSERT INTO buku(judulBuku) values (judulBukuInput);
                INSERT INTO eksemplar(idbuku,status) values (tempIdBuku+1,1);
                SET flagBookExistAuthor = 1;
                
            end if;
        end if;
    end if;
   
    if(flagBookExist=1)then
        insert into bukupengarang
        select tempBukuPengarang.idbuku, tempBukuPengarang.idpengarang
        from tempBukuPengarang;
    elseif(flagBookExistAuthor=1)then
        insert into bukupengarang
        select tempBukuPengarang.idbuku+1, tempBukuPengarang.idpengarang
        from tempBukuPengarang;
    end if;

    -- Iterator Tag
    iterator:
    LOOP
            IF LENGTH(TRIM(tagInput)) = 0 OR tagInput IS NULL THEN
            LEAVE iterator;
             END IF;
            
            -- ambil 1 tag 
            SET _next = SUBSTRING_INDEX(tagInput,',',1);
            
            -- panjang next
            SET _nextlen = LENGTH(_next);
            
            -- hilangkan spasi
            SET _value = TRIM(_next);
        
        DROP TEMPORARY TABLE IF EXISTS tagTable;
        create temporary table tagTable as
        SELECT tag.idtag
        FROM tag
        WHERE namatag LIKE _value;
        
         if ((select idtag from tagTable) is null) then
             INSERT INTO tag(namatag) VALUES(_value);
        end if;
        
         SELECT tag.idtag
         INTO tempIdTag
         FROM tag
         WHERE namatag LIKE _value
         LIMIT 1;
        
        if((select idtag from bukutag where idtag = tempIdTag and idbuku=tempIdBuku) is null) then
            INSERT INTO bukutag(idbuku,idtag) VALUES(tempIdBuku,tempIdTag);
        end if;
        SET tagInput = INSERT(tagInput,1,_nextlen + 1,'');
    END LOOP;
     
    -- SELECT buku.idbuku
    -- INTO tempIdBuku
    -- FROM buku
    -- WHERE judulbuku LIKE judulBukuInput
    -- LIMIT 1;
    
     select count(eksemplar.idbuku)
     into _jmlBuku
     from eksemplar;
    
    -- Iterator Judul
    iterator:
    LOOP
            IF LENGTH(TRIM(judulBukuInput)) = 0 OR judulBukuInput IS NULL THEN
            LEAVE iterator;
             END IF;
            
            -- ambil 1 kata dalam judul 
            SET _next = SUBSTRING_INDEX(judulBukuInput,' ',1);
            -- select _next;
            
            -- panjang next
            SET _nextlen = LENGTH(_next);
            
            -- hilangkan spasi
            SET _value = TRIM(_next);
        
        DROP TEMPORARY TABLE IF EXISTS kataTable;
        create temporary table kataTable as
        SELECT kata.idkata
        FROM kata
        WHERE namakata LIKE _value;
        
        
        
       --  _idf
     -- _jmlBuku
     -- _jmlBukuPunyaX
        
         if ((select idkata from kataTable) is null) then
            -- select "tessssssss";
             INSERT INTO kata(namakata,idf) VALUES(_value,1);
             -- select _value as 'tempKata';
        end if;
            
        

         SELECT kata.idkata
         INTO tempIdKata
         FROM kata
         WHERE namakata LIKE _value
         LIMIT 1;
         
         -- select tempIdKata as "tempidkata";
         
         if((select idkata from bukukata where idbuku=tempIdBuku and idkata=tempIdKata) is null) then
            -- select "tessssss";
            set _counterKataTemp = 1;
            INSERT INTO bukukata(idbuku,idkata,jmlkemunculan,bobot) VALUES(tempIdBuku,tempIdKata,_counterKataTemp,0);
        elseif((select idkata from bukukata where idbuku=tempIdBuku and idkata=tempIdKata) is not null) then
            select jmlkemunculan 
            into _counterKataTemp 
            from bukukata 
            where idbuku=tempIdBuku and idkata=tempIdKata;
            
            update bukukata 
            set jmlkemunculan = _counterKataTemp+1 
            where idbuku=tempIdBuku and idkata=tempIdKata;
            
        end if;
        SET judulBukuInput = INSERT(judulBukuInput,1,_nextlen + 1,'');
    END LOOP;
    
     open idfCursor;
         
        get_kata_and_idf: LOOP
            FETCH idfCursor INTO tempCursorIdKata;
            IF flagFinished = 1 THEN 
                LEAVE get_kata_and_idf;
            END IF;
              
            -- select _value,_jmlBuku,_jmlBukuPunyaX;
            
            select count(eksemplar.idbuku)
            into _jmlBukuPunyaX 
            from eksemplar inner join BukuKata on eksemplar.idbuku = BukuKata.idbuku
            where BukuKata.idkata = tempCursorIdKata;
            
            SELECT LOG(2,(_jmlBuku+0.0)/(_jmlBukuPunyaX+0.0))
            into _idf;
            
            update kata set idf = _idf where idkata=tempCursorIdKata;
        END LOOP get_kata_and_idf;
            
    close idfCursor;
    
    set flagFinished = 0;
    
     open bobotCursor;
         
        get_bobot: LOOP
            FETCH bobotCursor INTO tempCursorIdBuku, tempCursorIdKata, tempCursorJmlKemunculan;
            IF flagFinished = 1 THEN 
                LEAVE get_bobot;
            END IF;
            
            select idf
            into _idf
            from kata
            where idkata = tempCursorIdKata;
            
            select (1 + LOG(2,tempCursorJmlKemunculan))*_idf
            into bobotEksemplarKata;
            
            update bukukata 
            set bobot = bobotEksemplarKata 
            where idbuku=tempCursorIdBuku and idkata=tempCursorIdKata;
            
        END LOOP get_bobot;
            
    close bobotCursor;
END

-- Procedure untuk mencari banyak pengarang atau tag
CREATE DEFINER=`root`@`localhost` PROCEDURE `search_multi`(
    IN pengarang int,
    IN tag int
)
BEGIN
    if(pengarang != 0 && tag = 0) then
        SELECT pengarang.namapengarang
        FROM pengarang;
    elseif(pengarang = 0 && tag != 0) then
        SELECT tag.namatag
        FROM tag;
    end if;
END

-- Procedure untuk mencari satu pengarang atau tag
CREATE DEFINER=`root`@`localhost` PROCEDURE `search_one`(
    IN book varchar(100), 
    IN author varchar(100)
)
BEGIN
    DECLARE idBuku INT DEFAULT 0;
    DECLARE idPengarang INT DEFAULT 0;
    if(book != '') then
        SELECT buku.idbuku
        INTO idBuku
        FROM buku
        WHERE judulbuku LIKE CONCAT('%', book, '%')
        LIMIT 1;
    end if;
    if(author != '') then
        SELECT pengarang.idpengarang
        INTO idPengarang
        FROM pengarang
        WHERE namapengarang LIKE CONCAT('%', author, '%')
        LIMIT 1;
    end if;
    select idBuku, idPengarang;
END














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






--DENDA (SELESAI)

--DENDA: Mendapatkan semua tipe denda (fines.php)(TESTED)
CREATE DEFINER=`root`@`localhost` PROCEDURE `semuadenda`()
BEGIN		
	select *
	from denda;
END //

--DENDA: Menambahkan tipe denda (fines.php)(TESTED)
CREATE DEFINER=`root`@`localhost` PROCEDURE `tambahdenda`(
	IN intipedenda int,
	IN intarif int
)
BEGIN		
	insert into denda(tipedenda,tarif)
	values (intipedenda,intarif);
END //

--DENDA: Menghapus tipe denda berdasarkan tipedenda (fines.php)(TESTED)
CREATE DEFINER=`root`@`localhost` PROCEDURE `hapusdenda`(
	IN tipedendadihapus int
)
BEGIN
	delete from denda
	where denda.tipedenda = tipedendadihapus;
END //






-- Procedure untuk menambah eksemplar

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