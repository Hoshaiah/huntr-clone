class Activity < ApplicationRecord
    belongs_to :card
    validates :title, :tag, presence: true
end
