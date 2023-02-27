/***** SQL *****/
/* 質問１: LEAD window 関数を使用して、データセットの次の行の売上を表示する新しい列 sales_next を表示します。*/

SELECT 
	*, 
	LEAD(sales, 1) OVER (ORDER BY order_date) AS sales_next
FROM superstore_time_series;

/* 質問２: データセットの前の行の値を表示するために、新しい列 sales_previous を作成します。.*/ 

SELECT 
	*, 
	LAG(sales, 1) OVER (ORDER BY order_date) AS sales_previous,
	LEAD(sales, 1) OVER (ORDER BY order_date) AS sales_next
FROM superstore_time_series;

/* 質問３: RANK関数を使って、売上に基づいてデータを降順にランク付けします。*/

SELECT 
	*, 
	RANK() OVER (ORDER BY sales DESC) AS sales_rank
FROM superstore_time_series;

/* 質問4: 一般的な集計関数を使用して、月次および日次の売上平均を表示します。*/

/* 月次 */
SELECT 
	DATE_FORMAT(order_date, '%Y-%m') as order_month,
	AVG(sales) AS average_sales
FROM superstore_time_series
GROUP BY order_month
ORDER BY order_month;

/* 日次 */
SELECT 
	DATE_FORMAT(order_date, '%Y-%m-%d') as order_day,
	AVG(sales) AS average_sales
FROM superstore_time_series
GROUP BY order_day
ORDER BY order_day;

/* 質問5: 2日連続の割引を分析する。
前日の割引を表示し前日との割引の差を表示します。*/

WITH tbl_prev_discount AS (
	SELECT 
		*, 
		LAG(discount, 1) OVER (ORDER BY order_date) AS discount_previous
	FROM superstore_time_series
)

SELECT 
	*, 
	discount - discount_previous AS discount_diff
FROM tbl_prev_discount;

/* 質問5: window関数を用いて7日間の移動平均を評価します。*/

WITH tbl_day_total_sales AS (
	SELECT 
		DATE_FORMAT(order_date, '%Y-%m-%d') as order_day,
		SUM(sales) AS total_sales
	FROM superstore_time_series
	GROUP BY order_day
	ORDER BY order_day
)

SELECT 
	*,
	AVG(total_sales) OVER(ORDER BY order_day ROWS BETWEEN 6 PRECEDING AND CURRENT ROW) as sales_SMA7
FROM tbl_day_total_sales;




