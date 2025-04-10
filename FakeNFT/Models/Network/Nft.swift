import Foundation

struct Nft: Decodable {
    let id: String
    let name: String
    let images: [URL]
    let rating: Int
    let description: String
    let price: Double
    
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
            id: "28829968-8639-4e08-8853-2f30fcf09783",
            name: "Olive Avila",
            images: [
                URL(string: "https://code.s3.yandex.net/Mobile/iOS/NFT/Blue/Bonnie/1.png")!,
                URL(string: "https://code.s3.yandex.net/Mobile/iOS/NFT/Blue/Bonnie/2.png")!,
                URL(string: "https://code.s3.yandex.net/Mobile/iOS/NFT/Blue/Bonnie/3.png")!
            ],
            rating: 2,
            description: "saepe patrioque recteque doming fabellas harum libero",
            price: 21.0
        ),
        Nft(
            id: "ca34d35a-4507-47d9-9312-5ea7053994c0",
            name: "Jody Rivers",
            images: [
                URL(string: "https://code.s3.yandex.net/Mobile/iOS/NFT/Beige/Lark/1.png")!,
                URL(string: "https://code.s3.yandex.net/Mobile/iOS/NFT/Beige/Lark/2.png")!,
                URL(string: "https://code.s3.yandex.net/Mobile/iOS/NFT/Beige/Lark/3.png")!
            ],
            rating: 3,
            description: "posse honestatis lobortis tritani scelerisque inimicus",
            price: 49.64
        ),
        Nft(
            id: "739e293c-1067-43e5-8f1d-4377e744ddde",
            name: "Christi Noel",
            images: [
                URL(string: "https://code.s3.yandex.net/Mobile/iOS/NFT/Beige/April/1.png")!,
                URL(string: "https://code.s3.yandex.net/Mobile/iOS/NFT/Beige/April/2.png")!,
                URL(string: "https://code.s3.yandex.net/Mobile/iOS/NFT/Beige/April/3.png")!
            ],
            rating: 2,
            description: "fringilla eam vim sonet faucibus impetus",
            price: 36.54
        ),
        Nft(
            id: "5093c01d-e79e-4281-96f1-76db5880ba70",
            name: "Kieth Clarke",
            images: [
                URL(string: "https://code.s3.yandex.net/Mobile/iOS/NFT/Gray/Kaydan/1.png")!,
                URL(string: "https://code.s3.yandex.net/Mobile/iOS/NFT/Gray/Kaydan/2.png")!,
                URL(string: "https://code.s3.yandex.net/Mobile/iOS/NFT/Gray/Kaydan/3.png")!
            ],
            rating: 2,
            description: "tacimates docendi efficitur tempus non quod cras pellentesque commune",
            price: 16.95
        ),
        Nft(
            id: "3434c774-0e0f-476e-a314-24f4f0dfed86",
            name: "Rudolph Short",
            images: [
                URL(string: "https://code.s3.yandex.net/Mobile/iOS/NFT/Gray/Butter/1.png")!,
                URL(string: "https://code.s3.yandex.net/Mobile/iOS/NFT/Gray/Butter/2.png")!,
                URL(string: "https://code.s3.yandex.net/Mobile/iOS/NFT/Gray/Butter/3.png")!
            ],
            rating: 2,
            description: "praesent numquam commodo singulis labores dolor intellegat an orci",
            price: 25.42
        ),
        Nft(
            id: "fc92edf5-1355-4246-b3b7-d64bc54d1abd",
            name: "Anthony Roberson",
            images: [
                URL(string: "https://code.s3.yandex.net/Mobile/iOS/NFT/Yellow/Winnie/1.png")!,
                URL(string: "https://code.s3.yandex.net/Mobile/iOS/NFT/Yellow/Winnie/2.png")!,
                URL(string: "https://code.s3.yandex.net/Mobile/iOS/NFT/Yellow/Winnie/3.png")!
            ],
            rating: 1,
            description: "consequat definitionem doming his senectus",
            price: 32.31
        ),
        Nft(
            id: "594aaf01-5962-4ab7-a6b5-470ea37beb93",
            name: "Minnie Sanders",
            images: [
                URL(string: "https://code.s3.yandex.net/Mobile/iOS/NFT/Pink/Lilo/1.png")!,
                URL(string: "https://code.s3.yandex.net/Mobile/iOS/NFT/Pink/Lilo/2.png")!,
                URL(string: "https://code.s3.yandex.net/Mobile/iOS/NFT/Pink/Lilo/3.png")!
            ],
            rating: 2,
            description: "mediocritatem interdum eleifend penatibus adipiscing mattis",
            price: 40.59
        ),
        Nft(
            id: "9e472edf-ed51-4901-8cfc-8eb3f617519f",
            name: "Erwin Barron",
            images: [
                URL(string: "https://code.s3.yandex.net/Mobile/iOS/NFT/Peach/Oreo/1.png")!,
                URL(string: "https://code.s3.yandex.net/Mobile/iOS/NFT/Peach/Oreo/2.png")!,
                URL(string: "https://code.s3.yandex.net/Mobile/iOS/NFT/Peach/Oreo/3.png")!
            ],
            rating: 2,
            description: "definiebas detraxit luctus reque nam adolescens sententiae suavitate",
            price: 13.61
        ),
        Nft(
            id: "1fda6f0c-a615-4a1a-aa9c-a1cbd7cc76ae",
            name: "Carmine Wooten",
            images: [
                URL(string: "https://code.s3.yandex.net/Mobile/iOS/NFT/Gray/Piper/1.png")!,
                URL(string: "https://code.s3.yandex.net/Mobile/iOS/NFT/Gray/Piper/2.png")!,
                URL(string: "https://code.s3.yandex.net/Mobile/iOS/NFT/Gray/Piper/3.png")!
            ],
            rating: 4,
            description: "mus inceptos sociosqu te orci ut hendrerit vix",
            price: 32.89
        ),
        Nft(
            id: "cc74e9ab-2189-465f-a1a6-8405e07e9fe4",
            name: "James Burt",
            images: [
                URL(string: "https://code.s3.yandex.net/Mobile/iOS/NFT/Blue/Clover/1.png")!,
                URL(string: "https://code.s3.yandex.net/Mobile/iOS/NFT/Blue/Clover/2.png")!,
                URL(string: "https://code.s3.yandex.net/Mobile/iOS/NFT/Blue/Clover/3.png")!
            ],
            rating: 2,
            description: "eos habeo percipit duis malesuada",
            price: 11.14
        )
    ]
}
