import Foundation

struct Nft: Codable {
    let name: String
    let id: String
    let images: [URL]
    let rating: Int
    let price: Float
    let description: String
    
    var nftTitle: String {
        guard let firstImageURL = images.first else { return "" }
        
        guard let pathComponents = URLComponents(url: firstImageURL, resolvingAgainstBaseURL: false)?.path.components(separatedBy: "/"),
              pathComponents.count >= 2 else {
            return ""
        }
        
        return pathComponents[pathComponents.count - 2]
    }
}

extension Nft {
    static let mockData: [Nft] = [
        Nft(
            name: "Olive Avila", id: "28829968-8639-4e08-8853-2f30fcf09783",
            images: [
                URL(string: "https://code.s3.yandex.net/Mobile/iOS/NFT/Blue/Bonnie/1.png")!,
                URL(string: "https://code.s3.yandex.net/Mobile/iOS/NFT/Blue/Bonnie/2.png")!,
                URL(string: "https://code.s3.yandex.net/Mobile/iOS/NFT/Blue/Bonnie/3.png")!
            ],
            rating: 2,
            price: 21.0, description: "saepe patrioque recteque doming fabellas harum libero"
        ),
        Nft(
            name: "Jody Rivers", id: "ca34d35a-4507-47d9-9312-5ea7053994c0",
            images: [
                URL(string: "https://code.s3.yandex.net/Mobile/iOS/NFT/Beige/Lark/1.png")!,
                URL(string: "https://code.s3.yandex.net/Mobile/iOS/NFT/Beige/Lark/2.png")!,
                URL(string: "https://code.s3.yandex.net/Mobile/iOS/NFT/Beige/Lark/3.png")!
            ],
            rating: 3,
            price: 49.64, description: "posse honestatis lobortis tritani scelerisque inimicus"
        ),
        Nft(
            name: "Christi Noel", id: "739e293c-1067-43e5-8f1d-4377e744ddde",
            images: [
                URL(string: "https://code.s3.yandex.net/Mobile/iOS/NFT/Beige/April/1.png")!,
                URL(string: "https://code.s3.yandex.net/Mobile/iOS/NFT/Beige/April/2.png")!,
                URL(string: "https://code.s3.yandex.net/Mobile/iOS/NFT/Beige/April/3.png")!
            ],
            rating: 2,
            price: 36.54, description: "fringilla eam vim sonet faucibus impetus"
        ),
        Nft(
            name: "Kieth Clarke", id: "5093c01d-e79e-4281-96f1-76db5880ba70",
            images: [
                URL(string: "https://code.s3.yandex.net/Mobile/iOS/NFT/Gray/Kaydan/1.png")!,
                URL(string: "https://code.s3.yandex.net/Mobile/iOS/NFT/Gray/Kaydan/2.png")!,
                URL(string: "https://code.s3.yandex.net/Mobile/iOS/NFT/Gray/Kaydan/3.png")!
            ],
            rating: 2,
            price: 16.95, description: "tacimates docendi efficitur tempus non quod cras pellentesque commune"
        ),
        Nft(
            name: "Rudolph Short", id: "3434c774-0e0f-476e-a314-24f4f0dfed86",
            images: [
                URL(string: "https://code.s3.yandex.net/Mobile/iOS/NFT/Gray/Butter/1.png")!,
                URL(string: "https://code.s3.yandex.net/Mobile/iOS/NFT/Gray/Butter/2.png")!,
                URL(string: "https://code.s3.yandex.net/Mobile/iOS/NFT/Gray/Butter/3.png")!
            ],
            rating: 2,
            price: 25.42, description: "praesent numquam commodo singulis labores dolor intellegat an orci"
        ),
        Nft(
            name: "Anthony Roberson", id: "fc92edf5-1355-4246-b3b7-d64bc54d1abd",
            images: [
                URL(string: "https://code.s3.yandex.net/Mobile/iOS/NFT/Yellow/Winnie/1.png")!,
                URL(string: "https://code.s3.yandex.net/Mobile/iOS/NFT/Yellow/Winnie/2.png")!,
                URL(string: "https://code.s3.yandex.net/Mobile/iOS/NFT/Yellow/Winnie/3.png")!
            ],
            rating: 1,
            price: 32.31, description: "consequat definitionem doming his senectus"
        ),
        Nft(
            name: "Minnie Sanders", id: "594aaf01-5962-4ab7-a6b5-470ea37beb93",
            images: [
                URL(string: "https://code.s3.yandex.net/Mobile/iOS/NFT/Pink/Lilo/1.png")!,
                URL(string: "https://code.s3.yandex.net/Mobile/iOS/NFT/Pink/Lilo/2.png")!,
                URL(string: "https://code.s3.yandex.net/Mobile/iOS/NFT/Pink/Lilo/3.png")!
            ],
            rating: 2,
            price: 40.59, description: "mediocritatem interdum eleifend penatibus adipiscing mattis"
        ),
        Nft(
            name: "Erwin Barron", id: "9e472edf-ed51-4901-8cfc-8eb3f617519f",
            images: [
                URL(string: "https://code.s3.yandex.net/Mobile/iOS/NFT/Peach/Oreo/1.png")!,
                URL(string: "https://code.s3.yandex.net/Mobile/iOS/NFT/Peach/Oreo/2.png")!,
                URL(string: "https://code.s3.yandex.net/Mobile/iOS/NFT/Peach/Oreo/3.png")!
            ],
            rating: 2,
            price: 13.61, description: "definiebas detraxit luctus reque nam adolescens sententiae suavitate"
        ),
        Nft(
            name: "Carmine Wooten", id: "1fda6f0c-a615-4a1a-aa9c-a1cbd7cc76ae",
            images: [
                URL(string: "https://code.s3.yandex.net/Mobile/iOS/NFT/Gray/Piper/1.png")!,
                URL(string: "https://code.s3.yandex.net/Mobile/iOS/NFT/Gray/Piper/2.png")!,
                URL(string: "https://code.s3.yandex.net/Mobile/iOS/NFT/Gray/Piper/3.png")!
            ],
            rating: 4,
            price: 32.89, description: "mus inceptos sociosqu te orci ut hendrerit vix"
        ),
        Nft(
            name: "James Burt", id: "cc74e9ab-2189-465f-a1a6-8405e07e9fe4",
            images: [
                URL(string: "https://code.s3.yandex.net/Mobile/iOS/NFT/Blue/Clover/1.png")!,
                URL(string: "https://code.s3.yandex.net/Mobile/iOS/NFT/Blue/Clover/2.png")!,
                URL(string: "https://code.s3.yandex.net/Mobile/iOS/NFT/Blue/Clover/3.png")!
            ],
            rating: 2,
            price: 11.14, description: "eos habeo percipit duis malesuada"
        )
    ]
}
