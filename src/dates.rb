require 'date'

y = Date.today.year

(1..12).each do |m|
  puts (1..31)
    .lazy
    .map { |d| Date.new(y, m, d) }
    .select(&:thursday?)
    .first(2)
    .last
end
