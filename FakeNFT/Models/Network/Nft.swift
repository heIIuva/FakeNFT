import Foundation

struct Nft: Codable {
    let name: String
    let id: String
    let images: [URL]
    let rating: Int
    let price: Float
}
