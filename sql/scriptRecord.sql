-- Nama basis data: perpustakaantbd

-- Buku
insert into buku(judulbuku)
values ('Algoritma dan Struktur Data');
insert into buku(judulbuku)
values ('Introduction to Algorithm');
insert into buku(judulbuku)
values ('Programming for Dummies');
insert into buku(judulbuku)
values ('Manage the Economy');
insert into buku(judulbuku)
values ('Network Security');

-- Pengarang
insert into pengarang(namapengarang)
values ('Alvinus Sutendy');
insert into pengarang(namapengarang)
values ('Petrus Gumal');
insert into pengarang(namapengarang)
values ('Johanes Irwan');
insert into pengarang(namapengarang)
values ('Firman Sandy Prayitno');
insert into pengarang(namapengarang)
values ('Steven Rogerson');

-- Kata
insert into kata(namakata,idf)
values ('Algoritma',0);
insert into kata(namakata,idf)
values ('dan',0);
insert into kata(namakata,idf)
values ('Struktur',0);
insert into kata(namakata,idf)
values ('Data', 0);
insert into kata(namakata,idf)
values ('Network', 0);

-- Tag
insert into tag(namatag)
values ('Algoritma');
insert into tag(namatag)
values ('Sorting');
insert into tag(namatag)
values ('Ekonomi');
insert into tag(namatag)
values ('Network');

-- BukuPengarang
insert into bukupengarang(idbuku,idpengarang)
values (1,4);
insert into bukupengarang(idbuku,idpengarang)
values (2,4);
insert into bukupengarang(idbuku,idpengarang)
values (3,3);
insert into bukupengarang(idbuku,idpengarang)
values (4,5);
insert into bukupengarang(idbuku,idpengarang)
values (5,1);

-- BukuTag
insert into bukutag(idbuku, idtag)
values (1,1);
insert into bukutag(idbuku, idtag)
values (5,4);
insert into bukutag(idbuku, idtag)
values (1,2);
insert into bukutag(idbuku, idtag)
values (2,2);
insert into bukutag(idbuku, idtag)
values (5,2);
insert into bukutag(idbuku, idtag)
values (4,3);
insert into bukutag(idbuku, idtag)
values (3,2);

-- BukuKata
insert into bukukata(idbuku, idkata, jmlkemunculan, bobot)
values (1,1,1,0);
insert into bukukata(idbuku, idkata, jmlkemunculan, bobot)
values (1,2,1,0);
insert into bukukata(idbuku, idkata, jmlkemunculan, bobot)
values (1,3,1,0);
insert into bukukata(idbuku, idkata, jmlkemunculan, bobot)
values (1,4,1,0);
insert into bukukata(idbuku, idkata, jmlkemunculan, bobot)
values (5,5,1,0);

-- Eksemplar
insert into eksemplar(idbuku, status)
values (1,0);
insert into eksemplar(idbuku, status)
values (2,0);
insert into eksemplar(idbuku, status)
values (3,0);
insert into eksemplar(idbuku, status)
values (4,1);
insert into eksemplar(idbuku, status)
values (5,1);

-- Anggota
insert into anggota(email,nama,sandi,tipe)
values ('kasepSumasep@gmail.com','asep','sikasep123','admin');
insert into anggota(email,nama,sandi,tipe)
values ('irwanSiKasep@gmail.com','irwan','sayahandsome321','user_biasa');
insert into anggota(email,nama,sandi,tipe)
values ('alvinussutendy@gmail.com','alvinus','apaajaboleh','user_biasa');

-- Denda
insert into denda(tipedenda,tarif)
values (5,5000);
insert into denda(tipedenda,tarif)
values (15,10000);

-- Pemesanan
insert into pemesanan(email,idbuku,tglpemesanan)
values ('irwanSiKasep@gmail.com',1,'2019-12-25');
insert into pemesanan(email,idbuku,tglpemesanan)
values ('irwanSiKasep@gmail.com',2,'2018-12-25');

-- Peminjaman
insert into peminjaman(email, ideksemplar, tglpeminjaman, tglpengembalian, bataspengembalian, durasihariterlambat, besardenda)
values ('kasepSumasep@gmail.com',1,'2019-04-10','2019-04-17','2019-04-22', 5, 25000);
insert into peminjaman(email, ideksemplar, tglpeminjaman, tglpengembalian, bataspengembalian, durasihariterlambat, besardenda)
values ('irwanSiKasep@gmail.com',2,'2019-04-10','2019-04-17','2019-05-02', 15, 125000);
insert into peminjaman(email, ideksemplar, tglpeminjaman, tglpengembalian, bataspengembalian, durasihariterlambat, besardenda)
values ('alvinussutendy@gmail.com',3,'2019-04-10','2019-04-17','2019-04-22', 5, 25000);