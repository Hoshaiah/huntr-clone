class Card < ApplicationRecord
  belongs_to :kanban_column
  has_many :activities
end
