# Idempotency Tokens

```shell
curl https://api.tradegecko.com/orders/ \
     -X POST \
     -H "Idempotency-Key: ecf83ef1-0f85-4860-bbc3-70a4bd74be41" \
     -H "Content-type: application/json" \
     -H "Authorization: Bearer <ACCESS_TOKEN>" \
     -d '{"order": {"company_id": 101, "shipping_address_id": 1002, "billing_address_id": 1002, "status": "active", "issued_at": "21-02-2018", "order_line_items": [{"variant_id": 14, "quantity": 1}, {"variant_id": 15, "quantity": 2}]}}'
```

```ruby
order = gecko.Order.build({
  company_id: 101,
  shipping_address_id: 1002,
  billing_address_id: 1002,
  issued_at: Time.now,
})
order.order_line_items.build(variant_id: 14, quantity: 1)
order.order_line_items.build(variant_id: 15, quantity: 2)
order.save(idempotency_token: "ecf83ef1-0f85-4860-bbc3-70a4bd74be41")
```


The TradeGecko API has support for [idempotent](https://en.wikipedia.org/wiki/Idempotence) 
requests via an optional `Idempotency-Key` request header.
By providing a unique Idempotency key in your POST or PUT requests the API can 
guarantee that a specific operation is only performed once.

The keys expire after 24 hours.
