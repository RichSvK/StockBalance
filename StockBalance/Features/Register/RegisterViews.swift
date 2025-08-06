import SwiftUI

struct RegisterView: View {
    @Binding var isPresented: Bool
    @StateObject private var viewModel = RegisterViewModel()

    enum RegisterField {
        case email
        case password
        case username
    }

    @FocusState private var isFocused: RegisterField?
    @State private var isPasswordVisible: Bool = false

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Button(action: {
                    isPresented = false
                }) {
                    Image(systemName: "xmark")
                        .foregroundColor(.red)
                        .font(.system(size: 20))
                }
                Spacer()
            }

            Text("Register")
                .font(.headline)
                .padding(.bottom, 8)
                .frame(maxWidth: .infinity)
                .multilineTextAlignment(.center)

            TextField("Email", text: $viewModel.email)
                .focused($isFocused, equals: .email)
                .textInputAutocapitalization(.never)
                .keyboardType(.emailAddress)
                .padding()
                .background(Color.secondary.opacity(0.2))
                .clipShape(RoundedRectangle(cornerRadius: 8))

            HStack {
                Group {
                    if isPasswordVisible {
                        TextField("Password", text: $viewModel.password)
                    } else {
                        SecureField("Password", text: $viewModel.password)
                    }
                }
                .focused($isFocused, equals: .password)
                .textInputAutocapitalization(.never)
                .padding()
                .background(Color.secondary.opacity(0.2))
                .clipShape(RoundedRectangle(cornerRadius: 8))

                Button(action: {
                    isPasswordVisible.toggle()
                }) {
                    Image(systemName: isPasswordVisible ? "eye.slash" : "eye")
                        .foregroundColor(.gray)
                }
            }

            TextField("Username", text: $viewModel.username)
                .focused($isFocused, equals: .username)
                .padding()
                .background(Color.secondary.opacity(0.2))
                .clipShape(RoundedRectangle(cornerRadius: 8))

            Button("Register") {
                viewModel.register()
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color.blue)
            .foregroundColor(.white)
            .clipShape(RoundedRectangle(cornerRadius: 8))

            Spacer()
        }
        .padding()
        .onChange(of: viewModel.registrationSuccess) { item in
            if viewModel.registrationSuccess {
                isPresented = false
            }
        }
        .alert("Error", isPresented: $viewModel.showAlert) {
            Button("Close", role: .cancel) {}
        } message: {
            Text(viewModel.errorMessage)
        }
    }
}
