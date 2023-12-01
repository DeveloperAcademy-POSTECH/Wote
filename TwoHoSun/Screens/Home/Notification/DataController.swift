//
//  NotificationDatas.swift
//  TwoHoSun
//
//  Created by 235 on 11/23/23.
//

import CoreData

class DataController: ObservableObject {
    let container: NSPersistentContainer
    @Published var todayDatas: [NotificationModel] = []
    @Published var previousDatas: [NotificationModel] = []
    
    init() {
        container = NSPersistentContainer(name: "DataModel")
        container.loadPersistentStores { _, error in
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
            if allSavedDatas.count > 20 {
                let itemsToRemove = allSavedDatas.prefix(allSavedDatas.count - 20)
                for item in itemsToRemove {
                    container.viewContext.delete(item)
                }
                save()
            }
            let today = Calendar.current.startOfDay(for: Date())
            todayDatas = allSavedDatas.filter { data in
                guard let dataDate = data.date else { return false }
                return Calendar.current.isDate(dataDate, inSameDayAs: today)
            }

            previousDatas = allSavedDatas.filter { data in
                guard let dataDate = data.date else { return false }
                return !Calendar.current.isDate(dataDate, inSameDayAs: today)
            }
            todayDatas.sort { firstData, secondData in
                guard let firstDate = firstData.date, let secondDate = secondData.date else { return false }
                return firstDate < secondDate
            }

            // previousDatas를 날짜 순으로 정렬
            previousDatas.sort { firstData, secondData in
                guard let firstDate = firstData.date, let secondDate = secondData.date else { return false }
                return firstDate < secondDate
            }
        } catch let error {
            print("wow \(error)")
        }
    }

    func deleteData(indexSet: IndexSet, recentData: Bool) {
        guard let index = indexSet.first else {return}
        if recentData {
            let entity = todayDatas[index]
            container.viewContext.delete(entity)
        } else {
            let entity = previousDatas[index]
            container.viewContext.delete(entity)
        }
        save()
    }
}
