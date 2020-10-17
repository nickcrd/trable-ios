//
//    /
//    / This is no longer needed since Socket connections are  handled within the embedded WebView
//    / Keeping this for archive purposes in case we need it again in he future
//    /
//
////
////  TrableSocketManager.swift
////  Trable
////
////  Created by nc on 29.09.20.
////
//
//import Foundation
//import SocketIO
//
//class TrableSocketManager {
//
////    public static let shared = TrableSocketManager()
////    private init() {}
//
//    public var delegate: TrableSocketManagerDelegate?
//
//    public var socketManager: SocketManager?
//
//
//    public func setupSocketConnection(socketUrl: String, apiToken: String) {
//
//        socketManager = SocketManager(socketURL: URL(string: socketUrl)!, config: [.log(true), .compress, .extraHeaders(["Authorization":"Bearer \(apiToken)"])])
//
//        let socket = socketManager!.defaultSocket
//
//        socket.on(clientEvent: .connect) {data, ack in
//            print("socket connected")
//        }
//
//        socket.on("newLocation") { data, ack in
//            print(data)
//        }
//
//        socket.connect()
//
//
//    }
//
//}
