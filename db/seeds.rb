puts "Seeding Digestif..."

# Create users
users_data = [
  { username: "alice", email_address: "alice@example.com" },
  { username: "bob", email_address: "bob@example.com" },
  { username: "carol", email_address: "carol@example.com" },
  { username: "dave", email_address: "dave@example.com" },
  { username: "eve", email_address: "eve@example.com" },
  { username: "frank", email_address: "frank@example.com" },
  { username: "grace", email_address: "grace@example.com" },
  { username: "hank", email_address: "hank@example.com" },
  { username: "iris", email_address: "iris@example.com" },
  { username: "jack", email_address: "jack@example.com" },
]

users = users_data.map do |data|
  User.find_or_create_by!(email_address: data[:email_address]) do |u|
    u.username = data[:username]
    u.password = "password123"
    u.password_confirmation = "password123"
  end
end

puts "  Created #{users.size} users (password: password123)"

# Posts content
posts_content = [
  "Finally finished reading that book I started three months ago. The ending was absolutely worth it.",
  "Made sourdough from scratch today. It actually turned out decent for once. The secret is patience, apparently.",
  "Took the long way home through the park. The cherry blossoms are starting to bloom and it made my whole day better.",
  "Had one of those conversations with an old friend where you pick up exactly where you left off. So grateful for people like that.",
  "Tried a new coffee shop downtown. The barista remembered my name on the second visit. Small things matter.",
  "Spent the afternoon teaching my kid to ride a bike. More falls than successes but the grin on her face was everything.",
  "Sometimes the best thing you can do is absolutely nothing. Hammock. Book. Lemonade. That's it.",
  "Cooked dinner for the neighbors who just had a baby. Lasagna solves most problems, I've found.",
  "Watched the sunset from the roof tonight. The sky turned this impossible shade of orange. No photo could capture it.",
  "Started learning piano again after 15 years. My fingers remember more than I expected.",
  "Ran into my high school teacher at the grocery store. She said she always knew I'd figure things out. Made my week.",
  "The garden is coming along. First tomatoes should be ready in a few weeks. There's something deeply satisfying about growing your own food.",
  "Power went out for three hours. Lit some candles, played board games with the family. Honestly, it was the best evening we've had in months.",
  "Walked 10,000 steps today without even trying. Got lost in a podcast about the history of maps. Ironic.",
  "Made my grandmother's soup recipe from memory. It's not quite right but it's close enough to make me smile and miss her.",
  "Rainy day. Stayed in. Reorganized the bookshelf by color instead of author. Chaotic but beautiful.",
  "Had the best cup of tea of my life at a tiny place with no sign on the door. Some things you just stumble into.",
  "Finished a puzzle that's been sitting on the dining table for two weeks. 1000 pieces of a Van Gogh. Worth every piece.",
  "Biked to work today for the first time. Arrived sweaty but happy. Might make this a habit.",
  "Sat in the park and sketched for an hour. Nothing good, but that wasn't the point.",
  "Today I learned that octopuses have three hearts. Two for the gills, one for the body. Nature is wild.",
  "Fixed the squeaky door that's been driving me crazy for six months. Took five minutes. Why did I wait so long?",
  "Volunteered at the food bank this morning. Perspective is a powerful thing.",
  "Tried to meditate for 10 minutes. Managed about 3 before my brain went full squirrel. Progress, not perfection.",
  "The fog rolled in this evening and the whole city looked like a dream. Walked around in it just to feel small.",
  "Baked cookies for no reason. Gave half to the mail carrier. Their smile was the best part of my day.",
  "Read my kid's favorite book for the 400th time. Still finding new things in the illustrations.",
  "Listened to an album start to finish with no distractions. When was the last time you did that?",
  "Planted a tree in the backyard today. I like the idea of it being there long after I'm gone.",
  "Had a perfect nap on the couch. The kind where you wake up not knowing what year it is. Glorious.",
]

shuffled = posts_content.shuffle

# Create posts for the past 7 days (including yesterday so today's digest has content)
7.downto(0) do |days_ago|
  date = days_ago.days.ago
  users.each do |user|
    # ~70% chance of posting on any given day, but guarantee yesterday has good coverage
    next if days_ago != 1 && rand > 0.7
    # For yesterday, 90% chance so digest is full
    next if days_ago == 1 && rand > 0.9

    content = shuffled.pop || posts_content.sample
    post = Post.new(
      user: user,
      body: content,
      published_at: date.change(hour: rand(7..22), min: rand(0..59)),
      created_at: date,
      updated_at: date
    )
    post.save!(validate: false)
  end
end

puts "  Created #{Post.count} posts over the past week"

# Create follow relationships - everyone follows a few people
users.each do |user|
  others = users.reject { |u| u == user }
  to_follow = others.sample(rand(3..6))
  to_follow.each { |other| user.follow(other) }
end

puts "  Created #{Follow.count} follow relationships"
puts "Done! Sign in with any user (e.g. alice@example.com / password123)"
