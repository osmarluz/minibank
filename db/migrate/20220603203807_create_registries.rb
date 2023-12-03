# frozen_string_literal: true

class CreateRegistries < ActiveRecord::Migration[7.0]
  def change
    create_table :registries do |t|
      t.string :source
      t.string :external_id

      t.timestamps
    end
  end
end
