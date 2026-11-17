import SwiftUI

struct SplashView: View {
    @StateObject private var viewModel = JournalViewModel()
    @State private var isActive = false
    
    var body: some View {
        if isActive {
            MainView()
                .environmentObject(viewModel)
        } else {
            ZStack {
                Color.appBackground.ignoresSafeArea()
                
                VStack(spacing: 16) {
                    Image("firstp")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 140, height: 140)
                    
                    Text("Journali")
                        .font(.system(size: 34, weight: .bold))
                        .foregroundColor(.appTextPrimary)
                    
                    Text("Your thoughts, your story")
                        .font(.system(size: 16))
                        .foregroundColor(.appTextSecondary)
                }
            }
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                    withAnimation {
                        isActive = true
                    }
                }
            }
        }
    }
}
