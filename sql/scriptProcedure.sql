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
    DECLARE _next varchar(100) DEFAULT NULL;
    DECLARE _nextlen INT DEFAULT NULL;
    DECLARE _value varchar(100) DEFAULT NULL;
    DECLARE tempIdKata INT DEFAULT 0;
    DECLARE _counterKataTemp INT DEFAULT 0;

    DECLARE tempIdBuku INTEGER DEFAULT 0;
    DECLARE tempJmlKemunculan INTEGER DEFAULT 1;
    
    DECLARE bobotEksemplarKata float DEFAULT 0;
    DECLARE _idf FLOAT DEFAULT 0;
    
    DECLARE tempIdBukuCursor INTEGER DEFAULT 0;
   
   DECLARE flagFinished INTEGER DEFAULT 0;
   
    DECLARE rn int default 0;
    
    DECLARE panjangVDok float default 0;
   DECLARE panjangVQuery float default 0;
   DECLARE distance float default 0;
   DECLARE totalDistance float default 0;
    
    DECLARE counterVDokumen INTEGER DEFAULT 1;
    DECLARE counterVQuery INTEGER DEFAULT 1;
     DECLARE counterVDokumenQuery INTEGER DEFAULT 1;
    DECLARE tempBobot float DEFAULT 0;
    
    DECLARE result varchar(200) DEFAULT NULL;
   
   DECLARE dokumenCursor CURSOR FOR 
   SELECT idBuku
   FROM buku;
    
     DECLARE CONTINUE HANDLER 
        FOR NOT FOUND SET flagFinished = 1;
    
    if (pilihanpencarian = 'judul') then
    
        DROP TEMPORARY TABLE IF EXISTS distanceTable;
            create temporary table distanceTable as
            select 0 as idbuku, 0.00000 as distance
            from buku
            LIMIT 0;
        
        DROP TEMPORARY TABLE IF EXISTS tempSearchKataTable;
            create temporary table tempSearchKataTable as
            select 0 as seqnum, namakata  as 'nama', 0.00000 as 'bobot', 0 as 'jmlKemunculan'
            from kata
            LIMIT 0;
        ALTER TABLE tempSearchKataTable ADD PRIMARY KEY NONCLUSTERED (nama);
        
        set @rn = 0;
         -- Iterator Judul
        iterator:
        LOOP
                IF LENGTH(TRIM(keyword)) = 0 OR keyword IS NULL THEN
                LEAVE iterator;
                 END IF;
                
                -- ambil 1 kata dalam judul 
                SET _next = SUBSTRING_INDEX(keyword,' ',1);
                -- select _next;
                
                -- panjang next
                SET _nextlen = LENGTH(_next);
                
                -- hilangkan spasi
                SET _value = TRIM(_next);
             
             if((SELECT kata.idkata FROM kata WHERE namakata LIKE _value LIMIT 1) is not null) then
                select idf
                into _idf
                from kata
                where namakata=_value;
            elseif((SELECT kata.idkata FROM kata WHERE namakata LIKE _value LIMIT 1) is null) then
                set _idf = 0;
            end if;
            
            select jmlKemunculan
            into tempJmlKemunculan
            from tempSearchKataTable
            where nama=_value;
            
            if((select jmlKemunculan from tempSearchKataTable where nama = _value) is null) then
                insert into tempSearchKataTable(seqnum, nama, bobot, jmlkemunculan) values((@rn:= @rn+1) , _value, 0.00000, 1);
            elseif((select jmlkemunculan from tempSearchKataTable where nama =_value) is not null) then
                update tempSearchKataTable set jmlKemunculan=tempJmlKemunculan+1 where nama=_value;
            end if;
            
            update tempSearchKataTable set tempSearchKataTable.bobot= (1.0 + LOG(2,tempJmlKemunculan))*_idf where nama=_value;
         
            SET keyword = INSERT(keyword,1,_nextlen + 1,'');
        END LOOP;
        
        iterator:
        LOOP
            IF counterVQuery > (select count(nama) from tempSearchKataTable) THEN
                LEAVE iterator;
            END IF;
            
            set tempBobot = (select bobot from tempSearchKataTable where seqnum = counterVQuery)+0.00000;
        
            set panjangVQuery = POW(tempBobot,2)+panjangVQuery;
            
            set counterVQuery = counterVQuery + 1;
        END LOOP;
      
        set panjangVQuery = sqrt(panjangVQuery);
        
        set rn =0;
        
        set flagFinished=0;
        open dokumenCursor;
            
            get_id: LOOP
                FETCH dokumenCursor INTO tempIdBukuCursor;
                
                IF flagFinished = 1 THEN 
                    LEAVE get_id;
                END IF;
                
                DROP TEMPORARY TABLE IF EXISTS queryDanDokumenTable;
                create temporary table queryDanDokumenTable as
                select 0 as seqnum, kata.namakata as 'kataDokumen' , bukukata.bobot as 'bobotDokumen',
                tempSearchKataTable.nama as 'kataQuery', tempSearchKataTable.bobot as 'bobotQuery'
                from kata inner join bukukata on kata.idkata = bukukata.idkata
                inner join tempSearchKataTable on kata.namakata = tempSearchKataTable.nama
                LIMIT 0;
                
                DROP TEMPORARY TABLE IF EXISTS tempDokumenTable;
                create temporary table tempDokumenTable as
                select 0 as seqnum, kata.namakata as 'kataDokumen' , bukukata.bobot as 'bobotDokumen'
                from kata inner join bukukata on kata.idkata = bukukata.idkata
                LIMIT 0;
                
                set @rn = 0;
                insert into tempDokumenTable
                select (@rn:= @rn+1), kata.namakata as 'kataDokumen' , bukukata.bobot as 'bobotDokumen'
                from kata inner join bukukata on kata.idkata = bukukata.idkata
                where bukukata.idbuku = tempIdBukuCursor; 
                
                set @rn = 0;
                insert into queryDanDokumenTable
                select distinct (@rn:= @rn+1), tempDokumenTable.kataDokumen, tempDokumenTable.bobotDokumen,
                tempSearchKataTable.nama as kataQuery, tempSearchKataTable.bobot as kataDokumen
                from tempDokumenTable inner join tempSearchKataTable
                on tempDokumenTable.kataDokumen = tempSearchKataTable.nama;
                
               iterator:
                LOOP
                    IF counterVDokumen > (select count(katadokumen) from tempDokumenTable) THEN
                        LEAVE iterator;
                    END IF;
                    
                    set tempBobot = (select bobotdokumen from tempDokumenTable where seqnum = counterVDokumen)+0.00000;
                    set panjangVDok = POW(tempBobot,2)+panjangVDok;
                    
                    set counterVDokumen = counterVDokumen + 1;
                END LOOP;

                set panjangVDok = sqrt(panjangVDok);
                set counterVDokumen = 1;

                iterator:
                LOOP
                    IF counterVDokumenQuery > (select count(kataDokumen) from queryDanDokumenTable) THEN
                        LEAVE iterator;
                    END IF;
                    
                    set distance = distance +
                    (select (queryDanDokumenTable.bobotDokumen * queryDanDokumenTable.bobotquery)
                    from queryDanDokumenTable
                    where queryDanDokumenTable.seqnum = counterVDokumenQuery);
                    
                    set counterVDokumenQuery = counterVDokumenQuery + 1;
                END LOOP;
                set totalDistance = distance / (panjangVDok*panjangVQuery);
                IF(totalDistance is null) then
                    set totalDistance=0;
                end if;
                
                insert into distanceTable(idbuku, distance) values(tempIdBukuCursor,totalDistance);
                
                set counterVDokumenQuery = 1;
                set totalDistance=0;
                set distance=0;
                set panjangVDok = 0;
            END LOOP get_id;
        close dokumenCursor;
            
        select * from distanceTable 
        inner join bukupengarang on distanceTable.idbuku = bukupengarang.idbuku
        inner join buku on buku.idbuku = bukupengarang.idbuku
        inner join pengarang on pengarang.idpengarang = bukupengarang.idpengarang 
        where buku.deleted = 0 
        order by distanceTable.distance desc;
        
    elseif (pilihanpencarian = 'pengarang') then
        set keyword = concat('%',keyword,'%');
        
        select distinct *
        from bukupengarang
            inner join buku on buku.idbuku = bukupengarang.idbuku
            inner join pengarang on pengarang.idpengarang = bukupengarang.idpengarang
            inner join bukutag on bukutag.idbuku = bukupengarang.idbuku
            inner join tag on tag.idtag = bukutag.idtag
        where buku.deleted = 0 && pengarang.namapengarang like keyword;
    
    elseif (pilihanpencarian = 'tag') then
        set keyword = concat('%',keyword,'%');
    
        select distinct *
        from bukutag
            inner join buku on buku.idbuku = bukutag.idbuku
            inner join bukupengarang on bukupengarang.idbuku = buku.idbuku
            inner join pengarang on pengarang.idpengarang = bukupengarang.idpengarang
            inner join tag on tag.idtag = bukutag.idtag
        where buku.deleted = 0 && tag.namatag like keyword;
    end if;
