import Networking

/// - Note: `Sourcery` is unable to produce compilable
/// mock for `Requesting` so we have to do it manually
class RequestingMock<T: Request>: Requesting {
    var makeRequestCallsCount = 0
    var makeRequestCalled: Bool {
        return makeRequestCallsCount > 0
    }
    var makeRequestReceivedArguments: (request: T, completion: (Result<T.Response, Error>) -> ())?
    var makeRequestReceivedInvocations: [(request: T, completion: (Result<T.Response, Error>) -> ())] = []
    var makeRequestClosure: ((T, @escaping (Result<T.Response, Error>) -> ()) -> Void)?
    
    func make<V>(request: V, _ completion: @escaping (Result<V.Response, Error>) -> ()) where V : Request {
        guard
            let request = request as? T,
            let completion = completion as? (Result<T.Response, Error>) -> ()
        else {
            return
        }
        
        makeRequestCallsCount += 1
        makeRequestReceivedArguments = (request: request, completion: completion)
        makeRequestReceivedInvocations.append((request: request, completion: completion))
        makeRequestClosure?(request, completion)
    }
}
