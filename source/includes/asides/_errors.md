# Errors

The QuickBooks Commerce API uses the following error codes:

Error Code | Meaning
---------- | -------
400 | Bad Request -- You have passed a malformed request
401 | Unauthorized -- Your API access token is invalid
402 | Payment Required -- Your subscription has lapsed
403 | Forbidden -- The resource requested is not available with your permissions
404 | Not Found -- The specified resource could not be found
414 | Request URI too long -- You have applied too many filters on a GET request
422 | Unprocessable Entity -- Your request is invalid
429 | Too Many Requests -- You are allowed [300 requests per 300 seconds](#rate-limiting "Rate Limiting")
500 | Internal Server Error -- We had a problem with our server. Try again later
503 | Service Unavailable (Time out) -- The server was unable to finish the request in time, either the server was overloaded or if fetching large pages of data, please try using a smaller page size
