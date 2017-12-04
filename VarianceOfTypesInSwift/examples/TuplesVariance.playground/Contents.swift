protocol InetResource { func share() }
protocol Blog: InetResource { func subscribe() }
protocol VideoBlog: Blog { func watch() }

class InetResourceImp: InetResource {
    func share() {}
}

class VideoBlogImp: VideoBlog {
    func share() {}
    func subscribe() {}
    func watch() {}
}

// Function with argument of type '(Blog, Blog)'
func processBlogsTuple(_ tuple: (Blog, Blog)) {
    tuple.0.subscribe()
    tuple.1.subscribe()
}

let iResourcesTuple: (InetResource, InetResource) = (InetResourceImp(), InetResourceImp())
processBlogsTuple(iResourcesTuple) // Cannot convert value of type '(InetResource, InetResource)' to expected argument type '(Blog, Blog)'

let vBlogsTuple: (VideoBlog, VideoBlog) = (VideoBlogImp(), VideoBlogImp())
processBlogsTuple(vBlogsTuple) // Cannot express tuple conversion '(VideoBlog, VideoBlog)' to '(Blog, Blog)'
