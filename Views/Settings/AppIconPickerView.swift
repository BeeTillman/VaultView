import SwiftUI

struct AppIconPickerView: View {
    @Environment(\.presentationMode) var presentationMode

    let appIcons = [
        ("Default", nil),
        ("AlternateIcon1", "AlternateIcon1"),
        ("AlternateIcon2", "AlternateIcon2")
    ]

    var body: some View {
        NavigationView {
            List {
                ForEach(appIcons, id: \.1) { icon in
                    HStack {
                        Image(uiImage: UIImage(named: icon.1 ?? "AppIcon")!)
                            .resizable()
                            .frame(width: 60, height: 60)
                            .cornerRadius(10)
                        Text(icon.0)
                        Spacer()
                        if UIApplication.shared.alternateIconName == icon.1 {
                            Image(systemName: "checkmark")
                        }
                    }
                    .contentShape(Rectangle())
                    .onTapGesture {
                        changeAppIcon(to: icon.1)
                    }
                }
            }
            .navigationTitle("Choose App Icon")
            .navigationBarItems(trailing: Button("Done") {
                presentationMode.wrappedValue.dismiss()
            })
        }
    }

    func changeAppIcon(to iconName: String?) {
        UIApplication.shared.setAlternateIconName(iconName) { error in
            if let error = error {
                print("Error setting app icon: \(error.localizedDescription)")
            } else {
                print("App icon changed to \(iconName ?? "Default")")
            }
        }
    }
}
