# Adding New Services to the Menu

Guide for adding new services to the Meduseld services menu.

## Current Structure

```
meduseld.io              → Landing page
meduseld.io/menu         → Services menu (hub)
panel.meduseld.io        → Icarus control panel
[future].meduseld.io     → Future services
```

## How to Add a New Service

### Step 1: Create the Service

Set up your new service (e.g., Plex, Jellyfin, file server, etc.) on a subdomain:
- `media.meduseld.io`
- `files.meduseld.io`
- `minecraft.meduseld.io`
- etc.

### Step 2: Update DNS

In Cloudflare, add a new DNS record:
- Type: A
- Name: `media` (or whatever subdomain)
- Content: Your server IP
- Proxy: Enabled (orange cloud)

### Step 3: Add to Menu

Edit `templates/menu.html` and replace one of the "Coming Soon" cards:

```html
<!-- Entertainment Server -->
<div class="col-md-6 col-lg-4">
  <div class="card h-100 text-white bg-dark border-warning" style="transition: transform 0.2s;">
    <div class="card-body d-flex flex-column text-center p-4">
      <div class="mb-3">
        <i class="cil-movie" style="font-size: 3rem; color: #e6c65c;"></i>
      </div>
      <h3 class="card-title mb-3" style="color:#e6c65c;">Media Server</h3>
      <p class="card-text mb-4 flex-grow-1">
        Stream movies, TV shows, and music. Powered by Plex/Jellyfin.
      </p>
      <a href="https://media.meduseld.io" class="btn btn-warning btn-lg">
        Open Media Server
      </a>
    </div>
  </div>
</div>
```

### Step 4: Update Allowed Hosts

Edit `config.py` and add the new subdomain:

```python
ALLOWED_HOSTS = [
    "localhost",
    "127.0.0.1",
    "meduseld.io",
    "panel.meduseld.io",
    "media.meduseld.io",  # Add new subdomain
]
```

### Step 5: Restart Panel

```cmd
restart_panel.bat
```

### Step 6: Test

1. Go to https://meduseld.io
2. Click "Enter the Great Hall"
3. You should see the new service card
4. Click it to access the service

## Icon Options

Available CoreUI icons (change `cil-*` class):

- `cil-gamepad` - Gaming
- `cil-movie` - Media/Entertainment
- `cil-cloud` - Cloud/Storage
- `cil-music` - Music
- `cil-settings` - Settings/Admin
- `cil-folder` - Files
- `cil-chat` - Chat/Communication
- `cil-monitor` - Monitoring
- `cil-terminal` - Terminal/SSH
- `cil-book` - Documentation

Full list: https://coreui.io/icons/

## Card Colors

Change the border color:
- `border-warning` - Yellow/Gold (active services)
- `border-success` - Green
- `border-info` - Blue
- `border-danger` - Red
- `border-secondary` - Gray (coming soon)

## Example Services

### Media Server (Plex/Jellyfin)
```html
<i class="cil-movie" style="font-size: 3rem; color: #e6c65c;"></i>
<h3>Media Server</h3>
<a href="https://media.meduseld.io">Open Media Server</a>
```

### File Server (Nextcloud)
```html
<i class="cil-cloud" style="font-size: 3rem; color: #e6c65c;"></i>
<h3>File Storage</h3>
<a href="https://files.meduseld.io">Open File Server</a>
```

### Minecraft Server
```html
<i class="cil-gamepad" style="font-size: 3rem; color: #e6c65c;"></i>
<h3>Minecraft Server</h3>
<a href="https://minecraft.meduseld.io">Open Control Panel</a>
```

### Discord Bot Dashboard
```html
<i class="cil-chat" style="font-size: 3rem; color: #e6c65c;"></i>
<h3>Discord Bot</h3>
<a href="https://bot.meduseld.io">Open Dashboard</a>
```

### Monitoring (Grafana/Uptime Kuma)
```html
<i class="cil-monitor" style="font-size: 3rem; color: #e6c65c;"></i>
<h3>Monitoring</h3>
<a href="https://monitor.meduseld.io">Open Dashboard</a>
```

## Layout

The menu uses a responsive grid:
- Desktop: 3 cards per row
- Tablet: 2 cards per row
- Mobile: 1 card per row

Cards automatically adjust to fit the content.

## Adding More Than 3 Services

Just keep adding cards - they'll wrap to new rows automatically:

```html
<div class="row g-4 justify-content-center">
  <!-- Card 1 -->
  <!-- Card 2 -->
  <!-- Card 3 -->
  <!-- Card 4 -->
  <!-- Card 5 -->
  <!-- etc... -->
</div>
```

## Removing "Coming Soon" Cards

To remove a placeholder card, just delete the entire `<div class="col-md-6 col-lg-4">...</div>` block.

## Custom Styling

Each card can have custom styling:

```html
<div class="card h-100 text-white bg-dark border-warning" 
     style="transition: transform 0.2s; background: linear-gradient(135deg, #1a1a1a 0%, #2d2d2d 100%);">
```

## Testing Locally

Before deploying:

1. Edit `templates/menu.html`
2. Run `restart_panel.bat`
3. Go to `http://localhost:5000/menu`
4. Check the new card appears correctly
5. Test the link works

## Checklist for New Service

- [ ] Service is running and accessible
- [ ] DNS record added in Cloudflare
- [ ] Subdomain added to `config.py` ALLOWED_HOSTS
- [ ] Card added to `templates/menu.html`
- [ ] Icon and colors chosen
- [ ] Description written
- [ ] Panel restarted
- [ ] Tested from menu
- [ ] Updated USER_GUIDE.md if needed

## Future Enhancements

Ideas for the menu page:

1. **Service Status Indicators**
   - Show if service is online/offline
   - Requires API integration

2. **Authentication**
   - Login before accessing menu
   - Different services for different users

3. **Service Stats**
   - Show usage stats on cards
   - Player counts, uptime, etc.

4. **Search/Filter**
   - Search for services
   - Filter by category

5. **Favorites**
   - Pin frequently used services
   - Customize order

Let me know if you want any of these features added!

---

Keep it simple and add services as you need them. The menu is designed to grow with your server!
