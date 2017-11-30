protocol InetResource {}
protocol Blog: InetResource { func subscribe() }
protocol VideoBlog: Blog {}

struct InetResourceImp: InetResource {}
struct VideoBlogImp: VideoBlog { func subscribe() {} }

class Ref<T> {
    let value: T
    
    init(_ value: T) {
        self.value = value
    }
}

// Function with argument of type 'Ref<Blog>'
func subscribeOn(_ blog: Ref<Blog>) {
    blog.value.subscribe()
}

let inetResourceRef: Ref<InetResource> = Ref(InetResourceImp())
subscribeOn(inetResourceRef) // Cannot convert value of type 'Ref<InetResource>' to expected argument type 'Ref<Blog>'

let videoBlogRef: Ref<VideoBlog> = Ref(VideoBlogImp())
subscribeOn(videoBlogRef) // Cannot convert value of type 'Ref<VideoBlog>' to expected argument type 'Ref<Blog>'
