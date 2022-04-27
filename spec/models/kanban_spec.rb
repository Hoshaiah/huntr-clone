require 'rails_helper'

RSpec.describe Kanban, type: :model do
  context 'after creating a kanban' do
    fixtures :users

    it 'should output true if name and user_id are provided ' do
      kanban = Kanban.new(user: users(:mark), name: "test")
      output = kanban.save
      expect(output).to eq(true)
    end

    it 'should output false if name is not provided' do
      kanban = Kanban.new(user: users(:mark))
      output = kanban.save
      expect(output). to eq(false)
    end

    it 'should output false if user_id is not provided' do
      kanban = Kanban.new(name: "test")
      output = kanban.save
      expect(output). to eq(false)
    end
  end
end
