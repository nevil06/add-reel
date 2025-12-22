# 📹 How to Add Your Company Video Ads

## 🎯 Quick Guide

Your company video ads are defined in:
**`lib/services/api_service.dart`** → `_getFallbackAds()` method (lines 55-100)

---

## 📝 Template for Adding New Ads

Copy this template and fill in your company's details:

```dart
Ad(
  id: '4',                              // Unique ID (increment: 4, 5, 6...)
  companyId: 'company-123',             // Your company ID
  companyName: 'Your Company Name',     // Company name to display
  videoUrl: 'https://your-video-url.mp4', // Direct link to MP4 video
  title: 'Your Ad Title',               // Ad title (short & catchy)
  description: 'Your ad description here', // What the ad is about
  thumbnailUrl: 'https://your-thumbnail.jpg', // Thumbnail image URL
  ctaText: 'Shop Now',                  // Button text (Shop Now, Learn More, etc.)
  targetUrl: 'https://your-website.com', // Where button leads
  isActive: true,                       // true = show, false = hide
  order: 4,                             // Display order (1, 2, 3, 4...)
  createdAt: DateTime.now(),            // Auto timestamp
),
```

---

## 🚀 Example: Adding a Real Company Ad

Let's say you have a company called "TechGadgets":

```dart
Ad(
  id: '4',
  companyId: 'techgadgets-001',
  companyName: 'TechGadgets',
  videoUrl: 'https://cdn.techgadgets.com/ads/promo-2024.mp4',
  title: 'New Smartphone Launch!',
  description: 'Check out our latest flagship phone with amazing features',
  thumbnailUrl: 'https://cdn.techgadgets.com/thumbnails/phone.jpg',
  ctaText: 'Buy Now',
  targetUrl: 'https://techgadgets.com/new-phone',
  isActive: true,
  order: 4,
  createdAt: DateTime.now(),
),
```

---

## 📍 Where to Add Your Ads

### Option 1: Edit the File Directly

1. Open: `lib/services/api_service.dart`
2. Find the `_getFallbackAds()` method (line 55)
3. Add your new `Ad(...)` entry before the closing `];`
4. Save the file
5. Hot reload the app (press `r` in terminal)

### Option 2: I Can Add Them For You!

Just provide me with:
1. **Company Name**
2. **Video URL** (must be .mp4 format)
3. **Ad Title**
4. **Description**
5. **Button Text** (e.g., "Shop Now", "Learn More")
6. **Website URL** (where button leads)

---

## 🎬 Video Requirements

### ✅ Supported Formats:
- MP4 (recommended)
- WebM
- MOV

### ✅ Best Practices:
- **Duration**: 15-30 seconds
- **Resolution**: 1080x1920 (vertical) or 1920x1080 (horizontal)
- **Size**: Under 50MB for fast loading
- **Hosting**: Use CDN (Cloudflare, AWS S3, etc.)

### ✅ Where to Host Videos:
- **YouTube**: Not recommended (requires YouTube player)
- **Vimeo**: Works with direct .mp4 link
- **AWS S3**: ✅ Best option
- **Cloudflare R2**: ✅ Good option
- **Google Drive**: ⚠️ Requires public sharing

---

## 📊 Current Ads in Your App

Right now you have **3 sample ads**:

| ID | Company | Title | Video |
|----|---------|-------|-------|
| 1 | Sample Company | Sample Ad 1 | Big Buck Bunny |
| 2 | Sample Company | Sample Ad 2 | Elephants Dream |
| 3 | Sample Company | Sample Ad 3 | For Bigger Blazes |

**You can replace these or add more!**

---

## 🔄 How to Update

### After Adding Ads:

1. **Save the file**
2. **In the terminal** where Flutter is running, press:
   - `r` = Hot reload (fast, keeps state)
   - `R` = Hot restart (full restart)
3. **Check the Feed** in your browser
4. **Swipe up/down** to see your new ads!

---

## 💡 Pro Tips

### Multiple Companies:
```dart
// Company 1
Ad(id: '1', companyId: 'company-a', companyName: 'Company A', ...),
Ad(id: '2', companyId: 'company-a', companyName: 'Company A', ...),

// Company 2  
Ad(id: '3', companyId: 'company-b', companyName: 'Company B', ...),
Ad(id: '4', companyId: 'company-b', companyName: 'Company B', ...),
```

### Seasonal Ads:
```dart
Ad(
  id: '5',
  title: 'Christmas Sale!',
  isActive: true, // Set to false after Christmas
  ...
),
```

### A/B Testing:
```dart
// Show only one at a time
Ad(id: '6', title: 'Version A', isActive: true, ...),
Ad(id: '7', title: 'Version B', isActive: false, ...),
```

---

## 🎯 Ready to Add Your Ads?

**Tell me:**
1. How many company ads do you want to add?
2. Do you have the video URLs ready?
3. Should I replace the sample ads or add new ones?

**Or just give me the details and I'll add them for you!** 🚀
