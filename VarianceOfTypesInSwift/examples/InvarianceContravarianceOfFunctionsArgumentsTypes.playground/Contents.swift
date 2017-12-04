class Blog {}

typealias AdType = String

var blog = Blog()

// Function with argument of type '(inout Blog)->()'
func applyAdsMembershipForBlog(_ itegrateAds:(AdType, inout Blog)->()) {
    itegrateAds("banners", &blog)
}

// Function of type '(AdType?, inout Blog)->()'
func integrateAds(of type: AdType?, for possibleBlog: inout Blog) {}

// Can substitute '(AdType, inout Blog)->()' type with '(AdType?, inout Blog)->()' type
applyAdsMembershipForBlog(integrateAds)
