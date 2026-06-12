-- ==============================================================================
-- Project:Bank Customer Churn Analysis - SQL Queries
-- Author: Mahmoud Nasr Hassan Altras
-- ==============================================================================

-- 1. Phase 1: Baseline Metrics & Overall Churn Rate
-- Identifying the total percentage of attrited vs. existing customers.
SELECT
  Attrition_Flag,
  COUNT(*) AS total_customers,
  ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM `turing-seeker-498011-n9.bank_churn_project.churn_data`), 2) AS percentage
FROM `turing-seeker-498011-n9.bank_churn_project.churn_data`
GROUP BY Attrition_Flag;

-- ==============================================================================

-- 2. Phase 2: Demographic Risk Profiling (Gender Variance)
-- Calculating churn rate partitioned by Gender to avoid absolute number bias.
SELECT 
  Attrition_Flag,
  Gender,
  COUNT(*) AS Total_customers,
  ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER(PARTITION BY Gender), 2) AS percentage
FROM `turing-seeker-498011-n9.bank_churn_project.churn_data`
GROUP BY 
  Attrition_Flag, 
  Gender;

-- ==============================================================================

-- 3. Phase 2: Demographic Risk Profiling (Income Correlation)
-- Using CASE WHEN to calculate churn percentage per Income Category.
-- Finding: The highest-income tier (+$120K) exhibits the highest attrition rate.
SELECT 
  Income_Category,
  COUNT(*) AS total_customers,
  SUM(CASE WHEN Attrition_Flag = 'Attrited Customer' THEN 1 ELSE 0 END) AS churned_customers,
  ROUND(SUM(CASE WHEN Attrition_Flag = 'Attrited Customer' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS churn_rate_percentage
FROM `turing-seeker-498011-n9.bank_churn_project.churn_data`
GROUP BY Income_Category
ORDER BY churn_rate_percentage DESC;

-- ==============================================================================

-- 4. Phase 3: Behavioral Indicators (Usage Velocity & Transaction Drop)
-- Comparing the average annual transactions and amounts between attrited and existing customers.
SELECT
  Attrition_Flag,
  ROUND(AVG(Total_Trans_Ct), 0) AS avg_transactions_count,
  ROUND(AVG(Total_Trans_Amt), 2) AS avg_transaction_amount
FROM `turing-seeker-498011-n9.bank_churn_project.churn_data`
GROUP BY Attrition_Flag;

-- ==============================================================================

-- 5. Phase 3: Behavioral Indicators (Quarterly Collapse)
-- Measuring the drop in transaction volume between Q1 and Q4.
SELECT
  Attrition_Flag,
  ROUND(AVG(Total_Ct_Chng_Q4_Q1), 3) AS avg_count_change_ratio,
  ROUND(AVG(Total_Amt_Chng_Q4_Q1), 3) AS avg_amount_change_ratio
FROM `turing-seeker-498011-n9.bank_churn_project.churn_data`
GROUP BY Attrition_Flag;

-- ==============================================================================

-- 6. Phase 4: Product Repositioning & Up-selling Failure
-- Highlighting the percentage of female customers stuck on the basic 'Blue' card tier.
SELECT 
  Gender,
  Card_Category,
  COUNT(*) AS Total_customers,
  ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER(PARTITION BY Gender), 2) AS percentage
FROM `turing-seeker-498011-n9.bank_churn_project.churn_data`
GROUP BY 
  Gender,
  Card_Category;
