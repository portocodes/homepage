require_relative './speaker.rb'

Dir['data/speakers/*.yml']
  .each { |filename| speaker(filename) }

%w[
  index
  podcast
  previous
  speak
].each do |page|
  if File.exists?("src/pages/#{page}.rb")
    `ruby src/pages/#{page}.rb`
  else
    `cp src/pages/#{page}.html build/#{page}.html`
  end
end

`cp src/main.css build/main.css`
