//
//  TokenResponse.swift
//  MyCocoapodsLibrary
//
//  Created by Felipe Ramirez Vargas on 22/3/21.
//

import Foundation

@available(iOS 13.0, *)
class TokenResponse: Decodable, ObservableObject {
   
    @Published var token = ""
    
    enum CodingKeys: CodingKey {
        case token
    }
    
    init() {}
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        token = try container.decode(String.self, forKey: .token)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(token, forKey: .token)
    }
    
}
