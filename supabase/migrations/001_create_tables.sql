-- ============================================================
-- Smart Library Management System — Table Definitions
-- Run this in Supabase SQL Editor (or via CLI migrations)
-- ============================================================

-- ── Profiles (extends auth.users) ──
CREATE TABLE IF NOT EXISTS public.profiles (
  id UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
  email TEXT NOT NULL,
  name TEXT NOT NULL DEFAULT '',
  role TEXT NOT NULL DEFAULT 'student'
    CHECK (role IN ('student', 'librarian', 'admin', 'staff')),
  avatar_url TEXT,
  house_id TEXT,
  points INTEGER NOT NULL DEFAULT 0,
  is_frozen BOOLEAN NOT NULL DEFAULT FALSE,
  fcm_token TEXT,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- Auto-create profile on new auth.users signup and bypass email validation
CREATE OR REPLACE FUNCTION public.handle_new_user()
RETURNS TRIGGER AS $$
BEGIN
  -- 1. Create the public profile
  INSERT INTO public.profiles (id, email, name, role)
  VALUES (
    NEW.id,
    NEW.email,
    COALESCE(NEW.raw_user_meta_data->>'full_name', NEW.email),
    COALESCE(NEW.raw_user_meta_data->>'role', 'student')
  );
  
  -- 2. Force auto-confirm the email address instantly
  -- This entirely bypasses the Supabase email verification wall
  UPDATE auth.users SET email_confirmed_at = now() WHERE id = NEW.id;
  
  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

DROP TRIGGER IF EXISTS on_auth_user_created ON auth.users;
CREATE TRIGGER on_auth_user_created
  AFTER INSERT ON auth.users
  FOR EACH ROW EXECUTE FUNCTION public.handle_new_user();


-- ── Books ──
CREATE TABLE IF NOT EXISTS public.books (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  title TEXT NOT NULL,
  author TEXT NOT NULL,
  isbn TEXT NOT NULL DEFAULT '',
  genre TEXT NOT NULL DEFAULT '',
  description TEXT,
  cover_url TEXT,
  total_copies INTEGER NOT NULL DEFAULT 1,
  available_copies INTEGER NOT NULL DEFAULT 1,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE INDEX IF NOT EXISTS idx_books_title ON public.books USING gin(to_tsvector('english', title));
CREATE INDEX IF NOT EXISTS idx_books_author ON public.books (author);


-- ── Transactions ──
CREATE TABLE IF NOT EXISTS public.transactions (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES public.profiles(id) ON DELETE CASCADE,
  book_id UUID NOT NULL REFERENCES public.books(id) ON DELETE CASCADE,
  book_title TEXT NOT NULL DEFAULT '',
  book_author TEXT NOT NULL DEFAULT '',
  user_name TEXT NOT NULL DEFAULT '',
  status TEXT NOT NULL DEFAULT 'requested'
    CHECK (status IN ('requested', 'approved', 'rejected', 'issued', 'returned')),
  requested_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  approved_at TIMESTAMPTZ,
  issued_at TIMESTAMPTZ,
  due_date TIMESTAMPTZ,
  returned_at TIMESTAMPTZ,
  librarian_note TEXT,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE INDEX IF NOT EXISTS idx_txn_user ON public.transactions (user_id);
CREATE INDEX IF NOT EXISTS idx_txn_status ON public.transactions (status);


-- ── Fines ──
CREATE TABLE IF NOT EXISTS public.fines (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES public.profiles(id) ON DELETE CASCADE,
  transaction_id UUID REFERENCES public.transactions(id) ON DELETE SET NULL,
  book_title TEXT NOT NULL DEFAULT '',
  amount DOUBLE PRECISION NOT NULL DEFAULT 0,
  status TEXT NOT NULL DEFAULT 'unpaid'
    CHECK (status IN ('unpaid', 'paid', 'waived')),
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  paid_at TIMESTAMPTZ
);

CREATE INDEX IF NOT EXISTS idx_fines_user ON public.fines (user_id);


-- ── Houses ──
CREATE TABLE IF NOT EXISTS public.houses (
  id TEXT PRIMARY KEY,
  name TEXT NOT NULL,
  color TEXT NOT NULL DEFAULT '#000000',
  icon TEXT NOT NULL DEFAULT 'castle',
  motto TEXT NOT NULL DEFAULT '',
  total_points INTEGER NOT NULL DEFAULT 0,
  member_count INTEGER NOT NULL DEFAULT 0
);


-- ── Notifications ──
CREATE TABLE IF NOT EXISTS public.notifications (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES public.profiles(id) ON DELETE CASCADE,
  title TEXT NOT NULL,
  body TEXT NOT NULL,
  type TEXT NOT NULL DEFAULT 'requestUpdate'
    CHECK (type IN ('dueReminder', 'overdueAlert', 'requestUpdate', 'availabilityAlert')),
  is_read BOOLEAN NOT NULL DEFAULT FALSE,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  related_transaction_id UUID REFERENCES public.transactions(id) ON DELETE SET NULL
);

CREATE INDEX IF NOT EXISTS idx_notif_user ON public.notifications (user_id);


-- ── Audit Logs ──
CREATE TABLE IF NOT EXISTS public.audit_logs (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  action TEXT NOT NULL,
  performed_by UUID NOT NULL REFERENCES public.profiles(id),
  performed_by_name TEXT NOT NULL DEFAULT '',
  target_user_id UUID REFERENCES public.profiles(id),
  target_user_name TEXT,
  target_book_id UUID REFERENCES public.books(id),
  target_book_title TEXT,
  timestamp TIMESTAMPTZ NOT NULL DEFAULT now(),
  details TEXT
);

CREATE INDEX IF NOT EXISTS idx_audit_timestamp ON public.audit_logs (timestamp DESC);


-- ── Enable Realtime ──
ALTER PUBLICATION supabase_realtime ADD TABLE public.books;
ALTER PUBLICATION supabase_realtime ADD TABLE public.transactions;
ALTER PUBLICATION supabase_realtime ADD TABLE public.notifications;