END

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

--BUKU: Mendapatkan rekomendasi buku untuk anggota yang login (recommendation.php)
CREATE DEFINER=`root`@`localhost` PROCEDURE `rekomendasibuku`(
	IN emaillogin varchar(100)
)
BEGIN
	--cari total peminjaman setiap tag dari setiap buku yang pernah seorang anggota pinjam (value setiap tag)(SUDAH BENAR)
	drop temporary table if exists tmpjumlahpeminjamantag;
	create temporary table tmpjumlahpeminjamantag as
		select tag.idtag, tag.namatag, count(tag.idtag) as 'tagcount'
		from peminjaman
			inner join eksemplar on eksemplar.ideksemplar = peminjaman.ideksemplar
			inner join buku on buku.idbuku = eksemplar.idbuku
			inner join bukutag on bukutag.idbuku = buku.idbuku
			inner join tag on tag.idtag = bukutag.idtag
		where peminjaman.email like emaillogin
		group by tag.idtag
		order by tagcount desc;

	--cari semua buku dan urutkan berdasarkan book value (book value = total value dari tag-tag yang dimiliki buku)(SUDAH BENAR)
	drop temporary table if exists tmpvaluebuku;
	create temporary table tmpvaluebuku as
		select buku.idbuku, buku.judulbuku, sum(tagcount) as 'bookvalue'
		from buku
			inner join bukutag on bukutag.idbuku = buku.idbuku
			inner join tmpjumlahpeminjamantag on tmpjumlahpeminjamantag.idtag = bukutag.idtag
		group by buku.idbuku
		order by bookvalue desc;
	
	--hapus buku yang sedang dipinjam
	drop temporary table if exists tmpvaluebuku2;
	create temporary table tmpvaluebuku2 as
		select tmpvaluebuku.idbuku, tmpvaluebuku.judulbuku, tmpvaluebuku.bookvalue
		from peminjaman
			inner join eksemplar on eksemplar.ideksemplar = peminjaman.ideksemplar
			right outer join tmpvaluebuku on tmpvaluebuku.idbuku = eksemplar.idbuku
		where peminjaman.email like emaillogin and (peminjaman.statuspeminjaman like 'INACTIVE' or peminjaman.statuspeminjaman is null)
		group by tmpvaluebuku.idbuku
		order by bookvalue desc;
	
	--menambahkan nama pengarang
	select tmpvaluebuku2.idbuku, tmpvaluebuku2.judulbuku, pengarang.namapengarang, tmpvaluebuku2.bookvalue
	from tmpvaluebuku2
		inner join bukupengarang on bukupengarang.idbuku = tmpvaluebuku2.idbuku
		inner join pengarang on pengarang.idpengarang = bukupengarang.idpengarang
	order by bookvalue desc;
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

