# 🚀 Agent Factory - Setup Guide (5 דקות)

**תאריך:** 2026-02-10
**מטרה:** להפעיל את Agent Factory עם database עובד

---

## ✅ צעד 1: צור פרויקט Supabase (3 דקות)

### 1.1 היכנס לאתר:
```
https://supabase.com
```

### 1.2 התחבר:
- לחץ על "Sign In"
- התחבר עם GitHub (מומלץ) או Email

### 1.3 צור פרויקט חדש:
- לחץ על "New Project"
- **Organization:** בחר קיים או צור חדש
- **Name:** `agent-factory` (או כל שם שתרצה)
- **Database Password:** תבחר סיסמה חזקה (שמור אותה!)
- **Region:** `Europe (eu-west-1)` (הכי קרוב לישראל)
- **Pricing Plan:** **Free** (0$)
- לחץ "Create new project"

⏳ **המתן 1-2 דקות** שהפרויקט ייווצר...

---

## ✅ צעד 2: העתק Credentials (1 דקה)

### 2.1 לאחר שהפרויקט נוצר:
- לחץ על ⚙️ **Settings** (בצד שמאל למטה)
- לחץ על **API**

### 2.2 העתק 3 דברים:

#### א. Project URL:
```
לחפש: "Project URL"
יראה כמו: https://xxxxx.supabase.co
```

#### ב. anon/public key:
```
לחפש: "Project API keys" → "anon" → "public"
יראה כמו: eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...
```

#### ג. service_role key:
```
לחפש: "Project API keys" → "service_role" → "secret"
⚠️ לחץ על "Reveal" כדי לראות
יראה כמו: eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...
```

📋 **שמור את 3 הדברים האלה בנפרד!**

---

## ✅ צעד 3: הוסף ל-.env.local (30 שניות)

### 3.1 צור קובץ:
```bash
# בטרמינל:
cd /Users/refaelyharush/Documents/refael-obsidian/RefaelYHarush/agent-factory
touch .env.local
```

### 3.2 פתח את הקובץ ב-VS Code:
```bash
code .env.local
```

### 3.3 הדבק את זה (החלף XXX בערכים שלך):

```env
# Supabase
NEXT_PUBLIC_SUPABASE_URL=https://xxxxx.supabase.co
NEXT_PUBLIC_SUPABASE_ANON_KEY=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...
SUPABASE_SERVICE_ROLE_KEY=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...

# LLM APIs (להוסיף מאוחר יותר)
ANTHROPIC_API_KEY=
OPENAI_API_KEY=

# App
NEXT_PUBLIC_APP_URL=http://localhost:3001
```

💾 **שמור את הקובץ!** (Cmd+S)

---

## ✅ צעד 4: הרץ Migrations (1 דקה)

### 4.1 חזור ל-Supabase:
- לחץ על 🗄️ **SQL Editor** (בצד שמאל)

### 4.2 הרץ את המיגרציות (8 קבצים):

**לכל אחד מהקבצים הבאים:**

1. פתח את הקובץ במחשב שלך:
   ```
   agent-factory/supabase/migrations/001_users.sql
   ```

2. העתק **את כל התוכן**

3. ב-Supabase SQL Editor:
   - לחץ "New Query"
   - הדבק את התוכן
   - לחץ "Run" (או Cmd+Enter)
   - ✅ אמור לראות "Success. No rows returned"

4. חזור על זה ל-8 הקבצים:
   - ✅ `001_users.sql`
   - ✅ `002_agents.sql`
   - ✅ `003_workflows.sql`
   - ✅ `004_executions.sql`
   - ✅ `005_marketplace.sql`
   - ✅ `006_reviews.sql`
   - ✅ `007_analytics.sql`
   - ✅ `008_api_keys.sql`

---

## ✅ צעד 5: אתחל את השרת (10 שניות)

### 5.1 עצור את השרת הנוכחי:
```bash
# בטרמינל:
# Ctrl+C (או הרג את התהליך)
kill $(cat /tmp/agent-factory-dev.pid)
```

### 5.2 הפעל מחדש:
```bash
cd /Users/refaelyharush/Documents/refael-obsidian/RefaelYHarush/agent-factory
npm run dev
```

---

## ✅ צעד 6: בדיקה שהכל עובד! 🎉

### 6.1 פתח דפדפן:
```
http://localhost:3001/dashboard/agents/new
```

### 6.2 מלא טופס:
- **Name:** "My First Agent"
- **Description:** "Test agent"
- **System Prompt:** "You are a helpful assistant"
- לחץ **"Save Agent"**

### 6.3 אם עובד:
- ✅ תקבל הודעת הצלחה
- ✅ תועבר לרשימת Agents
- ✅ תראה את ה-agent החדש

### 6.4 בדוק ב-Supabase:
- חזור ל-Supabase
- לחץ **Table Editor** → **agents**
- ✅ אמור לראות את ה-agent שיצרת!

---

## 🎉 זהו! הכל עובד!

עכשיו יש לך:
- ✅ Database חי
- ✅ Agent Factory מחובר
- ✅ יכול ליצור/עדכן/מחוק agents
- ✅ הכל נשמר ב-cloud

---

## ❓ אם משהו לא עובד:

### בעיה: "Failed to create agent"
**פתרון:** בדוק ש-.env.local נכון ושהמיגרציות רצו

### בעיה: "Missing environment variables"
**פתרון:** וודא ש-.env.local קיים בתיקיית agent-factory

### בעיה: Database error
**פתרון:** ודא שכל 8 המיגרציות רצו בהצלחה

---

## 📞 צריך עזרה?

פשוט תגיד לי איפה אתה תקוע ואני אעזור! 🚀
