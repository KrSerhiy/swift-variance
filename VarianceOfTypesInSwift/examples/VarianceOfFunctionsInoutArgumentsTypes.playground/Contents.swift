class InetResource {}
class Blog: InetResource {}
class VideoBlog: Blog {}

var blog: Blog = Blog()

// Function with argument of type '(inout Blog)->()'
func applyAdsMembershipForBlog(_ itegrateAds:(inout Blog)->()) {
    itegrateAds(&blog)
}

// Function of type '(inout InetResource) -> ()'
func integrateAdsForInetResource(_ inetResource: inout InetResource) {}

// Function of type '(inout VideoBlog) -> ()'
func integrateAdsForVideoBlog(_ videoBlog: inout VideoBlog) {}

applyAdsMembershipForBlog(integrateAdsForInetResource) // Cannot convert value of type '(inout InetResource) -> ()' to expected argument type '(inout Blog) -> ()'
applyAdsMembershipForBlog(integrateAdsForVideoBlog) // Cannot convert value of type '(inout VideoBlog) -> ()' to expected argument type '(inout Blog) -> ()'
