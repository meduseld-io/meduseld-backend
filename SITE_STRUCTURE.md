# Meduseld Site Structure

Visual guide to how the site is organized.

## URL Structure

```
meduseld.io
├── /                    → Landing page (public)
├── /menu                → Services hub (requires Tailscale)
│
panel.meduseld.io        → Icarus control panel (requires Tailscale)
│
[future].meduseld.io     → Future services (requires Tailscale)
```

## User Flow

```
┌─────────────────────────────────────────────────────────────┐
│  User connects to Tailscale (404@meduseld.io)               │
└─────────────────────────────────────────────────────────────┘
                            │
                            ▼
┌─────────────────────────────────────────────────────────────┐
│  https://meduseld.io                                         │
│  ┌───────────────────────────────────────────────────────┐  │
│  │  Landing Page                                          │  │
│  │  - Logo                                                │  │
│  │  - "Meduseld"                                          │  │
│  │  - "404 Server Not Found"                             │  │
│  │  - [Enter the Great Hall] button                      │  │
│  └───────────────────────────────────────────────────────┘  │
└─────────────────────────────────────────────────────────────┘
                            │
                            ▼
┌─────────────────────────────────────────────────────────────┐
│  https://meduseld.io/menu                                    │
│  ┌───────────────────────────────────────────────────────┐  │
│  │  Services Menu                                         │  │
│  │  ┌──────────────┐  ┌──────────────┐  ┌─────────────┐ │  │
│  │  │ Icarus       │  │ Entertainment│  │ More        │ │  │
│  │  │ Server       │  │ Server       │  │ Services    │ │  │
│  │  │              │  │              │  │             │ │  │
│  │  │ [Open Panel] │  │ [Coming Soon]│  │[Coming Soon]│ │  │
│  │  └──────────────┘  └──────────────┘  └─────────────┘ │  │
│  └───────────────────────────────────────────────────────┘  │
└─────────────────────────────────────────────────────────────┘
                            │
                            ▼
┌─────────────────────────────────────────────────────────────┐
│  https://panel.meduseld.io                                   │
│  ┌───────────────────────────────────────────────────────┐  │
│  │  Icarus Control Panel                                  │  │
│  │  - Server status                                       │  │
│  │  - Start/Stop/Restart/Kill buttons                    │  │
│  │  - Resource graphs                                     │  │
│  │  - Live logs                                           │  │
│  └───────────────────────────────────────────────────────┘  │
└─────────────────────────────────────────────────────────────┘
```

## Access Control

### Public (No Tailscale Required)
- None currently
- Landing page is behind Tailscale

### Tailscale Required
- `meduseld.io` - Landing page
- `meduseld.io/menu` - Services hub
- `panel.meduseld.io` - Icarus panel
- All future services

## Host Routing Logic

The webserver routes based on hostname:

```python
meduseld.io
├── /           → landing.html
├── /menu       → menu.html
└── /api/*      → Blocked (403)

panel.meduseld.io
├── /           → dashboard.html
├── /api/*      → API endpoints
└── /start      → Control endpoints
    /stop
    /restart
    /kill

localhost (development)
└── /           → dashboard.html (direct access)
```

## File Mapping

```
URL                          Template File
─────────────────────────────────────────────────────
meduseld.io                  → landing.html
meduseld.io/menu             → menu.html
panel.meduseld.io            → dashboard.html
panel.meduseld.io/api/stats  → JSON response
```

## Future Expansion

When adding new services:

```
meduseld.io/menu
├── Icarus Server      → panel.meduseld.io
├── Media Server       → media.meduseld.io
├── File Server        → files.meduseld.io
├── Minecraft Server   → minecraft.meduseld.io
└── [Add more...]
```

Each service gets its own subdomain and card on the menu.

## Security Layers

```
┌─────────────────────────────────────────┐
│  Internet                                │
└─────────────────────────────────────────┘
                  │
                  ▼
┌─────────────────────────────────────────┐
│  Cloudflare                              │
│  - DDoS protection                       │
│  - SSL/TLS                               │
│  - DNS                                   │
└─────────────────────────────────────────┘
                  │
                  ▼
┌─────────────────────────────────────────┐
│  Tailscale VPN                           │
│  - Authentication (404@meduseld.io)      │
│  - Encrypted tunnel                      │
│  - Access control                        │
└─────────────────────────────────────────┘
                  │
                  ▼
┌─────────────────────────────────────────┐
│  Your Server                             │
│  - Flask app (port 5000)                 │
│  - Host-based routing                    │
│  - Rate limiting                         │
│  - Activity logging                      │
└─────────────────────────────────────────┘
```

## DNS Configuration

In Cloudflare:

```
Type    Name      Content           Proxy
────────────────────────────────────────────
A       @         YOUR_SERVER_IP    ✓ (orange)
A       panel     YOUR_SERVER_IP    ✓ (orange)
A       media     YOUR_SERVER_IP    ✓ (orange)  [future]
A       files     YOUR_SERVER_IP    ✓ (orange)  [future]
```

## Port Configuration

```
Service                Port    Access
──────────────────────────────────────────
Flask Panel            5000    Internal only
Cloudflare → Server    443     HTTPS (external)
Icarus Game Server     17777   UDP (game traffic)
Icarus Query Port      27015   UDP (server browser)
```

## Navigation Flow

```
Landing → Menu → Service
   ↑        ↓
   └────────┘
   (back link)
```

Users can:
1. Start at landing
2. Go to menu
3. Pick a service
4. Use back button or type URL to return

## Mobile Experience

Same flow on mobile:
- Responsive design
- Touch-friendly buttons
- Cards stack vertically
- Works in any mobile browser

## Bookmarking

Recommended bookmarks for users:
- `https://meduseld.io/menu` - Quick access to services
- `https://panel.meduseld.io` - Direct to Icarus panel

## Adding Authentication (Future)

If you want to add login:

```
meduseld.io
├── /           → Landing (public)
├── /login      → Login page
└── /menu       → Services (requires login)
```

This would replace Tailscale authentication with web-based login.

---

Current setup is simple and scalable. Easy to add new services as you grow!
