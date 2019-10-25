require 'yaml'

template = File
  .read("data/editions/template.yml")
  .then(&YAML.method(:load))

current = File
  .read("data/editions/current.yml")
  .then(&YAML.method(:load))

previous = {
  "id" => current["id"],
  "date" => current["date"],
  "talks" => current["schedule"].select {|t|t["speaker"]}.map do |talk|
    {
      "title" => talk["title"],
      "speaker" => talk["speaker"],
      "summary" => talk["summary"],
    }
  end,
}

following = File
  .read(Dir["data/editions/next/*.yml"].min)
  .then(&YAML.method(:load))

current = template
current["id"] = following["id"]
current["date"] = following["date"]
current["schedule"] = template["schedule"].map do |talk|
  if talk == "talk"
    (following["talks"] || []).map { |t2| { "start" => "19:30" }.merge t2 }
  else
    talk
  end
end.flatten

File.write("data/editions/previous/#{previous["date"]}.yml", YAML.dump(previous))
File.write("data/editions/current.yml", YAML.dump(current))
File.delete("data/editions/next/#{following["date"]}.yml")
