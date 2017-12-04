class InetResource {
    let link: String
    init(link: String) {
        self.link = link
    }
}
class Blog: InetResource { func subscribe() {} }
class VideoBlog: Blog {}

extension InetResource: Hashable {
    var hashValue: Int {
        return link.hashValue
    }
    static func ==(lhs: InetResource, rhs: InetResource) -> Bool {
        return lhs.link == rhs.link
    }
}

// Function with argument of type 'Set<Blog>'
func suscribeOnSetOf(_ blogs: Set<Blog>) {
    blogs.forEach { $0.subscribe() }
}

let videoBlogsSet: Set<VideoBlog> = []
suscribeOnSetOf(videoBlogsSet)

let inetResourcesSet: Set<InetResource> = []
suscribeOnSetOf(inetResourcesSet) // Cannot convert value of type 'Set<InetResource>' to expected argument type 'Set<Blog>'
