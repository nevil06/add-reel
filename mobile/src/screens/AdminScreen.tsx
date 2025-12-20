import React, { useState, useEffect } from 'react';
import {
    View,
    Text,
    StyleSheet,
    ScrollView,
    TextInput,
    TouchableOpacity,
    Alert,
} from 'react-native';
import { Ionicons } from '@expo/vector-icons';
import { LinearGradient } from 'expo-linear-gradient';
import AnalyticsService from '../services/AnalyticsService';
import PointsService from '../services/PointsService';
import { Analytics } from '../types';
import { ADMIN_CONFIG, APP_CONFIG } from '../config/appConfig';

export default function AdminScreen() {
    const [isAuthenticated, setIsAuthenticated] = useState(false);
    const [password, setPassword] = useState('');
    const [analytics, setAnalytics] = useState<Analytics | null>(null);

    useEffect(() => {
        if (isAuthenticated) {
            loadAnalytics();
        }
    }, [isAuthenticated]);

    const loadAnalytics = async () => {
        const data = await AnalyticsService.getAnalytics();
        setAnalytics(data);
    };

    const handleLogin = () => {
        if (password === ADMIN_CONFIG.adminPassword) {
            setIsAuthenticated(true);
            setPassword('');
        } else {
            Alert.alert('Error', 'Incorrect password');
        }
    };

    const handleLogout = () => {
        setIsAuthenticated(false);
    };

    if (!isAuthenticated) {
        return (
            <View style={styles.loginContainer}>
                <Ionicons name="lock-closed" size={64} color="#667eea" />
                <Text style={styles.loginTitle}>Admin Access</Text>
                <Text style={styles.loginSubtitle}>Enter password to continue</Text>

                <TextInput
                    style={styles.passwordInput}
                    placeholder="Password"
                    secureTextEntry
                    value={password}
                    onChangeText={setPassword}
                    autoCapitalize="none"
                />

                <TouchableOpacity style={styles.loginButton} onPress={handleLogin}>
                    <Text style={styles.loginButtonText}>Login</Text>
                </TouchableOpacity>

                <Text style={styles.hint}>Default password: admin123</Text>
            </View>
        );
    }

    if (!analytics) {
        return (
            <View style={styles.loadingContainer}>
                <Text>Loading...</Text>
            </View>
        );
    }

    const totalRevenue = AnalyticsService.getTotalRevenue();

    return (
        <ScrollView style={styles.container}>
            {/* Header */}
            <View style={styles.header}>
                <Text style={styles.headerTitle}>Admin Dashboard</Text>
                <TouchableOpacity onPress={handleLogout}>
                    <Ionicons name="log-out-outline" size={24} color="#333" />
                </TouchableOpacity>
            </View>

            {/* Revenue Card */}
            <LinearGradient
                colors={['#FF6B6B', '#FF8E53']}
                start={{ x: 0, y: 0 }}
                end={{ x: 1, y: 1 }}
                style={styles.revenueCard}
            >
                <Text style={styles.revenueLabel}>Total Commission</Text>
                <Text style={styles.revenueAmount}>₹{analytics.totalCommission.toFixed(2)}</Text>
                <Text style={styles.revenueSubtext}>
                    {APP_CONFIG.commission.commissionRate * 100}% of total revenue
                </Text>
            </LinearGradient>

            {/* Stats Grid */}
            <View style={styles.statsGrid}>
                <View style={styles.statBox}>
                    <Ionicons name="eye" size={32} color="#667eea" />
                    <Text style={styles.statValue}>{analytics.totalAdsWatched}</Text>
                    <Text style={styles.statLabel}>Feed Ads Viewed</Text>
                </View>

                <View style={styles.statBox}>
                    <Ionicons name="play-circle" size={32} color="#4ECDC4" />
                    <Text style={styles.statValue}>{analytics.totalRewardedAdsWatched}</Text>
                    <Text style={styles.statLabel}>Rewarded Ads</Text>
                </View>

                <View style={styles.statBox}>
                    <Ionicons name="gift" size={32} color="#FF6B6B" />
                    <Text style={styles.statValue}>{analytics.totalPointsEarned.toLocaleString()}</Text>
                    <Text style={styles.statLabel}>Points Distributed</Text>
                </View>

                <View style={styles.statBox}>
                    <Ionicons name="cash" size={32} color="#45B7D1" />
                    <Text style={styles.statValue}>
                        ₹{(analytics.totalPointsEarned / APP_CONFIG.points.pointsPerINR).toFixed(2)}
                    </Text>
                    <Text style={styles.statLabel}>Total Value</Text>
                </View>
            </View>

            {/* Configuration */}
            <View style={styles.configSection}>
                <Text style={styles.sectionTitle}>Current Configuration</Text>

                <View style={styles.configItem}>
                    <Text style={styles.configLabel}>Points per Rewarded Ad</Text>
                    <Text style={styles.configValue}>{APP_CONFIG.points.pointsPerRewardedAd}</Text>
                </View>

                <View style={styles.configItem}>
                    <Text style={styles.configLabel}>Points to INR Conversion</Text>
                    <Text style={styles.configValue}>{APP_CONFIG.points.pointsPerINR} points = ₹1</Text>
                </View>

                <View style={styles.configItem}>
                    <Text style={styles.configLabel}>Minimum Withdrawal</Text>
                    <Text style={styles.configValue}>
                        {APP_CONFIG.points.minimumWithdrawal} points (₹
                        {(APP_CONFIG.points.minimumWithdrawal / APP_CONFIG.points.pointsPerINR).toFixed(2)})
                    </Text>
                </View>

                <View style={styles.configItem}>
                    <Text style={styles.configLabel}>Commission Rate</Text>
                    <Text style={styles.configValue}>{APP_CONFIG.commission.commissionRate * 100}%</Text>
                </View>
            </View>

            {/* Actions */}
            <View style={styles.actionsSection}>
                <TouchableOpacity style={styles.actionButton} onPress={loadAnalytics}>
                    <Ionicons name="refresh" size={20} color="#667eea" />
                    <Text style={styles.actionButtonText}>Refresh Data</Text>
                </TouchableOpacity>

                <TouchableOpacity
                    style={[styles.actionButton, styles.dangerButton]}
                    onPress={() => {
                        Alert.alert(
                            'Reset Analytics',
                            'This will reset all analytics data. Continue?',
                            [
                                { text: 'Cancel', style: 'cancel' },
                                {
                                    text: 'Reset',
                                    style: 'destructive',
                                    onPress: async () => {
                                        await AnalyticsService.resetAnalytics();
                                        await loadAnalytics();
                                        Alert.alert('Success', 'Analytics reset successfully');
                                    },
                                },
                            ]
                        );
                    }}
                >
                    <Ionicons name="trash" size={20} color="#FF6B6B" />
                    <Text style={[styles.actionButtonText, { color: '#FF6B6B' }]}>Reset Analytics</Text>
                </TouchableOpacity>
            </View>

            <Text style={styles.note}>
                Note: To modify configuration values, edit the appConfig.ts file
            </Text>
        </ScrollView>
    );
}

