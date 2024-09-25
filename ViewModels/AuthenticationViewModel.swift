import Foundation
import FirebaseAuth

enum AuthState {
    case undefined
    case signedOut
    case signedIn
}

class AuthenticationViewModel: ObservableObject {
    @Published var isUserAuthenticated: AuthState = .undefined
    @Published var user: FirebaseAuth.User?

    init() {
        self.configureFirebaseStateDidChange()
    }

    func configureFirebaseStateDidChange() {
        Auth.auth().addStateDidChangeListener { [weak self] (_, user) in
            guard let self = self else { return }
            if let user = user {
                self.isUserAuthenticated = .signedIn
                self.user = user
            } else {
                self.isUserAuthenticated = .signedOut
                self.user = nil
            }
        }
    }

    func signUp(email: String, password: String, completion: @escaping (Error?) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { [weak self] authResult, error in
            if let error = error {
                completion(error)
            } else {
                self?.user = authResult?.user
                self?.isUserAuthenticated = .signedIn
                completion(nil)
            }
        }
    }

    func signIn(email: String, password: String, completion: @escaping (Error?) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] authResult, error in
            if let error = error {
                completion(error)
            } else {
                self?.user = authResult?.user
                self?.isUserAuthenticated = .signedIn
                completion(nil)
            }
        }
    }

    func signOut() {
        do {
            try Auth.auth().signOut()
            self.isUserAuthenticated = .signedOut
            self.user = nil
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
        }
    }
}
