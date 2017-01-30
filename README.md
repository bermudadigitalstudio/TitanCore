# TitanCore

TitanCore is a tiny Swift class that can be configured with `middleware` functions that are called in order when the `app` method is called.

[![Language Swift 3](https://img.shields.io/badge/Language-Swift%203-orange.svg)](https://swift.org) ![Platforms](https://img.shields.io/badge/Platforms-Docker%20%7C%20Linux%20%7C%20macOS-blue.svg) [![CircleCI](https://circleci.com/gh/bermudadigitalstudio/TitanCore/tree/master.svg?style=shield)](https://circleci.com/gh/bermudadigitalstudio/TitanCore)


## Functionality
The middleware functions receive a request and response object as input and must return a request and response object as output. There is no requirement that the outputs resemble the inputs in any way; however, it is expected that middlewares behave in a conservative and respectful fashion to their inputs. Middlewares should embrace the single responsibility principle: as a rule, they should only modify one property of either the request or the response. Multiple middlewares are always preferred over single middlewares.

For a more usable framework, which uses Titan and some other helpful libraries., see [Titan](https://github.com/bermudadigitalstudio/titan).
