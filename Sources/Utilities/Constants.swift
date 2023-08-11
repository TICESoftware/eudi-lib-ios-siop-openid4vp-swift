/*
 * Copyright (c) 2023 European Commission
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
import Foundation
import CryptoKit
import PresentationExchange

public struct Constants {
  public static let CLIENT_ID = "client_id"
  public static let NONCE = "nonce"
  public static let SCOPE = "scope"
  public static let STATE = "state"
  public static let HTTPS = "https"
  public static let PRESENTATION_DEFINITION = "presentation_definition"
  public static let PRESENTATION_DEFINITION_URI = "presentation_definition_uri"

  public static func testClientMetaData() -> ClientMetaData {
    .init(
      jwksUri: "https://jwks.uri",
      jwks: "{\"name\":\"Jane Doe\"",
      idTokenSignedResponseAlg: ".idTokenSignedResponseAlg",
      idTokenEncryptedResponseAlg: ".idTokenEncryptedResponseAlg",
      idTokenEncryptedResponseEnc: ".idTokenEncryptedResponseEnc",
      subjectSyntaxTypesSupported: [],
      authorizationSignedResponseAlg: ".authorizationSignedResponseAlg",
      authorizationEncryptedResponseAlg: ".authorizationEncryptedResponseAlg",
      authorizationEncryptedResponseEnc: ".authorizationEncryptedResponseEnc"
    )
  }

  public static let testClientId = "https%3A%2F%2Fclient.example.org%2Fcb"
  public static let testNonce = "0S6_WzA2Mj"
  public static let testScope = "one two three"

  public static let testResponseMode: ResponseMode = .directPost(responseURI: URL(string: "https://respond.here")!)

  static func generateRandomJWT() -> String {
    // Define the header
    let header = #"{"alg":"HS256","typ":"JWT"}"#

    // Define the claims
    let claims = #"{"iss":"issuer","sub":"subject","aud":["audience"],"exp":1679911600,"iat":1657753200}"#

    // Create the base64url-encoded segments
    let encodedHeader = header.base64urlEncode
    let encodedClaims = claims.base64urlEncode

    // Concatenate the header and claims segments with a dot separator
    let encodedToken = "\(encodedHeader).\(encodedClaims)"

    // Define the secret key for signing
    let secretKey = "your_secret_key".data(using: .utf8)!

    // Sign the token with HMAC-SHA256
    let signature = HMAC<SHA256>.authenticationCode(for: Data(encodedToken.utf8), using: SymmetricKey(data: secretKey))

    // Base64url-encode the signature
    let encodedSignature = Data(signature).base64EncodedString()

    // Concatenate the encoded token and signature with a dot separator
    let jwt = "\(encodedToken).\(encodedSignature)"

    return jwt
  }

  static func generateRandomBase64String() -> String? {
    let randomData = Data.randomData(length: 32)
    let base64URL = randomData.base64URLEncodedString()
    return base64URL
  }
}
