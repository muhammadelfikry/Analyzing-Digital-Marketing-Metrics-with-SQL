-- Overall ROMI
SELECT 
  id,
  c_date,
  campaign_name,
  category,
  mark_spent,
  revenue,
  ROUND((revenue - mark_spent) / mark_spent * 100) AS ROMI
FROM
  `united-triode-446917-s6.marketing_data.marketing`

-- ROMI by campaigns
SELECT
  campaign_name,
  (SUM(revenue) - SUM(mark_spent)) / SUM(mark_spent) * 100 AS ROMI
FROM
  `united-triode-446917-s6.marketing_data.marketing`
GROUP BY campaign_name

-- Dates that spend the most on advertising
SELECT
  c_date,
  SUM(mark_spent) AS total_mark_spent
FROM
  `united-triode-446917-s6.marketing_data.marketing`
GROUP BY
  c_date
ORDER BY total_mark_spent DESC 
LIMIT 5


-- Average order on each date
SELECT
  c_date,
  AVG(orders) as avg_orders
FROM
  `united-triode-446917-s6.marketing_data.marketing`
GROUP BY 
  c_date

-- Average order value for this campaign
SELECT
  campaign_name,
  SUM(revenue) / SUM(orders) as aov
FROM
  `united-triode-446917-s6.marketing_data.marketing`
GROUP BY 
  campaign_name
ORDER BY aov DESC

-- When buyers are more active? What is the average revenue on weekdays and weekends?
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

-- Which types of campaigns work best
SELECT
  category,
  SUM(revenue) AS total_revenue,
  SUM(mark_spent) AS total_mark_spent,
  SUM(clicks) AS total_clicks,
  SUM(leads) AS total_leads,
  (SUM(revenue) - SUM(mark_spent)) / SUM(mark_spent) * 100 AS ROI,
  SUM(clicks) / SUM(leads) * 100 AS CTR,
FROM
  `united-triode-446917-s6.marketing_data.marketing`
GROUP BY 
  category
ORDER BY
  ROI DESC

