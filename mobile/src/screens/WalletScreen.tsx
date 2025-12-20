import React, { useState, useEffect } from 'react';
import {
    View,
    Text,
    StyleSheet,
    ScrollView,
    TouchableOpacity,
    Alert,
} from 'react-native';
import { Ionicons } from '@expo/vector-icons';
import { LinearGradient } from 'expo-linear-gradient';
import PointsService from '../services/PointsService';
import { UserPoints } from '../types';
import { APP_CONFIG } from '../config/appConfig';

export default function WalletScreen() {
    const [points, setPoints] = useState<UserPoints | null>(null);
    const [loading, setLoading] = useState(true);

    useEffect(() => {
        loadPoints();

        // Refresh points when screen is focused
        const interval = setInterval(loadPoints, 2000);
        return () => clearInterval(interval);
    }, []);

    const loadPoints = async () => {
        try {
            const userPoints = await PointsService.getPoints();
            setPoints(userPoints);
        } catch (error) {
            console.error('Failed to load points:', error);
        } finally {
            setLoading(false);
        }
    };

    const handleWithdraw = () => {
        if (!points) return;

        if (!PointsService.canWithdraw(points.totalPoints)) {
            Alert.alert(
                'Insufficient Points',
                `You need at least ${APP_CONFIG.points.minimumWithdrawal} points (₹${PointsService.getINREquivalent(APP_CONFIG.points.minimumWithdrawal).toFixed(2)}) to withdraw.`
            );
            return;
        }

        Alert.alert(
            'Withdrawal',
            'Withdrawal feature coming soon! You will be able to transfer your points to your bank account or payment wallet.',
            [{ text: 'OK' }]
        );
    };

    if (loading || !points) {
        return (
            <View style={styles.loadingContainer}>
                <Text style={styles.loadingText}>Loading...</Text>
            </View>
        );
    }

    const inrValue = PointsService.getINREquivalent(points.totalPoints);
    const canWithdraw = PointsService.canWithdraw(points.totalPoints);

    return (
        <ScrollView style={styles.container}>
            {/* Balance Card */}
            <LinearGradient
                colors={['#667eea', '#764ba2']}
                start={{ x: 0, y: 0 }}
                end={{ x: 1, y: 1 }}
                style={styles.balanceCard}
            >
                <Text style={styles.balanceLabel}>Total Balance</Text>
                <Text style={styles.balanceAmount}>₹{inrValue.toFixed(2)}</Text>
                <Text style={styles.pointsAmount}>{points.totalPoints.toLocaleString()} points</Text>

                <View style={styles.conversionInfo}>
                    <Ionicons name="information-circle-outline" size={16} color="rgba(255,255,255,0.8)" />
                    <Text style={styles.conversionText}>
                        {APP_CONFIG.points.pointsPerINR.toLocaleString()} points = ₹1
                    </Text>
                </View>
            </LinearGradient>

            {/* Stats */}
            <View style={styles.statsContainer}>
                <View style={styles.statCard}>
                    <Ionicons name="trending-up" size={32} color="#667eea" />
                    <Text style={styles.statValue}>{points.totalEarned.toLocaleString()}</Text>
                    <Text style={styles.statLabel}>Total Earned</Text>
                </View>

                <View style={styles.statCard}>
                    <Ionicons name="wallet" size={32} color="#4ECDC4" />
                    <Text style={styles.statValue}>₹{inrValue.toFixed(2)}</Text>
                    <Text style={styles.statLabel}>Available</Text>
                </View>
            </View>

            {/* Withdraw Button */}
            <TouchableOpacity
                style={[styles.withdrawButton, !canWithdraw && styles.withdrawButtonDisabled]}
                onPress={handleWithdraw}
                disabled={!canWithdraw}
            >
                <Ionicons name="cash-outline" size={24} color="#fff" />
                <Text style={styles.withdrawButtonText}>
                    {canWithdraw ? 'Withdraw Funds' : 'Minimum Not Reached'}
                </Text>
            </TouchableOpacity>

            {!canWithdraw && (
                <Text style={styles.minimumText}>
                    Minimum withdrawal: {APP_CONFIG.points.minimumWithdrawal.toLocaleString()} points (₹
                    {PointsService.getINREquivalent(APP_CONFIG.points.minimumWithdrawal).toFixed(2)})
                </Text>
            )}

            {/* How to Earn */}
            <View style={styles.infoSection}>
                <Text style={styles.infoTitle}>How to Earn Points</Text>

                <View style={styles.infoItem}>
                    <View style={styles.infoIcon}>
                        <Ionicons name="play-circle" size={24} color="#667eea" />
                    </View>
                    <View style={styles.infoContent}>
                        <Text style={styles.infoItemTitle}>Watch Ads</Text>
                        <Text style={styles.infoItemText}>
                            Tap "Earn Points" button and watch rewarded ads
                        </Text>
                    </View>
                </View>

                <View style={styles.infoItem}>
                    <View style={styles.infoIcon}>
                        <Ionicons name="gift" size={24} color="#4ECDC4" />
                    </View>
                    <View style={styles.infoContent}>
                        <Text style={styles.infoItemTitle}>Earn {APP_CONFIG.points.pointsPerRewardedAd} Points</Text>
                        <Text style={styles.infoItemText}>
                            Complete each rewarded ad to earn points
                        </Text>
                    </View>
                </View>

                <View style={styles.infoItem}>
                    <View style={styles.infoIcon}>
                        <Ionicons name="cash" size={24} color="#FF6B6B" />
                    </View>
                    <View style={styles.infoContent}>
                        <Text style={styles.infoItemTitle}>Convert to Cash</Text>
                        <Text style={styles.infoItemText}>
                            Withdraw your earnings once you reach the minimum
                        </Text>
                    </View>
                </View>
            </View>
        </ScrollView>
    );
}

