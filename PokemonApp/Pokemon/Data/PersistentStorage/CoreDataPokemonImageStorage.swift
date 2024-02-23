import CoreData
import Foundation

final class CoreDataPokemonImageStorage: PokemonImageStorage
{
    private let coreDataStorage: CoreDataStorage

    init(coreDataStorage: CoreDataStorage = CoreDataStorage.shared)
    {
        self.coreDataStorage = coreDataStorage
    }

    private func fetchRequest(
        for path: String
    ) -> NSFetchRequest<ImageDataEntity>
    {
        let request: NSFetchRequest = ImageDataEntity.fetchRequest()
        request.predicate = NSPredicate(format: "%K = %@", #keyPath(ImageDataEntity.path), path)
        return request
    }
}

extension CoreDataPokemonImageStorage
{
    func getImage(for path: String) async throws -> Data?
    {
        return try await withCheckedThrowingContinuation
        { continuation in
            coreDataStorage.performBackgroundTask
            { context in
                do
                {
                    let fetchRequest = self.fetchRequest(for: path)
                    let requestEntity = try context.fetch(fetchRequest).first
                    let data = requestEntity?.data
                    continuation.resume(returning: data)
                }
                catch
                {
                    continuation.resume(throwing: error)
                }
            }
        }
    }

    func save(data: Data, for path: String)
    {
        coreDataStorage.performBackgroundTask
        { context in
            do
            {
                let imageDataEntity = ImageDataEntity(context: context)
                imageDataEntity.data = data
                imageDataEntity.path = path
                try context.save()
            }
            catch
            {
                print(error)
            }
        }
    }
}
