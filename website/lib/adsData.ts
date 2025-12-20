// Sample ad data structure
export interface Ad {
    id: string;
    videoUrl: string;
    title: string;
    description: string;
    thumbnailUrl: string;
    ctaText: string;
    targetUrl: string;
    isActive: boolean;
    order: number;
    createdAt: string;
}

// Initial sample ads
export const initialAds: Ad[] = [
    {
        id: '1',
        videoUrl: 'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4',
        title: 'Sample Ad 1',
        description: 'This is a sample advertisement. Watch to see amazing content!',
        thumbnailUrl: 'https://via.placeholder.com/400x600/FF6B6B/FFFFFF?text=Ad+1',
        ctaText: 'Learn More',
        targetUrl: 'https://example.com',
        isActive: true,
        order: 1,
        createdAt: new Date().toISOString(),
    },
    {
        id: '2',
        videoUrl: 'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ElephantsDream.mp4',
        title: 'Sample Ad 2',
        description: 'Another exciting advertisement for you to enjoy!',
        thumbnailUrl: 'https://via.placeholder.com/400x600/4ECDC4/FFFFFF?text=Ad+2',
        ctaText: 'Shop Now',
        targetUrl: 'https://example.com',
        isActive: true,
        order: 2,
        createdAt: new Date().toISOString(),
    },
    {
        id: '3',
        videoUrl: 'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerBlazes.mp4',
        title: 'Sample Ad 3',
        description: 'Discover something new with this advertisement!',
        thumbnailUrl: 'https://via.placeholder.com/400x600/45B7D1/FFFFFF?text=Ad+3',
        ctaText: 'Get Started',
        targetUrl: 'https://example.com',
        isActive: true,
        order: 3,
        createdAt: new Date().toISOString(),
    },
];
