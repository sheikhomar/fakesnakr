import sys

def handler(event, context):
    params = {}
    if "queryStringParameters" in event:
        params = event["queryStringParameters"]
    elif "body" in event:
        params = event["body"]

    if len(params) == 0:
        return {
            "status": "failed",
            "message": "No parameters found"
        }

    return {
        "status": "success",
        "message": "Parameters found",
        "params": params
    }
