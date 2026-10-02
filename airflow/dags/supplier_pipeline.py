
from airflow.sdk import dag, task
from datetime import datetime
import os
import subprocess
import requests
import time
import glob


@dag(
    dag_id="supplier_shipment_pipeline",
    start_date=datetime(2026, 1, 1),
    schedule=None,
    catchup=False,
    tags=["supplier", "airbyte"],
)
def supplier_shipment_pipeline():

    @task
    def generate_shipments():
        result = subprocess.run(
            [
                "python",
                "/opt/airflow/simulation/generate_supplier_shipments.py",
            ],
            capture_output=True,
            text=True,
        )

        print("Generator output:")
        print(result.stdout)

        if result.returncode != 0:
            print("Generator error:")
            print(result.stderr)
            raise Exception(
                f"Supplier shipment generator failed with exit code "
                f"{result.returncode}"
            )

        # Confirm that the CSV was created in the shared project folder
        csv_files = glob.glob("/opt/airflow/data/incoming/shipments_*.csv")

        if not csv_files:
            raise Exception(
                "Generator succeeded, but no shipment CSV was found "
                "in /opt/airflow/data/incoming/"
            )

        latest_csv = max(csv_files, key=os.path.getmtime)

        print(f"CSV created successfully: {latest_csv}")

    @task
    def sync_with_airbyte():
        airbyte_url = os.environ["AIRBYTE_URL"]
        connection_id = os.environ["SUPPLIER_AIRBYTE_CONNECTION_ID"]
        client_id = os.environ["AIRBYTE_CLIENT_ID"]
        client_secret = os.environ["AIRBYTE_CLIENT_SECRET"]

        # Get Airbyte access token
        token_response = requests.post(
            f"{airbyte_url}/api/public/v1/applications/token",
            json={
                "client_id": client_id,
                "client_secret": client_secret,
                "grant-type": "client_credentials",
            },
            timeout=30,
        )

        token_response.raise_for_status()
        token = token_response.json()["access_token"]

        # Start Airbyte sync
        response = requests.post(
            f"{airbyte_url}/api/public/v1/jobs",
            headers={"Authorization": f"Bearer {token}"},
            json={
                "jobType": "sync",
                "connectionId": connection_id,
            },
            timeout=30,
        )

        response.raise_for_status()

        job_id = response.json()["jobId"]

        print(f"Supplier Airbyte sync started. Job ID: {job_id}")

        # Wait for Airbyte to finish
        while True:
            time.sleep(15)

            # Get a fresh Airbyte access token
            token_response = requests.post(
                f"{airbyte_url}/api/public/v1/applications/token",
                json={
                    "client_id": client_id,
                    "client_secret": client_secret,
                    "grant-type": "client_credentials",
                },
                timeout=30,
            )

            token_response.raise_for_status()
            token = token_response.json()["access_token"]

            # Check Airbyte job status
            status_response = requests.get(
                f"{airbyte_url}/api/public/v1/jobs/{job_id}",
                headers={"Authorization": f"Bearer {token}"},
                timeout=30,
            )

            status_response.raise_for_status()

            job = status_response.json()
            status = job["status"]

            print(f"Airbyte job {job_id} status: {status}")

            if status == "succeeded":
                print("Supplier Airbyte sync completed successfully.")
                return

            if status in ["failed", "cancelled", "incomplete"]:
                raise Exception(
                    f"Airbyte sync failed. "
                    f"Job {job_id} status: {status}"
                )


    generate_shipments() >> sync_with_airbyte()


supplier_shipment_pipeline()

