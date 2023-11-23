//
//  NotificationDatas.swift
//  TwoHoSun
//
//  Created by 235 on 11/23/23.
//

import CoreData

class DataController: ObservableObject {
    let container: NSPersistentContainer
//    @Published var savedDatas: [NotificationModel] = [] {
//        didSet {
//            print(savedDatas)
//        }
//    }
    @Published var todayDatas: [NotificationModel] = []

    @Published var previousDatas: [NotificationModel] = []
    init() {
        container = NSPersistentContainer(name: "DataModel")
        container.loadPersistentStores { description, error in
            if let error = error {
                print("COREDATA\(error.localizedDescription)")
            }
        }
        fetchDatas()
    }

    func save() {
        do {
            try container.viewContext.save()
            fetchDatas()
            print("saved")
        } catch {
            print("not save data")
        }
    }

    func addNotificationData(model: NotiDecodeModel) {
        let notiData =  NotificationModel(context: container.viewContext)
        notiData.authorProfile = model.authorProfile
        notiData.body = model.aps.alert.body
        notiData.date = model.notitime.toDate()
        notiData.postImage = model.postImage
        notiData.postId = Int32(model.postid)
        save()
    }

    func fetchDatas() {
        let request = NSFetchRequest<NotificationModel>(entityName: "NotificationModel")
        do {
            let allSavedDatas = try container.viewContext.fetch(request)
            let today = Calendar.current.startOfDay(for: Date())
            todayDatas = allSavedDatas.filter { data in
                guard let dataDate = data.date else { return false }
                return Calendar.current.isDate(dataDate, inSameDayAs: today)
            }

            previousDatas = allSavedDatas.filter { data in
                guard let dataDate = data.date else { return false }
                return !Calendar.current.isDate(dataDate, inSameDayAs: today)
            }
        } catch let error {
            print("wow \(error)")
        }
    }

    func deleteData(indexSet: IndexSet) {
        guard let index = indexSet.first else {return}
        let entity = todayDatas[index]
        container.viewContext.delete(entity)
        save()
    }
}
