# AdReel Website

Companion website for the AdReel mobile app - manage video ads and promote the app.

## Features

- 🎨 **Modern Landing Page**: Beautiful, responsive design with hero section and features
- 🎬 **Admin Dashboard**: Upload and manage video ads that appear in the mobile app
- 📊 **Analytics**: View ad statistics and performance
- 🔌 **API Endpoints**: RESTful API for mobile app integration
- 🚀 **Vercel Ready**: Optimized for deployment to Vercel

## Getting Started

### Prerequisites

- Node.js 18+ installed
- npm or yarn package manager

### Installation

1. Navigate to the website directory:
```bash
cd website
```

2. Install dependencies:
```bash
npm install
```

3. Run the development server:
```bash
npm run dev
```

4. Open [http://localhost:3000](http://localhost:3000) in your browser

## Project Structure

```
website/
├── app/
│   ├── admin/
│   │   └── page.tsx          # Admin dashboard
│   ├── api/
│   │   └── ads/
│   │       └── route.ts      # Ads API endpoints
│   ├── layout.tsx            # Root layout
│   ├── page.tsx              # Landing page
│   └── globals.css           # Global styles
├── lib/
│   └── adsData.ts            # Ad data types
├── public/
│   └── api/
│       └── ads.json          # Ads data storage
└── package.json
```

## Admin Dashboard

Access the admin dashboard at `/admin` to:

- Upload new video ads
- Edit existing ads
- Activate/deactivate ads
- Delete ads
- View ad statistics

### Adding a New Ad

1. Go to `/admin`
2. Click "Add New Ad"
3. Fill in the form:
   - **Video URL**: Direct link to MP4 video or YouTube/Vimeo URL
   - **Title**: Ad title
   - **Description**: Ad description
   - **Thumbnail URL**: Preview image URL
   - **CTA Text**: Call-to-action button text
   - **Target URL**: Where the CTA button links to
   - **Active**: Toggle visibility in mobile app
4. Click "Create Ad"

## API Endpoints

### GET /api/ads
Fetch all ads

**Response:**
```json
{
  "ads": [
    {
      "id": "1",
      "videoUrl": "https://example.com/video.mp4",
      "title": "Sample Ad",
      "description": "Ad description",
      "thumbnailUrl": "https://example.com/thumb.jpg",
      "ctaText": "Learn More",
      "targetUrl": "https://example.com",
      "isActive": true,
      "order": 1,
      "createdAt": "2025-12-20T08:00:00.000Z"
    }
  ]
}
```

### POST /api/ads
Create a new ad

**Request Body:**
```json
{
  "videoUrl": "https://example.com/video.mp4",
  "title": "New Ad",
  "description": "Description",
  "thumbnailUrl": "https://example.com/thumb.jpg",
  "ctaText": "Click Here",
  "targetUrl": "https://example.com",
  "isActive": true
}
```

### PUT /api/ads
Update an existing ad

**Request Body:**
```json
{
  "id": "1",
  "videoUrl": "https://example.com/video.mp4",
  "title": "Updated Ad",
  ...
}
```

### DELETE /api/ads?id={id}
Delete an ad

**Query Parameters:**
- `id`: Ad ID to delete

## Deployment to Vercel

### One-Click Deploy

[![Deploy with Vercel](https://vercel.com/button)](https://vercel.com/new)

### Manual Deployment

1. Install Vercel CLI:
```bash
npm install -g vercel
```

2. Deploy:
```bash
vercel
```

3. Follow the prompts to deploy

4. Your site will be live at `https://your-project.vercel.app`

### Environment Variables

No environment variables required for basic functionality. The app uses file-based storage for simplicity.

For production, consider:
- Adding authentication to the admin dashboard
- Using a database (Firebase, Supabase, PostgreSQL)
- Implementing user management
- Adding analytics tracking

## Mobile App Integration

After deploying to Vercel:

1. Copy your deployment URL (e.g., `https://addreel.vercel.app`)
2. Update the mobile app configuration:
   - Open `mobile/src/config/appConfig.ts`
   - Update `api.adsEndpoint` to `https://your-site.vercel.app/api/ads`
3. Rebuild the mobile app

The mobile app will now fetch ads from your admin dashboard!

## Customization

### Styling

The website uses Tailwind CSS. Customize colors and styles in:
- `tailwind.config.ts` - Tailwind configuration
- `app/globals.css` - Global styles
- Component files - Inline Tailwind classes

### Content

Update landing page content in `app/page.tsx`:
- Hero section text
- Features
- Stats
- Footer links

## Production Considerations

For production deployment:

1. **Add Authentication**: Protect the admin dashboard with authentication
2. **Use a Database**: Replace JSON file storage with a proper database
3. **Add Validation**: Implement server-side validation for ad data
4. **Rate Limiting**: Add rate limiting to API endpoints
5. **Analytics**: Integrate analytics (Google Analytics, Plausible, etc.)
6. **CDN**: Use a CDN for video hosting (Cloudflare, AWS CloudFront)
7. **Monitoring**: Set up error tracking (Sentry, LogRocket)

## Support

For issues or questions, contact: support@addreel.com

## License

© 2025 AdReel. All rights reserved.
