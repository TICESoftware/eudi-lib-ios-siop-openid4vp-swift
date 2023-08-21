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
import XCTest

@testable import SiopOpenID4VP

final class ClientMetaDataResolverTests: XCTestCase {
  
  var clientMetaDataResolver: ClientMetaDataResolver!
  
  override func setUp() async throws {
    overrideDependencies()
    try await super.setUp()
  }
  
  override func tearDown() {
    DependencyContainer.shared.removeAll()
    self.clientMetaDataResolver = nil
    super.tearDown()
  }
  
  override func setUp() {
    self.clientMetaDataResolver = ClientMetaDataResolver()
  }
  
  func testResolve_WhenSourceIsNil_ThenReturnSuccessWithNilValue() async throws {
    
    let response = await self.clientMetaDataResolver.resolve(source: nil)
    
    switch response {
    case .success(let metaData):
      XCTAssertNil(metaData)
    case .failure(let error):
      XCTFail(error.localizedDescription)
    }
  }
  
  func testResolve_WhenPassByValue_ThenReturnSuccessMetaData() async throws {
    
    let clientMetaData = try ClientMetaData(metaDataString: TestsConstants.sampleClientMetaData)
    let response = await self.clientMetaDataResolver.resolve(source: .passByValue(metaData: clientMetaData))
    
    switch response {
    case .success(let metaData):
      XCTAssertEqual(metaData, clientMetaData)
    case .failure(let error):
      XCTFail(error.localizedDescription)
    }
  }
  
  func testResolve_WhenFetchByReferenceWithInvalidURL_ThenReturnFailure() async throws {
    
    let response = await self.clientMetaDataResolver.resolve(source: .fetchByReference(url: TestsConstants.invalidUrl))
    
    switch response {
    case .success:
      XCTFail("Success is not an option here")
    case .failure(let error):
      XCTAssertEqual(error.localizedDescription, ResolvingError.invalidSource.localizedDescription)
    }
  }
}

private extension ClientMetaDataResolverTests {
  func overrideDependencies() {
    DependencyContainer.shared.register(type: Reporting.self, dependency: {
      Reporter()
    })
  }
}
