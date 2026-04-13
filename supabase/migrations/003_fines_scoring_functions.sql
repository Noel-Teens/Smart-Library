-- ============================================================
-- Smart Library Management System - Database Functions
-- Run this in the Supabase SQL Editor (Dashboard → SQL Editor)
-- ============================================================

-- 1. Decrement available_copies when a book is issued
CREATE OR REPLACE FUNCTION decrement_available_copies(book_id_param UUID)
RETURNS void AS $$
BEGIN
  UPDATE books
  SET available_copies = GREATEST(available_copies - 1, 0)
  WHERE id = book_id_param;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- 2. Increment available_copies when a book is returned
CREATE OR REPLACE FUNCTION increment_available_copies(book_id_param UUID)
RETURNS void AS $$
BEGIN
  UPDATE books
  SET available_copies = LEAST(available_copies + 1, total_copies)
  WHERE id = book_id_param;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- 3. Add points to a user's profile
CREATE OR REPLACE FUNCTION add_user_points(user_id_param UUID, points_param INT)
RETURNS void AS $$
BEGIN
  UPDATE profiles
  SET points = COALESCE(points, 0) + points_param
  WHERE id = user_id_param;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- 4. Add points to a house's total
CREATE OR REPLACE FUNCTION add_house_points(house_id_param TEXT, points_param INT)
RETURNS void AS $$
BEGIN
  UPDATE houses
  SET total_points = COALESCE(total_points, 0) + points_param
  WHERE id = house_id_param;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- 5. Increment house member count (used during house selection)
CREATE OR REPLACE FUNCTION increment_house_member(house_id_param TEXT)
RETURNS void AS $$
BEGIN
  UPDATE houses
  SET member_count = COALESCE(member_count, 0) + 1
  WHERE id = house_id_param;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- ============================================================
-- Ensure the 'points' column exists in profiles
-- ============================================================
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_name = 'profiles' AND column_name = 'points'
  ) THEN
    ALTER TABLE profiles ADD COLUMN points INT DEFAULT 0;
  END IF;
END $$;

-- ============================================================
-- Ensure the 'points_awarded' column exists in transactions
-- ============================================================
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_name = 'transactions' AND column_name = 'points_awarded'
  ) THEN
    ALTER TABLE transactions ADD COLUMN points_awarded INT DEFAULT 0;
  END IF;
END $$;

-- ============================================================
-- Ensure the fines table exists
-- ============================================================
CREATE TABLE IF NOT EXISTS fines (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  transaction_id UUID REFERENCES transactions(id),
  user_id UUID REFERENCES profiles(id),
  book_title TEXT NOT NULL DEFAULT '',
  amount INT NOT NULL DEFAULT 0,
  status TEXT NOT NULL DEFAULT 'pending',
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  paid_at TIMESTAMPTZ
);

-- ============================================================
-- Ensure the houses table exists
-- ============================================================
CREATE TABLE IF NOT EXISTS houses (
  id TEXT PRIMARY KEY,
  name TEXT NOT NULL,
  total_points INT DEFAULT 0,
  member_count INT DEFAULT 0
);

-- Insert default houses if they don't exist
INSERT INTO houses (id, name, total_points, member_count)
VALUES
  ('crimson', 'House Crimson', 0, 0),
  ('cobalt', 'House Cobalt', 0, 0),
  ('emerald', 'House Emerald', 0, 0),
  ('amber', 'House Amber', 0, 0)
ON CONFLICT (id) DO NOTHING;

-- ============================================================
-- Enable Row Level Security (RLS) for fines
-- ============================================================
ALTER TABLE fines ENABLE ROW LEVEL SECURITY;

-- Students can read their own fines
DROP POLICY IF EXISTS "Students can read own fines" ON fines;
CREATE POLICY "Students can read own fines"
  ON fines FOR SELECT
  USING (auth.uid() = user_id);

-- Librarians/admins can read all fines
DROP POLICY IF EXISTS "Librarians can read all fines" ON fines;
CREATE POLICY "Librarians can read all fines"
  ON fines FOR SELECT
  USING (
    EXISTS (
      SELECT 1 FROM profiles
      WHERE id = auth.uid()
      AND role IN ('librarian', 'admin')
    )
  );

-- Allow insert from authenticated users (the app inserts fines on return)
DROP POLICY IF EXISTS "App can insert fines" ON fines;
CREATE POLICY "App can insert fines"
  ON fines FOR INSERT
  WITH CHECK (true);

-- Allow update (for payment recording) by librarians
DROP POLICY IF EXISTS "Librarians can update fines" ON fines;
CREATE POLICY "Librarians can update fines"
  ON fines FOR UPDATE
  USING (
    EXISTS (
      SELECT 1 FROM profiles
      WHERE id = auth.uid()
      AND role IN ('librarian', 'admin')
    )
  );

-- ============================================================
-- Triggers for Automatic Account Freezing
-- ============================================================

-- Function to evaluate and update a user's freeze status
CREATE OR REPLACE FUNCTION update_user_freeze_status()
RETURNS TRIGGER AS $$
DECLARE
  unpaid_count INT;
BEGIN
  -- We care about the user_id of the row being inserted/updated
  SELECT COUNT(*) INTO unpaid_count
  FROM fines
  WHERE user_id = NEW.user_id AND status = 'unpaid';

  IF unpaid_count > 0 THEN
    -- If there's at least one unpaid fine, freeze them
    UPDATE profiles SET is_frozen = true WHERE id = NEW.user_id;
  ELSE
    -- If no unpaid fines remain, unfreeze them
    UPDATE profiles SET is_frozen = false WHERE id = NEW.user_id;
  END IF;

  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Trigger whenever a fine is inserted or updated
DROP TRIGGER IF EXISTS trigger_update_freeze_status ON fines;
CREATE TRIGGER trigger_update_freeze_status
AFTER INSERT OR UPDATE OF status ON fines
FOR EACH ROW
EXECUTE FUNCTION update_user_freeze_status();

-- ============================================================
-- Function for Audit Logging
-- ============================================================
CREATE OR REPLACE FUNCTION log_audit_action(
  action_param TEXT,
  performed_by_param UUID,
  performed_by_name_param TEXT,
  target_user_id_param UUID DEFAULT NULL,
  target_user_name_param TEXT DEFAULT NULL,
  target_book_id_param UUID DEFAULT NULL,
  target_book_title_param TEXT DEFAULT NULL,
  details_param TEXT DEFAULT NULL
)
RETURNS void AS $$
BEGIN
  INSERT INTO audit_logs (
    action, performed_by, performed_by_name, 
    target_user_id, target_user_name, 
    target_book_id, target_book_title, 
    details
  ) VALUES (
    action_param, performed_by_param, performed_by_name_param,
    target_user_id_param, target_user_name_param,
    target_book_id_param, target_book_title_param,
    details_param
  );
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;
