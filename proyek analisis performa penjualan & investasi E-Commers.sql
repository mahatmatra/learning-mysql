CREATE DATABASE ecommers_analytics;
use ecommers_analytics;

create table pelanggan (
id_pelanggan varchar (10) primary key,
nama varchar (25),
kota varchar (25),
tanggal_daftar Date);

create table produk (
id_produk varchar (10) primary key,
nama_produk varchar (25),
kategori varchar (25),
harga_beli int,
harga_jual int,
stok int);

create table pesanan (
id_pesanan varchar (10) primary key,
id_pelanggan varchar (10),
tanggal_transaksi date,
status_bayar varchar (20),
foreign key (id_pelanggan) references pelanggan (id_pelanggan)
);

create table detail_pesanan (
id_detail int primary key,
id_pesanan varchar (10),
id_produk varchar (10),
qty int,
foreign key (id_pesanan) references pesanan (id_pesanan),
foreign key (id_produk) references produk (id_produk));

select * from detail_pesanan;

select * from pelanggan;

show databases;

select
p.nama_produk,
p.kategori,
sum(dp.qty) as total_terjual,
sum((p.harga_jual - p.harga_beli) *
dp.qty) as total_profit
from detail_pesanan dp
join produk p on dp.id_produk =
p.id_produk
join pesanan ps on dp.id_pesanan =
ps.id_pesanan
where ps.status_bayar = 'selesai'
group by p.id_produk, p.nama_produk,
p.kategori
order by total_profit desc;

SELECT 
    plg.kota,
    COUNT(DISTINCT ps.id_pesanan) AS jumlah_transaksi,
    SUM(p.harga_jual * dp.qty) AS total_pendapatan
FROM detail_pesanan dp
JOIN pesanan ps ON dp.id_pesanan = ps.id_pesanan
JOIN pelanggan plg ON ps.id_pelanggan = plg.id_pelanggan
JOIN produk p ON dp.id_produk = p.id_produk
WHERE ps.status_bayar = 'Selesai'
GROUP BY plg.kota
ORDER BY total_pendapatan DESC;

SELECT 
    id_produk, 
    nama_produk, 
    stok AS sisa_stok_gudang
FROM produk
WHERE stok <= 5
ORDER BY stok ASC;

SELECT 
    p.nama,
    p.kota,
    COUNT(ps.id_pesanan) AS total_belanja
FROM pesanan ps
JOIN pelanggan p ON ps.id_pelanggan = p.id_pelanggan
WHERE ps.status_bayar = 'Selesai'
GROUP BY p.id_pelanggan, p.nama, p.kota
HAVING total_belanja >= 2
ORDER BY total_belanja DESC;

CREATE TABLE tabel_analisis_ecommerce AS
SELECT 
    dp.id_detail,
    ps.id_pesanan,
    ps.tanggal_transaksi,
    MONTHNAME(ps.tanggal_transaksi) AS bulan, 
    ps.status_bayar,
    plg.nama AS nama_pelanggan,
    plg.kota AS kota_pelanggan,
    p.nama_produk,
    p.kategori AS kategori_produk,
    p.harga_beli,
    p.harga_jual,
    dp.qty,
    (p.harga_jual * dp.qty) AS total_pendapatan,
    ((p.harga_jual - p.harga_beli) * dp.qty) AS total_profit
FROM detail_pesanan dp
JOIN pesanan ps ON dp.id_pesanan = ps.id_pesanan
JOIN pelanggan plg ON ps.id_pelanggan = plg.id_pelanggan
JOIN produk p ON dp.id_produk = p.id_produk;

select * from tabel_analisis_ecommerce;

