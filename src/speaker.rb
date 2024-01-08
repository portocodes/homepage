require 'open-uri'
require 'yaml'
require 'json'
require 'digest'

def cache(contents)
  cache_filename = File.join("cache", Digest::SHA256.hexdigest(contents))

  if !File.exists?(cache_filename)
    File.write(cache_filename, yield)
  end

  File.read(cache_filename)
end


def speaker(filename)
  username = filename.match(/.*\/(.*)\.yml/)[1]

  contents = File.read(filename)

  cache(contents) do
    speaker = YAML.load(contents, permitted_classes: [Date])
    speaker = [
      linkedin(speaker["linkedin"]),
      twitter(speaker["twitter"]),
      github(speaker["github"]),
      speaker,
      { "username" => username },
    ].reduce(&:merge)

    JSON.generate(speaker)
  end.yield_self { |s| JSON.parse(s) }
end

def github(username)
  return {} if username.nil?

  creds = [ENV["GITHUB_USERNAME"], ENV["GITHUB_PASSWORD"]]

  result = JSON.parse(URI.open("https://api.github.com/users/#{username}", http_basic_authentication: creds).read)

  {
    "name" => result.fetch("name"),
    "avatar" => result.fetch("avatar_url"),
    "url" => result.fetch("html_url"),
  }
end

def linkedin(username)
  return {} if username.nil?

  {
    "url" => "https://www.linkedin.com/in/#{username}/",
  }
end

def twitter(username)
  return {} if username.nil?

  {
    "url" => "https://twitter.com/#{username}",
  }
end
