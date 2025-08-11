require 'rails_helper'

RSpec.describe 'RestaurantTables', type: :request do
  let!(:staff) { create(:user, :staff) }
  let!(:restaurant) { create(:restaurant, user: staff) }

  before do
    post user_session_path, params: {
      user: {
        email: staff.email,
        password: staff.password
      }
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

    it 'displays edit and delete buttons for each table' do
      get restaurant_restaurant_tables_path(restaurant), params: { page: 1 }
      doc = Nokogiri::HTML(response.body)
      rows = doc.css('table tbody tr')

      rows.each do |row|
        expect(row.inner_html).to include('fa-pen-to-square')
        expect(row.inner_html).to include('fa-trash')
      end
    end

    # Additional examples start here
    it 'paginates results to 10 per page' do
      get restaurant_restaurant_tables_path(restaurant), params: { page: 1 }
      doc = Nokogiri::HTML(response.body)
      expect(doc.css('table tbody tr').count).to eq(10)
    end

    it 'shows correct results on second page' do
      get restaurant_restaurant_tables_path(restaurant), params: { page: 2 }
      doc = Nokogiri::HTML(response.body)
      expect(doc.css('table tbody tr').count).to be > 0
    end

    it 'returns all statuses when no filter is applied' do
      get restaurant_restaurant_tables_path(restaurant)
      doc = Nokogiri::HTML(response.body)
      statuses = doc.css('table tbody tr td:nth-child(3)').map(&:text).uniq
      expect(statuses).to include('available', 'reserved', 'occupied')
    end

    it 'ignores invalid sort params and returns default order' do
      get restaurant_restaurant_tables_path(restaurant), params: { sort: 'invalid_column', direction: 'asc' }
      expect(response).to have_http_status(:ok)
    end

    it 'ignores invalid direction params and defaults to asc' do
      get restaurant_restaurant_tables_path(restaurant), params: { sort: 'table_number', direction: 'invalid' }
      expect(response).to have_http_status(:ok)
    end

    it 'returns empty table list if no tables match filter' do
      get restaurant_restaurant_tables_path(restaurant), params: { status: 'nonexistent' }
      doc = Nokogiri::HTML(response.body)
      expect(doc.css('table tbody tr').count).to eq(0)
    end

    it 'displays table numbers in ascending order when no sort params are given' do
      get restaurant_restaurant_tables_path(restaurant)
      doc = Nokogiri::HTML(response.body)
      numbers = doc.css('table tbody tr td:first-child').map(&:text).map(&:to_i)
      expect(numbers).to eq(numbers.sort)
    end

    it 'handles large number of records without error' do
      create_list(:restaurant_table, 50, restaurant: restaurant)
      get restaurant_restaurant_tables_path(restaurant)
      expect(response).to have_http_status(:ok)
    end

    it 'shows status badges in the table list' do
      get restaurant_restaurant_tables_path(restaurant)
      doc = Nokogiri::HTML(response.body)
      expect(doc.css('.badge').count).to be > 0
    end

    it 'includes link to create a new table' do
      get restaurant_restaurant_tables_path(restaurant)
      doc = Nokogiri::HTML(response.body)
      expect(doc.css("a[href='#{new_restaurant_restaurant_table_path(restaurant)}']").count).to be > 0
    end
  end
end
