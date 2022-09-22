# marketing-attribution
This project uses fictional data for multi-touch attribution for a clothing retailer and calculates which of their marketing campaigns resulted in the most purchases. These insights were then used to determine which campaigns would be the most profitable to reinvest in. 

This analysis uses the *page_visits* table.
```sql
SELECT *
FROM page_visits
LIMIT 20;
```
<img width="800" alt="attribution_1" src="https://user-images.githubusercontent.com/96267643/191605246-e899920a-0c96-47b6-a21e-5788b9550536.png">

This query calculates the numbers of distinct campaigns and distinct sources, and then aligns each campaign to its source.
```sql
SELECT COUNT(DISTINCT utm_campaign) AS 'utm_campaign_count', 
  COUNT(DISTINCT utm_source) AS 'utm_source_count'
FROM page_visits;

SELECT DISTINCT utm_campaign, utm_source
FROM page_visits;
```
<img width="685" alt="attribution_2" src="https://user-images.githubusercontent.com/96267643/191606746-bb7f14f2-7feb-4da5-b126-d207044ff851.png">

Creation of temporary tables *first_touch* and *last_touch*, containing all users' initial and most recent visits to the website, respectively.
``` sql
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
```
<img width="442" alt="attribution_3" src="https://user-images.githubusercontent.com/96267643/191608350-19a5288d-825f-44ba-a8d2-a53339a14d09.png">

Joining *first_touch* and *page_visits* to calculate how many first touches each campaign is responsible for.
```sql
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
```
<img width="558" alt="attribution_4" src="https://user-images.githubusercontent.com/96267643/191790530-1194b505-d343-4b08-9d00-f4cdbc667229.png">

Joining *last_touch* and *page_visits* to calculate how many last touches each campaign is responsible for.
```sql
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
```
<img width="558" alt="attribution_5" src="https://user-images.githubusercontent.com/96267643/191790801-e352a6fb-5b73-4f31-bb40-6f268be384fd.png">

This query calculates how many visitors made a purchase.
```sql
SELECT COUNT(DISTINCT user_id) AS 'total_purchase_count'
FROM page_visits
WHERE page_name = '4 - purchase';
```
<img width="342" alt="attribution_6" src="https://user-images.githubusercontent.com/96267643/191791302-602c5816-369b-441e-931a-30654d5828db.png">

This query calculates how many last touches on the purchase page each campaign is responsible for.

The three most profitable campaigns are:
* Weekly newsletter email
* Retargetting ad on Facebook
* Retargetting campaign email
```sql
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
```
<img width="913" alt="attribution_7" src="https://user-images.githubusercontent.com/96267643/191791571-bcb44273-f511-410d-9835-ac90102c71bc.png">
