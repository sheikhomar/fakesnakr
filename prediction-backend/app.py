import sys

def handler(event, context):
    if event['httpMethod'] == 'GET':
        return {
            'statusCode': 200,
            'body': 'We received a GET request.'
        }
    return event
