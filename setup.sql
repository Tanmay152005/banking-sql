DROP TABLE IF EXISTS transactions;
DROP TABLE IF EXISTS emi_payments;
DROP TABLE IF EXISTS loans;
DROP TABLE IF EXISTS customers;

CREATE TABLE customers (
  customer_id INTEGER PRIMARY KEY,
  name        TEXT,
  city        TEXT,
  kyc_status  TEXT
);

CREATE TABLE loans (
  loan_id       INTEGER PRIMARY KEY,
  customer_id   INTEGER,
  loan_type     TEXT,
  amount        INTEGER,
  interest_rate REAL,
  tenure_months INTEGER,
  start_date    TEXT,
  FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

CREATE TABLE emi_payments (
  emi_id      INTEGER PRIMARY KEY,
  loan_id     INTEGER,
  due_date    TEXT,
  paid_date   TEXT,
  emi_amount  INTEGER,
  status      TEXT,
  FOREIGN KEY (loan_id) REFERENCES loans(loan_id)
);

CREATE TABLE transactions (
  txn_id         INTEGER PRIMARY KEY,
  customer_id    INTEGER,
  mode           TEXT,
  amount         INTEGER,
  status         TEXT,
  failure_reason TEXT,
  txn_time       TEXT,
  FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

INSERT INTO customers VALUES
(1,'Arun Kumar','Chennai','Verified'),
(2,'Priya Raj','Coimbatore','Verified'),
(3,'Karthik Nair','Madurai','Pending'),
(4,'Divya Iyer','Trichy','Verified'),
(5,'Suresh Reddy','Salem','Expired'),
(6,'Meena Das','Chennai','Verified'),
(7,'Rahul Pillai','Madurai','Pending'),
(8,'Lakshmi Kumar','Coimbatore','Verified'),
(9,'Vijay Raj','Trichy','Verified'),
(10,'Anitha Nair','Chennai','Verified'),
(11,'Mohan Iyer','Salem','Pending'),
(12,'Sneha Reddy','Tirunelveli','Verified');

INSERT INTO loans VALUES
(1,1,'Home Loan',1500000,8.5,180,'2025-12-01'),
(2,2,'Personal Loan',200000,12.0,36,'2026-01-01'),
(3,3,'Vehicle Loan',600000,9.5,60,'2026-01-01'),
(4,4,'Education Loan',400000,10.0,84,'2026-02-01'),
(5,5,'Personal Loan',150000,12.0,36,'2026-02-01'),
(6,6,'Home Loan',2000000,8.5,180,'2026-03-01'),
(7,7,'Vehicle Loan',500000,9.5,60,'2026-03-01'),
(8,8,'Education Loan',350000,10.0,84,'2026-04-01'),
(9,9,'Personal Loan',100000,12.0,36,'2026-04-01'),
(10,10,'Vehicle Loan',700000,9.5,60,'2026-05-01'),
(11,11,'Home Loan',1800000,8.5,180,'2026-05-01'),
(12,12,'Education Loan',300000,10.0,84,'2026-05-01');

INSERT INTO emi_payments VALUES
(1,1,'2026-08-05','2026-08-06',14771,'Paid'),
(2,1,'2026-09-05','2026-09-14',14771,'Paid Late'),
(3,1,'2026-10-05','2026-10-17',14771,'Paid Late'),
(4,1,'2026-11-05','2026-11-06',14771,'Paid'),
(5,2,'2026-08-05','2026-08-13',6643,'Paid Late'),
(6,2,'2026-09-05','2026-09-05',6643,'Paid'),
(7,2,'2026-10-05','2026-10-06',6643,'Paid'),
(8,2,'2026-11-05',NULL,6643,'Overdue'),
(9,3,'2026-08-05',NULL,12602,'Overdue'),
(10,3,'2026-09-05',NULL,12602,'Overdue'),
(11,3,'2026-10-05',NULL,12602,'Overdue'),
(12,3,'2026-11-05',NULL,12602,'Overdue'),
(13,4,'2026-08-05','2026-08-06',6640,'Paid'),
(14,4,'2026-09-05','2026-09-07',6640,'Paid'),
(15,4,'2026-10-05',NULL,6640,'Overdue'),
(16,4,'2026-11-05','2026-11-06',6640,'Paid'),
(17,5,'2026-08-05','2026-08-07',4982,'Paid'),
(18,5,'2026-09-05',NULL,4982,'Overdue'),
(19,5,'2026-10-05','2026-10-06',4982,'Paid'),
(20,5,'2026-11-05','2026-11-07',4982,'Paid'),
(21,6,'2026-08-05','2026-08-12',19695,'Paid Late'),
(22,6,'2026-09-05','2026-09-15',19695,'Paid Late'),
(23,6,'2026-10-05','2026-10-07',19695,'Paid'),
(24,6,'2026-11-05','2026-11-05',19695,'Paid'),
(25,7,'2026-08-05',NULL,10501,'Overdue'),
(26,7,'2026-09-05',NULL,10501,'Overdue'),
(27,7,'2026-10-05','2026-10-05',10501,'Paid'),
(28,7,'2026-11-05','2026-11-06',10501,'Paid'),
(29,8,'2026-08-05','2026-08-07',5810,'Paid'),
(30,8,'2026-09-05','2026-09-20',5810,'Paid Late'),
(31,8,'2026-10-05','2026-10-06',5810,'Paid'),
(32,8,'2026-11-05',NULL,5810,'Overdue'),
(33,9,'2026-08-05','2026-08-05',3321,'Paid'),
(34,9,'2026-09-05','2026-09-06',3321,'Paid'),
(35,9,'2026-10-05',NULL,3321,'Overdue'),
(36,9,'2026-11-05','2026-11-05',3321,'Paid'),
(37,10,'2026-08-05','2026-08-06',14702,'Paid'),
(38,10,'2026-09-05','2026-09-07',14702,'Paid'),
(39,10,'2026-10-05','2026-10-11',14702,'Paid Late'),
(40,10,'2026-11-05','2026-11-06',14702,'Paid'),
(41,11,'2026-08-05',NULL,17725,'Overdue'),
(42,11,'2026-09-05','2026-09-05',17725,'Paid'),
(43,11,'2026-10-05','2026-10-06',17725,'Paid'),
(44,11,'2026-11-05','2026-11-07',17725,'Paid'),
(45,12,'2026-08-05','2026-08-05',4980,'Paid'),
(46,12,'2026-09-05','2026-09-06',4980,'Paid'),
(47,12,'2026-10-05','2026-10-07',4980,'Paid'),
(48,12,'2026-11-05',NULL,4980,'Overdue');

INSERT INTO transactions VALUES
(1,1,'UPI',2500,'Success',NULL,'2026-10-02 09:15:00'),
(2,2,'UPI',1200,'Failed','Timeout','2026-10-02 11:40:00'),
(3,3,'NEFT',15000,'Success',NULL,'2026-10-03 10:05:00'),
(4,4,'IMPS',8000,'Success',NULL,'2026-10-03 14:22:00'),
(5,5,'UPI',3200,'Failed','Insufficient Balance','2026-10-04 09:50:00'),
(6,6,'UPI',4500,'Success',NULL,'2026-10-05 16:10:00'),
(7,7,'UPI',900,'Failed','Timeout','2026-10-06 12:30:00'),
(8,8,'NEFT',22000,'Success',NULL,'2026-10-07 10:45:00'),
(9,9,'UPI',1800,'Failed','Incorrect PIN','2026-10-08 18:05:00'),
(10,10,'IMPS',6000,'Success',NULL,'2026-10-09 11:20:00'),
(11,1,'UPI',700,'Failed','Timeout','2026-10-10 09:35:00'),
(12,2,'UPI',5400,'Success',NULL,'2026-10-11 13:15:00'),
(13,4,'UPI',2100,'Failed','Bank Server Down','2026-10-12 20:10:00'),
(14,6,'NEFT',31000,'Success',NULL,'2026-10-13 10:00:00'),
(15,8,'UPI',1500,'Success',NULL,'2026-10-14 15:45:00'),
(16,10,'UPI',2800,'Failed','Timeout','2026-10-15 08:55:00'),
(17,12,'IMPS',9500,'Success',NULL,'2026-10-16 12:12:00'),
(18,3,'UPI',1100,'Pending',NULL,'2026-10-17 19:30:00'),
(19,5,'NEFT',18000,'Success',NULL,'2026-10-18 10:25:00'),
(20,7,'UPI',600,'Failed','Insufficient Balance','2026-10-19 17:40:00'),
(21,9,'UPI',3900,'Success',NULL,'2026-10-20 09:05:00'),
(22,11,'IMPS',12000,'Failed','Bank Server Down','2026-10-21 13:50:00'),
(23,1,'UPI',4100,'Success',NULL,'2026-10-22 11:11:00'),
(24,2,'UPI',2300,'Failed','Timeout','2026-10-23 16:25:00'),
(25,12,'UPI',1700,'Pending',NULL,'2026-10-24 14:00:00'),
(26,6,'UPI',2600,'Success',NULL,'2026-10-25 10:30:00'),
(27,4,'NEFT',27000,'Success',NULL,'2026-10-26 12:45:00'),
(28,10,'UPI',800,'Failed','Incorrect PIN','2026-10-27 18:20:00'),
(29,1,'UPI',6500,'Success',NULL,'2026-11-02 10:00:00'),
(30,1,'UPI',6500,'Success',NULL,'2026-11-02 10:01:00'),
(31,6,'IMPS',14000,'Success',NULL,'2026-11-05 15:30:00'),
(32,6,'IMPS',14000,'Success',NULL,'2026-11-05 15:31:00'),
(33,10,'UPI',3300,'Success',NULL,'2026-11-09 09:40:00'),
(34,10,'UPI',3300,'Success',NULL,'2026-11-09 09:42:00'),
(35,3,'NEFT',85000,'Success',NULL,'2026-11-03 11:15:00'),
(36,7,'IMPS',92000,'Success',NULL,'2026-11-07 14:40:00'),
(37,11,'UPI',78000,'Success',NULL,'2026-11-10 10:05:00'),
(38,5,'NEFT',95000,'Success',NULL,'2026-11-15 16:20:00'),
(39,2,'UPI',1900,'Failed','Timeout','2026-11-16 12:10:00'),
(40,8,'UPI',2200,'Failed','Timeout','2026-11-18 19:05:00');