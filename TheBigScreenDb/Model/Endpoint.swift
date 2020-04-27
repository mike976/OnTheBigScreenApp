

protocol Endpoint {
  var path: String { get }
}

enum Coinbase {
  case bitcoin
}

extension Coinbase: Endpoint {
  var path: String {
    switch self {
    case .bitcoin: return "https://api.coinbase.com/v2/prices/BTC-USD/spot"
    }
  }
}
