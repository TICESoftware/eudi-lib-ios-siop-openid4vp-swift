import Foundation
import PresentationExchange

extension ValidatedSiopOpenId4VPRequest {
  public struct IdAndVpTokenRequest {
    let idTokenType: IdTokenType
    let presentationDefinitionSource: PresentationDefinitionSource
    let clientMetaDataSource: ClientMetaDataSource?
    let clientIdScheme: ClientIdScheme?
    let clientId: String
    let nonce: String
    let scope: Scope?
    let responseMode: ResponseMode?
    let state: String?

    public init(
      idTokenType: IdTokenType,
      presentationDefinitionSource: PresentationDefinitionSource,
      clientMetaDataSource: ClientMetaDataSource?,
      clientIdScheme: ClientIdScheme?,
      clientId: String,
      nonce: String,
      scope: Scope?,
      responseMode: ResponseMode?,
      state: String?
    ) {
      self.idTokenType = idTokenType
      self.presentationDefinitionSource = presentationDefinitionSource
      self.clientMetaDataSource = clientMetaDataSource
      self.clientIdScheme = clientIdScheme
      self.clientId = clientId
      self.nonce = nonce
      self.scope = scope
      self.responseMode = responseMode
      self.state = state
    }
  }
}
