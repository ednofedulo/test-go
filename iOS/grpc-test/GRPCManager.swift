//
//  GRPCManager.swift
//  grpc-test
//
//  Created by Edno Fedulo on 11/04/21.
//

import Foundation
import GRPC
import Logging
import CoreData

class GRPCManager {
    
    
    static func fetchStream(completion: @escaping (_ response: Data_Response) -> Void){
        
        let group = PlatformSupport.makeEventLoopGroup(loopCount: 1)
        var logger = Logger(label: "gRPC", factory: StreamLogHandler.standardOutput(label:))
            logger.logLevel = .debug
        let channel = ClientConnection
            .insecure(group: group)
            .withBackgroundActivityLogger(logger)
            .connect(host: "localhost", port: 50005)
        
        let client = Data_StreamServiceClient(channel: channel)
        
        let data: Data_Request = .with {
            $0.id = 1
        }
        
        _ = client.fetchResponse(data) { (response) in
            DispatchQueue.main.async {
                completion(response)
            }
        }
    }
}
