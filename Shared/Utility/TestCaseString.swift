//
//  TestCaseString.swift
//  D2A
//
//  Created by Shibo Tong on 22/4/2023.
//

import Foundation

struct TestCaseString: Decodable {
    let userid: String
    let username: String
    
    static func load() throws -> Self {
        let testFile = Bundle.main.url(forResource: "testcase", withExtension: "json")
        
        guard let testFile, let fileData = try? Data(contentsOf: testFile) else {
            fatalError("No `testcase.json` file found. Make sure to duplicate `testcase.json.sample` and remove the `.sample` extension.")
        }
        
        return try JSONDecoder().decode(Self.self, from: fileData)
    }
}
