# frozen_string_literal: true

class CreateComments < ActiveRecord::Migration[7.0]
  def change
    create_table(:comments) do |t|
      t.belongs_to(:commentable, polymorphic: true)
      t.belongs_to(:author, class_name: "User")
      t.string(:body)

      t.timestamps
    end
  end
end
