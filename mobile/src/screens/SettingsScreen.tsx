import React from 'react';
import {
    View,
    Text,
    StyleSheet,
    ScrollView,
    TouchableOpacity,
    Linking,
    Alert,
} from 'react-native';
import { Ionicons } from '@expo/vector-icons';
import PointsService from '../services/PointsService';
import AnalyticsService from '../services/AnalyticsService';

export default function SettingsScreen() {
    const handleClearData = () => {
        Alert.alert(
            'Clear All Data',
            'This will reset your points and analytics. This action cannot be undone.',
            [
                { text: 'Cancel', style: 'cancel' },
                {
                    text: 'Clear',
                    style: 'destructive',
                    onPress: async () => {
                        await PointsService.resetPoints();
                        await AnalyticsService.resetAnalytics();
                        Alert.alert('Success', 'All data has been cleared.');
                    },
                },
            ]
        );
    };

    const handleContactSupport = () => {
        Linking.openURL('mailto:support@addreel.com?subject=Support Request');
    };

    const handlePrivacyPolicy = () => {
        Linking.openURL('https://your-website.vercel.app/privacy');
    };

    const handleTerms = () => {
        Linking.openURL('https://your-website.vercel.app/terms');
    };

    return (
        <ScrollView style={styles.container}>
            <View style={styles.section}>
                <Text style={styles.sectionTitle}>Account</Text>

                <TouchableOpacity style={styles.item}>
                    <Ionicons name="person-outline" size={24} color="#333" />
                    <Text style={styles.itemText}>Profile</Text>
                    <Ionicons name="chevron-forward" size={24} color="#999" />
                </TouchableOpacity>

                <TouchableOpacity style={styles.item}>
                    <Ionicons name="notifications-outline" size={24} color="#333" />
                    <Text style={styles.itemText}>Notifications</Text>
                    <Ionicons name="chevron-forward" size={24} color="#999" />
                </TouchableOpacity>
            </View>

            <View style={styles.section}>
                <Text style={styles.sectionTitle}>Support</Text>

                <TouchableOpacity style={styles.item} onPress={handleContactSupport}>
                    <Ionicons name="mail-outline" size={24} color="#333" />
                    <Text style={styles.itemText}>Contact Support</Text>
                    <Ionicons name="chevron-forward" size={24} color="#999" />
                </TouchableOpacity>

                <TouchableOpacity style={styles.item}>
                    <Ionicons name="help-circle-outline" size={24} color="#333" />
                    <Text style={styles.itemText}>Help Center</Text>
                    <Ionicons name="chevron-forward" size={24} color="#999" />
                </TouchableOpacity>
            </View>

            <View style={styles.section}>
                <Text style={styles.sectionTitle}>Legal</Text>

                <TouchableOpacity style={styles.item} onPress={handlePrivacyPolicy}>
                    <Ionicons name="shield-outline" size={24} color="#333" />
                    <Text style={styles.itemText}>Privacy Policy</Text>
                    <Ionicons name="chevron-forward" size={24} color="#999" />
                </TouchableOpacity>

                <TouchableOpacity style={styles.item} onPress={handleTerms}>
                    <Ionicons name="document-text-outline" size={24} color="#333" />
                    <Text style={styles.itemText}>Terms of Service</Text>
                    <Ionicons name="chevron-forward" size={24} color="#999" />
                </TouchableOpacity>
            </View>

            <View style={styles.section}>
                <Text style={styles.sectionTitle}>Data</Text>

                <TouchableOpacity style={styles.item} onPress={handleClearData}>
                    <Ionicons name="trash-outline" size={24} color="#FF6B6B" />
                    <Text style={[styles.itemText, { color: '#FF6B6B' }]}>Clear All Data</Text>
                    <Ionicons name="chevron-forward" size={24} color="#999" />
                </TouchableOpacity>
            </View>

            <View style={styles.footer}>
                <Text style={styles.version}>AdReel v1.0.0</Text>
                <Text style={styles.copyright}>© 2025 AdReel. All rights reserved.</Text>
            </View>
        </ScrollView>
    );
}

const styles = StyleSheet.create({
    container: {
        flex: 1,
        backgroundColor: '#f5f5f5',
    },
    section: {
        marginTop: 20,
        backgroundColor: '#fff',
        borderTopWidth: 1,
        borderBottomWidth: 1,
        borderColor: '#e0e0e0',
    },
    sectionTitle: {
        fontSize: 14,
        fontWeight: '600',
        color: '#666',
        paddingHorizontal: 20,
        paddingTop: 16,
        paddingBottom: 8,
        backgroundColor: '#f5f5f5',
    },
    item: {
        flexDirection: 'row',
        alignItems: 'center',
        padding: 16,
        paddingHorizontal: 20,
        borderBottomWidth: 1,
        borderBottomColor: '#f0f0f0',
    },
    itemText: {
        flex: 1,
        fontSize: 16,
        color: '#333',
        marginLeft: 16,
    },
    footer: {
        alignItems: 'center',
        padding: 40,
    },
    version: {
        fontSize: 14,
        color: '#999',
        marginBottom: 4,
    },
    copyright: {
        fontSize: 12,
        color: '#ccc',
    },
});
