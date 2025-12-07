# 569 on Berea - Complete System Setup Guide

## Overview

This is a fully operational property management system built with Supabase and modern web technologies. Everything runs for **FREE** or at minimal cost.

### What You Get
- Complete booking management system
- Real-time guest check-in/check-out
- Financial tracking (income/expenses)
- Task management for staff
- Guest self-service portal
- Manager dashboard

---

## Prerequisites

1. **Supabase Account** - Sign up at https://supabase.com (Free tier included)
2. **Your Supabase URL and API Key** - Available in Supabase project settings
3. **A modern web browser** - Chrome, Firefox, Safari, or Edge

---

## Step 1: Set Up Supabase

### Create a Supabase Project
1. Go to https://supabase.com and sign up
2. Create a new project (choose "Create a new project")
3. Name it: `569-on-berea`
4. Choose a strong database password and save it
5. Select your region (e.g., Africa if available)
6. Wait for the project to be created (2-3 minutes)

### Get Your Credentials
1. In your Supabase project, go to **Settings > API**
2. Copy and save:
   - **Project URL** (e.g., `https://xyz123.supabase.co`)
   - **Anon/Public Key** (shown under "Project API keys")
3. Keep these safe - you'll need them to configure the portals

---

## Step 2: Initialize Database

The database schema and sample data have already been created via migrations. Your database now includes:

### Tables Created:
- **rooms** - Your 5 guest rooms with rates
- **bookings** - Guest reservations
- **guests** - Guest information (FICA compliant)
- **income** - Revenue tracking
- **expenses** - Expense tracking
- **housekeeping_tasks** - Cleaning task management
- **groundskeeping_tasks** - Outdoor task management
- **maintenance_issues** - Issue tracking
- **daily_reports** - Manager reports
- **staff** - Staff member records

### Sample Data:
- 5 rooms pre-configured with rates
- Room 1: King Suite (R900/night)
- Room 2: Twin Room (R750/night)
- Room 3: Queen Room (R800/night)
- Room 4: Single Room (R600/night)
- Room 5: Family Suite (R1200/night)

---

## Step 3: Configure Manager Portal

### Edit the Manager Portal HTML
1. Open `manager_portal.html` in a text editor (VS Code, Notepad++, etc.)
2. Find these two lines (around line 1084-1085):
   ```javascript
   const SUPABASE_URL = 'YOUR_SUPABASE_URL';
   const SUPABASE_ANON_KEY = 'YOUR_SUPABASE_ANON_KEY';
   ```
3. Replace them with your actual credentials:
   ```javascript
   const SUPABASE_URL = 'https://xyz123.supabase.co';
   const SUPABASE_ANON_KEY = 'your_anon_key_here';
   ```
4. Save the file

### Access the Manager Portal
1. Open `manager_portal.html` in your browser
2. You should see the dashboard loading
3. The system will automatically load rooms and bookings

---

## Step 4: Deploy Edge Functions

Edge Functions handle server-side operations. They're already deployed with the system:

### Deployed Functions:
- `create-booking` - Creates new bookings
- `process-checkin` - Processes guest check-in
- `process-checkout` - Processes guest check-out
- `log-transaction` - Logs income and expenses

**No additional setup needed** - they're ready to use!

---

## Step 5: Set Up Guest Portal (Optional)

The guest portal allows guests to:
- View their booking details
- Access WiFi information
- See house rules
- Submit service requests
- Get emergency contacts

### Configure Guest Portal
1. Open `guest_portal.html`
2. Add your Supabase credentials (same as manager portal)
3. Print QR codes linking to the guest portal and place in each room

---

## Step 6: Customize Settings

### Modify Room Rates
1. Go to Supabase console
2. Navigate to **rooms** table
3. Edit `rate_per_night` and `weekend_rate` for each room

### Change Property Details
Edit this information in each portal's header/config:
- Property name
- Address
- Phone numbers
- WiFi network name and password
- Check-in/out times

---

## Daily Workflow

### Morning (Manager - Trudy)
1. Open Manager Portal
2. Check dashboard for today's check-ins/check-outs
3. Review occupied rooms
4. Verify pending bookings

### Guest Check-In
1. Open Manager Portal → Check-In/Out tab
2. Enter booking reference or guest name
3. Collect ID/Passport (FICA requirement)
4. Confirm deposit received (R500)
5. Click "Complete Check-In"

### Financial Logging
1. Open Manager Portal → Financial tab
2. Log income as it's received
3. Log expenses with receipts
4. System automatically calculates totals

