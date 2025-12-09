# Render Deployment Guide for University Admin App

## Files Created for Deployment

Your application is now ready for deployment on Render. The following files have been created/updated:

1. **runtime.txt** - Specifies Python version (3.9.18)
2. **requirements.txt** - Updated with production dependencies (gunicorn, psycopg2-binary)
3. **Procfile** - Tells Render how to run your app
4. **build.sh** - Build script for Render
5. **app.py** - Updated to use environment variables for port and debug mode

## Deployment Specifications - What You Need to Do

### Step 1: Create a Render Account
1. Go to https://render.com
2. Sign up for a free account
3. Connect your GitHub account

### Step 2: Push Your Code to GitHub
```bash
git add .
git commit -m "Prepare app for Render deployment"
git push origin main
```

### Step 3: Create a PostgreSQL Database on Render

1. In Render Dashboard, click **"New +"** → **"PostgreSQL"**
2. Configure:
   - **Name**: university-admin-db (or your preferred name)
   - **Database**: university_admin
   - **User**: (auto-generated)
   - **Region**: Choose closest to your users
   - **PostgreSQL Version**: 15 or later
   - **Plan**: Free (or paid as needed)
3. Click **"Create Database"**
4. Wait for database to be created (2-3 minutes)
5. **IMPORTANT**: Copy the **Internal Database URL** (starts with `postgresql://`)
   - You'll find this in the database's "Info" section
   - Format: `postgresql://user:password@host/database`

### Step 4: Import Your Database Schema

You have two options to create the database tables:

**Option A: Using the Simplified SQL File (Recommended)**
1. In your database dashboard on Render, click **"Connect"** → **"External Connection"**
2. Copy the **External Database URL**
3. Run the SQL file to create tables:
   ```bash
   psql <EXTERNAL_DATABASE_URL> < create_tables.sql
   ```
   OR use a PostgreSQL client (pgAdmin, DBeaver, TablePlus):
   - Connect using the External Database URL
   - Open and execute the `create_tables.sql` file

**Option B: Using the Original SQL File**
   ```bash
   psql <EXTERNAL_DATABASE_URL> < DB/admin_db.sql
   ```

**What the SQL Script Does:**
- Creates all necessary database tables (account, school, institution, area, etc.)
- Creates sequences for auto-incrementing IDs
- Sets up foreign key relationships
- Creates indexes for better query performance
- Inserts initial lookup data (areas, features, school types, etc.)

### Step 5: Create a Web Service on Render

1. In Render Dashboard, click **"New +"** → **"Web Service"**
2. Connect your GitHub repository
3. Configure the service:

   **Basic Settings:**
   - **Name**: university-admin-app (or your preferred name)
   - **Region**: Same as your database
   - **Branch**: main (or your default branch)
   - **Root Directory**: Leave blank
   - **Runtime**: Python 3
   - **Build Command**: `./build.sh`
   - **Start Command**: `gunicorn app:app`

   **Environment Variables:**
   Click **"Add Environment Variable"** and add:
   
   | Key | Value |
   |-----|-------|
   | `DATABASE_URL` | Paste the **Internal Database URL** from Step 3 (Note: Render provides this as `postgres://...` but the app will automatically convert it to `postgresql://...`) |
   | `FLASK_ENV` | `production` |
   | `SECRET_KEY` | Generate a secure random string (e.g., use https://randomkeygen.com/) |
   | `PYTHON_VERSION` | `3.9.18` |

   **Instance Type:**
   - **Plan**: Free (or paid as needed)

4. Click **"Create Web Service"**

### Step 6: Deploy

1. Render will automatically:
   - Install dependencies from `requirements.txt`
   - Run the build script (`build.sh`)
   - Start your application with gunicorn
2. Wait for deployment (3-5 minutes for first deploy)
3. Monitor the logs for any errors

### Step 7: Verify Deployment

1. Once deployed, Render will provide a URL like: `https://university-admin-app.onrender.com`
2. Visit your app URL
3. Test the API endpoints:
   - `https://your-app.onrender.com/bd/api/v1.0/area`
   - `https://your-app.onrender.com/bd/api/v1.0/school`

## Important Notes

### Database Configuration
- The app is configured to use PostgreSQL in production via the `DATABASE_URL` environment variable
- The `web/app.py` file already has the configuration: 
  ```python
  app.config['SQLALCHEMY_DATABASE_URI'] = os.environ.get(
      "DATABASE_URL",
      "sqlite:///local.db"
  )
  ```

### Free Tier Limitations (Render Free Plan)
- **Web Service**: Spins down after 15 minutes of inactivity (first request may be slow)
- **PostgreSQL**: 90 days of database storage, then expires
- **Build Minutes**: 400 minutes/month
- **Bandwidth**: 100 GB/month

### Environment Variables You May Want to Add
- `WTF_CSRF_ENABLED` - Already set to `True` in code
- Any API keys for SMS service (Util.SendSMSByZA)
- Any other third-party service credentials

### Security Recommendations
1. Change the `SECRET_KEY` from the hardcoded value to environment variable
2. Consider using environment variables for sensitive data
3. Enable HTTPS (Render provides this automatically)
4. Review and update CORS settings if needed

### Monitoring
- Check Render's dashboard for logs
- Set up log retention (paid feature)
- Monitor database usage

### Updating Your App
After deployment, to update:
```bash
git add .
git commit -m "Your update message"
git push origin main
```
Render will auto-deploy on push (if auto-deploy is enabled).

## Troubleshooting

### Database Connection Issues
- Verify `DATABASE_URL` is correctly set
- Ensure database is in the same region as web service
- Check database is not paused/expired

### Build Failures
- Check build logs in Render dashboard
- Verify all dependencies in `requirements.txt` are compatible
- Ensure `build.sh` has execute permissions

### Application Errors
- Check application logs in Render dashboard
- Verify all environment variables are set correctly
- Test database connection

## Support
- Render Documentation: https://render.com/docs
- Render Community: https://community.render.com/
