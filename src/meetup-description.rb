require 'yaml'

current = File
  .read("data/editions/current.yml")
  .yield_self(&YAML.method(:load))

description = <<-EOF
# Agenda

EOF

current["schedule"].each do |item|
  description << <<-EOF
## #{item["start"]} #{item["title"]}

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
