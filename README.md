# Using BigQuery for Digital Marketing Metrics Analysis with SQL and Visualization with Looker Studio

## Project Overview
This project focuses on analyzing key digital marketing metrics using SQL. The project involved analyzing and visualizing marketing data to gain actionable insights into campaign performance, customer behavior, and conversion rates.

Data Source: https://www.kaggle.com/datasets/sinderpreet/analyze-the-marketing-spending

| id  | c_date       | campaign_name   | category | campaign_id | impressions | mark_spent | clicks | leads | orders | revenue    |
|-----|--------------|-----------------|----------|-------------|------------|-------------|-------|-------|---------|------------|
| 11  | 2021-02-01   | banner_partner  | media    | 39889       | 20,900,000 | 931.99      | 2,090 | 3     | 0       | 0.0        |
| 22  | 2021-02-02   | banner_partner  | media    | 39889       | 42,000,000 | 46,159.8    | 4,200 | 92    | 13      | 51,753.0   |
| 33  | 2021-02-03   | banner_partner  | media    | 39889       | 125,910,000| 29,378.3    | 12,591| 68    | 13      | 51,753.0   |
| 44  | 2021-02-04   | banner_partner  | media    | 39889       | 41,924,802 | 177,746.0   | 16,806| 336   | 60      | 204,540.0  |
| 55  | 2021-02-05   | banner_partner  | media    | 39889       | 8,238,872  | 427,922.0   | 20,997| 796   | 119     | 471,240.0  |
| ... | ..........   | ..............  | .....    | .....       | .........  | .........   | ..... | ...   | ..      | .........  |


## Features
- SQL Queries for Analysis:
  - Overall ROMI (Return on Marketing Investment) analysis.
  - ROMI analysis by campaign.
  - Buyer's most active time: What is the average revenue on weekdays and weekends?
  - Which campaign types are most effective: Social Media, Banner, Influencer or Search?
- Output data that is ready to be visualized for dashboards

## Analyzing Results
The results of the analysis in this project are focused on providing deep insights into the effectiveness of the marketing strategies that have been implemented. This analysis aims to assist the company in optimizing marketing budget allocation and improving campaign performance. The business questions answered through this analysis include:
- What is the total Return on Marketing Investment (ROMI) generated overall.
- Which campaign provided the highest ROMI.
- On which dates were the largest marketing costs incurred.
- What is the average number of daily orders overall and per campaign.
- What is the average revenue on weekdays and holidays.
- Which campaigns were most effective based on ROMI and Click-Through Rate (CTR).

### Overall ROMI & Campaign
ROMI is used to measure the effectiveness of marketing campaigns by comparing the revenue generated against the marketing costs incurred. used to measure the effectiveness of marketing campaigns by comparing the revenue generated against the marketing costs incurred.
```
-- Overall ROMI
SELECT 
  ROUND(((SUM(revenue) - SUM(mark_spent)) / SUM(mark_spent)) * 100, 2) AS overall_romi_percentage
FROM
  `united-triode-446917-s6.marketing_data.marketing`
```

```
-- ROMI by campaigns
SELECT
  campaign_name,
  ROUND((SUM(revenue) - SUM(mark_spent)) / SUM(mark_spent) * 100, 2) AS ROMI
FROM
  `united-triode-446917-s6.marketing_data.marketing`
GROUP BY campaign_name
ORDER BY ROMI DESC
```

here the results at this point look like
| overall_romi_percentage |
| -----------------------:|
|         40.2            |

Overall ROMI

| campaign_name         | ROMI   |
|---------------------- |-------:|
| youtube_blogger       | 277.32 |
| facebook_retargeting  | 101.50 |
| google_hot            |  83.81 |
| instagram_tier1       |  77.14 |
| instagram_blogger     |  36.75 |
| banner_partner        |  22.41 |
| facebook_tier1        |  -6.57 |
| facebOOK_tier2        | -26.22 |
| google_wide           | -33.67 |
| instagram_tier2       | -37.11 |
| facebook_lal          | -88.64 |

ROMI by campaigns

### Dates that spend the most on advertising
The following query is used to find out the dates with the highest ad spend. This analysis is important for identifying periods where companies made large investments in marketing campaigns.

```
SELECT
  c_date,
  SUM(mark_spent) AS total_mark_spent
FROM
  `united-triode-446917-s6.marketing_data.marketing`
GROUP BY
  c_date
ORDER BY total_mark_spent DESC 
LIMIT 5
```

| c_date     | total_mark_spent |
|------------|------------------:|
| 2021-02-20 |       3,499,171.70 |
| 2021-02-17 |       3,271,291.50 |
| 2021-02-19 |       3,091,011.34 |
| 2021-02-16 |       3,035,499.00 |
| 2021-02-18 |       2,158,494.20 |

