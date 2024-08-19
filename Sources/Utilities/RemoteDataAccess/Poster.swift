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

public enum PostError: Error {
  case invalidUrl
  case invalidURLResponse
  case invalidResponse(String)
  case unexpectedEmptyAnswer
  case invalidStatusCode(Int, String?)
  case keyNotPresent(String)
  case networkError(Error)

  /**
   Provides a localized description of the post error.

   - Returns: A string describing the post error.
   */
  public var localizedDescription: String {
    switch self {
    case .invalidUrl:
      return "Invalid URL"
    case .networkError(let error):
      return "Network Error: \(error.localizedDescription)"
    case .invalidResponse(let body):
      return "Invalid response: \(body)"
    case .invalidURLResponse:
      return "Invalid url response"
    case .unexpectedEmptyAnswer:
      return "Unexpected empty answer"
    case .keyNotPresent(let body):
      return "Key not present in body: \(body)"
    case .invalidStatusCode(let statusCode, let body):
      return "Invalid status code \(statusCode) with body: \(body)"
    }
  }
}

public protocol Posting {

  var session: Networking { get set }

  /**
   Performs a POST request with the provided URLRequest.

   - Parameters:
      - request: The URLRequest to be used for the POST request.

   - Returns: A Result type with the response data or an error.
   */
  func post<Response: Codable>(request: URLRequest) async -> Result<Response, PostError>

  /**
   Performs a POST request with the provided URLRequest.

   - Parameters:
      - request: The URLRequest to be used for the POST request.

   - Returns: A Result type with a success boolean (based on status code) or an error.
   */
  func check(key: String, request: URLRequest) async -> Result<(String, Bool), PostError>
}

public struct Poster: Posting {

  public var session: Networking

  /**
   Initializes a Poster instance.
   */
  public init(
    session: Networking = URLSession.shared
  ) {
    self.session = session
  }

  /**
   Performs a POST request with the provided URLRequest.

   - Parameters:
      - request: The URLRequest to be used for the POST request.

   - Returns: A Result type with the response data or an error.
   */
  public func post<Response: Codable>(request: URLRequest) async -> Result<Response, PostError> {
    do {
      let (data, _) = try await self.session.data(for: request)
      let object = try JSONDecoder().decode(Response.self, from: data)

      return .success(object)
    } catch let error as NSError {
      if error.domain == NSURLErrorDomain {
        return .failure(.networkError(error))
      } else {
        return .failure(.networkError(error))
      }
    } catch {
      return .failure(.networkError(error))
    }
  }

  /**
   Performs a POST request with the provided URLRequest.

   - Parameters:
      - request: The URLRequest to be used for the POST request.

   - Returns: A Result type with a success boolean (based on status code) or an error.
   */
  public func check(key: String, request: URLRequest) async -> Result<(String, Bool) , PostError> {
    do {

      let (data, response) = try await self.session.data(for: request)

      guard let httpResponse = response as? HTTPURLResponse else {
        throw PostError.invalidURLResponse
      }
      let string = String(data: data, encoding: .utf8)
      guard httpResponse.statusCode.isWithinRange(200...299) else {
        throw PostError.invalidStatusCode(httpResponse.statusCode, string)
      }
      guard let string else {
        throw PostError.unexpectedEmptyAnswer
      }
      guard let dictionary = string.toDictionary() else {
        throw PostError.invalidResponse(string)
      }
      guard let value = dictionary[key] as? String else {
        throw PostError.keyNotPresent(string)
      }
      
      return .success((value, true))
    } catch let error as NSError {
      if error.domain == NSURLErrorDomain {
        return .failure(.networkError(error))
      } else {
        return .failure(.networkError(error))
      }
    } catch {
      return .failure(.networkError(error))
    }
  }
}
