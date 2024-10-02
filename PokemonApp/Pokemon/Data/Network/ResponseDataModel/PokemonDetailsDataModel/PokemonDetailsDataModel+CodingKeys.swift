import Foundation

extension PokemonDetailsDataModel {
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: AnyCodingKey.self)
//        id = try container.decode(
//            Int.self,
//            forKey: .init(stringValue: .KeyName.id)
//        )
        name = try container.decode(
            String.self,
            forKey: .init(stringValue: .KeyName.name)
        )
        height = try container.decode(
            Int.self,
            forKey: .init(stringValue: .KeyName.heightKey)
        )
        weight = try container.decode(
            Int.self,
            forKey: .init(stringValue: .KeyName.weightKey)
        )

        let spritesContainer = try container.nestedContainer(
            keyedBy: AnyCodingKey.self,
            forKey: .init(stringValue: .KeyName.spritesContainerKey)
        )
        imagePath = try spritesContainer.decode(
            String.self,
            forKey: .init(stringValue: .KeyName.imageKey)
        )

        var typesContainer = try container.nestedUnkeyedContainer(forKey: .init(stringValue: .KeyName.typeContainerKey))
        let slotContainer = try typesContainer.nestedContainer(keyedBy: AnyCodingKey.TypesCodingKeys.self)
        let typeContainer = try slotContainer.nestedContainer(keyedBy: AnyCodingKey.TypesCodingKeys.TypeNameKeys.self,
                                                              forKey: .type)
        type = try typeContainer.decode(
            String.self,
            forKey: .name
        )
    }
}

extension PokemonDetailsDataModel: Decodable {
    struct AnyCodingKey: CodingKey {
        var stringValue: String
        var intValue: Int?
        init(_ codingKey: CodingKey) {
            stringValue = codingKey.stringValue
            intValue = codingKey.intValue
        }

        init(stringValue: String) {
            self.stringValue = stringValue
            intValue = nil
        }

        init(intValue: Int) {
            stringValue = String(intValue)
            self.intValue = intValue
        }

        enum TypesCodingKeys: String, CodingKey {
            case type

            enum TypeNameKeys: String, CodingKey {
                case name
            }
        }
    }
}

private extension String {
    enum KeyName {
//        static let id = "id"
        static let name = "name"
        static let heightKey = "height"
        static let weightKey = "weight"
        static let imageKey = "front_default"
        static let spritesContainerKey = "sprites"
        static let typeContainerKey = "types"
    }
}
