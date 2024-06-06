//
//  HomeView.swift
//  FirebaseAuthProject
//
//  Created by Maxime Tanter on 05/06/2024.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject var authManager: AuthManager
    
    var body: some View {
        VStack {
//            Text(authManager.user?.displayName ?? "Username")
            Text(authManager.user?.email ?? "User Email")
                .font(.title2.bold())
                .padding(.bottom, 25)
            
            Button {
               signOut()
            } label: {
                Text("Log out")
                    .bold()
                    .frame(width: 150, height: 44)
                    .background(.blue)
                    .foregroundStyle(.white)
                    .clipShape(.capsule)
            }
            .padding()
        }
    }
    
    func signOut() {
        Task {
            do {
                try await authManager.signOut()
            }
            catch {
                print("Error: \(error)")
            }
        }
    }
}

#Preview {
    HomeView()
}
