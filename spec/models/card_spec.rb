require 'rails_helper'

RSpec.describe Card, type: :model do
    
    context 'after creating a card' do
        fixtures :kanban_columns, :users

        before do
            def build_card(kanban_column: kanban_columns(:wishlist), job_title: "engineer", company: "Avion", position: 1)
                Card.new(kanban_column: kanban_column, job_title: job_title, company: company, position: position)
            end
            Current.user = users(:mark)
        end

        it 'should output true if kanban_column, job_title, company, and position are provided ' do
            # card = Card.new(kanban_column: kanban_columns(:wishlist), job_title: "engineer", company: "Avion", position: 1)
            card = build_card()
            output = card.save
            expect(output).to eq(true)
        end

        it 'should output false if kanban_column is not provided' do
           card = build_card(kanban_column: nil) 
            output = card.save
            expect(output).to eq(false)
        end
        
        it 'should output false if job_title is not provided ' do
            card = build_card(job_title: nil)
            output = card.save
            expect(output).to eq(false)
        end

        it 'should output false if company is not provided ' do
            card = build_card(company: nil)
            output = card.save
            expect(output).to eq(false)
        end

        it 'should output false if position is not provided ' do
            card = build_card(position: nil)
            output = card.save
            expect(output).to eq(false)
        end
  end
end