### Guest Check-Out
1. Open Manager Portal → Check-In/Out tab
2. Inspect room for damage
3. Log any issues found
4. Process deposit refund
5. Click "Complete Check-Out"

### End of Day
1. Submit daily financial report
2. All data automatically syncs to Supabase
3. Reports available 24/7

---

## API Endpoints

### Edge Functions Available

All requests require authentication header:
```
Authorization: Bearer YOUR_SUPABASE_ANON_KEY
Content-Type: application/json
```

#### Create Booking
```
POST /functions/v1/create-booking

{
  "roomId": "uuid",
  "guestName": "John Doe",
  "guestPhone": "+27 82 123 4567",
  "checkInDate": "2025-12-01",
  "checkOutDate": "2025-12-05",
  "numberOfGuests": 2,
  "source": "Airbnb"
}
```

#### Process Check-In
```
POST /functions/v1/process-checkin

{
  "bookingId": "uuid",
  "idNumber": "1234567890123",
  "nationality": "South African",
  "depositMethod": "Cash",
  "depositReceived": true
}
```

#### Process Check-Out
```
POST /functions/v1/process-checkout

{
  "bookingId": "uuid",
  "inspection": "Pass",
  "depositAction": "Refund"
}
```

#### Log Transaction
```
POST /functions/v1/log-transaction

{
  "type": "income",
  "transactionDate": "2025-12-01",
  "description": "Room 1 - 3 nights",
  "category": "Room Revenue",
  "amount": 2700,
  "paymentMethod": "Cash"
}
```

---

## Troubleshooting

### Portal Not Loading
1. Check browser console (F12) for errors
2. Verify Supabase credentials are correct
3. Check internet connection
4. Try a different browser

### Bookings Not Showing
1. Verify rooms were created successfully
2. Check Supabase dashboard > rooms table
3. Refresh the portal

### Edge Functions Not Working
1. Check Supabase project > Functions
2. Verify all 4 functions are deployed
3. Check function logs for errors

### Database Issues
1. Go to Supabase dashboard
2. Check SQL Editor to verify tables exist
3. Verify Row Level Security (RLS) is enabled on tables

---

## Security Best Practices

### Protect Your Credentials
- Never commit credentials to version control
- Use environment variables for sensitive data
- Rotate API keys regularly

### Row Level Security (RLS)
- All tables have RLS enabled
- Only authorized users can access their data
- Manager has full access to operational data

### Backup Your Data
1. Go to Supabase dashboard
2. Regular automated backups included with free tier
3. Export data monthly for additional safety

---

## Cost Analysis

### What's Free
- Supabase database (500MB storage)
- Edge Functions (500K invocations/month)
- 50,000 monthly active users
- 1GB bandwidth

### Premium Features (Optional)
- Additional storage: $25/month per 500GB
- Higher limits: Upgrade from "Pro" tier
- Custom domains: $10/month

### Your Typical Monthly Cost: **R0**

---

## Maintenance Tasks

### Weekly
- Review financial reports
- Check for maintenance issues
- Verify all staff tasks completed

### Monthly
- Export financial data
- Review occupancy rates
- Backup database
- Update room rates if needed

### Quarterly
- Review system performance
- Update property information
- Check for new Supabase features

---

## Support & Resources

### Documentation
- Supabase Docs: https://supabase.com/docs
- JavaScript Client: https://supabase.com/docs/reference/javascript
- Row Level Security: https://supabase.com/docs/guides/auth/row-level-security

### Getting Help
1. Check this setup guide first
2. Review Supabase documentation
3. Check browser console for error messages
4. Verify database structure in Supabase dashboard

---

## Next Steps

1. ✅ Configure manager portal with your Supabase credentials
2. ✅ Test creating a booking
3. ✅ Test check-in/check-out flow
4. ✅ Log a test financial transaction
5. ✅ Configure guest portal (optional)
6. ✅ Print QR codes for guest access
7. ✅ Train staff on using the system

---

## Quick Reference

| Feature | Status | Notes |
|---------|--------|-------|
| Bookings | ✓ Ready | Full CRUD operations |
| Check-In/Out | ✓ Ready | FICA compliance built-in |
| Financial Tracking | ✓ Ready | Income & expense logging |
| Tasks | ✓ Ready | Housekeeping & groundskeeping |
| Maintenance | ✓ Ready | Issue tracking & resolution |
| Reports | ✓ Ready | Daily financial reports |
| Guest Portal | ✓ Ready | QR code accessible |
| Staff Portal | ✓ Ready | Mobile optimized |

---

**System Version:** 1.0
**Last Updated:** December 2025
**Property:** 569 on Berea, Muckleneuk, Pretoria