require 'date'
require 'mustache'
require_relative '../edition'

editions =
  Dir['data/editions/????-??-??.yml']
  .map { |filename| Edition.read(filename) }
  .select { |edition| edition.date < Date.today }
  .sort_by(&:date)
  .reverse

File.write(
  'build/previous.html',
  Mustache.render(
    File.read('src/pages/previous.html.mustache'),
    editions: editions
  )
)
