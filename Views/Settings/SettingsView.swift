import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var authViewModel: AuthenticationViewModel
    @State private var notificationFrequency: TimeInterval = 86400 // Default to daily
    @State private var selectedAppearance: Appearance = .system
    @State private var showAppIconPicker = false

    var body: some View {
        NavigationView {
            Form {
                // Notifications Section
                Section(header: Text("Notifications")) {
                    Picker("Frequency", selection: $notificationFrequency) {
                        Text("Daily").tag(TimeInterval(86400))
                        Text("Weekly").tag(TimeInterval(604800))
                        Text("Monthly").tag(TimeInterval(2592000))
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .onChange(of: notificationFrequency) { newValue in
                        NotificationManager.shared.scheduleNotification(frequency: newValue)
                    }
                }

                // Account Section
                Section(header: Text("Account")) {
                    HStack {
                        Text("Name")
                        Spacer()
                        Text(authViewModel.user?.displayName ?? "Unknown")
                            .foregroundColor(.gray)
                    }
                    HStack {
                        Text("Email")
                        Spacer()
                        Text(authViewModel.user?.email ?? "Unknown")
                            .foregroundColor(.gray)
                    }
                    Button(action: {
                        // Implement profile picture change
                    }) {
                        Text("Change Profile Picture")
                    }
                    Button(action: {
                        authViewModel.signOut()
                    }) {
                        Text("Sign Out")
                            .foregroundColor(.red)
                    }
                }

                // Appearance Section
                Section(header: Text("Appearance")) {
                    Picker("App Theme", selection: $selectedAppearance) {
                        Text("Light").tag(Appearance.light)
                        Text("Dark").tag(Appearance.dark)
                        Text("System").tag(Appearance.system)
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .onChange(of: selectedAppearance) { newValue in
                        AppearanceManager.shared.setAppearance(newValue)
                    }
                    Button(action: {
                        showAppIconPicker = true
                    }) {
                        HStack {
                            Text("App Icon")
                            Spacer()
                            if let appIcon = getCurrentAppIcon() {
                                Image(uiImage: appIcon)
                                    .resizable()
                                    .frame(width: 40, height: 40)
                            } else {
                                Image(systemName: "app.fill")
                                    .resizable()
                                    .frame(width: 40, height: 40)
                                    .foregroundColor(.gray)
                            }
                        }
                    }
                }
            }
            .navigationTitle("Settings")
            .sheet(isPresented: $showAppIconPicker) {
                AppIconPickerView()
            }
        }
    }

    func getCurrentAppIcon() -> UIImage? {
        if let iconName = UIApplication.shared.alternateIconName,
           let iconImage = UIImage(named: iconName) {
            return iconImage
        } else if let defaultIconImage = UIImage(named: "AppIcon") {
            return defaultIconImage
        } else {
            return nil
        }
    }
}
