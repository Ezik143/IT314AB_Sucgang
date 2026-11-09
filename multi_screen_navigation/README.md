**Issue 1: The "Host Identification Has Changed" Error**

ssh-keygen -R 16.176.239.125

# Complete Flutter Web Deployment to AWS Lightsail - Exam Guide

## **PART 1: AWS LIGHTSAIL SETUP**

### **Step 1.1: Create Your Instance**

1. Go to AWS Lightsail console
2. Click **Create instance**
3. Choose **Linux/Unix** blueprint (Ubuntu 22.04 or later)
4. Choose your instance plan (smallest is fine for testing)
5. Click **Create instance**

### **Step 1.2: Create Static IP**

1. In Lightsail, click **Networking** tab on your instance
2. Click **Attach static IP**
3. Click **Create** and attach it
4. **Note down your Static IP** (e.g., `16.176.239.125`)

### **Step 1.3: Configure Firewall**

1. Click **Networking** tab on your instance
2. Under **Firewall**, click **Add rule**
3. Add these rules:
   - **Application**: HTTP | **Port**: 80
   - **Application**: HTTPS | **Port**: 443
   - **Application**: SSH | **Port**: 22
4. For HTTP rule, set **Source** to **Anywhere** (0.0.0.0/0)

---

## **PART 2: SERVER PREPARATION**

### **Step 2.1: Connect to Your Server**

**Option A - Browser Terminal:**

- Click **Connect** using browser-based SSH in Lightsail console

**Option B - Local Terminal (PowerShell/Terminal):**

```bash
ssh -i "path/to/your-key.pem" ubuntu@YOUR_STATIC_IP
```

(Type `yes` if asked to continue, this is normal)

### **Step 2.2: Install Nginx and Create Deploy User**

Run these commands **one by one**:

```bash
# Update package list and install Nginx
sudo apt update && sudo apt install nginx -y

# Create deploy user (no password, for CI/CD)
sudo adduser --disabled-password --gecos "" deploy

# Create SSH directory for deploy user
sudo mkdir -p /home/deploy/.ssh
sudo chmod 700 /home/deploy/.ssh
```

### **Step 2.3: Generate SSH Key for GitHub Actions**

```bash
# Generate SSH key pair
sudo ssh-keygen -t ed25519 -C "github-actions-deploy" -f /home/deploy/.ssh/id_ed25519 -N ""

# Copy public key to authorized_keys
sudo cp /home/deploy/.ssh/id_ed25519.pub /home/deploy/.ssh/authorized_keys

# Set correct ownership and permissions
sudo chown -R deploy:deploy /home/deploy/.ssh
sudo chmod 600 /home/deploy/.ssh/authorized_keys
```

### **Step 2.4: Create Web Directory**

```bash
# Create directory structure
sudo mkdir -p /var/www/sucgang_app/build/web

# Set ownership to deploy user
sudo chown -R deploy:deploy /var/www/sucgang_app
```

### **Step 2.5: Configure Nginx**

```bash
# Open Nginx config file
sudo nano /etc/nginx/sites-available/sucgang_app
```

**Paste this exact configuration:**

```
server {
    listen 80;
    server_name _;
    root /var/www/sucgang_app/build/web;
    index index.html;

    location / {
        try_files $uri $uri/ /index.html;
    }
}
```

**Save and exit:** Press `Ctrl+O`, `Enter`, then `Ctrl+X`

**Enable the site:**

```bash
# Create symbolic link
sudo ln -s /etc/nginx/sites-available/sucgang_app /etc/nginx/sites-enabled/

# Remove default site
sudo rm -f /etc/nginx/sites-enabled/default

# Test Nginx configuration
sudo nginx -t

# Reload Nginx
sudo systemctl reload nginx
```

### **Step 2.6: Grant Passwordless Sudo to Deploy User**

```bash
echo "deploy ALL=(ALL) NOPASSWD: ALL" | sudo tee /etc/sudoers.d/deploy
```

### **Step 2.7: Copy Private Key for GitHub**

```bash
# Display the private key
sudo cat /home/deploy/.ssh/id_ed25519
```

**CRITICAL:** Copy the **ENTIRE** output including:

- `----BEGIN OPENSSH PRIVATE KEY-----`
- All the middle lines
- `----END OPENSSH PRIVATE KEY-----`

---

## **PART 3: GITHUB REPOSITORY SETUP**

### **Step 3.1: Add GitHub Secrets**

1. Go to your GitHub repository
2. Click **Settings** → **Secrets and variables** → **Actions**
3. Click **New repository secret** (do this 4 times)

**Secret 1:**

- **Name:** `LIGHTSAIL_HOST`
- **Value:** Your Static IP (e.g., `16.176.239.125`)

**Secret 2:**

- **Name:** `LIGHTSAIL_USER`
- **Value:** `deploy`

**Secret 3:**

- **Name:** `LIGHTSAIL_SSH_KEY`
- **Value:** Paste the ENTIRE private key from Step 2.7 (must include BEGIN and END lines)