const styles = StyleSheet.create({
    container: {
        flex: 1,
        backgroundColor: '#f5f5f5',
    },
    loginContainer: {
        flex: 1,
        justifyContent: 'center',
        alignItems: 'center',
        backgroundColor: '#f5f5f5',
        padding: 20,
    },
    loginTitle: {
        fontSize: 28,
        fontWeight: 'bold',
        color: '#333',
        marginTop: 20,
    },
    loginSubtitle: {
        fontSize: 16,
        color: '#666',
        marginTop: 8,
        marginBottom: 32,
    },
    passwordInput: {
        width: '100%',
        backgroundColor: '#fff',
        padding: 16,
        borderRadius: 12,
        fontSize: 16,
        borderWidth: 1,
        borderColor: '#e0e0e0',
    },
    loginButton: {
        width: '100%',
        backgroundColor: '#667eea',
        padding: 16,
        borderRadius: 12,
        alignItems: 'center',
        marginTop: 16,
    },
    loginButtonText: {
        fontSize: 18,
        fontWeight: '600',
        color: '#fff',
    },
    hint: {
        fontSize: 14,
        color: '#999',
        marginTop: 16,
    },
    loadingContainer: {
        flex: 1,
        justifyContent: 'center',
        alignItems: 'center',
        backgroundColor: '#f5f5f5',
    },
    header: {
        flexDirection: 'row',
        justifyContent: 'space-between',
        alignItems: 'center',
        padding: 20,
        backgroundColor: '#fff',
        borderBottomWidth: 1,
        borderBottomColor: '#e0e0e0',
    },
    headerTitle: {
        fontSize: 24,
        fontWeight: 'bold',
        color: '#333',
    },
    revenueCard: {
        margin: 20,
        padding: 30,
        borderRadius: 20,
        shadowColor: '#000',
        shadowOffset: { width: 0, height: 4 },
        shadowOpacity: 0.3,
        shadowRadius: 8,
        elevation: 8,
    },
    revenueLabel: {
        fontSize: 16,
        color: 'rgba(255,255,255,0.9)',
        marginBottom: 8,
    },
    revenueAmount: {
        fontSize: 48,
        fontWeight: 'bold',
        color: '#fff',
        marginBottom: 4,
    },
    revenueSubtext: {
        fontSize: 14,
        color: 'rgba(255,255,255,0.8)',
    },
    statsGrid: {
        flexDirection: 'row',
        flexWrap: 'wrap',
        paddingHorizontal: 20,
        gap: 12,
    },
    statBox: {
        width: '48%',
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
        fontSize: 12,
        color: '#666',
        marginTop: 4,
        textAlign: 'center',
    },
    configSection: {
        margin: 20,
        backgroundColor: '#fff',
        borderRadius: 16,
        padding: 20,
        shadowColor: '#000',
        shadowOffset: { width: 0, height: 2 },
        shadowOpacity: 0.1,
        shadowRadius: 4,
        elevation: 3,
    },
    sectionTitle: {
        fontSize: 20,
        fontWeight: 'bold',
        color: '#333',
        marginBottom: 16,
    },
    configItem: {
        flexDirection: 'row',
        justifyContent: 'space-between',
        alignItems: 'center',
        paddingVertical: 12,
        borderBottomWidth: 1,
        borderBottomColor: '#f0f0f0',
    },
    configLabel: {
        fontSize: 14,
        color: '#666',
    },
    configValue: {
        fontSize: 14,
        fontWeight: '600',
        color: '#333',
    },
    actionsSection: {
        paddingHorizontal: 20,
        gap: 12,
    },
    actionButton: {
        flexDirection: 'row',
        alignItems: 'center',
        justifyContent: 'center',
        backgroundColor: '#fff',
        padding: 16,
        borderRadius: 12,
        gap: 8,
        borderWidth: 1,
        borderColor: '#667eea',
    },
    dangerButton: {
        borderColor: '#FF6B6B',
    },
    actionButtonText: {
        fontSize: 16,
        fontWeight: '600',
        color: '#667eea',
    },
    note: {
        textAlign: 'center',
        fontSize: 12,
        color: '#999',
        margin: 20,
        marginTop: 32,
    },
});