--PEMINJAMAN: Mengupdate hari terlambat dan besar denda (borrows.php)(TESTED)
CREATE DEFINER=`root`@`localhost` PROCEDURE `updatepeminjaman`()
BEGIN
	declare newdurasihariterlambat int default 0;
	declare newbesardenda int default 0;
	
	declare dateinterval int default 0;
	
	declare vrbidpeminjaman int default 0;
	declare vrbbataspengembalian date;
	
	declare vrbtarif int default 0;
	declare vrbjumlahhari int default 0;
	
	
	declare flagfinished int default 0;
	declare flagfinished2 int default 0;
	
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
				
				set dateinterval = abs(dateinterval);
				set newdurasihariterlambat = abs(dateinterval);

				update peminjaman
				set peminjaman.durasihariterlambat = newdurasihariterlambat
				where peminjaman.idpeminjaman = vrbidpeminjaman;
				
				
				BLOCK2: BEGIN
				
				declare cursordenda cursor for
				select denda.tarif, denda.jumlahhari
				from denda
				order by denda.tarif asc;
				
				declare continue handler for not found set flagfinished2 = 1;
				
				open cursordenda;
					get_variabel2: loop
					
						fetch cursordenda
						into vrbtarif, vrbjumlahhari;
					
						if (flagfinished2 = 1) then
							leave get_variabel2;
						end if;
						
						if ((dateinterval-vrbjumlahhari) <= 0) then
							set newbesardenda = newbesardenda + (dateinterval*vrbtarif);
							leave get_variabel2;
						else
							set dateinterval = dateinterval - vrbjumlahhari;
							set newbesardenda = newbesardenda + (vrbjumlahhari*vrbtarif);
						end if;
					
					end loop get_variabel2;
				close cursordenda;
				
				END BLOCK2;
				
				update peminjaman
				set peminjaman.besardenda = newbesardenda
				where peminjaman.idpeminjaman = vrbidpeminjaman;
				
			end if;
			
			set newbesardenda = 0;
			set newdurasihariterlambat = 0;
			set dateinterval = 0;
			
			set flagfinished=0;
			set flagfinished2=0;
	
		end loop get_variabel;
	close cursorpeminjaman;
