from airflow.sdk import dag, task
from datetime import datetime


@dag(
    dag_id="test_pipeline",
    start_date=datetime(2026, 1, 1),
    schedule=None,
    catchup=False,
)
def test_pipeline():

    @task
    def hello():
        print("Hello! Airflow task is running successfully.")

    hello()


test_pipeline()
