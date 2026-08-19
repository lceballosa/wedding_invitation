# Deploying to Render

This document explains how to deploy the Flutter wedding invitation web app to Render.com.

## Prerequisites

1. A GitHub/GitLab account
2. A Render.com account (free tier available)
3. Git installed locally

## Deployment Steps

### Choose Your Deployment Method

**Option A: Static Site (Simplest)** ✅ RECOMMENDED
- Serve the pre-built `build/web` files
- No rebuild on Render
- Fastest deployment
- You handle compilation locally

**Option B: Dockerfile (Advanced)**
- Render automatically rebuilds when you push code
- Larger build files uploaded
- Takes longer to deploy
- Use only if you want automatic rebuilds

### 1. Initialize Git Repository (if not already done)

```bash
cd wedding_invitation
git init
git add .
git commit -m "Initial commit - Flutter wedding invitation web app"
```

### 2. Push to GitHub/GitLab

Create a new repository on GitHub/GitLab and push your code:

```bash
git remote add origin https://github.com/YOUR_USERNAME/wedding_invitation.git
git branch -M main
git push -u origin main
```

### 3. Deploy on Render.com

Since Render doesn't have native Dart support, use this approach:

1. Go to [render.com](https://render.com)
2. Sign in or create an account
3. Click "New +" button and select "Static Site"
4. Select "Build and deploy from a Git repository"
5. Connect your GitHub/GitLab account
6. Select the `wedding_invitation` repository
7. Fill in the deployment details:
   - **Name**: `wedding-invitation` (or your preferred name)
   - **Build Command**: Leave empty (we'll serve pre-built files)
   - **Publish directory**: `build/web`
8. Scroll down and make sure the following are configured:
   - **Branch**: main
9. Click "Create Static Site"

**Note**: The `build/web` directory already contains your compiled Flutter web app. Render will simply serve these files as a static website.

### Alternative: Using render.yaml with Dockerfile

If you want Render to rebuild on every deployment:

The `render.yaml` file is configured for this, but you'll also need a `Dockerfile` because Render doesn't have native Dart. See the Dockerfile section below.

### 4. Monitor Deployment

Once deployed, Render will:
1. Clone your repository
2. Run the build command (`flutter build web --release`)
3. Serve the contents of `build/web` folder

You can watch the deployment progress in the Render dashboard.

### 5. Access Your App

Once deployment is complete, your app will be available at a URL like:
```
https://wedding-invitation.onrender.com
```

## Custom Domain (Optional)

To use a custom domain:

1. In the Render dashboard, go to your service settings
2. Scroll to "Custom Domain"
3. Add your domain name
4. Follow the DNS instructions to point your domain to Render

## Updating Your App

To update the app after changes:

1. Make your changes locally
2. Commit and push to GitHub/GitLab:
   ```bash
   git add .
   git commit -m "Update app with changes"
   git push origin main
   ```

If using **Static Site** (Recommended):
- You need to rebuild locally: `flutter build web --release`
- Then commit and push

If using **Dockerfile** option:
- Render will automatically rebuild when you push to main
- No local rebuild needed (but ensure your code compiles first!)

## Using Dockerfile Option (Advanced)

If you prefer Render to rebuild automatically:

1. Instead of "Static Site", create a "Web Service"
2. Select "Build and deploy from a Git repository"
3. Render will detect the `Dockerfile` in the root
4. Configure:
   - **Build Command**: Leave empty (Dockerfile handles it)
   - **Start Command**: Leave empty (Dockerfile handles it)
5. Deploy

**Pros**: 
- Automatic rebuilds on every push
- Don't need to compile locally

**Cons**:
- Slower deployment (5-10 minutes for Flutter build)
- Uses more build resources
- Overkill for a static site

## Environment Variables

If your app needs environment variables:

1. In Render dashboard, go to "Environment" tab
2. Add your variables
3. They will be available during the build process if needed

## Troubleshooting

- **Build fails**: Check the build logs in Render dashboard. Ensure Flutter is installed properly.
- **Page not found on navigation**: The `render.yaml` includes routing configuration to handle SPA navigation automatically.
- **Large build size**: The `flutter build web --release` creates an optimized build. Consider using `--web-renderer html` for smaller builds if needed.

## Costs

Render's free tier includes:
- 750 hours/month of hosting
- Enough for a small to medium website

For persistent apps, consider a paid plan.
