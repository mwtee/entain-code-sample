struct NextRacesSectionModel {
    let sectionType: SectionType
    var rows: [NextRacesRowModel]
}

extension NextRacesSectionModel {
    enum SectionType {
        case races
    }
}
