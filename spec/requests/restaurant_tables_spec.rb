require 'rails_helper'

RSpec.describe 'RestaurantTables', type: :request do
  let!(:staff) { create(:user, :staff) }
  let!(:restaurant) { create(:restaurant, user: staff) }
  let!(:table) { create(:restaurant_table, restaurant: restaurant, table_number: 10, seats: 4, status: :available) }

  before do
    post user_session_path, params: {
      user: { email: staff.email, password: staff.password }
    }
    follow_redirect!
  end

  describe 'GET /restaurants/:restaurant_id/restaurant_tables' do
    before do
      create_list(:restaurant_table, 15, restaurant: restaurant, status: :available)
      create_list(:restaurant_table, 5, restaurant: restaurant, status: :reserved)
      create_list(:restaurant_table, 3, restaurant: restaurant, status: :occupied)
    end

    it 'filters tables by status' do
      get restaurant_restaurant_tables_path(restaurant), params: { status: 'reserved' }
      doc = Nokogiri::HTML(response.body)
      doc.css('table tbody tr').each { |row| expect(row.text).to include('reserved') }
    end

    it 'sorts by table_number ascending' do
      get restaurant_restaurant_tables_path(restaurant), params: { sort: 'table_number', direction: 'asc' }
      numbers = Nokogiri::HTML(response.body).css('table tbody tr td:first-child').map(&:text).map(&:to_i)
      expect(numbers).to eq(numbers.sort)
    end

    it 'sorts by seats descending' do
      get restaurant_restaurant_tables_path(restaurant), params: { sort: 'seats', direction: 'desc' }
      seats = Nokogiri::HTML(response.body).css('table tbody tr td:nth-child(2)').map(&:text).map(&:to_i)
      expect(seats).to eq(seats.sort.reverse)
    end

    it 'displays edit and delete buttons for each table' do
      get restaurant_restaurant_tables_path(restaurant), params: { page: 1 }
      Nokogiri::HTML(response.body).css('table tbody tr').each do |row|
        expect(row.inner_html).to include('fa-pen-to-square')
        expect(row.inner_html).to include('fa-trash')
      end
    end
  end

  describe 'POST /restaurants/:restaurant_id/restaurant_tables' do
    it 'rejects negative seats' do
      post restaurant_restaurant_tables_path(restaurant),
           params: { restaurant_table: { table_number: 1, seats: -5, status: :available } }
      expect(response.body).to include('Seats must be greater than 0')
    end

    it 'rejects empty table number' do
      post restaurant_restaurant_tables_path(restaurant),
           params: { restaurant_table: { table_number: nil, seats: 4, status: :available } }
      expect(response.body).to include("Table number can't be blank")
    end

    it 'rejects empty seats' do
      post restaurant_restaurant_tables_path(restaurant),
           params: { restaurant_table: { table_number: 2, seats: nil, status: :available } }
      expect(response.body).to include("Seats can't be blank")
    end
  end

  describe 'PATCH /restaurants/:restaurant_id/restaurant_tables/:id' do
    it 'rejects negative seats on update' do
      patch restaurant_restaurant_table_path(restaurant, table), params: { restaurant_table: { seats: -10 } }
      follow_redirect!
      expect(response.body).to include('Seats must be greater than 0')
    end

    it 'rejects empty table number on update' do
      patch restaurant_restaurant_table_path(restaurant, table), params: { restaurant_table: { table_number: nil } }
      follow_redirect!
      expect(response.body).to include("Table number can't be blank")
    end

    it 'rejects empty seats on update' do
      patch restaurant_restaurant_table_path(restaurant, table), params: { restaurant_table: { seats: nil } }
      follow_redirect!
      expect(response.body).to include("Seats can't be blank")
    end
  end
end