END //

--PEMINJAMAN: Mencari seluruh peminjaman (borrows.php)(TESTED)
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
		where buku.judulbuku like keyword and peminjaman.statuspeminjaman like statusdicari
		order by peminjaman.bataspengembalian asc;
	
	elseif (pilihanpencarian like 'anggota') then
	
		select *
		from peminjaman
			inner join anggota on anggota.email = peminjaman.email
			inner join eksemplar on eksemplar.ideksemplar = peminjaman.ideksemplar
			inner join buku on buku.idbuku = eksemplar.idbuku
			inner join bukupengarang on bukupengarang.idbuku = buku.idbuku
			inner join pengarang on pengarang.idpengarang = bukupengarang.idpengarang
		where anggota.nama like keyword and peminjaman.statuspeminjaman like statusdicari
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
	where eksemplar.idbuku = idbukudipinjam and eksemplar.status = 0
	limit 1;
	
	insert into peminjaman(email,ideksemplar,tglpeminjaman,bataspengembalian,durasihariterlambat,besardenda,statuspeminjaman)
	values (emailpeminjam,ideksemplardipinjam,now(),bataspeminjaman,0,0,'ACTIVE');
	
	update eksemplar
	set eksemplar.status = 1
	where eksemplar.ideksemplar = ideksemplardipinjam;
END //

--PEMINJAMAN: Menghapus peminjaman (borrows.php)(TESTED)
CREATE DEFINER=`root`@`localhost` PROCEDURE `hapuspeminjaman`(
	IN idpeminjamandihapus int
)
BEGIN
	declare ideksemplarkembali int;
	
	update peminjaman
	set peminjaman.statuspeminjaman = 'INACTIVE'
	where peminjaman.idpeminjaman = idpeminjamandihapus;
	
	update peminjaman
	set peminjaman.tglpengembalian = now()
	where peminjaman.idpeminjaman = idpeminjamandihapus;
	
	select peminjaman.ideksemplar
	into ideksemplarkembali
	from peminjaman
	where peminjaman.idpeminjaman = idpeminjamandihapus;
	
	update eksemplar
	set eksemplar.status = 0
	where eksemplar.ideksemplar = ideksemplarkembali;
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











--DENDA (SELESAI)

--DENDA: Mendapatkan semua tipe denda (fines.php)(TESTED)
CREATE DEFINER=`root`@`localhost` PROCEDURE `semuadenda`()
BEGIN		
	select *
	from denda;
END //

--DENDA: Menambahkan tipe denda (fines.php)(TESTED)
CREATE DEFINER=`root`@`localhost` PROCEDURE `tambahdenda`(
	IN intarif int,
	IN injumlahhari int
)
BEGIN		
	insert into denda(tarif,jumlahhari)
	values (intarif,injumlahhari);
END //

--DENDA: Menghapus tipe denda berdasarkan tipedenda (fines.php)(TESTED)
CREATE DEFINER=`root`@`localhost` PROCEDURE `hapusdenda`(
	IN tarifhapusdenda int
)
BEGIN
	delete from denda
	where denda.tarif = tarifhapusdenda;
END //











--LAPORAN (SELESAI)

