/*
  # 569 on Berea - Complete Database Schema

  ## Overview
  This migration creates the complete database schema for the property management system.
  
  ## Tables Created
  1. **rooms** - Property room configuration
  2. **bookings** - Guest reservations and check-in/out management
  3. **guests** - Guest information and FICA compliance
  4. **income** - Revenue tracking
  5. **expenses** - Expense tracking and categorization
  6. **housekeeping_tasks** - Cleaning and maintenance tasks
  7. **groundskeeping_tasks** - Outdoor and pool maintenance tasks
  8. **maintenance_issues** - Issue tracking and resolution
  9. **daily_reports** - Manager daily financial reports
  10. **staff** - Staff member information and roles
  
  ## Security
  - RLS enabled on all tables
  - Role-based access policies (manager, housekeeper, groundskeeper, guest)
  - Authentication via Supabase Auth
*/

-- Enable necessary extensions
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- ========================================================================
-- ROOMS TABLE
-- ========================================================================

CREATE TABLE IF NOT EXISTS rooms (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  name text NOT NULL UNIQUE,
  room_number text NOT NULL,
  type text NOT NULL,
  rate_per_night numeric(10, 2) NOT NULL,
  weekend_rate numeric(10, 2) NOT NULL,
  max_guests integer DEFAULT 2,
  description text,
  amenities text[],
  active boolean DEFAULT true,
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now()
);

ALTER TABLE rooms ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Everyone can view active rooms"
  ON rooms FOR SELECT
  TO authenticated, anon
  USING (active = true);

CREATE POLICY "Only manager can manage rooms"
  ON rooms FOR INSERT
  TO authenticated
  WITH CHECK (auth.jwt()->>'role' = 'manager');

CREATE POLICY "Only manager can update rooms"
  ON rooms FOR UPDATE
  TO authenticated
  USING (auth.jwt()->>'role' = 'manager')
  WITH CHECK (auth.jwt()->>'role' = 'manager');

-- ========================================================================
-- BOOKINGS TABLE
-- ========================================================================

CREATE TABLE IF NOT EXISTS bookings (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  booking_ref text NOT NULL UNIQUE,
  room_id uuid NOT NULL REFERENCES rooms(id),
  guest_name text NOT NULL,
  guest_email text,
  guest_phone text NOT NULL,
  check_in_date date NOT NULL,
  check_out_date date NOT NULL,
  number_of_guests integer DEFAULT 1,
  source text DEFAULT 'Direct',
  status text DEFAULT 'Confirmed',
  notes text,
  rate_per_night numeric(10, 2),
  total_amount numeric(10, 2),
  deposit_amount numeric(10, 2) DEFAULT 500,
  deposit_method text,
  deposit_received boolean DEFAULT false,
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now()
);

ALTER TABLE bookings ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Manager can view all bookings"
  ON bookings FOR SELECT
  TO authenticated
  USING (auth.jwt()->>'role' = 'manager');

CREATE POLICY "Guests can view their own booking"
  ON bookings FOR SELECT
  TO authenticated
  USING (auth.jwt()->>'role' = 'guest' AND guest_email = auth.jwt()->>'email');

CREATE POLICY "Manager can create bookings"
  ON bookings FOR INSERT
  TO authenticated
  WITH CHECK (auth.jwt()->>'role' = 'manager');

CREATE POLICY "Manager can update bookings"
  ON bookings FOR UPDATE
  TO authenticated
  USING (auth.jwt()->>'role' = 'manager')
  WITH CHECK (auth.jwt()->>'role' = 'manager');

-- ========================================================================
-- GUESTS TABLE (FICA COMPLIANCE)
-- ========================================================================

CREATE TABLE IF NOT EXISTS guests (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  booking_id uuid NOT NULL REFERENCES bookings(id),
  full_name text NOT NULL,
  id_number text,
  id_type text,
  nationality text,
  address text,
  checked_in boolean DEFAULT false,
  check_in_time timestamptz,
  checked_out boolean DEFAULT false,
  check_out_time timestamptz,
  id_photo_path text,
  signed_acceptance boolean DEFAULT false,
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now()
);

ALTER TABLE guests ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Manager can view all guest records"
  ON guests FOR SELECT
  TO authenticated
  USING (auth.jwt()->>'role' = 'manager');

CREATE POLICY "Manager can create guest records"
  ON guests FOR INSERT
  TO authenticated
  WITH CHECK (auth.jwt()->>'role' = 'manager');

CREATE POLICY "Manager can update guest records"
  ON guests FOR UPDATE
  TO authenticated
  USING (auth.jwt()->>'role' = 'manager')
  WITH CHECK (auth.jwt()->>'role' = 'manager');

-- ========================================================================
-- INCOME TABLE
-- ========================================================================

