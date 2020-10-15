# Rate Limiting

The QuickBooks Commerce API provides a rate limit of 300 requests per 300 seconds.

```
curl -IXGET https://api.tradegecko.com/products?page=1 -H "Content-type: application/json" -H "Authorization: Bearer <ACCESS_TOKEN>" | grep X-Rate-Limit  
X-Rate-Limit-Limit: 300
X-Rate-Limit-Remaining: 291
X-Rate-Limit-Reset: 1509339000  
```

Your current rate limit quota is provided in the response headers of every request.

| Header                     | Description
| -------------------------- | ------------- 
| **X-Rate-Limit-Limit**     | Number of requests available for this application (always 300)       .
| **X-Rate-Limit-Remaining** | Number of requests remaining in quota
| **X-Rate-Limit-Reset**     | The timestamp (as seconds since epoch) when the quota will reset.

If you go over this limit the API will return a response with a status code of 429 until the reset time.

<aside class="notice">  
 The API limit is tracked against the combination of application and account, so if your application is serving multiple accounts each account will have it's own quota.
</aside>
