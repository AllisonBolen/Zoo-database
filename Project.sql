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
/*
ZIC1: foreign key
*/
--CONSTRAINT ZIC1 FOREIGN KEY
);
--
CREATE TABLE exhibit
(
exhibitname	VARCHAR2(20)	PRIMARY KEY,		
climate		VARCHAR2(20)	NOT NULL,
managerssn	CHAR(9)			NOT NULL	
);
--
--
CREATE TABLE shop
(
shopid		INTEGER			PRIMARY KEY,
sname		VARCHAR2(15)	NOT NULL,
exhibitname	VARCHAR2(20)	NOT NULL
);
--
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
--zooemployee foreign keys
ALTER TABLE zooemployees
ADD FOREIGN KEY (superssn) references zooemployees(empssn)
Deferrable initially deferred;
ALTER TABLE zooemployees
ADD FOREIGN KEY (exhibitname) references exhibit(exhibitname)
Deferrable initially deferred;
--
--exhibit foreign key
ALTER TABLE exhibit
ADD FOREIGN KEY (managerssn) references zooemployees(empssn)
Deferrable initially deferred;
--
--shop foreign key
ALTER TABLE shop
ADD FOREIGN KEY (exhibitname) references exhibit(exhibitname)
Deferrable initially deferred;
--
--animal foreign keys
ALTER TABLE animal
ADD FOREIGN KEY (empssn) references zooemployees(empssn)
Deferrable initially deferred;
ALTER TABLE animal
ADD FOREIGN KEY (exhibitname) references exhibit(exhibitname)
Deferrable initially deferred;
--
--event foreign key
ALTER TABLE event
ADD FOREIGN KEY (exhibitname) references exhibit(exhibitname)
Deferrable initially deferred;
--
--shopproducts foreign key
ALTER TABLE shopproducts
ADD FOREIGN KEY (shopid) references shop(shopid)
Deferrable initially deferred;
--
--worksat foreign key
ALTER TABLE worksat
ADD FOREIGN KEY (empssn) references zooemployees(empssn)
Deferrable initially deferred;
ALTER TABLE worksat
ADD FOREIGN KEY (shopid) references shop(shopid)
Deferrable initially deferred;
--
--
--Insert values into the zooemployees table
INSERT INTO zooemployees VALUES (878792856, 'Jim', 'Smith', 'manager', '55 Redbarrow Rd.', 54000, '12-JUN-89', 'M', NULL, 'Penguin Park');
INSERT INTO zooemployees VALUES (135675234, 'Frank', 'Reynolds', 'shop manager', '124 Stage Rd.', 32000, '7-AUG-82', 'M', 878792856, 'Penguin Park');
INSERT INTO zooemployees VALUES (544667755, 'Tyler', 'Johnson', 'Tender', '9090 Left St.', 27000, '12-JUL-89', 'F', 878792856, 'Penguin Park');

INSERT INTO zooemployees VALUES (123456789, 'Salley', 'Jacobson', 'manager', '546 One Way', 57000, '11-JUN-95', 'F', NULL, 'Reptile Mania');
INSERT INTO zooemployees VALUES (456123789, 'Rebecca', 'Bing', 'Tender', '55 Yemen Rd.', 42000, '4-SEP-93', 'F', 123456789, 'Reptile Mania');
INSERT INTO zooemployees VALUES (987654321, 'Spencer', 'Matthews', 'Tender', '102 Stopper St.', 36000, '6-MAY-76', 'M', 123456789, 'Reptile Mania');

INSERT INTO zooemployees VALUES (771188229, 'Todd', 'Geller', 'manager', '443 Oak St.', 48000, '1-JAN-75', 'M', NULL, 'African Wild');
INSERT INTO zooemployees VALUES (993388227, 'Dave', 'Pollet', 'shop manager', '321 Odd Rd.', 37000, '1-MAY-84', 'M', 771188229, 'African Wild');
INSERT INTO zooemployees VALUES (971397139, 'Cassey', 'Mosbey', 'Tender', '6587 Even St.', 37000, '12-SEP-86', 'F', 771188229, 'African Wild');

INSERT INTO zooemployees VALUES (558822446, 'Bob', 'Topper', 'manager', '892 Simple Way', 65000, '9-OCT-91', 'M', NULL, 'Acquidic Adventure');
--
--
SET ECHO 
SPOOL OFF