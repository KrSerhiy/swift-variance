class InetResource {
    let link: String
    init(link: String) {
        self.link = link
    }
}
class Blog: InetResource {}
class VideoBlog: Blog {}

extension InetResource: Hashable {
    var hashValue: Int {
        return link.hashValue
    }
    static func ==(lhs: InetResource, rhs: InetResource) -> Bool {
        return lhs.link == rhs.link
    }
}

// Function with argument of type 'Dictionary<Blog, Int>'
func totalSubscribers(_ blogsDict: Dictionary<Blog, Int>) -> Int {
    return blogsDict.values.reduce(0, +)
}

let videoBlogsDict: Dictionary<VideoBlog, Int> = [:]
let videoBlogsSubscribers = totalSubscribers(videoBlogsDict)

let inetResourcesDict: Dictionary<InetResource, Int> = [:]
let inetResourcesSubscribers = totalSubscribers(inetResourcesDict) // Cannot convert value of type 'Dictionary<InetResource, Int>' to expected argument type 'Dictionary<Blog, Int>'
