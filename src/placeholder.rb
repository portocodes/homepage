require './src/edition'

last_event =
  (['data/editions/current.yml'] + Dir['data/editions/next/*.yml'])
    .map(&Edition.method(:read))
    .map { |event| event['date'] }
    .max

next_event_date = Edition.dates(from: last_event).first
meetup_event = Edition.meetup_com(next_event_date)

event = {
  'id' => meetup_event['id'],
  'date' => next_event_date,
  'title' => 'Monthly meetup',
  'summary' => nil,
  'talks' => [{
    'speaker' => 'tba',
    'title' => 'TBA',
    'description' => 'TBA',
  }.compact],
}.compact

puts JSON.pretty_generate(event)

File.write("data/editions/next/#{event["date"]}.yml", YAML.dump(event))
