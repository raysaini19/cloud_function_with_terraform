def helloGET(event, context):
    file_data = event

    # Extract relevant information from the event
    bucket_name = file_data['bucket']
    file_name = file_data['name']
    file_size = file_data['size']

    # Perform desired operations on the uploaded file
    # For example, you can process the file, store metadata, or trigger other actions

    print(f"File uploaded: {file_name} in bucket: {bucket_name}")
    print(f"File size: {file_size} bytes")
    print('Bucket:', event['bucket'])
    print('Created:',  event['timeCreated'])

    # Add your custom logic here

    # Return a response (optional)
    return "File processing completed"
    

# def hello_gcs(event, context):
#     """Background Cloud Function to be triggered by Cloud Storage.
#        This generic function logs relevant data when a file is changed.
#     Args:
#         event (dict):  The dictionary with data specific to this type of event.
#                        The `data` field contains a description of the event in
#                        the Cloud Storage `object` format described here:
#                        https://cloud.google.com/storage/docs/json_api/v1/objects#resource
#         context (google.cloud.functions.Context): Metadata of triggering event.
#     Returns:
#         None; the output is written to Stackdriver Logging
#     """
#     print('Event ID:' , context.event_id)
#     print('Event type:', context.event_type)
#     print('Bucket:', event['bucket'])
#     print('File:',  event['name'])
#     print('Metageneration:',  event['metageneration'])
#     print('Created:',  event['timeCreated'])
#     print('Updated:',  event['updated'])