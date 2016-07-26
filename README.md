# Quark

[![Swift][swift-badge]][swift-url]
[![Platform][platform-badge]][platform-url]
[![License][mit-badge]][mit-url]
[![Slack][slack-badge]][slack-url]
[![Travis][travis-badge]][travis-url]

A Clean Web Framework for Modern Swift Applications

## Manifesto

**Quark** is a framework heavily inspired by the [Clean Architecture](https://blog.8thlight.com/uncle-bob/2012/08/13/the-clean-architecture.html) and [The Twelve-Factor App](http://12factor.net). We believe that frameworks should do their best to make the developer's life easier while maintaining freedom. Applications built with **Quark** are architected in a way that the business logic is separated from the delivery mechanism (the web). This provides longevity for your application to evolve as the web evolves and incorporate new ways to deliver your application (real-time web apps for example). **Quark**'s architecture also allows you to test your business logic with no dependencies on the web or the database. You can have integration tests without booting up a server too.

## Documentation

For guides and an overview of **Quark** read our beautiful [documentation](https://quark-docs.readme.io).

## Reference

Want to dive deep inside **Quark**? Take a look at Quark's [reference](http://reference.quark.zewo.io).

## Installation

**Quark** works best with **June 20, 2016** Swift 3 Development Snapshot.

```swift
import PackageDescription

let package = Package(
    dependencies: [
        .Package(url: "https://github.com/QuarkX/Quark.git", majorVersion: 0, minor: 0)
    ]
)
```

## Support

If you have **any** trouble create a Github [issue](https://github.com/QuarkX/Quark/issues/new) and we'll do everything we can to help you. When stating your issue be sure to add enough details and reproduction steps so we can help you faster. If you prefer you can join our [Slack](http://slack.zewo.io) and go to the **#help** channel too.

## Community

[![Slack][slack-image]][slack-url]

We have an amazing community of open and welcoming developers. Join us on [Slack](http://slack.zewo.io) to get to know us!

## Contribution

Yo! Want to be a part of **Quark**? Check out our [Contribution Guidelines](CONTRIBUTING.md).

## Authors

These are the amazing folks that have contributed to the development of **Quark**.

- [Alex Studnicka](https://github.com/alex-alex)
- [Anton Mescheryakov](https://github.com/antonmes)
- [Brad Hilton](https://github.com/bradhilton)
- [Brian Rojas](https://github.com/marchinram)
- [Dan Appel](https://github.com/Danappelxx)
- [David Ask](https://github.com/formbound)
- [Honza Dvorsky](https://github.com/czechboy0)
- [Kevin Sullivan](https://github.com/kevinup7)
- [Oleg Dreyman](https://github.com/dreymonde)
- [Paulo Faria](http://github.com/paulofaria)
- [Peter Zignego](https://github.com/pvzig)
- [Ricardo Borelli](http://github.com/rabc)
- [Scott Byrns](https://github.com/scottbyrns)
- [Tomohisa Takaoka](https://github.com/tomohisa)
- [Thiago Holanda](http://github.com/unnamedd)
- [Vadym Holoveichuk](https://github.com/goloveychuk)

## License

**Quark** is released under the MIT license. See [LICENSE](https://raw.githubusercontent.com/QuarkX/Quark/master/LICENSE) for details.

[swift-badge]: https://img.shields.io/badge/Swift-3.0-orange.svg?style=flat
[swift-url]: https://swift.org
[zewo-badge]: https://img.shields.io/badge/Zewo-0.5-FF7565.svg?style=flat
[zewo-url]: http://zewo.io
[platform-badge]: https://img.shields.io/badge/Platforms-macOS%20&%20Linux-lightgray.svg?style=flat
[platform-url]: https://swift.org
[mit-badge]: https://img.shields.io/badge/License-MIT-blue.svg?style=flat
[mit-url]: https://tldrlegal.com/license/mit-license
[slack-image]: http://s13.postimg.org/ybwy92ktf/Slack.png
[slack-badge]: https://zewo-slackin.herokuapp.com/badge.svg
[slack-url]: http://slack.zewo.io
[travis-badge]: https://travis-ci.org/QuarkX/Quark.svg?branch=master
[travis-url]: https://travis-ci.org/QuarkX/Quark
