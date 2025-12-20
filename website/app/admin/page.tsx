'use client';

import { useState, useEffect } from 'react';
import Link from 'next/link';

interface Ad {
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

export default function AdminPage() {
    const [ads, setAds] = useState<Ad[]>([]);
    const [loading, setLoading] = useState(true);
    const [showForm, setShowForm] = useState(false);
    const [editingAd, setEditingAd] = useState<Ad | null>(null);

    const [formData, setFormData] = useState({
        videoUrl: '',
        title: '',
        description: '',
        thumbnailUrl: '',
        ctaText: '',
        targetUrl: '',
        isActive: true,
    });

    useEffect(() => {
        fetchAds();
    }, []);

    const fetchAds = async () => {
        try {
            const response = await fetch('/api/ads');
            const data = await response.json();
            setAds(data.ads || []);
        } catch (error) {
            console.error('Failed to fetch ads:', error);
        } finally {
            setLoading(false);
        }
    };

    const handleSubmit = async (e: React.FormEvent) => {
        e.preventDefault();

        try {
            if (editingAd) {
                // Update existing ad
                await fetch('/api/ads', {
                    method: 'PUT',
                    headers: { 'Content-Type': 'application/json' },
                    body: JSON.stringify({ ...formData, id: editingAd.id }),
                });
            } else {
                // Create new ad
                await fetch('/api/ads', {
                    method: 'POST',
                    headers: { 'Content-Type': 'application/json' },
                    body: JSON.stringify(formData),
                });
            }

            // Reset form and refresh
            setFormData({
                videoUrl: '',
                title: '',
                description: '',
                thumbnailUrl: '',
                ctaText: '',
                targetUrl: '',
                isActive: true,
            });
            setShowForm(false);
            setEditingAd(null);
            fetchAds();
        } catch (error) {
            console.error('Failed to save ad:', error);
            alert('Failed to save ad');
        }
    };

    const handleEdit = (ad: Ad) => {
        setEditingAd(ad);
        setFormData({
            videoUrl: ad.videoUrl,
            title: ad.title,
            description: ad.description,
            thumbnailUrl: ad.thumbnailUrl,
            ctaText: ad.ctaText,
            targetUrl: ad.targetUrl,
            isActive: ad.isActive,
        });
        setShowForm(true);
    };

    const handleDelete = async (id: string) => {
        if (!confirm('Are you sure you want to delete this ad?')) return;

        try {
            await fetch(`/api/ads?id=${id}`, { method: 'DELETE' });
            fetchAds();
        } catch (error) {
            console.error('Failed to delete ad:', error);
            alert('Failed to delete ad');
        }
    };

    const toggleActive = async (ad: Ad) => {
        try {
            await fetch('/api/ads', {
                method: 'PUT',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify({ ...ad, isActive: !ad.isActive }),
            });
            fetchAds();
        } catch (error) {
            console.error('Failed to update ad:', error);
        }
    };

    return (
        <div className="min-h-screen bg-gray-50">
            {/* Header */}
            <header className="bg-white shadow-sm border-b">
                <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-4">
                    <div className="flex justify-between items-center">
                        <div>
                            <h1 className="text-2xl font-bold text-gray-900">Admin Dashboard</h1>
                            <p className="text-sm text-gray-600">Manage your video ads</p>
                        </div>
                        <Link
                            href="/"
                            className="text-purple-600 hover:text-purple-700 font-medium"
                        >
                            ← Back to Home
                        </Link>
                    </div>
                </div>
            </header>

            <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-8">
                {/* Stats */}
                <div className="grid grid-cols-1 md:grid-cols-4 gap-6 mb-8">
                    <div className="bg-white rounded-lg shadow p-6">
                        <div className="text-sm text-gray-600 mb-1">Total Ads</div>
                        <div className="text-3xl font-bold text-gray-900">{ads.length}</div>
                    </div>
                    <div className="bg-white rounded-lg shadow p-6">
                        <div className="text-sm text-gray-600 mb-1">Active Ads</div>
                        <div className="text-3xl font-bold text-green-600">
                            {ads.filter(ad => ad.isActive).length}
                        </div>
                    </div>
                    <div className="bg-white rounded-lg shadow p-6">
                        <div className="text-sm text-gray-600 mb-1">Inactive Ads</div>
                        <div className="text-3xl font-bold text-gray-400">
                            {ads.filter(ad => !ad.isActive).length}
                        </div>
                    </div>
                    <div className="bg-white rounded-lg shadow p-6">
                        <div className="text-sm text-gray-600 mb-1">API Endpoint</div>
                        <div className="text-xs text-purple-600 font-mono break-all">
                            /api/ads
                        </div>
                    </div>
                </div>

                {/* Add Button */}
                <div className="mb-6">
                    <button
                        onClick={() => {
                            setShowForm(!showForm);
                            setEditingAd(null);
                            setFormData({
                                videoUrl: '',
                                title: '',
                                description: '',
                                thumbnailUrl: '',
                                ctaText: '',
                                targetUrl: '',
                                isActive: true,
                            });
                        }}
                        className="bg-purple-600 text-white px-6 py-3 rounded-lg font-semibold hover:bg-purple-700 transition-colors"
                    >
                        {showForm ? '✕ Cancel' : '+ Add New Ad'}
                    </button>
                </div>

                {/* Add/Edit Form */}
                {showForm && (
                    <div className="bg-white rounded-lg shadow-lg p-6 mb-8">
                        <h2 className="text-xl font-bold mb-6">
                            {editingAd ? 'Edit Ad' : 'Add New Ad'}
                        </h2>
                        <form onSubmit={handleSubmit} className="space-y-4">
                            <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
                                <div>
                                    <label className="block text-sm font-medium text-gray-700 mb-2">
                                        Video URL *
                                    </label>
                                    <input
                                        type="url"
                                        required
                                        value={formData.videoUrl}
                                        onChange={(e) => setFormData({ ...formData, videoUrl: e.target.value })}
                                        className="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-purple-500 focus:border-transparent"
                                        placeholder="https://example.com/video.mp4"
                                    />
                                </div>

                                <div>
                                    <label className="block text-sm font-medium text-gray-700 mb-2">
                                        Title *
                                    </label>
                                    <input
                                        type="text"
                                        required
                                        value={formData.title}
                                        onChange={(e) => setFormData({ ...formData, title: e.target.value })}
                                        className="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-purple-500 focus:border-transparent"
                                        placeholder="Ad Title"
                                    />
                                </div>

                                <div className="md:col-span-2">
                                    <label className="block text-sm font-medium text-gray-700 mb-2">
                                        Description *
                                    </label>
                                    <textarea
                                        required
                                        value={formData.description}
                                        onChange={(e) => setFormData({ ...formData, description: e.target.value })}
                                        className="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-purple-500 focus:border-transparent"
                                        rows={3}
                                        placeholder="Ad description"
                                    />
                                </div>

                                <div>
                                    <label className="block text-sm font-medium text-gray-700 mb-2">
                                        Thumbnail URL
                                    </label>
                                    <input
                                        type="url"
                                        value={formData.thumbnailUrl}
                                        onChange={(e) => setFormData({ ...formData, thumbnailUrl: e.target.value })}
                                        className="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-purple-500 focus:border-transparent"
                                        placeholder="https://example.com/thumbnail.jpg"
                                    />
                                </div>

                                <div>
                                    <label className="block text-sm font-medium text-gray-700 mb-2">
                                        CTA Text
                                    </label>
                                    <input
                                        type="text"
                                        value={formData.ctaText}
                                        onChange={(e) => setFormData({ ...formData, ctaText: e.target.value })}
                                        className="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-purple-500 focus:border-transparent"
                                        placeholder="Learn More"
                                    />
                                </div>

                                <div>
                                    <label className="block text-sm font-medium text-gray-700 mb-2">
                                        Target URL
                                    </label>
                                    <input
                                        type="url"
                                        value={formData.targetUrl}
                                        onChange={(e) => setFormData({ ...formData, targetUrl: e.target.value })}
                                        className="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-purple-500 focus:border-transparent"
                                        placeholder="https://example.com"
                                    />
                                </div>

                                <div className="flex items-center">
                                    <input
                                        type="checkbox"
                                        checked={formData.isActive}
                                        onChange={(e) => setFormData({ ...formData, isActive: e.target.checked })}
                                        className="w-4 h-4 text-purple-600 border-gray-300 rounded focus:ring-purple-500"
                                    />
                                    <label className="ml-2 text-sm font-medium text-gray-700">
                                        Active (visible in app)
                                    </label>
                                </div>
                            </div>

                            <div className="flex gap-4 pt-4">
                                <button
                                    type="submit"
                                    className="bg-purple-600 text-white px-6 py-2 rounded-lg font-semibold hover:bg-purple-700 transition-colors"
                                >
                                    {editingAd ? 'Update Ad' : 'Create Ad'}
                                </button>
                                <button
                                    type="button"
                                    onClick={() => {
                                        setShowForm(false);
                                        setEditingAd(null);
                                    }}
                                    className="bg-gray-200 text-gray-700 px-6 py-2 rounded-lg font-semibold hover:bg-gray-300 transition-colors"
                                >
                                    Cancel
                                </button>
                            </div>
                        </form>
                    </div>
                )}

                {/* Ads List */}
                <div className="bg-white rounded-lg shadow">
                    <div className="px-6 py-4 border-b border-gray-200">
                        <h2 className="text-lg font-semibold text-gray-900">All Ads</h2>
                    </div>

                    {loading ? (
                        <div className="p-8 text-center text-gray-500">Loading...</div>
                    ) : ads.length === 0 ? (
                        <div className="p-8 text-center text-gray-500">
                            No ads yet. Click "Add New Ad" to create one.
                        </div>
                    ) : (
                        <div className="divide-y divide-gray-200">
                            {ads.map((ad) => (
                                <div key={ad.id} className="p-6 hover:bg-gray-50 transition-colors">
                                    <div className="flex items-start justify-between">
                                        <div className="flex-1">
                                            <div className="flex items-center gap-3 mb-2">
                                                <h3 className="text-lg font-semibold text-gray-900">{ad.title}</h3>
                                                <span
                                                    className={`px-2 py-1 text-xs font-semibold rounded-full ${ad.isActive
                                                            ? 'bg-green-100 text-green-800'
                                                            : 'bg-gray-100 text-gray-800'
                                                        }`}
                                                >
                                                    {ad.isActive ? 'Active' : 'Inactive'}
                                                </span>
                                            </div>
                                            <p className="text-gray-600 mb-3">{ad.description}</p>
                                            <div className="flex flex-wrap gap-4 text-sm text-gray-500">
                                                <div>
                                                    <span className="font-medium">Video:</span>{' '}
                                                    <a
                                                        href={ad.videoUrl}
                                                        target="_blank"
                                                        rel="noopener noreferrer"
                                                        className="text-purple-600 hover:underline"
                                                    >
                                                        View
                                                    </a>
                                                </div>
                                                {ad.ctaText && (
                                                    <div>
                                                        <span className="font-medium">CTA:</span> {ad.ctaText}
                                                    </div>
                                                )}
                                                {ad.targetUrl && (
                                                    <div>
                                                        <span className="font-medium">Target:</span>{' '}
                                                        <a
                                                            href={ad.targetUrl}
                                                            target="_blank"
                                                            rel="noopener noreferrer"
                                                            className="text-purple-600 hover:underline"
                                                        >
                                                            Link
                                                        </a>
                                                    </div>
                                                )}
                                            </div>
                                        </div>

                                        <div className="flex gap-2 ml-4">
                                            <button
                                                onClick={() => toggleActive(ad)}
                                                className={`px-4 py-2 rounded-lg font-medium transition-colors ${ad.isActive
                                                        ? 'bg-gray-200 text-gray-700 hover:bg-gray-300'
                                                        : 'bg-green-600 text-white hover:bg-green-700'
                                                    }`}
                                            >
                                                {ad.isActive ? 'Deactivate' : 'Activate'}
                                            </button>
                                            <button
                                                onClick={() => handleEdit(ad)}
                                                className="px-4 py-2 bg-blue-600 text-white rounded-lg font-medium hover:bg-blue-700 transition-colors"
                                            >
                                                Edit
                                            </button>
                                            <button
                                                onClick={() => handleDelete(ad.id)}
                                                className="px-4 py-2 bg-red-600 text-white rounded-lg font-medium hover:bg-red-700 transition-colors"
                                            >
                                                Delete
                                            </button>
                                        </div>
                                    </div>
                                </div>
                            ))}
                        </div>
                    )}
                </div>

                {/* Instructions */}
                <div className="mt-8 bg-blue-50 border border-blue-200 rounded-lg p-6">
                    <h3 className="text-lg font-semibold text-blue-900 mb-3">📱 Mobile App Integration</h3>
                    <p className="text-blue-800 mb-4">
                        To connect your mobile app to this admin panel:
                    </p>
                    <ol className="list-decimal list-inside space-y-2 text-blue-800">
                        <li>Deploy this website to Vercel</li>
                        <li>Copy your Vercel deployment URL</li>
                        <li>
                            Update <code className="bg-blue-100 px-2 py-1 rounded">mobile/src/config/appConfig.ts</code>
                        </li>
                        <li>
                            Set <code className="bg-blue-100 px-2 py-1 rounded">api.adsEndpoint</code> to{' '}
                            <code className="bg-blue-100 px-2 py-1 rounded">https://your-site.vercel.app/api/ads</code>
                        </li>
                    </ol>
                </div>
            </div>
        </div>
    );
}
