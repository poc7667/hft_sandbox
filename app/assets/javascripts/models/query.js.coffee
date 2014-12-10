# for more details see: http://emberjs.com/guides/models/defining-models/

CnMarket.Query = DS.Model.extend
  userId: DS.attr 'number'
  queryContent: DS.attr 'string'
