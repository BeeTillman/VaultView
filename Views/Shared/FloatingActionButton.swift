// FloatingActionButton.swift

import SwiftUI

struct FloatingActionButton: View {
    @Binding var isExpanded: Bool
    var body: some View {
        ZStack {
            if isExpanded {
                // Background overlay
                Color.black.opacity(0.4)
                    .edgesIgnoringSafeArea(.all)
                    .onTapGesture {
                        withAnimation {
                            isExpanded = false
                        }
                    }

                VStack(spacing: 16) {
                    Spacer()
                    // Balance Entry Button
                    Button(action: {
                        NotificationCenter.default.post(name: NSNotification.Name("AddBalanceEntry"), object: nil)
                        withAnimation {
                            isExpanded = false
                        }
                    }) {
                        HStack {
                            Image(systemName: "plus.circle")
                                .font(.title)
                            Text("Add Balance Entry")
                                .font(.headline)
                        }
                        .padding()
                        .background(Theme.accentColor)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                    }
                    // Account Button
                    Button(action: {
                        NotificationCenter.default.post(name: NSNotification.Name("AddAccount"), object: nil)
                        withAnimation {
                            isExpanded = false
                        }
                    }) {
                        HStack {
                            Image(systemName: "plus.square")
                                .font(.title)
                            Text("Add Account")
                                .font(.headline)
                        }
                        .padding()
                        .background(Theme.accentColor)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                    }
                }
                .transition(.move(edge: .bottom))
                .padding()
            }

            VStack {
                Spacer()
                HStack {
                    Spacer()
                    Button(action: {
                        withAnimation {
                            isExpanded.toggle()
                        }
                    }) {
                        Image(systemName: isExpanded ? "xmark.circle.fill" : "plus.circle.fill")
                            .resizable()
                            .frame(width: 56, height: 56)
                            .foregroundColor(Theme.accentColor)
                            .rotationEffect(.degrees(isExpanded ? 45 : 0))
                            .animation(.spring())
                    }
                    .padding()
                }
            }
        }
    }
}
