import { NextRequest, NextResponse } from 'next/server';
import fs from 'fs';
import path from 'path';

const ADS_FILE_PATH = path.join(process.cwd(), 'public', 'api', 'ads.json');
const COMPANIES_FILE_PATH = path.join(process.cwd(), 'public', 'api', 'companies.json');

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

// Helper to read companies from file
function readCompanies() {
    try {
        const fileContent = fs.readFileSync(COMPANIES_FILE_PATH, 'utf-8');
        return JSON.parse(fileContent);
    } catch (error) {
        return { companies: [] };
    }
}

// Helper to get company name by ID
function getCompanyName(companyId: string): string {
    const data = readCompanies();
    const company = data.companies.find((c: any) => c.id === companyId);
    return company ? company.name : 'Unknown Company';
}

// GET - Fetch all ads (with optional company filter)
export async function GET(request: NextRequest) {
    try {
        const { searchParams } = new URL(request.url);
        const companyId = searchParams.get('companyId');

        const data = readAds();
        let ads = data.ads || [];

        // Filter by company if specified
        if (companyId) {
            ads = ads.filter((ad: any) => ad.companyId === companyId);
        }

        // Add company names to ads
        ads = ads.map((ad: any) => ({
            ...ad,
            companyName: ad.companyId ? getCompanyName(ad.companyId) : 'N/A'
        }));

        return NextResponse.json({ ads });
    } catch (error) {
        return NextResponse.json({ error: 'Failed to fetch ads' }, { status: 500 });
    }
}

// POST - Add new ad
export async function POST(request: NextRequest) {
    try {
        const newAd = await request.json();
        const data = readAds();

        // Validate company exists if companyId provided
        if (newAd.companyId) {
            const companies = readCompanies();
            const companyExists = companies.companies.some((c: any) => c.id === newAd.companyId);
            if (!companyExists) {
                return NextResponse.json({ error: 'Invalid company ID' }, { status: 400 });
            }
        }

        // Generate ID
        newAd.id = Date.now().toString();
        newAd.createdAt = new Date().toISOString();
        newAd.order = data.ads.length + 1;

        // Set default companyId if not provided (for backward compatibility)
        if (!newAd.companyId) {
            newAd.companyId = '1'; // Default to first company
        }

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

        // Validate company exists if companyId is being updated
        if (updatedAd.companyId && updatedAd.companyId !== data.ads[index].companyId) {
            const companies = readCompanies();
            const companyExists = companies.companies.some((c: any) => c.id === updatedAd.companyId);
            if (!companyExists) {
                return NextResponse.json({ error: 'Invalid company ID' }, { status: 400 });
            }
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