--LAPORAN: Mendapatkan buku yang sering dipinjam, baik ssecara universal maupun khusus anggota yang login (report.php reports.php)(TESTED)
CREATE DEFINER=`root`@`localhost` PROCEDURE `laporanbuku`(
	IN emaillogin varchar(100)
)
BEGIN
	if (emaillogin not like '') then

		select buku.judulbuku as 'bukudipinjam', count(buku.idbuku) as 'jumlahpeminjaman'
		from peminjaman
			inner join anggota on anggota.email = peminjaman.email
			inner join eksemplar on eksemplar.ideksemplar = peminjaman.ideksemplar
			inner join buku on buku.idbuku = eksemplar.idbuku
		where anggota.email like emaillogin
		group by buku.judulbuku
		order by jumlahpeminjaman desc;
	
	else

		select buku.judulbuku as 'bukudipinjam', count(buku.idbuku) as 'jumlahpeminjaman'
		from peminjaman
			inner join eksemplar on eksemplar.ideksemplar = peminjaman.ideksemplar
			inner join buku on buku.idbuku = eksemplar.idbuku
		group by buku.judulbuku
		order by jumlahpeminjaman desc;
	
	end if;
END //

--LAPORAN: Mendapatkan pengarang yang bukunya sering dipinjam, baik ssecara universal maupun khusus anggota yang login (report.php reports.php)(TESTED)
CREATE DEFINER=`root`@`localhost` PROCEDURE `laporanpengarang`(
	IN emaillogin varchar(100)
)
BEGIN
	if (emaillogin not like '') then

		select pengarang.namapengarang as 'pengarangdipinjam', count(pengarang.idpengarang) as 'jumlahpeminjaman'
		from peminjaman
			inner join anggota on anggota.email = peminjaman.email
			inner join eksemplar on eksemplar.ideksemplar = peminjaman.ideksemplar
			inner join buku on buku.idbuku = eksemplar.idbuku
			inner join bukupengarang on bukupengarang.idbuku = buku.idbuku
			inner join pengarang on pengarang.idpengarang = bukupengarang.idpengarang
		where anggota.email like emaillogin
		group by pengarang.namapengarang
		order by jumlahpeminjaman desc;
	
	else
	
		select pengarang.namapengarang as 'pengarangdipinjam', count(pengarang.idpengarang) as 'jumlahpeminjaman'
		from peminjaman
			inner join eksemplar on eksemplar.ideksemplar = peminjaman.ideksemplar
			inner join buku on buku.idbuku = eksemplar.idbuku
			inner join bukupengarang on bukupengarang.idbuku = buku.idbuku
			inner join pengarang on pengarang.idpengarang = bukupengarang.idpengarang
		group by pengarang.namapengarang
		order by jumlahpeminjaman desc;
	
	end if;
END //

--LAPORAN: Mendapatkan tag-tag yang sering dipinjam, baik ssecara universal maupun khusus anggota yang login (report.php reports.php)(TESTED)
CREATE DEFINER=`root`@`localhost` PROCEDURE `laporantag`(
	IN emaillogin varchar(100)
)
BEGIN
	if (emaillogin not like '') then

		select tag.namatag as 'tagdipinjam', count(tag.idtag) as 'jumlahpeminjaman'
		from peminjaman
			inner join anggota on anggota.email = peminjaman.email
			inner join eksemplar on eksemplar.ideksemplar = peminjaman.ideksemplar
			inner join buku on buku.idbuku = eksemplar.idbuku
			inner join bukutag on bukutag.idbuku = buku.idbuku
			inner join tag on tag.idtag = bukutag.idtag
		where anggota.email like emaillogin
		group by tag.namatag
		order by jumlahpeminjaman desc;

	else

		select tag.namatag as 'tagdipinjam', count(tag.idtag) as 'jumlahpeminjaman'
		from peminjaman
			inner join eksemplar on eksemplar.ideksemplar = peminjaman.ideksemplar
			inner join buku on buku.idbuku = eksemplar.idbuku
			inner join bukutag on bukutag.idbuku = buku.idbuku
			inner join tag on tag.idtag = bukutag.idtag
		group by tag.namatag
		order by jumlahpeminjaman desc;
		
	end if;
END //


















--ALVIN IRWAN

