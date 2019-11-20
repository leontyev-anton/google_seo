#standardSQL
SELECT
   clicks, impressions, ctr, position, search_type, domain, period, query, query_type

FROM
(
   SELECT 
      clicks, impressions, ROUND(clicks/impressions,4) AS ctr, ROUND(position,2) AS position, search_type, domain, period, value1 AS query,
      CASE                               -- брендированный запрос или нет
         WHEN value1 LIKE '%elama%' OR 
              value1 LIKE '%елама%' OR
              value1 LIKE '%tkfvf%' OR
              value1 LIKE '%удфьф%' OR
              value1 LIKE '%e-lama%' OR
              value1 LIKE '%e lama%' OR
              value1 LIKE '%е лама%' OR
              value1 = 'елам' OR
              value1 = 'элама' OR
              value1 LIKE '%e.lama%' OR
              value1 LIKE '%е-лама%' OR
              value1 LIKE '%ellama%' OR
              value1 LIKE '%tlama%' THEN 'branded'      
         ELSE 'not branded'      
      END as query_type

   FROM `your-project-id.search_console_google.elama_ru_2*`
   WHERE dimension1='query' AND dimension2 IS NULL AND domain='elama.ru'
)
UNION ALL -- '(other)' - под этим ключевиком пометим все ключевики, которые отсутствуют в выгрузке
(
   SELECT
      IFNULL(clicks_all,0) - IFNULL(clicks_queries,0) AS clicks, 
      IFNULL(impressions_all,0) - IFNULL(impressions_queries,0) AS impressions, 
      ROUND( (IFNULL(clicks_all,0) - IFNULL(clicks_queries,0)) / ( IFNULL(impressions_all,0) - IFNULL(impressions_queries,0) ) ,4) AS ctr, 
      NULL AS position, 
      search_type, domain, period,  
      '(other)' AS query,
      '(other)' AS query_type
   
   FROM
   (  
      SELECT 
         period, search_type, domain,
         SUM(IF (dimension1='device', clicks, NULL)) AS clicks_all,
         SUM(IF (dimension1='device', impressions, NULL)) AS impressions_all,
         SUM(IF (dimension1='query' , clicks, NULL)) AS clicks_queries,
         SUM(IF (dimension1='query' , impressions, NULL)) AS impressions_queries
   
      FROM `your-project-id.search_console_google.elama_ru_2*`
      WHERE dimension1 IN ('query','device') AND dimension2 IS NULL AND domain='elama.ru'
      GROUP BY search_type, period, domain
   )  
   WHERE IFNULL(impressions_all,0) - IFNULL(impressions_queries,0) != 0
)
UNION ALL
(
   SELECT 
      clicks, impressions, ROUND(clicks/impressions,4) AS ctr, ROUND(position,2) AS position, search_type, domain, period, value1 AS query,
      CASE                               -- брендированный запрос или нет
         WHEN value1 LIKE '%elama%' OR 
              value1 LIKE '%елама%' OR
              value1 LIKE '%tkfvf%' OR
              value1 LIKE '%удфьф%' OR
              value1 LIKE '%e-lama%' OR
              value1 LIKE '%e lama%' OR
              value1 LIKE '%е лама%' OR
              value1 = 'елам' OR
              value1 = 'элама' OR
              value1 LIKE '%e.lama%' OR
              value1 LIKE '%е-лама%' OR
              value1 LIKE '%ellama%' OR
              value1 LIKE '%tlama%' THEN 'branded'      
         ELSE 'not branded'      
      END as query_type

   FROM `your-project-id.search_console_google.elama_com_br_2*`
   WHERE dimension1='query' AND dimension2 IS NULL AND domain='elama.com.br'
)
UNION ALL -- '(other)' - под этим ключевиком пометим все ключевики, которые отсутствуют в выгрузке
(
   SELECT
      IFNULL(clicks_all,0) - IFNULL(clicks_queries,0) AS clicks, 
      IFNULL(impressions_all,0) - IFNULL(impressions_queries,0) AS impressions, 
      ROUND( (IFNULL(clicks_all,0) - IFNULL(clicks_queries,0)) / ( IFNULL(impressions_all,0) - IFNULL(impressions_queries,0) ) ,4) AS ctr, 
      NULL AS position, 
      search_type, domain, period,  
      '(other)' AS query,
      '(other)' AS query_type
   
   FROM
   (  
      SELECT 
         period, search_type, domain,
         SUM(IF (dimension1='device', clicks, NULL)) AS clicks_all,
         SUM(IF (dimension1='device', impressions, NULL)) AS impressions_all,
         SUM(IF (dimension1='query' , clicks, NULL)) AS clicks_queries,
         SUM(IF (dimension1='query' , impressions, NULL)) AS impressions_queries
   
      FROM `your-project-id.search_console_google.elama_com_br_2*`
      WHERE dimension1 IN ('query','device') AND dimension2 IS NULL AND domain='elama.com.br'
      GROUP BY search_type, period, domain
   )  
   WHERE IFNULL(impressions_all,0) - IFNULL(impressions_queries,0) != 0
)
UNION ALL
(
   SELECT 
      clicks, impressions, ROUND(clicks/impressions,4) AS ctr, ROUND(position,2) AS position, search_type, domain, period, value1 AS query,
      CASE                               -- брендированный запрос или нет
         WHEN value1 LIKE '%elama%' OR 
              value1 LIKE '%елама%' OR
              value1 LIKE '%tkfvf%' OR
              value1 LIKE '%удфьф%' OR
              value1 LIKE '%e-lama%' OR
              value1 LIKE '%e lama%' OR
              value1 LIKE '%е лама%' OR
              value1 = 'елам' OR
              value1 = 'элама' OR
              value1 LIKE '%e.lama%' OR
              value1 LIKE '%е-лама%' OR
              value1 LIKE '%ellama%' OR
              value1 LIKE '%tlama%' THEN 'branded'      
         ELSE 'not branded'      
      END as query_type

   FROM `your-project-id.search_console_google.elama_global_2*`
   WHERE dimension1='query' AND dimension2 IS NULL AND domain='elama.global'
)
UNION ALL -- '(other)' - под этим ключевиком пометим все ключевики, которые отсутствуют в выгрузке
(
   SELECT
      IFNULL(clicks_all,0) - IFNULL(clicks_queries,0) AS clicks, 
      IFNULL(impressions_all,0) - IFNULL(impressions_queries,0) AS impressions, 
      ROUND( (IFNULL(clicks_all,0) - IFNULL(clicks_queries,0)) / ( IFNULL(impressions_all,0) - IFNULL(impressions_queries,0) ) ,4) AS ctr, 
      NULL AS position, 
      search_type, domain, period,  
      '(other)' AS query,
      '(other)' AS query_type
   
   FROM
   (  
      SELECT 
         period, search_type, domain,
         SUM(IF (dimension1='device', clicks, NULL)) AS clicks_all,
         SUM(IF (dimension1='device', impressions, NULL)) AS impressions_all,
         SUM(IF (dimension1='query' , clicks, NULL)) AS clicks_queries,
         SUM(IF (dimension1='query' , impressions, NULL)) AS impressions_queries
   
      FROM `your-project-id.search_console_google.elama_global_2*`
      WHERE dimension1 IN ('query','device') AND dimension2 IS NULL AND domain='elama.global'
      GROUP BY search_type, period, domain
   )  
   WHERE IFNULL(impressions_all,0) - IFNULL(impressions_queries,0) != 0
)
UNION ALL
(
   SELECT 
      clicks, impressions, ROUND(clicks/impressions,4) AS ctr, ROUND(position,2) AS position, search_type, domain, period, value1 AS query,
      CASE                               -- брендированный запрос или нет
         WHEN value1 LIKE '%elama%' OR 
              value1 LIKE '%елама%' OR
              value1 LIKE '%tkfvf%' OR
              value1 LIKE '%удфьф%' OR
              value1 LIKE '%e-lama%' OR
              value1 LIKE '%e lama%' OR
              value1 LIKE '%е лама%' OR
              value1 = 'елам' OR
              value1 = 'элама' OR
              value1 LIKE '%e.lama%' OR
              value1 LIKE '%е-лама%' OR
              value1 LIKE '%ellama%' OR
              value1 LIKE '%tlama%' THEN 'branded'      
         ELSE 'not branded'      
      END as query_type

   FROM `your-project-id.search_console_google.elama_kz_2*`
   WHERE dimension1='query' AND dimension2 IS NULL AND domain='elama.kz'
)
UNION ALL -- '(other)' - под этим ключевиком пометим все ключевики, которые отсутствуют в выгрузке
(
   SELECT
      IFNULL(clicks_all,0) - IFNULL(clicks_queries,0) AS clicks, 
      IFNULL(impressions_all,0) - IFNULL(impressions_queries,0) AS impressions, 
      ROUND( (IFNULL(clicks_all,0) - IFNULL(clicks_queries,0)) / ( IFNULL(impressions_all,0) - IFNULL(impressions_queries,0) ) ,4) AS ctr, 
      NULL AS position, 
      search_type, domain, period,  
      '(other)' AS query,
      '(other)' AS query_type
   
   FROM
   (  
      SELECT 
         period, search_type, domain,
         SUM(IF (dimension1='device', clicks, NULL)) AS clicks_all,
         SUM(IF (dimension1='device', impressions, NULL)) AS impressions_all,
         SUM(IF (dimension1='query' , clicks, NULL)) AS clicks_queries,
         SUM(IF (dimension1='query' , impressions, NULL)) AS impressions_queries
   
      FROM `your-project-id.search_console_google.elama_kz_2*`
      WHERE dimension1 IN ('query','device') AND dimension2 IS NULL AND domain='elama.kz'
      GROUP BY search_type, period, domain
   )  
   WHERE IFNULL(impressions_all,0) - IFNULL(impressions_queries,0) != 0
)