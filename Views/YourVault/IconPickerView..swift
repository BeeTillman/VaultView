import SwiftUI

struct IconPickerView: View {
    @Binding var selectedIcon: String?
    let icons: [String]
    @Environment(\.presentationMode) var presentationMode

    let columns = [GridItem(.adaptive(minimum: 60))]

    var body: some View {
        NavigationView {
            ScrollView {
                LazyVGrid(columns: columns, spacing: 20) {
                    ForEach(icons, id: \.self) { iconName in
                        Image(iconName)
                            .resizable()
                            .frame(width: 60, height: 60)
                            .padding()
                            .background(selectedIcon == iconName ? Color.blue.opacity(0.3) : Color.clear)
                            .cornerRadius(10)
                            .onTapGesture {
                                selectedIcon = iconName
                                presentationMode.wrappedValue.dismiss()
                            }
                    }
                }
                .padding()
            }
            .navigationTitle("Select Icon")
            .navigationBarItems(trailing: Button("Cancel") {
                presentationMode.wrappedValue.dismiss()
            })
        }
    }
}
