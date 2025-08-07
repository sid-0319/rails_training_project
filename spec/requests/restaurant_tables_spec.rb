require 'rails_helper'

RSpec.describe 'RestaurantTables', type: :request do
  let!(:staff) { create(:user, :staff) }
  let!(:restaurant) { create(:restaurant, user: staff) }

  before do
    # Set Devise mapping manually if you use a custom scope in devise_for
    post user_session_path, params: {
      user: {
        email: staff.email,
        password: staff.password
      }
    }
    follow_redirect! # if redirect after login
  end

  describe 'GET /restaurants/:restaurant_id/restaurant_tables' do
    before do
      create_list(:restaurant_table, 15, restaurant: restaurant, status: :available)
      create_list(:restaurant_table, 5, restaurant: restaurant, status: :reserved)
      create_list(:restaurant_table, 3, restaurant: restaurant, status: :occupied)
    end

    it 'paginates results (5 per page)' do
      get restaurant_restaurant_tables_path(restaurant), params: { page: 1 }
      doc = Nokogiri::HTML(response.body)
      rows = doc.css('table tbody tr')
      expect(rows.size).to eq(5)
    end

    it 'filters tables by status' do
      get restaurant_restaurant_tables_path(restaurant), params: { status: 'reserved' }
      doc = Nokogiri::HTML(response.body)
      rows = doc.css('table tbody tr')
      rows.each do |row|
        expect(row.text).to include('reserved')
      end
    end

    it 'sorts by table_number ascending' do
      get restaurant_restaurant_tables_path(restaurant), params: { sort: 'table_number', direction: 'asc' }
      doc = Nokogiri::HTML(response.body)
      numbers = doc.css('table tbody tr td:first-child').map(&:text).map(&:to_i)
      expect(numbers).to eq(numbers.sort)
    end

    it 'sorts by seats descending' do
      get restaurant_restaurant_tables_path(restaurant), params: { sort: 'seats', direction: 'desc' }
      doc = Nokogiri::HTML(response.body)
      seats = doc.css('table tbody tr td:nth-child(2)').map(&:text).map(&:to_i)
      expect(seats).to eq(seats.sort.reverse)
    end

    it 'defaults to descending order if invalid params' do
      get restaurant_restaurant_tables_path(restaurant), params: { sort: 'invalid', direction: 'bad' }
      doc = Nokogiri::HTML(response.body)
      expect(doc.css('table tbody tr').count).to be > 0
    end

    it 'returns only staff access' do
      sign_out staff
      customer = create(:user, :customer)
      sign_in customer

      get restaurant_restaurant_tables_path(restaurant)
      expect(response).to redirect_to(root_path)
      follow_redirect!
      expect(response.body).to include('Access denied')
    end

    it 'displays edit and delete buttons for each table' do
      get restaurant_restaurant_tables_path(restaurant), params: { page: 1 }
      doc = Nokogiri::HTML(response.body)
      rows = doc.css('table tbody tr')

      rows.each do |row|
        expect(row.inner_html).to include('fa-pen-to-square') # edit icon
        expect(row.inner_html).to include('fa-trash')         # delete icon
      end
    end
  end
end
