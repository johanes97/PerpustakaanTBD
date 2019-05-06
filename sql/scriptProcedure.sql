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
CREATE DEFINER=`root`@`localhost` PROCEDURE `insert_book_author_tag`(
        IN judulBukuInput varchar(100),
        IN namaPengarangInput varchar(100),
        IN tagInput varchar(100)
)
BEGIN
    DECLARE tempIdBuku INT DEFAULT 0;
    DECLARE tempIdPengarang INT DEFAULT 0;
    DECLARE tempIdTag INT DEFAULT 0;
    DECLARE tempIdKata INT DEFAULT 0;
    
    DECLARE _next varchar(100) DEFAULT NULL;
    DECLARE _nextlen INT DEFAULT NULL;
    DECLARE _value varchar(100) DEFAULT NULL;
    
    INSERT INTO buku(judulbuku) VALUES(judulBukuInput);
    
    SELECT buku.idbuku
    INTO tempIdBuku
    FROM buku
    WHERE judulbuku LIKE judulBukuInput
    LIMIT 1;
    
    -- Hapus tanda ', ' di depan
    SET namaPengarangInput = INSERT(namaPengarangInput,1,2,'');
    SET tagInput = INSERT(tagInput,1,2,"");
    
    -- Iterator Pengarang
    iterator:
    LOOP
            IF LENGTH(TRIM(namaPengarangInput)) = 0 OR namaPengarangInput IS NULL THEN
            LEAVE iterator;
             END IF;
            
            -- ambil 1 pengarang 
            SET _next = SUBSTRING_INDEX(namaPengarangInput,',',1);
            select _next;
            
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
        
        INSERT INTO bukupengarang(idbuku,idpengarang) VALUES(tempIdBuku,tempIdPengarang);
        SET namaPengarangInput = INSERT(namaPengarangInput,1,_nextlen + 1,'');
    END LOOP;
    
    -- Iterator Tag
    iterator:
    LOOP
            IF LENGTH(TRIM(tagInput)) = 0 OR tagInput IS NULL THEN
            LEAVE iterator;
             END IF;
            
            -- ambil 1 tag 
            SET _next = SUBSTRING_INDEX(tagInput,',',1);
            select _next;
            
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
        
        INSERT INTO bukutag(idbuku,idtag) VALUES(tempIdBuku,tempIdTag);
        SET tagInput = INSERT(tagInput,1,_nextlen + 1,'');
    END LOOP;
    
    -- Iterator Judul
    iterator:
    LOOP
            IF LENGTH(TRIM(judulBukuInput)) = 0 OR judulBukuInput IS NULL THEN
            LEAVE iterator;
             END IF;
            
            -- ambil 1 kata dalam judul 
            SET _next = SUBSTRING_INDEX(judulBukuInput,' ',1);
            select _next;
            
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
             INSERT INTO kata(namakata) VALUES(_value);
        end if;
        
         SELECT kata.idkata
         INTO tempIdKata
         FROM kata
         WHERE namakata LIKE _value
         LIMIT 1;
        
        INSERT INTO bukukata(idbuku,idkata,jmlkemunculan,bobot) VALUES(tempIdBuku,tempIdKata,0,0);
        SET judulBukuInput = INSERT(judulBukuInput,1,_nextlen + 1,'');
    END LOOP;
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