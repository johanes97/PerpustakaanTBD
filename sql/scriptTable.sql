--Nama basis data: perpustakaantbd

--Bagian Buku
create table buku(
	idbuku int not null auto_increment primary key,
	judulbuku varchar(50) not null
);
create table pengarang(
	idpengarang int not null auto_increment primary key,
	namapengarang varchar(50) not null
);
create table kata(
	idkata int not null auto_increment primary key,
	namakata varchar(50) not null,
	idf float
);
create table tag(
	idtag int not null auto_increment primary key,
	namatag varchar(50) not null
);
create table bukupengarang(
	idbuku int, foreign key (idbuku) references buku(idbuku),
	idpengarang int, foreign key (idpengarang) references pengarang(idpengarang)
);
create table bukutag(
	idbuku int, foreign key (idbuku) references buku(idbuku),
	idtag int, foreign key (idtag) references tag(idtag)
);
create table bukukata(
	idbuku int, foreign key (idbuku) references buku(idbuku),
	idkata int, foreign key (idkata) references kata(idkata),
	jmlkemunculan int,
	bobot float
);
create table eksemplar(
	ideksemplar int not null primary key,
	idbuku int, foreign key (idbuku) references buku(idbuku),
	status int not null
);

--Bagian Peminjaman
create table anggota(
	email varchar(50) not null primary key,
	nama varchar(50) not null,
	sandi varchar(50) not null,
	tipe varchar(50) not null
);
create table denda(
	tipedenda int not null primary key,
	tarif int not null
);
create table pemesanan(
	idpemesanan int not null auto_increment primary key,
	email varchar(50), foreign key (email) references anggota(email),
	idbuku int, foreign key (idbuku) references buku(idbuku),
	tglpemesanan date not null
);
create table peminjaman(
	idpeminjaman int not null auto_increment primary key,
	email varchar(50), foreign key (email) references anggota(email),
	ideksemplar int, foreign key (ideksemplar) references eksemplar(ideksemplar),
	tglpeminjaman date not null,
	tglpengembalian date,
	bataspengembalian date not null,
	durasihariterlambat int,
	besardenda money
);