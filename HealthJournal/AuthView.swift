import SwiftUI

struct AuthView: View {
    @Binding var isAuthenticated: Bool
    @State private var animateIcon = false
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [Color.accentColor.opacity(0.15), Color.purple.opacity(0.10)]), startPoint: .topLeading, endPoint: .bottomTrailing)
                .ignoresSafeArea()
            Circle()
                .fill(Color.accentColor.opacity(0.12))
                .frame(width: 260, height: 260)
                .offset(x: 120, y: -180)
            VStack(spacing: 36) {
                Spacer()
                // Animated App Icon
                Image(systemName: "person.crop.circle.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 80, height: 80)
                    .foregroundColor(.accentColor)
                    .shadow(radius: 6)
                    .opacity(animateIcon ? 1 : 0)
                    .animation(.easeIn(duration: 1.0), value: animateIcon)
                    .onAppear { animateIcon = true }
                // Header
                VStack(spacing: 8) {
                    Text("Sign In or Create Account")
                        .font(.title)
                        .fontWeight(.bold)
                        .multilineTextAlignment(.center)
                    Text("Sync your journal and health data securely across devices.")
                        .font(.body)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                }
                // Sign in with Apple
                Button(action: {
                    // Placeholder for Sign in with Apple
                    isAuthenticated = true
                }) {
                    HStack {
                        Image(systemName: "applelogo")
                        Text("Sign in with Apple")
                            .bold()
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.black)
                    .foregroundColor(.white)
                    .cornerRadius(12)
                }
                .frame(maxWidth: 400)
                // Divider with 'or'
                HStack {
                    Rectangle().frame(height: 1).foregroundColor(Color(.separator))
                    Text("or")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Rectangle().frame(height: 1).foregroundColor(Color(.separator))
                }
                // Create Account with Email
                Button(action: {
                    // Placeholder for email sign up
                    isAuthenticated = true
                }) {
                    HStack {
                        Image(systemName: "envelope.fill")
                        Text("Create Account with Email")
                            .bold()
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(LinearGradient(gradient: Gradient(colors: [Color.accentColor, Color.teal]), startPoint: .leading, endPoint: .trailing))
                    .foregroundColor(.white)
                    .cornerRadius(12)
                }
                .frame(maxWidth: 400)
                Spacer()
            }
            .padding()
        }
    }
}

#Preview {
    AuthView(isAuthenticated: .constant(false))
} 
