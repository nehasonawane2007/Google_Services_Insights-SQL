📊 Google Platforms Data Analysis SQL Scripts

🚀 Overview

Welcome to the Google Platforms Data Analysis repository!
This project contains SQL scripts designed to analyze user behavior across multiple Google services — YouTube, Google Pay, and Google Search.
The queries provide insights into content engagement, spending habits, search behavior, and cross-platform interactions.

The scripts cover:
- Dataset integration
- Data exploration & cleaning
- Advanced analytical queries using JOINs, subqueries, window functions, and CTEs

📂 Files Included

📌 Queries.sql – Contains all SQL queries grouped by:

- YouTube Engagement Analysis
- Transaction & Payment Patterns
- Search Behavior Analysis
- Cross-Platform Behavior Insights

📌 Datasets Folder – Includes:

- google_users.csv – User profile data
- youtube_videos.csv – Video upload data
- google_pay_transactions.csv – Financial transaction data
- google_search_history.csv – Search activity logs

🗄 Database Schema
The project involves four interconnected tables:

1️⃣ google_users – Stores user profile information:
* user_id – Unique ID for each user (Primary Key)
* user_name – Name of the user
* email – Email address
* country – User’s country

2️⃣ youtube_videos – Stores uploaded video details:

* video_id – Unique ID for each video
* user_id – Linked to google_users.user_id
* category – Video category
* views – Number of views received
* upload_date – Date of upload

3️⃣ google_pay_transactions – Stores financial transaction details:

* transaction_id – Unique transaction ID
* user_id – Linked to google_users.user_id
* amount – Transaction amount
* transaction_type – Credit or Debit
* merchant – Merchant name
* transaction_date – Date of transaction

4️⃣ google_search_history – Stores search logs:

* search_id – Unique search ID
* user_id – Linked to google_users.user_id
* search_query – Search term
* search_time – Date & time of the search

📊 Analytical Queries & Insights

The Queries.sql file includes:

🔹 1️⃣ YouTube Engagement Analysis
- Find the country with the highest number of video uploads
- Identify users uploading videos in more than 3 categories
- Top 10 users with the most uploaded videos
- Country-wise total views

🔹 2️⃣ Transaction & Payment Patterns
- Users with total credit > total debit
- Count of credit vs debit transactions per user
- Merchant with the highest total transaction value
- Average transaction amount per merchant

🔹 3️⃣ Search Behavior Analysis
- Users making more than 5 searches in 2023
- Most searched keywords and their frequency
- Country with the highest number of searches
- Users searching for “buy” in their queries

🔹 4️⃣ Cross-Platform Insights
- Users active on all three platforms
- Correlation between video uploads and transactions
- Total activities per user across platforms

⚙️ How to Use

💾 Prerequisites

A SQL database engine such as:

✅ MySQL  
✅ PostgreSQL  
✅ SQL Server

▶️ Execution Steps:

1️⃣ Import the CSV datasets into your database as tables.

2️⃣ Run queries from Queries.sql in your SQL editor.

3️⃣ Modify queries or join conditions to explore deeper insights.

👨‍💻 Author

📌 Neha Sonawane- Passionate about data analytics and cross-platform behavioral insights.

🔍 Happy Querying! 🚀📊

