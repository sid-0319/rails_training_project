require 'rails_helper'

RSpec.describe 'MenuItems', type: :request do
  let!(:restaurant) { create(:restaurant) }
  let!(:menu_item) { create(:menu_item, restaurant: restaurant) }

  describe 'GET /index' do
    it 'renders a successful response' do
      get restaurant_menu_items_path(restaurant)
      expect(response).to be_successful
    end
  end

  describe 'GET /new' do
    it 'renders a successful response' do
      get new_restaurant_menu_item_path(restaurant)
      expect(response).to be_successful
    end
  end

  describe 'POST /create' do
    context 'with valid parameters' do
      let(:valid_params) do
        { menu_item: { item_name: 'New Item', description: 'Delicious', price: 9.99, category: 'Appetizer' } }
      end

      it 'creates a new MenuItem' do
        expect do
          post restaurant_menu_items_path(restaurant), params: valid_params
        end.to change(MenuItem, :count).by(1)
      end

      it 'redirects to the menu items list' do
        post restaurant_menu_items_path(restaurant), params: valid_params
        expect(response).to redirect_to(restaurant_menu_items_path(restaurant))
        follow_redirect!
        expect(response.body).to include('Menu item created.')
      end
    end

    context 'with invalid parameters' do
      let(:invalid_params) do
        { menu_item: { item_name: '', price: nil } }
      end

      it 'does not create a new MenuItem' do
        expect do
          post restaurant_menu_items_path(restaurant), params: invalid_params
        end.to change(MenuItem, :count).by(0)
      end

      it 'renders the new template with an unprocessable entity status' do
        post restaurant_menu_items_path(restaurant), params: invalid_params
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response).to render_template(:new)
      end
    end
  end

  describe 'GET /edit' do
    it 'renders a successful response' do
      get edit_restaurant_menu_item_path(restaurant, menu_item)
      expect(response).to be_successful
    end
  end

  describe 'PATCH /update' do
    context 'with valid parameters' do
      let(:new_attributes) do
        { item_name: 'Updated Name', price: 15.00 }
      end

      it 'updates the requested menu item' do
        patch restaurant_menu_item_path(restaurant, menu_item), params: { menu_item: new_attributes }
        menu_item.reload
        expect(menu_item.item_name).to eq('Updated Name')
        expect(menu_item.price).to eq(15.00)
      end

      it 'redirects to the menu items list' do
        patch restaurant_menu_item_path(restaurant, menu_item), params: { menu_item: new_attributes }
        expect(response).to redirect_to(restaurant_menu_items_path(restaurant))
        follow_redirect!
        expect(response.body).to include('Menu item updated.')
      end
    end

    context 'with invalid parameters' do
      let(:invalid_attributes) do
        { item_name: '', price: nil }
      end

      it 'does not update the menu item' do
        original_name = menu_item.item_name
        patch restaurant_menu_item_path(restaurant, menu_item), params: { menu_item: invalid_attributes }
        menu_item.reload
        expect(menu_item.item_name).to eq(original_name)
      end

      it 'renders the edit template with an unprocessable entity status' do
        patch restaurant_menu_item_path(restaurant, menu_item), params: { menu_item: invalid_attributes }
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response).to render_template(:edit)
      end
    end
  end

  describe 'DELETE /destroy' do
    it 'destroys the requested menu item' do
      expect do
        delete restaurant_menu_item_path(restaurant, menu_item)
      end.to change(MenuItem, :count).by(-1)
    end

    it 'redirects to the menu items list' do
      delete restaurant_menu_item_path(restaurant, menu_item)
      expect(response).to redirect_to(restaurant_menu_items_path(restaurant))
      follow_redirect!
      expect(response.body).to include('Menu item deleted.')
    end
  end
end
