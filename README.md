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
  👉 **[Download OlistDB_backup.bak from Google Drive(ضع_رابط_الملف_هنا)**

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

## 🚀 Future Work (Machine Learning Integration)
Delivery Delay Prediction: Building a classification model to predict order delay risks based on feature engineering.

Customer Churn Prediction: Utilizing the extracted RFM features to predict customer churn using Scikit-Learn.