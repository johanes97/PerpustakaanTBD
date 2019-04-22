-- phpMyAdmin SQL Dump
-- version 4.8.0
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: May 11, 2018 at 07:40 AM
-- Server version: 10.1.31-MariaDB
-- PHP Version: 7.2.4

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET AUTOCOMMIT = 0;
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `tugasbesarpbw2`
--

-- --------------------------------------------------------

--
-- Table structure for table `anggota`
--

CREATE TABLE `anggota` (
  `id_anggota` int(11) NOT NULL,
  `username` varchar(50) NOT NULL,
  `nama_anggota` varchar(100) NOT NULL,
  `password` varchar(50) NOT NULL,
  `alamat` varchar(100) NOT NULL,
  `no_hp` varchar(15) NOT NULL,
  `tgl_lahir` date NOT NULL,
  `role` varchar(10) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `anggota`
--

INSERT INTO `anggota` (`id_anggota`, `username`, `nama_anggota`, `password`, `alamat`, `no_hp`, `tgl_lahir`, `role`) VALUES
(1, 'aan', 'Andrianto', 'bebas', 'BJ', '081', '2018-05-08', 'user_biasa'),
(2, 'aga', 'aga putra', 'bebas', 'dhkshdk', '272897', '0072-07-28', 'user_biasa'),
(3, 'aldo', 'Aldo verrel', 'bebas', 'gshags', '79', '7686-06-08', 'user_biasa'),
(4, 'alvinus', 'Alvinus', 'bebas', 'BJD', '081313818883', '2018-05-07', 'user_biasa'),
(5, 'amabel', 'amabel l', 'bebas', 'shdjs', '27827', '0027-07-08', 'user_biasa'),
(6, 'anton', 'anton s', 'bebas', 'dksjhdks', '27827', '0076-06-02', 'user_biasa'),
(7, 'arnold', 'kevin a', 'bebas', 'bjak', '6378', '0000-00-00', 'user_biasa'),
(8, 'bil', 'billy s', 'bebas', 'gasha', '276726', '0872-02-07', 'user_biasa'),
(9, 'cah', 'cahyadi', 'bebas', 'whjdkhjw', '08929', '0000-00-00', 'user_biasa'),
(10, 'can', 'cantika', 'bebas', 'whjdhw', '27827', '0082-02-07', 'user_biasa'),
(11, 'chris', 'gunawan', 'bebas', 'hsjsh', '27829', '0027-02-06', 'user_biasa'),
(12, 'cindi', 'cindia w', 'bebas', 'hdjdhk', '28728', '0627-02-07', 'user_biasa'),
(13, 'david', 'David w', 'bebas', 'hdjhsdk', '323287', '0027-08-27', 'user_biasa'),
(59, 'dede', 'Dede', 'vJNGkXtv', 'BJ', '81', '2018-05-10', 'admin'),
(14, 'dian', 'Dian S', 'bebas', 'gsjhag', '278768', '0686-08-07', 'user_biasa'),
(65, 'didi', 'Didi', 'WBoH0Agy', 'BJD', '81', '2018-05-08', 'admin'),
(15, 'dini', 'Dini Puspita', 'bebas', 'hsjaks', '27827', '0873-07-31', 'user_biasa'),
(16, 'dipo', 'Pooo', 'bebas', 'hsjakh', '28278', '0068-06-27', 'user_biasa'),
(66, 'dudu', 'dudu', 'KOshQzU6', 'dsds', '33', '2018-05-11', 'admin'),
(17, 'ekel', 'garut', 'bebas', 'gshgq', '2628', '0072-02-06', 'user_biasa'),
(18, 'eldon', 'c eldon', 'bebas', 'hwkhw', '276726', '0028-02-07', 'user_biasa'),
(19, 'febrian', 'Febrian Nathan', 'bebas', 'ghjg', '678', '7676-07-06', 'user_biasa'),
(20, 'fer', 'ferdian', 'bebas', 'dshdkj', '7292', '8728-02-07', 'user_biasa'),
(21, 'firman', 'Firman sandi', 'bebas', 'shjahsk', '72872', '0072-02-07', 'user_biasa'),
(22, 'freng', 'frengki ang', 'bebas', 'sashak', '2782', '0728-02-06', 'user_biasa'),
(23, 'ger', 'gerry', 'bebas', 'sahskjha', '62876', '2018-05-07', 'user_biasa'),
(24, 'gopal', 'naofal', 'bebas', 'jdkjsld', '374983', '0067-02-28', 'user_biasa'),
(25, 'intan', 'intan c', 'bebas', 'hdjhs', '267287', '0726-02-06', 'user_biasa'),
(26, 'irvan', 'Irvan H', 'bebas', 'hskajhs', '73298', '0023-08-07', 'user_biasa'),
(27, 'irwan', 'Johanes', 'bebas', 'hskjahs', '2287', '0872-02-07', 'user_biasa'),
(28, 'ivan', 'ivan kris', 'bebas', 'basmban', '27827', '0072-02-07', 'user_biasa'),
(29, 'jason', 'jason', 'bebas', 'gshgaj', '26782', '0007-08-29', 'user_biasa'),
(30, 'jaya', 'Anugrah', 'bebas', 'bebas', '8728', '0276-02-07', 'user_biasa'),
(31, 'jl', 'joshua l', 'bebas', 'apa', '2267', '0722-07-26', 'user_biasa'),
(32, 'jojo', 'Jonathan Laksamana Purnomo', 'bebas', 'BJ', '081313', '2018-05-08', 'user_biasa'),
(33, 'jordan', 'Jordan', 'bebas', 'astana anyar', '7678', '0028-06-07', 'user_biasa'),
(34, 'kikiel', 'Yehezkiel', 'bebas', 'bebas', '09021', '0000-00-00', 'user_biasa'),
(35, 'lara', 'lara', 'bebas', 'dimana', '72938', '0272-06-23', 'user_biasa'),
(36, 'louis', 'louis g', 'bebas', 'hjdhkw', '6726', '0872-02-07', 'user_biasa'),
(37, 'michaelsc', 'Michael Stevin', 'bebas', 'sukaresmi', '081', '2018-05-07', 'user_biasa'),
(38, 'r', 'kevin r', 'bebas', 'gahsga', '7628', '0072-06-28', 'user_biasa'),
(39, 'ravi', 'm ravi', 'bebas', 'askajhs', '2289', '0000-00-00', 'user_biasa'),
(40, 'reggie', 'reggie g', 'bebas', 'hwdkhw', '26728', '0079-02-08', 'user_biasa'),
(41, 'reyirfan', 'reynaldi irfan', 'bebas', 'hajhsk', '729', '0000-00-00', 'user_biasa'),
(42, 'richarad', 'wijaya', 'bebas', 'hsdh', '6282', '0027-07-08', 'user_biasa'),
(43, 'sam', 'Samuel', 'bebas', '28928', '2782', '0087-02-09', 'user_biasa'),
(44, 'sandi', 'ucing', 'bebas', 'bbewk', '28762', '0286-02-06', 'user_biasa'),
(45, 'seph', 'joseph feb', 'bebas', 'hsjhq', '2672', '0829-02-07', 'user_biasa'),
(46, 'srul', 'Hasrul', 'bebas', 'bwbwk', '7268726', '0062-02-07', 'admin'),
(47, 'tomit', 'timothy', 'bebas', 'bebas', '278267', '0000-00-00', 'user_biasa'),
(48, 'winniiw', 'elisabeth', 'bebas', 'hdskhd', '287827', '0072-07-28', 'admin'),
(49, 'zaki', 'fikri', 'bebas', 'hjdkjhsk', '08167', '0000-00-00', 'user_biasa'),
(50, 'zega', 'titian nofa', 'bebas', 'bebas', '8279', '0000-00-00', 'admin');

-- --------------------------------------------------------

--
-- Table structure for table `buku`
--

CREATE TABLE `buku` (
  `id_buku` char(13) NOT NULL,
  `judul` varchar(100) NOT NULL,
  `pengarang` varchar(100) NOT NULL,
  `tahun_terbit` int(11) NOT NULL,
  `penerbit` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `buku`
--

INSERT INTO `buku` (`id_buku`, `judul`, `pengarang`, `tahun_terbit`, `penerbit`) VALUES
('1', 'SO', 'Tanenbaum', 1985, 'UNPAR'),
('10', 'indo', 'ratna', 5675, 'unpar'),
('11', 'kwn', 'huntoro', 6867, 'kanisius'),
('12', 'logika', 'thomas', 6786, 'erlangga'),
('123', 'Matematik', 'Dede', 2017, 'Erlangga'),
('13', 'pbo', 'vero', 6767, 'unpar'),
('14', 'aok', 'bagus', 2672, 'kanisius'),
('16', 'logika if', 'mariska', 6786, 'unpar'),
('17', 'matriks', 'yong', 6786, 'kanisius'),
('18', 'etika', 'rosa', 2672, 'erlangga'),
('19', 'pancas', 'mariska', 2162, 'unpar'),
('2', 'PSI', 'Tanenbaum', 1987, 'MIT'),
('20', 'ASD', 'husnul', 2672, 'unpar'),
('21', 'strukdis', 'nata', 2672, 'kanisius'),
('22', 'estetika', 'eko', 6373, 'visi'),
('23', 'RPL', 'claudio', 6721, 'unpar'),
('24', 'ADBO', 'nata', 6374, 'visi'),
('26', 'DAA', 'rosa', 6276, 'kanisius'),
('29', 'SO', 'tanenbaum', 2562, 'unpar'),
('3', 'MIBD', 'Veronica', 1999, 'UNPAR'),
('30', 'PSC', 'husnul', 2723, 'kanisius'),
('31', 'IMK', 'vero', 1363, 'erlangga'),
('321', 'Mat', 'dede', 2017, 'erlangga'),
('34', 'pengolahan citra', 'claudio', 6782, 'erlangga'),
('35', 'kewirus', 'adbis', 3627, 'unpar'),
('36', 'pbw', 'husnul', 2025, 'unpar'),
('4', 'rohani', 'billy graham', 1999, 'unpar'),
('5', 'komputasi', 'vero', 1999, 'unpar'),
('530', 'Matsss', 'DEDESS', 2000, 'AUUU'),
('550', 'AAAA', 'BBBB', 123, 'AUUU'),
('6', 'matdis', 'nata', 7896, 'erlangga'),
('600', 'JOJO', 'JOJO', 1234, 'JOJO'),
('6KQu', 'fenom2', 'Didi', 2017, 'UNPAR'),
('6XJv', 'fenom3', 'Didi', 2017, 'UNPAR'),
('7', 'PI', 'rosa', 4673, 'unpar'),
('8', 'matdas', 'wawan', 6782, 'erlangga'),
('9', 'katolik', 'yusuf', 7896, 'kanisius'),
('ALVIN', 'ALVIN', 'ALVIN', 1234, 'ALVIN'),
('lh2T', 'botol', 'botol', 2017, 'UNPAR'),
('og6l', 'fenom4', 'Didi', 2017, 'UNPAR'),
('QxKh', 'Fenom', 'Didi', 2017, 'UNPAR'),
('WUyk', 'fenom5', 'Didi', 2017, 'UNPAR'),
('XQXu', 'fenom2', 'Didi', 2017, 'UNPAR');

-- --------------------------------------------------------

--
-- Table structure for table `kategori`
--

CREATE TABLE `kategori` (
  `id_kategori` char(13) NOT NULL,
  `nama_kategori` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `kategori`
--

INSERT INTO `kategori` (`id_kategori`, `nama_kategori`) VALUES
('111', 'Seni'),
('112', 'Science'),
('113', 'Math');

-- --------------------------------------------------------

--
-- Table structure for table `kategori_buku`
--

CREATE TABLE `kategori_buku` (
  `id_buku` char(13) NOT NULL,
  `id_kategori` char(13) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `kategori_buku`
--

INSERT INTO `kategori_buku` (`id_buku`, `id_kategori`) VALUES
('1', '112'),
('2', '112'),
('1', '111'),
('1', '111'),
('3', '111'),
('4', '112'),
('5', '113'),
('6', '111'),
('7', '113'),
('8', '112'),
('9', '111'),
('10', '111'),
('11', '111'),
('11', '112'),
('13', '113'),
('14', '111'),
('16', '113'),
('17', '112'),
('18', '111'),
('19', '111'),
('20', '112'),
('21', '112'),
('23', '113'),
('22', '111'),
('24', '112'),
('26', '111'),
('26', '111'),
('29', '112'),
('29', '111'),
('30', '113'),
('30', '112'),
('31', '113'),
('34', '112'),
('35', '111'),
('36', '112'),
('123', '113'),
('123', '113'),
('123', '113'),
('123', '113'),
('123', '113'),
('123', '113'),
('123', '113'),
('530', '113'),
('530', '113'),
('550', '113'),
('550', '113'),
('600', '111'),
('ALVIN', '111'),
('QxKh', '111'),
('6KQu', '113'),
('XQXu', '113'),
('6XJv', '111'),
('og6l', '111'),
('WUyk', '111'),
('lh2T', '113');

-- --------------------------------------------------------

--
-- Table structure for table `peminjaman`
--

CREATE TABLE `peminjaman` (
  `id_peminjaman` int(11) NOT NULL,
  `tgl_pinjam` date NOT NULL,
  `tgl_kembali` date NOT NULL,
  `username` varchar(50) NOT NULL,
  `id_buku` char(13) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `peminjaman`
--

INSERT INTO `peminjaman` (`id_peminjaman`, `tgl_pinjam`, `tgl_kembali`, `username`, `id_buku`) VALUES
(1, '2018-05-06', '2018-05-16', 'alvinus', '1'),
(2, '2018-05-06', '2018-05-11', 'alvinus', '2'),
(13, '2018-05-07', '2018-05-15', 'arnold', '4'),
(14, '2018-05-14', '2018-05-23', 'eldon', '5'),
(15, '2018-05-09', '2018-05-21', 'arnold', '2'),
(16, '2018-05-09', '2018-05-28', 'arnold', '13'),
(17, '2018-05-13', '2018-05-20', 'eldon', '10'),
(18, '2018-05-07', '2018-05-14', 'alvinus', '3'),
(19, '2018-05-11', '2018-05-28', 'chris', '6'),
(20, '2018-05-03', '2018-05-27', 'chris', '8'),
(21, '2018-05-16', '2018-05-19', 'ekel', '12'),
(22, '2018-05-08', '2018-05-29', 'eldon', '14'),
(23, '2018-05-10', '2018-05-22', 'can', '16'),
(24, '2018-06-05', '2018-05-20', 'arnold', '16'),
(25, '2018-05-24', '2018-06-01', 'alvinus', '19'),
(26, '2018-05-07', '2018-05-14', 'chris', '20'),
(27, '2018-05-18', '2018-05-25', 'chris', '21'),
(28, '2018-05-23', '2018-05-29', 'amabel', '22'),
(29, '2018-06-13', '2018-06-20', 'ekel', '23'),
(30, '2018-05-09', '2018-05-15', 'eldon', '24'),
(31, '2018-05-27', '2018-05-30', 'arnold', '7');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `anggota`
--
ALTER TABLE `anggota`
  ADD UNIQUE KEY `username` (`username`),
  ADD UNIQUE KEY `id_anggota` (`id_anggota`);

--
-- Indexes for table `buku`
--
ALTER TABLE `buku`
  ADD UNIQUE KEY `id_buku` (`id_buku`);

--
-- Indexes for table `kategori`
--
ALTER TABLE `kategori`
  ADD UNIQUE KEY `id_kategori` (`id_kategori`);

--
-- Indexes for table `kategori_buku`
--
ALTER TABLE `kategori_buku`
  ADD KEY `id_buku_FK` (`id_buku`),
  ADD KEY `id_kategori_FK` (`id_kategori`);

--
-- Indexes for table `peminjaman`
--
ALTER TABLE `peminjaman`
  ADD UNIQUE KEY `id_peminjaman` (`id_peminjaman`),
  ADD KEY `username` (`username`),
  ADD KEY `id_buku` (`id_buku`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `anggota`
--
ALTER TABLE `anggota`
  MODIFY `id_anggota` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=67;

--
-- AUTO_INCREMENT for table `peminjaman`
--
ALTER TABLE `peminjaman`
  MODIFY `id_peminjaman` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=32;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `kategori_buku`
--
ALTER TABLE `kategori_buku`
  ADD CONSTRAINT `id_buku_FK` FOREIGN KEY (`id_buku`) REFERENCES `buku` (`id_buku`),
  ADD CONSTRAINT `id_kategori_FK` FOREIGN KEY (`id_kategori`) REFERENCES `kategori` (`id_kategori`);

--
-- Constraints for table `peminjaman`
--
ALTER TABLE `peminjaman`
  ADD CONSTRAINT `id_buku` FOREIGN KEY (`id_buku`) REFERENCES `buku` (`id_buku`),
  ADD CONSTRAINT `username` FOREIGN KEY (`username`) REFERENCES `anggota` (`username`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
