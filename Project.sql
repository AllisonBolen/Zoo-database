SPOOL ZooDB.out
SET ECHO ON
SET WRAP OFF
SET LINESIZE 30000
SET TRIMSPOOL ON
--
-- CIS 353 - Database Project: Zoo Database
--
-- Authors:
--
-- Allison Bolen
-- Andrew Olesak
-- Jake Walton
-- Kasey Stowell
--
-- -----------------------------------------------------------
-- The DROP commands below are placed here for convenience in
-- order to drop the tables if they exist. If the tables don't
-- exist, you'll get an error - just ignore the error.
-- -----------------------------------------------------------
--
DROP TABLE zooemployees CASCADE CONSTRAINTS;
DROP TABLE exhibit CASCADE CONSTRAINTS;
DROP TABLE shop CASCADE CONSTRAINTS;
DROP TABLE animal CASCADE CONSTRAINTS;
DROP TABLE event CASCADE CONSTRAINTS;
DROP TABLE shopproducts CASCADE CONSTRAINTS;
DROP TABLE worksat CASCADE CONSTRAINTS;
--
-- -----------------------------------------------------------
-- CREATE TABLES
-- -----------------------------------------------------------
--
CREATE TABLE zooemployees
(
empssn        INTEGER,
firstname    VARCHAR2(10)    NOT NULL,
lastname    VARCHAR2(10)    NOT NULL,
position    VARCHAR2(10)    NOT NULL,
eaddress    VARCHAR2(15)    NOT NULL,
esalary        INTEGER            NOT NULL,
ebdate        DATE            NOT NULL,
egender        CHAR            NOT NULL,
superssn    INTEGER,
exhibitname    VARCHAR2(16)    NOT NULL,
/*
PK1: The primary key of zoo employee is empssn.
*/
CONSTRAINT PK1 PRIMARY KEY (empssn),
/*
ZC1: The position is one of: Supervisor, Cashier, Barista, Cook, 
Janitor, Caretaker, or Vet.
*/
CONSTRAINT ZC1 CHECK (position IN ('Supervisor', 'Cashier', 'Barista', 
                    'Cook', 'Janitor', 'Caretaker', 'Vet')),
/*
ZC2: The employee gender is one of: M or F.
*/
CONSTRAINT ZC2 CHECK (egender IN ('M', 'F')),
/*
ZC3: A supervisor must have a salary greater than $40,000.
*/
CONSTRAINT ZC3 CHECK (NOT (position = 'Supervisor' AND esalary < 40000))
--
);
--
CREATE TABLE exhibit
(
exhibitname    VARCHAR2(16)    PRIMARY KEY,    
climate        VARCHAR2(9)    NOT NULL,
managerssn    INTEGER,
/*
ZC4: The climate is one of: Temperate, Polar, Tropical, Arid, 
or Coastal.
*/
CONSTRAINT ZC4 CHECK (climate IN ('Temperate', 'Polar', 'Tropical', 
                    'Arid', 'Coastal'))
);
--
--
CREATE TABLE shop
(
shopid        INTEGER            PRIMARY KEY,
sname        VARCHAR2(30)    NOT NULL,
exhibitname    VARCHAR2(16)    NOT NULL
);
--
--
CREATE TABLE animal
(
aid            INTEGER            PRIMARY KEY,
species        VARCHAR2(16)    NOT NULL,
age            INTEGER            NOT NULL,
agender        CHAR            NOT NULL,
empssn        INTEGER            NOT    NULL,
tendtime    INTEGER            NOT NULL,
exhibitname    VARCHAR2(16)    NOT NULL,
/*
ZC5: The animal gender is one of: M or F.
*/
CONSTRAINT ZC5 CHECK (agender IN ('M', 'F')),
/*
ZC6: The animal tend time must be between 6:00 thru 19:00.
*/
CONSTRAINT ZC6 CHECK (tendtime > 559 AND tendtime < 1900)
);
--
CREATE TABLE event
(
exhibitname    VARCHAR2(16),
evdate        DATE,
type        VARCHAR2(20)    NOT NULL,
PRIMARY KEY(exhibitname, evdate)    
);
--
CREATE TABLE shopproducts
(
shopid        INTEGER,
productname    VARCHAR2(35),
PRIMARY KEY(shopid, productname)        
);
--
CREATE TABLE worksat
(
empssn        INTEGER,
shopid        INTEGER,
PRIMARY KEY(empssn, shopid)
);
--
-- -----------------------------------------------------------
-- FOREIGN KEY CONSTRAINTS
-- -----------------------------------------------------------
--
-- Zoo Employees
/*
FK1: Every supervisor must also be a zoo employee. Also: If an employee 
is deleted, all the employees supervisees will have their superssn set 
to NULL.
*/
ALTER TABLE zooemployees
	ADD CONSTRAINT FK1 
	FOREIGN KEY (superssn) 
	REFERENCES zooemployees(empssn)
	ON DELETE SET NULL
	DEFERRABLE INITIALLY DEFERRED;