**Secret 4:**

- **Name:** `LIGHTSAIL_PORT`
- **Value:** `22`

### **Step 3.2: Create GitHub Actions Workflow**

1. In your repository, click **Add file** → **Create new file**
2. In the filename box, type: `.github/workflows/deploy.yml`
3. **Paste this exact workflow:**

```yaml
name: Deploy Flutter Web to AWS Lightsail

on:
  push:
    branches: ["main"]

jobs:
  build-and-deploy:
    runs-on: ubuntu-latest
    defaults:
      run:
        working-directory: ./multi_screen_navigation

    steps:
      - name: Checkout repository
        uses: actions/checkout@v4

      - name: Setup Flutter
        uses: subosito/flutter-action@v2
        with:
          channel: "stable"

      - name: Install dependencies
        run: flutter pub get

      - name: Build Flutter Web
        run: flutter build web --release

      - name: Copy build files to server via SCP
        uses: appleboy/scp-action@v0.1.7
        with:
          host: ${{ secrets.LIGHTSAIL_HOST }}
          username: ${{ secrets.LIGHTSAIL_USER }}
          key: ${{ secrets.LIGHTSAIL_SSH_KEY }}
          port: ${{ secrets.LIGHTSAIL_PORT }}
          source: "multi_screen_navigation/build/web/*"
          target: "/tmp/flutter_deploy"
          overwrite: true
          rm: false

      - name: Set Permissions and Reload Nginx
        uses: appleboy/ssh-action@v1.0.3
        with:
          host: ${{ secrets.LIGHTSAIL_HOST }}
          username: ${{ secrets.LIGHTSAIL_USER }}
          key: ${{ secrets.LIGHTSAIL_SSH_KEY }}
          port: ${{ secrets.LIGHTSAIL_PORT }}
          script_stop: true
          script: |
            set -euo pipefail

            # Clear old web files and move new files into place safely
            sudo rm -rf /var/www/sucgang_app/build/web
            sudo mkdir -p /var/www/sucgang_app/build/web
            sudo cp -r /tmp/flutter_deploy/* /var/www/sucgang_app/build/web/
            sudo rm -rf /tmp/flutter_deploy

            # Handout Section 3: Correct standard web directory permissions
            sudo chown -R www-data:www-data /var/www/sucgang_app
            sudo find /var/www/sucgang_app -type d -exec chmod 755 {} \;
            sudo find /var/www/sucgang_app -type f -exec chmod 644 {} \;

            # Handout Section 4: Graceful service reload
            sudo systemctl reload nginx
```

1. Click **Commit changes...** to save and trigger deployment

---

## **PART 4: MONITOR AND TEST**

### **Step 4.1: Watch GitHub Actions**

1. Click **Actions** tab in your repository
2. Click on the running workflow
3. Wait for all steps to show green checkmarks ✅

### **Step 4.2: Test Your Live App**

1. Open a new browser tab
2. Go to: `http://YOUR_STATIC_IP` (e.g., `http://16.176.239.125`)
3. Press `Ctrl + F5` (hard refresh)
4. You should see your Flutter web app!

---

## **PART 5: TROUBLESHOOTING**

### **If you see "Welcome to nginx!" page:**

```bash
# Remove default site and reload
sudo rm /etc/nginx/sites-enabled/default
sudo systemctl reload nginx
```

### **If you see 403 Forbidden:**

```bash
# Check where index.html is
find /var/www/sucgang_app -name "index.html"

# If files are nested, move them
sudo mv /var/www/sucgang_app/build/web/build/web/* /var/www/sucgang_app/build/web/
sudo rm -rf /var/www/sucgang_app/build/web/build

# Fix permissions
sudo chown -R www-data:www-data /var/www/sucgang_app
sudo find /var/www/sucgang_app -type d -exec chmod 755 {} \;
sudo find /var/www/sucgang_app -type f -exec chmod 644 {} \;
sudo systemctl reload nginx
```

### **If GitHub Actions fails with SSH error:**

1. Verify `LIGHTSAIL_SSH_KEY` secret includes BEGIN and END lines
2. Make sure there are no extra spaces or missing lines
3. Re-run the workflow

### **If you see 500 Internal Server Error:**

```bash
# Check Nginx error log
sudo tail -n 20 /var/log/nginx/error.log

# Verify files exist
ls -la /var/www/sucgang_app/build/web/
```

---

## **PART 6: VERIFICATION CHECKLIST**

✅ **Server Status:**

```bash
sudo systemctl status nginx
# Should show: Active: active (running)
```

✅ **File Permissions:**

```bash
ls -la /var/www/sucgang_app/build/web/
# Should show: owner www-data, dirs 755, files 644
```

✅ **Storage Space:**

```bash
df -h
# Root filesystem should be under 80%
```

✅ **Reboot Test:**

```bash
sudo reboot
# After 60 seconds, your app should still load at http://YOUR_IP
```

---

## **KEY COMMANDS REFERENCE**
