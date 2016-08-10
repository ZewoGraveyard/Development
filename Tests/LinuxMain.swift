import XCTest
@testable import QuarkTests

XCTMain([
    // Controller
    testCase(ControllerTests.allTests),

    // Quark
    testCase(QuarkTests.allTests),

    // Venice
    testCase(ChannelTests.allTests),
    testCase(CoroutineTests.allTests),
    testCase(FallibleChannelTests.allTests),
    testCase(FileTests.allTests),
    testCase(IPTests.allTests),
    testCase(POSIXTests.allTests),
    testCase(SelectTests.allTests),
    testCase(TCPTests.allTests),
    testCase(TickerTests.allTests),
    testCase(TimerTests.allTests),

    // Core
    testCase(Base64Tests.allTests),
    testCase(EnvironmentTests.allTests),
    testCase(JSONTests.allTests),
    testCase(LoggerTests.allTests),
    testCase(InternalTests.allTests),
    testCase(MappableTests.allTests),
    testCase(PerformanceTests.allTests),
    testCase(PublicTests.allTests),
    testCase(StringTests.allTests),
    testCase(MapTests.allTests),
    testCase(URITests.allTests),
    testCase(URLEncodedFormParserTests.allTests),


    // HTTP
    testCase(RequestContentTests.allTests),
    testCase(ResponseContentTests.allTests),
    testCase(AttributedCookieTests.allTests),
    testCase(BodyTests.allTests),
    testCase(CookieTests.allTests),
    testCase(MessageTests.allTests),
    testCase(RequestTests.allTests),
    testCase(ResponseTests.allTests),
    testCase(BasicAuthMiddlewareTests.allTests),
    testCase(ContentNegotiationMiddlewareTests.allTests),
    testCase(LogMiddlewareTests.allTests),
    testCase(RecoveryMiddlewareTests.allTests),
    testCase(RedirectMiddlewareTests.allTests),
    testCase(SessionMiddlewareTests.allTests),
    testCase(RequestParserTests.allTests),
    testCase(ResponseParserTests.allTests),
    testCase(ResourceTests.allTests),
    testCase(RouterTests.allTests),
    testCase(RoutesTests.allTests),
    testCase(TrieRouteMatcherTests.allTests),
    testCase(HTTPSerializerTests.allTests),
    testCase(ServerTests.allTests),

    // Template
    testCase(MustacheSerializerTests.allTests),
])
