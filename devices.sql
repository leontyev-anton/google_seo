#standardSQL
SELECT
   period, domain, search_type, device, clicks, impressions

FROM
(
   SELECT clicks, impressions, search_type, domain, period, value1 AS device
   
   FROM
   (
      SELECT clicks, impressions, search_type, domain, period, value1
      FROM `your-project-id.search_console_google.elama_ru_2*`
      WHERE dimension1='device' AND dimension2 IS NULL AND domain='elama.ru'
   )
   UNION ALL
   (
      SELECT clicks, impressions, search_type, domain, period, value1
      FROM `your-project-id.search_console_google.elama_com_br_2*`
      WHERE dimension1='device' AND dimension2 IS NULL AND domain='elama.com.br'
   )
   UNION ALL
   (
      SELECT clicks, impressions, search_type, domain, period, value1
      FROM `your-project-id.search_console_google.elama_global_2*`
      WHERE dimension1='device' AND dimension2 IS NULL AND domain='elama.global'
   )
   UNION ALL
   (
      SELECT clicks, impressions, search_type, domain, period, value1
      FROM `your-project-id.search_console_google.elama_kz_2*`
      WHERE dimension1='device' AND dimension2 IS NULL AND domain='elama.kz'
   )
)
ORDER BY period, domain, search_type, device