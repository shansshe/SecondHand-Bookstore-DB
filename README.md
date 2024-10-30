# Second-hand Bookstore DB
This project designs a MySQL database for a second-hand bookstore, featuring an ER model that visualizes the relationships between customers, staff, and publications. The database consists of nine tables that include information about customers, publications, staff, and providers, allowing for efficient data management and comprehensive analysis of bookstore operations.

## ER model
![shbookshop](https://github.com/shansshe/SecondHand-Bookstore-DB/blob/main/SHbookstore.jpg)

- Description
    1.	All customers in the database must buy at least one publication, each customer buys some publications, and each publication can only be bought by one customer.
    2.	Providers can provide zero or some publications, valuers evaluate the value and the status of publications at the same time, and there may be some valuers evaluate some publications. 
    3.	Clerks can be supervisors or supervisees. Each supervisor leads some supervisees, each supervisee is led by one supervisor.
    4.	One customer leaves some book reviews, one book is mentioned in some book reviews, and each book review is left by one customer with one book.
    5.	One clerk bargains with some providers, and each provider negotiates with one clerk.


## Tables
1. publication

| barcode | ptype | status | buyinPrice | sellPrice |
|---------|-------|--------|------------|-----------|
| B0123   | book  | nice   |        300 |       560 |
| B2456   | book  | fair   |        150 |       330 |
| B7836   | book  | poor   |        130 |       200 |
| CD2549  | CD    | fair   |        180 |       300 |
| CD5592  | CD    | nice   |        200 |       500 |
| CD5734  | CD    | nice   |        100 |       150 |

2. book

| barcode | btitle       | author           | publisher     | pages |
|---------|--------------|------------------|---------------|-------|
| B0123   | Harry Potter | J. K. Rowling    | Bloomsbury    |   223 |
| B2456   | DaVinci Code | Dan Brown        | Doubleday     |   454 |
| B7836   | The Hobbit   | J. R. R. Tolkien | HarperCollins |   310 |

3. CD

| barcode | ctitle        | artists          | genre   |
|---------|---------------|------------------|---------|
| CD2549  | Chopin CE     | Maria Joao Pires | classic |
| CD2549  | Chopin CE     | Rafal Blechacz   | classic |
| CD2549  | Chopin CE     | Yundi            | classic |
| CD5592  | AD MARE       | NMIXX            | kpop    |
| CD5734  | Morning Glory | Oasis            | rock    |

4. customer

| CUID | cname | gender | phone     | totalComsumption |
|------|-------|--------|-----------|------------------|
| C121 | Nancy | F      | 886563985679 |            15000 |
| C233 | John  | M      | 886957836789 |              500 |
| C466 | Roy   | M      | 886946737899 |             7000 |

5. clerk

| CLID  | clname | age  | gender | owner | valuer | supervisor |
|-------|--------|------|--------|-------|--------|------------|
| CL110 | Jack   |   40 | M      |     1 |      1 | NULL       |
| CL422 | Mike   |   35 | M      |     0 |      1 | CL110      |
| CL670 | May    |   26 | F      |     0 |      1 | CL110      |
| CL778 | Amy    |   24 | F      |     0 |      1 | CL670      |

6. provider

| PID  | type    | phone     | tel      | clerk | pname  | ctitle      | caddress                               |
|------|---------|-----------|----------|-------|--------|-------------|----------------------------------------|
| 2122 | person  | 886977986543 |     NULL | CL110 | August | NULL        | NULL                                   |
| 7668 | person  | 886924578397 | 27846708 | CL422 | Olivia | NULL        | NULL                                   |
| 9723 | company | NULL      | 27560478 | NULL  | CL670  | BookWarm    | No.10 Siwei Rd. Daan Dist. Taipei City |
| 9728 | company | NULL      | 27333908 | NULL  | CL110  | ReadBenefit | No.39 Shida Rd. Daan Dist. Taipei City |

7. book review

| customer | book  | ranking | comment               |
|----------|-------|---------|-----------------------|
| C121     | B0123 |       4 | awesome               |
| C121     | B2456 |       4 | worth reading         |
| C233     | B0123 |       1 | not my type           |
| C233     | B2456 |       5 | big fan of Dan Brown! |

8. purchase record

| PNo   | prdate     | publication | provider | valuer |
|-------|------------|-------------|----------|--------|
| P2749 | 2021-03-09 | B0123       | 9723     | CL110  |
| P2749 | 2021-03-09 | CD2549      | 9723     | CL422  |
| P3593 | 2021-11-27 | CD5592      | 9728     | CL422  |
| P4639 | 2020-12-29 | B7836       | 7668     | CL422  |
| P5630 | 2021-11-27 | B2456       | 2122     | CL670  |

9. sell record

| SNo   | srdate     | publication | customer |
|-------|------------|-------------|----------|
| S4638 | 2022-02-01 | B0123       | C121     |
| S4638 | 2022-02-01 | B2456       | C121     |
| S4846 | 2022-03-04 | B7836       | C233     |
| S6593 | 2022-03-08 | CD5592      | C466     |

## Views
1. review summary

| btitle       | author        | ranking | comment               |
|--------------|---------------|---------|-----------------------|
| Harry Potter | J. K. Rowling |       4 | awesome               |
| Harry Potter | J. K. Rowling |       1 | not my type           |
| DaVinci Code | Dan Brown     |       4 | worth reading         |
| DaVinci Code | Dan Brown     |       5 | big fan of Dan Brown! |

2. book sales summary

| srdate     | cname | btitle       |
|------------|-------|--------------|
| 2022-02-01 | Nancy | Harry Potter |
| 2022-02-01 | Nancy | DaVinci Code |
| 2022-03-04 | John  | The Hobbit   |

## MySQL script
[SHbookstore.sql](https://github.com/shansshe/SecondHand-Bookstore-DB/blob/main/SHbookstore.sql)
