# frozen_string_literal: true

module Build
  class DatabaseBuilder
    def reset_data
      puts 'Cleaning database...'

      # Delete in correct order to avoid foreign key violation
      RestaurantTable.destroy_all
      Restaurant.destroy_all
      User.destroy_all
    end

    def create_users
      puts 'Creating users...'
      10.times.map do
        User.create!(
          first_name: Faker::Name.first_name,
          last_name: Faker::Name.last_name,
          email: Faker::Internet.unique.email,
          age: rand(1..99),
          date_of_birth: Faker::Date.birthday(min_age: 1, max_age: 99),
          phone_number: Faker::PhoneNumber.cell_phone_in_e164,
          password: 'password',
          password_confirmation: 'password',
          role_type: :customer,
          account_status: :active
        )
      end
    end

    def create_restaurants(users)
      puts 'Creating restaurants...'

      statuses = %i[open closed archived]

      statuses.each do |status|
        20.times do
          user = users.sample
          restaurant = user.restaurants.new(
            name: Faker::Restaurant.name,
            description: Faker::Restaurant.description,
            location: Faker::Address.city,
            cuisine_type: Faker::Restaurant.type,
            rating: rand(1..5),
            note: Faker::Lorem.sentence,
            likes: rand(0..100)
          )
          restaurant.aasm_state = status.to_s
          restaurant.save!
        end
      end

      puts 'Done creating restaurants!'
    end

    def create_tables_for_restaurants
      puts 'Creating tables for each restaurant...'

      statuses = %i[available reserved occupied]

      Restaurant.find_each do |restaurant|
        10.times do |i|
          restaurant.restaurant_tables.create!(
            table_number: "T#{i + 1}",
            seats: [2, 4, 6].sample,
            status: statuses.sample
          )
        end
      end

      puts 'Done creating tables!'
    end

    def execute
      reset_data
      users = create_users
      create_restaurants(users)
      create_tables_for_restaurants
    end

    def run
      execute
    end
  end
end
