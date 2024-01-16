require 'yaml'

require_relative './edition.rb'
require_relative './speaker.rb'

speakers = Dir["data/speakers/*.yml"]
  .map { |filename| speaker(filename) }
  .map { |speaker| [speaker["username"], speaker] }
  .to_h

next_events =
  Dir['data/editions/????-??-??.yml']
  .map { |filename| Edition.read(filename, speakers) }
  .select { |edition| Date.today <= edition.date }
  .sort_by(&:date)

current = next_events.first

description = <<-EOF
# Agenda

EOF

current["schedule"].each do |item|
  description << <<-EOF
## #{item["start"]} #{item["title"]}#{", by #{item["speaker"]["name"]}" if item["speaker"]}

#{item["summary"].chomp("\n")}

  EOF
end

description << <<EOF
# Porto Codes

Porto Codes is a meetup for local and international programming enthusiasts.
The talks are recorded and published with the presenters' consent as one of our
goals is to provide programming resources to the community.

Reach us on Slack (https://invite.porto.codes) if you are interested in
presenting or chatting with us!
EOF

puts description