### Average orders on each date
The following query is used to calculate the average number of orders on each campaign date. This analysis is useful for understanding daily sales performance trends and helps in evaluating the effectiveness of marketing strategies on a particular day.
```
SELECT
  c_date,
  ROUND(AVG(orders), 2) as avg_orders
FROM
  `united-triode-446917-s6.marketing_data.marketing`
GROUP BY 
  c_date
```

| c_date     | avg_orders |
|------------|-----------:|
| 2021-02-01 |      2.73  |
| 2021-02-02 |      4.91  |
| 2021-02-03 |     24.82  |
| 2021-02-04 |     28.55  |
| 2021-02-05 |     43.18  |

### Average order value for each campaign
Query berikut digunakan untuk menghitung nilai rata-rata per pesanan (AOV) untuk setiap kampanye. AOV adalah metrik yang berguna untuk mengevaluasi berapa banyak pendapatan yang dihasilkan dari setiap pesanan dalam suatu kampanye. Ini dapat memberikan wawasan tentang seberapa efektif sebuah kampanye dalam menghasilkan pendapatan per transaksi.

```
SELECT
  campaign_name,
  ROUND(SUM(revenue) / SUM(orders), 2) as aov
FROM
  `united-triode-446917-s6.marketing_data.marketing`
GROUP BY 
  campaign_name
ORDER BY aov DESC
```

| campaign_name         |    AOV   |
|---------------------- |---------:|
| youtube_blogger       |  7,999.70 |
| google_hot            |  7,849.63 |
| instagram_tier1       |  5,994.89 |
| instagram_blogger     |  5,280.41 |
| facebook_tier1        |  5,055.72 |
| facebOOK_tier2        |  5,033.88 |
| facebook_retargeting  |  4,971.47 |
| banner_partner        |  3,929.09 |
| google_wide           |  2,740.98 |
| instagram_tier2       |  2,142.04 |
| facebook_lal          |  1,021.20 |

### When buyers are more active? What is the average revenue on weekdays and weekends?
The following query is used to find out the difference in average revenue between weekdays and weekends. This is important for understanding when shoppers are more active, as well as identifying days with higher marketing performance.

```
with DayType AS(
  SELECT
    c_date,
    campaign_name,
    orders,
    revenue,
    CASE
      WHEN EXTRACT(DAYOFWEEK FROM c_date) IN (1, 7) THEN 'Weekend'
      ELSE 'Weekday'
    END AS day_type
  FROM
    `united-triode-446917-s6.marketing_data.marketing`
)
SELECT
  day_type,
  AVG(revenue) AS avg_revenue,
  SUM(orders) AS total_transactions,
  SUM(revenue) AS total_revenue
FROM
  DayType
GROUP BY
  day_type
```

| day_type | avg_revenue  | total_transactions | total_revenue |
|----------|-------------:|-------------------:|--------------:|
| Weekday  | 141,914.24  |              5,763 |   31,221,133 |
| Weekend  | 132,593.56  |              2,280 |   11,668,233 |

### Which campaigns were most effective based on ROMI and Click-Through Rate (CTR)
The following query is used to identify the most effective campaigns based on two key metrics: Return on Marketing Investment (ROMI) and Click-Through Rate (CTR). By analyzing these two metrics, companies can understand which campaigns provide the highest value in terms of revenue generated compared to marketing costs and the extent to which campaigns attract user attention.

```
SELECT
  category,
  SUM(revenue) AS total_revenue,
  SUM(mark_spent) AS total_mark_spent,
  SUM(clicks) AS total_clicks,
  SUM(leads) AS total_leads,
  ROUND((SUM(revenue) - SUM(mark_spent)) / SUM(mark_spent) * 100, 2) AS ROI,
  ROUND(SUM(clicks) / SUM(leads) * 100, 2) AS CTR,
FROM
  `united-triode-446917-s6.marketing_data.marketing`
GROUP BY 
  category
ORDER BY
  ROI DESC

```

| category   | total_revenue | total_mark_spent | total_clicks | total_leads |    ROI   |    CTR   |
|------------|--------------:|-----------------:|-------------:|------------:|---------:|---------:|
| influencer |   21,119,887 |      8,305,304.08 |      749,973 |      16,939 |  154.29% | 4,427.49 |
| media      |    6,152,960 |      5,026,674.76 |      420,003 |      10,149 |   22.41% | 4,138.37 |
| search     |    3,705,065 |      3,460,400.07 |      330,054 |       7,107 |    7.07% | 4,644.07 |
| social     |   11,911,454 |     13,798,500.91 |    1,499,889 |      31,384 |  -13.68% | 4,779.15 |

## Dashboard

Dashboard Link: https://lookerstudio.google.com/reporting/2d1dc0bd-30f9-4585-878a-abe6cb986e06

![dashboard digital marketing](https://github.com/user-attachments/assets/82c0a3ca-e0ab-44e8-81db-2f30d93b932a)

## Tech Stack
- SQL(BigQuery)
- Looker Studio
