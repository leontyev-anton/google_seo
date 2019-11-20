#standardSQL
SELECT
   period,
   domain,
   search_type,
   query_type,
   SUM(clicks) AS clicks,
   SUM(impressions) AS impressions

FROM `your-project-id.search_console_google.queries`
WHERE domain IN ('elama.ru','elama.com.br','elama.global','elama.kz')
GROUP BY period, domain, search_type, query_type
ORDER BY period, domain, search_type, query_type