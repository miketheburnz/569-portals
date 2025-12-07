# 569 on Berea - Property Management System

A complete, fully operational property management system for managing guest accommodations, bookings, finances, and staff operations.

## Features

### 🏨 Booking Management
- Create and manage guest reservations
- Real-time room availability
- Automatic booking reference generation
- Multiple booking sources (Direct, Airbnb, Booking.com, Corporate)
- Guest tracking and FICA compliance

### ✅ Check-In/Check-Out
- Digital check-in with ID/Passport recording
- Deposit management (R500 security deposits)
- Room inspection tracking
- Damage logging and deposit handling
- Automated guest records (FICA compliant, 7-year retention)

### 💰 Financial Management
- Income tracking with categorization
- Expense logging with receipt tracking
- Real-time financial dashboards
- Daily financial reports
- Multiple payment methods support
- Deposit tracking and refunds

### 📋 Task Management
- Housekeeping task generation
- Groundskeeping task tracking
- Task prioritization (Urgent, High, Normal)
- Maintenance issue logging and tracking
- Staff assignment capabilities

### 🏠 Staff Portals
- Manager Dashboard - Full operational control
- Housekeeping Portal - Mobile-optimized task management
- Groundskeeping Portal - Outdoor task tracking
- Guest Portal - Self-service access to property information

### 🔒 Security & Compliance
- Row Level Security (RLS) on all tables
- FICA-compliant guest registration
- Guest ID/Passport recording
- 7-year record retention for compliance
- User role-based access control

---

## Quick Start

### 1. Get Your Supabase Credentials
- Sign up at https://supabase.com
- Create a new project
- Copy your Project URL and Anon Key from Settings > API

### 2. Configure the Portals
Edit these files and replace the placeholder credentials:

**manager_portal.html** (line 1084-1085):
```javascript
const SUPABASE_URL = 'https://your-project.supabase.co';
const SUPABASE_ANON_KEY = 'your_anon_key_here';
```

### 3. Open the Portal
- Open `manager_portal.html` in your browser
- Dashboard loads automatically with your data
- Start creating bookings!

---

## System Architecture

### Technology Stack
- **Frontend:** HTML5, CSS3, JavaScript (Vanilla)
- **Database:** Supabase (PostgreSQL)
- **Backend:** Supabase Edge Functions
- **Authentication:** Supabase Auth
- **Real-time:** Supabase Real-time Subscriptions

### Database Schema
```
rooms (5 properties with rates)
├── bookings (guest reservations)
│   └── guests (FICA-compliant records)
├── income (revenue tracking)
├── expenses (expense tracking)
├── housekeeping_tasks (cleaning tasks)
├── groundskeeping_tasks (outdoor tasks)
├── maintenance_issues (issue tracking)
├── daily_reports (manager reports)
└── staff (staff information)
```

### Edge Functions
- `create-booking` - Creates new bookings and auto-generates task
- `process-checkin` - Processes check-in and creates guest record
- `process-checkout` - Processes check-out and deposit refunds
- `log-transaction` - Logs income and expense transactions

---

## File Structure

```
project/
├── manager_portal.html          # Manager dashboard (primary portal)
├── guest_portal.html            # Guest self-service portal
├── housekeeping_portal.html     # Housekeeping task management
├── groundskeeping_portal.html   # Groundskeeping task management
├── README.md                    # This file
├── SETUP.md                     # Detailed setup instructions
└── .env                         # Environment configuration (if using)
```

---

## Usage Guide

### Creating a Booking

1. **Open Manager Portal** → Bookings tab
2. **Fill in guest details:**
   - Guest Name
   - Phone Number
   - Email (optional)
3. **Select Room** - Choose from available rooms
4. **Set Dates:**
   - Check-In Date
   - Check-Out Date
5. **Add Details:**
   - Number of Guests
   - Booking Source
   - Notes
