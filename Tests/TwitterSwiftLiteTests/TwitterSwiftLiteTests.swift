import XCTest
@testable import TwitterSwiftLite

final class TwitterSwiftLiteTests: XCTestCase {
    func testCreateSignature() {
        let model = TwitterSignatureParameters(
            includeEntities: true,
            oauthConsumerKey:  "xvz1evFS4wEEPTGEFPHBog",
            oauthSignatureMethod: "HMAC-SHA1",
            oauthTimestamp: "1318622958",
            oauthToken: "370773112-GmHxMAgYyLbNEtIKZeRNFsMKPR9EyMZeS9weJAEb",
            oauthVersion: "1.0",
            oauthNonce: "kYjzVBB8Y0ZFabxSWbWovY3uYSQ2pTgmZeNu2VS4cg",
            urlString: "https://api.twitter.com/1.1/statuses/update.json"
        )

        // sample keys not real lol
        let keys = TwitterSwiftLiteKeys(
            consumerKey: "xvz1evFS4wEEPTGEFPHBog",
            consumerSecret: "kAcSOqF21Fu85e7zjz7ZN2U4ZRhfV3WpwPAoE3Z7kBw",
            oauthToken: "370773112-GmHxMAgYyLbNEtIKZeRNFsMKPR9EyMZeS9weJAEb",
            oauthTokenSecret: "LswwdoUaIvS8ltyTt5jkRh4J50vUPVVHtR2YPi5kE"
        )
       
        let tweet = TwitterSwiftLite(keys: keys)
        let test = tweet.makeURLRequest(with: "Hello, Twitter world!", and: model)
        let headers: [String: String]? = test.allHTTPHeaderFields
        XCTAssertTrue((headers?["Authorization"] ?? "").contains("1muIWV0j/aRc1wMbuPAE7sEdTdE=".percentEscaped))
    }

    static var allTests = [
        ("testCreateSignature", testCreateSignature),
    ]
}
