# Zomato Bangalore Restaurant Analysis (MySQL)

This project is a comprehensive Exploratory Data Analysis (EDA) of the Zomato Bangalore restaurant dataset. The primary goal is to clean and transform messy, real-world data using MySQL and then query the clean data to derive actionable insights into the Bangalore restaurant market.

## 🚀 Project Overview

This analysis aims to answer key questions for a new entrepreneur looking to enter the Bangalore food market. By cleaning and analyzing Zomato's data, we can provide a data-driven strategy on:

* **Market Saturation:** What are the most common restaurant types?
* **Competitive Landscape:** Which chains are the most dominant?
* **Customer Preferences:** What is the distribution of restaurant ratings?
* **Operational Strategy:** Does offering online ordering *actually* impact customer ratings?
* **Location Analysis:** Which locations offer the best balance of high average ratings and manageable costs?

## 📊 Dataset

* **Source:** [Zomato Bangalore Restaurants on Kaggle](https://www.kaggle.com/datasets/himanshupandey/zomato-bangalore-restaurants)
* **Size:** ~51,700 restaurant entries
* **Format:** A single CSV file (`zomato.csv`)

## 🛠️ Tools Used

* **Database:** MySQL
* **Client:** MySQL Workbench (or any SQL client)

## 🧹 Data Cleaning

The raw dataset was notoriously "dirty" and required significant cleaning before any analysis could be performed. All cleaning steps were performed exclusively in MySQL.

The main cleaning tasks included:

* **`rate` Column:**
    * **Before:** Strings like "4.1/5", "NEW", "NaN", and "3.9 /5".
    * **After:** Converted to a clean `DECIMAL(3,1)` column (`rate_numeric`), with "NEW" and "NaN" treated as `NULL`.

* **`approx_cost_for_two_people` Column:**
    * **Before:** Comma-separated strings like "1,500".
    * **After:** Converted to a clean `INT` column (`cost_for_two_int`) after removing commas.

* **`phone` Column:**
    * **Before:** Inconsistent, with multiple numbers separated by "/" or smashed together (e.g., `+91.../+91...`).
    * **After:** Standardized to be comma-separated using `REPLACE` and `REGEXP_REPLACE`.

* **`reviews_list` Column:**
    * **Before:** Contained double quotes (`"`) that could break data integrity.
    * **After:** All double quotes were removed.

* **Empty Strings (`''`)**:
    * Standardized empty strings in key columns (`location`, `rest_type`, `cuisines`, etc.) to `NULL` for accurate aggregations.

* **Column Management:**
    * Dropped the old, "dirty" columns (`rate`, `approx_cost_for_two_people`) after verifying the new, clean columns.

## 📈 Exploratory Data Analysis & Insights
## ppt can be viewed after downloading



## 📋 How to Use

1.  **Clone Repository:**
    ```sh
    git clone [YOUR_REPOSITORY_LINK]
    ```
2.  **Database Setup:**
    * Create a new database (schema) in MySQL (e.g., `zomato_project`).
    * Run the `CREATE TABLE` query (found in the `.sql` file) to create the `restaurants` table.
3.  **Load Data:**
    * Download the `zomato.csv` file from the [Kaggle link](https://www.kaggle.com/datasets/himanshupandey/zomato-bangalore-restaurants).
    * Load the CSV into your table. You may need to use the `LOAD DATA LOCAL INFILE` command.
4.  **Run Analysis:**

    * Execute the `[your-file-name].sql` file in your MySQL client to perform all cleaning and analysis steps.
