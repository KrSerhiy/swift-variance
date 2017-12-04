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
