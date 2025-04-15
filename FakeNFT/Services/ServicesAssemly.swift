final class ServicesAssembly {

    private let networkClient: NetworkClient
    private let nftStorage: NftStorage

    init(
        networkClient: NetworkClient,
        nftStorage: NftStorage
    ) {
        self.networkClient = networkClient
        self.nftStorage = nftStorage
    }

    var nftService: NftService {
        NftServiceImpl(
            networkClient: networkClient,
            storage: nftStorage
        )
    }
    
    var profileService: ProfileService {
        ProfileServiceImpl(
            networkClient: networkClient,
            profileId: "1"
        )
    }
    
    var collectionService: CollectionServiceProtocol {
        CollectionService(networkClient: networkClient)
    }
    
    var catalogueService: CatalogueServiceProtocol {
        CatalogueService(networkClient: networkClient)
    }
}
