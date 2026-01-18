import SwiftUI

struct OTPValidationPage: View {

    @State private var otp = ""
    @State private var didSubmit = false
    @State private var showSuccess = false
    @State private var infoText = "OTP was sent to SMS."

    @State private var resendSeconds = 0
    @State private var timer: Timer? = nil

    var body: some View {
        NavigationView {
            ZStack {

                LinearGradient(
                    colors: [
                        Color(.systemBackground),
                        Color(.secondarySystemBackground)
                    ],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()

                VStack(spacing: 20) {
             
                    // Header (compact)
                    VStack(spacing: 8) {
                        ZStack {
                            Circle()
                                .fill(Color.accentColor.opacity(0.12))
                                .frame(width: 64, height: 64)

                            Image(systemName: "lock.shield")
                                .font(.system(size: 24, weight: .semibold))
                                .foregroundColor(.accentColor)
                        }

                        Text("Verify your number")
                            .font(.system(size: 22, weight: .bold, design: .rounded))

                        Text(infoText)
                            .font(.footnote)
                            .foregroundColor(.secondary)
                    }

                    // OTP Card
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Enter OTP")
                            .font(.headline)

                        otpField

                        if showError {
                            Text("Please enter the 6-digit OTP.")
                                .font(.footnote)
                                .foregroundColor(.red)
                        }
                    }
                    .padding(16)
                    .background(
                        RoundedRectangle(cornerRadius: 18, style: .continuous)
                            .fill(Color(.systemBackground))
                            .shadow(color: .black.opacity(0.05), radius: 12, x: 0, y: 6)
                    )
                    .padding(.horizontal, 20)

                    // Buttons (closer)
                    VStack(spacing: 10) {
                        Button {
                            infoText = "OTP was resent to SMS."
                            didSubmit = false
                            startResendCooldown(seconds: 30)
                        } label: {
                            HStack(spacing: 10) {
                                Image(systemName: "arrow.clockwise")
                                    .font(.system(size: 14, weight: .semibold))

                                Text(resendSeconds > 0 ? "Resend in \(resendSeconds)s" : "Resend OTP")
                                    .font(.system(size: 14, weight: .semibold, design: .rounded))
                            }
                            .foregroundColor(resendSeconds > 0 ? .black : .accentColor)
                            .padding(.horizontal, 18)
                            .padding(.vertical, 10)
                            .background(
                                Capsule()
                                    .fill(
                                        resendSeconds > 0
                                        ? Color.black.opacity(0.08)
                                        : Color.accentColor.opacity(0.12)
                                    )
                            )
                            .overlay(
                                Capsule()
                                    .stroke(
                                        resendSeconds > 0
                                        ? Color.black.opacity(0.25)
                                        : Color.accentColor.opacity(0.25),
                                        lineWidth: 1
                                    )
                            )
                        }
                        .buttonStyle(.plain)
                        .disabled(resendSeconds > 0)
                        .opacity(resendSeconds > 0 ? 0.85 : 1)

                        
                        Button {
                            didSubmit = true
                            if isOTPValid { showSuccess = true }
                        } label: {
                            Text("Submit")
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 14)
                        }
                        .buttonStyle(.borderedProminent)
                        .disabled(!isOTPValid)
                        .opacity(isOTPValid ? 1 : 0.6)

                    }
                    .padding(.horizontal, 20)

                    Spacer(minLength: 10)
                }
                .padding(.top, 16)
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("OTP Verification")
                        .font(.system(size: 16, weight: .semibold))
                }
            }
            .alert("✅ Verified", isPresented: $showSuccess) {
                Button("OK", role: .cancel) { }
            } message: {
                Text("OTP is correct.")
            }
            .onDisappear {
                timer?.invalidate()
                timer = nil
            }
        }
    }

    // MARK: - OTP Field
    private var otpField: some View {
        HStack(spacing: 10) {
            ForEach(0..<6, id: \.self) { i in
                Text(character(at: i))
                    .font(.system(size: 18, weight: .bold, design: .rounded))
                    .frame(width: 42, height: 50)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color(.secondarySystemBackground))
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(borderColor(for: i), lineWidth: 1)
                    )
            }
        }
        .overlay(
            TextField("", text: $otp)
                .keyboardType(.numberPad)
                .textContentType(.oneTimeCode)
                .foregroundColor(.clear)
                .accentColor(.clear)
                .onChange(of: otp) { newValue in
                    otp = String(newValue.filter { $0.isNumber }.prefix(6))
                    didSubmit = false
                }
        )
    }

    private func borderColor(for index: Int) -> Color {
        if showError { return .red.opacity(0.7) }
        if index == otp.count { return .accentColor }
        return .black.opacity(0.08)
    }

    private func character(at index: Int) -> String {
        index < otp.count ? String(Array(otp)[index]) : ""
    }

    private var isOTPValid: Bool { otp.count == 6 }
    private var showError: Bool { didSubmit && !isOTPValid }

    private func startResendCooldown(seconds: Int) {
        resendSeconds = seconds
        timer?.invalidate()

        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { t in
            resendSeconds > 0 ? (resendSeconds -= 1) : t.invalidate()
        }
    }
}

#Preview {
    OTPValidationPage()
}

