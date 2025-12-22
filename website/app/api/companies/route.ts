import { NextRequest, NextResponse } from 'next/server';
import fs from 'fs';
import path from 'path';

const COMPANIES_FILE_PATH = path.join(process.cwd(), 'public', 'api', 'companies.json');

// Helper to read companies from file
function readCompanies() {
    try {
        const fileContent = fs.readFileSync(COMPANIES_FILE_PATH, 'utf-8');
        return JSON.parse(fileContent);
    } catch (error) {
        return { companies: [] };
    }
}

// Helper to write companies to file
function writeCompanies(data: any) {
    fs.writeFileSync(COMPANIES_FILE_PATH, JSON.stringify(data, null, 2));
}

// GET - Fetch all companies
export async function GET() {
    try {
        const data = readCompanies();
        // Remove passwords from response
        const sanitizedCompanies = data.companies.map((company: any) => {
            const { password, ...rest } = company;
            return rest;
        });
        return NextResponse.json({ companies: sanitizedCompanies });
    } catch (error) {
        return NextResponse.json({ error: 'Failed to fetch companies' }, { status: 500 });
    }
}

// POST - Add new company
export async function POST(request: NextRequest) {
    try {
        const newCompany = await request.json();
        const data = readCompanies();

        // Check if email already exists
        const existingCompany = data.companies.find((c: any) => c.email === newCompany.email);
        if (existingCompany) {
            return NextResponse.json({ error: 'Company with this email already exists' }, { status: 400 });
        }

        // Generate ID
        newCompany.id = Date.now().toString();
        newCompany.createdAt = new Date().toISOString();
        newCompany.updatedAt = new Date().toISOString();

        // Set defaults
        if (!newCompany.commissionRate) newCompany.commissionRate = 0.3;
        if (newCompany.isActive === undefined) newCompany.isActive = true;
        if (!newCompany.branding) newCompany.branding = {};

        data.companies.push(newCompany);
        writeCompanies(data);

        // Remove password from response
        const { password, ...sanitizedCompany } = newCompany;
        return NextResponse.json(sanitizedCompany, { status: 201 });
    } catch (error) {
        return NextResponse.json({ error: 'Failed to create company' }, { status: 500 });
    }
}

// PUT - Update company
export async function PUT(request: NextRequest) {
    try {
        const updatedCompany = await request.json();
        const data = readCompanies();

        const index = data.companies.findIndex((c: any) => c.id === updatedCompany.id);
        if (index === -1) {
            return NextResponse.json({ error: 'Company not found' }, { status: 404 });
        }

        // Update timestamp
        updatedCompany.updatedAt = new Date().toISOString();

        data.companies[index] = { ...data.companies[index], ...updatedCompany };
        writeCompanies(data);

        // Remove password from response
        const { password, ...sanitizedCompany } = data.companies[index];
        return NextResponse.json(sanitizedCompany);
    } catch (error) {
        return NextResponse.json({ error: 'Failed to update company' }, { status: 500 });
    }
}

// DELETE - Delete company
export async function DELETE(request: NextRequest) {
    try {
        const { searchParams } = new URL(request.url);
        const id = searchParams.get('id');

        if (!id) {
            return NextResponse.json({ error: 'Company ID required' }, { status: 400 });
        }

        const data = readCompanies();
        data.companies = data.companies.filter((c: any) => c.id !== id);
        writeCompanies(data);

        return NextResponse.json({ success: true });
    } catch (error) {
        return NextResponse.json({ error: 'Failed to delete company' }, { status: 500 });
    }
}
