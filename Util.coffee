request = require 'request'
Config = require './Config'

GetSummaryUrl = Config.BaseUrl + '/api/investor/' + Config.Version + '/accounts/' + Config.AccountNum + '/summary'
GetOwnedNotesUrl = Config.BaseUrl + '/api/investor/' + Config.Version + '/accounts/' + Config.AccountNum + '/notes'
GetPortfoliosUrl = Config.BaseUrl + '/api/investor/' + Config.Version + '/accounts/' + Config.AccountNum + '/portfolios'
GetActiveNotesUrl = Config.BaseUrl + '/api/investor/' + Config.Version + '/loans/listing?showAll=true'
SubmitOrdersUrl = Config.BaseUrl + '/api/investor/' + Config.Version + '/accounts/' + Config.AccountNum + '/orders'
CreatePortfoliosUrl = Config.BaseUrl + '/api/investor/' + Config.Version + '/accounts/' + Config.AccountNum + '/portfolios'

GenGetOptions = (url) ->
  {url, headers: {Authorization: Config.Token}}

GenPostOptions = (url, data) ->
  {
    url
    body: JSON.stringify data
    headers:
      Authorization: Config.Token
      'content-type': 'application/json'
  }

GetBody = (url, callback) ->
  request GenGetOptions(url), (err, res, body) ->
    return callback err, null if err?
    try
      callback null, 
        JSON.parse(body)
    catch e
      callback e, null

PostBody = (url, data, callback) ->
  request.post GenPostOptions(url, data), (err, res, body) ->
    return callback err, null if err? 
    return callback('non 200 statusCode: ' + res.statusCode + ', ' + res.body) if res.statusCode/100 != 2
    try
      callback null, 
        JSON.parse(body)
    catch e
      callback e, null

CreateOrder = (loans) ->
  ({
    loanId: id,
    requestedAmount: Config.DefaultAmoutPerNote,
    portfolioId: Config.DefaultPortfolio
  } for {id} in loans)

module.exports = {
  GenGetOptions, GenPostOptions,
  GetBody, PostBody, CreateOrder,
  GetSummaryUrl, GetOwnedNotesUrl, GetPortfoliosUrl, GetActiveNotesUrl,
  SubmitOrdersUrl, CreatePortfoliosUrl
}