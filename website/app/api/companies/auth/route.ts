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

// POST - Company login
export async function POST(request: NextRequest) {
    try {
        const { email, password } = await request.json();

        if (!email || !password) {
            return NextResponse.json({ error: 'Email and password required' }, { status: 400 });
        }

        const data = readCompanies();
        const company = data.companies.find((c: any) => c.email === email);

        if (!company) {
            return NextResponse.json({ error: 'Invalid credentials' }, { status: 401 });
        }

        // Simple password check (in production, use bcrypt)
        if (company.password !== password) {
            return NextResponse.json({ error: 'Invalid credentials' }, { status: 401 });
        }

        if (!company.isActive) {
            return NextResponse.json({ error: 'Company account is inactive' }, { status: 403 });
        }

        // Remove password from response
        const { password: _, ...sanitizedCompany } = company;
        return NextResponse.json({
            success: true,
            company: sanitizedCompany
        });
    } catch (error) {
        return NextResponse.json({ error: 'Authentication failed' }, { status: 500 });
    }
}
