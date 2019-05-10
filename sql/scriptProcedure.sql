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

-- ADMIN

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

-- Procedure untuk menambah eksemplar
	
-- Procedure untuk mencari nilai IDF setiap kata

-- Procedure untuk menghitung bobot setiap kata berdasarkan IDF-nya

-- Procedure untuk menambah denda

-- Procedure untuk mencari semua member
-- (Sudah dibuat sql biasa)

-- Procedure untuk mencari semua administrator

-- Procedure untuk melakukan perpanjangan masa pinjam buku

-- Procedure untuk laporan buku-buku yang sering dipinjam

-- Procedure untuk laporan buku-buku yang sering dipinjam berdasarkan pengarang

-- Procedure untuk laporan tag-tag dari buku-buku yang sering dipinjam.

-- Procedure untuk laporan tag-tag yang sering dipinjam oleh seorang anggota.

-- Procedure untuk laporan rekomendasi buku bagi seorang anggota.



-- GENERAL

-- Procedure untuk laporan history peminjaman buku.

-- Procedure untuk laporan history pemesanan buku.

-- Procedure untuk mengupdate profil
-- (Sudah dibuat sql biasa)



-- Member

-- Procedure untuk mencari rekomendasi buku untuk member

-- Procedure untuk mendapatkan semua judul buku, nama pengarang (bisa berdasarkan judul dan nama pengaang)
-- (Sudah ada sql biasa berdasarkan input buku dan pengarangnya)

-- Procedure untuk melakukan peminjaman buku dengan judul buku dan eksemplar tertentu.

-- Procedure untuk melakukan pemesanan buku

-- Procedure untuk mencari semua pengembalian buku
-- (Sudah dibuat sql biasa)

-- Procedure untuk mencari semua pemesanan buku
-- (Sudah dibuat sql biasa)

-- Procedure untuk mengingatkan pengembalian buku

-- Procedure menu feedback