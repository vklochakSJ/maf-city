// MAF-CITY — Supabase Client
import { createClient } from 'https://esm.sh/@supabase/supabase-js@2';

export const supabase = createClient(
  'https://ywpzhyjofpxrkhsqensj.supabase.co',
  'sb_publishable_6AWxSXyU1dE69NZPtgj3fw_u2D-GqZ7'
);

// ── Toast ────────────────────────────────────────────────────────────
export function toast(msg, type = 'info') {
  let container = document.getElementById('toast-container');
  if (!container) {
    container = document.createElement('div');
    container.id = 'toast-container';
    document.body.appendChild(container);
  }
  const el = document.createElement('div');
  el.className = `toast toast-${type}`;
  el.textContent = msg;
  container.appendChild(el);
  setTimeout(() => el.remove(), 3500);
}

// ── Auth helpers ──────────────────────────────────────────────────────
export async function getCurrentUser() {
  const { data: { user } } = await supabase.auth.getUser();
  return user;
}

export async function getProfile(userId) {
  const { data } = await supabase
    .from('profiles')
    .select('*, clubs(id, name, logo_url)')
    .eq('id', userId)
    .single();
  return data;
}

export async function signOut() {
  await supabase.auth.signOut();
  window.location.href = '/index.html';
}

// ── Avatar initials ──────────────────────────────────────────────────
export function initials(name = '') {
  return name.slice(0, 2).toUpperCase() || '??';
}

// ── File upload ───────────────────────────────────────────────────────
export async function uploadLogo(file, path) {
  const { data, error } = await supabase.storage
    .from('club-logos')
    .upload(path, file, { upsert: true });
  if (error) throw error;
  const { data: { publicUrl } } = supabase.storage
    .from('club-logos')
    .getPublicUrl(path);
  return publicUrl;
}

// ── Auth guard (redirect if not logged in) ───────────────────────────
export async function requireAuth() {
  const user = await getCurrentUser();
  if (!user) {
    window.location.href = '/index.html';
    return null;
  }
  return user;
}
