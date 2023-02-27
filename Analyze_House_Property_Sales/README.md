# 住宅不動産販売 - データ分析
不動産の価格をより適切に見積もるために、このプロジェクトではオーストラリアのある都市における住宅用不動産の販売分析に取り組みます。

+ 販売数が最も多い日付
+ 販売あたりの平均価格が最も高い郵便番号
+ 販売件数が最も少ない年
+ その他

## データベースと利用したツール
+ [PostgreSQL](https://www.postgresql.org/)
+ [pgAdmin](https://www.pgadmin.org/)

## 利用したデータ
[Kaggleの【The House Property Sale】データセット](https://www.kaggle.com/datasets/htagholdings/property-sales)


# テーブルの説明

## raw_sales テーブル

| Column           | Type     | Description                                |
| ---------------- | -------  | ------------------------------------------ |
| datesold         | timestamp| 所有者が買い手に家を売った日付                  |
| postcode         | char     | オーナーが売却した4桁の郵便番号                 |
| price            | integer  | 売却した価格                                 |
| propertyType     | varchar  | プロパティのタイプ、つまり家またはユニット        |
| bedrooms         | integer  | ベッドルームの数　                            |

### 詳細

2007年から2019年までの住宅販売データの記録

<br>