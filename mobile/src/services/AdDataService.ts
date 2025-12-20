import AsyncStorage from '@react-native-async-storage/async-storage';
import { Ad } from '../types';
import { APP_CONFIG } from '../config/appConfig';

const STORAGE_KEY = 'addreel_ads';
const LAST_FETCH_KEY = 'addreel_ads_last_fetch';

// Fallback ads for testing/offline mode
const FALLBACK_ADS: Ad[] = [
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

class AdDataService {
    // Fetch ads from API or use fallback
    async fetchAds(): Promise<Ad[]> {
        try {
            // Try to fetch from API
            const response = await fetch(APP_CONFIG.api.adsEndpoint, {
                method: 'GET',
                headers: {
                    'Content-Type': 'application/json',
                },
            });

            if (response.ok) {
                const data = await response.json();
                const ads = data.ads || data;

                // Cache the ads
                await this.cacheAds(ads);
                await AsyncStorage.setItem(LAST_FETCH_KEY, new Date().toISOString());

                return ads.filter((ad: Ad) => ad.isActive).sort((a: Ad, b: Ad) => a.order - b.order);
            }
        } catch (error) {
            console.log('Failed to fetch ads from API, using fallback:', error);
        }

        // Use fallback or cached data
        if (APP_CONFIG.api.useFallbackData) {
            const cachedAds = await this.getCachedAds();
            return cachedAds.length > 0 ? cachedAds : FALLBACK_ADS;
        }

        return FALLBACK_ADS;
    }

    // Cache ads locally
    private async cacheAds(ads: Ad[]): Promise<void> {
        try {
            await AsyncStorage.setItem(STORAGE_KEY, JSON.stringify(ads));
        } catch (error) {
            console.error('Failed to cache ads:', error);
        }
    }

    // Get cached ads
    async getCachedAds(): Promise<Ad[]> {
        try {
            const cached = await AsyncStorage.getItem(STORAGE_KEY);
            if (cached) {
                return JSON.parse(cached);
            }
        } catch (error) {
            console.error('Failed to get cached ads:', error);
        }
        return [];
    }

    // Check if ads need refresh
    async needsRefresh(): Promise<boolean> {
        try {
            const lastFetch = await AsyncStorage.getItem(LAST_FETCH_KEY);
            if (!lastFetch) return true;

            const lastFetchTime = new Date(lastFetch).getTime();
            const now = new Date().getTime();
            const timeDiff = now - lastFetchTime;

            return timeDiff > APP_CONFIG.app.adRefreshInterval;
        } catch (error) {
            return true;
        }
    }

    // Track ad impression
    async trackImpression(adId: string, completed: boolean, watchDuration: number): Promise<void> {
        try {
            const impressions = await AsyncStorage.getItem('addreel_impressions');
            const impressionsList = impressions ? JSON.parse(impressions) : [];

            impressionsList.push({
                adId,
                timestamp: new Date().toISOString(),
                completed,
                watchDuration,
            });

            // Keep only last 100 impressions
            const recentImpressions = impressionsList.slice(-100);
            await AsyncStorage.setItem('addreel_impressions', JSON.stringify(recentImpressions));
        } catch (error) {
            console.error('Failed to track impression:', error);
        }
    }
}

export default new AdDataService();
