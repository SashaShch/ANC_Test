//
//  ProductsModel.swift
//  ANC_Test
//
//  Created by SashaShch on 22.12.2020.
//

import Foundation

class Product {
    var code: String
    let image: String
    
    init(code: String, image: String) {
        self.code = code
        self.image = image
    }
}

struct Products {
    let products = [Product(code: "", image: "Image-1"),
                    Product(code: "", image: "Image-2"),
                    Product(code: "", image: "Image-3"),
                    Product(code: "", image: "Image-4"),
                    Product(code: "", image: "Image-5"),
                    Product(code: "", image: "Image-6")
    ]
    
    func count() -> Int {
        products.count
    }
}
