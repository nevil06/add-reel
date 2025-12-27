import { NextResponse } from 'next/server';
import type { NextRequest } from 'next/server';

// Simple in-memory rate limiter
// TODO: Replace with Redis for production (Upstash)
const rateLimitMap = new Map<string, { count: number; resetTime: number }>();

/**
 * Check if request should be rate limited
 * @param identifier - IP address or user ID
 * @param maxRequests - Maximum requests allowed in window
 * @param windowMs - Time window in milliseconds
 * @returns true if request is allowed, false if rate limited
 */
export function checkRateLimit(
    identifier: string,
    maxRequests: number = 100,
    windowMs: number = 60000
): boolean {
    const now = Date.now();
    const record = rateLimitMap.get(identifier);

    // Clean up old entries periodically
    if (rateLimitMap.size > 10000) {
        for (const [key, value] of rateLimitMap.entries()) {
            if (now > value.resetTime) {
                rateLimitMap.delete(key);
            }
        }
    }

    if (!record || now > record.resetTime) {
        rateLimitMap.set(identifier, { count: 1, resetTime: now + windowMs });
        return true;
    }

    if (record.count >= maxRequests) {
        return false;
    }

    record.count++;
    return true;
}

/**
 * Middleware to apply rate limiting to API routes
 */
export function middleware(request: NextRequest) {
    // Skip rate limiting for non-API routes
    if (!request.nextUrl.pathname.startsWith('/api')) {
        return NextResponse.next();
    }

    // Get client identifier (IP address)
    const ip = request.ip ||
        request.headers.get('x-forwarded-for') ||
        request.headers.get('x-real-ip') ||
        'unknown';

    // Rate limit: 100 requests per minute per IP
    if (!checkRateLimit(ip, 100, 60000)) {
        return NextResponse.json(
            {
                error: 'Too many requests',
                message: 'Please try again later'
            },
            {
                status: 429,
                headers: {
                    'Retry-After': '60'
                }
            }
        );
    }

    return NextResponse.next();
}

export const config = {
    matcher: '/api/:path*',
};
