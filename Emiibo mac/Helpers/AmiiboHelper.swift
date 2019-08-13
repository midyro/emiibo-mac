//
//  AmiiboHelper.swift
//  Emiibo mac
//
//  Created by midyro on 10/08/2019.
//  Copyright © 2019 midyro. All rights reserved.
//

import Foundation
import Alamofire
import AlamofireImage

class AmiiboHelper {
    static let shared = AmiiboHelper(baseUrl: Constants.BaseUrl)
    
    let baseUrl: String

    init(baseUrl: String) {
        self.baseUrl = baseUrl
    }

    func getAmiibos(completion: @escaping (AmiiboResponse?) -> Void){
        if hasInternetConnection() {
            Alamofire.request(self.baseUrl).response { response in
                
                guard let data = response.data else { return }
                do {
                    let decoder = JSONDecoder()
                    let amiiboResponse = try decoder.decode(AmiiboResponse.self, from: data)

                    completion(amiiboResponse)
                } catch let error {
                    print(error)
                    completion(nil)
                }
            }
        } else {
            let alert = NSAlert()
            alert.messageText = "Unable to get amiibo list"
            alert.informativeText = "Please check your internet connection"
            alert.alertStyle = .critical
            alert.addButton(withTitle: "OK")
            alert.addButton(withTitle: "Cancel")
            alert.runModal()
        }
    }
    
    func generateJson(amiibo: Amiibo, randomUuid: Bool = true, name: String?){
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MMM-dd"
        let date = Date()
        
        let tags: Tag = Tag(randomUuid:randomUuid, uuid: UUID().uuidString)
        let model: Mode = Mode(amiiboId: amiibo.tail)
        let register: Register = Register(name: name ?? amiibo.name, firstWriteDate: dateFormatter.string(from: date), miiCharInfo: "mii-charinfo.bin")
        let common: Common = Common(lastWriteDate: dateFormatter.string(from: date), writeCounter: 0, version: 0)
        let path = FileManager.default.homeDirectoryForCurrentUser.appendingPathComponent("Desktop", isDirectory: true).appendingPathComponent("emiibo", isDirectory: true).appendingPathComponent(name ?? amiibo.name, isDirectory: true)
        
        createDirectory(path: path)
        createJsonFile(name: "tag", content: tags, path: path)
        createJsonFile(name: "model", content: model, path: path)
        createJsonFile(name: "register", content: register, path: path)
        createJsonFile(name: "common", content: common, path: path)
        
    }
    
    private func createJsonFile<T : Encodable>(name: String, content: T, path: URL) {
        do {
            let json = try JSONEncoder().encode(content)
            let jsonString = String(data: json, encoding: .utf8)!
            try jsonString.write(to: path
                    .appendingPathComponent("\(name).json",isDirectory: false), atomically: true, encoding: String.Encoding.utf8)
        } catch let error as NSError{
            print("something went wrong while creating the json file: with error: \(error)")
        }
    }
    
    private func createDirectory(path: URL){
        do {
            try FileManager.default.createDirectory(at: path, withIntermediateDirectories: true)
        } catch let error as NSError{
            print(error)
        }
    }
    
    private func hasInternetConnection() -> Bool {
        return NetworkReachabilityManager()?.isReachable ?? false
    }
    
}

