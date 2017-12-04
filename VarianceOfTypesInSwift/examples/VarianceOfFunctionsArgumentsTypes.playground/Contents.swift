class InetResource { func share() {} }
class Blog: InetResource { func subscribe() {} }
class VideoBlog: Blog { func watch() {} }

// Function with argument of type '(Blog)->()'
func getBlog(callback:(Blog)->()) {
    let blog = Blog()
    callback(blog)
}

// Function of type '(InetResource) -> ()'
func processInetResource(_ inetResource: InetResource) {
    inetResource.share()
}

// Function of type '(VideoBlog) -> ()'
func processVideoBlog(_ videoBlog: VideoBlog) {
    videoBlog.watch()
}

// Can substitute '(Blog)->()' type with '(InetResource) -> ()' type
getBlog(callback: processInetResource)

// Can't do the same with '(VideoBlog) -> ()' type
getBlog(callback: processVideoBlog) // Cannot convert value of type '(VideoBlog) -> ()' to expected argument type '(Blog) -> ()'
