import SwiftUI

struct LoginView: View {
    @State private var email = ""
    @State private var password = ""
    @State private var isLoading = false
    @State private var showSignUp = false
    @State private var navigateToHome = false
    @State private var errorMessage = ""
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 0) {
                    // Logo/Icon
                    Image(systemName: "lock.shield")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 80, height: 80)
                        .foregroundColor(.blue)
                        .padding(.top, 40)
                    
                    VStack(spacing: 8) {
                        Text("Welcome Back")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(.primary)
                        
                        Text("Log in to your account")
                            .font(.body)
                            .foregroundColor(.secondary)
                    }
                    .padding(.top, 32)
                    
                    VStack(spacing: 20) {
                        // Email Field
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Email")
                                .font(.headline)
                                .foregroundColor(.secondary)
                            
                            HStack {
                                Image(systemName: "envelope")
                                    .foregroundColor(.gray)
                                TextField("Enter your email", text: $email)
                                    .keyboardType(.emailAddress)
                                    .autocapitalization(.none)
                            }
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                            )
                        }
                        
                        // Password Field
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Password")
                                .font(.headline)
                                .foregroundColor(.secondary)
                            
                            HStack {
                                Image(systemName: "lock")
                                    .foregroundColor(.gray)
                                SecureField("Enter password", text: $password)
                            }
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                            )
                        }
                    }
                    .padding(.top, 40)
                    
                    if !errorMessage.isEmpty {
                        Text(errorMessage)
                            .foregroundColor(.red)
                            .font(.caption)
                            .padding(.top, 8)
                    }
                    
                    // Login Button
                    Button {
                        handleLogin()
                    } label: {
                        HStack {
                            if isLoading {
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                            } else {
                                Text("Log In")
                                    .font(.headline)
                                    .fontWeight(.bold)
                            }
                        }
                        .frame(maxWidth: .infinity)
                        .frame(height: 56)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                    }
                    .padding(.top, 32)
                    .disabled(isLoading)
                    
                    // Footer
                    HStack {
                        Text("Don't have an account?")
                            .foregroundColor(.secondary)
                        Button {
                            showSignUp.toggle()
                        } label: {
                            Text("Sign Up")
                                .fontWeight(.bold)
                                .foregroundColor(.blue)
                        }
                    }
                    .padding(.top, 40)
                    .padding(.bottom, 24)
                }
                .padding(.horizontal, 24)
            }
            .navigationDestination(isPresented: $navigateToHome) {
                HomeView()
            }
            .sheet(isPresented: $showSignUp) {
                SignUpView()
            }
        }
    }
    
    private func handleLogin() {
        isLoading = true
        errorMessage = ""
        
        let url = URL(string: "http://192.168.1.154:5001/api/auth/login")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body: [String: String] = ["email": email, "password": password]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                isLoading = false
                if let error = error {
                    errorMessage = "Failed to connect to server: \(error.localizedDescription)"
                    return
                }
                
                if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
                    navigateToHome = true
                } else {
                    errorMessage = "Invalid credentials or server error"
                }
            }
        }.resume()
    }
}

#Preview {
    LoginView()
}
