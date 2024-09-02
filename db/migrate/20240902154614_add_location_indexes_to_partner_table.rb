class AddLocationIndexesToPartnerTable < ActiveRecord::Migration[7.1]
  def change
    add_index :partners, :location, using: :gist     
    add_index :partners, [:latitude, :longitude]
  end
end
