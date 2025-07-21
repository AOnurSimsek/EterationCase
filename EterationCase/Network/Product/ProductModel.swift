//
//  ProductModel.swift
//  EterationCase
//
//  Created by Abdullah Onur Şimşek on 21.07.2025.
//

struct ProductModel: Decodable {
    let createdAt: String?
    let name: String?
    let image: String?
    let price: Double?
    let description: String?
    let model: String?
    let brand: String?
    let id: Int?
    
    enum CodingKeys: CodingKey {
        case createdAt
        case name
        case image
        case price
        case description
        case model
        case brand
        case id
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.createdAt = try container.decodeIfPresent(String.self, forKey: .createdAt)
        self.name = try container.decodeIfPresent(String.self, forKey: .name)
        self.image = try container.decodeIfPresent(String.self, forKey: .image)
        self.description = try container.decodeIfPresent(String.self, forKey: .description)
        if let priceString = try container.decodeIfPresent(String.self, forKey: .price),
           let price = Double(priceString) {
            self.price = price
        } else {
            self.price = -1.0
        }
        // It can throw a decoding error, but i think it shouldn't fail the entire product list if only a few items are corrupted
        self.model = try container.decodeIfPresent(String.self, forKey: .model)
        self.brand = try container.decodeIfPresent(String.self, forKey: .brand)
        if let idString = try container.decodeIfPresent(String.self, forKey: .id),
           let id = Int(idString) {
            self.id = id
        } else {
            self.id = -1
        }
        // It can throw a decoding error, but i think it shouldn't fail the entire product list if only a few items are corrupted
    }
    
}

