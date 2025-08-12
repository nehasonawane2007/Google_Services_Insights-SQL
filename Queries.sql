-- User Engagement on YouTube --
--/# 1. Which country has the highest number of video uploads? #/

SELECT u.country, COUNT(v.video_id) AS total_videos
FROM google_users u
JOIN youtube_videos v 
ON u.user_id = v.user_id
GROUP BY u.country
ORDER BY total_videos DESC
LIMIT 1;


-- /# 2.Display the total views received by users from each country. #/

SELECT u.country, SUM(v.views) AS total_views
FROM google_users u
LEFT JOIN youtube_videos v
ON u.user_id = v.user_id
GROUP BY u.country
ORDER BY total_views DESC;


-- /# 3. Which users upload videos in more than 3 categories? #/

SELECT u.user_name, COUNT(DISTINCT v.category) AS category_count
FROM google_users u
JOIN youtube_videos v 
ON u.user_id = v.user_id
GROUP BY u.user_name
HAVING COUNT(DISTINCT v.category) > 3;


-- /# 4.Who are the top 10 users with the most uploaded videos? #/

SELECT user_id, COUNT(video_id) AS total_videos 
FROM youtube_videos 
GROUP BY user_id
ORDER BY total_videos DESC
LIMIT 10;


-- /# 5. Show user_name, email, country, and total number of videos uploaded for users who have uploaded more than 5 videos. #/

SELECT u.user_name AS user_name, u.email, u.country, COUNT(v.video_id) AS total_videos
FROM google_users u
JOIN youtube_videos v 
ON u.user_id = v.user_id
GROUP BY u.user_name, u.email, u.country
HAVING COUNT(v.video_id) > 5
ORDER BY total_videos DESC;


-- Transaction & Payment Patterns --
--/# 6. List users whose total credit amount is higher than total debit amount. #/

SELECT u.user_name, c.credit, d.debit
FROM (
    SELECT user_id, SUM(amount) AS credit
    FROM google_pay_transactions
    WHERE LOWER(transaction_type) = 'credit'
    GROUP BY user_id
) c
JOIN (
    SELECT user_id, SUM(amount) AS debit
    FROM google_pay_transactions
    WHERE LOWER(transaction_type) = 'debit'
    GROUP BY user_id
) d
ON c.user_id = d.user_id
JOIN google_users u ON u.user_id = c.user_id
WHERE c.credit > d.debit;


-- /# 7. Count number of credit and debit transactions per user. #/

SELECT user_id,
SUM(CASE WHEN transaction_type = 'credit' THEN 1 ELSE 0 END) AS credit_count,
SUM(CASE WHEN transaction_type = 'debit' THEN 1 ELSE 0 END) AS debit_count
FROM google_pay_transactions
GROUP BY user_id;

 
-- /# 8.Which users made transactions in more than 3 different merchants? #/

SELECT user_id, count(distinct merchant) AS total_merchant
from google_pay_transactions
GROUP BY user_id
HAVING total_merchant > 3;


-- /# 9. What is the average transaction amount per merchant? #/

SELECT merchant, ROUND(AVG(amount), 2) AS avg_amount
FROM google_pay_transactions
GROUP BY merchant
ORDER BY avg_amount DESC;


-- /# 10. Which merchant has the highest total transaction amount? #/

SELECT merchant, SUM(amount) AS total_amount
FROM google_pay_transactions
GROUP BY merchant
ORDER BY total_amount DESC
LIMIT 1;


-- Search Behavior --
-- /# 11. Find users who made more than 5 searches in the year 2023. #/

SELECT user_id, COUNT(*) AS total_searches
FROM google_search_history
WHERE YEAR(search_time) = 2023
GROUP BY user_id
HAVING COUNT(*) > 5
ORDER BY total_searches DESC;


-- /# 12. How many unique users searched for “news today”? #/

SELECT COUNT(DISTINCT user_id) AS unique_users
FROM google_search_history
WHERE LOWER(search_query) = 'news today';


-- /# 13. Which country’s users search the most? #/

SELECT u.country, COUNT(s.search_id) AS total_searches
FROM google_users u
JOIN google_search_history s ON u.user_id = s.user_id
GROUP BY u.country
ORDER BY total_searches DESC
LIMIT 1;


-- /# 14. Find users name who performed more than 4 searches in total? #/

SELECT u.user_name, COUNT(s.search_id) AS search_count
FROM google_users u
JOIN google_search_history s ON u.user_id = s.user_id
GROUP BY u.user_name
HAVING COUNT(s.search_id) > 4
ORDER BY search_count DESC;


-- /# 15. Count the number of users who made at least one search containing "buy". #/

SELECT COUNT(DISTINCT user_id) AS buy_search_users
FROM google_search_history
WHERE LOWER(search_query) LIKE '%buy%';


-- Cross-Platform Behavior --
-- /# 16. Count how many users have interacted with all three platforms. #/

SELECT COUNT(u.user_id) FROM google_users u
INNER JOIN
(SELECT DISTINCT user_id FROM youtube_videos) v
ON u.user_id = v.user_id
INNER JOIN
(SELECT DISTINCT user_id FROM google_search_history) s
ON u.user_id = s.user_id
INNER JOIN
(SELECT DISTINCT user_id FROM google_pay_transactions) t
ON u.user_id = t.user_id;


--/# 17. Get each user’s name and how many searches and how many videos they have uploaded. #/ 

SELECT u.user_name, 
COALESCE(s.total_searches, 0) AS total_searches,
COALESCE(v.total_videos, 0) AS total_videos
FROM google_users u
LEFT JOIN (
    SELECT user_id, COUNT(*) AS total_searches
    FROM google_search_history
    GROUP BY user_id
) s ON u.user_id = s.user_id
LEFT JOIN (
    SELECT user_id, COUNT(*) AS total_videos
    FROM youtube_videos
    GROUP BY user_id
) v ON u.user_id = v.user_id;


-- /# 18. Show users who uploaded more than 2 videos and made more than 2 transactions. #/

SELECT u.user_id, v.total_videos, p.total_transactions
FROM (
    SELECT user_id, COUNT(*) AS total_videos
    FROM youtube_videos
    GROUP BY user_id) v
JOIN 
(
    SELECT user_id, COUNT(*) AS total_transactions
    FROM google_pay_transactions
    GROUP BY user_id
) p
ON v.user_id = p.user_id
JOIN google_users u ON u.user_id = v.user_id
WHERE v.total_videos > 2 AND p.total_transactions > 2
ORDER BY u.user_id;


-- /# 19. Get the total number of videos, transactions, and searches done by each user. #/

SELECT u.user_id, u.user_name AS user_name,
COUNT(DISTINCT v.video_id) AS total_videos,
COUNT(DISTINCT t.transaction_id) AS total_transactions,
COUNT(DISTINCT s.search_id) AS total_searches
FROM google_users u
LEFT JOIN youtube_videos v 
ON u.user_id = v.user_id
LEFT JOIN google_pay_transactions t
ON u.user_id = t.user_id
LEFT JOIN google_search_history s
ON u.user_id = s.user_id
GROUP BY u.user_id, u.user_name
ORDER BY u.user_id;


-- /# 20. Find user names who uploaded videos but never made a transaction? #/

SELECT DISTINCT u.user_name
FROM google_users u
JOIN youtube_videos v 
ON u.user_id = v.user_id
WHERE u.user_id NOT IN (SELECT user_id FROM google_pay_transactions);
