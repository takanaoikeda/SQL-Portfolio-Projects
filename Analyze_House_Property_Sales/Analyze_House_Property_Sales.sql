/***** SQL *****/
/* 質問１: 最も販売数が多いのはいつですか?*/

SELECT datesold, COUNT(datesold) AS sales_count
FROM raw_sales 
GROUP BY datesold
ORDER BY sales_count DESC
LIMIT 1;

/* 質問２: 販売あたりの平均価格が最も高い郵便番号はどれですか?
郵便番号ごとに販売額の平均価格を集計し平均価格が最も高い郵便番号を返すクエリを作成します。
郵便番号と平均価格を返します.*/ 

SELECT postcode, AVG(price) AS average_price
FROM raw_sales 
GROUP BY postcode
ORDER BY average_price DESC
LIMIT 1;

/* 質問３: 販売あたりの平均価格が最も高い郵便番号の平均の寝室の数はいくつですか？
販売あたりの平均価格が最も高い郵便番号から平均の寝室数を集計するクエリを作成します。
Invoice、Customer テーブルから取得します*/

WITH tbl_top_avgprice_postcode AS (
 	SELECT postcode, AVG(price) AS average_price
	FROM raw_sales 
 	GROUP BY postcode
 	ORDER BY average_price DESC
 	LIMIT 1
)

SELECT rs.postcode AS top_avgprice_postcode, AVG(rs.bedrooms) AS average_bedrooms
from raw_sales AS rs
JOIN tbl_top_avgprice_postcode AS ap ON rs.postcode = ap.postcode
GROUP BY rs.postcode

/* 質問4: 最も販売数が少ないのはどの年ですか?*/

SELECT 
	to_char(datesold,'YYYY') AS datesold_year,
	COUNT(datesold) AS sales_count
FROM raw_sales 
GROUP BY datesold_year
ORDER BY sales_count 
LIMIT 1;

/* 質問5: WINDOW関数を使用して年額で上位6つの郵便番号を推測します。
まずは各年で販売額が高い郵便番号をランクづけします。
その後、各年で販売額が高い郵便番号をナンバリングし上位６つを抽出します。*/

WITH tbl_year_rank_postcode AS (
	SELECT 
		to_char(datesold,'YYYY') as year, 
		postcode, price,
		dense_rank() OVER (
			PARTITION BY to_char(datesold,'YYYY'), postcode 
			ORDER BY price DESC
		) AS rank 
	FROM raw_sales
)

SELECT r.year, r.postcode, r.price
FROM (
	SELECT *,
		ROW_NUMBER() OVER (
			PARTITION BY year 
			ORDER BY price DESC
		) row_num
	FROM tbl_year_rank_postcode
) AS r
WHERE r.row_num BETWEEN 1 AND 6
