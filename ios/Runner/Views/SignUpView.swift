import SwiftUI

struct SignUpView: View {
    @Environment(\.dismiss) var dismiss
    @State private var fullName = ""
    @State private var email = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var isPasswordVisible = false
    @State private var isConfirmPasswordVisible = false
    @State private var isLoading = false
    @State private var errorMessage = ""

    @State private var emailError = ""
    @State private var passwordError = ""
    @State private var fullNameError = ""
    @State private var confirmPasswordError = ""

    private var isEmailValid: Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 0) {
                    // Logo/Icon
                    Image(systemName: "person.badge.plus")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 80, height: 80)
                        .foregroundColor(.blue)
                        .padding(.top, 20)

                    VStack(spacing: 8) {
                        Text("Create Account")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(.primary)

                        Text("Sign up to get started")
                            .font(.body)
                            .foregroundColor(.secondary)
                    }
                    .padding(.top, 32)

                    VStack(spacing: 20) {
                        // Full Name
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Full Name")
                                .font(.headline)
                                .foregroundColor(.secondary)

                            HStack {
                                Image(systemName: "person")
                                    .foregroundColor(.gray)
                                TextField("Enter your name", text: $fullName)
                            }
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(!fullNameError.isEmpty ? Color.red : Color.gray.opacity(0.3), lineWidth: 1)
                            )
                            if !fullNameError.isEmpty {
                                Text(fullNameError).font(.caption).foregroundColor(.red)
                            }
                        }

                        // Email
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
                                    .onChange(of: email) { _ in
                                        validateEmail()
                                    }
                            }
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(!emailError.isEmpty ? Color.red : Color.gray.opacity(0.3), lineWidth: 1)
                            )
                            if !emailError.isEmpty {
                                Text(emailError).font(.caption).foregroundColor(.red)
                            }
                        }

                        // Password
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Password")
                                .font(.headline)
                                .foregroundColor(.secondary)

                            HStack {
                                Image(systemName: "lock")
                                    .foregroundColor(.gray)
                                if isPasswordVisible {
                                    TextField("Enter password", text: $password)
                                } else {
                                    SecureField("Enter password", text: $password)
                                }
                                Button {
                                    isPasswordVisible.toggle()
                                } label: {
                                    Image(systemName: isPasswordVisible ? "eye.slash" : "eye")
                                        .foregroundColor(.gray)
                                }
                            }
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(!passwordError.isEmpty ? Color.red : Color.gray.opacity(0.3), lineWidth: 1)
                            )
                            if !passwordError.isEmpty {
                                Text(passwordError).font(.caption).foregroundColor(.red)
                            }
                        }

                        // Confirm Password
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Confirm Password")
                                .font(.headline)
                                .foregroundColor(.secondary)

                            HStack {
                                Image(systemName: "lock")
                                    .foregroundColor(.gray)
                                if isConfirmPasswordVisible {
                                    TextField("Confirm password", text: $confirmPassword)
                                } else {
                                    SecureField("Confirm password", text: $confirmPassword)
                                }
                                Button {
                                    isConfirmPasswordVisible.toggle()
                                } label: {
                                    Image(systemName: isConfirmPasswordVisible ? "eye.slash" : "eye")
                                        .foregroundColor(.gray)
                                }
                            }
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(!confirmPasswordError.isEmpty ? Color.red : Color.gray.opacity(0.3), lineWidth: 1)
                            )
                            if !confirmPasswordError.isEmpty {
                                Text(confirmPasswordError).font(.caption).foregroundColor(.red)
                            }
                        }
                    }
                    .padding(.top, 40)

                    if !errorMessage.isEmpty {
                        Text(errorMessage)
                            .foregroundColor(.red)
                            .font(.caption)
                            .padding(.top, 8)
                    }

                    // Sign Up Button
                    Button {
                        handleSignUp()
                    } label: {
                        HStack {
                            if isLoading {
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                            } else {
                                Text("Sign Up")
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

                    // OR Divider
                    HStack {
                        Rectangle()
                            .frame(height: 1)
                            .foregroundColor(Color.gray.opacity(0.3))
                        Text("OR")
                            .font(.caption)
                            .foregroundColor(.gray)
                            .padding(.horizontal, 16)
                        Rectangle()
                            .frame(height: 1)
                            .foregroundColor(Color.gray.opacity(0.3))
                    }
                    .padding(.vertical, 32)

                    // Social Buttons
                    HStack(spacing: 32) {
                        SocialButton(icon: "g.circle.fill", color: .red) {
                            // Google Login
                        }
                        SocialButton(icon: "apple.logo", color: .black) {
                            // Apple Login
                        }
                        SocialButton(icon: "f.circle.fill", color: .blue) {
                            // Facebook Login
                        }
                    }

                    // Footer
                    HStack {
                        Text("Already have an account?")
                            .foregroundColor(.secondary)
                        Button {
                            dismiss()
                        } label: {
                            Text("Log In")
                                .fontWeight(.bold)
                                .foregroundColor(.blue)
                        }
                    }
                    .padding(.top, 40)
                    .padding(.bottom, 24)
                }
                .padding(.horizontal, 24)
            }
            .navigationTitle("Sign Up")
            .navigationBarTitleDisplayMode(.large)
        }
    }

    private func validateEmail() {
        if email.isEmpty {
            emailError = "Email is required"
        } else if !isEmailValid {
            emailError = "Enter a valid email address"
        } else {
            emailError = ""
        }
    }

    private func handleSignUp() {
        // Trigger validations
        validateEmail()
        fullNameError = fullName.isEmpty ? "Full Name is required" : ""
        passwordError = password.isEmpty ? "Password is required" : (password.count < 6 ? "Password too short" : "")
        confirmPasswordError = confirmPassword != password ? "Passwords do not match" : ""

        guard emailError.isEmpty, fullNameError.isEmpty, passwordError.isEmpty, confirmPasswordError.isEmpty else {
            return
        }

        isLoading = true
        errorMessage = ""

        let url = URL(string: "http://192.168.1.154:5001/api/auth/register")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        let body: [String: String] = [
            "fullName": fullName,
            "email": email,
            "password": password
        ]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body)

        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                isLoading = false
                if let error = error {
                    errorMessage = "Failed to connect to server: \(error.localizedDescription)"
                    return
                }

                if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 201 {
                    dismiss()
                } else {
                    errorMessage = "Registration failed. Email might already exist."
                }
            }
        }.resume()
    }
}

#Preview {
    SignUpView()
}
