//
//  User.swift
//  MyCocoapodsLibrary
//
//  Created by Felipe Ramirez Vargas on 22/3/21.
//

import Foundation

@available(iOS 13.0, *)
class User: ObservableObject, Codable {
    
    /**Para el ejemplo, se usan estos dos valores quemados ya que son los que existen en el servidor de reqres (API de pruebas para peticiones POST),
     si se desea simular un login incorrecto basta con modificar alguno de estos. Especificamente el email, la contraseña solo se valida que no esté nula*/
    @Published var email = "eve.holt@reqres.in" /*eve.holt@reqres.in*/
    @Published var password = "cityslicka" /*cityslicka*/
    @Published var token = ""
    @Published var error = ""
    
    enum CodingKeys: CodingKey {
        case email, password, token, error
    }
    
    init() {}
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        email = try container.decode(String.self, forKey: .email)
        password = try container.decode(String.self, forKey: .password)
        token = try container.decode(String.self, forKey: .token)
        error = try container.decode(String.self, forKey: .error)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(email, forKey: .email)
        try container.encode(password, forKey: .password)
        try container.encode(token, forKey: .token)
        try container.encode(error, forKey: .error)
    }
    
}
