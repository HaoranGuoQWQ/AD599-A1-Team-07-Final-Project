-- 1. Design 1 analytical question along with the solution in SQL.
-- Which payment methods bring in the most collected revenue?
SELECT
    payment_method,
    ROUND(SUM(amount_paid), 2) AS total_collected
FROM invoices
GROUP BY payment_method
ORDER BY total_collected DESC;

-- We found that card payments generated the highest total revenue(≈ $7.43M), slightly above cash（≈ $7.40M) and insurance(≈ $7.39M). The differences are small，but card payments consistently bring in the most collected revenue across all invoices.
-- The query only uses the invoices table, so no joins or window functions were needed. We simply grouped invoices by payment_method and summed amount_paid for each group.
-- This insight helps the clinic understand which payment method brings in revenue most consistently, allowing them to focus on streamlining that method to support faster and more reliable cash flow.

-- ==========================================================
-- Analytical Question 1
-- Which doctors and time slots have the highest appointment no-show rates?
-- ==========================================================
-- ======================
-- 1) Doctors with highest no-show rates
--    We joined appointments with doctors on doctor_id, and calculated:
--       • total appointments per doctor
--       • number of no-show appointments
--       • no-show rate = no_show_count / total_appointments
--    Doctors were ranked by highest no-show rate.
-- ======================

SELECT 
    d.name AS doctor_name,
    COUNT(*) AS total_appointments,
    SUM(CASE WHEN a.status = 'no_show' THEN 1 ELSE 0 END) AS no_show_count,
    ROUND(
        SUM(CASE WHEN a.status = 'no_show' THEN 1 ELSE 0 END) * 1.0 
        / COUNT(*),
        3
    ) AS no_show_rate
FROM appointments a
JOIN doctors d 
    ON a.doctor_id = d.doctor_id
GROUP BY d.name
ORDER BY no_show_rate DESC, total_appointments DESC;

-- The results show that some doctors experience significantly higher patient no-show rates than others. The top doctors are:
--   • Claudia Holland (8.8%)
--   • Wayne Brown (7.6%)
--   • Nicholas Dixon (7.4%)
--
-- These doctors consistently have more missed appointments relative to their total volume, suggesting that the patient populations they serve or their scheduling patterns may be associated with higher no-show behavior.



-- ======================
-- 2) Time slots with highest no-show rates
--    We extracted the hour of each appointment using:
--       strftime('%H:00', appointment_datetime)
--    Then we computed:
--       • total appointments in each time slot
--       • number of no-shows
--       • no-show rate for each time slot
--    Time slots were ranked by highest no-show rate.
-- ======================

SELECT 
    strftime('%H:00', a.appointment_datetime) AS time_slot,
    COUNT(*) AS total_appointments,
    SUM(CASE WHEN a.status = 'no_show' THEN 1 ELSE 0 END) AS no_show_count,
    ROUND(
        SUM(CASE WHEN a.status = 'no_show' THEN 1 ELSE 0 END) * 1.0 
        / COUNT(*),
        3
    ) AS no_show_rate
FROM appointments a
GROUP BY time_slot
ORDER BY no_show_rate DESC, total_appointments DESC;

-- No-show rates also vary by appointment hour. The highest no-show time periods include:
--   • 08:00 (5.6%)
--   • 17:00 (5.5%)
--   • 16:00 (5.2%)
-- Early morning and late-afternoon sessions exhibit the greatest no-show likelihood. These times may be more prone to conflicts with work, transportation, or personal routines.


-- ==========================================================
-- Analytical Question 2
-- Which medical specialties generate the most revenue?
-- To determine which medical specialties generate the most revenue,we joined the invoices table with appointments and then joined appointments with doctors.
-- Revenue was measured using amount_billed from the invoices table.
-- We grouped the results by each doctor's specialty and summed all billed amounts to obtain total revenue per specialty.
-- ==========================================================

SELECT 
    d.specialty,
    SUM(i.amount_billed) AS total_revenue,
    COUNT(i.invoice_id) AS total_invoices
FROM invoices i
JOIN appointments a 
    ON i.appointment_id = a.appointment_id
JOIN doctors d
    ON a.doctor_id = d.doctor_id
GROUP BY d.specialty
ORDER BY total_revenue DESC;

-- Cardiology generates the highest revenue (~$9.4M).

-- ======================
--  Analytical Question 3 
--Which patients visit the clinic most frequently?

-- We grouped all appointment records by patient_id to calculate the total number of visits for each patient:COUNT(*) AS total_visits
-- We then joined the patients table to retrieve the patient names,enabling us to report results in a meaningful and readable format.
-- Finally, we sorted the results in descending order of visit count to identify the clinic’s most frequent visitors.
-- ======================
SELECT 
    p.name AS patient_name,
    COUNT(a.appointment_id) AS total_visits
