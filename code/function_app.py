from azure.identity import DefaultAzureCredential
from azure.mgmt.resource import SubscriptionClient
import azure.mgmt.resourcegraph as arg
import json

import azure.functions as func

# Authenticate
credential = DefaultAzureCredential()

def resource_graph_query( query ):
    # Get your credentials from Azure CLI (development only!) and get your subscription list
    subs_client = SubscriptionClient(credential)
    subscriptions_dict = []
    
    for subscription in subs_client.subscriptions.list():
        subscriptions_dict.append(subscription.as_dict())
    
    subscription_ids_dict = []
    
    for subscription in subscriptions_dict:
        subscription_ids_dict.append(subscription.get('subscription_id'))

    # Create Azure Resource Graph client and set options
    resource_graph_client = arg.ResourceGraphClient(credential)
    resource_graph_query_options = arg.models.QueryRequestOptions(result_format="objectArray")

    # Create query
    resource_graph_query = arg.models.QueryRequest(subscriptions=subscription_ids_dict, query=query, options=resource_graph_query_options)

    # Run query
    resource_graph_query_results = resource_graph_client.resources(resource_graph_query)

    # Show Python object
    return resource_graph_query_results

def check_name_availability(resource_name, resource_type=None):
    
    if(resource_type):
        rg_query = f"Resources | where name =~ '{resource_name}' | where type =~ '{resource_type}'"
    else:
        rg_query = f"Resources | where name =~ '{resource_name}'"
    
    
    rg_results = resource_graph_query(rg_query)
    
    results_dict = []

    if(rg_results.data):
        availability = False
    else:
        availability = True

    results_dict = dict({
        'resource_name': resource_name,
        'available': availability
    })
    
    return results_dict

app = func.FunctionApp()

@app.function_name(name="CheckNameAvailability")
@app.route(route="checkNameAvailability") # HTTP Trigger
def main(req: func.HttpRequest) -> func.HttpResponse:
    r_name = req.params.get('resourceName')
    r_type = req.params.get('resourceType')
    if not r_name:
        try:
            req_body = req.get_json()
        except ValueError:
            pass
        else:
            r_name = req_body.get('resourceName')
    
    if not r_type:
        try:
            req_body = req.get_json()
        except ValueError:
            pass
        else:
            r_type = req_body.get('resourceType')

    if r_name and r_type:
        result = check_name_availability(resource_name=r_name, resource_type=r_type)
        result_as_json = json.dumps(result)
        return func.HttpResponse(result_as_json)
    elif r_name:
        result = check_name_availability(resource_name=r_name)
        result_as_json = json.dumps(result)
        return func.HttpResponse(result_as_json)
    else:
        return func.HttpResponse(
            "This HTTP triggered function executed successfully. Pass a resourceName in the query string or in the request body for a proper response.",
            status_code=200
        ) 