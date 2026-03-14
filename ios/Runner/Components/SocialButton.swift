import SwiftUI

struct SocialButton: View {
    let icon: String
    let color: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Image(systemName: icon)
                .resizable()
                .scaledToFit()
                .frame(width: 32, height: 32)
                .padding(12)
                .foregroundColor(color)
                .background(
                    Circle()
                        .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                )
        }
    }
}

#Preview {
    HStack {
        SocialButton(icon: "g.circle.fill", color: .red) {}
        SocialButton(icon: "apple.logo", color: .black) {}
        SocialButton(icon: "f.circle.fill", color: .blue) {}
    }
    .padding()
}
