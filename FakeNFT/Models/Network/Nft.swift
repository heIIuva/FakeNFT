import Foundation

struct Nft: Decodable {
    let name: String
    let id: String
    let images: [URL]
    let rating: Int
    let price: Float
}
