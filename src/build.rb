require_relative './speaker.rb'

Dir['data/speakers/*.yml']
  .each { |filename| speaker(filename) }

`mkdir -p build/`

%w[
  index
  podcast
  previous
  speak
  slides
].each do |page|
  if File.exists?("src/pages/#{page}.rb")
    `ruby src/pages/#{page}.rb`
  else
    `cp src/pages/#{page}.html build/#{page}.html`
  end
end

`cp src/main.css build/main.css`
`cp -r src/fonts build/fonts`
`cp -r data/slides build/slides`
`cp -r data/sponsors build/sponsors`