const styles = StyleSheet.create({
    container: {
        flex: 1,
        backgroundColor: '#f5f5f5',
    },
    loadingContainer: {
        flex: 1,
        justifyContent: 'center',
        alignItems: 'center',
        backgroundColor: '#f5f5f5',
    },
    loadingText: {
        fontSize: 16,
        color: '#666',
    },
    balanceCard: {
        margin: 20,
        padding: 30,
        borderRadius: 20,
        shadowColor: '#000',
        shadowOffset: { width: 0, height: 4 },
        shadowOpacity: 0.3,
        shadowRadius: 8,
        elevation: 8,
    },
    balanceLabel: {
        fontSize: 16,
        color: 'rgba(255,255,255,0.9)',
        marginBottom: 8,
    },
    balanceAmount: {
        fontSize: 48,
        fontWeight: 'bold',
        color: '#fff',
        marginBottom: 4,
    },
    pointsAmount: {
        fontSize: 18,
        color: 'rgba(255,255,255,0.9)',
        marginBottom: 16,
    },
    conversionInfo: {
        flexDirection: 'row',
        alignItems: 'center',
        gap: 6,
    },
    conversionText: {
        fontSize: 14,
        color: 'rgba(255,255,255,0.8)',
    },
    statsContainer: {
        flexDirection: 'row',
        paddingHorizontal: 20,
        gap: 12,
    },
    statCard: {
        flex: 1,
        backgroundColor: '#fff',
        padding: 20,
        borderRadius: 16,
        alignItems: 'center',
        shadowColor: '#000',
        shadowOffset: { width: 0, height: 2 },
        shadowOpacity: 0.1,
        shadowRadius: 4,
        elevation: 3,
    },
    statValue: {
        fontSize: 24,
        fontWeight: 'bold',
        color: '#333',
        marginTop: 8,
    },
    statLabel: {
        fontSize: 14,
        color: '#666',
        marginTop: 4,
    },
    withdrawButton: {
        flexDirection: 'row',
        alignItems: 'center',
        justifyContent: 'center',
        backgroundColor: '#667eea',
        marginHorizontal: 20,
        marginTop: 24,
        padding: 16,
        borderRadius: 12,
        gap: 8,
    },
    withdrawButtonDisabled: {
        backgroundColor: '#ccc',
    },
    withdrawButtonText: {
        fontSize: 18,
        fontWeight: '600',
        color: '#fff',
    },
    minimumText: {
        textAlign: 'center',
        color: '#666',
        fontSize: 14,
        marginTop: 12,
        marginHorizontal: 20,
    },
    infoSection: {
        margin: 20,
        marginTop: 32,
        backgroundColor: '#fff',
        borderRadius: 16,
        padding: 20,
        shadowColor: '#000',
        shadowOffset: { width: 0, height: 2 },
        shadowOpacity: 0.1,
        shadowRadius: 4,
        elevation: 3,
    },
    infoTitle: {
        fontSize: 20,
        fontWeight: 'bold',
        color: '#333',
        marginBottom: 20,
    },
    infoItem: {
        flexDirection: 'row',
        marginBottom: 20,
    },
    infoIcon: {
        width: 48,
        height: 48,
        borderRadius: 24,
        backgroundColor: '#f5f5f5',
        justifyContent: 'center',
        alignItems: 'center',
        marginRight: 16,
    },
    infoContent: {
        flex: 1,
    },
    infoItemTitle: {
        fontSize: 16,
        fontWeight: '600',
        color: '#333',
        marginBottom: 4,
    },
    infoItemText: {
        fontSize: 14,
        color: '#666',
        lineHeight: 20,
    },
});
