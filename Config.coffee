FilterLoans = (loan) ->
  loan.grade > 'B' and 
  loan.grade < 'E' and
  loan.subGrade < 'D4' and
  loan.subGrade > 'C2' and
  loan.accNowDelinq is 0 and
  loan.accOpenPast24Mths <= 4 and
  loan.annualInc > 30000 and
  loan.bcUtil <= 60 and
  loan.chargeoffWithin12Mths is 0 and
  loan.delinq2Yrs is 0 and
  loan.delinqAmnt is 0 and
  loan.dti <= 25 and
  loan.empLength >= 1 and
  loan.ficoRangeLow > 700 and
  loan.inqLast6Mths is 0 and
  loan.loanAmount < 40000 and
  loan.pubRecBankruptcies is 0 and
  loan.pubRec is 0 and
  loan.revolBal <= 35000 and
  loan.revolUtil <= 85 and
  loan.totalAcc <= 20 and
  not loan.mthsSinceLastDelinq? and
  not loan.mthsSinceLastMajorDerog? and
  (loan.purpose.toLowerCase().indexOf("debt_consolidation") isnt -1 or loan.purpose.toLowerCase().indexOf("credit_card") isnt -1)

BaseUrl = 'https://api.lendingclub.com'
Version = 'v1'

Token = 'personal-api-token'
AccountNum = '00000000'

DefaultAmoutPerNote = 25
DefaultPortfolio = 11111111

module.exports = {
  FilterLoans,
  BaseUrl, Version,
  Token, AccountNum,
  DefaultAmoutPerNote,
  DefaultPortfolio
}