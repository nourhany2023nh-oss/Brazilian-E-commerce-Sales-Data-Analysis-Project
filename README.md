# Brazilian-E-commerce-Sales-Data-Analysis-Project
(A project aimed at showcasing data  analysis using SQL and Python)

An end-to-end data analysis project on the Brazilian Olist e-commerce dataset, covering SQL data quality checks, advanced business analytics, Python RFM customer segmentation, and cohort retention analysis

## 🛠️ Tech Stack & Tools
* **Database & Querying:** Microsoft SQL Server (T-SQL, CTEs, Window Functions, Joins, Data Validation)
* **Data Processing & Analysis:** Python, Pandas, NumPy
* **Data Visualization:** Matplotlib, Seaborn (Custom Dark Theme)
* **Version Control:** Git, GitHub
---

## 🗄️ Dataset & Database Setup

This project includes both the raw CSV files and a ready-to-use SQL Server database backup so you can easily explore or run the code locally.

### 1. Raw Dataset (`data/` folder)
* The original CSV files containing over 100,000 orders (orders, items, payments, customers, products, sellers, and reviews) are located in the `data/` directory.

## 2. Ready-to-Use Database Backup

For SQL Server users, you can restore the fully structured `OlistDB` (with all schemas: `sales` and `production`) using the provided backup file.

* **Download Database Backup:** You can download the `OlistDB_backup.bak` file (144 MB) from this direct link: 
  👉 **[Download OlistDB_backup.bak from Google Drive[OlismDB](https://drive.google.com/file/d/112-kGEgty9cer37X5VPy_6M7DHYISucJ/view?usp=sharing)**

* **How to restore:**
  1. Open SQL Server Management Studio (SSMS).
  2. Right-click on **Databases** -> **Restore Database...**
  3. Select the downloaded `.bak` file, and click **OK** to restore `OlistDB` instantly with all schemas and data fully structured.

---
## 📂 Project Structure
```text
📦 Olist-E-Commerce-Data-Analysis
 ┣ 📂 data                     # Original raw CSV files
 ┣ 📂 SQL                      # SQL scripts (Data quality, core metrics & advanced analytics)
 ┃ ┣ 📜 data_quality.sql       # Validating data integrity, missing values & sequence rules
 ┃ ┣ 📜 TT1.sql                # Core business metrics (sales, AOV, top products/categories)
 ┃ ┗ 📜 TT2.sql                # Advanced analytics (Monthly growth, Cohorts, Delivery performance)
 ┣ 📂 Python                   # Python analysis script (RFM & Cohort)
 ┃ ┗ 📜 TT3.py                 # RFM scoring, Customer segmentation, and correlation heatmaps
 ┗ 📂 Visualizations           # Exported charts and heatmaps
```
---
## 🔍 Key Project Phases
### 1. Data Quality & Validation (SQL/data_quality.sql)
Checked for missing keys and referential integrity using Left Joins and Unions across orders, items, and customers.

Validated timestamp logical sequences and verified pricing/freight rules to ensure clean analysis data.

### 2. Advanced SQL Analysis (SQL/TT1.sql & SQL/TT2.sql)
Calculated monthly revenue growth using LAG() and state rankings using DENSE_RANK().

Analyzed delivery performance, freight-to-price ratios, and late delivery impacts on customer reviews.

### 3. Python Analytics & Segmentation (Python/TT3.py)
Applied RFM Segmentation using qcut quantiles to categorize customers into actionable groups (Champions, Loyal, At Risk, Lost).

Generated Cohort Retention Analysis matrices and correlation heatmaps to visualize user retention and service metrics.

## 💡 Business Recommendations & Strategic Insights

Based on the deep analysis of SQL metrics, Python RFM segmentation, and delivery performance, here are actionable recommendations for Olist management to optimize operations and boost revenue:

### 1. Delivery Performance & Customer Satisfaction
* **Mitigate Shipping Delays:** Our correlation analysis showed a strong negative impact of delivery delays on customer review scores (`review_score`). Management should penalize chronically underperforming logistics partners and prioritize fast-shipping carriers.
* **Proactive Customer Communication:** For orders identified at high risk of delay, implement an automated notification system to update customers proactively, reducing negative reviews and support tickets.

### 2. Customer Retention & Marketing (RFM Insights)
* **Targeted Campaigns for "Champions":** The RFM segmentation identified our top "Champions" segment. Olist should create exclusive loyalty programs, early access sales, or personalized recommendations to retain these high-value customers.
* **Win-Back Strategies for "At Risk" & "Lost":** Design automated email marketing campaigns with special discounts aimed at re-engaging customers in the "At Risk" and "About to Sleep" categories before they churn permanently.

### 3. Geographic & Category Expansion
* **Focus on High-Performing States:** Sales analysis revealed top-performing states (e.g., SP, RJ, MG). Marketing budgets should be heavily concentrated in these regions for high ROI, while investigating conversion bottlenecks in lower-performing states.
* **Inventory & Seller Support:** Support top-selling product categories with better inventory forecasting and onboard more sellers in high-demand categories to prevent stockouts.

## 🚀 Future Work (Machine Learning Integration)
Delivery Delay Prediction: Building a classification model to predict order delay risks based on feature engineering.

Customer Churn Prediction: Utilizing the extracted RFM features to predict customer churn using Scikit-Learn.
