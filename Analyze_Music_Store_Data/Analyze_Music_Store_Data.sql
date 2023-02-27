/***** SQL: Set 1 *****/
/* 質問１: 請求が最も多い都市はどれか?*/

SELECT BillingCity, Count(BillingCity) AS InvoiceCount
FROM Invoice 
GROUP BY BillingCity
ORDER BY InvoiceCount DESC;

/* 質問２: 最も収益が多いの国はどれか？ 
最も多くの収益を上げた国でプロモーション用の広告を打ちたいと仮定します。
請求の合計額が最も多い1つの国を返すクエリを作成します。
国名と請求の合計を返します.*/

SELECT BillingCountry, SUM(total) AS InvoiceTotal 
FROM Invoice
GROUP BY BillingCountry
ORDER BY InvoiceTotal DESC
LIMIT 1;

/* 質問３: 最高の顧客は誰か?
最も多くのお金を使った顧客が最高の顧客とします。
最も多くのお金を使った人を返すクエリを作成します。
Invoice、Customer テーブルから取得します*/

SELECT c.CustomerId, CONCAT(c.FirstName , ' ', c.LastName) AS FullName, SUM(i.Total) AS TotalSpending
FROM Customer AS c
JOIN Invoice AS i ON c.CustomerId = i.CustomerId
GROUP BY c.CustomerId
ORDER BY TotalSpending DESC
LIMIT 1;


/***** SQL: Set 2 *****/
/* 質問１:
クエリを使用してすべてのHIPHOP リスナーのID、メールアドレス、ファーストネーム、ラストネームを返します。
電子メール アドレスはアルファベット順に並べられたリストで返します.*/

SELECT DISTINCT c.CustomerId, c.Email, c.FirstName, c.LastName
FROM Customer AS c
JOIN Invoice AS i ON c.CustomerId = i.CustomerId
JOIN InvoiceLine as il ON i.InvoiceId = il.InvoiceId
WHERE il.TrackId IN (
	SELECT TrackId
	FROM Track AS t
	JOIN Genre AS g ON t.GenreId = g.GenreId
	WHERE g.Name LIKE '%Hip Hop%'
) 
ORDER BY email;

/* 質問２: Jazzの曲を多く出しているのは誰か？
Jazzコンサートに招待するミュージシャンを決めます。
最も多くのJazz曲を出しているアーティストを招待します。
トップ10のJazzのアーティスト名とトラック数を返すクエリを作成します。*/

SELECT ar.ArtistId, ar.Name, COUNT(ar.ArtistId) AS TotalTracks
FROM Track AS t
JOIN Album AS al ON t.AlbumId = al.AlbumId
JOIN Artist AS ar ON ar.ArtistId = al.ArtistId
WHERE t.TrackId IN(
	SELECT TrackId
	FROM Track AS t
	JOIN Genre AS g ON t.GenreId = g.GenreId
	WHERE g.Name LIKE '%Jazz%'
)
GROUP BY ar.ArtistId
ORDER BY TotalTracks DESC
LIMIT 10;

/* 質問3:
曲の長さが平均値より長いトラック名をすべて返します。
新しいデータがデータベースに入ったときにクエリが更新されるようにしたい、と想定。
そのためクエリに平均値をハードコードはせずクエリで平均値を出します。
曲の長さ順に並べ、トラックの名前とミリ秒を返します。*/

SELECT TrackId, Name, Milliseconds
FROM Track
WHERE Milliseconds > (
	SELECT AVG(Milliseconds)
	FROM Track
)
ORDER BY Milliseconds DESC;

/* 質問4:
どのアーティストが最も稼いでいるのか探します。次に、どの顧客がそのアーティストに最もお金を使ったかを調べます。
Invoice、InvoiceLine、Track、Customer、Album、Artistテーブルを使用します。
InvoiceテーブルのTotalが1つの商品に対してでない可能性があるため
InvoiceLineテーブルを使用して各製品がいくつ購入されたかを確認し単価を掛け合わせ
最も稼いでいるアーティスト、最もお金を使った顧客で絞り込みます。*/

WITH BestSalesArtist AS (
	SELECT ar.ArtistId, ar.Name, SUM(il.UnitPrice * il.Quantity) AS TotalSales
	FROM InvoiceLine AS il
	JOIN Track AS t ON il.TrackId = t.TrackId
	JOIN Album AS al ON t.AlbumId = al.AlbumId
	JOIN Artist AS ar ON al.ArtistId = ar.ArtistId
	GROUP BY 1
	ORDER BY 3 DESC
	LIMIT 1
)

SELECT b.Name AS BestSalesArtistName, SUM(il.UnitPrice * il.Quantity) AS TotalSpent, c.CustomerId, c.FirstName, c.LastName
FROM Customer AS c
JOIN Invoice AS i ON c.CustomerId = i.CustomerId
JOIN InvoiceLine AS il ON i.InvoiceId = il.InvoiceId
JOIN Track AS t ON t.TrackId = il.TrackId
JOIN Album AS al ON al.AlbumId = t.AlbumId
JOIN BestSalesArtist AS b ON b.ArtistId = al.ArtistId
GROUP BY 1,3
ORDER BY 2 DESC;








