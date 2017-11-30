class InetResource {}
class Blog: InetResource { func subscribe() {} }
class VideoBlog: Blog {}

// OPTIONALS:
// Function with argument of type 'Optional<Blog>'
func suscribeOn(_ blog: Optional<Blog> ) {
    blog?.subscribe()
}

let videoBlog: Optional<VideoBlog> = nil
suscribeOn(videoBlog)

let inetResource: Optional<InetResource> = nil
suscribeOn(inetResource) // Cannot convert value of type 'Optional<InetResource>' to expected argument type 'Optional<Blog>'

// DICTIONARIES:
// Function with argument of type 'Dictionary<Int, Blog>'
func suscribeOnDictOf(_ blogs: Dictionary<Int, Blog>) {
    blogs.values.forEach { $0.subscribe() }
}

let videoBlogsDict: Dictionary<Int, VideoBlog> = [:]
suscribeOnDictOf(videoBlogsDict)

let inetResourcesDict: Dictionary<Int, InetResource> = [:]
suscribeOnDictOf(inetResourcesDict) // Cannot convert value of type 'Dictionary<Int, InetResource>' to expected argument type 'Dictionary<Int, Blog>'

// ARRAYS:
// Function with argument of type 'Array<Blog>'
func suscribeOnArrayOf(_ blogs: Array<Blog>) {
    blogs.forEach { $0.subscribe() }
}

let videoBlogsArray: Array<VideoBlog> = []
suscribeOnArrayOf(videoBlogsArray)

let inetResourcesArray: Array<InetResource> = []
suscribeOnArrayOf(inetResourcesArray) // Cannot convert value of type 'Array<InetResource>' to expected argument type 'Array<Blog>'

