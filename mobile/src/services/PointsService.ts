import AsyncStorage from '@react-native-async-storage/async-storage';
import { UserPoints } from '../types';
import { APP_CONFIG } from '../config/appConfig';

const POINTS_KEY = 'addreel_points';

class PointsService {
    // Get current points balance
    async getPoints(): Promise<UserPoints> {
        try {
            const data = await AsyncStorage.getItem(POINTS_KEY);
            if (data) {
                return JSON.parse(data);
            }
        } catch (error) {
            console.error('Failed to get points:', error);
        }

        // Return default
        return {
            totalPoints: 0,
            totalEarned: 0,
            lastUpdated: new Date().toISOString(),
        };
    }

    // Add points after watching rewarded ad
    async addPoints(points: number): Promise<UserPoints> {
        try {
            const current = await this.getPoints();
            const updated: UserPoints = {
                totalPoints: current.totalPoints + points,
                totalEarned: current.totalEarned + points,
                lastUpdated: new Date().toISOString(),
            };

            await AsyncStorage.setItem(POINTS_KEY, JSON.stringify(updated));
            return updated;
        } catch (error) {
            console.error('Failed to add points:', error);
            throw error;
        }
    }

    // Deduct points (for withdrawals)
    async deductPoints(points: number): Promise<UserPoints> {
        try {
            const current = await this.getPoints();

            if (current.totalPoints < points) {
                throw new Error('Insufficient points');
            }

            const updated: UserPoints = {
                ...current,
                totalPoints: current.totalPoints - points,
                lastUpdated: new Date().toISOString(),
            };

            await AsyncStorage.setItem(POINTS_KEY, JSON.stringify(updated));
            return updated;
        } catch (error) {
            console.error('Failed to deduct points:', error);
            throw error;
        }
    }

    // Calculate INR equivalent
    getINREquivalent(points: number): number {
        return points / APP_CONFIG.points.pointsPerINR;
    }

    // Calculate points needed for specific INR amount
    getPointsForINR(inr: number): number {
        return inr * APP_CONFIG.points.pointsPerINR;
    }

    // Check if user can withdraw
    canWithdraw(points: number): boolean {
        return points >= APP_CONFIG.points.minimumWithdrawal;
    }

    // Reset points (admin function)
    async resetPoints(): Promise<void> {
        try {
            const reset: UserPoints = {
                totalPoints: 0,
                totalEarned: 0,
                lastUpdated: new Date().toISOString(),
            };
            await AsyncStorage.setItem(POINTS_KEY, JSON.stringify(reset));
        } catch (error) {
            console.error('Failed to reset points:', error);
        }
    }
}

export default new PointsService();