6. **Click "Create Booking"**
   - System generates booking reference (BK0001)
   - Booking confirmation shows total amount
   - Housekeeping task auto-created

### Processing Check-In

1. **Manager Portal** → Check-In/Out tab
2. **Select Booking** from dropdown
3. **Enter Guest Information:**
   - ID/Passport Number (required - FICA)
   - Nationality
   - Home Address
4. **Select Deposit Method** (Cash/Card/EFT)
5. **Confirm Deposit Received** (R500)
6. **Click "Complete Check-In"**
   - Guest record created (FICA-compliant)
   - Room status updates to "Occupied"
   - Booking status changes to "Checked-In"

### Processing Check-Out

1. **Manager Portal** → Check-In/Out tab → Check-Out Guest
2. **Select Booking** from dropdown
3. **Room Inspection:**
   - Pass (no issues)
   - Minor issues (note details)
   - Damage found
4. **Log any damage** in notes field
5. **Select Deposit Action:**
   - Full Refund (R500)
   - Partial Refund (R250)
   - Forfeit (damages)
6. **Click "Complete Check-Out"**
   - Guest marked as checked-out
   - Deposit refund logged as income
   - Room becomes available

### Financial Logging

#### Income
1. **Financial tab** → Log Income
2. **Date** - Transaction date
3. **Description** - What was paid (e.g., "Room 1 - 3 nights")
4. **Category** - Type of income
5. **Amount** - Total in ZAR
6. **Payment Method** - Cash/Card/EFT/Online
7. **Click "Log Income"**

#### Expenses
1. **Financial tab** → Log Expense
2. **Date** - Transaction date
3. **Description** - What was purchased
4. **Category** - Expense type
5. **Amount** - Total in ZAR
6. **Receipt Number** - For tracking
7. **Click "Log Expense"**

### Daily Operations

#### Morning Routine (Manager)
1. Open Manager Portal
2. Check dashboard for today's schedule
3. Review check-ins and check-outs
4. Verify room status

#### Throughout Day
1. Process guest check-ins (✅ tab)
2. Log any income as received
3. Log any expenses
4. Create tasks for staff

#### Evening
1. Complete daily financial report
2. Review all day's transactions
3. Assign tomorrow's tasks

---

## Room Information

| Room | Type | Rate | Weekend | Max Guests |
|------|------|------|---------|-----------|
| Room 1 | King Suite | R900 | R1100 | 2 |
| Room 2 | Twin Room | R750 | R900 | 2 |
| Room 3 | Queen Room | R800 | R950 | 2 |
| Room 4 | Single Room | R600 | R750 | 1 |
| Room 5 | Family Suite | R1200 | R1400 | 4 |

---

## Financial Tracking

### Income Categories
- Room Revenue (primary)
- Laundry Service
- Late Checkout Fee
- Early Checkin Fee
- Deposit (security deposit only)

### Expense Categories
- Cleaning Supplies
- Maintenance & Repairs
- Utilities
- Pool Chemicals
- Groceries/Supplies
- Staff
- Marketing
- Administrative

### Reporting
- Daily financial summaries
- Monthly aggregations
- Income by category
- Expense tracking
- Net income calculations
- Occupancy rate analysis

---

## FICA Compliance

### Requirements
- Guest ID/Passport number collected at check-in
- Full name recorded
- Address information
- Nationality recorded
- All information retained for 7 years minimum

### System Features
- Automatic guest record creation
- ID/Passport field validation
- Signature acceptance tracking
- Record retention reminders
- 7-year retention period

---

## Booking Sources

Supported booking channels:
- **Direct** - Direct phone/email bookings
- **Airbnb** - Airbnb platform bookings
- **Booking.com** - Booking.com platform bookings
- **Corporate** - Corporate/business bookings
- **Referral** - Referral/word-of-mouth

---

## Mobile Optimization

