require 'mustache'
require_relative '../edition'

next_events =
  Dir['data/editions/????-??-??.yml']
  .map { |filename| Edition.read(filename) }
  .select { |edition| Date.today <= edition.date }
  .sort_by(&:date)

current = next_events.first

File.write(
  'build/index.html',
  Mustache.render(
    File.read('src/pages/index.html.mustache'),
    next_events: next_events.drop(1),
    current: current
  )
)
