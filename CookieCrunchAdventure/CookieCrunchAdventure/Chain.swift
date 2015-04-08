class Chain: Hashable, Printable {
    // The Cookies that are part of this chain.
    var cookies = [Cookie]()
    
    enum ChainType: Printable {
        case Horizontal
        case Vertical
        
        // Note: add any other shapes you want to detect to this list.
        //case ChainTypeLShape
        //case ChainTypeTShape
        
        var description: String {
            switch self {
            case .Horizontal: return "Horizontal"
            case .Vertical: return "Vertical"
            }
        }
    }
    
    // Whether this chain is horizontal or vertical.
    var chainType: ChainType
    
    // How many points this chain is worth.
    var score = 0
    
    init(chainType: ChainType) {
        self.chainType = chainType
    }
    
    func addCookie(cookie: Cookie) {
        cookies.append(cookie)
    }
    
    func firstCookie() -> Cookie {
        return cookies[0]
    }
    
    func lastCookie() -> Cookie {
        return cookies[cookies.count - 1]
    }
    
    var length: Int {
        return cookies.count
    }
    
    var description: String {
        return "type:\(chainType) cookies:\(cookies)"
    }
    
    var hashValue: Int {
        return reduce(cookies, 0) { $0.hashValue ^ $1.hashValue }
    }
}

func ==(lhs: Chain, rhs: Chain) -> Bool {
    return lhs.cookies == rhs.cookies
}