/*
FK2: Every zoo employees assigned exhibit must exist. Also: If an exhibit 
is deleted, all employees working in the exhibit is also deleted.
*/
ALTER TABLE zooemployees
	ADD CONSTRAINT FK2 
	FOREIGN KEY (exhibitname) 
	REFERENCES exhibit(exhibitname)
	ON DELETE CASCADE
	DEFERRABLE INITIALLY DEFERRED;
--
-- Exhibits
/*
FK3: Every exhibit manager must be an existing zoo employee. Also: if a
manager is deleted, set the exhibits managerssn to NULL.
*/
ALTER TABLE exhibit
	ADD CONSTRAINT FK3 
	FOREIGN KEY (managerssn) 
	REFERENCES zooemployees(empssn)
	ON DELETE SET NULL
	DEFERRABLE INITIALLY DEFERRED;
--
-- Shops
/*
FK4: All shops are located in an existing exhibit. Also: if an exhibit is
deleted, all shops in the exhibit are also deleted.
*/
ALTER TABLE shop
	ADD CONSTRAINT FK4 
	FOREIGN KEY (exhibitname) 
	REFERENCES exhibit(exhibitname)
	ON DELETE CASCADE
	DEFERRABLE INITIALLY DEFERRED;
--
-- Animals
/*
FK5: All animals are taken care of by an existing zoo employee. Also: if
an employee is deleted, all animals they take care of are also deleted.
*/
ALTER TABLE animal
	ADD CONSTRAINT FK5 
	FOREIGN KEY (empssn) 
	REFERENCES zooemployees(empssn)
	ON DELETE CASCADE
	DEFERRABLE INITIALLY DEFERRED;
/*
FK6: All animals must live in an exhisting exhibit. Also: if an exhibit is
deleted, then all animals living in the exhibit are also deleted.
*/
ALTER TABLE animal
	ADD CONSTRAINT FK6 
	FOREIGN KEY (exhibitname) 
	REFERENCES exhibit(exhibitname)
	ON DELETE CASCADE
	DEFERRABLE INITIALLY DEFERRED;
--
-- Events
/*
FK7: All events are held in an exhisting exhibit. Also: if an exhibit is
deleted, then also delete the event.
*/
ALTER TABLE event
	ADD CONSTRAINT FK7 
	FOREIGN KEY (exhibitname) 
	REFERENCES exhibit(exhibitname)
	ON DELETE CASCADE
	DEFERRABLE INITIALLY DEFERRED;
--
-- Shop Products
/*
FK8: All shop products are sold in an existing shop. Also: if a shop is
deleted, then also delete the products sold in that shop.
*/
ALTER TABLE shopproducts
	ADD CONSTRAINT FK8 
	FOREIGN KEY (shopid) 
	REFERENCES shop(shopid)
	ON DELETE CASCADE
	DEFERRABLE INITIALLY DEFERRED;
--
-- Works At
/*
FK9: The employee that works at a shop is an existing zoo employee. Also:
if the zoo employee is deleted, delete their works at relationship.
*/
ALTER TABLE worksat
	ADD CONSTRAINT FK9 
	FOREIGN KEY (empssn) 
	REFERENCES zooemployees(empssn) 
	ON DELETE CASCADE
	DEFERRABLE INITIALLY DEFERRED;
