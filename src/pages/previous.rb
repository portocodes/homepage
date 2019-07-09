require 'oga'
require 'open-uri'
require 'date'
require 'mustache'
require 'kramdown'

require_relative '../speaker.rb'

DAYS = ["th", "st", "nd", "rd"]

def fmt_date(date)
  "#{date.strftime("%B")} #{date.day}#{DAYS.fetch(date.day, "th")}, #{date.year}"
end

speakers = Dir["data/speakers/*.yml"]
  .map { |filename| speaker(filename) }
  .map { |speaker| [speaker["username"], speaker] }
  .to_h

editions = Dir["data/editions/previous/*.yml"]
  .map { |filename| YAML.load(File.read(filename)) }
  .map do |edition|
    edition.merge(
      date: edition["date"],
      human_date: fmt_date(edition["date"]),
      talks: edition.fetch("talks", []).map do |talk|
        puts "unknown speaker #{talk["speaker"]}" if speakers[talk["speaker"]].nil?

        talk.merge(
          speaker: speakers[talk["speaker"]],
          summary: talk["summary"]&.then { |summary| Kramdown::Document.new(summary).to_html },
        )
      end,
    )
  end
  .sort_by { |edition| edition[:date] }
  .reverse

File.write(
  "build/previous.html",
  Mustache.render(
    File.read("src/pages/previous.html.mustache"),
    editions: editions,
  ),
)
