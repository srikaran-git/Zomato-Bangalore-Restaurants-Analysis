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

After cleaning, the following questions were analyzed:

### 1. What are the most common restaurant types?
* **Insight:** The market is overwhelmingly dominated by **Quick Bites** (19,132 restaurants) and **Casual Dining** (10,330 restaurants). This suggests a high demand for fast, convenient, and informal dining.

```sql
-- Query Used:
SELECT
    rest_type,
    COUNT(*) AS restaurant_count
FROM restaurants
WHERE rest_type IS NOT NULL
GROUP BY rest_type
ORDER BY restaurant_count DESC
LIMIT 10;
```

### 2. Which restaurant chains have the most branches?
* **Insight:** **Cafe Coffee Day** (96 branches) and **Onesta** (85 branches) are the largest chains, highlighting the scalability of cafe and casual pizza models.

```sql
-- Query Used:
SELECT `name`, COUNT(`name`)
FROM restaurants
GROUP BY `name`
ORDER BY COUNT(`name`) DESC
LIMIT 5;
```

### 3. How does online ordering affect ratings?
* **Insight:** The impact is minimal. While more restaurants offer online ordering (30.4k) than don't (21.2k), the average rating is nearly identical.
    * **Accepts Online Orders:** 3.72 Average Rating
    * **Doesn't Accept:** 3.66 Average Rating

```sql
-- Query Used:
SELECT
    online_order,
    COUNT(*) AS num_restaurants,
    ROUND(AVG(rate_numeric), 2) AS avg_rating
FROM restaurants
WHERE online_order IS NOT NULL
GROUP BY online_order;
```

### 4. What is the distribution of restaurant ratings?
* **Insight:** The vast majority of restaurants **(30,192)** fall into the "Average" 3.0-4.0 rating bracket. Only **9,216** restaurants achieved a "High" rating (above 4.0), showing that high customer satisfaction is a significant differentiator.

```sql
-- Query Used:
SELECT
    COUNT(CASE WHEN rate_numeric > 4.0 THEN 1 END) AS high_rating,
    COUNT(CASE WHEN rate_numeric BETWEEN 3.0 AND 4.0 THEN 1 END) AS average_rating,
    COUNT(CASE WHEN rate_numeric < 3.0 THEN 1 END) AS low_rating
FROM restaurants;
```

### 5. What is the average rating and cost by location?
* **Insight:** *(This is where you would add your findings from the location query).*
* **Example:** "The analysis showed that locations like [Your-Top-Location] have a high average rating (e.g., 4.2) while maintaining a low average cost (e.g., ₹600), making them 'best value' neighborhoods. In contrast, [Your-Premium-Location] has the highest ratings but also the highest costs."

```sql
-- Query Used:
SELECT
    location,
    ROUND(AVG(rate_numeric), 2) AS avg_rating,
    ROUND(AVG(cost_for_two_int), 2) AS avg_cost_for_two
FROM restaurants
GROUP BY location
ORDER BY avg_rating DESC, avg_cost_for_two ASC;
```

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