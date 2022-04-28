class Kanban < ApplicationRecord
    belongs_to :user
    has_many :kanban_columns, dependent: :destroy
    has_many :cards, through: :kanban_columns
    has_many :activities, through: :cards
    validate :save_kanban?, :on => :create

    KANBAN_COLUMNS = ['WISHLIST','APPLIED','INTERVIEW','OFFER RECEIVED','OFFER ACCEPTED', 'OFFER REJECTED', 'REJECTED']

    def create_default_columns
        KANBAN_COLUMNS.each do |column|
            self.kanban_columns.create(name: column)
        end 
    end

    def create_column_graph_data(from_date, to_date)
        from_date = from_date.nil? ? 1.month.ago.beginning_of_day : from_date.to_date.beginning_of_day
        to_date = to_date.nil? ? Date.current.end_of_day : to_date.to_date.end_of_day
        columns = self.kanban_columns.where(name: ["WISHLIST", "APPLIED", "INTERVIEW", "OFFER RECEIVED"])
        hash_format = {}
    
        columns.each do |column|
          hash_format[column.name] = column.cards.where(created_at: from_date..to_date).count
        end
        
        hash_format
      end

    private

    def save_kanban?
        if Current.user.premium == false && Current.user.kanbans.count >= 1
            errors.add(:kanbans, message: "Please upgrade to premium to create more boards!")
            return false
        end
    end

end
