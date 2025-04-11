import Foundation

protocol NftStorageProtocol: AnyObject {
    func saveNft(_ nft: Nft)
    func getNft(with id: String) -> Nft?
}

final class NftStorage: NftStorageProtocol {
    private var storage: [String: Nft] = [:]

    private let queue = DispatchQueue(
        label: "nft-queue",
        qos: .userInteractive,
        attributes: .concurrent)

    func saveNft(_ nft: Nft) {
        queue.sync(flags: .barrier) { [weak self] in
            self?.storage[nft.id] = nft
        }
    }

    func getNft(with id: String) -> Nft? {
        queue.sync { [weak self] in
            self?.storage[id]
        }
    }
}
