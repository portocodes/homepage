all:
	sh -c 'env $$(cat .env) ruby src/build.rb'

desc:
	ruby src/meetup-description.rb

dates:
	ruby src/dates.rb
