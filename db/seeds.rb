require 'faker'

5.times do |i|
  User.create(
    id: i,
    first_name: Faker::Name.first_name,
    last_name: Faker::Name.first_name,
    legal_id_type: 'CC',
    legal_id: Faker::Number.number,
    email: Faker::Internet.email,
    phone: Faker::PhoneNumber.cell_phone,
    password: '123456',
    status: 'INACTIVE',
    is_verified: true,
    cognito_id: Faker::Number.number,
  )

  Lessor.create(
    id: i,
    legal_name: Faker::Company.name,
    legal_id_type: 'NIT',
    legal_id: Faker::Number.number,
    lessor_name: "#{Faker::Name.first_name} #{Faker::Name.last_name}",
    phone: Faker::PhoneNumber.cell_phone,
    email: Faker::Internet.email,
    address: Faker::Address.full_address,
    city: Faker::Address.city,
    status: 'ACTIVE',
    bank_account_type: 'SAVINGS',
    bank_account_number: Faker::Number.number,
    cognito_id: Faker::Number.number,
    description: Faker::Lorem.sentence,
    logo: Faker::Company.logo,
    password: '123456',
    is_verified: true
  )

  Spot.create(
    id: i,
    lessor_id: i,
    address: Faker::Address.full_address,
    city: Faker::Address.city,
    vehicle_type: 'CAR',
    status: 'AVAILABLE',
  )

  Reservation.create(
    id: i,
    user_id: i,
    spot_id: i,
    vehicle_plate: Faker::Vehicle.license_plate,
    reservation_type: 'ONE_TIME',
    check_out: Faker::Time.between(from: DateTime.now - 1,to: DateTime.now),
    check_in: Faker::Time.between(from: DateTime.now,to: DateTime.now + 1),
    status: 'ACTIVE',
    lessor_id: i,
  )

  Payment.create(
    id: i,
    user_id: i,
    reservation_id: i,
    lessor_id: i,
    spot_id: i,
    amount_in_cents: Faker::Number.between(from: 1000, to: 100000),
    status: 'APPROVED',
    payment_type: 'ONLINE',
  )
end
