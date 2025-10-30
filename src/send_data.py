import boto3
import json
import random
import time
from datetime import datetime

# Initialize Kinesis client
kinesis = boto3.client('kinesis', region_name='eu-central-1')

def generate_record():
    return {
        "device_id": f"sensor_{random.randint(1,5)}",
        "temperature": round(random.uniform(20.0, 30.0), 2),
        "timestamp": datetime.utcnow().isoformat()
    }

while True:
    record = generate_record()
    print(f"Sending: {record}")

    kinesis.put_record(
        StreamName='device-stream',
        Data=json.dumps(record),
        PartitionKey=record["device_id"]
    )

    time.sleep(2)
