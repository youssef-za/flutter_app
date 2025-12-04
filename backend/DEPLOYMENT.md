# Deployment Guide for Render and Railway

This guide explains how to deploy the Medical Emotion Monitoring System on Render or Railway.

## Prerequisites

- Git repository with your code
- Account on Render or Railway
- MySQL database (provided by Render/Railway or external)

## Environment Variables

Set the following environment variables in your deployment platform:

### Required Variables

| Variable | Description | Example |
|----------|-------------|---------|
| `DATABASE_URL` | Full MySQL JDBC URL | `jdbc:mysql://host:port/database?useSSL=true&serverTimezone=UTC` |
| `DATABASE_USERNAME` | MySQL username | `emotion_user` |
| `DATABASE_PASSWORD` | MySQL password | `your_secure_password` |
| `JWT_SECRET` | Secret key for JWT tokens (generate a strong random string) | `your-very-long-random-secret-key` |

### Optional Variables

| Variable | Description | Default |
|----------|-------------|---------|
| `PORT` | Server port | `8080` |
| `SERVER_CONTEXT_PATH` | API context path | `/api` |
| `SPRING_PROFILES_ACTIVE` | Spring profile | `prod` |
| `JWT_EXPIRATION` | JWT token expiration (ms) | `86400000` (24 hours) |
| `CORS_ALLOWED_ORIGINS` | Allowed CORS origins | `http://localhost:3000,http://localhost:4200` |
| `EMOTION_API_URL` | Emotion detection API URL | Hugging Face API |
| `EMOTION_API_KEY` | API key for emotion detection | (empty) |
| `EMOTION_API_ENABLED` | Enable/disable emotion API | `true` |
| `LOG_LEVEL` | Application log level | `INFO` |

## Deployment on Render

### Option 1: Using render.yaml (Recommended)

1. Push your code to GitHub/GitLab
2. In Render dashboard, click "New" → "Blueprint"
3. Connect your repository
4. Render will automatically detect `render.yaml` and configure the service
5. Add a MySQL database:
   - Click "New" → "PostgreSQL" (or use external MySQL)
   - Note the connection details
6. Set environment variables in the service settings
7. Deploy!

### Option 2: Manual Setup

1. In Render dashboard, click "New" → "Web Service"
2. Connect your Git repository
3. Configure:
   - **Name**: `emotion-monitoring-api`
   - **Environment**: `Java`
   - **Build Command**: `mvn clean package -DskipTests`
   - **Start Command**: `java -Dserver.port=$PORT -Dspring.profiles.active=prod -jar target/emotion-monitoring-1.0.0.jar`
4. Add MySQL database and set environment variables
5. Deploy!

### Render MySQL Database Setup

1. Create a new PostgreSQL database (Render doesn't offer MySQL, use external MySQL or adapt to PostgreSQL)
2. Or use an external MySQL service like:
   - [PlanetScale](https://planetscale.com/)
   - [Aiven](https://aiven.io/)
   - [Clever Cloud](https://www.clever-cloud.com/)

## Deployment on Railway

### Using railway.json

1. Install Railway CLI: `npm i -g @railway/cli`
2. Login: `railway login`
3. Initialize project: `railway init`
4. Link to existing project: `railway link`
5. Add MySQL service:
   - `railway add mysql`
   - Railway will automatically set `DATABASE_URL`
6. Set other environment variables:
   ```bash
   railway variables set JWT_SECRET=your-secret-key
   railway variables set SPRING_PROFILES_ACTIVE=prod
   ```
7. Deploy: `railway up`

### Manual Setup via Dashboard

1. Go to [Railway Dashboard](https://railway.app)
2. Click "New Project" → "Deploy from GitHub repo"
3. Select your repository
4. Add MySQL service from the template
5. Set environment variables in the Variables tab
6. Railway will auto-detect and deploy

## Generating JWT Secret

Generate a strong JWT secret:

```bash
# Using OpenSSL
openssl rand -base64 64

# Using Node.js
node -e "console.log(require('crypto').randomBytes(64).toString('base64'))"

# Using Python
python -c "import secrets; print(secrets.token_urlsafe(64))"
```

## Database Migration

The application uses `spring.jpa.hibernate.ddl-auto=update` in development and `validate` in production.

For production, consider:
1. Using Flyway or Liquibase for migrations
2. Running migrations manually before deployment
3. Using `update` mode (not recommended for production)

## Health Check

The application exposes a health check endpoint:
- `GET /api/auth/validate` - Returns 200 if the service is running

## Troubleshooting

### Application won't start

1. Check logs: `railway logs` or Render logs
2. Verify environment variables are set correctly
3. Check database connectivity
4. Ensure PORT is set correctly

### Database Connection Issues

1. Verify `DATABASE_URL` format:
   ```
   jdbc:mysql://host:port/database?useSSL=true&serverTimezone=UTC
   ```
2. Check database is accessible from deployment platform
3. Verify credentials are correct
4. Check firewall/security groups

### Build Failures

1. Ensure Java 17 is available
2. Check Maven dependencies download correctly
3. Verify `pom.xml` is correct
4. Check build logs for specific errors

## Monitoring

- **Render**: Built-in metrics and logs
- **Railway**: Built-in metrics and logs
- Consider adding:
  - Application Performance Monitoring (APM)
  - Error tracking (Sentry, Rollbar)
  - Log aggregation (Logtail, Papertrail)

## Security Checklist

- [ ] JWT_SECRET is set and strong (64+ characters)
- [ ] Database credentials are secure
- [ ] CORS origins are restricted to your frontend
- [ ] HTTPS is enabled (automatic on Render/Railway)
- [ ] Environment variables are not committed to Git
- [ ] Database uses SSL connections
- [ ] API keys are stored securely

## Post-Deployment

1. Test the API endpoints
2. Verify database connections
3. Test authentication flow
4. Monitor logs for errors
5. Set up alerts for critical issues

## Support

For issues:
- Check application logs
- Verify environment variables
- Test database connectivity
- Review Spring Boot documentation

