# Response Metadata
Every response returned from the QuickBooks Commerce API returns some useful pieces of information in the response headers.

## Request IDs
Every response will include an `X-Request-ID` parameter unique to that specific request.
If you need to contact us about a specific request, please make sure to include the specific request ID in any communication with us to help speed up investigations.

## Pagination Links

```
curl -IXGET https://api.tradegecko.com/products?page=1 -H "Content-type: application/json" -H "Authorization: Bearer <PRIVILEGED_ACCESS_TOKEN>" | grep X-Pagination  
X-Pagination: {"total_records":3103,"total_pages":32,"first_page":true,"last_page":false,"out_of_bounds":false,"offset":0}
```

Every response that returns a collection will include pagination data in the headers.
This data can be found as JSON under the `X-Pagination` header.

- `total_records`: The total number of records matching the filters (excludes `page` & `limit` params).
- `total_pages`: The total number of pages of records matching the filters.
- `first_page`: true/false based on whether this is the first page of results.
- `last_page`: true/false based on whether this is the last page of results.
- `out_of_bounds`: true/false based on whether the pagination request is out of bounds.
- `offset`: The offset from 0 for the start of this page

<aside class='notice'>
A small handful of endpoints include a `meta` key in the JSON, 
this is for historical reasons and should not be relied on, please use the pagination headers instead.
</aside>
