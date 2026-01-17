import SwiftUI

struct RoundedCorner: Shape {
    var radius: CGFloat = 25
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        return Path(path.cgPath)
    }
}
struct LoginView: View {
    var body: some View {
        GeometryReader { geo in
            ZStack(alignment: .top) {

                // 🔴 Full-screen red background
                Color.red
                    .frame(width: geo.size.width, height: geo.size.height)
                    .ignoresSafeArea()

                // 🟢 Green top area
                ZStack(alignment: .topLeading) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Log in to stay on")
                            .font(.largeTitle)
                            .bold()

                        Text("top of your tasks and projects.")
                            .font(.title3)
                    }
                    .foregroundColor(.white)
                    .padding(.top, 60)
                    .padding(.horizontal,24)
                }
                .frame(height: geo.size.height * 0.40)
                .frame(maxWidth: .infinity)
                .background(
                    Image("imgs")
                        .resizable()
                        .scaledToFill()
                        .overlay(
                            Color.black.opacity(0.3)
                       )
                )
                .clipped()



                // ⚪️ White login card
                VStack(spacing: 14) {
                    Text("Login").font(.title2).bold()

                    Text("Don't have an account? Sign Up")
                        .font(.footnote)
                        .foregroundColor(.gray)

                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.gray.opacity(0.15))
                        .frame(height: 48)

                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.gray.opacity(0.15))
                        .frame(height: 48)

                    Button("Login") {}
                        .frame(maxWidth: .infinity)
                        .frame(height: 52)
                        .background(Color.teal)
                        .foregroundColor(.white)
                        .cornerRadius(26)

                    Spacer(minLength: 0)
                }
                .padding(24)
                .frame(width: geo.size.width, height: geo.size.height * 0.70, alignment: .top)
                .background(Color.white)
                .clipShape(RoundedCorner(radius: 28, corners: [.topLeft, .topRight]))
                .shadow(color: .black.opacity(0.12), radius: 10, y: -2)
                .offset(y: geo.size.height * 0.35)
            }
            // ✅ force ZStack to fill screen
            .frame(width: geo.size.width, height: geo.size.height, alignment: .top)
        }
        .ignoresSafeArea()
    }
}



    
   


#Preview {
    LoginView()
}


