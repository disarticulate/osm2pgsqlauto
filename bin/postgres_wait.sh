#!/usr/local/bin/python3
import os
import time
import psycopg2

connection = "host='{POSTGRES_DB_HOST}' dbname='{POSTGRES_DB}' user='{POSTGRES_USER}' password='{POSTGRES_PASSWORD}'"
connection = connection.format(**os.environ)

while True:
	try:
	    conn = psycopg2.connect(connection)
	    conn.close()
	    break
	except psycopg2.OperationalError as ex:
	    print(f"Postgres at not available at {connection} failed: {ex}")
	    time.sleep(5)