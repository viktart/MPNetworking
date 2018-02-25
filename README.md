# MPNetworking
Compact network library in Swift 4


## Requirements

iOS 10.0 or higher.

## Usage

### NetworkManager

#### Retrieving a JSON object from server

```swift
// data object
struct Product: Codable {
    var productId : String
    var name : String?
    var price : Double?
    var imageURL : URL?
    var description : String?
    
    enum CodingKeys : String, CodingKey {
        case productId = "product_id"
        case name
        case price
        case imageURL = "image"
        case description
    }
}

/// Retrieving products in the following format:
/**
 "products": [
 {
 "product_id": "1",
 "name": "Apples",
 "price": 120,
 "image": "https://s3-eu-west-1.amazonaws.com/developer-application-test/images/1.jpg"
 },
 */
func GetProducts() {
    let URL_DEFAULT_SERVER =    "https://s3-eu-west-1.amazonaws.com/"
    let URL_PRODUCTS_LIST =     "developer-application-test/cart/list"
    
    NetworkManager.defaultManager.serverURL = URL(string: URL_DEFAULT_SERVER)!
    
    NetworkManager.defaultManager.performJSONRequest(
        relativeURLString: URL_PRODUCTS_LIST,
        httpMethod: .get,
        parameters: nil) { (responseObject: [String: [Product]]?, error) in
            let products = responseObject?["products"]
            print("\(products?.count ?? -1)")
    }
}

```
