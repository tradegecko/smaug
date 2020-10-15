## Creating a Sales Order

There are several ways to create a Sales Order via the QuickBooks Commerce API, 
depending on the number of line items, and whether the order is being made to a 
new or existing customer.

We're going to be POSTing a minimal JSON to the `/orders` endpoint.  
Check out [The Order Object](#the-order-object) for descriptions of all 
of the available fields.

As always, check the sidebar for example code.

Here's a few examples:

- Creating a Sales Order for an existing customer being shipped and billed to an existing address.
- Creating a Sales Order for an existing customer, but to a new address.
- Creating a Sales Order for a new customer.

### 1. Order with Existing Customer

```json--inline
{
  "order": {
    "company_id": 101,
    "shipping_address_id": 1002,
    "billing_address_id": 1002,
    "status": "active",
    "issued_at": "21-02-2018",
    "order_line_items": [
      { "variant_id": 14, "quantity": 1 },
      { "variant_id": 15, "quantity": 2 }
    ]
  }
}
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
order.save
```

```shell
curl -X POST -H "Content-type: application/json" -H "Authorization: Bearer <ACCESS_TOKEN>" https://api.tradegecko.com/orders/ \
-d '{"order": {"company_id": 101, "shipping_address_id": 1002, "billing_address_id": 1002, "status": "active", "issued_at": "21-02-2018", "order_line_items": [{"variant_id": 14, "quantity": 1}, {"variant_id": 15, "quantity": 2}]}}'
```

### 2. Order with Existing Customer but new address
We have two options here, we can either create the address in a separate request,
or as in the JSON below we can embed the new address inside the Order JSON and
it will get created for us.

```json--inline
{
  "order": {
    "company_id": 101,
    "shipping_address": {
      "address1": "123 Cross St",
      "city": "Springfield",
      "country": "United States of America",
      "label": "Head Office"
    },
    "status": "active",
    "issued_at": "21-02-2018",
    "order_line_items": [
      { "variant_id": 14, "quantity": 1 },
      { "variant_id": 15, "quantity": 2 }
    ]
  }
}
```

```shell
curl -X POST -H "Content-type: application/json" -H "Authorization: Bearer <ACCESS_TOKEN>" https://api.tradegecko.com/orders/
-d '{"order": {"company_id": 101, "shipping_address": {"address1": "123 Cross St", "city": "Springfield", "country": "United States of America", "label": "Head Office"}, "status": "active", "issued_at": "21-02-2018", "order_line_items": [{"variant_id": 14, "quantity": 1}, {"variant_id": 15, "quantity": 2}]}}'
```

```ruby
# The rubygem does not yet support creating nested addresses,
# so this will make two API requests.
address = gecko.Address.build({
  company_id: 101,
  address1: "123 Cross St",
  city: "Springfield",
  country: "United States of America",
  label: "Head Office"
})
address.save
order = gecko.Order.build({
  company_id: 101,
  shipping_address_id: address.id,
  billing_address_id: address.id,
  issued_at: Time.now,
})
order.order_line_items.build(variant_id: 14, quantity: 1)
order.order_line_items.build(variant_id: 15, quantity: 2)
order.save
```

<aside class="notice">
  If you are unsure whether an address exists in your system yet, you will need to
  handle lookup separately as the order endpoint does not do any address deduping work.
</aside>

<aside class="notice">
  In the example above we have not included a billing address,
  if the billing address is not included the API will assume the shipping address
  is the same as the billing address, if there is a different billing address,
  then either include a `billing_address_id` if the address already exists,
  or nest a new address under the `billing_address` key.
</aside>

### 3. Order for New Customer

If the order is for a new company, the company can either be created via a separate
request, or nested inside the order.
If nesting inside the order, at least a `shipping_address` must be included as well.

```json--inline
{
  "order": {
    "company": {
      "name": "Bill's Boots",
      "company_code": "BB-123",
      "company_type": "business",
      "email": "billy@billsboots.com",
      "website": "https://billsboots.com"
    },
    "shipping_address": {
      "address1": "123 Cross St",
      "city": "Springfield",
      "country": "United States of America",
      "label": "Head Office"
    },
    "status": "active",
    "issued_at": "21-02-2018",
    "order_line_items": [
      { "variant_id": 14, "quantity": 1 },
      { "variant_id": 15, "quantity": 2 }
    ]
  }
}
```

```shell
curl -X POST -H "Content-type: application/json" -H "Authorization: Bearer <ACCESS_TOKEN>" https://api.tradegecko.com/orders/ \
-d '{"order": {"company": {"name": "Bill\'s Boots", "company_code": "BB-123", "company_type": "business", "email": "billy@billsboots.com", "website": "https://billsboots.com"}, "shipping_address": {"address1": "123 Cross St", "city": "Springfield", "country": "United States of America", "label": "Head Office"}, "status": "active", "issued_at": "21-02-2018", "order_line_items": [{"variant_id": 14, "quantity": 1}, {"variant_id": 15, "quantity": 2 }]}}'
```

```ruby
company = gecko.Company.build({
  name: "Bill's Boots",
  company_code: "BB-123",
  company_type: "business",
  email: "billy@billsboots.com",
  website: "https://billsboots.com"
})
company.save
address = gecko.Address.build({
  address1: "123 Cross St",
  city: "Springfield",
  country: "United States of America",
  label: "Head Office"
})
address.save
  company_id: company.id,
  shipping_address_id: address.id,
  billing_address_id: address.id,
  issued_at: Time.now,
})
order.order_line_items.build(variant_id: 14, quantity: 1)
order.order_line_items.build(variant_id: 15, quantity: 2)
order.save
```

### Creating a Sales Order with > 250 items.

If you are regularly creating orders with several hundreds of items you may run into
the occasional case where the server times out.

To mitigate effects of timeouts we suggest the use of two extra mechanisms.

**1. Idempotency Tokens**  
By using an [Idempotency Token](#idempotency-tokens) header when creating the
Sales Order, you can automatically recover from occasional timeout errors by simply
retrying the POST request and the API will ensure only a single Sales Order is created.

**2. Multi-part Creates**  
For an order with a significant number of line items, it may make sense to split
them into multiple requests.
We don't suggest unless you're running into regular issues with Sales Order size.
In this case, create the Sales Order as above with a section of the line items
(150 for example), and then fire an Order update request with just an array of
the next set of items.

`PUT /orders/12345`

```json--inline
{
  "order": {
    "order_line_items": [
      { "variant_id": 14, "quantity": 1 },
      { "variant_id": 15, "quantity": 2 }
    ]
  }
}
```

<aside class="notice">
If you are regularly making > 400 line item orders via the QuickBooks Commerce API, please
contact your success rep as we'd love to discuss your usecases further.
</aside>
