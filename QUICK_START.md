# ⚡ Agent Factory - Quick Start (3 Steps Only!)

**כל מה שצריך לעשות בשביל שזה יעבוד:**

---

## 📝 צעד 1: צור פרויקט Supabase (2 דקות)

1. **לך ל:** https://supabase.com
2. **התחבר** (GitHub מומלץ)
3. **New Project:**
   - Name: `agent-factory`
   - Password: (שמור אותה!)
   - Region: `Europe (eu-west-1)`
   - Plan: **Free**
4. **לחץ "Create"** ← המתן דקה

---

## 🔑 צעד 2: העתק Credentials (1 דקה)

**אחרי שהפרויקט נוצר:**

1. לחץ ⚙️ **Settings** → **API**

2. **העתק 3 דברים:**

### א. Project URL
```
מחפשים: "Project URL"
נראה כמו: https://xxxxx.supabase.co
```

### ב. anon key
```
מחפשים: "anon" → "public"
נראה כמו: eyJhbGci...
```

### ג. service_role key
```
מחפשים: "service_role" → לחץ "Reveal"
נראה כמו: eyJhbGci...
```

3. **פתח את הקובץ `.env.local`** (בתיקיית agent-factory)

4. **החלף את השורות:**
```env
NEXT_PUBLIC_SUPABASE_URL=https://xxxxx.supabase.co    ← הדבק כאן
NEXT_PUBLIC_SUPABASE_ANON_KEY=eyJhbGci...             ← הדבק כאן
SUPABASE_SERVICE_ROLE_KEY=eyJhbGci...                 ← הדבק כאן
```

5. **שמור!** (Cmd+S)

---

## 🗄️ צעד 3: הרץ את הDatabase (30 שניות)

1. **בSupabase:** לחץ 🗄️ **SQL Editor**

2. **לחץ "New Query"**

3. **פתח את הקובץ `SUPABASE_SETUP.sql`** (בתיקיית agent-factory)

4. **העתק את כל התוכן** (Cmd+A, Cmd+C)

5. **הדבק ב-SQL Editor** (Cmd+V)

6. **לחץ "Run"** (או Cmd+Enter)

7. **אמור לראות:** ✅ "Success. No rows returned"

---

## 🎉 זהו! עכשיו תבדוק:

### הפעל מחדש את השרת:

```bash
# עצור את השרת (Ctrl+C או):
kill $(cat /tmp/agent-factory-dev.pid)

# הפעל מחדש:
cd /Users/refaelyharush/Documents/refael-obsidian/RefaelYHarush/agent-factory
npm run dev
```

### צור Agent ראשון:

1. פתח: http://localhost:3001/dashboard/agents/new

2. מלא:
   - Name: "Test Agent"
   - Description: "My first agent"
   - System Prompt: "You are helpful"

3. **לחץ "Save Agent"**

4. **אם עובד:** ✅ תועבר לרשימת Agents!

---

## ✅ Done!

**עכשיו יש לך:**
- ✅ Database מחובר
- ✅ Agent Factory עובד
- ✅ יכול ליצור agents
- ✅ הכל נשמר בcloud

---

## 🆘 עזרה מהירה:

### אם יש שגיאה:
1. בדוק ש-`.env.local` מלא נכון
2. בדוק שהSQL רץ בהצלחה
3. רענן את השרת

### אם עובד:
🎉 מזל טוב! תמשיך ליצור agents!
