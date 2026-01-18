import SwiftUI

struct oundedCorner: Shape {   // ✅ rename to match usage
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

struct SignUp: View {

    @State private var email = ""
    @State private var phoneNum = ""
    @State private var password = ""
    @State private var name = ""
    @State private var alert = ""
    @State private var messageC = 0
    @State private var verifiedPass = ""
    @State private var showPassword = false

    @State private var goToOTP = false

    func showAlert(_ message: String) {
        alert = message
        DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
            alert = ""
        }
    }

    // ✅ Return Bool to decide navigation
    func submitLogin() -> Bool {

        let p1 = password.trimmingCharacters(in: .whitespacesAndNewlines)
        let p2 = verifiedPass.trimmingCharacters(in: .whitespacesAndNewlines)
        let cleanEmail = email.trimmingCharacters(in: .whitespacesAndNewlines)
        let cleanPhone = phoneNum.trimmingCharacters(in: .whitespacesAndNewlines)
        let cleanName = name.trimmingCharacters(in: .whitespacesAndNewlines)

        // Missing fields
        if cleanPhone.isEmpty || cleanName.isEmpty || p1.isEmpty || p2.isEmpty {
            showAlert("Please fill missing fields!")
            messageC = 2
            return false
        }

        // Passwords match
        if p1 != p2 {
            showAlert("Two passwords are not equal")
            messageC = 2
            return false
        }

        // ✅ Success
        showAlert("Sign up Successful")
        messageC = 1
        return true
    }

    var body: some View {
        NavigationStack {
            GeometryReader { geo in
                ZStack(alignment: .top) {

                    Color.red
                        .ignoresSafeArea()

                    // Top image header
                    ZStack(alignment: .topLeading) {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Back in control.")
                                .font(.largeTitle)
                                .bold()

                            Text("    Help is just a tap away.")
                                .font(.title3)
                        }
                        .foregroundColor(.white)
                        .padding(.top, 4)
                        .padding(.horizontal, 4)
                    }
                    .frame(height: geo.size.height * 0.32)
                    .frame(maxWidth: .infinity)
                    .background(
                        Image("imgs")
                            .resizable()
                            .scaledToFill()
                            .overlay(Color.black.opacity(0.4))
                    )
                    .clipped()

                    // White card
                    VStack(spacing: 14) {
                        Text("Join Gharaza").font(.title2).bold()

                        fieldRow(icon: "person.fill") {
                            TextField("Enter full name", text: $name)
                                .textInputAutocapitalization(.words)
                                .disableAutocorrection(true)
                        }

                        fieldRow(icon: "envelope") {
                            TextField("Email (optional)", text: $email)
                                .keyboardType(.emailAddress)
                                .textInputAutocapitalization(.never)
                                .disableAutocorrection(true)
                        }

                        fieldRow(icon: "phone.fill") {
                            TextField("Enter phone number", text: $phoneNum)
                                .keyboardType(.numberPad)
                                .textInputAutocapitalization(.never)
                                .disableAutocorrection(true)
                        }

                        passwordRow(title: "New password", text: $password, showPassword: $showPassword)
                        passwordRow(title: "Confirm password", text: $verifiedPass, showPassword: $showPassword)

                        Text(alert)
                            .foregroundColor(messageC == 2 ? .red : .green)

                        Button {
                            let ok = submitLogin()
                            if ok {
                                goToOTP = true   // ✅ navigate only on success
                            }
                        } label: {
                            RoundedRectangle(cornerRadius: 26)
                                .fill(Color.teal)
                                .frame(maxWidth: .infinity)
                                .frame(height: 52)
                                .overlay(
                                    Text("Create account")
                                        .foregroundColor(.white)
                                        .fontWeight(.semibold)
                                )
                        }

                        Text("Or continue with")
                            .padding(.top, 6)

                        HStack {
                            Button { } label: {
                                HStack(spacing: 8) {
                                    Image(systemName: "applelogo")
                                    Text("Apple").fontWeight(.medium)
                                }
                                .frame(width: 160, height: 50)
                                .background(Color.black)
                                .foregroundColor(.white)
                                .cornerRadius(26)
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
                    .frame(width: geo.size.width, height: geo.size.height * 0.80, alignment: .top)
                    .background(Color.white)
                    .clipShape(RoundedCorner(radius: 39, corners: [.topLeft, .topRight]))
                    .shadow(color: .black.opacity(0.12), radius: 10, y: -2)
                    .offset(y: geo.size.height * 0.27)
                }
                .frame(width: geo.size.width, height: geo.size.height, alignment: .top)
            }
            .ignoresSafeArea()
            .sheet(isPresented: $goToOTP) {
                OTPValidationPage()
                    .presentationDetents([.height(560)])
                    .presentationDragIndicator(.visible)
            }
        }
        
    }

    // MARK: - Small helpers for clean UI
    private func fieldRow<Content: View>(icon: String, @ViewBuilder content: () -> Content) -> some View {
        HStack {
            Image(systemName: icon).foregroundColor(.gray)
            content()
        }
        .padding()
        .frame(height: 48)
        .background(Color.gray.opacity(0.15))
        .cornerRadius(12)
    }

    private func passwordRow(title: String, text: Binding<String>, showPassword: Binding<Bool>) -> some View {
        HStack {
            Image(systemName: "lock.fill").foregroundColor(.gray)

            if showPassword.wrappedValue {
                TextField(title, text: text)
                    .textInputAutocapitalization(.never)
                    .disableAutocorrection(true)
            } else {
                SecureField(title, text: text)
            }

            Button {
                showPassword.wrappedValue.toggle()
            } label: {
                Image(systemName: showPassword.wrappedValue ? "eye.slash" : "eye")
                    .foregroundColor(showPassword.wrappedValue ? .blue : .gray)
            }
        }
        .padding()
        .frame(height: 48)
        .background(Color.gray.opacity(0.15))
        .cornerRadius(12)
    }
}

#Preview {
    SignUp()
}
