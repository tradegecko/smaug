## OAuth Authentication Flows

The QuickBooks Commerce API is based on [version 22 of the OAuth 2.0 specification](http://tools.ietf.org/html/draft-ietf-oauth-v2-22).

If you are familiar with OAuth, then the authentication endpoints are as follows:

- Authorization: `https://api.tradegecko.com/oauth/authorize` 
- Token Request: `https://api.tradegecko.com/oauth/token` 

<aside class='notice'>
  We very highly recommend using a third-party library in your chosen language rather than trying to implement OAuth flows manually.
  <br/>
  You can find <a href="https://oauth.net/code/#client-libraries">a list of recommended libraries here</a>
</aside>

### Available Authentication Flows

The QuickBooks Commerce API supports two common OAuth 2.0 flows:

- [Authorization Code with Refresh Token flow](#authorization-code)
- [Resource Owner Password Credentials flow](#resource-owner-password-credentials)

Under the majority of circumstances we recommend the [Authorization Code with Refresh Token](#authorization-code) flow as it provides the highest level of security.

For prototyping, or one-off integrations you may use the [Resource Owner Password Credentials](#resource-owner-password-credentials) flows.

If you plan on building an application that will be used by multiple QuickBooks Commerce accounts, you MUST use the [Authorization Code with Refresh token](#authorization-code) flow.
