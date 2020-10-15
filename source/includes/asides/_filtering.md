# Filtering Collections

The QuickBooks Commerce API allows filtering of records by passing along query parameters.  
These are some of the filters currently allowed by the API (where relevant).

```shell
curl -X GET -H "Content-type: application/json" -H "Authorization: Bearer <ACCESS_TOKEN>"
https://api.tradegecko.com/products?created_at_min=2015-11-04/
```

```ruby
require 'gecko-ruby'
gecko = Gecko::Client.new(<OAUTH_ID>, <OAUTH_SECRET>)
access_token = OAuth2::AccessToken.new(gecko.oauth_client, <ACCESS_TOKEN>)
gecko.access_token = access_token

gecko.Product.where(created_at_min: "2015-11-04")
```

###  Index Filters

| Arguments          | Description
|--------------------|--------------------
| **ids**            | An array of object IDs, see [Batching Requests](#batching-requests)
| **created_at_min** | Return objects only created since
| **created_at_max** | Return objects only created before
| **updated_at_min** | Return objects only updated since
| **updated_at_max** | Return objects only updated before
| **order**          | The order to return the collection i.e "?order=created_at desc"
| **limit**          | See [Pagination](#pagination) (default is 50)
| **page**           | See [Pagination](#pagination)

In addition, each record type has their own specific filters; 
these filters are covered in their respective sections.

### Batching Requests
Requests can be batched together to get records with different IDs in a single API call.  
`GET https://api.tradegecko.com/products?ids[]=1&ids[]=2`

Batching can also be done to return the results of multiple possible values.  
For example, a single API call can return products with multiple brands:  
`GET https://api.tradegecko.com/products?brand[]=ABC&brand[]=XYZ`

Or statuses:  
`GET https://api.tradegecko.com/orders?status[]=draft&status[]=active`

### Comma-separated support for Integer filters
For ID based filters, optionally a comma-separated collection can be used instead for brevity.  
`GET https://api.tradegecko.com/products?ids=1,2`, or  
`GET https://api.tradegecko.com/variants?product_id=1,2`

### Combining Multiple Filters in a Single call
You can combine filters in a single API call to return tighter subsets of results.  
`GET https://api.tradegecko.com/companies?company_status=active&company_type=supplier&order=created_at+desc&page=2&limit=20`