/*
FK10: The shop that an employee works at must be an already existing shop.
Also: if a shop is deleted, then delete the works at relationship with
the zoo employees.
*/
ALTER TABLE worksat
	ADD CONSTRAINT FK10 
	FOREIGN KEY (shopid) 
	REFERENCES shop(shopid)
	ON DELETE CASCADE
	DEFERRABLE INITIALLY DEFERRED;
--
-- -----------------------------------------------------
-- Populate the database
-- -----------------------------------------------------
--
SET FEEDBACK OFF
--
alter session set NLS_DATE_FORMAT = 'YYYY-MM-DD';
--
-- Supervisors
insert into zooemployees values (130423454, 'Ronnie', 'Alvarado', 'Supervisor', '496 Farland St', 72000, '1970-04-15', 'M', NULL, 'Bugs');
insert into zooemployees values (635052791, 'Patricia', 'Scott', 'Supervisor', '174 Cinn Ln', 60000, '1971-09-27', 'F', 130423454, 'Tiger Realm');
insert into zooemployees values (543145276, 'Brenda', 'Myers', 'Supervisor', '233 Hollow Rd', 61000, '1962-05-31', 'F', 130423454, 'Shores Aquarium');
insert into zooemployees values (187225055, 'Michael', 'Tejada', 'Supervisor', '531 Lone Rd', 62000, '1975-09-01', 'M', 130423454, 'Pelican Pier');
insert into zooemployees values (397981967, 'David', 'Gullett', 'Supervisor', '479 Leg Road', 63000, '1979-01-29', 'M', 130423454, 'Tropic Treasures');
insert into zooemployees values (405249752, 'Reginald', 'Phillips', 'Supervisor', '194 Park Ln', 64000, '1985-08-22', 'M', 130423454, 'Wild Way Trail');
insert into zooemployees values (198204924, 'Jack', 'Arnold', 'Supervisor', '238 Pride Ave', 65000, '1983-05-10', 'M', 130423454, 'Petting Zoo');
insert into zooemployees values (306369902, 'Robert', 'Bradley', 'Supervisor', '154 Neville St', 66000, '1974-01-24', 'M', 130423454, 'Africa');
insert into zooemployees values (594494079, 'Sheila', 'Lane', 'Supervisor', '438 Badger Ln', 67000, '1975-11-13', 'F', 130423454, 'North America');
insert into zooemployees values (660054663, 'Jennifer', 'Atencio', 'Supervisor', '403 Wood St', 68000, '1989-12-05', 'F', 130423454, 'South America');
insert into zooemployees values (170725571, 'Allie', 'Owens', 'Supervisor', '347 Creek Rd', 69000, '1985-12-14', 'F', 130423454, 'Frogs');
insert into zooemployees values (114327791, 'Jennifer', 'Doe', 'Supervisor', '710 Huntz Lane', 70000, '1970-12-22', 'F', 130423454, 'Forest Realm');
insert into zooemployees values (216407536, 'Georgia', 'Murray', 'Supervisor', '223 Blue Ln', 71000, '1976-05-19', 'F', 130423454, 'Monkeys');
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
insert into exhibit values ('South America', 'Coastal', 660054663);
insert into exhibit values ('Frogs', 'Tropical', 170725571);
insert into exhibit values ('Forest Realm', 'Temperate', 114327791);
insert into exhibit values ('Monkeys', 'Tropical', 216407536);
insert into exhibit values ('Bugs', 'Tropical', 130423454);
--
-- Zoo Cashiers
insert into zooemployees values (681102346, 'Karl', 'Callahan', 'Cashier', '131 Fire Rd', 16000, '1958-12-09', 'M', 635052791, 'Tiger Realm');
insert into zooemployees values (167360529, 'Richard', 'Smith', 'Cashier', '277 Center Way', 16100, '1979-04-30', 'M', 635052791, 'Tiger Realm');
insert into zooemployees values (531256644, 'Greg', 'Diaz', 'Cashier', '360 Mud Rd', 16200, '1992-06-22', 'M', 187225055, 'Pelican Pier');
insert into zooemployees values (370125667, 'Gertrude', 'English', 'Cashier', '169 Howard Rd', 16300, '1992-10-08', 'F', 397981967, 'Tropic Treasures');
insert into zooemployees values (192760485, 'Geraldine', 'Guest', 'Cashier', '377 Turkey Rd', 16400, '1988-02-11', 'F', 405249752, 'Wild Way Trail');
insert into zooemployees values (464626469, 'Mary', 'Brown', 'Cashier', '4685 Hill Dr', 16500, '1989-06-28', 'F', 187225055, 'Pelican Pier');
insert into zooemployees values (321184990, 'Holly', 'Hess', 'Cashier', '33 Butter Ln', 16600, '1953-02-03', 'F', 306369902, 'Africa');
insert into zooemployees values (811420103, 'Ronnie', 'Gaillard', 'Cashier', '353 Fresh Dr', 16700, '1990-10-28', 'M', 594494079, 'North America');
insert into zooemployees values (278786624, 'Adam', 'Spencer', 'Cashier', '354 Upland Ave', 16800, '1983-05-05', 'M', 660054663, 'South America');
insert into zooemployees values (260437927, 'Cassie', 'Schmitt', 'Cashier', '270 Kidd Ave', 16900, '1994-04-07', 'F', 114327791, 'Forest Realm');
insert into zooemployees values (564364430, 'Wally', 'Perkinson', 'Cashier', '264 Austin Ave', 17000, '1992-03-21', 'M', 114327791, 'Forest Realm');
insert into zooemployees values (763010925, 'Joanna', 'Sterling', 'Cashier', '513 Cheno Dr', 17100, '1992-09-29', 'F', 405249752, 'Wild Way Trail');
insert into zooemployees values (313236075, 'Richard', 'Paul', 'Cashier', '495 Rain Bvd', 17200, '1992-10-06', 'M', 187225055, 'Pelican Pier');
insert into zooemployees values (251828867, 'Benjamin', 'Luong', 'Cashier', '231 Marion St', 17300, '1993-02-27', 'M', 397981967, 'Tropic Treasures');
insert into zooemployees values (178269601, 'Gina', 'Clear', 'Cashier', '301 Coal St', 17400, '1990-08-27', 'F', 216407536, 'Monkeys');
--
--Zoo Baristas
insert into zooemployees values (574127433, 'Monica', 'Kamp', 'Barista', '170 Mine Rd', 20800, '1993-07-07', 'F', 187225055, 'Pelican Pier');
insert into zooemployees values (255728306, 'Carl', 'Guerra', 'Barista', '433 Hart Ln', 20900, '1988-10-16', 'M', 114327791, 'Forest Realm');
--
-- Zoo Cooks
insert into zooemployees values (427481397, 'Tania', 'Ramirez', 'Cook', '204 Kelley Rd', 22800, '1993-07-07', 'F', 397981967, 'Tropic Treasures');
insert into zooemployees values (416860165, 'Terrence', 'Harrison', 'Cook', '35 Pen Ln', 22900, '1981-12-14', 'M', 397981967, 'Tropic Treasures');
insert into zooemployees values (378213720, 'Avery', 'Foster', 'Cook', '691 Ten Ave', 23000, '1994-10-18', 'M', 660054663, 'South America');
insert into zooemployees values (256728014, 'Stephanie', 'Grant', 'Cook', '151 Junior Ave', 23100, '1991-10-21', 'F', 660054663, 'South America');
--
-- Caretakers
insert into zooemployees values (622347022, 'Annie', 'Allen', 'Caretaker', '797 Heritage Rd', 35000, '1986-11-05', 'F', 635052791, 'Tiger Realm');
insert into zooemployees values (392058668, 'Kelly', 'Vanwagenen', 'Caretaker', '442 Comfort Crt', 35100, '1976-09-05', 'F', 543145276, 'Shores Aquarium');
insert into zooemployees values (149039012, 'Jessica', 'Coburn', 'Caretaker', '481 Webster St', 35200, '1983-12-23', 'F', 187225055, 'Pelican Pier');
insert into zooemployees values (595061909, 'Patrick', 'Shreve', 'Caretaker', '483 Tyler Ave', 35300, '1994-11-13', 'M', 397981967, 'Tropic Treasures');
insert into zooemployees values (590600939, 'Teri', 'McClary', 'Caretaker', '326 Steve Rd', 35400, '1967-05-01', 'F', 405249752, 'Wild Way Trail');
insert into zooemployees values (135681064, 'Bernard', 'Johnston', 'Caretaker', '663 Melm St', 35500, '1971-06-04', 'M', 198204924, 'Petting Zoo');
insert into zooemployees values (511844657, 'John', 'Mathews', 'Caretaker', '398 Sigley Rd', 35600, '1983-06-18', 'M', 306369902, 'Africa');
insert into zooemployees values (445661181, 'Samantha', 'Garcia', 'Caretaker', '90 Late Ave', 35700, '1982-01-05', 'F', 594494079, 'North America');
insert into zooemployees values (644284210, 'Catherine', 'Farrington', 'Caretaker', '480 Book St', 35800, '1988-09-24', 'F', 660054663, 'South America');
insert into zooemployees values (421562138, 'Willie', 'Nixon', 'Caretaker', '340 Wright Crt', 35900, '1952-03-11', 'M', 170725571, 'Frogs');
insert into zooemployees values (265036954, 'Kathy', 'Stewart', 'Caretaker', '489 George St', 36000, '1984-02-22', 'F', 114327791, 'Forest Realm');
insert into zooemployees values (103010924, 'Marjorie', 'Castaneda', 'Caretaker', '182 Anmoore Rd', 36100, '1985-07-22', 'F', 216407536, 'Monkeys');
--
-- Vets
insert into zooemployees values (571707179, 'Peggy', 'Baker', 'Vet', '169 Oak Rd', 50000, '1973-10-28', 'F', 635052791, 'Tiger Realm');
insert into zooemployees values (166701386, 'Silas', 'Foulk', 'Vet', '437 James Dr', 51000, '1976-04-22', 'M', 543145276, 'Shores Aquarium');
insert into zooemployees values (460085712, 'Doris', 'Patterson', 'Vet', '697 South St', 52000, '1979-07-13', 'F', 187225055, 'Pelican Pier');
insert into zooemployees values (479360155, 'Steven', 'Davis', 'Vet', '435 Woodland Dr', 53000, '1983-03-06', 'M', 397981967, 'Tropic Treasures');
insert into zooemployees values (542100923, 'Veronica', 'Morales', 'Vet', '165 Heron Way', 54000, '1984-08-17', 'F', 405249752, 'Wild Way Trail');
insert into zooemployees values (457903419, 'Connie', 'Landis', 'Vet', '363 Course Dr', 55000, '1971-05-29', 'F', 198204924, 'Petting Zoo');
insert into zooemployees values (265755073, 'John', 'Joyner', 'Vet', '804 Wood St', 56000, '1982-04-25', 'M', 306369902, 'Africa');
insert into zooemployees values (241380147, 'Michael', 'Rodriguez', 'Vet', '737 Ridge Rd', 57000, '1975-11-13', 'M', 594494079, 'North America');
insert into zooemployees values (765189816, 'William', 'Richie', 'Vet', '388 Crow Rd', 58000, '1974-10-05', 'M', 660054663, 'South America');
insert into zooemployees values (681108756, 'Jessica', 'Gonzalez', 'Vet', '988 Concord St', 59000, '1991-07-11', 'F', 170725571, 'Frogs');
insert into zooemployees values (126122218, 'Angela', 'Rice', 'Vet', '476 Valley Dr', 60000, '1987-12-11', 'F', 114327791, 'Forest Realm');
insert into zooemployees values (168542187, 'Nathan', 'Jones', 'Vet', '263 Brown Ln', 61000, '1980-12-29', 'M', 216407536, 'Monkeys');
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
insert into animal values (100, 'Tiger', 5, 'M', 622347022, 1030, 'Tiger Realm');
insert into animal values (101, 'Tiger', 3, 'F', 622347022, 1230, 'Tiger Realm');
insert into animal values (110, 'Penguin', 2, 'M', 392058668, 900, 'Shores Aquarium');
insert into animal values (112, 'Penguin', 2, 'F', 392058668, 1000, 'Shores Aquarium');
insert into animal values (120, 'Shark', 2, 'M', 392058668, 1130, 'Shores Aquarium');
insert into animal values (121, 'Shark', 5, 'F', 392058668, 1200, 'Shores Aquarium');
insert into animal values (130, 'Eel', 1, 'M', 392058668, 1230, 'Shores Aquarium');
insert into animal values (140, 'Anemone', 1, 'M', 392058668, 1300, 'Shores Aquarium');
insert into animal values (150, 'Exotic Fish', 1, 'M', 392058668, 1330, 'Shores Aquarium');
insert into animal values (151, 'Exotic Fish', 4, 'F', 392058668, 1400, 'Shores Aquarium');
insert into animal values (160, 'Bald Eagle', 5, 'M', 149039012, 900, 'Pelican Pier');
insert into animal values (161, 'Bald Eagle', 4, 'F', 149039012, 930, 'Pelican Pier');
insert into animal values (170, 'Pelican', 5, 'M', 149039012, 1000, 'Pelican Pier');
insert into animal values (171, 'Pelican', 5, 'F', 149039012, 1030, 'Pelican Pier');
insert into animal values (180, 'Flamingo', 2, 'F', 149039012, 1100, 'Pelican Pier');
insert into animal values (181, 'Flamingo', 2, 'F', 149039012, 1130, 'Pelican Pier');
insert into animal values (190, 'Black-footed Cat', 2, 'F', 595061909, 900, 'Tropic Treasures');
insert into animal values (200, 'Dart Frog', 1, 'M', 595061909, 930, 'Tropic Treasures');
insert into animal values (210, 'Caiman', 1, 'F', 595061909, 1000, 'Tropic Treasures');
insert into animal values (220, 'Sloth', 4, 'M', 595061909, 1030, 'Tropic Treasures');
insert into animal values (230, 'Tarantula', 2, 'M', 595061909, 1100, 'Tropic Treasures');
insert into animal values (240, 'Wallaby', 1, 'M', 590600939, 900, 'Wild Way Trail');
insert into animal values (241, 'Wallaby', 1, 'F', 590600939, 930, 'Wild Way Trail');
insert into animal values (250, 'Howler Monkey', 8, 'M', 590600939, 1000, 'Wild Way Trail');
insert into animal values (251, 'Howler Monkey', 6, 'F', 590600939, 1030, 'Wild Way Trail');
insert into animal values (260, 'Parrot', 23, 'M', 590600939, 1100, 'Wild Way Trail');
insert into animal values (270, 'Goat', 3, 'M', 135681064, 900, 'Petting Zoo');
insert into animal values (271, 'Goat', 2, 'F', 135681064, 930, 'Petting Zoo');
insert into animal values (280, 'Sheep', 1, 'F', 135681064, 1000, 'Petting Zoo');
insert into animal values (281, 'Sheep', 2, 'F', 135681064, 1030, 'Petting Zoo');
insert into animal values (290, 'Donkey', 4, 'M', 135681064, 1100, 'Petting Zoo');
insert into animal values (300, 'Mini Horse', 5, 'F', 135681064, 1130, 'Petting Zoo');
insert into animal values (310, 'Lion', 4, 'F', 511844657, 900, 'Africa');
insert into animal values (313, 'Lion', 4, 'M', 511844657, 1030, 'Africa');
insert into animal values (320, 'Antelope', 3, 'F', 511844657, 1100, 'Africa');
insert into animal values (321, 'Antelope', 2, 'M', 511844657, 1130, 'Africa');
insert into animal values (330, 'Ground Hornbill', 2, 'M', 511844657, 1200, 'Africa');
insert into animal values (340, 'Warthog', 4, 'M', 511844657, 1230, 'Africa');
insert into animal values (341, 'Warthog', 4, 'F', 511844657, 1300, 'Africa');
insert into animal values (350, 'Camel', 5, 'M', 511844657, 1330, 'Africa');
insert into animal values (360, 'Grizzly Bear', 5, 'M', 445661181, 900, 'North America');
insert into animal values (361, 'Grizzly Bear', 3, 'F', 445661181, 930, 'North America');
insert into animal values (370, 'Mountain Lion', 3, 'M', 445661181, 1000, 'North America');
insert into animal values (371, 'Mountain Lion', 4, 'F', 445661181, 1030, 'North America');
insert into animal values (380, 'River Otter', 2, 'M', 445661181, 1100, 'North America');
insert into animal values (381, 'Bobcat', 4, 'M', 445661181, 1130, 'North America');
insert into animal values (382, 'Bobcat', 5, 'F', 445661181, 1200, 'North America');
insert into animal values (390, 'Turtle', 6, 'M', 445661181, 1230, 'North America');
insert into animal values (400, 'Capybara', 3, 'M', 644284210, 900, 'South America');
insert into animal values (401, 'Capybara', 3, 'F', 644284210, 930, 'South America');
insert into animal values (410, 'Tapir', 4, 'F', 644284210, 1000, 'South America');
insert into animal values (411, 'Tapir', 2, 'M', 644284210, 1030, 'South America');
insert into animal values (420, 'Saki Monkey', 5, 'F', 644284210, 1100, 'South America');
insert into animal values (421, 'Saki Monkey', 6, 'M', 644284210, 1130, 'South America');
insert into animal values (430, 'Maned Wolf', 3, 'F', 644284210, 1200, 'South America');
insert into animal values (431, 'Maned Wolf', 3, 'M', 644284210, 1230, 'South America');
insert into animal values (440, 'Tropical Frog', 1, 'M', 421562138, 900, 'Frogs');
insert into animal values (441, 'Tropical Frog', 1, 'M', 421562138, 930, 'Frogs');