FROM appointments a
JOIN patients p
    ON a.patient_id = p.patient_id
GROUP BY p.name
ORDER BY total_visits DESC;

-- Thomas Byrd is the most frequent visitor with 76 total appointments

-- ======================
--  Analytical Question 4  
--What are the most common procedures performed across specialties?
-- Here we use the procedures table as the source of procedure information and derive the specialty from the procedure name.
-- Then, group by specialty and procedure_type and count how many procedures each specialty offers in each category.
-- Finally, we sort by specialty and num_procedures in descending order to seewhich procedure types are most common within each specialty.
-- ======================

SELECT
    substr(p.name, 1, instr(p.name, ' procedure') - 1) AS specialty,
    p.procedure_type,
    COUNT(*) AS num_procedures
FROM procedures p
GROUP BY specialty, p.procedure_type
ORDER BY specialty, num_procedures DESC;

-- The output shows patterns in the types of procedures each specialty most commonly performs:
--   • Cardiology most frequently performs surgery.
--   • Dermatology primarily performs lab tests and consultations.
--   • General Practice shows a balanced mix of lab tests, surgery, and consultations, with lab tests being the most common.
--   • Orthopedics mainly conducts consultations and surgeries.
--   • Pediatrics frequently performs surgeries, followed by lab tests.
--   • Psychiatry primarily conducts consultations, with occasional lab tests and surgeries.

-- ==========================================================
-- Analytical Question 5
-- Which patients have outstanding balances and how large are they?
-- To identify patients with outstanding balances, we joined the invoices table with appointments to obtain patient_id, and then joined patients to retrieve patient names. 
-- The outstanding balance for each invoice was calculated as:  amount_billed - amount_paid
-- We aggregated these balances at the patient level and filtered for patients whose total outstanding amount is greater than zero.
-- ==========================================================

SELECT
    p.name AS patient_name,
    SUM(i.amount_billed - i.amount_paid) AS outstanding_balance,
    COUNT(i.invoice_id) AS total_invoices
FROM invoices i
JOIN appointments a
    ON i.appointment_id = a.appointment_id
JOIN patients p
    ON a.patient_id = p.patient_id
GROUP BY p.name
HAVING outstanding_balance > 0
ORDER BY outstanding_balance DESC;


-- The results show that patient Jeffrey Rogers (~19,904.65) has the largest unpaid balances.

-- ===============================
-- Window Function Questions 6
-- What is the number of days between each patient’s consecutive visits?
SELECT
    a.patient_id,
    p.name AS patient_name,
    a.appointment_datetime,
    LAG(a.appointment_datetime) OVER (
        PARTITION BY a.patient_id
        ORDER BY a.appointment_datetime
    ) AS previous_visit,
    ROUND(
        julianday(a.appointment_datetime) -
        julianday(
            LAG(a.appointment_datetime) OVER (
                PARTITION BY a.patient_id
                ORDER BY a.appointment_datetime
            )
        ),
        1
    ) AS days_since_last_visit
FROM appointments a
JOIN patients p
    ON a.patient_id = p.patient_id
ORDER BY a.patient_id, a.appointment_datetime;

-- We found most patients return within 1–40 days between visits, with occasional long gaps over 50+ days, showing mixed follow-up consistency.
-- We joined appointments with patients to add patient names, and used LAG() OVER (PARTITION BY patient_id ORDER BY appointment_datetime) to capture each patient’s previous visit and calculate the day gap.
-- This insight helps us knowing visit gaps helps the clinic identify patients who delay follow-ups so staff can improve scheduling and follow-up reminders.

-- =========================================
-- Window Function Questions 7
-- What is the revenue rank of each doctor?

WITH doctor_revenue AS (
    SELECT
        d.doctor_id,
        d.name AS doctor_name,
        ROUND(SUM(i.amount_billed), 2) AS total_revenue
    FROM invoices i
    JOIN appointments a
        ON i.appointment_id = a.appointment_id
    JOIN doctors d
        ON a.doctor_id = d.doctor_id
    GROUP BY d.doctor_id, doctor_name
)
SELECT
    doctor_id,
    doctor_name,
    total_revenue,
    RANK() OVER (ORDER BY total_revenue DESC) AS revenue_rank
FROM doctor_revenue
ORDER BY revenue_rank;

-- The results show each doctor’s total revenue and rank, with the top earners (e.g., Sarah Cobb ≈ $766K, Megan Smith ≈ $747K) significantly ahead of others.
-- We joined invoices → appointments → doctors to link billed amounts to the correct doctor, then grouped totals per doctor. Finally, we applied RANK() to order doctors by total revenue.
-- This ranking helps the clinic identify high-impact doctors and allocate resources or support where it drives the most financial value.













