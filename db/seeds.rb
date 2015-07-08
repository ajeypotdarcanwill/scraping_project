# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

URL = "http://www.yellowpages.ca/bus/Ontario/Mississauga/Gabriel-s-Restaurant-Bar-Grill/2280895.html?what=restaurants&where=Mississauga,+ON&useContext=true"

#creating a dummy url for testing purpose.
BusinessUrl.where(url: URL).first_or_create