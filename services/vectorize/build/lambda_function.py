import os
import psycopg2

def lambda_handler(event, context):
    try:
        conn = psycopg2.connect(
            host=os.environ['AURORA_ENDPOINT'],
            port=os.environ['AURORA_PORT'],
            user=os.environ['AURORA_USER'],
            password=os.environ['AURORA_PASSWORD'],
            dbname=os.environ['AURORA_DB_NAME']
        )
        cur = conn.cursor()
        cur.execute("SELECT 'Hello, Aurora!'")
        result = cur.fetchone()
        cur.close()
        conn.close()
        return {
            'statusCode': 200,
            'body': result[0]
        }
    except Exception as e:
        return {
            'statusCode': 500,
            'body': str(e)
        }
