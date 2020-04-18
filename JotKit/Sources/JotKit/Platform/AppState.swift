import Foundation

public protocol AppStateType: AnyObject {
    var textBusinessLogic: TextBusinessLogicType { get }
    var shareBusinessLogic: ShareBusinessLogicType { get }
    var activityHandler: ActivityHandlerType { get }
}

public final class AppState: AppStateType {
    private let loggingService: LoggingService
    private let dataService: DataService

    #if os(iOS)
    private let reviewBusinessLogic: ReviewBusinessLogicType
    #endif

    public let textBusinessLogic: TextBusinessLogicType
    public let shareBusinessLogic: ShareBusinessLogicType
    public let activityHandler: ActivityHandlerType

    #if os(iOS)
    init(loggingService: LoggingService,
         dataService: DataService,
         reviewBusinessLogic: ReviewBusinessLogicType,
         textBusinessLogic: TextBusinessLogicType,
         shareBusinessLogic: ShareBusinessLogicType,
         activityHandler: ActivityHandlerType) {
        self.loggingService = loggingService
        self.dataService = dataService
        self.reviewBusinessLogic = reviewBusinessLogic
        self.textBusinessLogic = textBusinessLogic
        self.shareBusinessLogic = shareBusinessLogic
        self.activityHandler = activityHandler
        activityHandler.appState = self
    }

    public convenience init() {
        let loggingService = OSLoggingService(bundleIdentifier: Bundle.main.bundleIdentifier!)
        let dataService = CloudDataService(loggingService: loggingService)
        let textBusinessLogic = TextBusinessLogic(dataService: dataService)
        let shareBusinessLogic = ShareBusinessLogic(textBusinessLogic: textBusinessLogic)
        self.init(loggingService: loggingService,
                  dataService: dataService,
                  reviewBusinessLogic: ReviewBusinessLogic(dataService: dataService,
                                                           textBusinessLogic: textBusinessLogic,
                                                           shareBusinessLogic: shareBusinessLogic),
                  textBusinessLogic: textBusinessLogic,
                  shareBusinessLogic: shareBusinessLogic,
                  activityHandler: ActivityHandler())
    }

    #elseif os(macOS)
    init(loggingService: LoggingService,
         dataService: DataService,
         textBusinessLogic: TextBusinessLogicType,
         shareBusinessLogic: ShareBusinessLogicType,
         activityHandler: ActivityHandlerType) {
        self.loggingService = loggingService
        self.dataService = dataService
        self.textBusinessLogic = textBusinessLogic
        self.shareBusinessLogic = shareBusinessLogic
        self.activityHandler = activityHandler
        activityHandler.appState = self
    }

    public convenience init() {
        let loggingService = OSLoggingService(bundleIdentifier: Bundle.main.bundleIdentifier!)
        let dataService = CloudDataService(loggingService: loggingService)
        let textBusinessLogic = TextBusinessLogic(dataService: dataService)
        self.init(loggingService: loggingService,
                  dataService: dataService,
                  textBusinessLogic: textBusinessLogic,
                  shareBusinessLogic: ShareBusinessLogic(textBusinessLogic: textBusinessLogic),
                  activityHandler: ActivityHandler())
    }
    #endif
}