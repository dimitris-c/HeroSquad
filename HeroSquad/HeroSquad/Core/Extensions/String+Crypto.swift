import Foundation
import CommonCrypto

extension String {
    func toMD5() -> String? {
        guard let data = self.data(using: .utf8) else { return nil }
        
        let hash = data.withUnsafeBytes { (bytes: UnsafeRawBufferPointer) -> [UInt8] in
            var hash: [UInt8] = [UInt8](repeating: 0, count: Int(CC_MD5_DIGEST_LENGTH))
            CC_MD5(bytes.baseAddress, CC_LONG(data.count), &hash)
            return hash
        }
        
        return hash.map { String(format: "%02x", $0) }.joined()
    }
}
