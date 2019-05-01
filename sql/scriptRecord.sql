--Nama basis data: perpustakaantbd

--Buku
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

--Pengarang
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

--Kata
insert into kata(namakata,idf)
values ('Algoritma',0.43);
insert into kata(namakata,idf)
values ('dan',0.06);
insert into kata(namakata,idf)
values ('Struktur',3.34);
insert into kata(namakata,idf)
values ('Data',1.45);
insert into kata(namakata,idf)
values ('Network',1.4);

--Tag
insert into tag(namatag)
values 

--BukuPengarang
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

--BukuTag

--BukuKata

--Eksemplar


--Anggota
insert into anggota(email,nama,sandi,tipe)
values ('kasepSumasep@gmail.com','asep','sikasep123','admin');
insert into anggota(email,nama,sandi,tipe)
values ('irwanSiKasep@gmail.com','irwan','sayahandsome321','user_biasa');
insert into anggota(email,nama,sandi,tipe)
values ('alvinussutendy@gmail.com','alvinus','apaajaboleh','user_biasa');

--Denda
insert into denda(tipedenda,tarif)
values (5,5000);
insert into denda(tipedenda,tarif)
values (15,10000);

--Pemesanan
insert into pemesanan(email,idbuku,tglpemesanan)
values ('irwanSiKasep@gmail.com',1,'2019-12-25');
insert into pemesanan(email,idbuku,tglpemesanan)
values ('irwanSiKasep@gmail.com',2,'2018-12-25');

--Peminjaman