### Responsive Design
All portals are fully responsive:
- **Desktop** - Optimal layout on large screens
- **Tablet** - Adjusted layout for tablets
- **Mobile** - Touch-optimized for phones

### Recommended Device Usage
- **Manager Portal** - Tablet or Desktop (preferred)
- **Housekeeping Portal** - Mobile Phone (touch-optimized)
- **Groundskeeping Portal** - Mobile Phone (touch-optimized)
- **Guest Portal** - Mobile Phone (QR code accessible)

---

## Pricing & Costs

### Free Forever Features
- Supabase database (500MB included)
- 500K Edge Function invocations/month
- 50,000 active users
- Unlimited projects

### Typical Monthly Cost
- **Your usage:** R0/month (stays within free tier)
- **Peak season:** Still R0 (free tier is very generous)
- **Growth:** Only pay when you exceed limits (unlikely for single property)

### Optional Upgrades
Only needed if exceeding free tier limits:
- Additional storage: R200/month per 500GB
- Pro tier: R1500/month for higher limits

---

## Support & Documentation

### Built-in Help
- System includes validation error messages
- Toast notifications for all actions
- Status indicators for all operations

### Detailed Guides
- See `SETUP.md` for installation
- Check browser console (F12) for error details
- Review Supabase documentation

### Troubleshooting
1. **Portals won't load** - Check internet connection, clear cache
2. **Bookings don't save** - Verify Supabase credentials
3. **Dates not working** - Ensure correct date format (YYYY-MM-DD)
4. **Calculations wrong** - Check room rates in database

---

## Backup & Data Safety

### Automatic Backups
- Supabase provides daily backups
- Included in free tier
- Available for 7 days

### Manual Exports
1. Go to Supabase dashboard
2. Use SQL Editor to export data
3. Export monthly for additional security

### Data Retention
- Guest records: 7 years minimum (FICA requirement)
- Financial records: Indefinite
- Booking history: Indefinite
- Task history: Indefinite

---

## Best Practices

### Daily
✓ Process all check-ins same day
✓ Log all financial transactions same day
✓ Log any maintenance issues immediately
✓ Update task status as completed

### Weekly
✓ Review financial reports
✓ Check maintenance issues
✓ Verify room cleanliness standards
✓ Plan upcoming needs

### Monthly
✓ Export financial data
✓ Review occupancy rates
✓ Backup database
✓ Update rates if needed

### Quarterly
✓ Review system performance
✓ Update property information
✓ Train staff on updates
✓ Plan seasonal changes

---

## Features Roadmap

### Current Version (1.0)
- ✅ Booking management
- ✅ Check-in/check-out
- ✅ Financial tracking
- ✅ Task management
- ✅ FICA compliance
- ✅ Staff portals
- ✅ Real-time updates
- ✅ Mobile optimization

### Future Enhancements (Planned)
- Guest communication (SMS/Email)
- Automated invoicing
- Integration with payment gateways
- Advanced reporting and analytics
- Staff performance tracking
- Maintenance scheduling
- Guest feedback system
- Multi-property support

---

## License & Attribution

This system is provided as-is for property management use.

### Technologies Used
- Supabase (Open source PostgreSQL backend)
- JavaScript ES6+
- HTML5 & CSS3

### Credits
- Built with modern web standards
- Designed for simplicity and reliability
- Optimized for South African property management

---

## Version History

### v1.0 (Current)
- Initial release
- Complete booking system
- Financial management
- Task management
- Staff portals
- Guest self-service

---

## Getting Help

1. **Check SETUP.md** - Detailed setup instructions
2. **Review browser console** - Error messages visible with F12
3. **Supabase Docs** - https://supabase.com/docs
4. **Test with sample data** - System includes sample bookings

---

**System Status:** ✅ Production Ready
**Last Updated:** December 2025
**Support Level:** Community
**Uptime:** 99.9% (Supabase reliability)

---

For detailed setup instructions, see **SETUP.md**