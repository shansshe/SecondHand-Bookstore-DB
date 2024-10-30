/* create and use database */
CREATE DATABASE SHbookstore;
USE SHbookstore;

/* create table */
CREATE TABLE publication (
  barcode varchar(10) NOT NULL,
  ptype ENUM('book','CD') DEFAULT 'book',
  status ENUM('nice','fair','poor') DEFAULT 'fair',
  buyinPrice int CHECK (buyinPrice > 0),
  sellPrice int CHECK (sellPrice > 0),
  PRIMARY KEY (barcode),
  CHECK (buyinPrice < sellPrice)
);

CREATE TABLE book (
  barcode varchar(10) NOT NULL,
  btitle varchar(20) NOT NULL,
  author varchar(20),
  publisher varchar(20) DEFAULT 'Bloomsbury',
  pages int CHECK (pages > 0),
  PRIMARY KEY (barcode)
);

CREATE TABLE CD (
  barcode varchar(10) NOT NULL,
  ctitle varchar(20) NOT NULL,
  artists varchar(20),
  genre varchar(10) DEFAULT 'rock',
  PRIMARY KEY (barcode, artists)
);

CREATE TABLE customer (
  CUID varchar(10) NOT NULL,
  cname varchar(20) NOT NULL,
  gender ENUM('M', 'F') DEFAULT 'M',
  phone varchar(15),
  totalComsumption int CHECK (totalComsumption > 0),
  PRIMARY KEY (CUID)
);

CREATE TABLE clerk (
    CLID varchar(10) NOT NULL,
    clname varchar(20) NOT NULL,
    age int CHECK (age > 0 AND age < 100),
    gender ENUM('M', 'F') DEFAULT 'M',
    owner int CHECK (owner = 0 OR owner = 1) DEFAULT 0,
    valuer int CHECK (valuer = 0 OR valuer = 1) DEFAULT 1,
    supervisor varchar(10),
    PRIMARY KEY (CLID),
    FOREIGN KEY (supervisor) REFERENCES clerk(CLID)
);

CREATE TABLE provider (
    PID varchar(10) NOT NULL,
    type ENUM('person','company') DEFAULT 'person',
    phone varchar(15),
    tel int,
    clerk varchar(10) DEFAULT 'CL110',
    pname varchar(10),
    ctitle varchar(20),
    caddress varchar(40),
    PRIMARY KEY (PID),
    FOREIGN KEY (clerk) REFERENCES clerk(CLID)
);

CREATE TABLE sellRecord (
  SNo varchar(10) NOT NULL,
  srdate date,
  publication varchar(20) NOT NULL,
  customer varchar(20) NOT NULL,
  PRIMARY KEY (SNo, publication),
  FOREIGN KEY (publication) REFERENCES publication(barcode),
  FOREIGN KEY (customer) REFERENCES customer(CUID)
);

CREATE TABLE purchaseRecord (
  PNo varchar(10) NOT NULL,
  prdate date,
  publication varchar(20) NOT NULL,
  provider varchar(20) NOT NULL,
  valuer varchar(10) DEFAULT 'CL110',
  PRIMARY KEY (PNo, publication),
  FOREIGN KEY (publication) REFERENCES publication(barcode),
  FOREIGN KEY (provider) REFERENCES provider(PID),
  FOREIGN KEY (valuer) REFERENCES clerk(CLID)
);

CREATE TABLE bookReview (
  customer varchar(10) NOT NULL,
  book varchar(20) NOT NULL,
  ranking int CHECK(ranking > 0 AND ranking < 6) DEFAULT 3,
  comment varchar(40),
  PRIMARY KEY (customer, book),
  FOREIGN KEY (customer) REFERENCES customer(CUID),
  FOREIGN KEY (book) REFERENCES publication(barcode),
  FOREIGN KEY (book) REFERENCES book(barcode)
);

