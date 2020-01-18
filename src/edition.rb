require 'date'
require 'httparty'
require 'yaml'

module Edition
  def self.read(filename)
    filename
      .then(&File.method(:read))
      .then(&YAML.method(:load))
  end

  def self.dates(from:)
    Date
      .new(from.year, from.month)
      .then { |d| Enumerator.produce(d, &:next_month) }
      .lazy
      .map(&method(:date))
      .select { |d| from < d }
  end

  def self.date(start)
    start
      .then { |d| Enumerator.produce(d, &:next) }
      .lazy
      .select(&:thursday?)
      .drop(1)
      .first
  end

  def self.meetup_com(date)
    HTTParty
      .get(
        'https://api.meetup.com/portocodes/events',
        {
          query: { no_earlier_than: "#{date}T00:00:00.000", page: 1 },
          headers: { Cookie: 'yes' },
        },
      )
      .first
  end
end
