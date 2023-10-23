# frozen_string_literal: true

class Pollable::Option < ApplicationRecord
  self.abstract_class = true
  self.table_name = "pollable_options"

  belongs_to :pollable, polymorphic: true
end
