//
//  MockNetworkProvider.swift
//  D2A
//
//  Created by Shibo Tong on 8/12/2025.
//

@testable import D2A
import UIKit

class MockDataProvider: DataProviding {
    
    private var data: Data? = nil
    var urlString: String?
    var dataCallCount = 0
    
    func data(urlString: String) async throws -> Data {
        dataCallCount += 1
        self.urlString = urlString
        guard let data else {
            throw UnitTestError(.dataNotProvided)
        }
        return data
    }
    
    func add(data: Any) {
        self.data = try! JSONSerialization.data(withJSONObject: data)
    }
    
    func add(image: UIImage) {
        self.data = image.pngData()!
    }
}
