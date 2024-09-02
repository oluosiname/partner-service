class CreatePartners < ActiveRecord::Migration[7.1]
  def change
    create_table :partners do |t|
      t.string :name, null: false
      t.float :latitude, null: false                   
      t.float :longitude, null: false                  
      t.st_point :location, geographic: true, null: false  # PostGIS point type for geospatial queries
      t.float :operating_radius, null: false           # Operating radius in kilometers
      t.float :rating, null: false, default: 0.0       
      t.timestamps
    end
  end
end
