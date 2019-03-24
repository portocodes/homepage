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

current = File
  .read("data/editions/current.yml")
  .yield_self(&YAML.method(:load))
  .yield_self do |current|
    current.merge(
      schedule: current["schedule"].map do |i|
        i.merge(
          summary: Kramdown::Document.new(i["summary"]).to_html,
          speaker: speakers[i["speaker"]],
        )
      end,
      human_date: fmt_date(current["date"]),
    )
  end

editions = Dir["data/editions/next/*.yml"]
  .map { |filename| YAML.load(File.read(filename)) }
  .map do |edition|
    edition.merge(
      date: edition["date"],
      title: edition["title"] || "Monthly meetup",
      human_date: fmt_date(edition["date"]),
      talks: edition.fetch("talks", []).map do |talk|
        puts "unknown speaker #{talk["speaker"]}" if speakers[talk["speaker"]].nil?

        talk.merge(
          speaker: speakers[talk["speaker"]],
        )
      end,
    )
  end
  .sort_by { |edition| edition[:date] }

File.write(
  "build/index.html",
  Mustache.render(
    File.read("src/pages/index.html.mustache"),
    editions: editions,
    current: current,
  ),
)
