# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)


Twit.create!(content: "My first tweet", link: "https://twitter.com/Jean_Voix/status/770538259197800448", like: "10", retweet: "5")
Twit.create!(content: "My second tweet", link: "https://twitter.com/Jean_Voix/status/770538555089321984", like: "20", retweet: "10")
Twit.create!(content: "My third tweet", link: "https://twitter.com/Jean_Voix/status/770538756680085504", like: "30", retweet: "15")
