module Build
  class DatabaseBuilder
    def reset_data
      puts "Cleaning database..."
      User.destroy_all
    end

    def create_users
      puts "Creating users..."
      10.times do
        User.create!(
          first_name: Faker::Name.first_name,
          last_name: Faker::Name.last_name,
          email: Faker::Internet.unique.email,
          age: rand(18..60),
          date_of_birth: Faker::Date.birthday(min_age: 18, max_age: 60),
          phone_number: Faker::PhoneNumber.cell_phone_in_e164,
          password: "password",
          password_confirmation: "password"
        )
      end
    end

    def execute
      reset_data
      create_users
    end

    def run
      execute
    end
  end
end