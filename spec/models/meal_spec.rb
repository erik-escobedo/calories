require 'rails_helper'

describe Meal do
  describe 'Validations' do
    let(:meal) { build(:meal) }

    it 'should be valid with valid data' do
      expect(meal).to be_valid
    end

    it 'should be invalid with no user' do
      meal.user_id = nil
      expect(meal).to_not be_valid
    end

    it 'should be invalid witout a taken_at datetime' do
      meal.taken_at = nil
      expect(meal).to_not be_valid
    end

    it 'should be invalid with no calories ammount' do
      meal.calories = nil
      expect(meal).to_not be_valid
    end

    it 'should be invalid with a negative calories ammount' do
      meal.calories = -100
      expect(meal).to_not be_valid
    end
  end

  describe 'Filter' do
    before(:all) do
      Time.zone = 'UTC'

      user = create(:user)
      @breakfasts = []
      @lunches    = []
      @dinners    = []

      5.times do |i|
        date = i.days.ago.to_date

        @breakfasts << create(:meal, {
          user: user,
          taken_at: "#{date.to_s} #{[8, 9, 10].sample}:#{rand(60)} AM"
        })

        @lunches << create(:meal, {
          user: user,
          taken_at: "#{date.to_s} #{[1, 2, 3].sample}:#{rand(60)} PM"
        })

        @dinners << create(:meal, {
          user: user,
          taken_at: "#{date.to_s} #{[7, 8, 9].sample}:#{rand(60)} PM"
        })
      end
    end

    it 'should filter by hour and date' do
      expect(
        Meal.filter({
          date_from: 5.days.ago.to_date,
          date_to: Date.today,
          time_from: '8:00 AM',
          time_to:   '11:00 AM'
        })
      ).to eq(@breakfasts)

      expect(
        Meal.filter({
          date_from: 3.days.ago.to_date,
          date_to:   3.days.ago.to_date,
          time_from: '1:00 PM',
          time_to:   '4:00 PM'
        })
      ).to eq([@lunches[3]])

      expect(
        Meal.filter({
          date_from: 4.days.ago.to_date,
          date_to:   1.days.ago.to_date,
          time_from: '7:00 PM',
          time_to:   '10:00 PM'
        })
      ).to eq(@dinners[1..4])
    end
  end
end
