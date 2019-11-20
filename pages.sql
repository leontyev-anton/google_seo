#standardSQL
SELECT
   domain, search_type, page,
   SUM(clicks) AS clicksAllTime,
   SUM(IF (period='2018-05' , clicks, 0)) as c18_05,
   SUM(IF (period='2018-06' , clicks, 0)) as c18_06,
   SUM(IF (period='2018-07' , clicks, 0)) as c18_07,
   SUM(IF (period='2018-08' , clicks, 0)) as c18_08,
   SUM(IF (period='2018-09' , clicks, 0)) as c18_09,
   SUM(IF (period='2018-10' , clicks, 0)) as c18_10,
   SUM(IF (period='2018-11' , clicks, 0)) as c18_11,
   SUM(IF (period='2018-12' , clicks, 0)) as c18_12,
   SUM(IF (period='2019-01' , clicks, 0)) as c19_01,
   SUM(IF (period='2019-02' , clicks, 0)) as c19_02,
   SUM(IF (period='2019-03' , clicks, 0)) as c19_03,
   SUM(IF (period='2019-04' , clicks, 0)) as c19_04,
   SUM(IF (period='2019-05' , clicks, 0)) as c19_05,
   SUM(IF (period='2019-06' , clicks, 0)) as c19_06,
   SUM(IF (period='2019-07' , clicks, 0)) as c19_07,
   SUM(IF (period='2019-08' , clicks, 0)) as c19_08,
   SUM(IF (period='2019-09' , clicks, 0)) as c19_09,
   SUM(IF (period='2019-10' , clicks, 0)) as c19_10,
   SUM(IF (period='2019-11' , clicks, 0)) as c19_11,
   SUM(IF (period='2019-12' , clicks, 0)) as c19_12,
   SUM(IF (period='2020-01' , clicks, 0)) as c20_01,
   SUM(IF (period='2020-02' , clicks, 0)) as c20_02,
   SUM(IF (period='2020-03' , clicks, 0)) as c20_03,
   SUM(IF (period='2020-04' , clicks, 0)) as c20_04

FROM
(
   SELECT clicks, impressions, search_type, domain, period, value1 AS page
   
   FROM
   (
      SELECT clicks, impressions, search_type, domain, period, value1
      FROM `your-project-id.search_console_google.elama_ru_2*`
      WHERE dimension1='page' AND dimension2 IS NULL AND domain='elama.ru' AND clicks>0
   )
   UNION ALL
   (
      SELECT clicks, impressions, search_type, domain, period, value1
      FROM `your-project-id.search_console_google.elama_com_br_2*`
      WHERE dimension1='page' AND dimension2 IS NULL AND domain='elama.com.br' AND clicks>0
   )
   UNION ALL
   (
      SELECT clicks, impressions, search_type, domain, period, value1
      FROM `your-project-id.search_console_google.elama_global_2*`
      WHERE dimension1='page' AND dimension2 IS NULL AND domain='elama.global' AND clicks>0
   )
   UNION ALL
   (
      SELECT clicks, impressions, search_type, domain, period, value1
      FROM `your-project-id.search_console_google.elama_kz_2*`
      WHERE dimension1='page' AND dimension2 IS NULL AND domain='elama.kz' AND clicks>0
   )
)
GROUP BY domain, search_type, page
HAVING clicksAllTime >= 10
ORDER BY domain DESC, search_type DESC, clicksAllTime DESC