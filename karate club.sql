drop database KARATE;
CREATE DATABASE KARATE;
USE KARATE;

CREATE TABLE ogrenciler(
id INT PRIMARY KEY NOT NULL,
ad CHAR (20),
soyad CHAR (20),
dogum_tarihi DATE,
uye_tarihi DATE
);

CREATE TABLE s_ogrenciler(
id INT PRIMARY KEY NOT NULL,
ad CHAR (20),
soyad CHAR (20),
dogum_tarihi DATE,
uye_tarihi DATE
);

CREATE TABLE hocalar(
id INT PRIMARY KEY NOT NULL,
ad CHAR (20),
soyad CHAR (20),
dogum_tarihi DATE
);

CREATE TABLE s_hocalar(
id INT PRIMARY KEY NOT NULL,
ad CHAR (20),
soyad CHAR (20),
dogum_tarihi DATE
);

CREATE TABLE gruplar(
id INT PRIMARY KEY NOT NULL,
adi CHAR (20),
seviye CHAR(20)
);

CREATE TABLE s_gruplar(
id INT PRIMARY KEY NOT NULL,
adi CHAR (20),
seviye CHAR(05)
);

CREATE TABLE ogrenci_grup(
ogrenci_id INT,
grup_id INT,
PRIMARY KEY (ogrenci_id, grup_id),
	FOREIGN KEY (ogrenci_id)
    REFERENCES ogrenciler(id)
		ON UPDATE CASCADE
        ON DELETE CASCADE,
	FOREIGN KEY (grup_id)
    REFERENCES gruplar(id)
		ON UPDATE CASCADE
        ON DELETE CASCADE
);
CREATE TABLE hoca_grup(
hoca_id INT,
grup_id INT,
PRIMARY KEY (hoca_id, grup_id),
	FOREIGN KEY (hoca_id)
    REFERENCES hocalar(id)
		ON UPDATE CASCADE
        ON DELETE CASCADE,
	FOREIGN KEY (grup_id)
    REFERENCES gruplar(id)
		ON UPDATE CASCADE
        ON DELETE CASCADE
);
INSERT INTO ogrenciler(id, ad, soyad, dogum_tarihi, uye_tarihi)
	VALUES (01, 'emir', 'emiroglu', '1997-01-01', '2022-01-01'),
		   (02, 'ilayda', 'rabia', '2002-01-01','2021-01-01'),
           (03, 'yaso', 'aslan', '2000-01-01','2020-01-01'),
           (04, 'efe', 'aydın', '1985-01-01','2019-01-01');
INSERT INTO hocalar(id, ad, soyad, dogum_tarihi)
	VALUES (01, 'ugur', 'balkan', '1997-01-01'),
		   (02, 'emre', 'vecdi', '2002-01-01'),
           (03, 'tugba', 'deniz', '2000-01-01'),
           (04, 'engin', 'men', '1985-01-01');
INSERT INTO gruplar(id, adi, seviye)
	VALUES (01, 'ders1', 'A'),
		   (02, 'ders2', 'B'),
           (03, 'ders3', 'C'),
           (04,null , null);

INSERT INTO ogrenci_grup(ogrenci_id, grup_id)
	VALUES (01,01),
           (02,02),
		   (03,04),
		   (04,04);
           
INSERT INTO hoca_grup(hoca_id, grup_id)
	VALUES (01,01),
           (01,03),
		   (02,03),
		   (02,02),
           (03,01),
           (03,02),
           (03,03),
           (04,03);
           
DELIMITER $$
CREATE TRIGGER s_ogrenciler BEFORE DELETE
ON ogrenciler
FOR EACH ROW
BEGIN
INSERT INTO s_ogrenciler (id, ad, soyad, dogum_tarihi, uye_tarihi)
	VALUES (OLD.id, OLD.ad, OLD.soyad, OLD.dogum_tarihi, OLD.uye_tarihi);
END $$
DELIMITER ;

DELIMITER $$
CREATE TRIGGER s_hocalar BEFORE DELETE
ON hocalar
FOR EACH ROW
BEGIN
INSERT INTO s_hocalar (id, ad, soyad, dogum_tarihi)
	VALUES (OLD.id, OLD.ad, OLD.soyad, OLD.dogum_tarihi);
END $$
DELIMITER ;


DELIMITER $$
CREATE TRIGGER s_gruplar BEFORE DELETE
ON gruplar
FOR EACH ROW
BEGIN
INSERT INTO deleted_users (id, adi, seviye)
	VALUES (OLD.id, OLD.adi, OLD.seviye);
END $$
DELIMITER ;

# Hiçbir gruba üye olmayan öğrencilerin adı ve soyadı
SELECT
	ad, soyad
FROM
	ogrenciler as o
WHERE
	id IN (
		select ogrenci_id
        from ogrenci_grup as og
        where og.grup_id = 04 
    );
    
# Herbir hoca için ders verdiği grubun öğrenci sayısı
SELECT h.ad, h.soyad,
COUNT(hg.hoca_id)
FROM
	hoca_grup as hg
INNER JOIN
	hocalar as h
ON h.id = hg.hoca_id
GROUP BY h.id;