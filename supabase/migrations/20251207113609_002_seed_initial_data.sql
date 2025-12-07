/*
  # Seed Initial Room Data
  
  Creates the room inventory for 569 on Berea with rates and configurations
*/

INSERT INTO rooms (name, room_number, type, rate_per_night, weekend_rate, max_guests, description, amenities) VALUES
  (
    'Room 1 - King Suite',
    '1',
    'Suite',
    900.00,
    1100.00,
    2,
    'Spacious king suite with en-suite bathroom, work area',
    ARRAY['King Bed', 'WiFi', 'AC', 'TV', 'Work Desk', 'Private Bathroom', 'Mini Fridge']
  ),
  (
    'Room 2 - Twin Room',
    '2',
    'Standard',
    750.00,
    900.00,
    2,
    'Comfortable twin beds room with shared facilities',
    ARRAY['Twin Beds', 'WiFi', 'AC', 'TV', 'Shared Bathroom']
  ),
  (
    'Room 3 - Queen Room',
    '3',
    'Standard',
    800.00,
    950.00,
    2,
    'Queen bed room with en-suite bathroom',
    ARRAY['Queen Bed', 'WiFi', 'AC', 'TV', 'Private Bathroom']
  ),
  (
    'Room 4 - Single Room',
    '4',
    'Budget',
    600.00,
    750.00,
    1,
    'Compact single room, ideal for business travelers',
    ARRAY['Single Bed', 'WiFi', 'AC', 'Shared Bathroom']
  ),
  (
    'Room 5 - Family Suite',
    '5',
    'Suite',
    1200.00,
    1400.00,
    4,
    'Large family suite with separate living area',
    ARRAY['Double Bed + Twin Beds', 'WiFi', 'AC', 'TV', 'Kitchenette', 'Private Bathroom']
  )
ON CONFLICT (name) DO NOTHING;