CREATE TABLE IF NOT EXISTS income (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  transaction_date date NOT NULL,
  description text NOT NULL,
  category text NOT NULL,
  amount numeric(10, 2) NOT NULL,
  payment_method text,
  booking_id uuid REFERENCES bookings(id),
  received_by text,
  notes text,
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now()
);

ALTER TABLE income ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Manager can view all income"
  ON income FOR SELECT
  TO authenticated
  USING (auth.jwt()->>'role' = 'manager');

CREATE POLICY "Manager can create income"
  ON income FOR INSERT
  TO authenticated
  WITH CHECK (auth.jwt()->>'role' = 'manager');

CREATE POLICY "Manager can update income"
  ON income FOR UPDATE
  TO authenticated
  USING (auth.jwt()->>'role' = 'manager')
  WITH CHECK (auth.jwt()->>'role' = 'manager');

-- ========================================================================
-- EXPENSES TABLE
-- ========================================================================

CREATE TABLE IF NOT EXISTS expenses (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  transaction_date date NOT NULL,
  description text NOT NULL,
  category text NOT NULL,
  amount numeric(10, 2) NOT NULL,
  payment_method text,
  receipt_number text,
  paid_by text,
  approved_by text,
  notes text,
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now()
);

ALTER TABLE expenses ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Manager can view all expenses"
  ON expenses FOR SELECT
  TO authenticated
  USING (auth.jwt()->>'role' = 'manager');

CREATE POLICY "Manager can create expenses"
  ON expenses FOR INSERT
  TO authenticated
  WITH CHECK (auth.jwt()->>'role' = 'manager');

CREATE POLICY "Manager can update expenses"
  ON expenses FOR UPDATE
  TO authenticated
  USING (auth.jwt()->>'role' = 'manager')
  WITH CHECK (auth.jwt()->>'role' = 'manager');

-- ========================================================================
-- HOUSEKEEPING TASKS TABLE
-- ========================================================================

CREATE TABLE IF NOT EXISTS housekeeping_tasks (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  task_date date NOT NULL,
  room_id uuid REFERENCES rooms(id),
  task_type text NOT NULL,
  priority text DEFAULT 'Normal',
  assigned_to text,
  status text DEFAULT 'Pending',
  completed_at timestamptz,
  completed_by text,
  notes text,
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now()
);

ALTER TABLE housekeeping_tasks ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Manager can view all housekeeping tasks"
  ON housekeeping_tasks FOR SELECT
  TO authenticated
  USING (auth.jwt()->>'role' = 'manager');

CREATE POLICY "Housekeepers can view their tasks"
  ON housekeeping_tasks FOR SELECT
  TO authenticated
  USING (auth.jwt()->>'role' = 'housekeeper' OR auth.jwt()->>'role' = 'manager');

CREATE POLICY "Manager can create tasks"
  ON housekeeping_tasks FOR INSERT
  TO authenticated
  WITH CHECK (auth.jwt()->>'role' = 'manager');

CREATE POLICY "Authorized users can update tasks"
  ON housekeeping_tasks FOR UPDATE
  TO authenticated
  USING (auth.jwt()->>'role' IN ('manager', 'housekeeper'))
  WITH CHECK (auth.jwt()->>'role' IN ('manager', 'housekeeper'));

-- ========================================================================
-- GROUNDSKEEPING TASKS TABLE
-- ========================================================================

CREATE TABLE IF NOT EXISTS groundskeeping_tasks (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  task_date date NOT NULL,
  task_type text NOT NULL,
  priority text DEFAULT 'Normal',
  location text,
  assigned_to text,
  status text DEFAULT 'Pending',
  completed_at timestamptz,
  completed_by text,
  notes text,
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now()
);

ALTER TABLE groundskeeping_tasks ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Manager can view all groundskeeping tasks"
  ON groundskeeping_tasks FOR SELECT
  TO authenticated
  USING (auth.jwt()->>'role' = 'manager');

CREATE POLICY "Groundskeepers can view their tasks"
  ON groundskeeping_tasks FOR SELECT
  TO authenticated
  USING (auth.jwt()->>'role' = 'groundskeeper' OR auth.jwt()->>'role' = 'manager');

CREATE POLICY "Manager can create tasks"
  ON groundskeeping_tasks FOR INSERT
  TO authenticated
  WITH CHECK (auth.jwt()->>'role' = 'manager');

CREATE POLICY "Authorized users can update tasks"
  ON groundskeeping_tasks FOR UPDATE
  TO authenticated
  USING (auth.jwt()->>'role' IN ('manager', 'groundskeeper'))
  WITH CHECK (auth.jwt()->>'role' IN ('manager', 'groundskeeper'));

-- ========================================================================
-- MAINTENANCE ISSUES TABLE
-- ========================================================================

