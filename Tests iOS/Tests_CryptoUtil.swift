//
//  Tests_CryptoUtil.swift
//  Tests iOS
//
//  Created by Shay markovich on 22/04/2021.
//

import XCTest

class Tests_CryptoUtil: XCTestCase {

    let decryptionUtil = DecryptionUtil()
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testDecrypteEAS256() throws {
        
        let secretKey = "abfc192898ccasfb908afbecacd23fde"
        let hexText = "FAE8A9CBAECFBD34AE6CF9DB33A1C9EF573FA96A4E489E076E76AC6A564172AC5C0F4CC57B1A5FCA839F7B048A12A8C00C9A834D4EBBF516DB01DCB2EFD1100C58B9BE662E1069A3A20BA78FCAFF31B8"
        
        let result = decryptionUtil.decrypteEAS256(secretKey: secretKey, hexText: hexText)
        
        XCTAssertTrue(result ==  "It’s only after we’ve lost everything that we’re free to do anything.\u{5}\u{5}\u{5}\u{5}\u{5}")
        
        
    }

}
