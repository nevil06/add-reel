import { NextRequest, NextResponse } from 'next/server';
import fs from 'fs';
import path from 'path';

const ADS_FILE_PATH = path.join(process.cwd(), 'public', 'api', 'ads.json');

// Helper to read ads from file
function readAds() {
    try {
        const fileContent = fs.readFileSync(ADS_FILE_PATH, 'utf-8');
        return JSON.parse(fileContent);
    } catch (error) {
        return { ads: [] };
    }
}

// Helper to write ads to file
function writeAds(data: any) {
    fs.writeFileSync(ADS_FILE_PATH, JSON.stringify(data, null, 2));
}

// GET - Fetch all ads
export async function GET() {
    try {
        const data = readAds();
        return NextResponse.json(data);
    } catch (error) {
        return NextResponse.json({ error: 'Failed to fetch ads' }, { status: 500 });
    }
}

// POST - Add new ad
export async function POST(request: NextRequest) {
    try {
        const newAd = await request.json();
        const data = readAds();

        // Generate ID
        newAd.id = Date.now().toString();
        newAd.createdAt = new Date().toISOString();
        newAd.order = data.ads.length + 1;

        data.ads.push(newAd);
        writeAds(data);

        return NextResponse.json(newAd, { status: 201 });
    } catch (error) {
        return NextResponse.json({ error: 'Failed to create ad' }, { status: 500 });
    }
}

// PUT - Update ad
export async function PUT(request: NextRequest) {
    try {
        const updatedAd = await request.json();
        const data = readAds();

        const index = data.ads.findIndex((ad: any) => ad.id === updatedAd.id);
        if (index === -1) {
            return NextResponse.json({ error: 'Ad not found' }, { status: 404 });
        }

        data.ads[index] = { ...data.ads[index], ...updatedAd };
        writeAds(data);

        return NextResponse.json(data.ads[index]);
    } catch (error) {
        return NextResponse.json({ error: 'Failed to update ad' }, { status: 500 });
    }
}

// DELETE - Delete ad
export async function DELETE(request: NextRequest) {
    try {
        const { searchParams } = new URL(request.url);
        const id = searchParams.get('id');

        if (!id) {
            return NextResponse.json({ error: 'Ad ID required' }, { status: 400 });
        }

        const data = readAds();
        data.ads = data.ads.filter((ad: any) => ad.id !== id);
        writeAds(data);

        return NextResponse.json({ success: true });
    } catch (error) {
        return NextResponse.json({ error: 'Failed to delete ad' }, { status: 500 });
    }
}
