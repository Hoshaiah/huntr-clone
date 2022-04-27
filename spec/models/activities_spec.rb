require 'rails_helper'

RSpec.describe Activity, type: :model do
    
    context 'after creating an activity' do
        fixtures :cards

        before do
            def build_activity(card: cards(:avion_engineer), tag: "Applied", title: "Apply")
                Activity.new(card: card, tag: tag, title: title)
            end
        end

        it 'should output true if card, tag, and title are provided' do
            activity = build_activity()
            output = activity.save
            expect(output).to eq(true)
        end

        it 'should output false if card is not provided ' do
            activity = build_activity(card: nil)
            output = activity.save
            expect(output).to eq(false)
        end

        it 'should output false if tag is not provided ' do
            activity = build_activity(tag: nil)
            output = activity.save
            expect(output).to eq(false)
        end

        it 'should output false if title is not provided ' do
            activity = build_activity(title: nil)
            output = activity.save
            expect(output).to eq(false)
        end
    end
end
