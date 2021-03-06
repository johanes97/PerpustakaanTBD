-- Nama basis data: jfalibrary

-- Buku
insert into buku(judulbuku,deleted)
values ('Algoritma dan Struktur Data',0);
insert into buku(judulbuku,deleted)
values ('Introduction to Algorithm',0);
insert into buku(judulbuku,deleted)
values ('Programming for Dummies',0);
insert into buku(judulbuku,deleted)
values ('Manage the Economy',0);
insert into buku(judulbuku,deleted)
values ('Network Security',0);
insert into buku(judulbuku,deleted)
values ('Java First',0);

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
insert into tag(namatag)
values ('Java');
insert into tag(namatag)
values ('Language');
insert into tag(namatag)
values ('Android');
insert into tag(namatag)
values ('Software');

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
insert into bukupengarang(idbuku,idpengarang)
values (6,1);

-- BukuTag
insert into bukutag(idbuku, idtag)
values (1,1);
insert into bukutag(idbuku, idtag)
values (1,2);
insert into bukutag(idbuku, idtag)
values (1,3);
insert into bukutag(idbuku, idtag)
values (2,2);
insert into bukutag(idbuku, idtag)
values (2,5);
insert into bukutag(idbuku, idtag)
values (2,6);
insert into bukutag(idbuku, idtag)
values (3,2);
insert into bukutag(idbuku, idtag)
values (4,3);
insert into bukutag(idbuku, idtag)
values (4,7);
insert into bukutag(idbuku, idtag)
values (4,8);
insert into bukutag(idbuku, idtag)
values (5,2);
insert into bukutag(idbuku, idtag)
values (5,4);
insert into bukutag(idbuku, idtag)
values (5,5);
insert into bukutag(idbuku, idtag)
values (5,7);


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
insert into eksemplar(idbuku,status,deleted)
values (1,0,0);
insert into eksemplar(idbuku,status,deleted)
values (1,0,0);
insert into eksemplar(idbuku,status,deleted)
values (1,0,0);
insert into eksemplar(idbuku,status,deleted)
values (2,0,0);
insert into eksemplar(idbuku,status,deleted)
values (2,0,0);
insert into eksemplar(idbuku,status,deleted)
values (3,0,0);
insert into eksemplar(idbuku,status,deleted)
values (3,0,0);
insert into eksemplar(idbuku,status,deleted)
values (3,0,0);
insert into eksemplar(idbuku,status,deleted)
values (4,0,0);
insert into eksemplar(idbuku,status,deleted)
values (5,0,0);
insert into eksemplar(idbuku,status,deleted)
values (5,0,0);
insert into eksemplar(idbuku,status,deleted)
values (5,0,0);
insert into eksemplar(idbuku,status,deleted)
values (5,0,0);
insert into eksemplar(idbuku,status,deleted)
values (6,0,0);
insert into eksemplar(idbuku,status,deleted)
values (6,0,0);
insert into eksemplar(idbuku,status,deleted)
values (6,0,0);

-- Anggota
insert into anggota(email,nama,sandi,tipe)
values ('kasepSumasep@gmail.com','asep','sikasep123','admin');
insert into anggota(email,nama,sandi,tipe)
values ('irwanSiKasep@gmail.com','irwan','sayahandsome321','user_biasa');
insert into anggota(email,nama,sandi,tipe)
values ('alvinussutendy@gmail.com','alvinus','apaajaboleh','user_biasa');
insert into anggota(email,nama,sandi,tipe)
values ('firmansandyp@gmail.com','firmansandyp','tetetoet','user_biasa');

-- Denda
insert into denda(tarif,jumlahhari)
values (5000,5);
insert into denda(tarif,jumlahhari)
values (7500,5);
insert into denda(tarif,jumlahhari)
values (10000,3);

-- Pemesanan
insert into pemesanan(email,idbuku,tglpemesanan,statuspemesanan)
values ('irwanSiKasep@gmail.com',1,'2019-12-25','WAITING');
insert into pemesanan(email,idbuku,tglpemesanan,statuspemesanan)
values ('irwanSiKasep@gmail.com',2,'2018-12-25','ACCEPTED');

-- Peminjaman
insert into peminjaman(email, ideksemplar, tglpeminjaman, tglpengembalian, bataspengembalian, durasihariterlambat, besardenda, statuspeminjaman)
values ('firmansandyp@gmail.com',1,'2019-04-10','2019-04-17','2019-04-22', 5, 25000, 'ACTIVE');
insert into peminjaman(email, ideksemplar, tglpeminjaman, tglpengembalian, bataspengembalian, durasihariterlambat, besardenda, statuspeminjaman)
values ('irwanSiKasep@gmail.com',2,'2019-04-10','2019-04-17','2019-05-02', 15, 125000, 'ACTIVE');
insert into peminjaman(email, ideksemplar, tglpeminjaman, tglpengembalian, bataspengembalian, durasihariterlambat, besardenda, statuspeminjaman)
values ('alvinussutendy@gmail.com',3,'2019-04-10','2019-04-17','2019-04-22', 5, 25000, 'ACTIVE');