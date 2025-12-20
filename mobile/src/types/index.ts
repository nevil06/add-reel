// Ad Data Types
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

// User Points Data
export interface UserPoints {
    totalPoints: number;
    totalEarned: number;
    lastUpdated: string;
}

// Analytics Data
export interface Analytics {
    totalAdsWatched: number;
    totalRewardedAdsWatched: number;
    totalPointsEarned: number;
    totalCommission: number;
    lastReset: string;
}

// Ad Impression Tracking
export interface AdImpression {
    adId: string;
    timestamp: string;
    completed: boolean;
    watchDuration: number;
}
