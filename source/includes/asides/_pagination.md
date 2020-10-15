# Pagination

```shell
curl -X GET -H "Content-type: application/json" -H "Authorization: Bearer <ACCESS_TOKEN>"
https://api.tradegecko.com/users?limit=5&page=2
```

```ruby
require 'gecko-ruby'
gecko = Gecko::Client.new(<OAUTH_ID>, <OAUTH_SECRET>)
access_token = OAuth2::AccessToken.new(gecko.oauth_client, <ACCESS_TOKEN>)
gecko.access_token = access_token
gecko.User.where(limit: 5, page: 2)
```
 
The QuickBooks Commerce API enables pagination via `limit`
and `page` query parameters on GET requests to index pages. 

The default page size is 50 items, with the maximum page size being 250.
