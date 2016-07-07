extension Body {
    /**
     Converts the body's contents into a `Data` buffer.
     If the body is a receiver or sender type,
     it will be drained.
     */
    public mutating func becomeBuffer(timingOut deadline: Double = .never) throws -> Data {
        switch self {
        case .buffer(let data):
            return data
        case .receiver(let receiver):
            let data = Drain(for: receiver, timingOut: deadline).data
            self = .buffer(data)
            return data
        case .sender(let sender):
            let drain = Drain()
            try sender(drain)
            let data = drain.data

            self = .buffer(data)
            return data
        default:
            throw BodyError.inconvertibleType
        }
    }

    ///Returns true if body is case `buffer`
    public var isBuffer: Bool {
        switch self {
        case .buffer: return true
        default: return false
        }
    }

    /**
     Converts the body's contents into a `ReceivingStream`
     that can be received in chunks.
     */
    public mutating func becomeReceiver() throws -> ReceivingStream {
        switch self {
        case .receiver(let stream):
            return stream
        case .buffer(let data):
            let stream = Drain(for: data)
            self = .receiver(stream)
            return stream
        case .sender(let sender):
            let stream = Drain()
            try sender(stream)
            self = .receiver(stream)
            return stream
        default:
            throw BodyError.inconvertibleType
        }
    }

    ///Returns true if body is case `receiver`
    public var isReceiver: Bool {
        switch self {
        case .receiver: return true
        default: return false
        }
    }

    /**
     Converts the body's contents into a closure
     that accepts a `SendingStream`.
     */
    public mutating func becomeSender(timingOut deadline: Double = .never) -> ((SendingStream) throws -> Void) {
        switch self {
        case .buffer(let data):
            let closure: ((SendingStream) throws -> Void) = { sender in
                try sender.send(data, timingOut: deadline)
            }
            self = .sender(closure)
            return closure
        case .receiver(let receiver):
            let closure: ((SendingStream) throws -> Void) = { sender in
                let data = Drain(for: receiver, timingOut: deadline).data
                try sender.send(data, timingOut: deadline)
            }
            self = .sender(closure)
            return closure
        case .sender(let sender):
            return sender
        default:
            let closure: ((SendingStream) throws -> Void) = { _ in
                throw BodyError.inconvertibleType
            }
            return closure
        }
    }

    ///Returns true if body is case `sender`
    public var isSender: Bool {
        switch self {
        case .sender: return true
        default: return false
        }
    }
}

extension Body {
    /**
     Converts the body's contents into a `Data` buffer asynchronously.

     If the body is a receiver, sender, asyncReceiver or asyncSender type,
     it will be drained.
     */
    public func asyncBecomeBuffer(timingOut deadline: Double = .never, completion: ((Void) throws -> (Body, Data)) -> Void) {
        switch self {
        case .asyncReceiver(let stream):
            _ = AsyncDrain(for: stream, timingOut: deadline) { closure in
                completion {
                    let drain = try closure ()
                    return (.buffer(drain.data), drain.data)
                }
            }

        case .asyncSender(let sender):
            let drain = AsyncDrain()
            sender(drain) { closure in
                completion {
                    try closure()
                    return (.buffer(drain.data), drain.data)
                }
            }

        default:
            completion {
                throw BodyError.inconvertibleType
            }
        }
    }

    ///Returns true if body is case `asyncReceiver`
    public var isAsyncReceiver: Bool {
        switch self {
        case .asyncReceiver: return true
        default: return false
        }
    }


    /**
     Converts the body's contents into a `AsyncReceivingStream`
     that can be received in chunks.
     */
    public func becomeAsyncReceiver(completion: ((Void) throws -> (Body, AsyncReceivingStream)) -> Void) {
        switch self {
        case .asyncReceiver(let stream):
            completion {
                (self, stream)
            }
        case .buffer(let data):
            let stream = AsyncDrain(for: data)
            completion {
                (.asyncReceiver(stream), stream)
            }
        case .asyncSender(let sender):
            let stream = AsyncDrain()
            sender(stream) { closure in
                completion {
                    try closure()
                    return (.asyncReceiver(stream), stream)
                }
            }
        default:
            completion {
                throw BodyError.inconvertibleType
            }
        }
    }

    /**
     Converts the body's contents into a closure
     that accepts a `AsyncSendingStream`.
     */
    public func becomeAsyncSender(timingOut deadline: Double = .never, completion: ((Void) throws -> (Body, ((AsyncSendingStream, ((Void) throws -> Void) -> Void) -> Void))) -> Void) {

        switch self {
        case .buffer(let data):
            let closure: ((AsyncSendingStream, ((Void) throws -> Void) -> Void) -> Void) = { sender, result in
                sender.send(data, timingOut: deadline) { closure in
                    result {
                        try closure()
                    }
                }
            }
            completion {
                return (.asyncSender(closure), closure)
            }
        case .asyncReceiver(let receiver):
            let closure: ((AsyncSendingStream, ((Void) throws -> Void) -> Void) -> Void) = { sender, result in
                _ = AsyncDrain(for: receiver, timingOut: deadline) { getData in
                    do {
                        let drain = try getData()
                        sender.send(drain.data, timingOut: deadline, completion: result)
                    } catch {
                        result {
                            throw error
                        }
                    }
                }
            }
            completion {
                return (.asyncSender(closure), closure)
            }
        case .asyncSender(let closure):
            completion {
                (self, closure)
            }
        default:
            completion {
                throw BodyError.inconvertibleType
            }
        }
    }

    ///Returns true if body is case `asyncSender`
    public var isAsyncSender: Bool {
        switch self {
        case .asyncSender: return true
        default: return false
        }
    }
}
