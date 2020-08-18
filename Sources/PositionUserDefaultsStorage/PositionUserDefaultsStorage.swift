//
//  PositionUserDefaultsStorage.swift
//  PositionUserDefaultsStorage
//
//

import Foundation
import GithubJobServices

final class PositionUserDefaultsStorage: PositionStorageManager {
    
    private struct Position: PositionDTO, Codable {
        var id: String
        var type: String
        var url: String
        var company: String
        var companyUrl: String
        var location: String
        var title: String
        var description: String
        var howToApply: String
        var companyLogo: String
        
        init(dto: PositionDTO) {
               id = dto.id
               type = dto.type
               url = dto.url
               company = dto.company
               companyUrl = dto.companyUrl
               location = dto.location
               title = dto.title
               description = dto.description
               howToApply = dto.howToApply
               companyLogo = dto.companyLogo
           }
    }
    
    private let store: UserDefaults = UserDefaults.standard
    private let key = "positions"
    
    var allPositions: [PositionDTO] {
        if let positionsData = store.data(forKey: key),
            let positions = try? JSONDecoder().decode([Position].self, from: positionsData) {
            return positions
        }
        return []
    }
    
    func getPosition(id: String) -> PositionDTO? {
        allPositions.first{ $0.id == id }
    }
    
    func findPositions(searchText: String) -> [PositionDTO] {
        allPositions.filter{ $0.title.contains(searchText) }
    }
    
    func filterPositions(by filter: PositionFilter) -> [PositionDTO] {
        return allPositions.filter {
            $0.company == filter.company ||
            $0.title == filter.title ||
            $0.location == filter.location
        }
    }
    
    func save(positions: [PositionDTO]) {
        DispatchQueue.global().async {
            if let encoded = try? JSONEncoder().encode(positions.map { Position(dto: $0) }) {
                self.store.set(encoded, forKey: self.key)
            }
        }
    }
}
