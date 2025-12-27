import { initializeApp, cert, getApps } from 'firebase-admin/app';
import { getAuth } from 'firebase-admin/auth';
import { getFirestore } from 'firebase-admin/firestore';

// Initialize Firebase Admin SDK
if (!getApps().length) {
    const serviceAccount = process.env.FIREBASE_ADMIN_SDK
        ? JSON.parse(process.env.FIREBASE_ADMIN_SDK)
        : undefined;

    if (serviceAccount) {
        initializeApp({
            credential: cert(serviceAccount)
        });
    } else {
        // For development, use default credentials
        initializeApp();
    }
}

export const auth = getAuth();
export const firestore = getFirestore();

/**
 * Verify Firebase ID token from request
 * @param request - Next.js request object
 * @returns Decoded token with user info
 * @throws Error if token is invalid or missing
 */
export async function verifyAuthToken(request: Request): Promise<{
    uid: string;
    email?: string;
    role?: string;
}> {
    const authHeader = request.headers.get('Authorization');

    if (!authHeader || !authHeader.startsWith('Bearer ')) {
        throw new Error('Missing or invalid authorization header');
    }

    const token = authHeader.replace('Bearer ', '');

    try {
        const decodedToken = await auth.verifyIdToken(token);

        // Get user role from Firestore
        const userDoc = await firestore.collection('users').doc(decodedToken.uid).get();
        const userData = userDoc.data();

        return {
            uid: decodedToken.uid,
            email: decodedToken.email,
            role: userData?.role || 'user'
        };
    } catch (error) {
        throw new Error('Invalid or expired token');
    }
}

/**
 * Check if user is admin
 */
export async function isAdmin(uid: string): Promise<boolean> {
    const userDoc = await firestore.collection('users').doc(uid).get();
    const userData = userDoc.data();
    return userData?.role === 'admin';
}
