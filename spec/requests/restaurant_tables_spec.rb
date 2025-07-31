require 'rails_helper'

RSpec.describe 'RestaurantTables', type: :request do
  let(:staff) { create(:user, role_type: :staff) }
  let(:restaurant) { create(:restaurant, user: staff) }

  before do
    sign_in staff
  end

  describe 'GET /restaurants/:restaurant_id/restaurant_tables' do
    before do
      create_list(:restaurant_table, 15, restaurant: restaurant, status: :available)
      create_list(:restaurant_table, 5, restaurant: restaurant, status: :reserved)
      create_list(:restaurant_table, 3, restaurant: restaurant, status: :occupied)
    end

    it 'paginates results (5 per page)' do
      get restaurant_restaurant_tables_path(restaurant), params: { page: 1 }
      expect(response.body).to include('table') # any table row will match
      expect(assigns(:tables).size).to eq(5)
    end

    it 'filters tables by status' do
      get restaurant_restaurant_tables_path(restaurant), params: { status: 'reserved' }
      expect(assigns(:tables).pluck(:status)).to all(eq('reserved'))
    end

    it 'sorts by table_number ascending' do
      get restaurant_restaurant_tables_path(restaurant), params: { sort: 'table_number', direction: 'asc' }
      expect(assigns(:tables)).to eq(assigns(:tables).sort_by(&:table_number))
    end

    it 'sorts by seats descending' do
      get restaurant_restaurant_tables_path(restaurant), params: { sort: 'seats', direction: 'desc' }
      expect(assigns(:tables)).to eq(assigns(:tables).sort_by(&:seats).reverse)
    end

    it 'defaults to descending order if invalid params' do
      get restaurant_restaurant_tables_path(restaurant), params: { sort: 'invalid', direction: 'bad' }
      expect(assigns(:tables)).to eq(assigns(:tables).sort_by(&:created_at).reverse)
    end

    it 'returns only staff access' do
      sign_out staff
      customer = create(:user, role_type: :customer)
      sign_in customer

      get restaurant_restaurant_tables_path(restaurant)
      expect(response).to redirect_to(root_path)
      follow_redirect!
      expect(response.body).to include('Access denied')
    end
  end
end
