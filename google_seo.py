# -*- coding: utf-8 -*-

# документация и пример кода: https://developers.google.com/webmaster-tools/search-console-api-original/v3/how-tos/search_analytics

# ['page'] и ['query','page']  сумма кликов и сумма показов больше, чем, например, [device], тк за один результат поиска в google может выдаваться несколько страниц одного сайта, и все они суммируются
# ['query','device'] и ['query','country'] сумма кликов совпадает с ['query'], но сумма показов может быть больше тк по части запросов в выгрузке становится больше показов + добавляются новые запросы с показами (по ['query'] выгружается не полностью все данные).

# для работы скрипта нужно установить следующие библиотеки:
# pip install --upgrade google-api-python-client
# pip install pandas
# pip install pandas_gbq
# pip install --upgrade oauth2client 

import json
import sys
from googleapiclient import sample_tools
from google.oauth2 import service_account
import pandas
import pandas_gbq
import urllib.parse
from datetime import datetime
from dateutil.relativedelta import relativedelta
import os

def main(argv):
    gcloud_key = 'C:\\Dropbox\\gsc\\google_credentials.json' # замените на свой - путь к JSON-ключу от сервисного аккаунта Google Cloud
    gbq_project_id = 'your-project-id' # замените на свой - идентификатор проекта BigQuery
    gbq_dataset = 'search_console_google' # замените на свой - название dataset'a в BigQuery
    domains = ['elama.ru','elama.global','elama.kz','elama.com.br'] # замените на свои - домены-ресурсы, подтвержденные в Google консоли для вебмастеров
    first_month = current_month = datetime(2019, 8, 1) # с какого по какой месяц выгружаем данные
    last_month = datetime(2019, 8, 1)
    search_types = ['web','image','video']
    dimensions = [['device'],['country'],['searchAppearance'],['page'],['query'],['query','device'],['query','country'],['query','page']]
    row_limit = 25000  #current max response size 25000
    months = []

    service, flags = sample_tools.init(argv,'webmasters', 'v3', __doc__, __file__ , parents=[], scope='https://www.googleapis.com/auth/webmasters.readonly')
    credentials = service_account.Credentials.from_service_account_file(gcloud_key)

    while current_month <= last_month:
        start_date = current_month.strftime("%Y-%m-%d")
        end_date = (current_month + relativedelta(months=1) - relativedelta(days=1)).strftime("%Y-%m-%d")
        months.append({'start_date': start_date, 'end_date': end_date})
        current_month += relativedelta(months=1)

    file = open(os.path.dirname(sys.argv[0]) + '/google_seo_log.txt', 'w')
    write_log (file, datetime.strftime(datetime.now(), '%Y-%m-%d %H:%M:%S\n'))

    for domain in domains:

        for month in months:

            df_domain = pandas.DataFrame()
            write_log(file, f'\n{domain:<18}')
            write_log(file, month['start_date'][0:7] + '\n')

            for search_type in search_types:

                df_search_type = pandas.DataFrame()
                for dimension in dimensions:
                
                    df_dimension = pandas.DataFrame()
                    dimension_str=str(dimension).replace('[','').replace(']','').replace('\'','').replace(',','')
                    start_row = 0
                    condition = True
    
                    while condition:
                        request = { 'startDate': month['start_date'], 'endDate': month['end_date'], 'dimensions': dimension, 'searchType': search_type, 'rowLimit': row_limit, 'startRow': start_row }
                        response = service.searchanalytics().query(siteUrl='sc-domain:'+domain, body=request).execute()

                        try:
                            df = pandas.DataFrame.from_dict(response['rows'])
                            start_row = start_row + row_limit
    
                        except:
                            condition = False
    
                        else:
                            df['search_type'] = search_type
                            df['domain'] = domain
                            df['period'] = month['start_date'][0:7]
                            df['dimension1'] = dimension[0]
                            df['dimension2'] = dimension[1] if len(dimension) == 2 else None
                            df['clicks'] = df['clicks'].astype(int)
                            df['impressions'] = df['impressions'].astype(int)  
                            if len(dimension) == 1:
                                df['value1'] = df['keys'].apply(lambda row: row[0]) if dimension[0] != 'page' else df['keys'].apply(lambda row: urllib.parse.unquote(row[0]))
                                df['value2'] = None
                            else:
                                df['value1'] = df['keys'].apply(lambda row: row[0]) if dimension[0] != 'page' else df['keys'].apply(lambda row: urllib.parse.unquote(row[0]))
                                df['value2'] = df['keys'].apply(lambda row: row[1]) if dimension[1] != 'page' else df['keys'].apply(lambda row: urllib.parse.unquote(row[1]))
                            df = df.drop(columns=['keys'])
    
                            df_dimension = df_dimension.append(df, ignore_index=True)

                    if len(df_dimension) > 0:
                        clicks_over_0 = 0
                        for clicks in df_dimension['clicks']:
                            if clicks > 0: 
                                clicks_over_0 += 1 
                    
                        write_log(file, f'   search_type: {search_type:<7}')
                        write_log(file, f'dimension1: {dimension[0]:<18}')
                        write_log(file, f'dimension2: {str(dimension[1] if len(dimension) == 2 else None):<9}')
                        write_log(file, f'all values: {str(len(df_dimension)):<8}')
                        write_log(file, f'values with clicks: {str(clicks_over_0):<7}')
                        write_log(file, f'clicks sum: {int(sum(df_dimension["clicks"])):<8}') 
                        write_log(file, f'impressions sum: {int(sum(df_dimension["impressions"]))}\n')
                                    
                    else:
                        write_log(file, f'   search_type: {search_type:<7}')
                        write_log(file, f'dimension1: {dimension[0]:<18}')
                        write_log(file, f'dimension2: {str(dimension[1] if len(dimension) == 2 else None):<9}')
                        write_log(file, f'all values: {len(df_dimension)}\n')

                    df_search_type = df_search_type.append(df_dimension, ignore_index=True)
                    
                df_domain = df_domain.append(df_search_type, ignore_index=True) 


            if len(df_domain) > 0:
                table_name = domain.replace('.','_') + '_' + month['start_date'].replace('-','')
                try:
                    pandas_gbq.to_gbq(df_domain, gbq_dataset+'.'+table_name, project_id=gbq_project_id, if_exists='replace')
                    write_log(file, f'\n   Table in BigQuery: \'{gbq_project_id}:{gbq_dataset}.{table_name}\' success created. Number of rows: {len(df_domain)}\n\n')
                except:
                    write_log(file, f'\n   ERROR: Can\'t write table \'{gbq_project_id}:{gbq_dataset}.{table_name}\' in BigQuery\n\n')
            else:
                write_log(file, f'   Table in BigQuery don\'t created, because rows: {len(df_domain)}\n\n')
    file.close()


def write_log (file, str):
    print(str, end='')
    file.write(str)


if __name__ == '__main__':
    main(sys.argv)