--Menambah buku sekaligus kata, tag, dan kata-katanya
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
        
        if(countTempBukuPengarang>countInnerJoinBukuPengarang) then
            INSERT INTO buku(judulBuku) values (judulBukuInput);
            INSERT INTO eksemplar(idbuku,status) values (tempIdBuku+1,1);
            
            SET flagBookExistAuthor = 1;
            
             SELECT buku.idbuku
            INTO tempIdBuku
            FROM buku
            WHERE judulbuku LIKE judulBukuInput
            ORDER BY buku.idbuku desc
            LIMIT 1;
            
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
                
                 SELECT buku.idbuku
                INTO tempIdBuku
                FROM buku
                WHERE judulbuku LIKE judulBukuInput
                ORDER BY buku.idbuku desc
                LIMIT 1;
                
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
        
         if ((select idkata from kataTable) is null) then
             INSERT INTO kata(namakata,idf) VALUES(_value,1);
        end if;
            
         SELECT kata.idkata
         INTO tempIdKata
         FROM kata
         WHERE namakata LIKE _value
         LIMIT 1;

         if((select idkata from bukukata where idbuku=tempIdBuku and idkata=tempIdKata) is null) then
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
            
            select tempIdBuku;
            
        end if;
        SET judulBukuInput = INSERT(judulBukuInput,1,_nextlen + 1,'');
    END LOOP;
    
     open idfCursor;
         
        get_kata_and_idf: LOOP
            FETCH idfCursor INTO tempCursorIdKata;
            IF flagFinished = 1 THEN 
                LEAVE get_kata_and_idf;
            END IF;
            
            select count(eksemplar.idbuku)
            into _jmlBukuPunyaX 
            from eksemplar inner join BukuKata on eksemplar.idbuku = BukuKata.idbuku
            where BukuKata.idkata=tempCursorIdKata;
            
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



