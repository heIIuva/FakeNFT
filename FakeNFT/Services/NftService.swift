import Foundation

typealias NftCompletion = (Result<Nft, Error>) -> ()
typealias NftOrderCompletion = (Result<Order, Error>) -> ()
typealias CurrencyCompletion = (Result<[Currency], Error>) -> ()
typealias PaymentConfirmationCompletion = (Result<Payment, Error>) -> ()


protocol NftService {
    func loadNft(id: String, completion: @escaping NftCompletion)
    func loadOrder(completion: @escaping NftOrderCompletion)
    func loadCurrencies(completion: @escaping CurrencyCompletion)
    func updateOrder(nfts: [String], completion: @escaping NftOrderCompletion)
    func confirmPayment(currency: Currency, completion: @escaping PaymentConfirmationCompletion)
}

final class NftServiceImpl: NftService {

    private let networkClient: NetworkClient
    private let storage: NftStorage

    init(networkClient: NetworkClient, storage: NftStorage) {
        self.storage = storage
        self.networkClient = networkClient
    }

    func loadNft(id: String, completion: @escaping NftCompletion) {
        if let nft = storage.getNft(with: id) {
            completion(.success(nft))
            return
        }

        let request = NFTRequest(id: id)
        networkClient.send(request: request, type: Nft.self) { [weak storage] result in
            switch result {
            case .success(let nft):
                storage?.saveNft(nft)
                completion(.success(nft))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func loadOrder(completion: @escaping NftOrderCompletion) {
        networkClient.send(request: NFTOrderRequest(), type: Order.self) { result in
            switch result {
            case .success(let order):
                completion(.success(order))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func loadCurrencies(completion: @escaping CurrencyCompletion) {
        networkClient.send(request: CurrencyRequest(), type: [Currency].self) { result in
            switch result {
            case .success(let currencies):
                completion(.success(currencies))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func updateOrder(nfts: [String], completion: @escaping NftOrderCompletion) {
        networkClient.send(request: NftPutOrderRequest(order: nfts), type: Order.self) { result in
            switch result {
            case .success(let order):
                completion(.success(order))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func confirmPayment(currency: Currency, completion: @escaping PaymentConfirmationCompletion) {
        networkClient.send(request: PaymentConfirmationRequest(currency: currency), type: Payment.self) { result in
            switch result {
            case .success(let payment):
                completion(.success(payment))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