insert into animal values (450, 'Red Panda', 4, 'M', 265036954, 900, 'Forest Realm');
insert into animal values (461, 'Chimpanzee', 5, 'M', 103010924, 930, 'Monkeys');
insert into animal values (462, 'Chimpanzee', 4, 'F', 103010924, 1000, 'Monkeys');
insert into animal values (471, 'Gorilla', 5, 'F', 103010924, 1330, 'Monkeys');
insert into animal values (472, 'Gorilla', 10, 'M', 103010924, 1400, 'Monkeys');
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
--
SET FEEDBACK ON
COMMIT;
--
-- -----------------------------------------------------
-- QUERIES THAT PRINT DATABASE
-- -----------------------------------------------------
--
SELECT * FROM zooemployees;
SELECT * FROM exhibit;
SELECT * FROM shop;
SELECT * FROM animal;
SELECT * FROM event;
SELECT * FROM shopproducts;
SELECT * FROM worksat;
--
-- -----------------------------------------------------
-- SQL QUERIES
-- -----------------------------------------------------
--
-- Q1 - Relational Division Query
-- Find the SSN, first name, last name, and gender of every employee who tends to every animal whose species is penguins.
select e.empssn, e.firstname, e.lastname, e.egender
from zooemployees e
where NOT EXISTS ((select a.aid
					from animal a
					where a.species = 'Penguin')
					MINUS
				 	(select a.aid
						from animal a
						where a.species = 'Penguin'
						and a.empssn = e.empssn));
