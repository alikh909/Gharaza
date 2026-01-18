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
    @State private var email = ""
    @State private var phoneNum = ""
    @State private var password = ""
    @State private var alert = ""
    @State private var MassageC = 0
    @State private var showPassword = false
    @State private var goToSignUp = false

    func submitLogin() {
        if (!email.isEmpty || !phoneNum.isEmpty) && !password.isEmpty {
            print("✅ All fields filled")
            print("Email: \(email)")
            print("Phone: \(phoneNum)")
            print("Password: \(password)")
            alert = "Sign in Successful"
            MassageC = 1
            
        } else {
            print("❌ Please fill all fields")
            alert = "Please fill missing fields!"
            MassageC = 2
        }
    }
    
    var body: some View {
        NavigationStack {
            GeometryReader { geo in
                ZStack(alignment: .top) {
                    
                    // 🔴 Full-screen red background
                    Color.red
                        .frame(width: geo.size.width, height: geo.size.height)
                        .ignoresSafeArea()
                    
                    // 🟢 Green top area
                    ZStack(alignment: .topLeading) {
                        VStack(alignment: .leading, spacing: 8) {
                            
                            Text("Back on the road.")
                                .font(.largeTitle)
                                .bold()
                            
                            Text("Help is always within reach")
                                .font(.title3)
                        }
                        .foregroundColor(.white)
                        .padding(.top, 10)
                        .padding(.horizontal,24)
                    }
                    //Play with picture
                    .frame(height: geo.size.height * 0.49)
                    .frame(maxWidth: .infinity)
                    .background(
                        Image("imgs")
                            .resizable()
                            .scaledToFill()
                            .overlay(
                                Color.black.opacity(0.4)
                            )
                    )
                    .clipped()
                    
                    
                    
                    // ⚪️ White login card
                    VStack(spacing: 14) {
                        Text("Login").font(.title2).bold()
                        HStack{
                            Text("create new account?")
                                .font(.footnote)
                                .foregroundColor(.gray)
                            NavigationLink("Create account"){
                                SignUp()
                            }
                        }
                        HStack {
                            Image(systemName: "envelope")
                                .foregroundColor(.gray)
                            
                            TextField("Enter your email or phone", text: $email)
                                .keyboardType(.emailAddress)
                                .textContentType(.emailAddress)
                                .autocapitalization(.none)
                                .disableAutocorrection(true)
                        }
                        .padding()
                        .frame(height: 48)
                        .background(Color.gray.opacity(0.15))
                        .cornerRadius(12)
                        HStack {
                            Image(systemName: "lock.fill")
                                .foregroundColor(.gray)
                            
                            if showPassword {
                                TextField("Enter your password", text: $password)
                            } else {
                                SecureField("Enter your password", text: $password)
                            }
                            
                            Button {
                                showPassword.toggle()
                            } label: {
                                Image(systemName: showPassword ? "eye.slash" : "eye")
                                    .foregroundColor(showPassword == true ? .blue : .gray)
                            }
                            
                        }
                        .padding()
                        .frame(height: 48)
                        .background(Color.gray.opacity(0.15))
                        .cornerRadius(12)
                        
                        
                        Button("Forgot password?") {
                            // action
                        }
                        .frame(maxWidth: .infinity, alignment: .trailing)
                        
                        Text(alert)
                            .foregroundColor(MassageC == 2 ? .red : .green)
                        Button(action: {
                            submitLogin()
                        }) {
                            ZStack {
                                // Background
                                RoundedRectangle(cornerRadius: 26)
                                    .fill(Color.teal)
                                
                                // Content
                                Text("Login")
                                    .foregroundColor(.white)
                                    .fontWeight(.semibold)
                            }
                            .frame(maxWidth : .infinity)
                            .frame(height: 52)
                        }
                        
                        
                        
                        
                        Text("Or countine with")
                            .padding()
                        HStack{
                            Button(action: {
                                // Google login action
                            }) {
                                HStack(spacing: 8) {
                                    Image(systemName: "applelogo")
                                        .font(.system(size: 18, weight: .medium))
                                    
                                    Text("Apple")
                                        .fontWeight(.medium)
                                }
                                .frame(width: 160, height: 50)
                                .background(Color.black)
                                .foregroundColor(.white)
                                .cornerRadius(26)
                                .foregroundColor(.black)
                            }
                            Button(action: {
                                // Google login action
                            }) {
                                HStack(spacing: 8) {
                                    Image("google")
                                        .resizable()
                                        .scaledToFit()        // keeps aspect ratio
                                        .frame(width: 18, height: 18)
                                    
                                    
                                    Text("Google")
                                        .fontWeight(.medium)
                                }
                                .frame(width: 160, height: 50)
                                .background(
                                    Color.white
                                        .overlay(
                                            Color.black.opacity(0.10)   // adjust opacity
                                        )
                                )
                                .cornerRadius(26)
                                .foregroundColor(.black)
                            }
                            
                        }
                        Spacer(minLength: 0)
                        
                    }
                    .padding(24)
                    .frame(width: geo.size.width, height: geo.size.height * 0.70, alignment: .top)
                    .background(Color.white)
                    .clipShape(RoundedCorner(radius: 28, corners: [.topLeft, .topRight]))
                    .shadow(color: .black.opacity(0.12), radius: 10, y: -2)
                    .offset(y: geo.size.height * 0.40)
                    
                    
                }
                // ✅ force ZStack to fill screen
                .frame(width: geo.size.width, height: geo.size.height, alignment: .top)
                
            }
            .ignoresSafeArea()
        }
    }
}



    
   


#Preview {
    LoginView()
}


