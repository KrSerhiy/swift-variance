class InetResource {}
class Blog: InetResource { func subscribe() {} }
class VideoBlog: Blog {}

// Function with argument of type 'Blog'
func subscribeOn(_ blog: Blog) {
    blog.subscribe()
}

// We can easily pass in instance of type 'VideoBlog', because 'VideoBlog' is subtype of 'Blog'
subscribeOn(VideoBlog())

// And we can't do the same with 'InetResource' type
subscribeOn(InetResource()) // Cannot convert value of type 'InetResource' to expected argument type 'Blog'
