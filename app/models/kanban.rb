class Kanban < ApplicationRecord
    belongs_to :user
    has_many :kanban_columns, dependent: :destroy
    has_many :cards, through: :kanban_columns
    has_many :activities, through: :cards

    KANBAN_COLUMNS = ['WISHLIST','APPLIED','INTERVIEW','OFFER RECIEVED','OFFER ACCEPTED', 'OFFER REJECTED', 'REJECTED']

    def create_default_columns
        KANBAN_COLUMNS.each do |column|
            self.kanban_columns.create(name: column)
        end 
    end

end
