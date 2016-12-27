# TradeGecko developer docs
--------

### Example attribute.
```
name: {
  name: "",
  type: "String",
  description: "",
  filterable: "",
  updatable: true,
  creatable: true,
  required: false,
  readonly: false,
  beta: false,
  deprecated: false,
  private: false
},
```

### To Do

- FulfillmentReturn
- LedgerAccount
- Login
- Payment
- Procurement
- Refund
- StockAdjustment
- StockTransfer
- TaxComponent
- Webhook

### Add a new resource with

`thor generate model ClassName`

You will need 
```
OAUTH_SECRET=xxx
OAUTH_ID=xxx
OAUTH_TOKEN=xxx
```

In your .env.

### Add to Changelog

Look in changes.html

### Customise content of a resource

Look in the appropriate .yml file.

# Deploy

./deploy.sh

# Rebase with upstream

git remote set upstream git@github.com:lord/slate.git

git fetch upstream

git merge upstream/master

