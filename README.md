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

# Setup

1. Install dependencies
```bash
bundle install
yarn install
```

2. Run the server
```bash
bundle exec middleman server
```

[Learn more about slatedocs setup](https://github.com/slatedocs/slate/wiki/Using-Slate-Natively)

# Deploy

./deploy.sh

# Pre-Built Search Index

To speed up lunr index building, we are using index pre-buidling approach as documented at
https://lunrjs.com/guides/index_prebuilding.html

Run the following snippet in browser console after visiting `/docs.html`
```js
let tokens = []
$('h1, h2').each(function () {
    var title = $(this);
    var body = title.nextUntil('h1, h2');
    tokens.push({
      id: title.prop('id'),
      title: title.text(),
      body: body.text()
    });
  });
JSON.stringify(tokens) // to replace the JSON string in tokenString
```

# Rebase with upstream

git remote set upstream git@github.com:slatedocs/slate.git

git fetch upstream

git merge upstream/master