--
--
-- Q2 - A non-correlated subquery, and a self-join
-- Find the SSN, first name, and position of every employee who is not a supervisor
select e.empssn, e.firstName, e.position
from zooemployees e
where e.empssn not in (select k.empssn 
					from zooemployees n, zooemployees k
					where n.superssn = k.empssn);
--
--
-- Q3 - MINUS query 
-- Find the essn, first name, salary, and position of employees whose salary is greater than 30,000 and are caretakers
select e.empssn, e.firstname, e.esalary, e.position
from zooemployees e
where e.esalary > 30000
MINUS
select e.empssn, e.firstname, e.esalary, e.position
from zooemployees e
where e.position != 'Caretaker';
--
--
-- Q4 - A join involving at least four relations
-- For every employee who works at a shop located in the pelican pier exhibit select their ssn, first name, and salary
select E.empssn, E.firstname, E.esalary
from zooemployees E, shop S, exhibit X, worksat W
where E.empssn = W.empssn and
    W.shopid = S.shopid and
    S.exhibitname = X.exhibitname and
    X.exhibitname = 'Pelican Pier';
--
--
-- Q5 - SUM, AVERAGE, GROUP BY, HAVING, and ORDER BY
-- For every exhibit whose average salary is greater than 43,000, select the exhibit name and the sum of the salaries along with the average. Order by the sum
select E.exhibitname, sum(E.esalary) as TotalSalarySum, avg(E.esalary) as AverageSalary
from zooemployees E
group by E.exhibitname
having avg(E.esalary) > 43000
order by sum(E.esalary);
--
--
-- Q6 - A rank query
-- Find the rank of the salary 23000 among all the salaries
select rank(23000) within group (order by esalary)
from zooemployees;
--
--
-- Q7 - A top-N query
-- Find the ssn, last name and salary of the 5 highest paid employees
select empssn, lastname, esalary
from (select *
        from zooemployees
        order by esalary desc)
