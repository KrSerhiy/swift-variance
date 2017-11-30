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
