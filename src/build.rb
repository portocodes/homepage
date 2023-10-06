`rm -rf build/`
`mkdir -p build/`

%w[
  index
  previous
  speak
  slides
  title
  hacktoberfest2019
  hacktoberfest2019location
].each do |page|
  if File.exist?("src/pages/#{page}.rb")
    print `ruby src/pages/#{page}.rb`
  else
    `cp src/pages/#{page}.html build/#{page}.html`
  end
end

`cp src/main.css build/main.css`
`cp -r src/fonts build/fonts`
`cp -r src/images build/images`
`cp -r data/slides build/slides`
`cp -r data/sponsors build/sponsors`
