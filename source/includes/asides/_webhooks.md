# Webhooks

You can use webhooks to receive notifications fo a collection of common events, see [the list here](#list-of-available-events).

Once you've created a webhook via the API, any time that matching event is triggered in the customer's QuickBooks Commerce account, the endpoint will receive a POST request.

### The Webhook notification

The webhook request you received will include a JSON serialized payload including the
`object_id`, `event`, a `timestamp` and the `resource_url`.

```json--inline
  {
    "object_id": 1234567,
    "event": "fulfillments.create",
    "timestamp": 1546272000,
    "resource_url": "https://api.tradegecko.com/fulfillments/1234567.json"
  }
```

It will also include some specific HTTP headers.

`X-Gecko-Delivery`: A unique identifier for the event, if you have any issues with webhooks, please provide this value when submitting any support ticket.

`X-Gecko-Signature`: A signed signature for verification.

To ensure the request comes from QuickBooks Commerce itself and is not being spoofed be sure to verify the
signature against the payload received.

An example implementation in Ruby is provided.

```ruby--inline
def generate_signature(body)
  digest = OpenSSL::Digest.new('sha256')
  Base64.encode64(OpenSSL::HMAC.digest(digest, application.secret, body.to_json)).strip
end
```


### Responding to a webhook
When receiving a webhook, the request must complete within a 10-second window, we highly recommending processing the webhooks asynchronously to avoid any problems.

We use HTTP response codes to determine whether a webhook has been received successfully.
If your server returns a HTTP status code between `200` and `399`, we assume it has been processed successfully.

A HTTP `410 Gone` response will automatically delete the webhook.

Other responses will cause the outgoing request to be retried, based on an [exponential backoff strategy](https://github.com/mperham/sidekiq/wiki/Error-Handling#automatic-job-retry).

If we receive unsuccessful responses consecutively for 3 days, the webhook will be deleted. Any successful response within the 3 day period will reset the counter.
Application developers will receive daily emails to notify them of webhook failure and webhook deletion.
