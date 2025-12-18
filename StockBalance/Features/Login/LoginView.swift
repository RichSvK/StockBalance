import SwiftUI

struct LoginView: View {
    @StateObject var viewModel: LoginViewModel = LoginViewModel()
    
    enum LoginField {
        case email
        case password
    }
        
    @FocusState var isFocused: LoginField?
    @State var isPasswordVisible: Bool = false
    
    var body: some View {
        VStack {
            Text("Login")
                .font(.title)
                .fontWeight(.bold)
                .padding()
            
            TextField("email", text: $viewModel.email)
                .focused($isFocused, equals: .email)
                .textInputAutocapitalization(.never)
                .keyboardType(.emailAddress)
                .padding()
                .background(Color.secondary.opacity(0.2))
                .clipShape(RoundedRectangle(cornerRadius: 8))
                .keyboardType(.asciiCapable)

            HStack {
                Group {
                    if isPasswordVisible {
                        TextField("Password", text: $viewModel.password)
                    } else {
                        SecureField("Password", text: $viewModel.password)
                    }
                }
                .textContentType(.password)
                .keyboardType(.asciiCapable)
                .autocorrectionDisabled()
                .textInputAutocapitalization(.never)
                .submitLabel(.done)
                .focused($isFocused, equals: .password)
                .padding()
                .background(Color.secondary.opacity(0.2))
                .clipShape(RoundedRectangle(cornerRadius: 8))

                Button(action: {
                    isPasswordVisible.toggle()
                }, label: {
                    Image(systemName: isPasswordVisible ? "eye.slash" : "eye")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 10)
                        .foregroundColor(.gray)
                })
            }
            .frame(height: 40)
            .padding(.top, 5)
            
            Button(action: {
                Task {
                    await viewModel.login()
                }
            }, label: {
                Text("Login")
                    .foregroundStyle(Color.white)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(10)
                    .padding(.top)
            })
            
            Button(action: {
                viewModel.showRegister = true
            }, label: {
                Text("Register Account")
                    .padding()
                    .frame(maxWidth: .infinity)
            })
            
            Spacer()
        }
        .padding()
        .fullScreenCover(isPresented: $viewModel.showRegister) {
            RegisterView(isPresented: $viewModel.showRegister)
        }
        .alert("Notice", isPresented: $viewModel.showAlert) {
            Button("Close", role: .cancel) { }
        } message: {
            Text(viewModel.alertMessage)
        }
    }
}

#Preview{
    LoginView()
}