CREATE TABLE IF NOT EXISTS maintenance_issues (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  reported_date date NOT NULL,
  location text NOT NULL,
  description text NOT NULL,
  priority text DEFAULT 'Normal',
  reported_by text,
  assigned_to text,
  status text DEFAULT 'Open',
  resolved_at timestamptz,
  resolution_notes text,
  cost numeric(10, 2),
  approved_by text,
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now()
);

ALTER TABLE maintenance_issues ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Manager can view all maintenance issues"
  ON maintenance_issues FOR SELECT
  TO authenticated
  USING (auth.jwt()->>'role' = 'manager');

CREATE POLICY "Staff can view maintenance issues"
  ON maintenance_issues FOR SELECT
  TO authenticated
  USING (auth.jwt()->>'role' IN ('housekeeper', 'groundskeeper', 'manager'));

CREATE POLICY "Manager can create issues"
  ON maintenance_issues FOR INSERT
  TO authenticated
  WITH CHECK (auth.jwt()->>'role' IN ('manager', 'housekeeper', 'groundskeeper'));

CREATE POLICY "Manager can update issues"
  ON maintenance_issues FOR UPDATE
  TO authenticated
  USING (auth.jwt()->>'role' = 'manager')
  WITH CHECK (auth.jwt()->>'role' = 'manager');

-- ========================================================================
-- DAILY REPORTS TABLE
-- ========================================================================

CREATE TABLE IF NOT EXISTS daily_reports (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  report_date date NOT NULL UNIQUE,
  rooms_occupied integer,
  revenue numeric(10, 2),
  expenses numeric(10, 2),
  cash_on_hand numeric(10, 2),
  deposits_held numeric(10, 2),
  notes text,
  submitted_by text,
  submitted_at timestamptz,
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now()
);

ALTER TABLE daily_reports ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Manager can view all reports"
  ON daily_reports FOR SELECT
  TO authenticated
  USING (auth.jwt()->>'role' = 'manager');

CREATE POLICY "Manager can create reports"
  ON daily_reports FOR INSERT
  TO authenticated
  WITH CHECK (auth.jwt()->>'role' = 'manager');

CREATE POLICY "Manager can update reports"
  ON daily_reports FOR UPDATE
  TO authenticated
  USING (auth.jwt()->>'role' = 'manager')
  WITH CHECK (auth.jwt()->>'role' = 'manager');

-- ========================================================================
-- STAFF TABLE
-- ========================================================================

CREATE TABLE IF NOT EXISTS staff (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  email text NOT NULL UNIQUE,
  full_name text NOT NULL,
  role text NOT NULL,
  phone text,
  active boolean DEFAULT true,
  hire_date date,
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now()
);

ALTER TABLE staff ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Manager can view all staff"
  ON staff FOR SELECT
  TO authenticated
  USING (auth.jwt()->>'role' = 'manager');

CREATE POLICY "Staff can view their own info"
  ON staff FOR SELECT
  TO authenticated
  USING (auth.jwt()->>'email' = email);

CREATE POLICY "Manager can manage staff"
  ON staff FOR INSERT
  TO authenticated
  WITH CHECK (auth.jwt()->>'role' = 'manager');

CREATE POLICY "Manager can update staff"
  ON staff FOR UPDATE
  TO authenticated
  USING (auth.jwt()->>'role' = 'manager')
  WITH CHECK (auth.jwt()->>'role' = 'manager');

-- ========================================================================
-- CREATE INDEXES FOR PERFORMANCE
-- ========================================================================

CREATE INDEX idx_bookings_room_id ON bookings(room_id);
CREATE INDEX idx_bookings_check_in_date ON bookings(check_in_date);
CREATE INDEX idx_bookings_check_out_date ON bookings(check_out_date);
CREATE INDEX idx_bookings_status ON bookings(status);
CREATE INDEX idx_guests_booking_id ON guests(booking_id);
CREATE INDEX idx_income_transaction_date ON income(transaction_date);
CREATE INDEX idx_income_category ON income(category);
CREATE INDEX idx_expenses_transaction_date ON expenses(transaction_date);
CREATE INDEX idx_expenses_category ON expenses(category);
CREATE INDEX idx_housekeeping_tasks_task_date ON housekeeping_tasks(task_date);
CREATE INDEX idx_housekeeping_tasks_status ON housekeeping_tasks(status);
CREATE INDEX idx_groundskeeping_tasks_task_date ON groundskeeping_tasks(task_date);
CREATE INDEX idx_groundskeeping_tasks_status ON groundskeeping_tasks(status);
CREATE INDEX idx_maintenance_issues_status ON maintenance_issues(status);
CREATE INDEX idx_daily_reports_report_date ON daily_reports(report_date);
CREATE INDEX idx_staff_email ON staff(email);
CREATE INDEX idx_staff_role ON staff(role);