-- Procedure untuk mencari buku berdasarkan bobotnya
CREATE DEFINER=`root`@`localhost` PROCEDURE `search_by_idf`(
    IN judulBukuInput varchar(100)
)
BEGIN
    DECLARE _next varchar(100) DEFAULT NULL;
    DECLARE _nextlen INT DEFAULT NULL;
    DECLARE _value varchar(100) DEFAULT NULL;
    DECLARE tempIdKata INT DEFAULT 0;
    DECLARE _counterKataTemp INT DEFAULT 0;

    DECLARE tempIdBuku INTEGER DEFAULT 0;
    DECLARE tempJmlKemunculan INTEGER DEFAULT 1;
    
    DECLARE bobotEksemplarKata float DEFAULT 0;
    DECLARE _idf FLOAT DEFAULT 0;
    
    DECLARE tempIdBukuCursor INTEGER DEFAULT 0;
   
   DECLARE flagFinished INTEGER DEFAULT 0;
   
    DECLARE rn int default 0;
    
    DECLARE panjangVDok float default 0;
   DECLARE panjangVQuery float default 0;
   DECLARE distance float default 0;
   DECLARE totalDistance float default 0;
    
    DECLARE counterVDokumen INTEGER DEFAULT 1;
    DECLARE counterVQuery INTEGER DEFAULT 1;
     DECLARE counterVDokumenQuery INTEGER DEFAULT 1;
    DECLARE tempBobot float DEFAULT 0;
   
   DECLARE dokumenCursor CURSOR FOR 
   SELECT idBuku
   FROM buku;
    
     DECLARE CONTINUE HANDLER 
        FOR NOT FOUND SET flagFinished = 1;
    
    DROP TEMPORARY TABLE IF EXISTS distanceTable;
        create temporary table distanceTable as
        select 0 as idbuku, 0.00000 as distance
        from buku
        LIMIT 0;
    
    DROP TEMPORARY TABLE IF EXISTS tempSearchKataTable;
        create temporary table tempSearchKataTable as
        select 0 as seqnum, namakata  as 'nama', 0.00000 as 'bobot', 0 as 'jmlKemunculan'
        from kata
        LIMIT 0;
    ALTER TABLE tempSearchKataTable ADD PRIMARY KEY NONCLUSTERED (nama);
    
    set @rn = 0;
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
         
         if((SELECT kata.idkata FROM kata WHERE namakata LIKE _value LIMIT 1) is not null) then
            select idf
            into _idf
            from kata
            where namakata=_value;
        elseif((SELECT kata.idkata FROM kata WHERE namakata LIKE _value LIMIT 1) is null) then
            set _idf = 0;
        end if;
        
        select jmlKemunculan
        into tempJmlKemunculan
        from tempSearchKataTable
        where nama=_value;
        
        if((select jmlKemunculan from tempSearchKataTable where nama = _value) is null) then
            insert into tempSearchKataTable(seqnum, nama, bobot, jmlkemunculan) values((@rn:= @rn+1) , _value, 0.00000, 1);
        elseif((select jmlkemunculan from tempSearchKataTable where nama =_value) is not null) then
            update tempSearchKataTable set jmlKemunculan=tempJmlKemunculan+1 where nama=_value;
        end if;
        
        update tempSearchKataTable set tempSearchKataTable.bobot= (1.0 + LOG(2,tempJmlKemunculan))*_idf where nama=_value;
     
        SET judulBukuInput = INSERT(judulBukuInput,1,_nextlen + 1,'');
    END LOOP;
    
    iterator:
    LOOP
        IF counterVQuery > (select count(nama) from tempSearchKataTable) THEN
            LEAVE iterator;
        END IF;
        
        set tempBobot = (select bobot from tempSearchKataTable where seqnum = counterVQuery)+0.00000;
    
        set panjangVQuery = POW(tempBobot,2)+panjangVQuery;
        
        set counterVQuery = counterVQuery + 1;
    END LOOP;
  
    set panjangVQuery = sqrt(panjangVQuery);
    
    set rn =0;
    
    set flagFinished=0;
    open dokumenCursor;
        
        get_id: LOOP
            FETCH dokumenCursor INTO tempIdBukuCursor;
            
            IF flagFinished = 1 THEN 
                LEAVE get_id;
            END IF;
            
            DROP TEMPORARY TABLE IF EXISTS queryDanDokumenTable;
            create temporary table queryDanDokumenTable as
            select 0 as seqnum, kata.namakata as 'kataDokumen' , bukukata.bobot as 'bobotDokumen',
            tempSearchKataTable.nama as 'kataQuery', tempSearchKataTable.bobot as 'bobotQuery'
            from kata inner join bukukata on kata.idkata = bukukata.idkata
            inner join tempSearchKataTable on kata.namakata = tempSearchKataTable.nama
            LIMIT 0;
            
            DROP TEMPORARY TABLE IF EXISTS tempDokumenTable;
            create temporary table tempDokumenTable as
            select 0 as seqnum, kata.namakata as 'kataDokumen' , bukukata.bobot as 'bobotDokumen'
            from kata inner join bukukata on kata.idkata = bukukata.idkata
            LIMIT 0;
            
            set @rn = 0;
            insert into tempDokumenTable
            select (@rn:= @rn+1), kata.namakata as 'kataDokumen' , bukukata.bobot as 'bobotDokumen'
            from kata inner join bukukata on kata.idkata = bukukata.idkata
            where bukukata.idbuku = tempIdBukuCursor; 
            
            set @rn = 0;
            insert into queryDanDokumenTable
            select distinct (@rn:= @rn+1), tempDokumenTable.kataDokumen, tempDokumenTable.bobotDokumen,
            tempSearchKataTable.nama as kataQuery, tempSearchKataTable.bobot as kataDokumen
            from tempDokumenTable inner join tempSearchKataTable
            on tempDokumenTable.kataDokumen = tempSearchKataTable.nama;
            
           iterator:
            LOOP
                IF counterVDokumen > (select count(katadokumen) from tempDokumenTable) THEN
                    LEAVE iterator;
                END IF;
                
                set tempBobot = (select bobotdokumen from tempDokumenTable where seqnum = counterVDokumen)+0.00000;
                set panjangVDok = POW(tempBobot,2)+panjangVDok;
                
                set counterVDokumen = counterVDokumen + 1;
            END LOOP;

            set panjangVDok = sqrt(panjangVDok);
            set counterVDokumen = 1;


            iterator:
            LOOP
                IF counterVDokumenQuery > (select count(kataDokumen) from queryDanDokumenTable) THEN
                    LEAVE iterator;
                END IF;
                
                set distance = distance +
                (select (queryDanDokumenTable.bobotDokumen * queryDanDokumenTable.bobotquery)
                from queryDanDokumenTable
                where queryDanDokumenTable.seqnum = counterVDokumenQuery);
                
                set counterVDokumenQuery = counterVDokumenQuery + 1;
            END LOOP;
            set totalDistance = distance / (panjangVDok*panjangVQuery);
            IF(totalDistance is null) then
                set totalDistance=0;
            end if;
            
            insert into distanceTable(idbuku, distance) values(tempIdBukuCursor,totalDistance);
            
            set counterVDokumenQuery = 1;
            set totalDistance=0;
            set distance=0;
            set panjangVDok = 0;
        END LOOP get_id;
    close dokumenCursor;

    select * from distanceTable order by distanceTable.distance desc;
