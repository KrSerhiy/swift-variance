class InetResource {}

// Function with argument of type 'InetResource?'
func share(_ resource: InetResource?) {}

// We can substitute optinal type with approptiate non optional
let inetResource: InetResource = InetResource()
share(inetResource)
