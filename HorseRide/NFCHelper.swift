//
//  NFCHelper.swift
//  TagReader
//
//  Created by Jameson Quave on 6/16/17.
//  Copyright © 2017 Jameson Quave. All rights reserved.
//

import Foundation
import CoreNFC

class NFCHelper: NSObject, NFCNDEFReaderSessionDelegate {
    var session: NFCNDEFReaderSession? = nil
  var onNFCResult: ((Bool, String, String) -> ())?
  func restartSession() {
    let session = NFCNDEFReaderSession(delegate: self,
                                       queue: nil,
                                       invalidateAfterFirstRead: false)
    session.begin()
  }
  
  // MARK: NFCNDEFReaderSessionDelegate
  func readerSession(_ session: NFCNDEFReaderSession, didInvalidateWithError error: Error) {
    guard let onNFCResult = onNFCResult else { return }
    onNFCResult(false, "", error.localizedDescription)
  }
  
  func readerSession(_ session: NFCNDEFReaderSession, didDetectNDEFs messages: [NFCNDEFMessage]) {
    session.invalidate()
    guard let onNFCResult = onNFCResult else { return }
    for message in messages {
      for record in message.records {
        print("Type name format: \(record.typeNameFormat)")
        let typeString = String(data: record.type, encoding: .utf8)
        print("Type: \(typeString ?? "")")
        print("Identifier: \(record.identifier)")
        print("Payload: \(record.payload)")
        if let resultString = String(data: record.payload, encoding: .utf8) {
          print(resultString)
          onNFCResult(true, typeString ?? "", resultString)
        }
      }
    }
  }

}
