import React, { useEffect, useRef } from 'react';
import { View, StyleSheet, Dimensions, TouchableOpacity, Text, Linking } from 'react-native';
import { Video, ResizeMode, AVPlaybackStatus } from 'expo-av';
import { LinearGradient } from 'expo-linear-gradient';
import { Ionicons } from '@expo/vector-icons';
import { Ad } from '../types';
import AdDataService from '../services/AdDataService';

const { width, height } = Dimensions.get('window');

interface VideoCardProps {
    ad: Ad;
    isActive: boolean;
    onVideoEnd?: () => void;
}

export default function VideoCard({ ad, isActive, onVideoEnd }: VideoCardProps) {
    const videoRef = useRef<Video>(null);
    const [isPlaying, setIsPlaying] = React.useState(false);
    const [progress, setProgress] = React.useState(0);
    const [hasCompleted, setHasCompleted] = React.useState(false);

    useEffect(() => {
        if (isActive) {
            videoRef.current?.playAsync();
            setIsPlaying(true);
        } else {
            videoRef.current?.pauseAsync();
            setIsPlaying(false);
        }
    }, [isActive]);

    const handlePlaybackStatusUpdate = (status: AVPlaybackStatus) => {
        if (!status.isLoaded) return;

        const currentProgress = status.positionMillis / (status.durationMillis || 1);
        setProgress(currentProgress);

        // Track completion at 80%
        if (currentProgress >= 0.8 && !hasCompleted) {
            setHasCompleted(true);
            AdDataService.trackImpression(ad.id, true, status.positionMillis);
        }

        // Handle video end
        if (status.didJustFinish) {
            onVideoEnd?.();
        }
    };

    const handleTogglePlay = async () => {
        if (isPlaying) {
            await videoRef.current?.pauseAsync();
            setIsPlaying(false);
        } else {
            await videoRef.current?.playAsync();
            setIsPlaying(true);
        }
    };

    const handleCTAPress = () => {
        if (ad.targetUrl) {
            Linking.openURL(ad.targetUrl);
        }
    };

    return (
        <View style={styles.container}>
            <Video
                ref={videoRef}
                source={{ uri: ad.videoUrl }}
                style={styles.video}
                resizeMode={ResizeMode.COVER}
                isLooping
                shouldPlay={isActive}
                onPlaybackStatusUpdate={handlePlaybackStatusUpdate}
            />

            {/* Gradient Overlay */}
            <LinearGradient
                colors={['transparent', 'rgba(0,0,0,0.3)', 'rgba(0,0,0,0.8)']}
                style={styles.gradient}
            />

            {/* Play/Pause Button */}
            <TouchableOpacity style={styles.playButton} onPress={handleTogglePlay}>
                <Ionicons
                    name={isPlaying ? 'pause' : 'play'}
                    size={40}
                    color="rgba(255,255,255,0.8)"
                />
            </TouchableOpacity>

            {/* Ad Info */}
            <View style={styles.infoContainer}>
                <Text style={styles.title}>{ad.title}</Text>
                <Text style={styles.description} numberOfLines={2}>
                    {ad.description}
                </Text>

                {/* CTA Button */}
                {ad.ctaText && (
                    <TouchableOpacity style={styles.ctaButton} onPress={handleCTAPress}>
                        <Text style={styles.ctaText}>{ad.ctaText}</Text>
                        <Ionicons name="arrow-forward" size={18} color="#000" />
                    </TouchableOpacity>
                )}

                {/* Progress Bar */}
                <View style={styles.progressContainer}>
                    <View style={[styles.progressBar, { width: `${progress * 100}%` }]} />
                </View>
            </View>

            {/* Side Actions */}
            <View style={styles.sideActions}>
                <TouchableOpacity style={styles.actionButton}>
                    <Ionicons name="heart-outline" size={32} color="#fff" />
                </TouchableOpacity>
                <TouchableOpacity style={styles.actionButton}>
                    <Ionicons name="share-social-outline" size={32} color="#fff" />
                </TouchableOpacity>
            </View>
        </View>
    );
}

const styles = StyleSheet.create({
    container: {
        width,
        height,
        backgroundColor: '#000',
    },
    video: {
        width: '100%',
        height: '100%',
    },
    gradient: {
        position: 'absolute',
        left: 0,
        right: 0,
        bottom: 0,
        height: '50%',
    },
    playButton: {
        position: 'absolute',
        top: '50%',
        left: '50%',
        marginLeft: -20,
        marginTop: -20,
        width: 60,
        height: 60,
        borderRadius: 30,
        backgroundColor: 'rgba(0,0,0,0.3)',
        justifyContent: 'center',
        alignItems: 'center',
    },
    infoContainer: {
        position: 'absolute',
        bottom: 100,
        left: 20,
        right: 80,
    },
    title: {
        fontSize: 24,
        fontWeight: 'bold',
        color: '#fff',
        marginBottom: 8,
    },
    description: {
        fontSize: 14,
        color: '#fff',
        marginBottom: 16,
        opacity: 0.9,
    },
    ctaButton: {
        flexDirection: 'row',
        alignItems: 'center',
        backgroundColor: '#fff',
        paddingHorizontal: 24,
        paddingVertical: 12,
        borderRadius: 25,
        alignSelf: 'flex-start',
        gap: 8,
    },
    ctaText: {
        fontSize: 16,
        fontWeight: '600',
        color: '#000',
    },
    progressContainer: {
        height: 3,
        backgroundColor: 'rgba(255,255,255,0.3)',
        borderRadius: 2,
        marginTop: 16,
        overflow: 'hidden',
    },
    progressBar: {
        height: '100%',
        backgroundColor: '#fff',
    },
    sideActions: {
        position: 'absolute',
        right: 12,
        bottom: 120,
        gap: 24,
    },
    actionButton: {
        width: 48,
        height: 48,
        borderRadius: 24,
        backgroundColor: 'rgba(0,0,0,0.3)',
        justifyContent: 'center',
        alignItems: 'center',
    },
});
