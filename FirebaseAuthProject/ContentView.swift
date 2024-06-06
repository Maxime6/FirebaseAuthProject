//
//  ContentView.swift
//  FirebaseAuthProject
//
//  Created by Maxime Tanter on 05/06/2024.
//

import SwiftUI
import AuthenticationServices
import Firebase
import CryptoKit
import GoogleSignInSwift

struct ContentView: View {
    
    @EnvironmentObject var authManager: AuthManager
    
    @State var scale = 0.0
    
    var body: some View {
        if authManager.authState != . signedOut {
            HomeView()
                .scaleEffect(scale)
                .onAppear {
                    withAnimation {
                        scale = 1.0
                    }
                }
        } else {
            VStack {
                AppleButton()
                    .padding(.bottom, 20)
                
                GoogleSignInButton(style: .wide) {
                    Task {
                        await signInWithGoogle()
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: 40)
                .clipShape(Capsule())
                .shadow(radius: 2)
//                .overlay {
//                    RoundedRectangle(cornerRadius: 25)
//                        .stroke(.primary, lineWidth: 1)
//                }

            }
            .scaleEffect(scale)
            .onAppear {
                withAnimation(.easeInOut) {
                    scale = 1.0
                }
            }
            .padding()
        }
    }
    
    func signInWithGoogle() async {
        do {
            guard let user = try await GoogleSignInManager.shared.signInWithGoogle() else { return }

            let result = try await authManager.googleAuth(user)
            if let result = result {
                print("GoogleSignInSuccess: \(result.user.uid)")
//                dismiss()
            }
        }
        catch {
            print("GoogleSignInError: failed to sign in with Google, \(error))")
            // Here you can show error message to user.
        }
    }
    
    func handleAppleID(_ result: Result<ASAuthorization, Error>) {
        if case let .success(auth) = result {
            guard let appleIDCredentials = auth.credential as? ASAuthorizationAppleIDCredential else {
                print("AppleAuthorization failed: AppleID credential not available")
                return
            }
            
            Task {
                do {
                    let result = try await authManager.appleAuth(appleIDCredentials, nonce: AppleSignInManager.nonce)
                    if let result = result {
                        // dismiss
                    }
                }
                catch {
                    print("AppleAuthorization failed: \(error)")
                    // Here you can show error message to user.
                }
            }
        }
        else if case let .failure(error) = result {
            print("AppleAuthorization failed: \(error)")
            // Here you can show error message to user.
        }
    }
    
    /// Sign in with Apple Button
    @ViewBuilder
    func AppleButton() -> some View {
        SignInWithAppleButton(.continue) { request in
            AppleSignInManager.shared.requestAppleAuthorization(request)
        } onCompletion: { result in
            handleAppleID(result)
        }
        .frame(maxWidth: .infinity, maxHeight: 45)
        .clipShape(.capsule)
    }
    
    @ViewBuilder
    func loadingView() -> some View {
        ZStack {
            Rectangle()
                .fill(.ultraThinMaterial)
            
            ProgressView()
                .frame(width: 45, height: 45)
                .background(.background, in: .rect(cornerRadius: 5))
        }
    }
}

#Preview {
    ContentView()
}
