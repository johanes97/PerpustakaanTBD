-- Nama basis data: perpustakaantbd

-- Bagian Buku
drop table if exists buku;
create table buku(
	idbuku int not null auto_increment primary key,
	judulbuku varchar(50) not null
);
drop table if exists pengarang;
create table pengarang(
	idpengarang int not null auto_increment primary key,
	namapengarang varchar(50) not null
);
drop table if exists kata;
create table kata(
	idkata int not null auto_increment primary key,
	namakata varchar(50) not null,
	idf float
);
drop table if exists tag;
create table tag(
	idtag int not null auto_increment primary key,
	namatag varchar(50) not null
);
drop table if exists bukupengarang;
create table bukupengarang(
	idbuku int, foreign key (idbuku) references buku(idbuku),
	idpengarang int, foreign key (idpengarang) references pengarang(idpengarang)
);
drop table if exists bukutag;
create table bukutag(
	idbuku int, foreign key (idbuku) references buku(idbuku),
	idtag int, foreign key (idtag) references tag(idtag)
);
drop table if exists bukukata;
create table bukukata(
	idbuku int, foreign key (idbuku) references buku(idbuku),
	idkata int, foreign key (idkata) references kata(idkata),
	jmlkemunculan int,
	bobot float
);
drop table if exists eksemplar;
create table eksemplar(
	ideksemplar int not null auto_increment primary key,
	idbuku int, foreign key (idbuku) references buku(idbuku),
	status int not null
);

-- Bagian Peminjaman
drop table if exists anggota;
create table anggota(
	email varchar(50) not null primary key,
	nama varchar(50) not null,
	sandi varchar(50) not null,
	tipe varchar(50) not null
);
drop table if exists denda;
create table denda(
	tipedenda int not null primary key,
	tarif int not null
);
drop table if exists pemesanan;
create table pemesanan(
	idpemesanan int not null auto_increment primary key,
	email varchar(50), foreign key (email) references anggota(email),
	idbuku int, foreign key (idbuku) references buku(idbuku),
	tglpemesanan date not null,
	statuspemesanan varchar(50) not null
);
drop table if exists peminjaman;
create table peminjaman(
	idpeminjaman int not null auto_increment primary key,
	email varchar(50), foreign key (email) references anggota(email),
	ideksemplar int, foreign key (ideksemplar) references eksemplar(ideksemplar),
	tglpeminjaman date not null,
	tglpengembalian date,
	bataspengembalian date not null,
	durasihariterlambat int,
	besardenda int
);