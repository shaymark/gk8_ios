//
//  ContentView.swift
//  Shared
//
//  Created by Shay markovich on 22/04/2021.
//

import SwiftUI
import CodeScanner

struct Token: Decodable {
    let value: String
}

struct LoginResponse: Decodable {
    let token: Token
}

class ViewModel: ObservableObject  {
    @Published var username = ""
    @Published var password = ""
    @Published var token: Token?
    @Published var showingAlert = false
    @Published var alertText = ""
    @Published var isShowingScanner = false
    @Published var decripedCode: String?
    
    let deyptionUtil = DecryptionUtil()
    
    func onPressLogin()  {
        loginUser(userName: username, password: password)
    }
    
    func loginUser(userName: String, password: String) {
        guard let url = URL(string: "https://jsonblob.com/api/719e676f-a336-11eb-8efc-d9e3bf61bc9d") else { return }
        
        URLSession.shared.dataTask(with: url){data, response, error in
            guard let data = data else {
                DispatchQueue.main.async {
                    self.showError(message: "invalide user name or password")
                }
                return
            }
            let decodedData = try! JSONDecoder().decode(LoginResponse.self, from: data)
            DispatchQueue.main.async {
                self.token = decodedData.token
                self.isShowingScanner = true
            }
        }.resume()
        
    }
    
    func handleScan(result: Result<String, CodeScannerView.ScanError>) {
       self.isShowingScanner = false
        
        switch result {
        case .success(let code):
            self.decripedCode = deyptionUtil.decrypteEAS256(secretKey: Constns.secretKey, hexText: code)
            if(self.decripedCode == nil) {
                showError(message: "decryped code faild")
            }
        case .failure(let error):
            showError(message: "Scanning failed" + error.localizedDescription)
        }
    }
    
    private func showError(message: String) {
        self.alertText = "invalide user name or password"
        self.showingAlert = true
    }
}

struct ContentView: View {
    @StateObject var viewModel = ViewModel()
    
    var body: some View {
        VStack {
            Text("please enter username and password")
                .padding()
            TextField(
                "User name",
                text: $viewModel.username
            )
            .autocapitalization(.none)
                .disableAutocorrection(true)
                .border(Color(UIColor.separator))
                .padding()
            SecureField(
                "Password",
                text: $viewModel.password
            )
                .border(Color(UIColor.separator))
                .padding()
            
            Button("Login") {
                viewModel.onPressLogin()
            }
            .alert(isPresented: $viewModel.showingAlert) {
                Alert(title: Text(viewModel.alertText), dismissButton: .default(Text("Got it!")))
            }
            .sheet(isPresented: $viewModel.isShowingScanner) {
                CodeScannerView(codeTypes: [.qr], simulatedData: "FAE8A9CBAECFBD34AE6CF9DB33A1C9EF573FA96A4E489E076E76AC6A564172AC5C0F4CC57B1A5FCA839F7B048A12A8C00C9A834D4EBBF516DB01DCB2EFD1100C58B9BE662E1069A3A20BA78FCAFF31B8", completion: viewModel.handleScan)
            }
        }
        
        if let decripedCode = viewModel.decripedCode {
            Text("the code is: \n" + decripedCode)
        }
    
    }
    
    
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
