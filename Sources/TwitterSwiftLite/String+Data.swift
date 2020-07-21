import Foundation

extension String {
  var byteArray: [UInt8] {
    return Array(self.utf8)
  }

  var data: Data {
    return Data(self.utf8)
  }

  var percentEscaped: String {
    let allowedCharacterSet = (CharacterSet(charactersIn: "!*'();:@&=+$,/?%#[] ").inverted)
    guard let escapedString = self.addingPercentEncoding(withAllowedCharacters: allowedCharacterSet) else {
      fatalError("Unable to encode string. My apologies.")
    }
    return escapedString
  }
}