where rownum <6;
--
--
-- Q8 - An outer join query
-- For every employee select the ssn, first name, and salary.  Also show the animal ID and species if an employee tends animals
select E.empssn, E.firstname, E.esalary, A.aid, A.species
from zooemployees E left outer join animal A on A.empssn = E.empssn;
--
--
-- Q9 - A correlated subquery
-- For every employee who tends to animals and is male, select their ssn, last name, gender, and supervisor's ssn
select E.empssn, E.lastname, E.egender, E.superssn
from zooemployees E
where E.egender = 'M' and
        exists (select *
                from animal A
                where A.empssn = E.empssn);
--
-- -----------------------------------------------------
-- INSERT/DELETE/UPDATE STATEMENTS
-- -----------------------------------------------------
--
-- Testing K1
insert into exhibit values ('Petting Zoo','Temperate', 114327791);
-- Testing ZC1 violate
insert into zooemployees values (144423650, 'Andy', 'Carl', 'Person', '496 Land St', 8000, '1970-04-15', 'M', NULL, 'Bugs');
-- Testing ZC2 violate
insert into zooemployees values (133333651, 'Ju-lee', 'Carl', 'Supervisor', '460 Land St', 80000, '1970-04-15', 'R', NULL, 'Bugs');
-- Testing ZC3 violate
insert into zooemployees values (130423650, 'Beth', 'Carl', 'Supervisor', '960 Land St', 80000, '1970-04-15', 'M', NULL, 'Bugs');
-- Testing ZC4 violate
insert into exhibit values ('Petting Zoo', 'Cold', 198204924);
-- Testing ZC5 violate
insert into animal values (100, 'Tiger', 5, 'R', 622347022, 1030, 'Tiger Realm');
-- Testing ZC6 violate
insert into animal values (479, 'Gorilla', 2, 'F', 103010924, 100, 'Monkeys');
-- Testing FK1 
delete from zooemployees WHERE empssn = 405249752;
-- Testing FK1.1 should violate the parent key constraint
insert into zooemployees values (144423650, 'Andy', 'Carl', 'Barista', '496 Land St', 8000, '1970-04-15', 'M', 000000000, 'Bugs');
-- Testing FK2 
delete from zooemployees WHERE exhibitname = 'Shores Aquarium';
-- Testing FK3 
delete from exhibit where managerssn = 198204924;
-- Testing FK4 
delete from shop where exhibitname = 'Monkeys';
-- Testing FK5 
delete from animal where empssn = 595061909;
-- testing FK6 
delete from animal where exhibitname = 'Pelican Pier';
-- Testing FK7 
delete from event where exhibitname = 'Forest Real';
-- Testing FK8 
delete from shopproducts where shopid = 12;
-- Testing FK9 
delete from worksat where empssn = 681102346;
-- Testing FK10
delete from worksat where shopid = 10;
--
COMMIT;
-- 
SPOOL OFF