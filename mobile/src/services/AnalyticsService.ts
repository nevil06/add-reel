import AsyncStorage from '@react-native-async-storage/async-storage';
import { Analytics } from '../types';
import { APP_CONFIG } from '../config/appConfig';

const ANALYTICS_KEY = 'addreel_analytics';

class AnalyticsService {
    // Get analytics data
    async getAnalytics(): Promise<Analytics> {
        try {
            const data = await AsyncStorage.getItem(ANALYTICS_KEY);
            if (data) {
                return JSON.parse(data);
            }
        } catch (error) {
            console.error('Failed to get analytics:', error);
        }

        return {
            totalAdsWatched: 0,
            totalRewardedAdsWatched: 0,
            totalPointsEarned: 0,
            totalCommission: 0,
            lastReset: new Date().toISOString(),
        };
    }

    // Track feed ad view
    async trackFeedAdView(): Promise<void> {
        try {
            const analytics = await this.getAnalytics();
            analytics.totalAdsWatched += 1;
            await AsyncStorage.setItem(ANALYTICS_KEY, JSON.stringify(analytics));
        } catch (error) {
            console.error('Failed to track feed ad view:', error);
        }
    }

    // Track rewarded ad completion
    async trackRewardedAd(pointsEarned: number): Promise<void> {
        try {
            const analytics = await this.getAnalytics();
            analytics.totalRewardedAdsWatched += 1;
            analytics.totalPointsEarned += pointsEarned;

            // Calculate commission (simplified - in reality this would be based on actual ad revenue)
            const estimatedRevenue = pointsEarned / APP_CONFIG.points.pointsPerINR;
            const commission = estimatedRevenue * APP_CONFIG.commission.commissionRate;
            analytics.totalCommission += commission;

            await AsyncStorage.setItem(ANALYTICS_KEY, JSON.stringify(analytics));
        } catch (error) {
            console.error('Failed to track rewarded ad:', error);
        }
    }

    // Reset analytics
    async resetAnalytics(): Promise<void> {
        try {
            const reset: Analytics = {
                totalAdsWatched: 0,
                totalRewardedAdsWatched: 0,
                totalPointsEarned: 0,
                totalCommission: 0,
                lastReset: new Date().toISOString(),
            };
            await AsyncStorage.setItem(ANALYTICS_KEY, JSON.stringify(reset));
        } catch (error) {
            console.error('Failed to reset analytics:', error);
        }
    }

    // Get commission earned
    async getCommissionEarned(): Promise<number> {
        const analytics = await this.getAnalytics();
        return analytics.totalCommission;
    }

    // Get total revenue (points converted to INR)
    async getTotalRevenue(): Promise<number> {
        const analytics = await this.getAnalytics();
        return analytics.totalPointsEarned / APP_CONFIG.points.pointsPerINR;
    }
}

export default new AnalyticsService();
