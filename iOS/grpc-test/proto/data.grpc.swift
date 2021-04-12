//
// DO NOT EDIT.
//
// Generated by the protocol buffer compiler.
// Source: data/data.proto
//

//
// Copyright 2018, gRPC Authors All rights reserved.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//
import GRPC
import NIO
import SwiftProtobuf


/// Usage: instantiate `Data_StreamServiceClient`, then call methods of this protocol to make API calls.
internal protocol Data_StreamServiceClientProtocol: GRPCClient {
  var serviceName: String { get }
  var interceptors: Data_StreamServiceClientInterceptorFactoryProtocol? { get }

  func fetchResponse(
    _ request: Data_Request,
    callOptions: CallOptions?,
    handler: @escaping (Data_Response) -> Void
  ) -> ServerStreamingCall<Data_Request, Data_Response>
}

extension Data_StreamServiceClientProtocol {
  internal var serviceName: String {
    return "data.StreamService"
  }

  /// Server streaming call to FetchResponse
  ///
  /// - Parameters:
  ///   - request: Request to send to FetchResponse.
  ///   - callOptions: Call options.
  ///   - handler: A closure called when each response is received from the server.
  /// - Returns: A `ServerStreamingCall` with futures for the metadata and status.
  internal func fetchResponse(
    _ request: Data_Request,
    callOptions: CallOptions? = nil,
    handler: @escaping (Data_Response) -> Void
  ) -> ServerStreamingCall<Data_Request, Data_Response> {
    return self.makeServerStreamingCall(
      path: "/data.StreamService/FetchResponse",
      request: request,
      callOptions: callOptions ?? self.defaultCallOptions,
      interceptors: self.interceptors?.makeFetchResponseInterceptors() ?? [],
      handler: handler
    )
  }
}

internal protocol Data_StreamServiceClientInterceptorFactoryProtocol {

  /// - Returns: Interceptors to use when invoking 'fetchResponse'.
  func makeFetchResponseInterceptors() -> [ClientInterceptor<Data_Request, Data_Response>]
}

internal final class Data_StreamServiceClient: Data_StreamServiceClientProtocol {
  internal let channel: GRPCChannel
  internal var defaultCallOptions: CallOptions
  internal var interceptors: Data_StreamServiceClientInterceptorFactoryProtocol?

  /// Creates a client for the data.StreamService service.
  ///
  /// - Parameters:
  ///   - channel: `GRPCChannel` to the service host.
  ///   - defaultCallOptions: Options to use for each service call if the user doesn't provide them.
  ///   - interceptors: A factory providing interceptors for each RPC.
  internal init(
    channel: GRPCChannel,
    defaultCallOptions: CallOptions = CallOptions(),
    interceptors: Data_StreamServiceClientInterceptorFactoryProtocol? = nil
  ) {
    self.channel = channel
    self.defaultCallOptions = defaultCallOptions
    self.interceptors = interceptors
  }
}

/// To build a server, implement a class that conforms to this protocol.
internal protocol Data_StreamServiceProvider: CallHandlerProvider {
  var interceptors: Data_StreamServiceServerInterceptorFactoryProtocol? { get }

  func fetchResponse(request: Data_Request, context: StreamingResponseCallContext<Data_Response>) -> EventLoopFuture<GRPCStatus>
}

extension Data_StreamServiceProvider {
  internal var serviceName: Substring { return "data.StreamService" }

  /// Determines, calls and returns the appropriate request handler, depending on the request's method.
  /// Returns nil for methods not handled by this service.
  internal func handle(
    method name: Substring,
    context: CallHandlerContext
  ) -> GRPCServerHandlerProtocol? {
    switch name {
    case "FetchResponse":
      return ServerStreamingServerHandler(
        context: context,
        requestDeserializer: ProtobufDeserializer<Data_Request>(),
        responseSerializer: ProtobufSerializer<Data_Response>(),
        interceptors: self.interceptors?.makeFetchResponseInterceptors() ?? [],
        userFunction: self.fetchResponse(request:context:)
      )

    default:
      return nil
    }
  }
}

internal protocol Data_StreamServiceServerInterceptorFactoryProtocol {

  /// - Returns: Interceptors to use when handling 'fetchResponse'.
  ///   Defaults to calling `self.makeInterceptors()`.
  func makeFetchResponseInterceptors() -> [ServerInterceptor<Data_Request, Data_Response>]
}
