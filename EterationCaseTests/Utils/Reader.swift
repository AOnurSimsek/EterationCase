//
//  Reader.swift
//  EterationCase
//
//  Created by Abdullah Onur Şimşek on 23.07.2025.
//

import Foundation

final class Reader {
    private init() { }
    
    static func read<T: Decodable>(_ fileName: String, type: T.Type) -> T? {
        guard let file = Bundle(for: Self.self).path(forResource: fileName,
                                                     ofType: "json"),
              let contents = try? String(contentsOfFile: file,
                                         encoding: .utf8)
        else { return nil }
        
        let data = Data(contents.utf8)
        let result = try? JSONDecoder().decode(T.self, from: data)
        return result
    }
    
}
