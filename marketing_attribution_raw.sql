SELECT *
FROM page_visits
LIMIT 20;

SELECT COUNT(DISTINCT utm_campaign) AS 'utm_campaign_count', 
  COUNT(DISTINCT utm_source) AS 'utm_source_count'
FROM page_visits;

SELECT DISTINCT utm_campaign, utm_source
FROM page_visits;

WITH first_touch AS (
  SELECT user_id,
     MIN(timestamp) AS 'first_touch_at'
  FROM page_visits
  GROUP BY user_id)
SELECT *
FROM first_touch
LIMIT 10;

WITH last_touch AS (
  SELECT user_id,
     MAX(timestamp) AS 'last_touch_at'
  FROM page_visits
  GROUP BY user_id)
SELECT *
FROM last_touch
LIMIT 10;

WITH first_touch AS (
  SELECT user_id,
      MIN(timestamp) AS 'first_touch_at'
  FROM page_visits
  GROUP BY user_id)
SELECT pv.utm_source,
  pv.utm_campaign,
  COUNT(utm_campaign) AS 'first_touch_count'
FROM first_touch ft
JOIN page_visits pv
  ON ft.user_id = pv.user_id
  AND ft.first_touch_at = pv.timestamp
GROUP BY utm_campaign
ORDER BY 3 DESC;

WITH last_touch AS (
  SELECT user_id,
    MAX(timestamp) AS 'last_touch_at'
  FROM page_visits
  GROUP BY user_id)
SELECT pv.utm_source,
  pv.utm_campaign,
  COUNT(utm_campaign) AS 'last_touch_count'
FROM last_touch lt
JOIN page_visits pv
  ON lt.user_id = pv.user_id
  AND lt.last_touch_at = pv.timestamp
GROUP BY utm_campaign
ORDER BY 3 DESC;

SELECT COUNT(DISTINCT user_id) AS 'total_purchase_count'
FROM page_visits
WHERE page_name = '4 - purchase';

WITH last_touch AS (
  SELECT user_id,
  MAX(timestamp) AS 'last_touch_at'
FROM page_visits
WHERE page_name = '4 - purchase'
GROUP BY user_id)
SELECT pv.utm_source,
  pv.utm_campaign,
  COUNT(utm_campaign) AS 'purchase_count'
FROM last_touch lt
JOIN page_visits pv
  ON lt.user_id = pv.user_id
  AND lt.last_touch_at = pv.timestamp
GROUP BY utm_campaign
ORDER BY 3 DESC;