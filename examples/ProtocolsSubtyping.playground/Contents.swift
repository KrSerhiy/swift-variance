protocol Blog { func subscribe() }
protocol VideoBlog: Blog {}

class VideoBlogImp: VideoBlog { func subscribe() {} }

// Function with argument of type 'Blog'
func subscribeOn(_ blog: Blog) {
    blog.subscribe()
}

// We can easily pass in instance of type 'VideoBlog', because 'VideoBlog' is subtype of 'Blog'
let videoBlog: VideoBlog = VideoBlogImp()
subscribeOn(videoBlog)
