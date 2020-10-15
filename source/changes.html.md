---
title: QuickBooks Commerce API Changelog

toc_footers:
  - <a href='https://go.tradegecko.com/register'>Sign up for an account</a>
  - <a href='http://github.com/tripit/slate'>Documentation Powered by Slate</a>

search: true
---

# QuickBooks Commerce API Changelog

Build tools that solve problems for millions of wholesale and retail businesses worldwide.

You can view code examples in the dark area to the right; switch the programming language of the examples with the tabs in the top right.

If anything is missing or seems incorrect, please check the [GitHub issues](https://github.com/tradegecko/smaug/issues)
for existing known issues or [create a new issue](https://github.com/tradegecko/smaug/issues/new).

## Changelog

### July 2020
Added new Payment Method endpoint.

### June 2020
Added new "FulfillmentReturn Received", and "Invoice Destroy" webhooks.

Added new `component_id` array filter for Composition index endpoint.

### April 2020
Added new "PurchaseOrder Received" webhook.

### Feb 2020 - Composition API Release
In order to provide a simpler way to fetch packsize and bundle decomposition information, we've exposed a brand new API.

### Apr 2019 - Pagination Cleanup & Line Item Filters
In order to provide a great experience to all our API users we've made some changes to our pagination.
The default page size is now 50 items (down from 100), with a max page size up to 250.

The max page size for new integrations has been 250 for several years, but we have a
few grandfathered integrations that supported a page size of up to 999.
Over the next few weeks we will be contacting and migrating everyone to a 250 item max.

Added a Webhooks section to the documentation.

OrderLineItem and PurchaseOrderLineItem index endpoints now support an `order_status` and `purchase_order_status` filter respectively.

### Oct 2018 - Enable Sideloading, Add Webhooks and Resource Actions
We now support [sideloading of resources](/docs.html#sideloading-resources).
We have also added support for [webhooks](/docs.html#webhook)
and introduced resource actions for [Order](/docs.html#order-actions), [Purchase Order](/docs.html#purchase-order-actions), [Stock Adjustment](/docs.html#stock-adjustment-actions) and [Stock Transfer](/docs.html#stock-transfer-actions).

### Nov 2017 - Image management moved from Variant to the Product Level
We have moved image management from the variant level to the product level.
This allows the same product image to be shared between multiple variants of a product.
All of the changes are backwards compatible.

The related changes to the APIs are:

- Added: `Product#image_ids`.
- Added: `Image#product_id`.
- Added: `Image#variant_ids`.
- Deprecated: `Image#variant_id` now returns the image's first variant.


## API Deprecations

There are a few edge cases of the API that we will be removing as we hit 1.0.
We will endeavour to only remove APIs that have been deprecated for at least 12 months in the v1.0 release.

### Nov 2017 - Image IDs
`Image#variant_id` has been replaced with `Image#variant_ids` and `Image#product_id` now that an image can belong to multiple variants.

### Jan 2016 - Pagination Limits

Default pagination is 50 and the maximum will be set as 250 items. We will begin returning a 400 Bad Request on larger requests.

Previously we hadn't been enforcing our API pagination limits, very soon we will start to do so as to make sure all our customers receive a great experience.

### Jan 2016 - Purchase Order

| Initial                   | Updated                   |
| ------------------------- | -------                   |
| **tax_type**              | **tax_treatment**         |
| **default_price_type_id** | **default_price_list_id** |
| **cached_total**          | **total**                 |

### Jan 2016 - Purchase Order Line Item

| Initial      | Updated                   |
| -------      | -------                   |
| **tax_rate** | **tax_rate_override**     |

This has been renamed to denote it's actual nature -> you should technically use tax_type_id, but if for some reason you want to override it with a specific value, you can use this.

### Jan 2016 - Order

| Initial                   | Updated                   |
| -------                   | -------                   |
| **due_at**                | **ship_at**               |
| **url**                   | **source_url**            |
| **tax_type**              | **tax_treatment**         |
| **default_price_type_id** | **default_price_list_id** |

Tax Type has been renamed to tax_treatment (inclusive vs exclusive) as tax_type now represents an object
with multiple tax_components.

### Jan 2016 - Order Line Item

| Initial      | Updated               |
| -------      | -------               |
| **tax_rate** | **tax_rate_override** |

### Jan 2016 - Contact

| Initial   | Updated          |
| -------   | -------          |
| **phone** | **phone_number** |

### Jan 2016 - Company

| Initial                   | Updated                     |
| -------                   | -------                     |
| **default_price_type_id** | **default_price_list_id**   |
| **default_tax_rate**      | **default_tax_type_id** (1) |

1 - Tax rate has been deprecated site wide in preference of tax_type_id, as this allows multiple tax lines.

### Jan 2016 - Account

| Initial                                  | Updated                                  |
| -------                                  | -------                                  |
| **default_tax_type**                     | **default_tax_treatment**                |
| **default_tax_type_id**                  | **default_sales_order_tax_type_id**      |
| **default_order_price_type_id**          | **default_order_price_list_id**          |
| **default_purchase_order_price_type_id** | **default_purchase_order_price_list_id** |
| **logo_url**                             | N/A (1)                                  |

1 - Accounts no longer have logos.

### Jan 2016 - Users

| Initial          | Updated    |
| -------          | -------    |
| **mobile_phone** | **mobile** |

### Jan 2016 - Product

| Initial        | Updated         |
| -------        | -------         |
| **vendor**     | **supplier_id** |
| **supplier**   | **supplier_id** |

Vendor was deprecated for supplier, then supplier was deprecated in order to enable multiple suppliers per variant (not yet released). Previously, vendor and supplier were just names and stored as strings, now they reference a company within your TradeGecko system.

### Jan 2016 - Variants

| Initial                     | Updated    |
| --------------------------- | ---------- |
| **is_online**               | N/A (1)       |
| **prices**                  | **variant_prices** (2) |
| **stock_levels**            | **locations** (3)
| **committed_stock_levels**  | **locations** (3)

1 - With the addition of multiple sales channels, is_online became restrictive. A variant may be online on Shopify, but not Amazon.

```
Old format

prices: {
  2: "200.0",
  3: "150.0",
  4: "100.0"
},
```

```
New format

variant_prices: [
  {
    price_list_id: "2",
    value: "200.0"
  },
  {
    price_list_id: "3",
    value: "4.0"
  },
  {
    price_list_id: "buy",
    value: "100.0"
  }
],
```

2 - Prices has not just been renamed, the syntax is updated to be more in line with other embedded objects in our API.


```
Old format

stock_levels: {
  1: 5
},

committed_stock_levels: {
  1: 2
}
```

```
New format

locations: [
  {
    location_id: 1,
    stock_on_hand: "5",
    committed: 2,
    incoming: null,
    bin_location: null,
    reorder_point: null
  }
],
```

3 - This is the same deal as prices, the locations hash has replaced stock_levels and committed_stock_levels hashes.
