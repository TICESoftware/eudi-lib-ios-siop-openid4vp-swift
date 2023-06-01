import XCTest
@testable import SiopOpenID4VP

class ResolvedSiopOpenId4VPRequestDataTests: XCTestCase {
  
  func testIdAndVpTokenDataInitialization() throws {

    let idTokenType: IdTokenType = .attesterSigned
    let presentationDefinition = PresentationExchange.Constants.presentationDefinitionPreview()
    let clientMetaData = try ClientMetaData(metaDataString: TestsConstants.sampleClientMetaData)
    let clientId = "testClientID"
    let nonce = "testNonce"
    let responseMode: ResponseMode = .directPost(responseURI: URL(string: "https://www.example.com")!)
    let state = "testState"
    let scope = "// Replace with an instance of `Scope`"
    
    let tokenData = ResolvedRequestData.IdAndVpTokenData(
      idTokenType: idTokenType,
      presentationDefinition: presentationDefinition,
      clientMetaData: clientMetaData,
      clientId: clientId,
      nonce: nonce,
      responseMode: responseMode,
      state: state,
      scope: scope
    )
    
    XCTAssertEqual(tokenData.idTokenType, idTokenType)
    XCTAssertEqual(tokenData.clientMetaData, clientMetaData)
    XCTAssertEqual(tokenData.clientId, clientId)
    XCTAssertEqual(tokenData.nonce, nonce)
    XCTAssertEqual(tokenData.state, state)
    XCTAssertEqual(tokenData.scope, scope)
  }
  
  func testIdTokenRequestInitialization() {
    let idTokenType = IdTokenType.subjectSigned
    let clientMetaDataSource: ClientMetaDataSource = .fetchByReference(url: URL(string: "https://www.example.com")!)
    let clientIdScheme: ClientIdScheme = .redirectUri
    let clientId = "dummy_client_id"
    let nonce = "dummy_nonce"
    let scope = "dummy_scope"
    let responseMode: ResponseMode = .directPost(responseURI: URL(string: "https://www.example.com")!)
    let state = "dummy_state"
    
    let request = ValidatedSiopOpenId4VPRequest.IdTokenRequest(
      idTokenType: idTokenType,
      clientMetaDataSource: clientMetaDataSource,
      clientIdScheme: clientIdScheme,
      clientId: clientId,
      nonce: nonce,
      scope: scope,
      responseMode: responseMode,
      state: state
    )
    
    XCTAssertEqual(request.idTokenType, idTokenType)
    XCTAssertEqual(request.clientIdScheme, clientIdScheme)
    XCTAssertEqual(request.clientId, clientId)
    XCTAssertEqual(request.nonce, nonce)
    XCTAssertEqual(request.scope, scope)
    XCTAssertEqual(request.state, state)
  }
  
  func testWalletOpenId4VPConfigurationInitialization() {
    let subjectSyntaxTypesSupported: [SubjectSyntaxType] = [.jwkThumbprint]
    let preferredSubjectSyntaxType: SubjectSyntaxType = .jwkThumbprint
    let decentralizedIdentifier: DecentralizedIdentifier = .did("DID:example:12341512#$")
    let idTokenTTL: TimeInterval = 600.0
    let presentationDefinitionUriSupported: Bool = false
    let supportedClientIdScheme: ClientIdScheme = .did
    let vpFormatsSupported: [ClaimFormat] = [.jwtType(.jwt)]
    let knownPresentationDefinitionsPerScope: [String: PresentationDefinition] = [:]

    let walletOpenId4VPConfiguration = WalletOpenId4VPConfiguration(
      subjectSyntaxTypesSupported: subjectSyntaxTypesSupported,
      preferredSubjectSyntaxType: preferredSubjectSyntaxType,
      decentralizedIdentifier: decentralizedIdentifier,
      idTokenTTL: idTokenTTL,
      presentationDefinitionUriSupported: presentationDefinitionUriSupported,
      supportedClientIdScheme: supportedClientIdScheme,
      vpFormatsSupported: vpFormatsSupported,
      knownPresentationDefinitionsPerScope: knownPresentationDefinitionsPerScope
    )
    
    XCTAssertEqual(walletOpenId4VPConfiguration.subjectSyntaxTypesSupported, subjectSyntaxTypesSupported)
    XCTAssertEqual(walletOpenId4VPConfiguration.preferredSubjectSyntaxType, preferredSubjectSyntaxType)
    XCTAssertEqual(walletOpenId4VPConfiguration.decentralizedIdentifier, decentralizedIdentifier)
    XCTAssertEqual(walletOpenId4VPConfiguration.idTokenTTL, idTokenTTL)
    XCTAssertEqual(walletOpenId4VPConfiguration.presentationDefinitionUriSupported, presentationDefinitionUriSupported)
    XCTAssertEqual(walletOpenId4VPConfiguration.supportedClientIdScheme, supportedClientIdScheme)
    XCTAssertEqual(walletOpenId4VPConfiguration.vpFormatsSupported, vpFormatsSupported)
  }
  
  func testSubjectSyntaxTypeInitWithThumbprint() {
    let subjectSyntaxType: SubjectSyntaxType = .jwkThumbprint
    XCTAssert(subjectSyntaxType == .jwkThumbprint)
  }

  func testSubjectSyntaxTypeInitWithDecentralizedIdentifier() {
    let subjectSyntaxType: SubjectSyntaxType = .decentralizedIdentifier
    XCTAssert(subjectSyntaxType == .decentralizedIdentifier)
  }
  
  func testValidDID() {
    let did = DecentralizedIdentifier.did("did:example:123abc")
    XCTAssertTrue(did.isValid())
  }
      
  func testInvalidDID() {
    let did = DecentralizedIdentifier.did("invalid_did")
    XCTAssertFalse(did.isValid())
  }
  
  func testEmptyDID() {
    let did = DecentralizedIdentifier.did("")
    XCTAssertFalse(did.isValid())
  }
  
  func testWhitespaceDID() {
    let did = DecentralizedIdentifier.did("  ")
    XCTAssertFalse(did.isValid())
  }
}