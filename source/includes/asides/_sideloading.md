# Sideloading Resources

QuickBooks Commerce allows you retrieve associated resources as part of a single request.
This can be done by adding an `include` parameter containing a comma-separated list of resources to load.

<aside class="notice">
  Sideloading for Orders and Purchase Orders are currently available only when retrieving a single order or purchase order. Using the `include` parameter won't work on index pages.
</aside>


Here's a few examples:

### Fetching a Product

`GET https://api.tradegecko.com/products/1?include=variants`

```shell
curl -X POST -H "Content-type: application/json" -H "Authorization: Bearer <ACCESS_TOKEN>" https://api.tradegecko.com/products/153172?include=variants
```

```json--inline
{
   "variants":[
      {
         "id":558277,
         "created_at":"2013-11-18T03:00:38.459Z",
         "updated_at":"2018-05-23T08:02:29.569Z",
         "product_id":153172,
         ...
      }
   ],
   "product":{
      "id":153172,
      "created_at":"2013-07-23T16:25:36.582Z",
      "updated_at":"2018-09-01T04:54:25.085Z",
      "brand":null,
      "description":"Wiggly and squiggly. Watch out for the tail falling off!\u003cbr\u003e",
      "image_url":null,
      ...
   }
}
```

### Fetching an Order

`GET https://api.tradegecko.com/orders/160?include=order_line_items,shipping_address,billing_address,company`

```shell
curl -X POST -H "Content-type: application/json" -H "Authorization: Bearer <ACCESS_TOKEN>" https://api.tradegecko.com/orders?include=order_line_items,shipping_address,billing_address,company
```

```json--inline
{
   "order_line_items":[
      {
         "id":335,
         "created_at":"2018-02-23T07:54:43.756Z",
         "updated_at":"2018-03-22T13:50:57.564Z",
         "order_id":160,
         "variant_id":1193,
         ...
      },
      {
         "id":336,
         "created_at":"2018-02-23T07:54:43.765Z",
         "updated_at":"2018-03-22T13:50:57.507Z",
         "order_id":160,
         "variant_id":1199,
         ...
      },
      {
         "id":337,
         "created_at":"2018-02-23T07:54:43.774Z",
         "updated_at":"2018-03-22T13:50:57.475Z",
         "order_id":160,
         "variant_id":1182,
         ...
      }
   ],
   "addresses":[
      {
         "id":147,
         "created_at":"2018-02-23T07:54:42.462Z",
         "updated_at":"2018-02-23T07:54:42.462Z",
         "company_id":96,
         "address1":"1260 Billy Plaza",
         ...
      },
      {
         "id":146,
         "created_at":"2018-02-23T07:54:42.460Z",
         "updated_at":"2018-02-23T07:54:42.460Z",
         "company_id":96,
         "address1":"620 Pfannerstill Run",
         ...
      }
   ],
   "companies":[
      {
         "id":96,
         "created_at":"2018-02-23T07:54:42.457Z",
         "updated_at":"2018-03-22T13:50:30.892Z",
         ...
      }
   ],
   "order":{
      "id":160,
      "created_at":"2018-02-23T07:54:43.683Z",
      "updated_at":"2018-09-24T03:29:30.759Z",
      "assignee_id":null,
      "billing_address_id":147,
      "company_id":96,
      "contact_id":null,
      ...
   }
}
```


### Fetching a Bundle Product Variant's Composition

Sideloading parameters for composition API work for both single and collection actions. Examples:

`GET https://api.tradegecko.com/variants/composition?include=bundle`

`GET https://api.tradegecko.com/variants/composition/1?include=bundle,component`


```shell
curl -X GET -H "Content-type: application/json" -H "Authorization: Bearer <ACCESS_TOKEN>" https://api.tradegecko.com/variants/composition?include=bundle,component
```

```json--inline
{
   "variants": [
      {
         "id": 1,
         "sku": "DRK-0001",
         ...
      },
      {
         "id": 2,
         "sku": "DRINK-PACK-SKU",
         ...
      },
      ...
   ],
   "composition": [
      {
         "bundle_sku": "DRINK-PACK-SKU",
         "component_sku": "DRK-0001",
         "quantity": "6.0",
         "bundle_id": 2,
         "component_id": 1
      },
      ...
   ]
}
```
