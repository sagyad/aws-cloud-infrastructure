import json
import boto3
import os
import uuid

dynamodb = boto3.resource("dynamodb")
table = dynamodb.Table(os.environ["TABLE_NAME"])

def handler(event, context):
    method = event.get("requestContext", {}).get("http", {}).get("method")

    if method == "GET":
        result = table.scan()
        return {"statusCode": 200, "body": json.dumps(result["Items"])}

    elif method == "POST":
        body = json.loads(event.get("body", "{}"))
        item = {"id": str(uuid.uuid4()), "name": body.get("name", "unknown")}
        table.put_item(Item=item)
        return {"statusCode": 201, "body": json.dumps(item)}

    return {"statusCode": 400, "body": json.dumps({"error": "Bad request"})}
