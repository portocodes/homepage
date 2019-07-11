require 'yaml'

require_relative './speaker.rb'

speakers = Dir["data/speakers/*.yml"]
  .map { |filename| speaker(filename) }
  .map { |speaker| [speaker["username"], speaker] }
  .to_h

current = File
  .read("data/editions/current.yml")
  .yield_self(&YAML.method(:load))
  .yield_self do |current|
    current.merge(
      "schedule" => current["schedule"].map do |i|
        i.merge(
          "speaker" => speakers[i["speaker"]]&.fetch("name"),
        )
      end,
    )
  end

description = <<-EOF
# Agenda

EOF

current["schedule"].each do |item|
  description << <<-EOF
## #{item["start"]} #{item["title"]}#{", by #{item["speaker"]}" if item["speaker"]}

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
