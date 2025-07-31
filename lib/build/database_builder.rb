# frozen_string_literal: true

module Build
  class DatabaseBuilder
    def reset_data
      puts 'Cleaning database...'
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

    def execute
      reset_data
      users = create_users
      create_restaurants(users)
    end

    def run
      execute
    end
  end
end
