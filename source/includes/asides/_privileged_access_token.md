## Resource Owner Password Credentials flow

The QuickBooks Commerce API also supports the Resource Owner Password Credentials flow
through the concept of Privileged Access Tokens.

These tokens are generated through the QuickBooks Commerce UI and do not expire.
This means that you can access the API using the privileged token without the need
to use browser redirects or manage refresh tokens.

However you will need to manually manage key rotation yourselves if your privileged
key gets compromised in any way.

Because of the inherent higher safety risks involved in storing privileged access tokens,
the Resource Owner Password Credentials flow is only available on single-account Applications.

> Once you have obtained your Privileged Access Token, you can use cURL or Ruby to check if it is working.

```shell
curl -X GET -H "Content-type: application/json" -H "Authorization: Bearer <PRIVILEGED_ACCESS_TOKEN>"
https://api.tradegecko.com/accounts/current
```

```ruby
require 'gecko-ruby'
gecko = Gecko::Client.new(<OAUTH_ID>, <OAUTH_SECRET>)
gecko.authorize_from_existing(<PRIVILEGED_ACCESS_TOKEN>, nil, nil)
gecko.Account.current
```

### Phase 1: Privileged Access Token Generation

As the application developer, after [registering your application](#registering-for-an-access-token),
you will see a button to "Create a Privileged Token" for the application.

<div class="screenshot">
  <img src="images/token-screenshot.png">
</div>

If you have already registered your application, you can add a privileged token by
finding your application in your [QuickBooks Commerce App List](https://go.tradegecko.com/oauth/applications).

<aside class="notice">
Important: The Privileged Access Tokens provide unfettered access to your QuickBooks Commerce
account, be very careful to store them securely.
</aside>
