//
//  DecryptionUtil.swift
//  gk8
//
//  Created by Shay markovich on 22/04/2021.
//

import Foundation
import CryptoSwift

struct Constns {
    static let secretKey = "abfc192898ccasfb908afbecacd23fde"
}


class DecryptionUtil: NSObject {
    func decrypteEAS256(secretKey: String, hexText: String)-> String? {
        if let decrypted = try? AES(key: Array(secretKey.utf8), blockMode: ECB(), padding: .noPadding).decrypt(hexText.hexaBytes) {
            return String(bytes: decrypted, encoding: .utf8)
        }
       
        return nil
    }
}

extension StringProtocol {
    var hexaData: Data { .init(hexa) }
    var hexaBytes: [UInt8] { .init(hexa) }
    private var hexa: UnfoldSequence<UInt8, Index> {
        sequence(state: startIndex) { startIndex in
            guard startIndex < self.endIndex else { return nil }
            let endIndex = self.index(startIndex, offsetBy: 2, limitedBy: self.endIndex) ?? self.endIndex
            defer { startIndex = endIndex }
            return UInt8(self[startIndex..<endIndex], radix: 16)
        }
    }
}
