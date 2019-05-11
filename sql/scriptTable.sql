-- Nama basis data: perpustakaantbd

-- Bagian Buku
create table buku(
	idbuku int not null auto_increment primary key,
	judulbuku varchar(50) not null,
	deleted int not null
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
	idbuku int not null, foreign key (idbuku) references buku(idbuku),
	idpengarang int not null, foreign key (idpengarang) references pengarang(idpengarang)
);
create table bukutag(
	idbuku int not null, foreign key (idbuku) references buku(idbuku),
	idtag int not null, foreign key (idtag) references tag(idtag)
);
create table bukukata(
	idbuku int not null, foreign key (idbuku) references buku(idbuku),
	idkata int not null, foreign key (idkata) references kata(idkata),
	jmlkemunculan int,
	bobot float
);
create table eksemplar(
	ideksemplar int not null auto_increment primary key,
	idbuku int not null, foreign key (idbuku) references buku(idbuku),
	status int not null,
	deleted int not null
);

-- Bagian Peminjaman
create table anggota(
	email varchar(50) not null primary key,
	nama varchar(50) not null,
	sandi varchar(50) not null,
	tipe varchar(50) not null
);
create table denda(
	tarif int not null primary key,
	jumlahhari int not null
);
create table pemesanan(
	idpemesanan int not null auto_increment primary key,
	email varchar(50) not null, foreign key (email) references anggota(email),
	idbuku int not null, foreign key (idbuku) references buku(idbuku),
	tglpemesanan date not null,
	statuspemesanan varchar(50) not null
);
create table peminjaman(
	idpeminjaman int not null auto_increment primary key,
	email varchar(50) not null, foreign key (email) references anggota(email),
	ideksemplar int not null, foreign key (ideksemplar) references eksemplar(ideksemplar),
	tglpeminjaman date not null,
	tglpengembalian date,
	bataspengembalian date not null,
	durasihariterlambat int not null,
	besardenda int not null,
	statuspeminjaman varchar(50)
);