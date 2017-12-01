### Variance of Types in Swift

In this post, I would like to systemize my knowledge about variance in Swift, on purpose, to detect some false assumption or gaps and hopefully to help somebody in discovering and studying this topic. For understanding it, you should have basic knowledge of Swift and also you should be aware of such concept as generics.

During exploring the topic, I really liked the explanation of variance on Wikipedia:

> [Many programming language type systems support subtyping. For instance, if the type Cat is a subtype of Animal, then an expression of type Cat can be used wherever an expression of type Animal is used. Variance refers to how subtyping between more complex types relates to subtyping between their components. For example, how should a list of Cats relate to a list of Animals? Or how should a function returning Cat relates to a function returning Animal? Depending on the variance of the type constructor, the subtyping relation of the simple types may be either preserved, reversed, or ignored for the respective complex types.](https://en.wikipedia.org/wiki/Covariance_and_contravariance_(computer_science))

Running ahead, I just want to add to the bolded text, that components of complex types are another types.

To understand the explanation of variance, we need to be aware of the key concepts, which was mentioned above: ***subtyping*** and ***complex types***. Also, to clearly distinguish complex types from other types, I’m going to call those others — ***simple types***. I’m not sure, that those are correct CS terms, sorry for that.

#### Simple types

Referring to [The Swift Programming Language](https://developer.apple.com/library/content/documentation/Swift/Conceptual/Swift_Programming_Language/Types.html#//apple_ref/doc/uid/TP40014097-CH31-ID445) book, we have next types in Swift ( the division on named and compound types doesn’t matter for us): ***classes, structures, enumerations, protocols***, functions, and tuples. From this list, functions, and tuples, but not only, are complex types (we are going to see that a little bit later), and the others are simple.

#### Subtyping

Subtyping is also very clearly explained in the above definition from Wikipedia (*… if the type Cat is a subtype of Animal, then an expression of type Cat can be used wherever an expression of type Animal is used …*).

The simple and widespread example, how we can achieve this in Swift, is by using classes and inheritance. Let’s look at some code:

[](ClassesSubtyping.playground)

```swift
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
```
​
Why does substitution of the type `Blog` with the type `VideoBlog` make sense? Via inheritance, `VideoBlog` type receives all properties and behavior, which `Blog` has. It gives us the guarantee, that anything `subscribeOn(:)` function can do with `blog` parameter of the type `Blog` is also going to work with the instance of `VideoBlog` type.

There is one more simple type, which allows to implement subtyping — a protocol. With protocols, we also can do that via inheritance:

[](ProtocolsSubtyping.playground)

```swift
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
```

Similar, as with classes, protocol inheritance guarantee that a type which conforms to `VideoBlog` protocol, must also conform to the requirements of `Blog` protocol. That’s why it is safe to pass the instance of the type `VideoBlog` where the instance of the type `Blog` is expected.

To summarize the above: ***from a point of variance, there are only two meaningful simple types, in Swift: classes and protocols***.

Besides inheritance of the classes and protocols, there is one more way to achieve subtyping: ***any type is a subtype of an appropriate optional type in Swift***. Here is the code example:

[](OptionalsSubtyping.playground)

```swift
class InetResource {}

// Function with argument of type 'InetResource?'
func share(_ resource: InetResource?) {}

// We can substitute optinal type with approptiate non optional
let inetResource: InetResource = InetResource()
share(inetResource)
```

In the following examples, we are going to use all these subtyping mechanisms, to demonstrate variance behavior of types in Swift.

#### Complex types

Complex types — types, which are constructed with another simple or complex types or which have another simple or complex types as its type components. Type components are types which are used by a [type constructor](https://en.wikipedia.org/wiki/Type_constructor) to build a new complex type. There are such complex types in Swift: ***functions, tuples, generic structures/enumerations/classes***. Also, in Swift, we have such complex things as generic functions and protocols with Self or associated types requirements. But we can’t consider them as fully-fledged types, cause we can’t use them:

> * [as a parameter type or return type in a function, method, or initializer](https://developer.apple.com/library/content/documentation/Swift/Conceptual/Swift_Programming_Language/Protocols.html#//apple_ref/doc/uid/TP40014097-CH25-ID267)
> * [as the type of a constant, variable, or property](https://developer.apple.com/library/content/documentation/Swift/Conceptual/Swift_Programming_Language/Protocols.html#//apple_ref/doc/uid/TP40014097-CH25-ID267) 
> * [as the type of items in an array, dictionary, or other container](https://developer.apple.com/library/content/documentation/Swift/Conceptual/Swift_Programming_Language/Protocols.html#//apple_ref/doc/uid/TP40014097-CH25-ID267)

The exception is protocols, in which Self is used only as return types of methods. Those protocols behave similarly as simple protocols:

[](SimpleProtocolWithSelfRequirement.playground)

```swift
protocol InetResource {
    var link: String {get}
    var language: String {get}
    
    func translatedTo(_ targetLanguage: String) -> Self
}

final class InetResourceImp: InetResource {
    let link: String
    let language: String
    
    init(link: String, language: String = "en") {
        self.link = link
        self.language = language
    }
    
    func translatedTo(_ targetLanguage: String) -> InetResourceImp {
        return InetResourceImp(link: link, language: targetLanguage)
    }
}

// 'InetResource' protocol type used as type of constant
let ukrainianResource: InetResource = InetResourceImp(link: "inetresource.com").translatedTo("ua")
```

Let’s look at the code examples of the complex types in Swift:

[](ComplexTypes.playground)

```swift
// COMPLEX TYPES CONSTRUCTED WITH SIMPLE TYPES:

func someFunction (int: Int) -> Bool { return true } // complex function type '(Int) -> Bool', constructed with simple 'Int' and 'Bool' types

let tuple = ("a", 0.5) // complex tuple type '(String, Double)', constructed with simple 'String' and 'Double' types

struct SomeGenericStruct<T> {
    init(_ t: T) {}
}
let someGenericStruct = SomeGenericStruct("") // complex generic type 'SomeGenericStruct<String>', constructed with simple 'String' type

// COMPLEX TYPES CONSTRUCTED ALSO WITH COMPLEX TYPES:

let tupleWithFunctionAndTuple = (someFunction, tuple) // complex tuple type '((Int) -> Bool, (String, Double))', constructed with complex '(Int) -> Bool' and '(String, Double)' types

func functionWithFunction(anotherFunc: (Int) -> Bool) {} // complex function type '((Int) -> Bool) -> ()', constructed with complex '(Int) -> Bool' type
```

#### Variance

So, the notion variance is about realizing what subtyping behavior a complex type has according to subtyping behavior of appropriate type components.

Let’s assume that expression `A[B]` means, that the type `A` is a complex type, constructed from the simple type `B`, or the complex type `A` has the simple type `B` as its type component.  According to this abstract syntax, let’s give the definitions of the different kinds of variance:

* the type `A` is ***covariant*** with its type components if the type `A[C]` is a subtype of the type `A[B]`, when `C` is a subtype of the  type `B`;
* the type `A` is ***contravariant*** with its type components if the type `A[B]` is a subtype of the type `A[C]`, when `C` is a subtype of the type `B`;
* the type `A` is ***invariant*** with its type components if the type `A[B]` is never a subtype of the type `A[C]`, regardless of subtyping relations between the types `C` and `B`;
* the type `A` is ***bivariant*** with its type components if the type `A[B]` is always a subtype of the type `A[C]`, regardless of subtyping relations between the types `C` and `B`.

Complex types can have:

* more than one type component —`A[B, C]` . Then, if `A` is covariant, `A[D, E]` is a subtype of `A[B, C]`, when `D` is a subtype of `B` and `E` is a subtype of `C`. As we can see, subtyping behavior of complex types depends on subtyping of all of their type components;
* other complex types as their type components— `A[B[C]]`. Then if `A` is contravariant, `A[B[D]]` is a subtype of `A[B[C]]`, when `B[C]` is a subtype of `B[B]`. It’s obvious, that to realize subtyping behavior for an outer complex type, we need to realize it for an inner complex type. And no matter how deep is this hierarchy, we always end up with a complex type, constructed with a simple on;
* different groups of type components, to separate them by variance behavior — `A[B][C]`. Then, if `A` is covariant with the first group and contravariant with the second, `A[D][E]` is a subtype of `A[B][C]`, when `D` is a subtype of `B` and `C`is a subtype of `E`. To realize subtyping behavior of a complex type, we need to take into consideration variance of all component’s groups;
* all above options can also be combined together — `A[B[C], D][E[F]]`. To realize its subtyping behavior we just need to follow the upper rules.

Bellow, we are going to look at the variance of the Swift’s complex types.

**Variance of functions in Swift**

Let’s consider the next example:

[](VarianceOfFunctionsReturnType.playground)

```swift
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
```

We can make the assumption, that functions in Swift are covariant with their components, cause:

* `VideoBlog` is a subtype of `Blog` and `() -> VideoBlog` is a subtype of `() -> Blog` (as derived from `processBlog(getVideoBlog)`)
* `Blog` is a subtype of `InetResource`  and `() -> InetResource` isn’t a subtype of `() -> Blog` (as derived from `processBlog(getInetResource)`)

But this is not completely true. Let’s look at another example:

[](VarianceOfFunctionsArgumentsTypes.playground)

```swift
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
```

In this example, Swift functions behave as contrvarian with their components, cause:

* `Blog` is a subtype of `InetResource`  and `(InetResource) -> ()` is a subtype of `(Blog) -> ()`(as derived from `getBlog(callback: processInetResource)`)
* `VideoBlog` is a subtype of `Blog` and `(VideoBlog) -> ()`isn’t a subtype of `(Blog) -> ()`(as derived from `getBlog(callback: processVideoBlog)`)

But the real truth is that ***functions in Swift are contravariant with their arguments types and covariant with their return type***. For analogy with our abstract syntax, the function of type `(P1, P2) -> R` looks like `F[P1, P2][R]` and is contravariant with the first components group and covariant with the second.

At first look, it seems confusing, that functions are contravariant with their arguments types, but it really makes sense. Assume that passing into the function `getBlog(callback:)` an argument of the type `(VideoBlog) -> ()` works. Then, during the function execution, it will try to call that  `callback` parameter with an argument of the type `Blog`. But a substitution of `VideoBlog` type with `Blog` type is impossible, cause `Blog` isn’t a subtype of `VideoBlog`. With passing in an argument of the type `(InetResource) -> ()`, a substitution of`InetResource` type with `Blog` type takes place, what is completely legally, cause `Blog` is a subtype of `InetResource`.

Let’s look at one more example of function’s contravariance with arguments types:

[](ContravarianceOfFunctionsArgumentsTypes.playground)

```swift
class Blog { func subscribe() {} }

// Function with argument of type '(Blog)->()'
func getBlog(callback:(Blog)->()) {
    let blog = Blog()
    callback(blog)
}

// Function of type '(Blog?) -> ()'
func processPossibleBlog(_ blog: Blog?) {
    blog?.subscribe()
}

// Can substitute '(Blog)->()' type with '(Blog?) -> ()' type
getBlog(callback: processPossibleBlog)
```

Here we substitute the function, which receives an argument of the non-optional type `(Blog)->()`, with the function, which receives an argument of the optional type `(Blog?)->()`. It makes sense, cause then the second can easily be called with a non-optional argument inside the outer function `getBlog(callback:)`.

In general, we should think about this in a next way:

* ***arguments types of a 'replace function' will be substituted with argument types of a 'replaced function'***;
* ***a return type of a 'replace function' will substitute a return type of a 'replaced function'***.

Here are: 'replace function' —  a function that substitutes another one; 'replaced function' —  a function that is substituted by another one.

**Variance of tuples in Swift**

Let’s look at the code example, to realize variance of tuples in Swift:

[](TuplesVariance.playground)

```swift
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
```

As we can see, ***tuples in Swift are invariant with their components***, although, theoretically, tuples could be covariant with their components.

I don’t exactly know, why in the previous example we get different error messages. I guess it refers to some specific things of tuples implementation, as this is out of the theme of variance, I wasn’t discovering it.

**Variance of generics in Swift**

Under generics, I mean generic enumerations, structures or classes. Let’s look at the code example, to realize variance of generics in swift (in this example a generic class are used, but with structures and enumerations behavior is the same):

[](CustomGenericsVariance.playground)

```swift
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
```

As we can see from the example, ***custom generics in Swift are invariant with their type parameters***, and we, as programmers, can’t specify another behavior, as possible to do in some other languages (in my opinion, there are essential reasons for this and you can read it in the separate article [Why are custom generics invariant in Swift?](http://d)TK).

But we have different behavior for some generic types in Swift standard library, it refers to the container types, such as optionals, arrays, sets, and dictionaries. For example:

[](SetsCovariance.playground)

```swift
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
```

Ass we can see, sets are covariant with their type parameters. Optionals, dictionaries, and arrays have the same behavior:

[](OptionalsDictionariesArraysCovariance.playground)

```swift
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
```

Notice that dictionaries also covariant with type parameter for key:

[](DictionariesKeyParameterCovariance.playground)

```swift
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
```

So, ***the container types (optionals, arrays, sets, and dictionaries) are covariant with their type parameters in Swift***.