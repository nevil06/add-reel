import React from 'react';
import { NavigationContainer } from '@react-navigation/native';
import { createBottomTabNavigator } from '@react-navigation/bottom-tabs';
import { Ionicons } from '@expo/vector-icons';
import FeedScreen from '../screens/FeedScreen';
import WalletScreen from '../screens/WalletScreen';
import SettingsScreen from '../screens/SettingsScreen';
import AdminScreen from '../screens/AdminScreen';

const Tab = createBottomTabNavigator();

export default function AppNavigator() {
    return (
        <NavigationContainer>
            <Tab.Navigator
                screenOptions={({ route }) => ({
                    tabBarIcon: ({ focused, color, size }) => {
                        let iconName: keyof typeof Ionicons.glyphMap = 'home';

                        if (route.name === 'Feed') {
                            iconName = focused ? 'play-circle' : 'play-circle-outline';
                        } else if (route.name === 'Wallet') {
                            iconName = focused ? 'wallet' : 'wallet-outline';
                        } else if (route.name === 'Settings') {
                            iconName = focused ? 'settings' : 'settings-outline';
                        } else if (route.name === 'Admin') {
                            iconName = focused ? 'shield' : 'shield-outline';
                        }

                        return <Ionicons name={iconName} size={size} color={color} />;
                    },
                    tabBarActiveTintColor: '#667eea',
                    tabBarInactiveTintColor: '#999',
                    tabBarStyle: {
                        backgroundColor: '#fff',
                        borderTopWidth: 1,
                        borderTopColor: '#e0e0e0',
                        height: 60,
                        paddingBottom: 8,
                        paddingTop: 8,
                    },
                    tabBarLabelStyle: {
                        fontSize: 12,
                        fontWeight: '600',
                    },
                    headerShown: false,
                })}
            >
                <Tab.Screen
                    name="Feed"
                    component={FeedScreen}
                    options={{ title: 'Feed' }}
                />
                <Tab.Screen
                    name="Wallet"
                    component={WalletScreen}
                    options={{ title: 'Wallet' }}
                />
                <Tab.Screen
                    name="Settings"
                    component={SettingsScreen}
                    options={{ title: 'Settings' }}
                />
                <Tab.Screen
                    name="Admin"
                    component={AdminScreen}
                    options={{ title: 'Admin' }}
                />
            </Tab.Navigator>
        </NavigationContainer>
    );
}
