import SwiftUI

struct HomeView: View {
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                Image(systemName: "house.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 80, height: 80)
                    .foregroundColor(.blue)
                
                Text("Welcome Home!")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                Text("You have successfully logged in to the SwiftUI version.")
                    .font(.body)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                
                Spacer()
            }
            .navigationTitle("Home")
            .navigationBarTitleDisplayMode(.large)
            .padding(.top, 50)
        }
    }
}

#Preview {
    HomeView()
}