END




--LAPORAN

--LAPORAN: Mendapatkan buku yang sering dipinjam, baik ssecara universal maupun khusus anggota yang login (report.php reports.php)(TESTED)
CREATE DEFINER=`root`@`localhost` PROCEDURE `laporanbuku`(
	IN emaillogin varchar(100)
)
BEGIN
	if (emaillogin not like '') then

		select buku.judulbuku as 'bukudipinjam', count(buku.idbuku) as 'jumlahpeminjaman'
		from peminjaman
			inner join anggota on anggota.email = peminjaman.email
			inner join eksemplar on eksemplar.ideksemplar = peminjaman.ideksemplar
			inner join buku on buku.idbuku = eksemplar.idbuku
		where anggota.email like emaillogin
		group by buku.judulbuku
		order by jumlahpeminjaman desc;
	
	else

		select buku.judulbuku as 'bukudipinjam', count(buku.idbuku) as 'jumlahpeminjaman'
		from peminjaman
			inner join eksemplar on eksemplar.ideksemplar = peminjaman.ideksemplar
			inner join buku on buku.idbuku = eksemplar.idbuku
		group by buku.judulbuku
		order by jumlahpeminjaman desc;
	
	end if;
END //

--LAPORAN: Mendapatkan pengarang yang bukunya sering dipinjam, baik ssecara universal maupun khusus anggota yang login (report.php reports.php)(TESTED)
CREATE DEFINER=`root`@`localhost` PROCEDURE `laporanpengarang`(
	IN emaillogin varchar(100)
)
BEGIN
	if (emaillogin not like '') then

		select pengarang.namapengarang as 'pengarangdipinjam', count(pengarang.idpengarang) as 'jumlahpeminjaman'
		from peminjaman
			inner join anggota on anggota.email = peminjaman.email
			inner join eksemplar on eksemplar.ideksemplar = peminjaman.ideksemplar
			inner join buku on buku.idbuku = eksemplar.idbuku
			inner join bukupengarang on bukupengarang.idbuku = buku.idbuku
			inner join pengarang on pengarang.idpengarang = bukupengarang.idpengarang
		where anggota.email like emaillogin
		group by pengarang.namapengarang
		order by jumlahpeminjaman desc;
	
	else
	
		select pengarang.namapengarang as 'pengarangdipinjam', count(pengarang.idpengarang) as 'jumlahpeminjaman'
		from peminjaman
			inner join eksemplar on eksemplar.ideksemplar = peminjaman.ideksemplar
			inner join buku on buku.idbuku = eksemplar.idbuku
			inner join bukupengarang on bukupengarang.idbuku = buku.idbuku
			inner join pengarang on pengarang.idpengarang = bukupengarang.idpengarang
		group by pengarang.namapengarang
		order by jumlahpeminjaman desc;
	
	end if;
END //

--LAPORAN: Mendapatkan tag-tag yang sering dipinjam, baik ssecara universal maupun khusus anggota yang login (report.php reports.php)(TESTED)
CREATE DEFINER=`root`@`localhost` PROCEDURE `laporantag`(
	IN emaillogin varchar(100)
)
BEGIN
	if (emaillogin not like '') then

		select tag.namatag as 'tagdipinjam', count(tag.idtag) as 'jumlahpeminjaman'
		from peminjaman
			inner join anggota on anggota.email = peminjaman.email
			inner join eksemplar on eksemplar.ideksemplar = peminjaman.ideksemplar
			inner join buku on buku.idbuku = eksemplar.idbuku
			inner join bukutag on bukutag.idbuku = buku.idbuku
			inner join tag on tag.idtag = bukutag.idtag
		where anggota.email like emaillogin
		group by tag.namatag
		order by jumlahpeminjaman desc;

	else

		select tag.namatag as 'tagdipinjam', count(tag.idtag) as 'jumlahpeminjaman'
		from peminjaman
			inner join eksemplar on eksemplar.ideksemplar = peminjaman.ideksemplar
			inner join buku on buku.idbuku = eksemplar.idbuku
			inner join bukutag on bukutag.idbuku = buku.idbuku
			inner join tag on tag.idtag = bukutag.idtag
		group by tag.namatag
		order by jumlahpeminjaman desc;
		
	end if;
END //












