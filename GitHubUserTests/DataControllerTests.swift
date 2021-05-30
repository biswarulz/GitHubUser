//
//  DataControllerTests.swift
//  GitHubUserTests
//
//  Created by Biswajyoti Sahu on 30/05/21.
//

import XCTest
import CoreData
@testable import GitHubUser

class DataControllerTests: XCTestCase {

    private var dataController: DataController?
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        dataController = DataController()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        dataController = nil
    }
    
    private class PersistenContainer: NSPersistentContainer {
        
        override var viewContext: NSManagedObjectContext {
            
            get {
                
                return ManagedObjectContextSpy(concurrencyType: .mainQueueConcurrencyType)
            }
            
            set {
                
            }
        }
    }
    
    private class PersistenContainer1: NSPersistentContainer {
        
        override var viewContext: NSManagedObjectContext {
            
            get {
                
                return ManagedObjectContextSpy1(concurrencyType: .mainQueueConcurrencyType)
            }
            
            set {
                
            }
        }
    }
    
    private class AppDelegateSpy: AppDelegate {
        
        var saveContextCalled = false
        override var persistentContainer: NSPersistentContainer {
            
            get {
                
                let container = PersistenContainer(name: "GitHubUser", managedObjectModel: NSManagedObjectModel())
                container.loadPersistentStores(completionHandler: { (storeDescription, error) in
                    if let error = error as NSError? {

                        fatalError("Unresolved error \(error), \(error.userInfo)")
                    }
                })
                return container
            }
            
            set {
                
            }
        }
        
        override func saveContext() {
            
            saveContextCalled = true
        }
    }
    
    private class AppDelegateSpy1: AppDelegate {
        
        var saveContextCalled = false
        override var persistentContainer: NSPersistentContainer {
            
            get {
                
                let container = PersistenContainer1(name: "GitHubUser", managedObjectModel: NSManagedObjectModel())
                container.loadPersistentStores(completionHandler: { (storeDescription, error) in
                    if let error = error as NSError? {

                        fatalError("Unresolved error \(error), \(error.userInfo)")
                    }
                })
                return container
            }
            
            set {
                
            }
        }
        
        override func saveContext() {
            
            saveContextCalled = true
        }
    }

    private class ManagedObjectContextSpy: NSManagedObjectContext {
        
        var insertCalled = false
        
        override func fetch(_ request: NSFetchRequest<NSFetchRequestResult>) throws -> [Any] {
            
            return []
        }
        
        override func insert(_ object: NSManagedObject) {
            
            insertCalled = true
        }
        
    }
    
    private class ManagedObjectContextSpy1: NSManagedObjectContext {
        
        var insertCalled = false
        
        override func fetch(_ request: NSFetchRequest<NSFetchRequestResult>) throws -> [Any] {
            
            let entity = UserEntity(context: self)
            entity.userName = "test"
            entity.note = "note"
            entity.cachedImage = Data()
            return [entity]
        }
        
        override func insert(_ object: NSManagedObject) {
            
            insertCalled = true
        }
        
    }
    
    func testInsertUser() {
        
        // Given
        let appDelegateSpy = AppDelegateSpy()
        dataController?.appDelegate = appDelegateSpy
        let user = User()
        
        // When
        dataController?.insertUser([user])
        
        // Then
        XCTAssertTrue(appDelegateSpy.saveContextCalled, "Data should be saved")
    }
    
    func testFetchUsers() {
        
        // Given
        let appDelegateSpy = AppDelegateSpy1()
        dataController?.appDelegate = appDelegateSpy
        
        // When
        let users = dataController?.fetchUsers()

        // Then
        XCTAssertTrue(users?.count == 1, "one data should be there")
    }
    
    func testFetchUserDetailBasedOnUsername() {
        
        // Given
        let appDelegateSpy = AppDelegateSpy1()
        dataController?.appDelegate = appDelegateSpy
        
        // When
        let userDetail = dataController?.fetchUserDetailBasedOnUsername("test")

        // Then
        XCTAssertNotNil(userDetail, "userDetail should not be nil")
    }
    
    func testFetchUserDetailBasedOnUsername1() {
        
        // Given
        let appDelegateSpy = AppDelegateSpy()
        dataController?.appDelegate = appDelegateSpy
        
        // When
        let userDetail = dataController?.fetchUserDetailBasedOnUsername("test")

        // Then
        XCTAssertNotNil(userDetail, "userDetail should not be nil")
    }
    
    func testSaveUserDetail() {
        
        // Given
        let appDelegateSpy = AppDelegateSpy1()
        dataController?.appDelegate = appDelegateSpy
        
        // When
        let userDetail = UserDetail()
        dataController?.saveUserDetail(userDetail)

        // Then
        XCTAssertTrue(appDelegateSpy.saveContextCalled, "Data should be saved")
    }

    func testSaveNoteDataForUser() {
        
        // Given
        let appDelegateSpy = AppDelegateSpy1()
        dataController?.appDelegate = appDelegateSpy
        
        // When
        dataController?.saveNoteDataForUser("test", note: "note")

        // Then
        XCTAssertTrue(appDelegateSpy.saveContextCalled, "Data should be saved")
    }
    
    func testGetNoteDataForUser() {
        
        // Given
        let appDelegateSpy = AppDelegateSpy1()
        dataController?.appDelegate = appDelegateSpy
        
        // When
        let note = dataController?.getNoteDataForUser("test")

        // Then
        XCTAssertTrue(note == "note", "Data should be matched")
    }
    
    func testSaveImageToOfflineStorage() {
        
        // Given
        let appDelegateSpy = AppDelegateSpy1()
        dataController?.appDelegate = appDelegateSpy
        
        // When
        dataController?.saveImageToOfflineStorage("test", imageData: Data())

        // Then
        XCTAssertTrue(appDelegateSpy.saveContextCalled, "Data should be saved")
    }
    
    func testGetImageStoredOfflineStorage() {
        
        // Given
        let appDelegateSpy = AppDelegateSpy1()
        dataController?.appDelegate = appDelegateSpy
        
        // When
        let imageData = dataController?.getImageStoredOfflineStorage("test")

        // Then
        XCTAssertNotNil(imageData, "userDetail should not be nil")
    }
}
