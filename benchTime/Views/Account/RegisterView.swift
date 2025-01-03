//
//  RegisterView.swift
//  benchTime
//
//  Created by Joanna Xue on 7/5/2024.
//

import SwiftUI

struct RegisterView: View {
    @Environment(\.colorScheme) var colorScheme
    @ObservedObject var authManager = AuthenticationManager.shared
    @StateObject var viewModel = RegisterViewViewModel()

    var body: some View {
        ZStack {
            VStack {
                Spacer()
                HeaderView()
                VStack {
                    BTFormField(label: "Display name", text:  $viewModel.displayName)
                    
                    BTFormField(label: "Email address", text:  $viewModel.email)
                    
                    BTSecureField(label: "Password", text:  $viewModel.password)

                    BTButton(title: "Register", isDisabled: false) {
                        Task {
                            viewModel.register() { result in
                                switch result {
                                    case .success:
                                        print("Register successful")
                                        authManager.showSignInView = false
                                    case .failure:
                                        print("\(viewModel.errorMessage)")
                                }
                            }
                            
                        }
                    }
                }
                .padding(25)
                
                VStack{
                    Text("Already have an account?")
                        
                    NavigationLink {
                        LoginView()
                    } label: {
                        Text("Take a seat")
                            .foregroundColor(colorScheme == .dark ? UIStyles.Colors.Dark.link : UIStyles.Colors.Light.link)
                            .font(.headline)
                    }
                }
                Spacer()
            }
            
            if viewModel.isLoading {
                Loading()
            }
        }
        .navigationBarBackButtonHidden(true)
        .alert(isPresented: $viewModel.showAlert) {
            Alert(title: Text("Error"), message: Text(viewModel.errorMessage), dismissButton: .default(Text("OK")))
        }
    }
}
