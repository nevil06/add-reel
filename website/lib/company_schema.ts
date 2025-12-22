// Company Schema and Types

export interface Company {
    id: string;
    name: string;
    email: string;
    password: string; // Hashed password
    commissionRate: number; // Percentage (e.g., 0.3 for 30%)
    isActive: boolean;
    branding: CompanyBranding;
    createdAt: string;
    updatedAt: string;
}

export interface CompanyBranding {
    logo?: string; // URL to company logo
    primaryColor?: string; // Hex color code
    secondaryColor?: string;
}

export interface CompanyAuth {
    email: string;
    password: string;
}

export interface CompanyStats {
    companyId: string;
    totalAds: number;
    activeAds: number;
    totalViews: number;
    totalEarnings: number;
    commission: number;
}

export interface CompanyData {
    companies: Company[];
}
