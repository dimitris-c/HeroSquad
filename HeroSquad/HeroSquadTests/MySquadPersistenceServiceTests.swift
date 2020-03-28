//
//  NetworkingClientTests.swift
//  HeroSquadTests
//
//  Created by Dimitrios Chatzieleftheriou on 24/03/2020.
//  Copyright © 2020 Decimal Digital. All rights reserved.
//

import Foundation
import RealmSwift
import XCTest
@testable import HeroSquad

class MySquadPersistenceServiceTests: XCTestCase {

    override func setUp() {
        Realm.Configuration.defaultConfiguration.inMemoryIdentifier = self.name
    }
    
    func test_WritesACharacter_InDatabase() {
        
        let sut = MySquadPersistenceService()
        
        let character = Character(id: 1,
                                  name: "Test",
                                  description: "",
                                  thumbnail: MarvelImage(path: "", extension: ""),
                                  comics: ComicList(available: 0, returned: 0, collectionURI: "", items: []))
        
        sut.add(character: character)
        
        let realm = try! Realm()
        let dbCharacter = realm.objects(RLMCharacter.self).last
        XCTAssertNotNil(dbCharacter)
        
    }
    
    
    func test_RemovesACharacter_FromDatabase() {
        
        let sut = MySquadPersistenceService()
        
        let character = Character(id: 1,
                                  name: "Test",
                                  description: "",
                                  thumbnail: MarvelImage(path: "", extension: ""),
                                  comics: ComicList(available: 0, returned: 0, collectionURI: "", items: []))
        
        sut.add(character: character)
        
        let realm = try! Realm()
        let dbCharacter = realm.objects(RLMCharacter.self).last
        XCTAssertNotNil(dbCharacter)
        
        sut.remove(character: dbCharacter!)
        
        let objectsCount = realm.objects(RLMCharacter.self).count
        XCTAssertEqual(objectsCount, 0)
        
    }
    
    func test_CanRetrieveObjects_FromDatabase() {
        let sut = MySquadPersistenceService()
        
        let character = Character(id: 1,
                                  name: "Test",
                                  description: "",
                                  thumbnail: MarvelImage(path: "", extension: ""),
                                  comics: ComicList(available: 0, returned: 0, collectionURI: "", items: []))
        
        sut.add(character: character)
        
        let results = sut.mySquad()
        XCTAssertEqual(results.count, 1)
    }
}
    
