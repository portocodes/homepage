require 'date'
require 'httparty'
require 'yaml'
require 'kramdown'


# Monkey patching helper functions
class Date
  ORDINAL_SUFFIXES = %w[th st nd rd].freeze

  def human
    "#{self.strftime('%B')} #{self.day}#{ORDINAL_SUFFIXES.fetch(self.day, 'th')}, #{self.year}"
  end
end

# Monkey patching helper functions
class Integer
  def to_hour
    minutes = (self / 60) % 60
    hours = self / 3600

    '%02d:%02d' % [hours, minutes]
  end
end

# Monkey patching helper functions
class String
  def markdown_to_html
    Kramdown::Document.new(self).to_html
  end
end

# Represents an entry in the meetup schedule
class ScheduleEntry < OpenStruct
  def self.load(obj, speakers)
    obj['summary_html'] = obj['summary']&.markdown_to_html
    obj['start'] = obj['start']&.to_hour
    obj['speaker'] = speakers[obj['speaker']]

    new(obj)
  end

  def talk?
    !self.speaker.nil?
  end
end

# Represents a meetup edition
class Edition < OpenStruct
  def self.read(filename, speakers)
    parse(File.read(filename), speakers)
  end

  def self.parse(yml, speakers)
    self.load(YAML.load(yml, permitted_classes: [Date]), speakers)
  end

  def self.load(edition, speakers)
    edition['human_date'] = edition['date']&.human
    edition['summary_html'] = edition['summary']&.markdown_to_html
    edition['schedule'] = edition['schedule']&.map do |entry|
      ScheduleEntry.load(entry, speakers)
    end

    new(edition)
  end

  # Crap that shouldn't be here, probably

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
          headers: { Cookie: 'yes' }
        }
      )
      .first
  end
end
