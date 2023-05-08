import Foundation

enum ClientConsent {
  case idTokenConsensus
  case vpTokenConsensus(approvedClaims: [Claim])
  case idAndVPTokenConsensus(approvedClaims: [Claim])
  case negative
}