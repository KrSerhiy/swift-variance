class InetResource {}
class Blog: InetResource { func subscribe() {} }
class VideoBlog: Blog {}

// Function with argument of type '() -> Blog'
func processBlog(_ request: () -> Blog) {
    let blog = request()
    blog.subscribe()
}

// Function of type '() -> InetResource'
func getInetResource() -> InetResource {
    return InetResource()
}

// Function of type '() -> VideoBlog'
func getVideoBlog() -> VideoBlog {
    return VideoBlog()
}

// Can substitute '() -> Blog' type with '() -> VideoBlog' type
processBlog(getVideoBlog)

// Can't do the same with '() -> InetResource' type
processBlog(getInetResource) // Cannot convert value of type '() -> InetResource' to expected argument type '() -> Blog'
