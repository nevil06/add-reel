import React, { useState, useEffect, useRef } from 'react';
import {
    View,
    FlatList,
    StyleSheet,
    Dimensions,
    RefreshControl,
    TouchableOpacity,
    Text,
    Alert,
} from 'react-native';
import { Ionicons } from '@expo/vector-icons';
import VideoCard from '../components/VideoCard';
import { Ad } from '../types';
import AdDataService from '../services/AdDataService';
import AdMobService from '../services/AdMobService';
import PointsService from '../services/PointsService';
import AnalyticsService from '../services/AnalyticsService';

const { height } = Dimensions.get('window');

export default function FeedScreen() {
    const [ads, setAds] = useState<Ad[]>([]);
    const [currentIndex, setCurrentIndex] = useState(0);
    const [refreshing, setRefreshing] = useState(false);
    const [loading, setLoading] = useState(true);
    const [adLoading, setAdLoading] = useState(false);
    const flatListRef = useRef<FlatList>(null);

    useEffect(() => {
        loadAds();
        initializeAdMob();
    }, []);

    const initializeAdMob = async () => {
        try {
            await AdMobService.initialize();
            await AdMobService.loadRewardedAd();
        } catch (error) {
            console.error('Failed to initialize AdMob:', error);
        }
    };

    const loadAds = async () => {
        try {
            setLoading(true);
            const fetchedAds = await AdDataService.fetchAds();
            setAds(fetchedAds);
        } catch (error) {
            console.error('Failed to load ads:', error);
            Alert.alert('Error', 'Failed to load ads. Please try again.');
        } finally {
            setLoading(false);
        }
    };

    const handleRefresh = async () => {
        setRefreshing(true);
        await loadAds();
        setRefreshing(false);
    };

    const handleViewableItemsChanged = useRef(({ viewableItems }: any) => {
        if (viewableItems.length > 0) {
            const index = viewableItems[0].index;
            setCurrentIndex(index);

            // Track ad view
            if (ads[index]) {
                AnalyticsService.trackFeedAdView();
            }
        }
    }).current;

    const viewabilityConfig = useRef({
        itemVisiblePercentThreshold: 50,
    }).current;

    const handleWatchRewardedAd = async () => {
        try {
            setAdLoading(true);

            // Check if ad is ready
            if (!AdMobService.isRewardedAdReady()) {
                Alert.alert('Loading...', 'Please wait while we load the ad.');
                await AdMobService.loadRewardedAd();
            }

            // Show rewarded ad
            const result = await AdMobService.showRewardedAd();

            if (result.rewarded) {
                // Add points
                const updated = await PointsService.addPoints(result.points);

                // Track analytics
                await AnalyticsService.trackRewardedAd(result.points);

                // Show success message
                Alert.alert(
                    'Points Earned! 🎉',
                    `You earned ${result.points} points!\n\nTotal Points: ${updated.totalPoints}\nINR Value: ₹${PointsService.getINREquivalent(updated.totalPoints).toFixed(2)}`,
                    [{ text: 'Awesome!', style: 'default' }]
                );

                // Load next ad
                await AdMobService.loadRewardedAd();
            }
        } catch (error) {
            console.error('Failed to show rewarded ad:', error);
            Alert.alert('Error', 'Failed to load ad. Please try again later.');
        } finally {
            setAdLoading(false);
        }
    };

    const renderItem = ({ item, index }: { item: Ad; index: number }) => (
        <VideoCard ad={item} isActive={index === currentIndex} />
    );

    if (loading) {
        return (
            <View style={styles.loadingContainer}>
                <Text style={styles.loadingText}>Loading ads...</Text>
            </View>
        );
    }

    if (ads.length === 0) {
        return (
            <View style={styles.emptyContainer}>
                <Ionicons name="film-outline" size={64} color="#666" />
                <Text style={styles.emptyText}>No ads available</Text>
                <TouchableOpacity style={styles.retryButton} onPress={loadAds}>
                    <Text style={styles.retryText}>Retry</Text>
                </TouchableOpacity>
            </View>
        );
    }

    return (
        <View style={styles.container}>
            <FlatList
                ref={flatListRef}
                data={ads}
                renderItem={renderItem}
                keyExtractor={(item) => item.id}
                pagingEnabled
                showsVerticalScrollIndicator={false}
                snapToInterval={height}
                snapToAlignment="start"
                decelerationRate="fast"
                onViewableItemsChanged={handleViewableItemsChanged}
                viewabilityConfig={viewabilityConfig}
                refreshControl={
                    <RefreshControl refreshing={refreshing} onRefresh={handleRefresh} tintColor="#fff" />
                }
            />

            {/* Earn Points Button */}
            <TouchableOpacity
                style={styles.earnButton}
                onPress={handleWatchRewardedAd}
                disabled={adLoading}
            >
                <Ionicons name="gift" size={24} color="#fff" />
                <Text style={styles.earnButtonText}>
                    {adLoading ? 'Loading...' : 'Earn Points'}
                </Text>
            </TouchableOpacity>
        </View>
    );
}

const styles = StyleSheet.create({
    container: {
        flex: 1,
        backgroundColor: '#000',
    },
    loadingContainer: {
        flex: 1,
        justifyContent: 'center',
        alignItems: 'center',
        backgroundColor: '#000',
    },
    loadingText: {
        color: '#fff',
        fontSize: 16,
    },
    emptyContainer: {
        flex: 1,
        justifyContent: 'center',
        alignItems: 'center',
        backgroundColor: '#000',
        padding: 20,
    },
    emptyText: {
        color: '#fff',
        fontSize: 18,
        marginTop: 16,
        marginBottom: 24,
    },
    retryButton: {
        backgroundColor: '#fff',
        paddingHorizontal: 32,
        paddingVertical: 12,
        borderRadius: 25,
    },
    retryText: {
        color: '#000',
        fontSize: 16,
        fontWeight: '600',
    },
    earnButton: {
        position: 'absolute',
        top: 60,
        right: 20,
        flexDirection: 'row',
        alignItems: 'center',
        backgroundColor: '#FF6B6B',
        paddingHorizontal: 20,
        paddingVertical: 12,
        borderRadius: 25,
        gap: 8,
        shadowColor: '#000',
        shadowOffset: { width: 0, height: 2 },
        shadowOpacity: 0.3,
        shadowRadius: 4,
        elevation: 5,
    },
    earnButtonText: {
        color: '#fff',
        fontSize: 16,
        fontWeight: '600',
    },
});
