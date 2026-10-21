-- Daivik Doorstep Customer CRM schema
-- Run in the SQL Editor of the SAME Supabase project configured in customer.html.
-- Security note: owner.html currently uses a client-side PIN, not Supabase Auth. Do not expose customer CRM tables to anon until a server-side admin gate or proper Auth/RLS policies are configured.

create table if not exists public.daivik_customer_followups (
  id uuid primary key default gen_random_uuid(),
  name text not null,
  phone text not null,
  car_model text,
  package_name text,
  last_service_date date,
  next_followup_date date not null,
  last_contact_date date,
  notes text,
  whatsapp_opt_in boolean not null default false,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create index if not exists daivik_customer_followups_next_date_idx
  on public.daivik_customer_followups(next_followup_date);
create index if not exists daivik_customer_followups_phone_idx
  on public.daivik_customer_followups(phone);

create table if not exists public.daivik_customer_followup_history (
  id uuid primary key default gen_random_uuid(),
  customer_id uuid references public.daivik_customer_followups(id) on delete set null,
  customer_name text not null,
  phone text not null,
  contact_type text not null default 'Follow-up',
  status text not null default 'Recorded',
  note text,
  contact_date date not null default current_date,
  created_at timestamptz not null default now()
);
create index if not exists daivik_customer_followup_history_date_idx
  on public.daivik_customer_followup_history(contact_date desc);

alter table public.daivik_customer_followups enable row level security;
alter table public.daivik_customer_followup_history enable row level security;

-- Intentionally no anon/public CRUD policies are created here.
-- Add policies only after a secure admin authentication approach is configured.
