//
//  Persistence.swift
//  SwiftUICalendar
//
//  Created by 이윤지 on 2023/04/12.
//

import CoreData

struct PersistenceController {
    static let shared = PersistenceController()
    let databaseName = "SwiftUICalendar.sqlite"
    
    var oldStoredURL: URL {
        let directory = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).first!
        return directory.appendingPathComponent(databaseName)
    }
    
    var sharedStoreURL: URL{
        let container = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.com.acasia.SwiftUICalendar")!
        return container.appendingPathComponent(databaseName)
    }

    static var preview: PersistenceController = {
        let result = PersistenceController(inMemory: true)
        let viewContext = result.container.viewContext
        let startDate = Calendar.current.dateInterval(of: .month, for: .now)!.start
        for dayOffset in 0..<30 {
            let newDay = Day(context: viewContext)
           newDay.date = Calendar.current.date(byAdding: .day, value: dayOffset, to: startDate)

            newDay.didStudy = Bool.random()
        }
        do {
            try viewContext.save()
        } catch {
            
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        return result
    }()
    let container: NSPersistentContainer

    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "SwiftUICalendar")
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        } else if !FileManager.default.fileExists(atPath: oldStoredURL.path){
            print("⛄️oldStore은 더 이상 탈출할 수 없습니다. 새로운 shared URL을 이용해주세요.")
            container.persistentStoreDescriptions.first!.url = sharedStoreURL
        }
        print("🍎container URL = \(container.persistentStoreDescriptions.first!.url!)")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
            
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        migrateStore(for: container)
        container.viewContext.automaticallyMergesChangesFromParent = true
    }
    
    func migrateStore(for container: NSPersistentContainer) {
        print("➡️ migrateStore으로 이동했습니다.")
        let coordinator = container.persistentStoreCoordinator
        
        guard let oldStore = coordinator.persistentStore(for: oldStoredURL) else {return}
        print("🛡️oldStore은 더 이상 남아있을 수 없습니다.")
        do{
           let _ = try coordinator.migratePersistentStore(oldStore, to: sharedStoreURL, type: .sqlite)
            print("🏁이동을 성공했습니다. 이사완료!")
        } catch{
            fatalError("이동된 shared store 은 사용할 수 없습니다.")
        }
        
        do{
            try FileManager.default.removeItem(at: oldStoredURL)
            print("🗑️oldStore은 삭제했습니다.")
        } catch{
            print("oldStoredms 삭제되어 사용할 수 없습니다.")
        }
    }
}
