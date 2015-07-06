lending-club-investor
===============

Node.js tool to automatically invest on lendingclub notes filtered according to your customized filter

## Installation

```bash
$ npm install lending-club-investor
```

## Using it
In order to use this auto-investor, follow the following steps:

1. Get your LendingClub API Token from: https://www.lendingclub.com/developers/lc-api.action .
2. Get your LendingClub Account number from your account summary.
3. Get your default Portfolio ID using function **GetPortfolios** in [**Invest.coffee**](https://github.com/mithraslee/lending-club-investor/Invest.coffee). You can also create new portfolio using function **CreatePortfolio**.
4. Fill in the token, account#, portfolio id got from above steps in [**Config.coffee**](https://github.com/mithraslee/lending-club-investor/Config.coffee).
5. Buildup notes filtering function **FilterLoans** in [**Config.coffee**](https://github.com/mithraslee/lending-club-investor/Config.coffee) based on your judgement.
6. Run the auto-invetor by:

```coffeescript
coffee invest.coffee
```