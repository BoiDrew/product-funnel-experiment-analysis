CREATE DATABASE IF NOT EXISTS ecommerce_analystics;
USE ecommerce_analystics;

CREATE TABLE IF NOT EXISTS ecommerce_events(
    UserID INT,
    SessionID INT,
    `Timestamp` VARCHAR(50),
    EventType VARCHAR(50),
    ProductID VARCHAR(50),
    Amount DECIMAL(10,2),
    Outcome VARCHAR(50)
);

SET GLOBAL local_infile = 1;

USE ecommerce_analytics;

LOAD DATA INFILE
'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/ecommerce_clickstream_transactions.csv'
INTO TABLE ecommerce_events
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(
    UserID,
    SessionID,
    `Timestamp`,
    EventType,
    ProductID,
    @Amount,
    Outcome
)
SET
    Amount = NULLIF(@Amount, '');

SHOW VARIABLES LIKE 'local_infile';

SELECT COUNT(*) FROM ecommerce_events;

SELECT Amount 
	FROM ecommerce_events
    WHERE EventType ='purchase' LIMIT 5;
    
    
 /* =========================================================
   Project 3 — B2C E-commerce Funnel Metrics
   Database: ecommerce_analytics
   Table: ecommerce_events

   Purpose:
   - Build a user-level, sequence-based funnel
   - Avoid presence-based (inflated) conversion rates
   - Identify true drop-offs
   ========================================================= */

  --  1. Filter only funnel-relevant events
  
WITH funnel_events AS (
    SELECT
        UserID,
        EventType,
        CAST(`Timestamp` AS DATETIME) AS event_time
    FROM ecommerce_events
    -- Only keep events that belong to the funnel

    WHERE EventType IN (
        'page_view',
        'product_view',
        'add_to_cart',
        'purchase'
    )
),


--  2. First occurrence of each step per user

first_events AS(
SELECT
        UserID,
        MIN(CASE WHEN EventType = 'page_view' THEN event_time END)    AS page_view_time,
        MIN(CASE WHEN EventType = 'product_view' THEN event_time END) AS product_view_time,
        MIN(CASE WHEN EventType = 'add_to_cart' THEN event_time END)  AS add_to_cart_time,
        MIN(CASE WHEN EventType = 'purchase' THEN event_time END)     AS purchase_time
    FROM funnel_events
    GROUP BY UserID
),


user_funnel AS (
    SELECT
        UserID,

        /* Step 1: Page View */
        CASE
            WHEN page_view_time IS NOT NULL THEN 1
            ELSE 0
        END AS page_view,

        /* Step 2: Product View (must have page view first) */
        CASE
            WHEN page_view_time IS NOT NULL
             AND product_view_time IS NOT NULL
             AND product_view_time > page_view_time
            THEN 1 ELSE 0
        END AS product_view,

        /* Step 3: Add to Cart */
        CASE
            WHEN page_view_time IS NOT NULL
			 AND product_view_time IS NOT NULL
             AND add_to_cart_time IS NOT NULL
             AND product_view_time > page_view_time
             AND add_to_cart_time > product_view_time
            THEN 1 ELSE 0
        END AS add_to_cart,

        /* Step 4: Purchase */
        CASE
            WHEN page_view_time IS NOT NULL
             AND product_view_time IS NOT NULL
             AND add_to_cart_time IS NOT NULL
             AND purchase_time IS NOT NULL
             AND product_view_time > page_view_time
             AND add_to_cart_time > product_view_time
             AND purchase_time > add_to_cart_time
            THEN 1 ELSE 0
        END AS purchase

    FROM first_events
)

SELECT
    COUNT(*) AS total_users,

    SUM(page_view)     AS page_view_users,
    SUM(product_view)  AS product_view_users,
    SUM(add_to_cart)   AS add_to_cart_users,
    SUM(purchase)      AS purchase_users,
    
      /* Conversion rates */
    ROUND(SUM(product_view) * 1.0 / NULLIF(SUM(page_view), 0), 4)
        AS page_to_product_conversion,

    ROUND(SUM(add_to_cart) * 1.0 / NULLIF(SUM(product_view), 0), 4)
        AS product_to_cart_conversion,

    ROUND(SUM(purchase) * 1.0 / NULLIF(SUM(add_to_cart), 0), 4)
        AS cart_to_purchase_conversion
FROM user_funnel;