class CreatePartnerMaterials < ActiveRecord::Migration[7.1]
  def change
    create_table :partner_materials do |t|
      t.references :partner, null: false, foreign_key: true
      t.references :material, null: false, foreign_key: true

      t.timestamps
    end

    add_index :partner_materials, [:partner_id, :material_id], unique: true
  end
end
