require 'date'
require 'mustache'
require_relative '../edition'

next_events =
  Dir['data/editions/????-??-??.yml']
  .map { |filename| Edition.read(filename) }
  .select { |edition| Date.today <= edition.date }
  .sort_by(&:date)

current = next_events.first

File.write(
  'build/slides.html',
  Mustache.render(
    File.read('src/pages/slides.html.mustache'),
    editions: next_events.drop(1),
    current: current
  )
)
