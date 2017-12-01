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
eaddress	VARCHAR2(60)	NOT NULL,		
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
sname		VARCHAR2(30)	NOT NULL,
exhibitname	VARCHAR2(20)	NOT NULL
);
--
--
CREATE TABLE animal
(
aid			INTEGER			PRIMARY KEY,
species		VARCHAR2(30)	NOT NULL,
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
productname	VARCHAR2(35),
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
-- -----------------------------------------------------
-- Populate the database
-- -----------------------------------------------------
--
alter session set NLS_DATE_FORMAT = 'YYYY-MM-DD';
--
-- Exhibits
insert into exhibit values ('Tiger Realm', 'Temperate', 635052791);
insert into exhibit values ('Shores Aquarium', 'Polar', 543145276);
insert into exhibit values ('Pelican Pier', 'Temperate', 187225055);
insert into exhibit values ('Tropic Treasures', 'Tropical', 397981967);
insert into exhibit values ('Wild Way Trail', 'Temperate', 405249752);
insert into exhibit values ('Petting Zoo', 'Temperate', 198204924);
insert into exhibit values ('Africa', 'Arid', 306369902);
insert into exhibit values ('North America', 'Temperate', 594494079);
insert into exhibit values ('South America', 'Mediterranean', 660054663);
insert into exhibit values ('Frogs', 'Tropical', 170725571);
insert into exhibit values ('Forest Realm', 'Temperate', 114327791);
insert into exhibit values ('Monkeys', 'Tropical', 216407536);
--
-- supervisors
insert into zooemployees values (130423454, 'Ronnie', 'Alvarado', 'Supervisor', '4960 Farland Street, Grand Rapids, MI', '72000', '1970-04-15', 'M', NULL, 'Pelican Pier');
insert into zooemployees values (635052791, 'Patricia', 'Scott', 'Supervisor', '1743 Cinnamon Lane, Grand Rapids, MI', '60000', '1971-09-27', 'F', 130423454, 'Tiger Realm');
insert into zooemployees values (543145276, 'Brenda', 'Myers', 'Supervisor', '2338 Skinner Hollow Road, Grand Rapids, MI', '61000', '1962-05-31', 'F', 130423454, 'Shores Aquarium');
insert into zooemployees values (187225055, 'Michael', 'Tejada', 'Supervisor', '531 Stoney Lonesome Road, Grand Rapids, MI', '62000', '1975-09-01', 'M', 130423454, 'Pelican Pier');
insert into zooemployees values (397981967, 'David', 'Gullett', 'Supervisor', '4796 Trouser Leg Road, Grand Rapids, MI', '63000', '1979-01-29', 'M', 130423454, 'Tropic Treasures');
insert into zooemployees values (405249752, 'Reginald', 'Phillips', 'Supervisor', '1984 Straford Park, Grand Rapids, MI', '64000', '1985-08-22', 'M', 130423454, 'Wild Way Trail');
insert into zooemployees values (198204924, 'Jack', 'Arnold', 'Supervisor', '2385 Pride Avenue, Grand Rapids, MI', '65000', '1983-05-10', 'M', 130423454, 'Petting Zoo');
insert into zooemployees values (306369902, 'Robert', 'Bradley', 'Supervisor', '1524 Neville Street, Grand Rapids, MI', '66000', '1974-01-24', 'M', 130423454, 'Africa');
insert into zooemployees values (594494079, 'Sheila', 'Lane', 'Supervisor', '4387 Badger Pond Lane, Grand Rapids, MI', '67000', '1975-11-13', 'F', 130423454, 'North America');
insert into zooemployees values (660054663, 'Jennifer', 'Atencio', 'Supervisor', '4035 Wood Street, Grand Rapids, MI', '68000', '1989-12-05', 'F', 130423454, 'South America');
insert into zooemployees values (170725571, 'Allie', 'Owens', 'Supervisor', '3475 Lost Creek Road, Grand Rapids, MI', '69000', '1985-12-14', 'F', 130423454, 'Frogs');
insert into zooemployees values (114327791, 'Jennifer', 'Doe', 'Supervisor', '710 Huntz Lane, Grand Rapids, MI', '70000', '1970-12-22', 'F', 130423454, 'Forest Realm');
insert into zooemployees values (216407536, 'Georgia', 'Murray', 'Supervisor', '2236 Blue Spruce Lane, Grand Rapids, MI', '71000', '1976-05-19', 'F', 130423454, 'Monkeys');
--
-- Zoo Cashiers
insert into zooemployees values (681102346, 'Karl', 'Callahan', 'Cashier', '1312 Fire Access Rd, Grand Rapids, MI', '16000', '1958-12-09', 'M', 635052791, 'Tiger Realm');
insert into zooemployees values (167360529, 'Richard', 'Smith', 'Cashier', '2777 Conference Center Way, Grand Rapids, MI', '16100', '1979-04-30', 'M', 635052791, 'Tiger Realm');
insert into zooemployees values (531256644, 'Greg', 'Diaz', 'Cashier', '3603 Mudlick Road, Grand Rapids, MI', '16200', '1992-06-22', 'M', 187225055, 'Pelican Pier');
insert into zooemployees values (370125667, 'Gertrude', 'English', 'Cashier', '1692 Howard Street, Grand Rapids, MI', '16300', '1992-10-08', 'F', 397981967, 'Tropic Treasures');
insert into zooemployees values (192760485, 'Geraldine', 'Guest', 'Cashier', '3778 Turkey Pen Road, Grand Rapids, MI', '16400', '1988-02-11', 'F', 405249752, 'Wild Way Trail');
insert into zooemployees values (464626469, 'Mary', 'Brown', 'Cashier', '4685 Giraffe Hill Drive, Grand Rapids, MI', '16500', '1989-06-28', 'F', 187225055, 'Pelican Pier');
insert into zooemployees values (321184990, 'Holly', 'Hess', 'Cashier', '33 Butternut Lane, Grand Rapids, MI', '16600', '1953-02-03', 'F', 306369902, 'Africa');
insert into zooemployees values (811420103, 'Ronnie', 'Gaillard', 'Cashier', '3539 Freshour Circle, Grand Rapids, MI', '16700', '1990-10-28', 'M', 594494079, 'North America');
insert into zooemployees values (278786624, 'Adam', 'Spencer', 'Cashier', '3542 Upland Avenue, Grand Rapids, MI', '16800', '1983-05-05', 'M', 660054663, 'South America');
insert into zooemployees values (260437927, 'Cassie', 'Schmitt', 'Cashier', '2706 Kidd Avenue, Grand Rapids, MI', '16900', '1994-04-07', 'F', 114327791, 'Forest Realm');
insert into zooemployees values (564364430, 'Wally', 'Perkinson', 'Cashier', '2647 Austin Avenue, Grand Rapids, MI', '17000', '1992-03-21', 'M', 114327791, 'Forest Realm');
insert into zooemployees values (763010925, 'Joanna', 'Sterling', 'Cashier', '51 Chenoweth Drive, Grand Rapids, MI', '17100', '1992-09-29', 'F', 405249752, 'Wild Way Trail');
insert into zooemployees values (313236075, 'Richard', 'Paul', 'Cashier', '4950 Raintree Boulevard, Grand Rapids, MI', '17200', '1992-10-06', 'M', 187225055, 'Pelican Pier');
insert into zooemployees values (251828867, 'Benjamin', 'Luong', 'Cashier', '2317 Marion Street, Grand Rapids, MI', '17300', '1993-02-27', 'M', 397981967, 'Tropic Treasures');
insert into zooemployees values (178269601, 'Gina', 'Clear', 'Cashier', '301 Coal Street, Grand Rapids, MI', '17400', '1990-08-27', 'F', 216407536, 'Monkeys');
--
--Zoo Baristas
insert into zooemployees values (574127433, 'Monica', 'Kamp', 'Barista', '1709 Williams Mine Road, Grand Rapids, MI', '20800', '1993-07-07', 'F', 187225055, 'Pelican Pier');
insert into zooemployees values (255728306, 'Carl', 'Guerra', 'Barista', '4331 Hart Country Lane, Grand Rapids, MI', '20900', '1988-10-16', 'M', 114327791, 'Forest Realm');
--
-- Zoo Cooks
insert into zooemployees values (427481397, 'Tania', 'Ramirez', 'Cook', '2043 Kelley Road, Grand Rapids, MI', '22800', '1993-07-07', 'F', 397981967, 'Tropic Treasures');
insert into zooemployees values (416860165, 'Terrence', 'Harrison', 'Cook', '35 Turkey Pen Lane, Grand Rapids, MI', '22900', '1981-12-14', 'M', 397981967, 'Tropic Treasures');
insert into zooemployees values (378213720, 'Avery', 'Foster', 'Cook', '691 Tennessee Avenue, Grand Rapids, MI', '23000', '1994-10-18', 'M', 660054663, 'South America');
insert into zooemployees values (256728014, 'Stephanie', 'Grant', 'Cook', '1513 Junior Avenue, Grand Rapids, MI', '23100', '1991-10-21', 'F', 660054663, 'South America');
--
-- Janitors
insert into zooemployees values (508325683, 'Craig', 'Miller', 'Janitor', '3897 Bungalow Road, Grand Rapids, MI', '24900', '1975-01-11', 'M', 635052791, 'Tiger Realm');
insert into zooemployees values (399628898, 'Herbert', 'Clark', 'Janitor', '1347 Primrose Lane, Grand Rapids, MI', '25000', '1955-03-23', 'M', 543145276, 'Shores Aquarium');
insert into zooemployees values (461817489, 'Nickolas', 'Russell', 'Janitor', '2752 Gore Street, Grand Rapids, MI', '25100', '1990-06-21', 'M', 187225055, 'Pelican Pier');
insert into zooemployees values (239498729, 'James', 'Williams', 'Janitor', '3782 Patton Lane, Grand Rapids, MI', '25200', '1987-11-13', 'M', 397981967, 'Tropic Treasures');
insert into zooemployees values (171403537, 'Lottie', 'Adams', 'Janitor', '3498 Hanover Street, Grand Rapids, MI', '25300', '1970-09-09', 'F', 405249752, 'Wild Way Trail');
insert into zooemployees values (761015455, 'Karen', 'Becker', 'Janitor', '1834 Farm Meadow Drive, Grand Rapids, MI', '25400', '1962-11-20', 'F', 198204924, 'Petting Zoo');
insert into zooemployees values (675264747, 'Mary', 'Whaley', 'Janitor', '3893 Pine Garden Lane, Grand Rapids, MI', '25500', '1991-05-25', 'F', 306369902, 'Africa');
insert into zooemployees values (386441888, 'Thomas', 'Garcia', 'Janitor', '3079 Corpening Drive, Grand Rapids, MI', '25600', '1975-12-11', 'M', 594494079, 'North America');
insert into zooemployees values (408920818, 'Stephanie', 'Lafountain', 'Janitor', '4821 Arlington Avenue, Grand Rapids, MI', '25700', '1983-11-23', 'F', 660054663, 'South America');
insert into zooemployees values (464128775, 'Mario', 'Martinez', 'Janitor', '2741 Sundown Lane, Grand Rapids, MI', '25800', '1967-09-04', 'M', 170725571, 'Frogs');
insert into zooemployees values (644028125, 'Jerry', 'Peyton', 'Janitor', '3834 Ashton Lane, Grand Rapids, MI', '25900', '1965-05-31', 'M', 114327791, 'Forest Realm');
insert into zooemployees values (198820069, 'James', 'Fox', 'Janitor', '555 Woodland Terrace, Grand Rapids, MI', '26000', '1967-07-15', 'M', 216407536, 'Monkeys');
--
-- Caretakers
insert into zooemployees values (622347022, 'Annie', 'Allen', 'Caretaker', '797 Heritage Road, Grand Rapids, MI', '35000', '1986-11-05', 'F', 635052791, 'Tiger Realm');
insert into zooemployees values (392058668, 'Kelly', 'Vanwagenen', 'Caretaker', '442 Comfort Court, Grand Rapids, MI', '35100', '1976-09-05', 'F', 543145276, 'Shores Aquarium');
insert into zooemployees values (149039012, 'Jessica', 'Coburn', 'Caretaker', '4817 Webster Street, Grand Rapids, MI', '35200', '1983-12-23', 'F', 187225055, 'Pelican Pier');
insert into zooemployees values (595061909, 'Patrick', 'Shreve', 'Caretaker', '4843 Tyler Avenue, Grand Rapids, MI', '35300', '1994-11-13', 'M', 397981967, 'Tropic Treasures');
insert into zooemployees values (590600939, 'Teri', 'McClary', 'Caretaker', '326 Steve Hunt Road, Grand Rapids, MI', '35400', '1967-05-01', 'F', 405249752, 'Wild Way Trail');
insert into zooemployees values (135681064, 'Bernard', 'Johnston', 'Caretaker', '663 Melm Street, Grand Rapids, MI', '35500', '1971-06-04', 'M', 198204924, 'Petting Zoo');
insert into zooemployees values (511844657, 'John', 'Mathews', 'Caretaker', '3989 Sigley Road, Grand Rapids, MI', '35600', '1983-06-18', 'M', 306369902, 'Africa');
insert into zooemployees values (445661181, 'Samantha', 'Garcia', 'Caretaker', '90 Late Avenue, Grand Rapids, MI', '35700', '1982-01-05', 'F', 594494079, 'North America');
insert into zooemployees values (644284210, 'Catherine', 'Farrington', 'Caretaker', '4880 Brooke Street, Grand Rapids, MI', '35800', '1988-09-24', 'F', 660054663, 'South America');
insert into zooemployees values (421562138, 'Willie', 'Nixon', 'Caretaker', '3409 Wright Court, Grand Rapids, MI', '35900', '1952-03-11', 'M', 170725571, 'Frogs');
insert into zooemployees values (265036954, 'Kathy', 'Stewart', 'Caretaker', '4089 George Street, Grand Rapids, MI', '36000', '1984-02-22', 'F', 114327791, 'Forest Realm');
insert into zooemployees values (103010924, 'Marjorie', 'Castaneda', 'Caretaker', '1782 Anmoore Road, Grand Rapids, MI', '36100', '1985-07-22', 'F', 216407536, 'Monkeys');
--
-- Vets
insert into zooemployees values (571707179, 'Peggy', 'Baker', 'Vet', '1696 Black Oak Hollow Road, Grand Rapids, MI', '50000', '1973-10-28', 'F', 635052791, 'Tiger Realm');
insert into zooemployees values (166701386, 'Silas', 'Foulk', 'Vet', '4373 Saint James Drive, Grand Rapids, MI', '51000', '1976-04-22', 'M', 543145276, 'Shores Aquarium');
insert into zooemployees values (460085712, 'Doris', 'Patterson', 'Vet', '697 South Street, Grand Rapids, MI', '52000', '1979-07-13', 'F', 187225055, 'Pelican Pier');
insert into zooemployees values (479360155, 'Steven', 'Davis', 'Vet', '4355 Woodland Drive, Grand Rapids, MI', '53000', '1983-03-06', 'M', 397981967, 'Tropic Treasures');
insert into zooemployees values (542100923, 'Veronica', 'Morales', 'Vet', '1655 Heron Way, Grand Rapids, MI', '54000', '1984-08-17', 'F', 405249752, 'Wild Way Trail');
insert into zooemployees values (457903419, 'Connie', 'Landis', 'Vet', '3637 Colonial Drive, Grand Rapids, MI', '55000', '1971-05-29', 'F', 198204924, 'Petting Zoo');
insert into zooemployees values (265755073, 'John', 'Joyner', 'Vet', '804 Woodside Circle, Grand Rapids, MI', '56000', '1982-04-25', 'M', 306369902, 'Africa');
insert into zooemployees values (241380147, 'Michael', 'Rodriguez', 'Vet', '737 Keyser Ridge Road, Grand Rapids, MI', '57000', '1975-11-13', 'M', 594494079, 'North America');
insert into zooemployees values (765189816, 'William', 'Richie', 'Vet', '3888 Crowfield Road, Grand Rapids, MI', '58000', '1974-10-05', 'M', 660054663, 'South America');
insert into zooemployees values (681108756, 'Jessica', 'Gonzalez', 'Vet', '988 Concord Street, Grand Rapids, MI', '59000', '1991-07-11', 'F', 170725571, 'Frogs');
insert into zooemployees values (126122218, 'Angela', 'Rice', 'Vet', '4760 Valley View Drive, Grand Rapids, MI', '60000', '1987-12-11', 'F', 114327791, 'Forest Realm');
insert into zooemployees values (168542187, 'Nathan', 'Jones', 'Vet', '2631 Browning Lane, Grand Rapids, MI', '61000', '1980-12-29', 'M', 216407536, 'Monkeys');
--
-- Shops
insert into shop values (10, 'Coffee Station', 'Pelican Pier');
insert into shop values (11, 'Info Kiosk ', 'Pelican Pier');
insert into shop values (12, 'Balloon Stall', 'Pelican Pier');
insert into shop values (13, 'Souvenir Shop', 'Tiger Realm');
insert into shop values (14, 'Lemonade Stand', 'Tiger Realm');
insert into shop values (15, 'Sunglasses Stall', 'Tropic Treasures');
insert into shop values (16, 'Neptunes Seafood', 'Tropic Treasures');
insert into shop values (17, 'Ice Cream', 'Wild Way Trail');
insert into shop values (18, 'Hat Shop', 'Wild Way Trail');
insert into shop values (19, 'Stuffed Animal Adoption', 'Africa');
insert into shop values (20, 'Popcorn Stand', 'North America');
insert into shop values (21, 'Grilled Delights', 'South America');
insert into shop values (22, 'T-Shirts and More', 'Forest Realm');
insert into shop values (23, 'Coffee Station', 'Forest Realm');
insert into shop values (24, 'Souvenir Shop', 'Monkeys');
--
-- Animals
insert into animal values (100, 'Tiger', 5, 'M', 622347022, '10:30', 'Tiger Realm');
insert into animal values (101, 'Tiger', 3, 'F', 622347022, '12:30', 'Tiger Realm');
insert into animal values (110, 'Penguin', 2, 'M', 392058668, '9:00', 'Shores Aquarium');
insert into animal values (111, 'Penguin', 1, 'M', 392058668, '9:30', 'Shores Aquarium');
insert into animal values (112, 'Penguin', 2, 'F', 392058668, '10:00', 'Shores Aquarium');
insert into animal values (113, 'Penguin', 3, 'F', 392058668, '10:30', 'Shores Aquarium');
insert into animal values (114, 'Penguin', 4, 'F', 392058668, '11:00', 'Shores Aquarium');
insert into animal values (120, 'Shark', 2, 'M', 392058668, '11:30', 'Shores Aquarium');
insert into animal values (121, 'Shark', 5, 'F', 392058668, '12:00', 'Shores Aquarium');
insert into animal values (130, 'Eel', 1, 'M', 392058668, '12:30', 'Shores Aquarium');
insert into animal values (140, 'Anemone', 1, 'M', 392058668, '13:00', 'Shores Aquarium');
insert into animal values (150, 'Exotic Fish', 1, 'M', 392058668, '13:30', 'Shores Aquarium');
insert into animal values (151, 'Exotic Fish', 4, 'F', 392058668, '14:00', 'Shores Aquarium');
insert into animal values (152, 'Exotic Fish', 2, 'M', 392058668, '14:30', 'Shores Aquarium');
insert into animal values (153, 'Exotic Fish', 3, 'M', 392058668, '15:00', 'Shores Aquarium');
insert into animal values (154, 'Exotic Fish', 1, 'F', 392058668, '15:30', 'Shores Aquarium');
insert into animal values (155, 'Exotic Fish', 3, 'F', 392058668, '16:00', 'Shores Aquarium');
insert into animal values (156, 'Exotic Fish', 2, 'M', 392058668, '16:30', 'Shores Aquarium');
insert into animal values (160, 'Bald Eagle', 5, 'M', 149039012, '9:00', 'Pelican Pier');
insert into animal values (161, 'Bald Eagle', 4, 'F', 149039012, '9:30', 'Pelican Pier');
insert into animal values (170, 'Pelican', 5, 'M', 149039012, '10:00', 'Pelican Pier');
insert into animal values (171, 'Pelican', 5, 'F', 149039012, '10:30', 'Pelican Pier');
insert into animal values (180, 'Flamingo', 2, 'F', 149039012, '11:00', 'Pelican Pier');
insert into animal values (181, 'Flamingo', 2, 'F', 149039012, '11:30', 'Pelican Pier');
insert into animal values (182, 'Flamingo', 4, 'F', 149039012, '12:00', 'Pelican Pier');
insert into animal values (183, 'Flamingo', 3, 'F', 149039012, '12:30', 'Pelican Pier');
insert into animal values (190, 'Black-footed Cat', 2, 'F', 595061909, '9:00', 'Tropic Treasures');
insert into animal values (200, 'Dart Frog', 1, 'M', 595061909, '9:30', 'Tropic Treasures');
insert into animal values (210, 'Caiman', 1, 'F', 595061909, '10:00', 'Tropic Treasures');
insert into animal values (220, 'Sloth', 4, 'M', 595061909, '10:30', 'Tropic Treasures');
insert into animal values (230, 'Tarantula', 2, 'M', 595061909, '11:00', 'Tropic Treasures');
insert into animal values (240, 'Wallaby', 1, 'M', 590600939, '9:00', 'Wild Way Trail');
insert into animal values (241, 'Wallaby', 1, 'F', 590600939, '9:30', 'Wild Way Trail');
insert into animal values (250, 'Howler Monkey', 8, 'M', 590600939, '10:00', 'Wild Way Trail');
insert into animal values (251, 'Howler Monkey', 6, 'F', 590600939, '10:30', 'Wild Way Trail');
insert into animal values (260, 'Parrot', 23, 'M', 590600939, '11:00', 'Wild Way Trail');
insert into animal values (270, 'Goat', 3, 'M', 135681064, '9:00', 'Petting Zoo');
insert into animal values (271, 'Goat', 2, 'F', 135681064, '9:30', 'Petting Zoo');
insert into animal values (280, 'Sheep', 1, 'F', 135681064, '10:00', 'Petting Zoo');
insert into animal values (281, 'Sheep', 2, 'F', 135681064, '10:30', 'Petting Zoo');
insert into animal values (290, 'Donkey', 4, 'M', 135681064, '11:00', 'Petting Zoo');
insert into animal values (300, 'Mini Horse', 5, 'F', 135681064, '11:30', 'Petting Zoo');
insert into animal values (310, 'Lion', 4, 'F', 511844657, '9:00', 'Africa');
insert into animal values (311, 'Lion', 2, 'F', 511844657, '9:30', 'Africa');
insert into animal values (312, 'Lion', 3, 'F', 511844657, '10:00', 'Africa');
insert into animal values (313, 'Lion', 4, 'M', 511844657, '10:30', 'Africa');
insert into animal values (320, 'Antelope', 3, 'F', 511844657, '11:00', 'Africa');
insert into animal values (321, 'Antelope', 2, 'M', 511844657, '11:30', 'Africa');
insert into animal values (330, 'Ground Hornbill', 2, 'M', 511844657, '12:00', 'Africa');
insert into animal values (340, 'Warthog', 4, 'M', 511844657, '12:30', 'Africa');
insert into animal values (341, 'Warthog', 4, 'F', 511844657, '13:00', 'Africa');
insert into animal values (350, 'Camel', 5, 'M', 511844657, '13:30', 'Africa');
insert into animal values (360, 'Grizzly Bear', 5, 'M', 445661181, '9:00', 'North America');
insert into animal values (361, 'Grizzly Bear', 3, 'F', 445661181, '9:30', 'North America');
insert into animal values (370, 'Mountain Lion', 3, 'M', 445661181, '10:00', 'North America');
insert into animal values (371, 'Mountain Lion', 4, 'F', 445661181, '10:30', 'North America');
insert into animal values (380, 'River Otter', 2, 'M', 445661181, '11:00', 'North America');
insert into animal values (381, 'Bobcat', 4, 'M', 445661181, '11:30', 'North America');
insert into animal values (382, 'Bobcat', 5, 'F', 445661181, '12:00', 'North America');
insert into animal values (390, 'Turtle', 6, 'M', 445661181, '12:30', 'North America');
insert into animal values (400, 'Capybara', 3, 'M', 644284210, '9:00', 'South America');
insert into animal values (401, 'Capybara', 3, 'F', 644284210, '9:30', 'South America');
insert into animal values (410, 'Tapir', 4, 'F', 644284210, '10:00', 'South America');
insert into animal values (411, 'Tapir', 2, 'M', 644284210, '10:30', 'South America');
insert into animal values (420, 'Saki Monkey', 5, 'F', 644284210, '11:00', 'South America');
insert into animal values (421, 'Saki Monkey', 6, 'M', 644284210, '11:30', 'South America');
insert into animal values (430, 'Maned Wolf', 3, 'F', 644284210, '12:00', 'South America');
insert into animal values (431, 'Maned Wolf', 3, 'M', 644284210, '12:30', 'South America');
insert into animal values (440, 'Tropical Frog', 1, 'M', 421562138, '9:00', 'Frogs');
insert into animal values (441, 'Tropical Frog', 1, 'M', 421562138, '9:30', 'Frogs');
insert into animal values (442, 'Tropical Frog', 3, 'M', 421562138, '10:00', 'Frogs');
insert into animal values (443, 'Tropical Frog', 1, 'M', 421562138, '10:30', 'Frogs');
insert into animal values (444, 'Tropical Frog', 2, 'M', 421562138, '11:00', 'Frogs');
insert into animal values (445, 'Tropical Frog', 1, 'M', 421562138, '11:30', 'Frogs');
insert into animal values (446, 'Tropical Frog', 1, 'M', 421562138, '12:00', 'Frogs');
insert into animal values (450, 'Red Panda', 4, 'M', 265036954, '9:00', 'Forest Realm');
insert into animal values (460, 'Chimpanzee', 4, 'M', 103010924, '9:00', 'Monkeys');
insert into animal values (461, 'Chimpanzee', 5, 'M', 103010924, '9:30', 'Monkeys');
insert into animal values (462, 'Chimpanzee', 4, 'F', 103010924, '10:00', 'Monkeys');
insert into animal values (463, 'Chimpanzee', 7, 'F', 103010924, '10:30', 'Monkeys');
insert into animal values (464, 'Chimpanzee', 6, 'F', 103010924, '11:00', 'Monkeys');
insert into animal values (465, 'Chimpanzee', 4, 'M', 103010924, '11:30', 'Monkeys');
insert into animal values (466, 'Chimpanzee', 10, 'F', 103010924, '12:00', 'Monkeys');
insert into animal values (467, 'Chimpanzee', 3, 'M', 103010924, '12:30', 'Monkeys');
insert into animal values (470, 'Gorilla', 3, 'F', 103010924, '13:00', 'Monkeys');
insert into animal values (471, 'Gorilla', 5, 'F', 103010924, '13:30', 'Monkeys');
insert into animal values (472, 'Gorilla', 10, 'M', 103010924, '14:00', 'Monkeys');
insert into animal values (473, 'Gorilla', 7, 'F', 103010924, '14:30', 'Monkeys');
insert into animal values (474, 'Gorilla', 5, 'F', 103010924, '15:00', 'Monkeys');
--
-- Events
insert into event values ('Petting Zoo', '2018-11-27', 'Birthday');
insert into event values ('Forest Realm', '2018-07-14', 'Wedding');
insert into event values ('Forest Realm', '2018-06-05', 'Bird Show');
insert into event values ('Forest Realm', '2018-06-06', 'Bird Show');
insert into event values ('Forest Realm', '2018-06-07', 'Bird Show');
--
-- Shop Products
insert into shopproducts values (10, 'Latte');
insert into shopproducts values (10, 'Small Coffee');
insert into shopproducts values (10, 'Large Coffee');
insert into shopproducts values (10, 'Tea');
insert into shopproducts values (10, 'Espresso');
insert into shopproducts values (10, 'Water');
insert into shopproducts values (11, 'Guide Book');
insert into shopproducts values (11, 'Day Pass');
insert into shopproducts values (11, 'Membership Pass');
insert into shopproducts values (12, 'Basic Balloon');
insert into shopproducts values (12, 'Animal Balloon');
insert into shopproducts values (13, 'Pin');
insert into shopproducts values (13, 'Tumbler');
insert into shopproducts values (13, 'Shot Glass');
insert into shopproducts values (13, 'Ornament');
insert into shopproducts values (13, 'Key Chain');
insert into shopproducts values (13, 'T-Shirt');
insert into shopproducts values (14, 'Small Lemonade');
insert into shopproducts values (14, 'Large Lemonade');
insert into shopproducts values (15, 'Kid Sunglasses');
insert into shopproducts values (15, 'Adult Sunglasses');
insert into shopproducts values (16, 'Sushi Roll');
insert into shopproducts values (16, 'Sushi Burrito');
insert into shopproducts values (16, 'Popcorn Shrimp');
insert into shopproducts values (16, 'Fish Sandwich');
insert into shopproducts values (16, 'Soda');
insert into shopproducts values (16, 'Water');
insert into shopproducts values (17, 'Vanilla Ice Cream');
insert into shopproducts values (17, 'Chocolate Ice Cream');
insert into shopproducts values (17, 'Superman Ice Cream');
insert into shopproducts values (17, 'Chocolate Chip Ice Cream');
insert into shopproducts values (17, 'Neopolitan Ice Cream');
insert into shopproducts values (18, 'Novelty Hat');
insert into shopproducts values (18, 'Baseball Hat');
insert into shopproducts values (18, 'Bucket Hat');
insert into shopproducts values (19, 'Stuffed Tiger');
insert into shopproducts values (19, 'Stuffed Penguin');
insert into shopproducts values (19, 'Stuffed Bear');
insert into shopproducts values (19, 'Stuffed Monkey');
insert into shopproducts values (20, 'Large Popcorn');
insert into shopproducts values (20, 'Small Popcorn');
insert into shopproducts values (21, 'Turkey Leg');
insert into shopproducts values (21, 'Kabbob');
insert into shopproducts values (21, 'Chicken Melt');
insert into shopproducts values (21, 'Soda');
insert into shopproducts values (21, 'Water');
insert into shopproducts values (22, 'T-Shirt');
insert into shopproducts values (22, 'Keychain');
insert into shopproducts values (22, 'Tumblr');
insert into shopproducts values (23, 'Latte');
insert into shopproducts values (23, 'Small Coffee');
insert into shopproducts values (23, 'Large Coffee');
insert into shopproducts values (23, 'Tea');
insert into shopproducts values (23, 'Espresso');
insert into shopproducts values (23, 'Water');
insert into shopproducts values (24, 'Pin');
insert into shopproducts values (24, 'Tumbler');
insert into shopproducts values (24, 'Shot Glass');
insert into shopproducts values (24, 'Ornament');
insert into shopproducts values (24, 'Key Chain');
insert into shopproducts values (24, 'T-Shirt');
--
-- Works At
insert into worksat values (681102346, 13);
insert into worksat values (167360529, 14);
insert into worksat values (531256644, 10);
insert into worksat values (370125667, 15);
insert into worksat values (192760485, 17);
insert into worksat values (464626469, 11);
insert into worksat values (321184990, 19);
insert into worksat values (811420103, 20);
insert into worksat values (278786624, 21);
insert into worksat values (260437927, 23);
insert into worksat values (564364430, 22);
insert into worksat values (763010925, 18);
insert into worksat values (313236075, 12);
insert into worksat values (251828867, 16);
insert into worksat values (178269601, 24);
insert into worksat values (574127433, 10);
insert into worksat values (255728306, 23);
insert into worksat values (427481397, 16);
insert into worksat values (416860165, 16);
insert into worksat values (378213720, 21);
insert into worksat values (256728014, 21);
--
COMMIT;
--
SET ECHO 
SPOOL OFF