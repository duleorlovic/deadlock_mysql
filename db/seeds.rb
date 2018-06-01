_bob = Farmer.where(name: 'Bob', coin: 100).first_or_create!
jack = Farmer.where(name: 'Jack', coin: 100).first_or_create!
Tractor.where(model: 'Massey', farmer: jack).first_or_create!
Tractor.where(model: 'John Deere', farmer: jack).first_or_create!
