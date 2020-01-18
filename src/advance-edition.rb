require './src/edition'

template =
  "data/editions/template.yml"
    .then(&Edition.method(:read))

current =
  "data/editions/current.yml"
    .then(&Edition.method(:read))

following =
  Dir["data/editions/next/*.yml"]
    .min
    .then(&Edition.method(:read))

previous = {
  "id" => current["id"],
  "date" => current["date"],
  "talks" => current["schedule"].select { |t| t["speaker"] }.map do |talk|
    {
      "title" => talk["title"],
      "speaker" => talk["speaker"],
      "summary" => talk["summary"],
    }
  end,
}

current = template
current["id"] = following["id"]
current["date"] = following["date"]
current["schedule"] = template["schedule"].map do |talk|
  if talk == "talks"
    (following["talks"] || []).map { |t2| { "start" => "19:30" }.merge t2 }
  else
    talk
  end
end.flatten

File.write("data/editions/previous/#{previous["date"]}.yml", YAML.dump(previous))
File.write("data/editions/current.yml", YAML.dump(current))
File.delete("data/editions/next/#{following["date"]}.yml")
