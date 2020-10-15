## Authorization Code with Refresh Token

The Authorization Code flow is a redirection-based flow,
which means the application must be able to redirect the application user
and receive authorization codes via a web browser.



### Phase 1: Authorization Phase

> To authorize, use this code:

```ruby
require 'gecko-ruby'
oauth_client = Gecko::Client.new(<OAUTH_ID>, <OAUTH_SECRET>).oauth_client
authorization_url = oauth_client.auth_code.authorize_url(redirect_uri: '<REDIRECT_URI>')
#=> "https://go.tradegecko.com/oauth/authorize?client_id=<CLIENT_ID>&redirect_uri=<REDIRECT_URI>&response_type=code"
redirect_to authorization_url
```

```shell
open https://go.tradegecko.com/oauth/authorize?client_id=<CLIENT_ID>&redirect_uri=<REDIRECT_URI>&response_type=code
```

> Make sure to replace `<OAUTH_ID>`, `<OAUTH_SECRET>` `<REDIRECT_URI>` with your details.

An authorization code is the key used to retrieve the access token.
In order to acquire an authorization code, you need to redirect the user's
browser to the authorization endpoint.

`https://api.tradegecko.com/oauth/authorize?response_type=code&client_id=<CLIENT_ID>&redirect_uri=<REDIRECT_URI>`

- `https://api.tradegecko.com/oauth/authorize`: indicates the API authorization endpoint.
- `response_type=code`: specifies that your application is requesting an authorization code grant.
- `client_id=<CLIENT_ID>`: the application's client ID provided when [registering your application](#registering-an-application).
- `redirect_uri=<REDIRECT_URI>`: should be set to a URL in your application where
the user will be redirected back to after the request is authorized.



### Phase 2: User Authorization

Once directed to the above link, the user will be asked to log in to their QuickBooks Commerce account (if they're not already logged in).
They will then be asked to authorize or deny the authentication request.

<div class="screenshot">
  <img src="images/auth-screenshot.png" style="max-width: 400px">
</div>


### Phase 3: Authorization Code response

After the user successfully authorizes the application, they will be redirected back to
the provided `redirect_uri` with the authorization code as a query parameter named `code`.

e.g. `https://my.application.com/auth/app/callback?code=12bc6909c57aaa930`



### Phase 4: Requesting an Access Token

```shell
curl -H "Content-type: application/json" -X POST https://api.tradegecko.com/oauth/token -d '{"client_id": "<CLIENT_ID>", "client_secret":"<CLIENT_SECRET>", "redirect_uri": "https://my.application.com/auth/app/callback", "code": "<CODE_FROM_PHASE_3>", "grant_type": "authorization_code"}'
```

```shell
{
  "access_token": "57ed301af04bf35b40f255feb5ef469ab2f046aff14",
  "expires_in": 7200,
  "refresh_token": "026b343de07818b3ffebfb3001eff9a00aea43da0a",
  "scope": "public",
  "token_type": "bearer"
}
```

```ruby
require 'gecko-ruby'
gecko = Gecko::Client.new(<OAUTH_ID>, <OAUTH_SECRET>)
oauth_client = gecko.oauth_client
access_token = oauth_client.auth_code.get_token(params[:code], redirect_uri: '<REDIRECT_URI>')
gecko.access_token = access_token
gecko.Account.current
```

The access token is a unique key used to make requests to the API.

In order to get an access token, the application must make a POST request to
`https://api.tradegecko.com/oauth/token` with the `client_id`,
`client_secret`, `redirect_uri`, `code` and `grant_type` as parameters.

- `https://api.tradegecko.com/oauth/token`: indicates the API token endpoint.
- `grant_type=authorization_code`: specifies that your application is requesting an authorization code.
- `client_id=<CLIENT_ID>`: the application's client ID provided when [registering your application](#registering-an-application).
- `client_secret=<CLIENT_SECRET>`: the application's client secret provided when [registering your application](#registering-an-application).
- `redirect_uri=<REDIRECT_URI>`: should be set to a URL in your application where the code will be received.
- `code=<CODE>`  must match the authorization code returned by the authorization endpoint in Phase 3

```ruby
access_token.to_hash
#=> {"token_type"=>"bearer", "scope"=>"public", "created_at"=>1500000000, :access_token=>"<ACCESS_TOKEN>", :refresh_token=>"<REFRESH_TOKEN>", :expires_at=>1500007200}
```

Once you have generated the access_token, this is the point where you will likely
want to save off the details for future reuse without requiring user interaction.
To reconstruct a refreshable access token you will need to store
the `access_token` and `refresh_token` parameters returned.

### Phase 5: Refreshing an Access Token

```shell
curl -H "Content-type: application/json" -X POST https://api.tradegecko.com/oauth/token -d '{"client_id": "<CLIENT_ID>", "client_secret": "<CLIENT_SECRET>", "redirect_uri": "http://my.application.com/auth/callback", "refresh_token": "<REFRESH_TOKEN>", "grant_type": "refresh_token"}'
```

```shell
{
  "access_token": "439fc57cf1525e51555",
  "expires_in": 7200,
  "refresh_token": "ecfa1a22bd612cc1d8",
  "scope": "public",
  "token_type": "bearer"
}
```

```ruby
# From existing access_token object
access_token.refresh!
access_token.to_hash # For storage

# From string
require 'gecko-ruby'
gecko = Gecko::Client.new("<OAUTH_ID>", "<OAUTH_SECRET>")
gecko.authorize_from_refresh_token("<REFRESH_TOKEN>")
gecko.access_token.to_hash # For storage
```

A refresh token is a unique token returned when creating an access token that can be
used to request a new access token when the existing current access token expires.

To refresh an access token, the application must make a POST request to
`https://api.tradegecko.com/oauth/token` with the `client_id`,
`client_secret`, `redirect_uri`, `refresh_token` and `grant_type` as parameters.

- `https://api.tradegecko.com/oauth/token`: indicates the API token endpoint.
- `grant_type=refresh_token`: specifies that your application is requesting an refresh token.
- `client_id=<CLIENT_ID>`: the application's client ID provided when [registering your application](#registering-an-application).
- `client_secret=<CLIENT_SECRET>`: the application's client secret provided when [registering your application](#registering-an-application).
- `redirect_uri=<REDIRECT_URI>`: should be set to a URL in your application where the code will be received.
- `refresh_token`: must match the refresh token returned by the authorization endpoint in Phase 4


<aside class='notice'>
**Note:** When the access token is refreshed, a new refresh token is
generated and this should be stored and used the next time the token is refreshed is invoked.
Using an expired refresh token will return an error.
</aside>