/* insert */
INSERT INTO publication
VALUES
('B0123', 'book', 'nice', 300, 560),
('B2456', 'book', 'fair', 150, 330),
('B7836', 'book', 'poor', 130, 200),
('CD5734', 'CD', 'nice', 100, 150),
('CD2549','CD', 'fair', 180, 300),
('CD5592','CD', 'nice', 200, 500);

INSERT INTO book
VALUES
('B0123', 'Harry Potter', 'J. K. Rowling', 'Bloomsbury', 223),
('B2456', 'DaVinci Code', 'Dan Brown', 'Doubleday', 454),
('B7836', 'The Hobbit', 'J. R. R. Tolkien', 'HarperCollins', 310);

INSERT INTO CD
VALUES
('CD5734','Morning Glory', 'Oasis', 'rock'),
('CD2549','Chopin CE', 'Yundi', 'classic'),
('CD2549','Chopin CE', 'Maria Joao Pires', 'classic'),
('CD2549','Chopin CE', 'Rafal Blechacz', 'classic'),
('CD5592', 'AD MARE', 'NMIXX', 'kpop');

INSERT INTO customer
VALUES
('C121', 'Nancy', 'F', 886563985679, 15000),
('C233', 'John', 'M', 886957836789, 500),
('C466', 'Roy', 'M', 886946737899, 7000);

INSERT INTO clerk
VALUES
('CL110', 'Jack', 40, 'M', 1,1, NULL),
('CL422', 'Mike', 35, 'M',0,1, 'CL110'),
('CL670', 'May', 26, 'F', 0,1, 'CL110'),
('CL778', 'Amy', 24, 'F', 0,1, 'CL670');

INSERT INTO provider
VALUES
('2122', 'person', 886977986543, NULL, 'CL110','August', NULL, NULL),
('7668', 'person', 886924578397, 27846708, 'CL422', 'Olivia', NULL, NULL),
('9723', 'company', NULL, 27560478, NULL, 'CL670', 'BookWarm', 'No.10 Siwei Rd. Daan Dist. Taipei City'),
('9728', 'company', NULL, 27333908, NULL, 'CL110', 'ReadBenefit', 'No.39 Shida Rd. Daan Dist. Taipei City');

INSERT INTO sellRecord
VALUES
('S4638', '2022-02-01', 'B0123','C121'),
('S4638', '2022-02-01', 'B2456','C121'),
('S4846', '2022-03-04', 'B7836','C233'),
('S6593', '2022-03-08', 'CD5592','C466');

INSERT INTO purchaseRecord
VALUES
('P2749', '2021-03-09', 'B0123', '9723', 'CL110'),
('P2749', '2021-03-09', 'CD2549', '9723', 'CL422'),
('P4639', '2020-12-29', 'B7836', '7668', 'CL422'),
('P5630', '2021-11-27', 'B2456', '2122', 'CL670'),
('P3593', '2021-11-27', 'CD5592', '9728', 'CL422');

INSERT INTO bookReview
VALUES
('C121','B0123', 4, 'awesome'),
('C121','B2456', 4, 'worth reading'),
('C233','B0123', 1, 'not my type'),
('C233','B2456', 5, 'big fan of Dan Brown!');

/* create two views */
CREATE VIEW reviewSummary AS
SELECT book.btitle, book.author, bookReview.ranking, bookReview.comment
FROM bookReview, book
WHERE bookReview.book= book.barcode;

CREATE VIEW BooksellSummary AS
SELECT sellRecord.srdate, customer.cname, book.btitle
FROM sellRecord, customer, book
WHERE sellRecord.customer = customer.CUID AND
sellRecord.publication = book.barcode;

/* select from all tables and views */
SELECT * FROM publication;
SELECT * FROM book;
SELECT * FROM CD;
SELECT * FROM customer;
SELECT * FROM clerk;
SELECT * FROM provider;
SELECT * FROM bookReview;
SELECT * FROM purchaseRecord;
SELECT * FROM sellRecord;
SELECT * FROM reviewSummary;
SELECT * FROM BooksellSummary;

/* drop database */
/* DROP DATABASE SHbookstore; */
