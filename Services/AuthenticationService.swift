import Foundation
import FirebaseAuth
import GoogleSignIn
import AuthenticationServices

class AuthenticationService {
    static let shared = AuthenticationService()
    
    // Email and Password Authentication
    func signIn(email: String, password: String, completion: @escaping (Result<User, Error>) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            if let error = error {
                completion(.failure(error))
            } else if let firebaseUser = authResult?.user {
                let user = User(id: firebaseUser.uid, email: firebaseUser.email ?? "", displayName: firebaseUser.displayName)
                completion(.success(user))
            }
        }
    }
    
    func signUp(email: String, password: String, completion: @escaping (Result<User, Error>) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            if let error = error {
                completion(.failure(error))
            } else if let firebaseUser = authResult?.user {
                let user = User(id: firebaseUser.uid, email: firebaseUser.email ?? "", displayName: firebaseUser.displayName)
                completion(.success(user))
            }
        }
    }
    
    func signOut(completion: @escaping (Result<Void, Error>) -> Void) {
        do {
            try Auth.auth().signOut()
            completion(.success(()))
        } catch let signOutError as NSError {
            completion(.failure(signOutError))
        }
    }
    
    // Sign in with Apple
    func handleAppleSignIn(credential: ASAuthorizationAppleIDCredential, completion: @escaping (Result<User, Error>) -> Void) {
        // Implement Apple sign-in logic with Firebase
    }
    
    // Sign in with Google
    func handleGoogleSignIn(completion: @escaping (Result<User, Error>) -> Void) {
        // Implement Google sign-in logic with Firebase
    }
}
