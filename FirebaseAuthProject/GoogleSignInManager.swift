//
//  GoogleSignInManager.swift
//  FirebaseAuthProject
//
//  Created by Maxime Tanter on 05/06/2024.
//

import Foundation
import GoogleSignIn

class GoogleSignInManager {
    
    static let shared = GoogleSignInManager()
    
    typealias GoogleAuthResult = (GIDGoogleUser?, Error?) -> Void
    
    private init() {}
    
    @MainActor
    func signInWithGoogle() async throws -> GIDGoogleUser? {
        // 1.
        if GIDSignIn.sharedInstance.hasPreviousSignIn() {
            return try await GIDSignIn.sharedInstance.restorePreviousSignIn()
        } else {
            // 2.
            guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return nil }
            guard let rootViewController = windowScene.windows.first?.rootViewController else { return nil }
            
            // 3.
            let result = try await GIDSignIn.sharedInstance.signIn(withPresenting: rootViewController)
            return result.user
        }
    }
    
    // 4.
    func signOutFromGoogle() {
        GIDSignIn.sharedInstance.signOut()
    }
}
