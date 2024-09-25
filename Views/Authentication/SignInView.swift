import SwiftUI

struct SignInView: View {
    @EnvironmentObject var authViewModel: AuthenticationViewModel

    @State private var email: String = ""
    @State private var password: String = ""
    @State private var showSignUp = false
    @State private var showAlert = false
    @State private var alertMessage = ""

    var body: some View {
        VStack(spacing: 20) {
            TextField("Email", text: $email)
                .autocapitalization(.none)
                .padding()
                .background(Color(.secondarySystemBackground))
                .cornerRadius(5)

            SecureField("Password", text: $password)
                .padding()
                .background(Color(.secondarySystemBackground))
                .cornerRadius(5)

            Button(action: {
                signIn()
            }) {
                Text("Sign In")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(5)
            }

            Button(action: {
                showSignUp = true
            }) {
                Text("Don't have an account? Sign Up")
            }
            .sheet(isPresented: $showSignUp) {
                SignUpView()
                    .environmentObject(authViewModel)
            }

            Spacer()
        }
        .padding()
        .navigationTitle("Sign In")
        .alert(isPresented: $showAlert) {
            Alert(title: Text("Sign In Error"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
        }
    }

    func signIn() {
        authViewModel.signIn(email: email, password: password) { error in
            if let error = error {
                alertMessage = error.localizedDescription
                showAlert = true
            } else {
                // Successful sign-in actions
            }
        }
    }
}
