#if !os(macOS)

import Foundation
import CCryptoBoringSSL

// this is an inaccurate port of SecRandomCopyBytes.

public typealias SecRandomRef = Int
public let kSecRandomDefault: SecRandomRef = 0
public let errSecParam = -50
public let errSecSuccess = 0

public func SecRandomCopyBytes(_ rnd: SecRandomRef, _ count: size_t, _ bytes: UnsafeMutableRawPointer) -> Int 
{
    CCryptoBoringSSL_RAND_bytes(bytes, count)
	return errSecSuccess;
}

#endif
