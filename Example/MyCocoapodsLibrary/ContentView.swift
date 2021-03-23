//
//  ContentView.swift
//  MyCocoapodsLibrary_Example
//
//  Created by Felipe Ramirez Vargas on 22/3/21.
//  Copyright © 2021 CocoaPods. All rights reserved.
//

import SwiftUI
import MyCocoapodsLibrary

struct ContentView: View {
    
    @ObservedObject var user = User()
    @ObservedObject var tokenResponse = TokenResponse()
    
    @State var message: String
    @State var tokenText: String
    
    var body: some View {
        VStack(alignment: .center, spacing: 50){
            VStack{
                Text("GET")
                if let dogUrl = URL(string:message){
                    Image(systemName: "square.fill").data(url: dogUrl)
                        .frame(width: 200.0, height: 100.0)
                }
                Button(action: {
                    loadDetails()
                }) {
                    Text("Get a Random Dog")
                }
            }
            VStack{
                Text("POST")
                Button(action: {
                    sendData()
                }, label: {
                    Text("Post Data")
                })
                Text("Token: \(tokenText)")
                Text("*Ejemplo con datos de servidor quemados, los mismos se encuentran en User.swift, si se desea emular un login incorrecto que no retorna un token, se debe modificar el email.")
            }
        }
    }
    
    func loadDetails(){
        guard let url = URL(string: "https://dog.ceo/api/breeds/image/random") else{
            print("The API url is not valid")
            return
        }
        let request = URLRequest(url: url)

        URLSession.shared.dataTask(with: request){data,
            response, error in
            if let data = data {
                if let response = try?
                    JSONDecoder().decode(Response.self,
                                         from: data){
                    DispatchQueue.main.async {
                        self.message = response.message
                    }
                    return
                }
            }
        }.resume()
    }
    
    func sendData(){
        guard let encoded = try? JSONEncoder().encode(user) else {
            print("Failed to encode data")
            return
        }
        let url = URL(string: "https://reqres.in/api/login")!
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        request.httpBody = encoded
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                print("No data in response: \(error?.localizedDescription ?? "Unknown error").")
                return
            }
            if let decodedOrder = try? JSONDecoder().decode(TokenResponse.self, from: data){
                print("Token: \(decodedOrder.token)")
                self.tokenText = decodedOrder.token
               // print("Error: \(decodedOrder.error)")
            } else {
                print("Invalid response from server")
                self.tokenText = "Credenciales incorrectas"
            }
        }.resume()
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(message: "https://images.dog.ceo/breeds/brabancon/n02112706_473.jpg", tokenText: "")
    }
}

extension Image {
    func data(url: URL) -> Self {
        if let data = try? Data(contentsOf: url){
            guard let image = UIImage(data: data) else {
                return Image(systemName: "square.fill")
            }
            return Image(uiImage: image)
                .resizable()
        }
        return self.resizable()
    }
}
