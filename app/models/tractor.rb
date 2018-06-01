class Tractor < ApplicationRecord
  belongs_to :farmer
  after_update :set_coin

  def set_coin
    farmer.coin += 1
    farmer.save!
  end

  def transfer_to!(new_farmer, price)
    # Tractor.transaction do
      old_farmer = self.farmer
      self.farmer = new_farmer
      puts "#{farmer.name} is new owner"
      sleep 5
      save!
      puts "Adjust coins"
      farmer.coin += price
      farmer.save!
      old_farmer.coin -= price
      old_farmer.save!
    # end
  end
end
