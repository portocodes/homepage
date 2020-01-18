require './src/edition'

Edition
  .dates(from: Date.today)
  .take(12)
  .to_a
  .then(&method(:puts))
