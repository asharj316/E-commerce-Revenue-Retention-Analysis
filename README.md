# E-commerce-Revenue-Retention-Analysis
Analyzed 50,000+ e-commerce transactions to identify high-value 'Power Users' and calculate category revenue share to optimize inventory velocity.
# 📊 Pakistan E-commerce: Revenue & Retention Analysis (PostgreSQL)

## 📋 Executive Summary
This project analyzes over 500,000 transactions from one of Pakistan’s largest e-commerce datasets. The goal was to move beyond basic sales tracking to uncover **Customer Lifetime Value (CLV)** and **Inventory Velocity**. By using advanced PostgreSQL techniques, I identified "Power Users" and calculated the precise revenue contribution of each product category.

## 🚀 Key Business Questions Answered
* **Customer Retention:** Who are the "Power Users" (repeat buyers) driving the most value?
* **Revenue Share:** What percentage of total company revenue does each category contribute?
* **Inventory Velocity:** Which categories are moving the fastest vs. which are stagnant?

## 🛠️ Technical Skills Demonstrated
* **Window Functions:** `SUM() OVER()` to calculate grand totals for share analysis.
* **Ranking Functions:** `DENSE_RANK()` to categorize inventory movement.
* **Data Cleaning:** Handled NULL values and performed type casting (`::NUMERIC`) to ensure precision in financial calculations.
* **Advanced Aggregation:** Used `HAVING` and `GROUP BY` to segment high-value customer groups.

## 💡 Top 3 Business Insights
1. **The Power User Gap:** Identified that users with 2+ orders contribute significantly more to the bottom line than one-time shoppers, suggesting a need for a targeted loyalty program.
2. **High-Margin Anchors:** Certain categories like 'Electronics' have lower velocity but dominate Revenue Share—these are the business's financial anchors.
3. **The Precision Factor:** By fixing Integer Division issues in SQL, I ensured that revenue reports are accurate to two decimal places, preventing rounding errors in financial forecasting.

---
*Note: Due to GitHub file size limits (100MB+), the raw dataset is linked below rather than hosted in this repo.*
[Pakistan's Largest E-Commerce Dataset
](https://www.kaggle.com/datasets/zusmani/pakistans-largest-ecommerce-dataset)
