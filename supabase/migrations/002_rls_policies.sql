-- ============================================================
-- Row Level Security Policies
-- ============================================================

-- Enable RLS on all tables
ALTER TABLE public.profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.books ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.transactions ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.fines ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.houses ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.notifications ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.audit_logs ENABLE ROW LEVEL SECURITY;

-- ── Helper: get current user's role ──
CREATE OR REPLACE FUNCTION public.get_user_role()
RETURNS TEXT AS $$
  SELECT role FROM public.profiles WHERE id = auth.uid();
$$ LANGUAGE sql SECURITY DEFINER STABLE;


-- ═══════════════════════════════════════════════
-- PROFILES
-- ═══════════════════════════════════════════════

-- Everyone can read all profiles (needed for leaderboard, user management)
CREATE POLICY "profiles_select_all" ON public.profiles
  FOR SELECT USING (TRUE);

-- Users can update their own profile
CREATE POLICY "profiles_update_self" ON public.profiles
  FOR UPDATE USING (auth.uid() = id)
  WITH CHECK (auth.uid() = id);

-- Admins can update any profile (role changes, freeze)
CREATE POLICY "profiles_update_admin" ON public.profiles
  FOR UPDATE USING (public.get_user_role() = 'admin')
  WITH CHECK (public.get_user_role() = 'admin');

-- Librarians can freeze/unfreeze
CREATE POLICY "profiles_update_librarian" ON public.profiles
  FOR UPDATE USING (public.get_user_role() = 'librarian')
  WITH CHECK (public.get_user_role() = 'librarian');


-- ═══════════════════════════════════════════════
-- BOOKS
-- ═══════════════════════════════════════════════

-- Everyone can read books
CREATE POLICY "books_select_all" ON public.books
  FOR SELECT USING (TRUE);

-- Librarians and admins can insert/update/delete books
CREATE POLICY "books_insert_librarian_admin" ON public.books
  FOR INSERT WITH CHECK (
    public.get_user_role() IN ('librarian', 'admin')
  );

CREATE POLICY "books_update_librarian_admin" ON public.books
  FOR UPDATE USING (
    public.get_user_role() IN ('librarian', 'admin')
  );

CREATE POLICY "books_delete_librarian_admin" ON public.books
  FOR DELETE USING (
    public.get_user_role() IN ('librarian', 'admin')
  );


-- ═══════════════════════════════════════════════
-- TRANSACTIONS
-- ═══════════════════════════════════════════════

-- Students can see their own transactions
CREATE POLICY "txn_select_own" ON public.transactions
  FOR SELECT USING (auth.uid() = user_id);

-- Librarians and admins can see all transactions
CREATE POLICY "txn_select_librarian_admin" ON public.transactions
  FOR SELECT USING (
    public.get_user_role() IN ('librarian', 'admin', 'staff')
  );

-- Students can insert (create requests)
CREATE POLICY "txn_insert_student" ON public.transactions
  FOR INSERT WITH CHECK (
    auth.uid() = user_id AND status = 'requested'
  );

-- Librarians can update transactions (approve, reject, issue, return)
CREATE POLICY "txn_update_librarian" ON public.transactions
  FOR UPDATE USING (
    public.get_user_role() IN ('librarian', 'admin')
  );


-- ═══════════════════════════════════════════════
-- FINES
-- ═══════════════════════════════════════════════

-- Students see their own fines
CREATE POLICY "fines_select_own" ON public.fines
  FOR SELECT USING (auth.uid() = user_id);

-- Librarians and admins see all fines
CREATE POLICY "fines_select_librarian_admin" ON public.fines
  FOR SELECT USING (
    public.get_user_role() IN ('librarian', 'admin', 'staff')
  );

-- Librarians can insert/update fines
CREATE POLICY "fines_insert_librarian" ON public.fines
  FOR INSERT WITH CHECK (
    public.get_user_role() IN ('librarian', 'admin')
  );

CREATE POLICY "fines_update_librarian" ON public.fines
  FOR UPDATE USING (
    public.get_user_role() IN ('librarian', 'admin')
  );


-- ═══════════════════════════════════════════════
-- HOUSES
-- ═══════════════════════════════════════════════

-- Everyone can read houses
CREATE POLICY "houses_select_all" ON public.houses
  FOR SELECT USING (TRUE);

-- Only admins can modify houses
CREATE POLICY "houses_modify_admin" ON public.houses
  FOR ALL USING (public.get_user_role() = 'admin')
  WITH CHECK (public.get_user_role() = 'admin');


-- ═══════════════════════════════════════════════
-- NOTIFICATIONS
-- ═══════════════════════════════════════════════

-- Users see their own notifications
CREATE POLICY "notif_select_own" ON public.notifications
  FOR SELECT USING (auth.uid() = user_id);

-- Users can update their own notifications (mark read)
CREATE POLICY "notif_update_own" ON public.notifications
  FOR UPDATE USING (auth.uid() = user_id);

-- System (librarian/admin) can insert notifications for any user
CREATE POLICY "notif_insert_system" ON public.notifications
  FOR INSERT WITH CHECK (
    public.get_user_role() IN ('librarian', 'admin')
    OR auth.uid() = user_id
  );


-- ═══════════════════════════════════════════════
-- AUDIT LOGS
-- ═══════════════════════════════════════════════

-- Only admins can read audit logs
CREATE POLICY "audit_select_admin" ON public.audit_logs
  FOR SELECT USING (
    public.get_user_role() IN ('admin', 'staff')
  );

-- Librarians and admins can insert audit logs
CREATE POLICY "audit_insert" ON public.audit_logs
  FOR INSERT WITH CHECK (
    public.get_user_role() IN ('librarian', 'admin')
  );
