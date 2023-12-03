# frozen_string_literal: true

class AddBalanceToClinics < ActiveRecord::Migration[7.0]
  def change
    add_column :clinics, :balance, :decimal, default: 0.0
  end
end
