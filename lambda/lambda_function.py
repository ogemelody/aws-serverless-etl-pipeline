# lambda_function.py
import json

def lambda_handler(event, context):
    print("Received event:", json.dumps(event))
    for record in event.get("Records", []):
        s3_bucket = record["s3"]["bucket"]["name"]
        s3_key = record["s3"]["object"]["key"]
        print(f"New file uploaded: Bucket={s3_bucket}, Key={s3_key}")
    return {"statusCode": 200, "body": "Processed event successfully"}
