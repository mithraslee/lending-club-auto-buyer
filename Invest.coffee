Log4js = require('log4js');
Config = require './Config'
Util = require './Util'

Log4js.configure {
  appenders: [
    { type: 'console' }
    { type: 'file', filename: 'log/lendingclub.log', category: 'lc' }
  ]
}
logger = Log4js.getLogger('lc')

GetSummary = (callback) ->
  Util.GetBody Util.GetSummaryUrl, callback

GetLoans = (callback) ->
  Util.GetBody Util.GetActiveNotesUrl, (err, data) ->
    return callback err, [] if err?
    callback null, data.loans

GetOwnedLoans = (callback) ->
  Util.GetBody Util.GetOwnedNotesUrl, (err, data) ->
    return callback err, [] if err?
    callback null, data.myNotes

GetPortfolios = (callback) ->
  Util.GetBody Util.GetPortfoliosUrl, (err, data) ->
    return callback err, [] if err?
    callback null, data

SubmitOrders = (orders, callback) ->
  Util.PostBody Util.SubmitOrdersUrl, {aid: Config.AccountNum, orders: orders}, callback

CreatePortfolio = (portfolioName, portfolioDescription, callback) ->
  Util.PostBody Util.CreatePortfoliosUrl, {aid: Config.AccountNum, portfolioName, portfolioDescription}, callback

Start = () ->
  logger.info "Start Auto-Investor for Account #{Config.AccountNum}"
  GetSummary (err1, summary) ->
    return logger.error err1 if err1?
    logger.info "Account Summary:"
    logger.info summary

    GetLoans (err2, allLoans) ->
      return logger.error err2 if err2?
      validLoans = allLoans.filter(Config.FilterLoans).sort((l1, l2) -> l2.intRate - l1.intRate)
      logger.info "Number of valid notes: #{validLoans.length}"

      GetOwnedLoans (err3, ownedLoans) ->
        return logger.error err3 if err3?
        ownedLoanIds = (loanId for {loanId} in ownedLoans)
        logger.info "Number of owned notes: #{ownedLoanIds.length}"
        
        notOwnedValidLoans = validLoans.filter((loan) -> ownedLoanIds.indexOf(loan.id) is -1)
        logger.info "Number of not-owned valid notes: #{notOwnedValidLoans.length}"

        orders = Util.CreateOrder notOwnedValidLoans[0...(Math.floor summary.availableCash/Config.DefaultAmoutPerNote)]
        return logger.info "Zero orders to be placed" unless orders.length > 0

        logger.info "Number of orders to be placed: #{orders.length}"
        logger.info "Notes to be invested"
        logger.info notOwnedValidLoans[0...orders.length]
        logger.info "Orders to be placed"
        logger.info orders

        SubmitOrders orders, (err4, res) ->
          return logger.error err4 if err4?
          logger.info "OrderSubmitStatus:\norderInstructId: #{res.orderInstructId}"
          logger.info res.orderConfirmations

Start()

module.exports = {GetSummary, GetLoans, GetOwnedLoans, GetPortfolios, SubmitOrders, CreatePortfolio, Start}

