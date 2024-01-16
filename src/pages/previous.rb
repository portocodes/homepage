require 'date'
require 'mustache'
require_relative '../edition.rb'
require_relative '../speaker.rb'

speakers = Dir["data/speakers/*.yml"]
  .map { |filename| speaker(filename) }
  .map { |speaker| [speaker["username"], speaker] }
  .to_h

editions =
  Dir['data/editions/????-??-??.yml']
  .map { |filename| Edition.read(filename, speakers) }
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
