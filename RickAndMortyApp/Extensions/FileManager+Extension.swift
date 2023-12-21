//
//  FileManager+Extension.swift
//  RickAndMortyApp
//
//  Created by Tixon Markin on 21.12.2023.
//

import Foundation

extension FileManager {
    var imagesDir: URL {
        let userDomain = FileManager.default.urls(for: .documentDirectory, 
                                                  in: .userDomainMask).first!
        let imagesDir = FileManager.default.getDir(named: "CharacterImages", 
                                                   in: userDomain)
        
        return imagesDir
    }
    
    
    
    private func getDir(named dirName: String, in rootDir: URL) -> URL {
        var dirURL: URL!
        
        if let newDirURL = URL(string: rootDir.absoluteString + dirName + "/") {
            
            if FileManager.default.directoryExists(atUrl: newDirURL) {
                print("directory named \(dirName) already exists")
                dirURL = newDirURL
                
            } else {
                do {
                    try FileManager.default.createDirectory(at: newDirURL, 
                                                            withIntermediateDirectories: true)
                    print("duccessfully created \(dirName)")
                    dirURL = newDirURL
                } catch {
                    print("An error occured while creating \(dirName)")
                }
            }
            
        } else {
            dirURL = rootDir
            print("Can not create directory \(dirName)")
        }
        
        return dirURL
    }
    
    private func directoryExists(atUrl url: URL) -> Bool {
        var isDirectory: ObjCBool = false
        let exists = self.fileExists(atPath: url.path, 
                                     isDirectory:&isDirectory)
        return exists && isDirectory.boolValue
    }
}
