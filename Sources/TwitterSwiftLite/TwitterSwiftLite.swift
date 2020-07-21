import Foundation
import FoundationNetworking

public struct TwitterSignatureParameters {
  let includeEntities: Bool
  let oauthConsumerKey: String
  let oauthSignatureMethod: String
  let oauthTimestamp: String
  let oauthToken: String
  let oauthVersion: String
  let oauthNonce: String
  let urlString: String

  var parameterString: String {
    var string: String = ""
    // string.append("include_entities=true&")
    string.append("oauth_consumer_key=\(oauthConsumerKey.percentEscaped)&")
    string.append("oauth_nonce=\(oauthNonce.percentEscaped)&")
    string.append("oauth_signature_method=\(oauthSignatureMethod.percentEscaped)&")
    string.append("oauth_timestamp=\(oauthTimestamp.percentEscaped)&")
    string.append("oauth_token=\(oauthToken.percentEscaped)&")
    string.append("oauth_version=1.0")
    return string
  }
}

public struct TwitterSwiftLiteKeys {
  let consumerKey: String
  let consumerSecret: String
  let oauthToken: String
  let oauthTokenSecret: String
  
  public init(consumerKey: String, consumerSecret: String, oauthToken: String, oauthTokenSecret: String) {
    self.consumerKey = consumerKey
    self.consumerSecret = consumerSecret
    self.oauthToken = oauthToken
    self.oauthTokenSecret = oauthTokenSecret
  }
  
  var signingKey: String {
    return "\(consumerSecret.percentEscaped)&\(oauthTokenSecret.percentEscaped)"
  }
}

public struct TwitterSwiftLite {
  private let keys: TwitterSwiftLiteKeys

  public init(keys: TwitterSwiftLiteKeys? = nil) {
    guard let keys = keys else {
      fatalError("Need keys to use API")
    }

    self.keys = keys
  }

  public func postTweet(_ message: String) {
    let model = TwitterSignatureParameters(
      includeEntities: true,
      oauthConsumerKey:  self.keys.consumerKey,
      oauthSignatureMethod: "HMAC-SHA1",
      oauthTimestamp: "\(Int(Date().timeIntervalSince1970))",
      oauthToken: self.keys.oauthToken,
      oauthVersion: "1.0",
      oauthNonce: "\(UUID().uuidString)",
      urlString: "https://api.twitter.com/1.1/statuses/update.json"
    )

    let request = makeURLRequest(with: message, and: model)
    Requests.post(urlRequest: request)
  }

  public func makeURLRequest(with message: String, and model: TwitterSignatureParameters) -> URLRequest {
    guard let url = URL(string: model.urlString) else {
      fatalError("Unable to construct URL")
    }

    let headers = makeHeaders(with: message, and: model)
    let data = "status=\(message.percentEscaped)".data
    var urlRequest = URLRequest(url: url)
    urlRequest.httpMethod = "POST"
    urlRequest.allHTTPHeaderFields = headers
    urlRequest.httpBody = data
    return urlRequest
  }
  
  private func makeHeaders(with message: String, and model: TwitterSignatureParameters) -> [String: String] {
    let parameterString = "\(model.parameterString)&status=\(message.percentEscaped)"
    let signatureBaseString = "POST&\(model.urlString.percentEscaped)&\(parameterString.percentEscaped)"
    let signature = calculateSignature(with: signatureBaseString)
    let oauthString = makeOAuthHeader(with: signature, and: model)

    return [
      "User-Agent": "Linux Swifty Pi",
      "Authorization": oauthString,
      "Content-Type": "application/x-www-form-urlencoded"
    ]
  }

  private func calculateSignature(with string: String) -> String {
    let dataHash = HMAC.sha1(key: keys.signingKey.data, message: string.data)
    guard let signatureString = dataHash?.base64EncodedString() else {
      fatalError("Error making signature")
    }

    return signatureString
  }

  private func makeOAuthHeader(with signature: String, and model: TwitterSignatureParameters) -> String {
    var output = "OAuth " 
    output.append("oauth_consumer_key=\"\(model.oauthConsumerKey.percentEscaped)\",")
    output.append("oauth_token=\"\(model.oauthToken.percentEscaped)\",")
    output.append("oauth_signature_method=\"HMAC-SHA1\",")
    output.append("oauth_timestamp=\"\(model.oauthTimestamp.percentEscaped)\",")
    output.append("oauth_nonce=\"\(model.oauthNonce.percentEscaped)\",")
    output.append("oauth_version=\"1.0\",")
    output.append("oauth_signature=\"\(signature.percentEscaped)\"")
    return output
  }
}
