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
        NftService(
            networkClient: networkClient,
            storage: nftStorage
        )
    }
    
    var catalogueService: CatalogueServiceProtocol {
        CatalogueService(networkClient: networkClient)
    }
}
