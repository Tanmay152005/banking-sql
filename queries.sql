-- Q1: How many transactions succeed, fail or stay pending ?
SELECT status, COUNT(*) AS total 
FROM transactions
GROUP BY status;
-- Finding: 13 of 40 transactions failed (32.5%).

-- Q2: Failed transactions and total failed amount per mode
SELECT mode, 
		COUNT(*) AS failed_count,
		SUM(AMOUNT) AS total_failed_amt
FROM transactions
WHERE status = 'Failed'
GROUP BY mode;
-- Finding: UPI has 12 of the 13 failed transactions (Rs 20,500); the one IMPS failure is Rs. 12,000.

-- Q3: What are the most common reasons for failed transactions ? 
SELECT failure_reason, COUNT(*) AS total
FROM transactions
WHERE status = 'Failed'
GROUP BY failure_reason
ORDER BY total DESC;
-- Finding: Timeout is the top failure reason(7 out of 13); the other three reasons have 2 each.

-- Q4: Which customers have KYC that is not verified, and which cities they are in? 
SELECT name, city, kyc_status
FROM customers
WHERE kyc_status != 'Verified' 
ORDER BY city;
-- Finding: 4 customers have non-verified KYC (3 Pending, 1 Expired), all in Madurai and Salem

-- Q5: Which 5 customers have the most failed transactions ? 
 SELECT c.name, c.city, COUNT(*) AS failed_count
 FROM transactions t
 JOIN customers c ON t.customer_id = c.customer_id
 WHERE t.status = 'Failed' 
 GROUP BY c.customer_id,c.name,c.city
 ORDER BY failed_count DESC, c.name
 LIMIT 5;
-- Finding: Priya Raj (Coimbatore) has the most failed transactions(3).  

-- Q6: How many EMIs are overdue for each loan type, and what is the total overdue amount ?  
SELECT l.loan_type, COUNT(*) AS overdue_emis, SUM(e.emi_amount) AS total_overdue
FROM emi_payments e
JOIN loans l ON e.loan_id = l.loan_id
WHERE e.status = 'Overdue'
GROUP BY l.loan_type
ORDER BY total_overdue DESC;
-- Finding: Vehicle Loans have the highest overdue amount (6 EMIs, Rs. 71,410). 

-- Q7: What is the Failure percentage for each payment mode
SELECT mode,
       COUNT(*) AS total_txns,
       SUM(CASE WHEN status = 'Failed' THEN 1 ELSE 0 END) AS failed_txns,
       ROUND(SUM(CASE WHEN status = 'Failed' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 1) AS failure_pct
FROM transactions
GROUP BY mode;
-- Finding: UPI fails 46.2% of the time, IMPS 14.3%, NEFT 0%.  

-- Q8: Which customers have paid their EMI late 2 or more times ?
SELECT c.name, COUNT(*) AS late_count
FROM emi_payments e
JOIN loans l ON e.loan_id = l.loan_id
JOIN customers c ON l.customer_id = c.customer_id
WHERE e.status = 'Paid Late'
GROUP BY c.customer_id, c.name
HAVING COUNT(*) >= 2;
-- Finding: Arun Kumar and Meena Das each paid late twice

-- Q9: How many EMIs and how much amount fall into each overdue age bucket 
-- (1-30, 31-60, 61-90, 90+ days) as of 2026-11-30?
SELECT CASE
         WHEN days_overdue <= 30 THEN '1-30 days'
         WHEN days_overdue <= 60 THEN '31-60 days'
         WHEN days_overdue <= 90 THEN '61-90 days'
         ELSE '90+ days'
       END AS age_bucket,
       COUNT(*) AS overdue_emis,
       SUM(emi_amount) AS total_amount
FROM (
  SELECT emi_amount,
         CAST(julianday('2026-11-30') - julianday(due_date) AS INTEGER) AS days_overdue
  FROM emi_payments
  WHERE status = 'Overdue'
)
GROUP BY age_bucket
ORDER BY MIN(days_overdue);
-- Finding:  13 overdue EMIs; 3 are 90+ days old (Rs 40,828), which is the NPA risk group.

-- Q10: Which successful transactions look like duplicate debits 
-- (same customer, mode and amount, close in time)?
SELECT customer_id, mode, amount,
       COUNT(*) AS times_charged,
       MIN(txn_time) AS first_time,
       MAX(txn_time) AS last_time
FROM transactions
WHERE status = 'Success'
GROUP BY customer_id, mode, amount
HAVING COUNT(*) > 1;
-- Finding: 3 customers (IDs 1, 6, 10) were charged the same amount twice within 1-2 minutes.

-- Q11: Which customers with Pending or Expired KYC made a successful transaction above Rs 50,000?
SELECT c.name, c.kyc_status, t.amount, t.mode, t.txn_time
FROM transactions t
JOIN customers c ON t.customer_id = c.customer_id
WHERE c.kyc_status IN ('Pending', 'Expired')
  AND t.status = 'Success'
  AND t.amount > 50000
ORDER BY t.amount DESC;
-- Finding: 4 high-value transactions (Rs 78,000 to Rs 95,000) came from customers without verified KYC.

-- Q12: Which loans are at NPA risk (any EMI overdue more than 90 days as of 2026-11-30), 
-- and what is the total overdue amount for each?
SELECT c.name, l.loan_type,
       COUNT(*) AS overdue_emis,
       SUM(e.emi_amount) AS total_overdue,
       MAX(CAST(julianday('2026-11-30') - julianday(e.due_date) AS INTEGER)) AS max_days_overdue
FROM emi_payments e
JOIN loans l ON e.loan_id = l.loan_id
JOIN customers c ON l.customer_id = c.customer_id
WHERE e.status = 'Overdue'
  AND l.loan_id IN (
        SELECT loan_id FROM emi_payments
        WHERE status = 'Overdue'
          AND julianday('2026-11-30') - julianday(due_date) > 90)
GROUP BY l.loan_id, c.name, l.loan_type
ORDER BY total_overdue DESC;
-- Finding: 3 loans are at NPA risk (117 days overdue); 
-- Karthik Nair's Vehicle Loan is highest at Rs 50,408 overdue.
