# frozen_string_literal: true

class CreateTransactions < ActiveRecord::Migration[7.0]
  def change
    create_table :transactions do |t|
      t.string :kind
      t.decimal :amount
      t.string :description
      t.references :clinic, null: false, index: true, foreign_key: true

      t.timestamps
    end
  end
end
