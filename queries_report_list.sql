#standardSQL
SELECT
   domain, search_type, query_type, query,
   SUM(clicks) AS clicksAllTime,
   SUM(IF (period='2018-05' , clicks, 0)) as c18_05, MAX(IF (period='2018-05' , position, 0)) as p18_05,
   SUM(IF (period='2018-06' , clicks, 0)) as c18_06, MAX(IF (period='2018-06' , position, 0)) as p18_06,
   SUM(IF (period='2018-07' , clicks, 0)) as c18_07, MAX(IF (period='2018-07' , position, 0)) as p18_07,
   SUM(IF (period='2018-08' , clicks, 0)) as c18_08, MAX(IF (period='2018-08' , position, 0)) as p18_08,
   SUM(IF (period='2018-09' , clicks, 0)) as c18_09, MAX(IF (period='2018-09' , position, 0)) as p18_09,
   SUM(IF (period='2018-10' , clicks, 0)) as c18_10, MAX(IF (period='2018-10' , position, 0)) as p18_10,
   SUM(IF (period='2018-11' , clicks, 0)) as c18_11, MAX(IF (period='2018-11' , position, 0)) as p18_11,
   SUM(IF (period='2018-12' , clicks, 0)) as c18_12, MAX(IF (period='2018-12' , position, 0)) as p18_12,
   SUM(IF (period='2019-01' , clicks, 0)) as c19_01, MAX(IF (period='2019-01' , position, 0)) as p19_01,
   SUM(IF (period='2019-02' , clicks, 0)) as c19_02, MAX(IF (period='2019-02' , position, 0)) as p19_02,
   SUM(IF (period='2019-03' , clicks, 0)) as c19_03, MAX(IF (period='2019-03' , position, 0)) as p19_03,
   SUM(IF (period='2019-04' , clicks, 0)) as c19_04, MAX(IF (period='2019-04' , position, 0)) as p19_04,
   SUM(IF (period='2019-05' , clicks, 0)) as c19_05, MAX(IF (period='2019-05' , position, 0)) as p19_05,
   SUM(IF (period='2019-06' , clicks, 0)) as c19_06, MAX(IF (period='2019-06' , position, 0)) as p19_06,
   SUM(IF (period='2019-07' , clicks, 0)) as c19_07, MAX(IF (period='2019-07' , position, 0)) as p19_07,
   SUM(IF (period='2019-08' , clicks, 0)) as c19_08, MAX(IF (period='2019-08' , position, 0)) as p19_08,
   SUM(IF (period='2019-09' , clicks, 0)) as c19_09, MAX(IF (period='2019-09' , position, 0)) as p19_09,
   SUM(IF (period='2019-10' , clicks, 0)) as c19_10, MAX(IF (period='2019-10' , position, 0)) as p19_10,
   SUM(IF (period='2019-11' , clicks, 0)) as c19_11, MAX(IF (period='2019-11' , position, 0)) as p19_11,
   SUM(IF (period='2019-12' , clicks, 0)) as c19_12, MAX(IF (period='2019-12' , position, 0)) as p19_12,
   SUM(IF (period='2020-01' , clicks, 0)) as c20_01, MAX(IF (period='2020-01' , position, 0)) as p20_01,
   SUM(IF (period='2020-02' , clicks, 0)) as c20_02, MAX(IF (period='2020-02' , position, 0)) as p20_02,
   SUM(IF (period='2020-03' , clicks, 0)) as c20_03, MAX(IF (period='2020-03' , position, 0)) as p20_03,
   SUM(IF (period='2020-04' , clicks, 0)) as c20_04, MAX(IF (period='2020-04' , position, 0)) as p20_04

FROM
(
   SELECT clicks, search_type, domain, period, query, query_type, ROUND(position,1) AS position
   FROM `your-project-id.search_console_google.queries`
   WHERE domain IN ('elama.ru','elama.com.br','elama.global','elama.kz')
)
GROUP BY domain, search_type, query_type, query
HAVING clicksAllTime>=10
ORDER BY domain DESC, search_type DESC, query_type DESC, clicksAllTime DESC