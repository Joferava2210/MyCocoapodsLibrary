//
//  DataExample.swift
//  MyCocoapodsLibrary
//
//  Created by Felipe Ramirez Vargas on 22/3/21.
//

import Foundation

@available(iOS 13.0, *)
public class DataExample {
    
    var user = User()
    var tokenResponse = TokenResponse()
    
    var message = ""
    var tokenText = ""
    
    public init(){}
    
    public func loadDetails(){
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
    
    public func sendData(){
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
