SPOOL ZooDB.out
SET ECHO ON
--
-- 353 Database Project
-- Zoo Database
--
-- *Authors
-- <Allison Bolen>
-- <Andrew Olesak>
-- <Jake Walton>
-- <Kasey Walton>
--
DROP TABLE zooemployees CASCADE CONSTRAINTS;
DROP TABLE exhibit CASCADE CONSTRAINTS;
DROP TABLE shop CASCADE CONSTRAINTS;
DROP TABLE animal CASCADE CONSTRAINTS;
DROP TABLE event CASCADE CONSTRAINTS;
DROP TABLE shopproducts CASCADE CONSTRAINTS;
DROP TABLE worksat CASCADE CONSTRAINTS;
--
CREATE TABLE zooemployees
(
empssn		CHAR(9)			PRIMARY KEY,
firstname	VARCHAR2(15)	NOT NULL,
lastname	VARCHAR2(15)	NOT NULL,
position	VARCHAR2(15)	NOT NULL,
eaddress	VARCHAR2(30)	NOT NULL,		
esalary		NUMBER(10,2)	NOT NULL,
ebdate		DATE			NOT NULL,
egender		CHAR			NOT NULL,
superssn	CHAR(9),
exhibitname	VARCHAR2(20)	NOT NULL
);
--
CREATE TABLE exhibit
(
exhibitname	VARCHAR2(20)	PRIMARY KEY,		
climate		VARCHAR2(20)	NOT NULL,
superssn	CHAR(9)			NOT NULL	
);
--
CREATE TABLE shop
(
shopid		INTEGER			PRIMARY KEY,
sname		VARCHAR2(15)	NOT NULL,
exhibitname	VARCHAR2(20)	NOT NULL
);
--
CREATE TABLE animal
(
aid			INTEGER			PRIMARY KEY,
species		VARCHAR2(15)	NOT NULL,
age			INTEGER			NOT NULL,
agender		CHAR			NOT NULL,
empssn		CHAR(9)			NOT	NULL,
tendtime	CHAR(5)			NOT NULL,
exhibitname	VARCHAR2(20)	NOT NULL	
);
--
CREATE TABLE event
(
exhibitname	VARCHAR2(20),
evdate		DATE,
type		VARCHAR2(20)	NOT NULL,
PRIMARY KEY(exhibitname, evdate)	
);
--
CREATE TABLE shopproducts
(
shopid		INTEGER,
productname	VARCHAR2(20),
PRIMARY KEY(shopid, productname)		
);
--
CREATE TABLE worksat
(
empssn		CHAR(9),
shopid		INTEGER,
PRIMARY KEY(empssn, shopid)
);
--
SET ECHO OFF
SPOOL OFF