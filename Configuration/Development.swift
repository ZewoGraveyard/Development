import QuarkConfiguration

configuration = [
    "server": [
        "tcp": [
            "host": "0.0.0.0",
            "port": 8080,
        ],
        "backlog": 128,
        "reusePort": false,
        "log": false,
        "session": false,
        "contentNegotiation": false,
        "bufferSize": 2048
    ]
]
