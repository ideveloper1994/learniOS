
import UIKit


@objc public final class SSCalendarTimeSelectorStyle: NSObject {
    fileprivate(set) public var showDateMonth: Bool = true
    fileprivate(set) public var showMonth: Bool = false
    fileprivate(set) public var showYear: Bool = true
    fileprivate(set) public var showTime: Bool = true
    fileprivate var isSingular = false
    
    public func showDateMonth(_ show: Bool) {
        showDateMonth = show
        showMonth = show ? false : showMonth
        if show && isSingular {
            showMonth = false
            showYear = false
            showTime = false
        }
    }
    
    public func showMonth(_ show: Bool) {
        showMonth = show
        showDateMonth = show ? false : showDateMonth
        if show && isSingular {
            showDateMonth = false
            showYear = false
            showTime = false
        }
    }
    
    public func showYear(_ show: Bool) {
        showYear = show
        if show && isSingular {
            showDateMonth = false
            showMonth = false
            showTime = false
        }
    }
    
    public func showTime(_ show: Bool) {
        showTime = show
        if show && isSingular {
            showDateMonth = false
            showMonth = false
            showYear = false
        }
    }
    
    fileprivate func countComponents() -> Int {
        return (showDateMonth ? 1 : 0) +
            (showMonth ? 1 : 0) +
            (showYear ? 1 : 0) +
            (showTime ? 1 : 0)
    }
    
    fileprivate convenience init(isSingular: Bool) {
        self.init()
        self.isSingular = isSingular
        showDateMonth = true
        showMonth = false
        showYear = false
        showTime = false
    }
}

/// Set `optionSelectionType` with one of the following:
///
/// `Single`: This will only allow the selection of a single date. If applicable, this also allows selection of year and time.
///
/// `Multiple`: This will allow the selection of multiple dates. This automatically ignores the attribute of `optionPickerStyle`, hence selection of multiple year and time is currently not available.
///
/// `Range`: This will allow the selection of a range of dates. This automatically ignores the attribute of `optionPickerStyle`, hence selection of multiple year and time is currently not available.
///
/// - Note:
/// Selection styles will only affect date selection. It is currently not possible to select multiple/range
@objc public enum SSCalendarTimeSelectorSelection: Int {
    /// Single Selection.
    case single
    /// Multiple Selection. Year and Time interface not available.
    case multiple
    /// Range Selection. Year and Time interface not available.
    case range
}

/// Set `optionMultipleSelectionGrouping` with one of the following:
///
/// `Simple`: No grouping for multiple selection. Selected dates are displayed as individual circles.
///
/// `Pill`: This is the default. Pill-like grouping where dates are grouped only if they are adjacent to each other (+- 1 day).
///
/// `LinkedBalls`: Smaller circular selection, with a bar connecting adjacent dates.
@objc public enum SSCalendarTimeSelectorMultipleSelectionGrouping: Int {
    /// Displayed as individual circular selection
    case simple
    /// Rounded rectangular grouping
    case pill
    /// Individual circular selection with a bar between adjacent dates
    case linkedBalls
}

/// Set `optionTimeStep` to customise the period of time which the users will be able to choose. The step will show the user the available minutes to select (with exception of `OneMinute` step, see *Note*).
///
/// - Note:
/// Setting `optionTimeStep` to `OneMinute` will show the clock face with minutes on intervals of 5 minutes.
/// In between the intervals will be empty space. Users will however be able to adjust the minute hand into the intervals of those 5 minutes.
///
/// - Note:
/// Setting `optionTimeStep` to `SixtyMinutes` will disable the minutes selection entirely.
@objc public enum SSCalendarTimeSelectorTimeStep: Int {
    /// 1 Minute interval, but clock will display intervals of 5 minutes.
    case oneMinute = 1
    /// 5 Minutes interval.
    case fiveMinutes = 5
    /// 10 Minutes interval.
    case tenMinutes = 10
    /// 15 Minutes interval.
    case fifteenMinutes = 15
    /// 30 Minutes interval.
    case thirtyMinutes = 30
    /// Disables the selection of minutes.
    case sixtyMinutes = 60
}

@objc open class SSCalendarTimeSelectorDateRange: NSObject {
    fileprivate(set) open var start: Date = Date().beginningOfDay
    fileprivate(set) open var end: Date = Date().beginningOfDay
    open var array: [Date] {
        var dates: [Date] = []
        var i = start.beginningOfDay
        let j = end.beginningOfDay
        while i.compare(j) != .orderedDescending {
            dates.append(i)
            i = i + 1.day
        }
        return dates
    }
    
    open func setStartDate(_ date: Date) {
        start = date.beginningOfDay
        if start.compare(end) == .orderedDescending {
            end = start
        }
    }
    
    open func setEndDate(_ date: Date) {
        end = date.beginningOfDay
        if start.compare(end) == .orderedDescending {
            start = end
        }
    }
}

/// The delegate of `SSCalendarTimeSelector` can adopt the `SSCalendarTimeSelectorProtocol` optional methods. The following Optional methods are available:
///
/// `SSCalendarTimeSelectorDone:selector:dates:`
/// `SSCalendarTimeSelectorDone:selector:date:`
/// `SSCalendarTimeSelectorCancel:selector:dates:`
/// `SSCalendarTimeSelectorCancel:selector:date:`
/// `SSCalendarTimeSelectorWillDismiss:selector:`
/// `SSCalendarTimeSelectorDidDismiss:selector:`
@objc public protocol SSCalendarTimeSelectorProtocol {
    
    /// Method called before the selector is dismissed, and when user is Done with the selector.
    ///
    /// This method is only called when `optionMultipleSelection` is `true`.
    ///
    /// - SeeAlso:
    /// `SSCalendarTimeSelectorDone:selector:date:`
    ///
    /// - Parameters:
    ///     - selector: The selector that will be dismissed.
    ///     - dates: Selected dates.
    @objc optional func SSCalendarTimeSelectorDone(_ selector: SSCalendarTimeSelector, dates: [Date])
    
    /// Method called before the selector is dismissed, and when user is Done with the selector.
    ///
    /// This method is only called when `optionMultipleSelection` is `false`.
    ///
    /// - SeeAlso:
    /// `SSCalendarTimeSelectorDone:selector:dates:`
    ///
    /// - Parameters:
    ///     - selector: The selector that will be dismissed.
    ///     - dates: Selected date.
    @objc optional func SSCalendarTimeSelectorDone(_ selector: SSCalendarTimeSelector, date: Date)
    
    /// Method called before the selector is dismissed, and when user Cancel the selector.
    ///
    /// This method is only called when `optionMultipleSelection` is `true`.
    ///
    /// - SeeAlso:
    /// `SSCalendarTimeSelectorCancel:selector:date:`
    ///
    /// - Parameters:
    ///     - selector: The selector that will be dismissed.
    ///     - dates: Selected dates.
    @objc optional func SSCalendarTimeSelectorCancel(_ selector: SSCalendarTimeSelector, dates: [Date])
    
    /// Method called before the selector is dismissed, and when user Cancel the selector.
    ///
    /// This method is only called when `optionMultipleSelection` is `false`.
    ///
    /// - SeeAlso:
    /// `SSCalendarTimeSelectorCancel:selector:dates:`
    ///
    /// - Parameters:
    ///     - selector: The selector that will be dismissed.
    ///     - dates: Selected date.
    @objc optional func SSCalendarTimeSelectorCancel(_ selector: SSCalendarTimeSelector, date: Date)
    
    /// Method called before the selector is dismissed.
    ///
    /// - SeeAlso:
    /// `SSCalendarTimeSelectorDidDismiss:selector:`
    ///
    /// - Parameters:
    ///     - selector: The selector that will be dismissed.
    @objc optional func SSCalendarTimeSelectorWillDismiss(_ selector: SSCalendarTimeSelector)
    
    /// Method called after the selector is dismissed.
    ///
    /// - SeeAlso:
    /// `SSCalendarTimeSelectorWillDismiss:selector:`
    ///
    /// - Parameters:
    ///     - selector: The selector that has been dismissed.
    @objc optional func SSCalendarTimeSelectorDidDismiss(_ selector: SSCalendarTimeSelector)
    
    /// Method if implemented, will be used to determine if a particular date should be selected.
    ///
    /// - Parameters:
    ///     - selector: The selector that is checking for selectablity of date.
    ///     - date: The date that user tapped, but have not yet given feedback to determine if should be selected.
    @objc optional func SSCalendarTimeSelectorShouldSelectDate(_ selector: SSCalendarTimeSelector, date: Date) -> Bool
}

open class SSCalendarTimeSelector: UIViewController, UITableViewDelegate, UITableViewDataSource,SSCalendarRowProtocol, SSClockProtocol,createdListDelegate, EditPriceDelegate {
    
    /// The delegate of `SSCalendarTimeSelector` can adopt the `SSCalendarTimeSelectorProtocol` optional methods. The following Optional methods are available:
    ///
    /// `SSCalendarTimeSelectorDone:selector:dates:`
    /// `SSCalendarTimeSelectorDone:selector:date:`
    /// `SSCalendarTimeSelectorCancel:selector:dates:`
    /// `SSCalendarTimeSelectorCancel:selector:date:`
    /// `SSCalendarTimeSelectorWillDismiss:selector:`
    /// `SSCalendarTimeSelectorDidDismiss:selector:`
    open var delegate: SSCalendarTimeSelectorProtocol?
    
    
    //MARK:
    open var arrBlockedDates : NSArray = NSArray()
    open var arrReservedDates : NSArray = NSArray()
    open var arrNightlyPrice : NSArray = NSArray()
    
    open var arrRoomList : NSMutableArray = NSMutableArray()
    open var strSelectedRoomId = ""
    open var strRoomPrice = ""
    open var nSelectedIndex : Int = 0
    open var nSelectionIndex : Int = 0
    open var strRoomCurrencySymbol = ""
    open var strRoomCurrencyCode = ""
    
    open var cellIdentifierNew = "cell"
    
    
    /// A convenient identifier object. Not used by `SSCalendarTimeSelector`.
    open var optionIdentifier: AnyObject?
    
    /// Set `optionPickerStyle` with one or more of the following:
    ///
    /// `DateMonth`: This shows the the date and month.
    ///
    /// `Year`: This shows the year.
    ///
    /// `Time`: This shows the clock, users will be able to select hour and minutes as well as am or pm.
    ///
    /// - Note:
    /// `optionPickerStyle` should contain at least 1 of the following style. It will default to all styles should there be none in the option specified.
    ///
    /// - Note:
    /// Defaults to all styles.
    open var optionStyles: SSCalendarTimeSelectorStyle = SSCalendarTimeSelectorStyle()
    
    /// Set `optionTimeStep` to customise the period of time which the users will be able to choose. The step will show the user the available minutes to select (with exception of `OneMinute` step, see *Note*).
    ///
    /// - Note:
    /// Setting `optionTimeStep` to `OneMinute` will show the clock face with minutes on intervals of 5 minutes.
    /// In between the intervals will be empty space. Users will however be able to adjust the minute hand into the intervals of those 5 minutes.
    ///
    /// - Note:
    /// Setting `optionTimeStep` to `SixtyMinutes` will disable the minutes selection entirely.
    ///
    /// - Note:
    /// Defaults to `OneMinute`.
    open var optionTimeStep: SSCalendarTimeSelectorTimeStep = .oneMinute
    
    /// Set to `true` will show the entire selector at the top. If you only wish to hide the *title bar*, see `optionShowTopPanel`. Set to `false` will hide the entire top container.
    ///
    /// - Note:
    /// Defaults to `true`.
    ///
    /// - SeeAlso:
    /// `optionShowTopPanel`.
    open var optionShowTopContainer: Bool = true
    
    /// Set to `true` to show the weekday name *or* `optionTopPanelTitle` if specified at the top of the selector. Set to `false` will hide the entire panel.
    ///
    /// - Note:
    /// Defaults to `true`.
    open var optionShowTopPanel = true
    
    /// Set to nil to show default title. Depending on `privateOptionStyles`, default titles are either **Select Multiple Dates**, **(Capitalized Weekday Full Name)** or **(Capitalized Month Full Name)**.
    ///
    /// - Note:
    /// Defaults to `nil`.
    open var optionTopPanelTitle: String? = nil
    
    /// Set `optionSelectionType` with one of the following:
    ///
    /// `Single`: This will only allow the selection of a single date. If applicable, this also allows selection of year and time.
    ///
    /// `Multiple`: This will allow the selection of multiple dates. This automatically ignores the attribute of `optionPickerStyle`, hence selection of multiple year and time is currently not available.
    ///
    /// `Range`: This will allow the selection of a range of dates. This automatically ignores the attribute of `optionPickerStyle`, hence selection of multiple year and time is currently not available.
    ///
    /// - Note:
    /// Selection styles will only affect date selection. It is currently not possible to select multiple/range
    open var optionSelectionType: SSCalendarTimeSelectorSelection = .single
    
    /// Set to default date when selector is presented.
    ///
    /// - SeeAlso:
    /// `optionCurrentDates`
    ///
    /// - Note:
    /// Defaults to current date and time, with time rounded off to the nearest hour.
    open var optionCurrentDate = Date().minute < 30 ? Date().beginningOfHour : Date().beginningOfHour + 1.hour
    
    /// Set the default dates when selector is presented.
    ///
    /// - SeeAlso:
    /// `optionCurrentDate`
    ///
    /// - Note:
    /// Selector will show the earliest selected date's month by default.
    open var optionCurrentDates: Set<Date> = []
    
    /// Set the default dates when selector is presented.
    ///
    /// - SeeAlso:
    /// `optionCurrentDate`
    ///
    /// - Note:
    /// Selector will show the earliest selected date's month by default.
    open var optionCurrentDateRange: SSCalendarTimeSelectorDateRange = SSCalendarTimeSelectorDateRange()
    
    /// Set the background blur effect, where background is a `UIVisualEffectView`. Available options are as `UIBlurEffectStyle`:
    ///
    /// `Dark`
    ///
    /// `Light`
    ///
    /// `ExtraLight`
    open var optionStyleBlurEffect: UIBlurEffectStyle = .dark
    
    /// Set `optionMultipleSelectionGrouping` with one of the following:
    ///
    /// `Simple`: No grouping for multiple selection. Selected dates are displayed as individual circles.
    ///
    /// `Pill`: This is the default. Pill-like grouping where dates are grouped only if they are adjacent to each other (+- 1 day).
    ///
    /// `LinkedBalls`: Smaller circular selection, with a bar connecting adjacent dates.
    open var optionMultipleSelectionGrouping: SSCalendarTimeSelectorMultipleSelectionGrouping = .pill
    
    
    // Fonts & Colors
    open var optionCalendarFontMonth = UIFont (name: "CircularAirPro-Book", size: 16)
    open var optionCalendarFontDays = UIFont (name: "CircularAirPro-Book", size: 12)
    open var optionCalendarFontToday = UIFont (name: "CircularAirPro-Book", size: 16)
    open var optionCalendarFontTodayHighlight = UIFont (name: "CircularAirPro-Book", size: 16)
    open var optionCalendarFontPastDates = UIFont (name: "CircularAirPro-Book", size: 16)
    open var optionCalendarFontPastDatesHighlight = UIFont (name: "CircularAirPro-Book", size: 16)
    open var optionCalendarFontFutureDates = UIFont (name: "CircularAirPro-Book", size: 16)
    open var optionCalendarFontFutureDatesHighlight = UIFont (name: "CircularAirPro-Book", size: 16)
    
    open var optionCalendarFontColorMonth = UIColor.darkGray
    open var optionCalendarFontColorDays = UIColor.darkGray
    open var optionCalendarFontColorToday = UIColor.darkGray
    open var optionCalendarFontColorTodayHighlight = UIColor.white
    open var optionCalendarBackgroundColorTodayHighlight = UIColor.darkGray
    open var optionCalendarBackgroundColorTodayFlash = UIColor.darkGray
    open var optionCalendarFontColorPastDates = UIColor.darkGray.withAlphaComponent(0.5)
    open var optionCalendarFontColorPastDatesHighlight = UIColor.darkGray
    open var optionCalendarBackgroundColorPastDatesHighlight = UIColor.brown
    open var optionCalendarBackgroundColorPastDatesFlash = UIColor.darkGray
    open var optionCalendarFontColorFutureDates = UIColor.darkGray
    open var optionCalendarFontColorFutureDatesHighlight = UIColor.white
    open var optionCalendarBackgroundColorFutureDatesHighlight = UIColor.darkGray
    open var optionCalendarBackgroundColorFutureDatesFlash = UIColor.black
    
    open var optionCalendarFontCurrentYear = UIFont (name: "CircularAirPro-Book", size: 16)
    open var optionCalendarFontCurrentYearHighlight = UIFont.boldSystemFont(ofSize: 20)
    open var optionCalendarFontColorCurrentYear = UIColor.darkGray
    open var optionCalendarFontColorCurrentYearHighlight = UIColor.black
    open var optionCalendarFontPastYears = UIFont.boldSystemFont(ofSize: 18)
    open var optionCalendarFontPastYearsHighlight = UIFont.boldSystemFont(ofSize: 20)
    open var optionCalendarFontColorPastYears = UIColor.darkGray
    open var optionCalendarFontColorPastYearsHighlight = UIColor.black
    open var optionCalendarFontFutureYears = UIFont.boldSystemFont(ofSize: 18)
    open var optionCalendarFontFutureYearsHighlight = UIFont.boldSystemFont(ofSize: 20)
    open var optionCalendarFontColorFutureYears = UIColor.darkGray
    open var optionCalendarFontColorFutureYearsHighlight = UIColor.black
    
    open var optionClockFontAMPM = UIFont.systemFont(ofSize: 18)
    open var optionClockFontAMPMHighlight = UIFont.systemFont(ofSize: 20)
    open var optionClockFontColorAMPM = UIColor.black
    open var optionClockFontColorAMPMHighlight = UIColor.white
    open var optionClockBackgroundColorAMPMHighlight = UIColor.brown
    open var optionClockFontHour = UIFont.systemFont(ofSize: 16)
    open var optionClockFontHourHighlight = UIFont.systemFont(ofSize: 18)
    open var optionClockFontColorHour = UIColor.black
    open var optionClockFontColorHourHighlight = UIColor.white
    open var optionClockBackgroundColorHourHighlight = UIColor.brown
    open var optionClockBackgroundColorHourHighlightNeedle = UIColor.brown
    open var optionClockFontMinute = UIFont.systemFont(ofSize: 12)
    open var optionClockFontMinuteHighlight = UIFont.systemFont(ofSize: 14)
    open var optionClockFontColorMinute = UIColor.black
    open var optionClockFontColorMinuteHighlight = UIColor.white
    open var optionClockBackgroundColorMinuteHighlight = UIColor.brown
    open var optionClockBackgroundColorMinuteHighlightNeedle = UIColor.brown
    open var optionClockBackgroundColorFace = UIColor(white: 0.9, alpha: 1)
    open var optionClockBackgroundColorCenter = UIColor.black
    
    open var optionButtonTitleDone: String = "Done"
    open var optionButtonTitleCancel: String = "Cancel"
    open var optionButtonFontCancel = UIFont.systemFont(ofSize: 16)
    open var optionButtonFontDone = UIFont.boldSystemFont(ofSize: 16)
    open var optionButtonFontColorCancel = UIColor.brown
    open var optionButtonFontColorDone = UIColor.brown
    open var optionButtonFontColorCancelHighlight = UIColor.brown.withAlphaComponent(0.25)
    open var optionButtonFontColorDoneHighlight = UIColor.brown.withAlphaComponent(0.25)
    open var optionButtonBackgroundColorCancel = UIColor.clear
    open var optionButtonBackgroundColorDone = UIColor.clear
    
    open var optionTopPanelBackgroundColor = UIColor.brown
    open var optionTopPanelFont = UIFont.systemFont(ofSize: 16)
    open var optionTopPanelFontColor = UIColor.white
    
    open var optionSelectorPanelFontMonth = UIFont.systemFont(ofSize: 16)
    open var optionSelectorPanelFontDate = UIFont.systemFont(ofSize: 16)
    open var optionSelectorPanelFontYear = UIFont.systemFont(ofSize: 16)
    open var optionSelectorPanelFontTime = UIFont.systemFont(ofSize: 16)
    open var optionSelectorPanelFontMultipleSelection = UIFont.systemFont(ofSize: 16)
    open var optionSelectorPanelFontMultipleSelectionHighlight = UIFont.systemFont(ofSize: 17)
    open var optionSelectorPanelFontColorMonth = UIColor(white: 1, alpha: 0.5)
    open var optionSelectorPanelFontColorMonthHighlight = UIColor.white
    
    open var optionSelectorPanelFontColorDate = UIColor.white.withAlphaComponent(0.5)
    open var optionSelectorPanelFontColorDateHighlight = UIColor.white
    
    open var optionSelectorPanelFontColorYear = UIColor(white: 1, alpha: 0.5)
    open var optionSelectorPanelFontColorYearHighlight = UIColor.white
    open var optionSelectorPanelFontColorTime = UIColor(white: 1, alpha: 0.5)
    open var optionSelectorPanelFontColorTimeHighlight = UIColor.white
    open var optionSelectorPanelFontColorMultipleSelection = UIColor.white
    open var optionSelectorPanelFontColorMultipleSelectionHighlight = UIColor.white
    open var optionSelectorPanelBackgroundColor = UIColor.brown.withAlphaComponent(0.9)
    
    open var optionMainPanelBackgroundColor = UIColor.white
    open var optionBottomPanelBackgroundColor = UIColor.white
    
    /// This is the month's offset when user is in selection of dates mode. A positive number will adjusts the month higher, while a negative number will adjust the month lower.
    ///
    /// - Note:
    /// Defaults to 30.
    open var optionSelectorPanelOffsetHighlightMonth: CGFloat = 30
    
    /// This is the date's offset when user is in selection of dates mode. A positive number will adjusts the date lower, while a negative number will adjust the date higher.
    ///
    /// - Note:
    /// Defaults to 24.
    open var optionSelectorPanelOffsetHighlightDate: CGFloat = 24
    
    /// This is the scale of the month when it is in active view.
    open var optionSelectorPanelScaleMonth: CGFloat = 2.5
    open var optionSelectorPanelScaleDate: CGFloat = 4.5
    open var optionSelectorPanelScaleYear: CGFloat = 4
    open var optionSelectorPanelScaleTime: CGFloat = 2.75
    
    /// This is the height calendar's "title bar". If you wish to hide the Top Panel, consider `optionShowTopPanel`
    ///
    /// - SeeAlso:
    /// `optionShowTopPanel`
    open var optionLayoutTopPanelHeight: CGFloat = 28
    
    /// The height of the calendar in portrait mode. This will be translated automatically into the width in landscape mode.
    open var optionLayoutHeight: CGFloat?
    
    /// The width of the calendar in portrait mode. This will be translated automatically into the height in landscape mode.
    open var optionLayoutWidth: CGFloat?
    
    /// If optionLayoutHeight is not defined, this ratio is used on the screen's height.
    open var optionLayoutHeightRatio: CGFloat = 0.9
    
    /// If optionLayoutWidth is not defined, this ratio is used on the screen's width.
    open var optionLayoutWidthRatio: CGFloat = 0.85
    
    /// When calendar is in portrait mode, the ratio of *Top Container* to *Bottom Container*.
    ///
    /// - Note: Defaults to 7 / 20
    open var optionLayoutPortraitRatio: CGFloat = 7/20
    
    /// When calendar is in landscape mode, the ratio of *Top Container* to *Bottom Container*.
    ///
    /// - Note: Defaults to 3 / 8
    open var optionLayoutLandscapeRatio: CGFloat = 3/8
    
    @IBOutlet var btnCancel: UIButton!
    @IBOutlet var lblNoListingNote: UILabel!
    @IBOutlet var lblNoListing: UILabel!
    @IBOutlet var btnNightlyPrice: UIButton!
    // All Views
    @IBOutlet fileprivate weak var topContainerView: UIView!
    @IBOutlet fileprivate weak var bottomContainerView: UIView!
    @IBOutlet fileprivate weak var backgroundDayView: UIView!
    @IBOutlet fileprivate weak var backgroundRangeView: UIView!
    @IBOutlet fileprivate weak var backgroundContentView: UIView!
    @IBOutlet fileprivate weak var backgroundButtonsView: UIView!
    @IBOutlet fileprivate weak var cancelButton: UIButton!
    @IBOutlet fileprivate weak var doneButton: UIButton!
    @IBOutlet fileprivate weak var selDateView: UIView!
    @IBOutlet fileprivate weak var dayLabel: UILabel!
    @IBOutlet fileprivate weak var monthLabel: UILabel!
    @IBOutlet fileprivate weak var dateLabel: UILabel!
    @IBOutlet fileprivate weak var yearLabel: UILabel!
    @IBOutlet fileprivate weak var timeLabel: UILabel!
    @IBOutlet fileprivate weak var rangeStartLabel: UILabel!
    @IBOutlet fileprivate weak var rangeToLabel: UILabel!
    @IBOutlet fileprivate weak var rangeEndLabel: UILabel!
    @IBOutlet fileprivate weak var calendarTable: UITableView!
    
    @IBOutlet fileprivate var btnAvailable: UIButton!
    @IBOutlet fileprivate var btnBlocked: UIButton!
    @IBOutlet fileprivate weak var viewAvailableHolder: UIView!
    @IBOutlet fileprivate weak var imgRoom: UIImageView!
    @IBOutlet fileprivate weak var lblRoomName: UILabel!
    @IBOutlet fileprivate weak var btnSaveChanges: UIView!
    @IBOutlet fileprivate weak var lblRoomPrice: UILabel!
    @IBOutlet fileprivate weak var lblSaving: UILabel!
    @IBOutlet fileprivate var btnAddListing: UIButton!
    @IBOutlet fileprivate weak var viewNoListing: UIView!
    @IBOutlet fileprivate weak var vwListLayer: UIView!
    @IBOutlet fileprivate weak var tblList:UITableView!
    
    fileprivate var isDateBlocked : Bool = false
    fileprivate var isRoomPriceChanged : Bool = false
    
    //    @IBOutlet fileprivate weak var viewGradient: UIView!
    
    @IBOutlet fileprivate weak var yearTable: UITableView!
    @IBOutlet fileprivate weak var clockView: SSClock!
    @IBOutlet fileprivate weak var monthsView: UIView!
    @IBOutlet fileprivate var monthsButtons: [UIButton]!
    
    // All Constraints
    @IBOutlet fileprivate weak var dayViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet fileprivate weak var topContainerTopConstraint: NSLayoutConstraint!
    @IBOutlet fileprivate weak var topContainerLeftConstraint: NSLayoutConstraint!
    @IBOutlet fileprivate weak var topContainerWidthConstraint: NSLayoutConstraint!
    @IBOutlet fileprivate weak var topContainerHeightConstraint: NSLayoutConstraint!
    @IBOutlet fileprivate weak var bottomContainerTopConstraint: NSLayoutConstraint!
    @IBOutlet fileprivate weak var bottomContainerLeftConstraint: NSLayoutConstraint!
    @IBOutlet fileprivate weak var bottomContainerWidthConstraint: NSLayoutConstraint!
    @IBOutlet fileprivate weak var bottomContainerHeightConstraint: NSLayoutConstraint!
    @IBOutlet fileprivate weak var selMonthXConstraint: NSLayoutConstraint!
    @IBOutlet fileprivate weak var selMonthYConstraint: NSLayoutConstraint!
    @IBOutlet fileprivate weak var selDateXConstraint: NSLayoutConstraint!
    @IBOutlet fileprivate weak var selDateYConstraint: NSLayoutConstraint!
    @IBOutlet fileprivate weak var selDateTopConstraint: NSLayoutConstraint!
    @IBOutlet fileprivate weak var selDateLeftConstraint: NSLayoutConstraint!
    @IBOutlet fileprivate weak var selDateRightConstraint: NSLayoutConstraint!
    @IBOutlet fileprivate weak var selDateHeightConstraint: NSLayoutConstraint!
    @IBOutlet fileprivate weak var selYearTopConstraint: NSLayoutConstraint!
    @IBOutlet fileprivate weak var selYearLeftConstraint: NSLayoutConstraint!
    @IBOutlet fileprivate weak var selYearRightConstraint: NSLayoutConstraint!
    @IBOutlet fileprivate weak var selYearHeightConstraint: NSLayoutConstraint!
    @IBOutlet fileprivate weak var selTimeTopConstraint: NSLayoutConstraint!
    @IBOutlet fileprivate weak var selTimeLeftConstraint: NSLayoutConstraint!
    @IBOutlet fileprivate weak var selTimeRightConstraint: NSLayoutConstraint!
    @IBOutlet fileprivate weak var selTimeHeightConstraint: NSLayoutConstraint!
    
    // Private Variables
    fileprivate let selAnimationDuration: TimeInterval = 0.4
    fileprivate let selInactiveHeight: CGFloat = 48
    fileprivate var portraitContainerWidth: CGFloat { return optionLayoutWidth ?? optionLayoutWidthRatio * portraitWidth }
    fileprivate var portraitTopContainerHeight: CGFloat { return optionShowTopContainer ? (optionLayoutHeight ?? optionLayoutHeightRatio * portraitHeight) * optionLayoutPortraitRatio : 0 }
    fileprivate var portraitBottomContainerHeight: CGFloat { return (optionLayoutHeight ?? optionLayoutHeightRatio * portraitHeight) - portraitTopContainerHeight }
    fileprivate var landscapeContainerHeight: CGFloat { return optionLayoutWidth ?? optionLayoutWidthRatio * portraitWidth }
    fileprivate var landscapeTopContainerWidth: CGFloat { return optionShowTopContainer ? (optionLayoutHeight ?? optionLayoutHeightRatio * portraitHeight) * optionLayoutLandscapeRatio : 0 }
    fileprivate var landscapeBottomContainerWidth: CGFloat { return (optionLayoutHeight ?? optionLayoutHeightRatio * portraitHeight) - landscapeTopContainerWidth }
    fileprivate var selCurrrent: SSCalendarTimeSelectorStyle = SSCalendarTimeSelectorStyle(isSingular: true)
    fileprivate var isFirstLoad = false
    fileprivate var selTimeStateHour = true
    fileprivate var calRow1Type: SSCalendarRowType = SSCalendarRowType.date
    fileprivate var calRow2Type: SSCalendarRowType = SSCalendarRowType.date
    fileprivate var calRow3Type: SSCalendarRowType = SSCalendarRowType.date
    fileprivate var calRow1StartDate: Date = Date()
    fileprivate var calRow2StartDate: Date = Date()
    fileprivate var calRow3StartDate: Date = Date()
    fileprivate var yearRow1: Int = 2016
    fileprivate var multipleDates: [Date] { return optionCurrentDates.sorted(by: { $0.compare($1) == ComparisonResult.orderedAscending }) }
    fileprivate var multipleDatesLastAdded: Date?
    fileprivate var flashDate: Date?
    fileprivate let defaultTopPanelTitleForMultipleDates = "Select Multiple Dates"
    fileprivate let portraitHeight: CGFloat = max(UIScreen.main.bounds.height, UIScreen.main.bounds.width)
    fileprivate let portraitWidth: CGFloat = min(UIScreen.main.bounds.height, UIScreen.main.bounds.width)
    fileprivate var isSelectingStartRange: Bool = true { didSet { rangeStartLabel.textColor = isSelectingStartRange ?  optionSelectorPanelFontColorDate: optionSelectorPanelFontColorDateHighlight;
        rangeEndLabel.textColor = isSelectingStartRange ?  optionSelectorPanelFontColorDateHighlight: optionSelectorPanelFontColorDate } }
    fileprivate var shouldResetRange: Bool = true
    
    /// Only use this method to instantiate the selector. All customization should be done before presenting the selector to the user.
    /// To receive callbacks from selector, set the `delegate` of selector and implement `SSCalendarTimeSelectorProtocol`.
    ///
    ///     let selector = SSCalendarTimeSelector.instantiate()
    ///     selector.delegate = self
    ///     presentViewController(selector, animated: true, completion: nil)
    ///
    
    fileprivate let weekDays = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"]
    
    open static func instantiate() -> SSCalendarTimeSelector {
        let podBundle = Bundle(for: self.classForCoder())
        let bundleURL = podBundle.url(forResource: "SSCalendarTimeSelectorStoryboardBundle", withExtension: "bundle")
        var bundle: Bundle?
        if let bundleURL = bundleURL {
            bundle = Bundle(url: bundleURL)
        }
        return UIStoryboard(name: "SSCalendarTimeSelector", bundle: bundle).instantiateInitialViewController() as! SSCalendarTimeSelector
    }
    
    open override func awakeFromNib() {
        super.awakeFromNib()
        modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        modalTransitionStyle = UIModalTransitionStyle.crossDissolve
    }
    
    // MARK:- View Method(s)
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        self.lblSaving.isHidden = true
        viewAvailableHolder.isHidden = true
        btnBlocked.backgroundColor = UIColor.clear
        let seventhRowStartDate = optionCurrentDate.beginningOfMonth
        calRow3StartDate = ((seventhRowStartDate - 1.day).beginningOfWeek - 1.day).beginningOfWeek
        calRow2StartDate = (calRow3StartDate - 1.day).beginningOfWeek
        calRow1StartDate = (calRow2StartDate - 1.day).beginningOfWeek
        let rect = UIScreen.main.bounds as CGRect
        var rectStartBtn = btnAddListing.frame
        rectStartBtn.origin.y = rect.size.height-btnAddListing.frame.size.height-50
        btnAddListing.frame = rectStartBtn
        btnAddListing.isHidden = true
        viewNoListing.isHidden = true
        yearRow1 = optionCurrentDate.year - 5
        calendarTable.setContentOffset(CGPoint(x: 0, y:300), animated:true)
        view.layoutIfNeeded()
        UIDevice.current.beginGeneratingDeviceOrientationNotifications()
        NotificationCenter.default.addObserver(self, selector: #selector(SSCalendarTimeSelector.didRotateOrNot), name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
        
        callAPIForGettingRooms()
        
        let addNewContactsingleFingerTap = UITapGestureRecognizer(target: self, action: #selector(self.handleSingleTap))
        addNewContactsingleFingerTap.cancelsTouchesInView = false
        self.view.addGestureRecognizer(addNewContactsingleFingerTap)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.callAPIForGettingRooms), name: NSNotification.Name(rawValue: "NewRoomAdded"), object: nil)
        updateDate()
        self.localization()
        isFirstLoad = true
    }
    
    open override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if isFirstLoad {
            isFirstLoad = false
            calendarTable.reloadData()
            self.didRotateOrNot()
            if optionStyles.showDateMonth {
                showDate(true)
            }
            else if optionStyles.showMonth {
                showMonth(true)
            }
            else if optionStyles.showYear {
                showYear(true)
            }
            else if optionStyles.showTime {
                showTime(true)
            }
        }
    }
    
    open override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        isFirstLoad = false
        //         appDelegate.makentTabBarCtrler.tabBar.isHidden = false
    }
    
    open override var preferredStatusBarStyle: UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }
    
    // MARK:- Gesture Recognizer Method(s)
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWithGestureRecognizer otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    func handleSingleTap(_ sender: UITapGestureRecognizer) {
        let position = sender.location(in: self.view)
        if (position.y > ((appDelegate?.window?.frame.size.height)! - 50 - viewAvailableHolder.frame.size.height)) {
            if viewAvailableHolder.isHidden {
                calendarTable.setContentOffset(CGPoint(x: 0, y:position.y - calendarTable.contentOffset.y + 150), animated:true)
            } else {
            }
        }
    }
    
    // MARK:- API Calling Method(s)
    
    func callAPIForGettingRooms() {
        ProgressHud.shared.Animation = true
        self.calendarTable.isHidden = false
        ServerAPI.sharedInstance.makeCall(requestMethod: "GET", apiName: API_CALENDER_ROOMS_LIST, params: NSMutableDictionary(), isTokenRequired: true, forSuccessionBlock: { (response, error) in
            OperationQueue.main.addOperation {
                if(error != nil){
                    self.btnAddListing.isHidden = false
                    self.viewNoListing.isHidden = false
                    self.bottomContainerView.isHidden = true
                    self.btnAddListing.isHidden = false
                }else{
                    if response != nil {
                        let result = response as! NSDictionary
                        if self.arrRoomList.count > 0 {
                            self.arrRoomList.removeAllObjects()
                        }
                        self.calendarTable.isHidden = false
                        let data = result["data"] as! NSArray
                        self.arrRoomList = ListingModel().initiateListingData(jsonData: data) as! NSMutableArray
                        self.calendarTable.delegate = self
                        self.calendarTable.dataSource = self
                        self.onCreateListTapped(index: 0)
                        self.calendarTable.reloadData()
                        self.bottomContainerView.isHidden = false
                        self.btnAddListing.isHidden = true
                        self.viewNoListing.isHidden = true
                    }
                }
                ProgressHud.shared.Animation = false
            }
        }) { (error) in
            ProgressHud.shared.Animation = false
        }
    }
    
    func callBlockedDataAPI(_ selectedDates :  NSMutableArray) {
        let dicts = NSMutableDictionary()
        dicts["room_id"]    = strSelectedRoomId
        dicts["nightly_price"] = strRoomPrice
        dicts["blocked_dates"] = getSelectedDates().componentsJoined(by: ",")
        dicts["is_avaliable_selected"] = (btnAvailable.isSelected) ? "Yes" : "No"
        
        ServerAPI.sharedInstance.makeCall(requestMethod: "GET", apiName: API_BLOCK_DATES, params: dicts, isTokenRequired: true, forSuccessionBlock: { (response, error) in
            OperationQueue.main.addOperation {
                if (error != nil){
                    self.lblSaving.isHidden = true
                }else{
                    if response != nil {
                        let result = response as! NSDictionary
                        self.nSelectedIndex = self.nSelectedIndex + self.arrRoomList.count
                        self.lblSaving.text = "Saved..."
                        let arrData = result["blocked_dates"] as! NSArray
                        if arrData.count > 0 {
                            self.arrBlockedDates = arrData
                        }
                        if result["reserved_dates"] != nil {
                            let arrReservedData = result["reserved_dates"] as! NSArray
                            if arrReservedData.count > 0 {
                                self.arrReservedDates = arrReservedData
                            }
                        }
                        if result["nightly_price"] != nil {
                            let arrNightlyData = result["nightly_price"] as! NSArray
                            if arrNightlyData.count > 0 {
                                self.arrNightlyPrice = arrNightlyData
                            }
                        }
                        self.makeNewTable(self.arrBlockedDates)
                        Timer.scheduledTimer(timeInterval: 2.0, target: self, selector: #selector(self.onRemoveLabel), userInfo: nil, repeats: false)
                        self.updateRoomInfo(reservedDates: self.arrReservedDates, nightlyPrice: self.arrNightlyPrice )
                    }
                }
                self.isRoomPriceChanged = false
            }
        }) { (Error) in
            OperationQueue.main.addOperation {
                self.lblSaving.text = "Error!!!"
                Timer.scheduledTimer(timeInterval: 2.0, target: self, selector: #selector(self.onRemoveLabel), userInfo: nil, repeats: false)
                self.isRoomPriceChanged = false
            }
        }
    }
    
    // MARK:- Device Orientation Method(s)
    
    internal func didRotateOrNot() {
        let orientation = UIApplication.shared.statusBarOrientation
        if orientation == .landscapeLeft || orientation == .landscapeRight || orientation == .portrait || orientation == .portraitUpsideDown {
            UIView.animate(
                withDuration: selAnimationDuration,
                delay: 0,
                usingSpringWithDamping: 0.8,
                initialSpringVelocity: 0,
                options: [UIViewAnimationOptions.allowAnimatedContent, UIViewAnimationOptions.allowUserInteraction],
                animations: {
                    self.view.layoutIfNeeded()
            },
                completion: nil
            )
            
            if selCurrrent.showDateMonth {
                showDate(false)
            }
            else if selCurrrent.showMonth {
                showMonth(false)
            }
            else if selCurrrent.showYear {
                showYear(false)
            }
            else if selCurrrent.showTime {
                showTime(false)
            }
        }
    }
    
    open override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.all
    }
    
    open override var shouldAutorotate: Bool {
        return false
    }
    
    // MARK:- IBOutlet Method(s)
    
    @IBAction func selectMonth(_ sender: UIButton) {
        let date = (optionCurrentDate.beginningOfYear + sender.tag.months).beginningOfDay
        if delegate?.SSCalendarTimeSelectorShouldSelectDate?(self, date: date) ?? true {
            optionCurrentDate = optionCurrentDate.change(year: date.year, month: date.month, day: date.day).beginningOfDay
            updateDate()
        }
    }
    
    @IBAction func selectStartRange() {
        if isSelectingStartRange == true {
            let date = optionCurrentDateRange.start
            let seventhRowStartDate = date.beginningOfMonth
            calRow3StartDate = ((seventhRowStartDate - 1.day).beginningOfWeek - 1.day).beginningOfWeek
            calRow2StartDate = (calRow3StartDate - 1.day).beginningOfWeek
            calRow1StartDate = (calRow2StartDate - 1.day).beginningOfWeek
            
            flashDate = date
            calendarTable.reloadData()
            calendarTable.scrollToRow(at: IndexPath(row: 15, section: 0), at: UITableViewScrollPosition.top, animated: true)
        } else {
            isSelectingStartRange = true
        }
        shouldResetRange = false
        updateDate()
    }
    
    @IBAction func selectEndRange() {
        if isSelectingStartRange == false {
            let date = optionCurrentDateRange.end
            
            let seventhRowStartDate = date.beginningOfMonth
            calRow3StartDate = ((seventhRowStartDate - 1.day).beginningOfWeek - 1.day).beginningOfWeek
            calRow2StartDate = (calRow3StartDate - 1.day).beginningOfWeek
            calRow1StartDate = (calRow2StartDate - 1.day).beginningOfWeek
            
            flashDate = date
            calendarTable.reloadData()
            calendarTable.scrollToRow(at: IndexPath(row: 4, section: 0), at: UITableViewScrollPosition.top, animated: true)
        } else {
            isSelectingStartRange = false
        }
        shouldResetRange = false
        updateDate()
    }
    
    @IBAction func showDate() {
        if optionStyles.showDateMonth {
            showDate(true)
        } else {
            showMonth(true)
        }
    }
    
    @IBAction func showYear() {
        showYear(true)
    }
    
    @IBAction func showTime() {
        showTime(true)
    }
    
    @IBAction func cancel() {
        let picker = self
        let del = delegate
        if optionSelectionType == .single {
            del?.SSCalendarTimeSelectorCancel?(picker, date: optionCurrentDate)
        } else {
            del?.SSCalendarTimeSelectorCancel?(picker, dates: multipleDates)
        }
        del?.SSCalendarTimeSelectorWillDismiss?(picker)
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func onCancelTapped() {
        isRoomPriceChanged = false
        if optionCurrentDates.count > 0 {
            optionCurrentDates = []
            self.calendarTable.reloadData()
        }
        self.makeViewAnimation(yPosition: self.view.frame.size.height, hidden : true)
    }
    
    @IBAction func onSaveTapped() {
        self.lblSaving.isHidden = false
        self.makeViewAnimation(yPosition: self.view.frame.size.height, hidden : true)
        callBlockedDataAPI(getSelectedDates())
        lblSaving.text = "Saving..."
    }
    
    @IBAction func onAvailabeOrBlockTapped(sender:UIButton) {
        if sender.tag == 11 {
            if isDateBlocked && optionCurrentDates.count > 1 {
                btnSaveChanges.isHidden = false
            } else {
                btnSaveChanges.isHidden = true
            }
            btnAvailable.isSelected = true
            btnBlocked.isSelected = false
            btnAvailable.backgroundColor = UIColor.white
            btnBlocked.backgroundColor = UIColor.clear
        } else {
            if isDateBlocked {
                btnSaveChanges.isHidden = true
            } else {
                btnSaveChanges.isHidden = false
            }
            btnBlocked.isSelected = true
            btnAvailable.isSelected = false
            btnAvailable.backgroundColor = UIColor.clear
            btnBlocked.backgroundColor = UIColor.white
        }
        if isRoomPriceChanged {
            btnSaveChanges.isHidden = false
        }
    }
    
    @IBAction func onAddListingTapped(sender:UIButton) {
        //        self.appDelegate.makentTabBarCtrler.selectedIndex = 2
    }
    
    @IBAction func onListTapped(sender:UIButton) {
        if arrRoomList.count > 0 {
            if !viewAvailableHolder.isHidden {
                self.onCancelTapped()
            }
            
            let viewCreateList = CreatedListVC(nibName: "CreatedListVC", bundle: nil)
            
            viewCreateList.delegate = self
            viewCreateList.arrRoomList = arrRoomList
            viewCreateList.selectedRoom_id = strSelectedRoomId
            viewCreateList.view.backgroundColor = UIColor.clear
            viewCreateList.modalPresentationStyle = UIModalPresentationStyle.overFullScreen
            present(viewCreateList, animated: false, completion: nil)
        }
    }
    
    @IBAction func onEditPrice() {
        let priceEditView = EditPriceVC(nibName: "EditPriceVC", bundle: nil)
        priceEditView.delegate = self
        priceEditView.isFromCalendar = true
        priceEditView.room_currency_code = strRoomCurrencyCode
        priceEditView.room_currency_symbol = strRoomCurrencySymbol
        priceEditView.strPrice = strRoomPrice
        priceEditView.strRoomId = strSelectedRoomId
        self.navigationController?.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(priceEditView, animated: true)
    }
    
    @IBAction func done() {
        let picker = self
        let del = delegate
        switch optionSelectionType {
        case .single:
            del?.SSCalendarTimeSelectorDone?(picker, date: optionCurrentDate)
        case .multiple:
            del?.SSCalendarTimeSelectorDone?(picker, dates: multipleDates)
        case .range:
            del?.SSCalendarTimeSelectorDone?(picker, dates: optionCurrentDateRange.array)
        }
        del?.SSCalendarTimeSelectorWillDismiss?(picker)
        dismiss(animated: true) {
            del?.SSCalendarTimeSelectorDidDismiss?(picker)
        }
    }
    
    // MARK:- Date Method(s)
    
    func getAPIDateFormat(_ date : Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = DateFormatter.Style.medium
        
        dateFormatter.timeStyle = DateFormatter.Style.none
        dateFormatter.dateFormat = "dd-MM-yyy"
        return dateFormatter.string(from: date)
    }
    
    func getSelectedDates() -> NSMutableArray {
        let selectedDates : NSMutableArray = NSMutableArray()
        let arrTempDate = Array(optionCurrentDates)
        for i in 0...optionCurrentDates.count-1 {
            selectedDates.add(getAPIDateFormat(arrTempDate[i]))
        }
        return selectedDates
    }
    
    func showDate(_ userTap: Bool) {
        changeSelDate()
        if userTap {
            let seventhRowStartDate = optionCurrentDate.beginningOfMonth
            calRow3StartDate = ((seventhRowStartDate - 1.day).beginningOfWeek - 1.day).beginningOfWeek
            calRow2StartDate = (calRow3StartDate - 1.day).beginningOfWeek
            calRow1StartDate = (calRow2StartDate - 1.day).beginningOfWeek
            calendarTable.reloadData()
            calendarTable.scrollToRow(at: IndexPath(row: 4, section: 0), at: UITableViewScrollPosition.top, animated: true)
        } else {
            calendarTable.reloadData()
        }
        UIView.animate(withDuration: selAnimationDuration,
                       delay: 0,
                       options: [UIViewAnimationOptions.allowAnimatedContent, UIViewAnimationOptions.beginFromCurrentState, UIViewAnimationOptions.allowUserInteraction, UIViewAnimationOptions.curveEaseOut],
                       animations: {
                        self.calendarTable.alpha = 1
        },
                       completion: nil
        )
    }
    
    fileprivate func showMonth(_ userTap: Bool) {
        changeSelMonth()
        
        if userTap {
            
        } else {
            
        }
        
        UIView.animate(
            withDuration: selAnimationDuration,
            delay: 0,
            options: [UIViewAnimationOptions.allowAnimatedContent, UIViewAnimationOptions.beginFromCurrentState, UIViewAnimationOptions.allowUserInteraction, UIViewAnimationOptions.curveEaseOut],
            animations: {
                self.calendarTable.alpha = 0
                self.monthsView.alpha = 1
                self.yearTable.alpha = 0
                self.clockView.alpha = 0
        },
            completion: nil
        )
    }
    
    fileprivate func showYear(_ userTap: Bool) {
        changeSelYear()
        
        if userTap {
            yearRow1 = optionCurrentDate.year - 5
            yearTable.reloadData()
            yearTable.scrollToRow(at: IndexPath(row: 3, section: 0), at: UITableViewScrollPosition.top, animated: true)
        } else {
            yearTable.reloadData()
        }
        
        UIView.animate(
            withDuration: selAnimationDuration,
            delay: 0,
            options: [UIViewAnimationOptions.allowAnimatedContent, UIViewAnimationOptions.beginFromCurrentState, UIViewAnimationOptions.allowUserInteraction, UIViewAnimationOptions.curveEaseOut],
            animations: {
                self.calendarTable.alpha = 0
                self.monthsView.alpha = 0
                self.yearTable.alpha = 1
                self.clockView.alpha = 0
        },
            completion: nil
        )
    }
    
    fileprivate func showTime(_ userTap: Bool) {
        if userTap {
            if selCurrrent.showTime {
                selTimeStateHour = !selTimeStateHour
            } else {
                selTimeStateHour = true
            }
        }
        
        if optionTimeStep == .sixtyMinutes {
            selTimeStateHour = true
        }
        
        changeSelTime()
        
        if userTap {
            clockView.showingHour = selTimeStateHour
        }
        clockView.setNeedsDisplay()
        
        UIView.transition(
            with: clockView,
            duration: selAnimationDuration / 2,
            options: [UIViewAnimationOptions.transitionCrossDissolve],
            animations: {
                self.clockView.layer.displayIfNeeded()
        },
            completion: nil
        )
        
        UIView.animate(
            withDuration: selAnimationDuration,
            delay: 0,
            options: [UIViewAnimationOptions.allowAnimatedContent, UIViewAnimationOptions.beginFromCurrentState, UIViewAnimationOptions.allowUserInteraction, UIViewAnimationOptions.curveEaseOut],
            animations: {
                self.calendarTable.alpha = 0
                self.monthsView.alpha = 0
                self.yearTable.alpha = 0
                self.clockView.alpha = 1
        },
            completion: nil
        )
    }
    
    func getDayOfWeek(today:String)->Int {
        
        let formatter  = DateFormatter()
        formatter.dateFormat = "d' 'MMM' 'yyyy"
        let todayDate = formatter.date(from: today)!
        let myCalendar = NSCalendar(calendarIdentifier: NSCalendar.Identifier.gregorian)!
        let myComponents = myCalendar.components(.weekday, from: todayDate)
        let weekDay = myComponents.weekday
        return weekDay!
    }
    
    
    
    fileprivate func updateDate() {
        if let topPanelTitle = optionTopPanelTitle {
            dayLabel.text = topPanelTitle
        }
        rangeEndLabel.text = (String(format: "%@",optionCurrentDateRange.end.stringFromFormat("d' 'MMM")) as NSString) as String
        if shouldResetRange {
        }
        else {
            rangeEndLabel.textColor = isSelectingStartRange ?  optionSelectorPanelFontColorDateHighlight: optionSelectorPanelFontColorDate
        }
    }
    
    fileprivate func changeSelDate() {
    }
    
    fileprivate func changeSelMonth() {
        
    }
    
    fileprivate func changeSelYear() {
        _ = self.selInactiveHeight
    }
    
    fileprivate func changeSelTime() {
        let selInactiveHeight = self.selInactiveHeight
        selDateYConstraint.constant = 0
        selMonthYConstraint.constant = 0
        
        selTimeTopConstraint.constant = 0
        selTimeLeftConstraint.constant = 0
        selTimeRightConstraint.constant = 0
        
        selDateLeftConstraint.constant = 0
        selYearRightConstraint.constant = 0
        if optionStyles.showDateMonth || optionStyles.showMonth {
            selDateHeightConstraint.constant = selInactiveHeight
            if optionStyles.showYear {
                selYearHeightConstraint.constant = selInactiveHeight
            } else {
                selDateRightConstraint.constant = 0
                selYearHeightConstraint.constant = 0
                selYearTopConstraint.constant = 0
            }
        } else {
            selDateHeightConstraint.constant = 0
            selDateTopConstraint.constant = 0
            if optionStyles.showYear {
                selYearHeightConstraint.constant = selInactiveHeight
                selYearLeftConstraint.constant = 0
            } else {
                selYearHeightConstraint.constant = 0
                selYearTopConstraint.constant = 0
            }
        }
        
        timeLabel.contentScaleFactor = UIScreen.main.scale * optionSelectorPanelScaleTime
        UIView.animate(
            withDuration: selAnimationDuration,
            delay: 0,
            usingSpringWithDamping: 0.8,
            initialSpringVelocity: 0,
            options: [UIViewAnimationOptions.allowAnimatedContent, UIViewAnimationOptions.allowUserInteraction],
            animations: {
                self.timeLabel.transform = CGAffineTransform.identity.scaledBy(x: self.optionSelectorPanelScaleTime, y: self.optionSelectorPanelScaleTime)
                self.monthLabel.transform = CGAffineTransform.identity
                self.dateLabel.transform = CGAffineTransform.identity
                self.yearLabel.transform = CGAffineTransform.identity
                self.view.layoutIfNeeded()
        },
            completion: { _ in
                if self.selCurrrent.showTime {
                    self.monthLabel.contentScaleFactor = UIScreen.main.scale
                    self.dateLabel.contentScaleFactor = UIScreen.main.scale
                    self.yearLabel.contentScaleFactor = UIScreen.main.scale
                }
        }
        )
        selCurrrent.showTime(true)
        updateDate()
    }
    
    // MARK:- Custom Method(s)
    
    func updateRoomInfo(reservedDates: NSArray,nightlyPrice:NSArray) {
        (arrRoomList[nSelectionIndex] as? ListingModel)?.blocked_dates = arrBlockedDates.mutableCopy() as? NSArray
        (arrRoomList[nSelectionIndex] as? ListingModel)?.reserved_dates = reservedDates.mutableCopy() as? NSArray
        (arrRoomList[nSelectionIndex] as? ListingModel)?.nightly_price = nightlyPrice.mutableCopy() as? NSArray
    }
    
    func onRemoveLabel() {
        lblSaving.isHidden = true
    }
    
    func manageSaveButton(_ date: Date) {
        isDateBlocked = false
        let selectedDate = getSelectedDates()
        if arrBlockedDates.count == 0 {
            btnSaveChanges.isHidden = true
            btnAvailable.removeTarget(nil, action: nil, for: .allEvents)
            btnBlocked.removeTarget(nil, action: nil, for: .allEvents)
            btnAvailable.addTarget(self, action: #selector(self.onBlockedCountZeroTapped), for: UIControlEvents.touchUpInside)
            btnBlocked.addTarget(self, action: #selector(self.onBlockedCountZeroTapped), for: UIControlEvents.touchUpInside)
        } else if arrBlockedDates.count == selectedDate.count {
            btnAvailable.removeTarget(nil, action: nil, for: .allEvents)
            btnBlocked.removeTarget(nil, action: nil, for: .allEvents)
            
            if arrBlockedDates == selectedDate {
                isDateBlocked = true
                btnSaveChanges.isHidden = true
                btnAvailable.backgroundColor = UIColor.clear
                btnBlocked.backgroundColor = UIColor.white
                btnBlocked.isSelected = true
                btnAvailable.addTarget(self, action: #selector(self.onBlockOneTapped), for: UIControlEvents.touchUpInside)
                btnBlocked.addTarget(self, action: #selector(self.onBlockOneTapped), for: UIControlEvents.touchUpInside)
            } else {
                for i in 0 ..< arrBlockedDates.count {
                    for j in 0 ..< selectedDate.count {
                        btnAvailable.removeTarget(nil, action: nil, for: .allEvents)
                        btnBlocked.removeTarget(nil, action: nil, for: .allEvents)
                        if (arrBlockedDates[i] as! String) == (selectedDate[j] as! String) {
                            isDateBlocked = true
                            btnSaveChanges.isHidden = true
                            btnAvailable.isSelected = false
                            btnBlocked.isSelected = false
                            btnAvailable.backgroundColor = UIColor.clear
                            btnBlocked.backgroundColor = UIColor.clear
                            btnAvailable.addTarget(self, action: #selector(self.onBlockResetTapped), for: UIControlEvents.touchUpInside)
                            btnBlocked.addTarget(self, action: #selector(self.onBlockResetTapped), for: UIControlEvents.touchUpInside)
                            return
                        } else {
                            btnSaveChanges.isHidden = true
                            btnAvailable.backgroundColor = UIColor.white
                            btnAvailable.isSelected = true
                            btnBlocked.backgroundColor = UIColor.clear
                            btnAvailable.addTarget(self, action: #selector(self.onBlockOneTapped), for: UIControlEvents.touchUpInside)
                            btnBlocked.addTarget(self, action: #selector(self.onBlockOneTapped), for: UIControlEvents.touchUpInside)
                        }
                    }
                }
            }
        } else if arrBlockedDates.count > selectedDate.count {
            for i in 0 ..< arrBlockedDates.count {
                for j in 0 ..< selectedDate.count {
                    if (arrBlockedDates[i] as! String) == (selectedDate[j] as! String) {
                        isDateBlocked = true
                        btnSaveChanges.isHidden = true
                        btnAvailable.backgroundColor = UIColor.clear
                        btnBlocked.backgroundColor = UIColor.white
                        btnBlocked.isSelected = true
                        btnAvailable.addTarget(self, action: #selector(self.onBlockOneTapped), for: UIControlEvents.touchUpInside)
                        btnBlocked.addTarget(self, action: #selector(self.onBlockOneTapped), for: UIControlEvents.touchUpInside)
                        return
                    } else {
                        btnSaveChanges.isHidden = true
                        btnAvailable.backgroundColor = UIColor.white
                        btnAvailable.isSelected = true
                        btnBlocked.backgroundColor = UIColor.clear
                        btnAvailable.addTarget(self, action: #selector(self.onBlockOneTapped), for: UIControlEvents.touchUpInside)
                        btnBlocked.addTarget(self, action: #selector(self.onBlockOneTapped), for: UIControlEvents.touchUpInside)
                    }
                }
            }
        } else {
            for i in 0 ..< selectedDate.count {
                for j in 0 ..< arrBlockedDates.count {
                    btnAvailable.removeTarget(nil, action: nil, for: .allEvents)
                    btnBlocked.removeTarget(nil, action: nil, for: .allEvents)
                    
                    if (selectedDate[i] as! String) == (arrBlockedDates[j] as! String) {
                        isDateBlocked = true
                        btnSaveChanges.isHidden = true
                        btnAvailable.isSelected = false
                        btnBlocked.isSelected = false
                        btnAvailable.backgroundColor = UIColor.clear
                        btnBlocked.backgroundColor = UIColor.clear
                        btnAvailable.addTarget(self, action: #selector(self.onBlockAvailableTapped), for: UIControlEvents.touchUpInside)
                        btnBlocked.addTarget(self, action: #selector(self.onBlockAvailableTapped), for: UIControlEvents.touchUpInside)
                        return
                    } else {
                        btnAvailable.addTarget(self, action: #selector(self.onBlockAvailableTapped), for: UIControlEvents.touchUpInside)
                        btnBlocked.addTarget(self, action: #selector(self.onBlockAvailableTapped), for: UIControlEvents.touchUpInside)
                    }
                }
            }
        }
    }
    
    func onBlockOneTapped(sender:UIButton) {
        if sender.tag == 11 {
            if isDateBlocked {
                btnSaveChanges.isHidden = false
            } else {
                btnSaveChanges.isHidden = true
            }
            btnAvailable.isSelected = true
            btnBlocked.isSelected = false
            btnAvailable.backgroundColor = UIColor.white
            btnBlocked.backgroundColor = UIColor.clear
        } else {
            if isDateBlocked {
                btnSaveChanges.isHidden = true
            } else {
                btnSaveChanges.isHidden = false
            }
            btnBlocked.isSelected = true
            btnAvailable.isSelected = false
            btnAvailable.backgroundColor = UIColor.clear
            btnBlocked.backgroundColor = UIColor.white
        }
        if isRoomPriceChanged {
            btnSaveChanges.isHidden = false
        }
    }
    
    func onBlockResetTapped(sender:UIButton) {
        if sender.tag == 11 {
            btnAvailable.isSelected = !btnAvailable.isSelected
            
            btnSaveChanges.isHidden = (btnAvailable.isSelected) ? false : true
            
            btnBlocked.isSelected = false
            btnAvailable.backgroundColor = UIColor.white
            btnBlocked.backgroundColor = UIColor.clear
        } else {
            btnBlocked.isSelected = !btnBlocked.isSelected
            btnSaveChanges.isHidden = (btnBlocked.isSelected) ? false : true
            btnAvailable.isSelected = false
            btnAvailable.backgroundColor = UIColor.clear
            btnBlocked.backgroundColor = UIColor.white
        }
        if isRoomPriceChanged {
            btnSaveChanges.isHidden = false
        }
    }
    
    func onBlockAvailableTapped(sender:UIButton) {
        if sender.tag == 11 {
            btnAvailable.isSelected = true
            btnBlocked.isSelected = false
            btnAvailable.backgroundColor = UIColor.white
            btnBlocked.backgroundColor = UIColor.clear
        } else {
            btnBlocked.isSelected = true
            btnAvailable.isSelected = false
            btnAvailable.backgroundColor = UIColor.clear
            btnBlocked.backgroundColor = UIColor.white
        }
        btnSaveChanges.isHidden =  false
        if isRoomPriceChanged {
            btnSaveChanges.isHidden = false
        }
    }
    
    func onBlockedCountZeroTapped(sender:UIButton) {
        if sender.tag == 11 {
            btnSaveChanges.isHidden = true
            btnAvailable.isSelected = true
            btnBlocked.isSelected = false
            btnAvailable.backgroundColor = UIColor.white
            btnBlocked.backgroundColor = UIColor.clear
        } else {
            btnSaveChanges.isHidden = false
            btnBlocked.isSelected = true
            btnAvailable.isSelected = false
            btnAvailable.backgroundColor = UIColor.clear
            btnBlocked.backgroundColor = UIColor.white
        }
        if isRoomPriceChanged {
            btnSaveChanges.isHidden = false
        }
    }
    
    func makeNewTable(_ blocked_dates : NSArray) {
        optionCurrentDates = []
        cellIdentifierNew = String(format:"cell%d",nSelectedIndex)
        arrBlockedDates = blocked_dates
        calendarTable.removeFromSuperview()
        calendarTable.delegate = nil
        calendarTable.dataSource = nil
        bottomContainerView.addSubview(calendarTable)
        calendarTable.delegate = self
        calendarTable.dataSource = self
        self.calendarTable.reloadData()
    }
    
    func makeViewAnimation(yPosition:CGFloat , hidden : Bool)
    {
        UIView.animate(withDuration:  0.25, delay: 0.0, options: UIViewAnimationOptions.curveEaseIn, animations: { () -> Void in
            var rectStartBtn = self.viewAvailableHolder.frame
            rectStartBtn.origin.y = yPosition
            self.viewAvailableHolder.frame = rectStartBtn
        }, completion: { (finished: Bool) -> Void in
            self.viewAvailableHolder.isHidden = hidden
        })
    }
    
    // MARK:- SSCalendar Method(s)
    
    internal func SSCalendarRowDidSelect(_ date: Date) {
        if delegate?.SSCalendarTimeSelectorShouldSelectDate?(self, date: date) ?? true {
            switch optionSelectionType {
            case .single:
                optionCurrentDate = optionCurrentDate.change(year: date.year, month: date.month, day: date.day)
                updateDate()
                
            case .multiple:
                let date1 : NSDate = date as NSDate
                let date2 : NSDate = NSDate() //initialized by default with the current date
                
                let compareResult = date1.compare(date2 as Date)
                if compareResult == ComparisonResult.orderedAscending || arrRoomList.count == 0 || strSelectedRoomId == "" {
                    return
                }
                
                let strCheckInDate = getAPIDateFormat(date)
                if arrReservedDates.count>0 {
                    for i in 0 ..< arrReservedDates.count {
                        let strBlocked = arrReservedDates[i] as! NSString
                        if strCheckInDate == strBlocked as String {
                            //                            appDelegate.createToastMessage("This Date already Reserved", isSuccess: false)
                            return
                        }
                    }
                }
                
                let listModel = arrRoomList[nSelectionIndex] as? ListingModel
                strRoomPrice = (listModel?.room_price)!
                lblRoomPrice.text = String(format:"%@%@",strRoomPrice,strRoomCurrencySymbol.stringByDecodingHTMLEntities)
                
                if arrNightlyPrice.count>0 {
                    for i in 0 ..< arrNightlyPrice.count {
                        let strBlocked = arrNightlyPrice[i] as! NSString
                        let strPrice = strBlocked.components(separatedBy: "*")
                        if strCheckInDate == strPrice[0] as String {
                            strRoomPrice = strPrice[1]
                            lblRoomPrice.text = String(format:"%@%@",strPrice[1],strRoomCurrencySymbol.stringByDecodingHTMLEntities)
                        }
                    }
                }
                
                if multipleDates.index(of: date) != nil {
                    optionCurrentDates.remove(date)
                } else
                {
                    optionCurrentDates.insert(date)
                }
                let rect = UIScreen.main.bounds as CGRect
                
                if viewAvailableHolder.isHidden {
                    viewAvailableHolder.isHidden = false
                    self.makeViewAnimation(yPosition: rect.size.height-self.viewAvailableHolder.frame.size.height-50 , hidden : false)
                }
                
                if optionCurrentDates.count == 0 {
                    self.makeViewAnimation(yPosition: rect.size.height-self.viewAvailableHolder.frame.size.height-50 , hidden : true)
                } else
                {
                    manageSaveButton(date)
                }
                break
            case .range:
                let date1 : NSDate = date as NSDate
                let date2 : NSDate = NSDate()
                let compareResult = date1.compare(date2 as Date)
                if compareResult == ComparisonResult.orderedAscending || arrRoomList.count == 0 || strSelectedRoomId == "" {
                    return
                }
                let rangeDate = date.beginningOfDay
                if shouldResetRange {
                    optionCurrentDateRange.setStartDate(rangeDate)
                    optionCurrentDateRange.setEndDate(rangeDate)
                    isSelectingStartRange = false
                    shouldResetRange = false
                    rangeStartLabel.text = optionCurrentDateRange.start.stringFromFormat("d' 'MMM")
                } else {
                    if isSelectingStartRange {
                        optionCurrentDateRange.setStartDate(rangeDate)
                        isSelectingStartRange = false
                    } else {
                        optionCurrentDateRange.setEndDate(rangeDate)
                        shouldResetRange = true
                    }
                    let startDate = optionCurrentDateRange.start.stringFromFormat("d' 'MMM")
                    let endDate = optionCurrentDateRange.end.stringFromFormat("d' 'MMM")
                    rangeStartLabel.text = String(format:"%@ - %@",startDate,endDate)
                }
                
                if viewAvailableHolder.isHidden {
                    viewAvailableHolder.isHidden = false
                    let rect = UIScreen.main.bounds as CGRect
                    self.makeViewAnimation(yPosition: rect.size.height-self.viewAvailableHolder.frame.size.height-50 , hidden : false)
                }
                rangeStartLabel.textColor = UIColor(red: 90.0 / 255.0 , green: 81.0 / 255.0 , blue: 84.0 / 255.0 , alpha: 1.0)
                updateDate()
            }
            calendarTable.reloadData()
        }
    }
    
    internal func SSCalendarRowGetDetails(_ row: Int) -> (type: SSCalendarRowType, startDate: Date) {
        if row == 1 {
            return (calRow1Type, calRow1StartDate)
        } else if row == 2 {
            return (calRow2Type, calRow2StartDate)
        } else if row == 3 {
            return (calRow3Type, calRow3StartDate)
        } else if row > 3 {
            var startRow: Int
            var startDate: Date
            var rowType: SSCalendarRowType
            if calRow3Type == .date {
                startRow = 3
                startDate = calRow3StartDate
                rowType = calRow3Type
            } else if calRow2Type == .date {
                startRow = 2
                startDate = calRow2StartDate
                rowType = calRow2Type
            } else {
                startRow = 1
                startDate = calRow1StartDate
                rowType = calRow1Type
            }
            
            for _ in startRow..<row {
                if rowType == .month {
                    rowType = .day
                } else if rowType == .day {
                    rowType = .date
                    startDate = startDate.beginningOfMonth
                } else {
                    let newStartDate = startDate.endOfWeek + 1.day
                    if newStartDate.month != startDate.month {
                        rowType = .month
                    }
                    startDate = newStartDate
                }
            }
            return (rowType, startDate)
        } else {
            // row <= 0
            var startRow: Int
            var startDate: Date
            var rowType: SSCalendarRowType
            if calRow1Type == .date {
                startRow = 1
                startDate = calRow1StartDate
                rowType = calRow1Type
            } else if calRow2Type == .date {
                startRow = 2
                startDate = calRow2StartDate
                rowType = calRow2Type
            } else {
                startRow = 3
                startDate = calRow3StartDate
                rowType = calRow3Type
            }
            
            for _ in row..<startRow {
                if rowType == .date {
                    if startDate.day == 1 {
                        rowType = .day
                    } else {
                        let newStartDate = (startDate - 1.day).beginningOfWeek
                        if newStartDate.month != startDate.month {
                            startDate = startDate.beginningOfMonth
                        } else {
                            startDate = newStartDate
                        }
                    }
                } else if rowType == .day {
                    rowType = .month
                } else {
                    rowType = .date
                    startDate = (startDate - 1.day).beginningOfWeek
                }
            }
            return (rowType, startDate)
        }
    }
    
    internal func SSClockGetTime() -> Date {
        return optionCurrentDate
    }
    
    internal func SSClockSwitchAMPM(isAM: Bool, isPM: Bool) {
        var newHour = optionCurrentDate.hour
        if isAM && newHour >= 12 {
            newHour = newHour - 12
        }
        if isPM && newHour < 12 {
            newHour = newHour + 12
        }
        
        optionCurrentDate = optionCurrentDate.change(hour: newHour)
        updateDate()
        clockView.setNeedsDisplay()
        UIView.transition(
            with: clockView,
            duration: selAnimationDuration / 2,
            options: [UIViewAnimationOptions.transitionCrossDissolve, UIViewAnimationOptions.allowUserInteraction, UIViewAnimationOptions.beginFromCurrentState],
            animations: {
                self.clockView.layer.displayIfNeeded()
        },
            completion: nil
        )
    }
    
    internal func SSClockSetHourMilitary(_ hour: Int) {
        optionCurrentDate = optionCurrentDate.change(hour: hour)
        updateDate()
        clockView.setNeedsDisplay()
    }
    
    internal func SSClockSetMinute(_ minute: Int) {
        optionCurrentDate = optionCurrentDate.change(minute: minute)
        updateDate()
        clockView.setNeedsDisplay()
    }
    
    //
    // MARK: AVAILABLE OR BLOCK DATES ACTION
    //
    /*
     BTN TAG =  11 --> AVAILABLE TAPPED
     BTN TAG =  22 --> BLOCK TAPPED
     */
    
    // MARK: CREATED LIST VIEW DELEGATE METHODS
    
    func onCreateListTapped(index: Int) {
        if !viewAvailableHolder.isHidden {
            self.onCancelTapped()
        }
        nSelectionIndex = index
        nSelectedIndex = index
        let listModel = arrRoomList[index] as? ListingModel
        if (listModel?.room_thumb_images.count)! > 0 {
            imgRoom.sd_setImage(with: NSURL(string: listModel?.room_thumb_images[0] as! String)! as URL, placeholderImage:UIImage(named:""))
        } else {
            imgRoom.image = UIImage(named:"room_default_no_photos.png")
        }
        
        if ((listModel?.room_name)?.characters.count)! > 0 {
            lblRoomName.text = listModel?.room_name
        } else {
            lblRoomName.text = ((listModel?.room_location)?.characters.count)! > 0 ? String(format:"%@ in %@",(listModel?.room_type)!,(listModel?.room_location)!) : String(format:"%@",(listModel?.room_type)!)
        }
        strRoomPrice = (listModel?.room_price)!
        strSelectedRoomId = (listModel?.room_id)!
        strRoomCurrencyCode = (listModel?.currency_code)!
        strRoomCurrencySymbol = (listModel?.currency_symbol)!
        arrNightlyPrice = (listModel?.nightly_price!)!
        arrReservedDates = (listModel?.reserved_dates!)!
        lblRoomPrice.text = String(format:"%@%@",strRoomPrice,strRoomCurrencySymbol.stringByDecodingHTMLEntities)
        
        self.makeNewTable((listModel?.blocked_dates!)!)
    }
    
    // MARK:- Edit Price delegate Method(s)
    
    func PriceEditted(strDescription: String) {
        isRoomPriceChanged = true
        strRoomPrice = strDescription
        btnSaveChanges.isHidden = false
        lblRoomPrice.text = String(format:"%@%@",strDescription,strRoomCurrencySymbol.stringByDecodingHTMLEntities)
    }
    
    func currencyChangedInEditPrice(strCurrencyCode: String, strCurrencySymbol: String) {
    }
    
    func updateAllRoomPrice(modelList : ListingModel) {
    }
    
    // MARK:- Table View Method(s)
    
    open func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView == calendarTable {
            return tableView.frame.height / 8
        }
        return tableView.frame.height / 5
    }
    
    open func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == calendarTable {
            return 16
        }
        return multipleDates.count
    }
    
    open func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: UITableViewCell
        
        if tableView == calendarTable {
            cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: cellIdentifierNew)
            let calRow = SSCalendarRow()
            calRow.translatesAutoresizingMaskIntoConstraints = false
            calRow.delegate = self
            calRow.backgroundColor = UIColor.clear
            calRow.monthFont = optionCalendarFontMonth
            calRow.monthFontColor = optionCalendarFontColorMonth
            calRow.dayFont = optionCalendarFontDays
            calRow.dayFontColor = optionCalendarFontColorDays
            calRow.datePastFont = optionCalendarFontPastDates
            calRow.datePastFontHighlight = optionCalendarFontPastDatesHighlight
            calRow.datePastFontColor = optionCalendarFontColorPastDates
            calRow.datePastHighlightFontColor = optionCalendarFontColorPastDatesHighlight
            calRow.datePastHighlightBackgroundColor = optionCalendarBackgroundColorPastDatesHighlight
            calRow.datePastFlashBackgroundColor = optionCalendarBackgroundColorPastDatesFlash
            calRow.dateTodayFont = optionCalendarFontToday
            calRow.dateTodayFontHighlight = optionCalendarFontTodayHighlight
            calRow.dateTodayFontColor = optionCalendarFontColorToday
            calRow.dateTodayHighlightFontColor = optionCalendarFontColorTodayHighlight
            calRow.dateTodayHighlightBackgroundColor = optionCalendarBackgroundColorTodayHighlight
            calRow.dateTodayFlashBackgroundColor = optionCalendarBackgroundColorTodayFlash
            calRow.dateFutureFont = optionCalendarFontFutureDates
            calRow.dateFutureFontHighlight = optionCalendarFontFutureDatesHighlight
            calRow.dateFutureFontColor = optionCalendarFontColorFutureDates
            calRow.dateFutureHighlightFontColor = optionCalendarFontColorFutureDatesHighlight
            calRow.dateFutureHighlightBackgroundColor = optionCalendarBackgroundColorFutureDatesHighlight
            calRow.dateFutureFlashBackgroundColor = optionCalendarBackgroundColorFutureDatesFlash
            calRow.flashDuration = selAnimationDuration
            calRow.multipleSelectionGrouping = optionMultipleSelectionGrouping
            calRow.multipleSelectionEnabled = optionSelectionType != .single
            cell.contentView.addSubview(calRow)
            cell.backgroundColor = UIColor.clear
            cell.contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[cr]|", options: [], metrics: nil, views: ["cr": calRow]))
            cell.contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[cr]|", options: [], metrics: nil, views: ["cr": calRow]))
            
            if arrBlockedDates.count>0 {
                calRow.arrBlockedDates = arrBlockedDates
            }
            if arrReservedDates.count>0 {
                calRow.arrReservedDates = arrReservedDates
            }
            
            for sv in cell.contentView.subviews {
                if let calRow = sv as? SSCalendarRow {
                    calRow.tag = (indexPath as NSIndexPath).row + 1
                    switch optionSelectionType {
                    case .single:
                        calRow.selectedDates = [optionCurrentDate]
                    case .multiple:
                        calRow.selectedDates = optionCurrentDates
                    case .range:
                        calRow.selectedDates = Set(optionCurrentDateRange.array)
                    }
                    calRow.setNeedsDisplay()
                    if let fd = flashDate {
                        if calRow.flashDate(fd) {
                            flashDate = nil
                        }
                    }
                }
            }
        } else { // multiple dates table
            if let c = tableView.dequeueReusableCell(withIdentifier: cellIdentifierNew) {
                cell = c
            } else {
                cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: cellIdentifierNew)
                cell.textLabel?.textAlignment = NSTextAlignment.center
                cell.selectionStyle = UITableViewCellSelectionStyle.none
                cell.backgroundColor = UIColor.clear
            }
            let date = multipleDates[(indexPath as NSIndexPath).row]
            cell.textLabel?.font = date == multipleDatesLastAdded ? optionSelectorPanelFontMultipleSelectionHighlight : optionSelectorPanelFontMultipleSelection
            cell.textLabel?.textColor = date == multipleDatesLastAdded ? optionSelectorPanelFontColorMultipleSelectionHighlight : optionSelectorPanelFontColorMultipleSelection
            cell.textLabel?.text = date.stringFromFormat("EEE', 'd' 'MMM' 'yyyy")
        }
        return cell
    }
    
    open func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == yearTable {
            let displayYear = yearRow1 + (indexPath as NSIndexPath).row
            let newDate = optionCurrentDate.change(year: displayYear)
            if delegate?.SSCalendarTimeSelectorShouldSelectDate?(self, date: newDate!) ?? true {
                optionCurrentDate = newDate!
                updateDate()
                tableView.reloadData()
            }
        }
    }
    
    // MARK:- ScrollView Method(s)
    
    open func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        
        if scrollView == calendarTable {
            let twoRow = bottomContainerView.frame.height / 4
            if offsetY < twoRow {
                // every row shift by 4 to the back, recalculate top 3 towards earlier dates
                
                let detail1 = SSCalendarRowGetDetails(-3)
                let detail2 = SSCalendarRowGetDetails(-2)
                let detail3 = SSCalendarRowGetDetails(-1)
                calRow1Type = detail1.type
                calRow1StartDate = detail1.startDate
                calRow2Type = detail2.type
                calRow2StartDate = detail2.startDate
                calRow3Type = detail3.type
                calRow3StartDate = detail3.startDate
                
                scrollView.contentOffset = CGPoint(x: 0, y: offsetY + twoRow * 2)
                calendarTable.reloadData()
            } else if offsetY > twoRow * 3 {
                // every row shift by 4 to the front, recalculate top 3 towards later dates
                
                let detail1 = SSCalendarRowGetDetails(5)
                let detail2 = SSCalendarRowGetDetails(6)
                let detail3 = SSCalendarRowGetDetails(7)
                calRow1Type = detail1.type
                calRow1StartDate = detail1.startDate
                calRow2Type = detail2.type
                calRow2StartDate = detail2.startDate
                calRow3Type = detail3.type
                calRow3StartDate = detail3.startDate
                
                scrollView.contentOffset = CGPoint(x: 0, y: offsetY - twoRow * 2)
                calendarTable.reloadData()
            }
        } else if scrollView == yearTable {
            let triggerPoint = backgroundContentView.frame.height / 10 * 3
            if offsetY < triggerPoint {
                yearRow1 = yearRow1 - 3
                
                scrollView.contentOffset = CGPoint(x: 0, y: offsetY + triggerPoint * 2)
                yearTable.reloadData()
            } else if offsetY > triggerPoint * 3 {
                yearRow1 = yearRow1 + 3
                
                scrollView.contentOffset = CGPoint(x: 0, y: offsetY - triggerPoint * 2)
                yearTable.reloadData()
            }
        }
    }
    
    // MARK:- Localization Method
    func localization() {
        self.lblSaving.text = saving
        self.btnNightlyPrice.setTitle(nightlyPrice, for: .normal)
        self.btnBlocked.setTitle(blocked, for: .normal)
        self.btnAvailable.setTitle(available, for: .normal)
        self.btnAddListing.setTitle(nxt, for: .normal)
        self.lblNoListing.text = noListing
        self.lblNoListingNote.text = noListingNote
        self.btnCancel.setTitle(strcancel, for: .normal)
    }
    
}


@objc internal enum SSCalendarRowType: Int {
    case month, day, date
}

internal protocol SSCalendarRowProtocol {
    func SSCalendarRowGetDetails(_ row: Int) -> (type: SSCalendarRowType, startDate: Date)
    func SSCalendarRowDidSelect(_ date: Date)
}

internal class SSCalendarRow: UIView {
    
    internal var delegate: SSCalendarRowProtocol!
    internal var monthFont: UIFont!
    internal var monthFontColor: UIColor!
    internal var dayFont: UIFont!
    internal var dayFontColor: UIColor!
    internal var datePastFont: UIFont!
    internal var datePastFontHighlight: UIFont!
    internal var datePastFontColor: UIColor!
    internal var datePastHighlightFontColor: UIColor!
    internal var datePastHighlightBackgroundColor: UIColor!
    internal var datePastFlashBackgroundColor: UIColor!
    internal var dateTodayFont: UIFont!
    internal var dateTodayFontHighlight: UIFont!
    internal var dateTodayFontColor: UIColor!
    internal var dateTodayHighlightFontColor: UIColor!
    internal var dateTodayHighlightBackgroundColor: UIColor!
    internal var dateTodayFlashBackgroundColor: UIColor!
    internal var dateFutureFont: UIFont!
    internal var dateFutureFontHighlight: UIFont!
    internal var dateFutureFontColor: UIColor!
    internal var dateFutureHighlightFontColor: UIColor!
    internal var dateFutureHighlightBackgroundColor: UIColor!
    internal var dateFutureFlashBackgroundColor: UIColor!
    internal var flashDuration: TimeInterval!
    internal var multipleSelectionGrouping: SSCalendarTimeSelectorMultipleSelectionGrouping = .pill
    internal var multipleSelectionEnabled: Bool = false
    
    internal var selectedDates: Set<Date> {
        set {
            originalDates = newValue
            comparisonDates = []
            for date in newValue {
                comparisonDates.insert(date.beginningOfDay)
            }
        }
        get {
            return originalDates
        }
    }
    fileprivate var originalDates: Set<Date> = []
    fileprivate var comparisonDates: Set<Date> = []
    fileprivate let days = ["S", "M", "T", "W", "T", "F", "S"]
    fileprivate let multipleSelectionBorder: CGFloat = 12
    fileprivate let multipleSelectionBar: CGFloat = 8
    
    var arrBlockedDates : NSArray = NSArray()
    var arrReservedDates : NSArray = NSArray()
    var arrNightlyPrice : NSArray = NSArray()
    
    
    internal override func draw(_ rect: CGRect) {
        let detail = delegate.SSCalendarRowGetDetails(tag)
        let startDate = detail.startDate.beginningOfDay
        
        let ctx = UIGraphicsGetCurrentContext()
        let boxHeight = rect.height
        let boxWidth = rect.width / 7
        let paragraph = NSMutableParagraphStyle()
        paragraph.alignment = NSTextAlignment.center
        
        if detail.type == .month {
            let monthName = startDate.stringFromFormat("MMMM yyyy").capitalized
            let monthHeight = ceil(monthFont.lineHeight)
            
            let str = NSAttributedString(string: monthName, attributes: [NSFontAttributeName: monthFont, NSForegroundColorAttributeName: monthFontColor, NSParagraphStyleAttributeName: paragraph])
            str.draw(in: CGRect(x: 0, y: boxHeight - monthHeight, width: rect.width, height: monthHeight))
        } else if detail.type == .day {
            let dayHeight = ceil(dayFont.lineHeight)
            let y = (boxHeight - dayHeight) / 2
            
            for (index, element) in days.enumerated() {
                let str = NSAttributedString(string: element, attributes: [NSFontAttributeName: dayFont, NSForegroundColorAttributeName: dayFontColor, NSParagraphStyleAttributeName: paragraph])
                str.draw(in: CGRect(x: CGFloat(index) * boxWidth, y: y, width: boxWidth, height: dayHeight))
            }
        } else {
            let today = Date().beginningOfDay
            var date = startDate
            var str: NSMutableAttributedString
            
            for i in 1...7 {
                if date.weekday == i {
                    var font = comparisonDates.contains(date) ? dateFutureFontHighlight : dateFutureFont
                    var fontColor = dateFutureFontColor
                    var fontHighlightColor = dateFutureHighlightFontColor
                    var backgroundHighlightColor = dateFutureHighlightBackgroundColor.cgColor
                    if date == today {
                        font = comparisonDates.contains(date) ? dateTodayFontHighlight : dateTodayFont
                        fontColor = comparisonDates.contains(date) ? dateTodayHighlightFontColor : dateTodayFontColor
                        fontHighlightColor = dateTodayHighlightFontColor
                        backgroundHighlightColor = dateTodayHighlightBackgroundColor.cgColor
                    } else if date.compare(today) == ComparisonResult.orderedAscending {
                        font = comparisonDates.contains(date) ? datePastFontHighlight : datePastFont
                        fontColor = datePastFontColor
                        fontHighlightColor = datePastHighlightFontColor
                        backgroundHighlightColor = datePastHighlightBackgroundColor.cgColor
                    }
                    
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
                    dateFormatter.dateStyle = DateFormatter.Style.medium
                    
                    dateFormatter.timeStyle = DateFormatter.Style.none
                    dateFormatter.dateFormat = "dd-MM-yyy"
                    let strCheckInDate = dateFormatter.string(from: date)
                    
                    let dateHeight = ceil(font!.lineHeight) as CGFloat
                    let y = (boxHeight - dateHeight) / 2
                    
                    if comparisonDates.contains(date) {
                        ctx?.setFillColor(backgroundHighlightColor)
                        
                        if multipleSelectionEnabled {
                            var testStringSize = NSAttributedString(string: "00", attributes: [NSFontAttributeName: dateTodayFontHighlight, NSParagraphStyleAttributeName: paragraph]).size()
                            var dateMaxWidth = testStringSize.width
                            var dateMaxHeight = testStringSize.height
                            if dateFutureFontHighlight.lineHeight > dateTodayFontHighlight.lineHeight {
                                testStringSize = NSAttributedString(string: "00", attributes: [NSFontAttributeName: dateFutureFontHighlight, NSParagraphStyleAttributeName: paragraph]).size()
                                dateMaxWidth = testStringSize.width
                                dateMaxHeight = testStringSize.height
                            }
                            if datePastFontHighlight.lineHeight > dateFutureFontHighlight.lineHeight {
                                testStringSize = NSAttributedString(string: "00", attributes: [NSFontAttributeName: datePastFontHighlight, NSParagraphStyleAttributeName: paragraph]).size()
                                dateMaxWidth = testStringSize.width
                                dateMaxHeight = testStringSize.height
                            }
                            
                            let size = min(max(dateHeight, dateMaxWidth) + multipleSelectionBorder, min(boxHeight, boxWidth))
                            let maxConnectorSize = min(max(dateMaxHeight, dateMaxWidth) + multipleSelectionBorder, min(boxHeight, boxWidth))
                            let x = CGFloat(i - 1) * boxWidth + (boxWidth - size) / 2
                            let y = (boxHeight - size) / 2
                            
                            // connector
                            switch multipleSelectionGrouping {
                            case .simple:
                                break
                            case .pill:
                                if comparisonDates.contains(date - 1.day) {
                                    ctx?.fill(CGRect(x: CGFloat(i - 1) * boxWidth, y: y, width: boxWidth / 2 + 1, height: maxConnectorSize))
                                }
                                if comparisonDates.contains(date + 1.day) {
                                    ctx?.fill(CGRect(x: CGFloat(i - 1) * boxWidth + boxWidth / 2, y: y, width: boxWidth / 2 + 1, height: maxConnectorSize))
                                }
                            case .linkedBalls:
                                if comparisonDates.contains(date - 1.day) {
                                    ctx?.fill(CGRect(x: CGFloat(i - 1) * boxWidth, y: (boxHeight - multipleSelectionBar) / 2, width: boxWidth / 2 + 1, height: multipleSelectionBar))
                                }
                                if comparisonDates.contains(date + 1.day) {
                                    ctx?.fill(CGRect(x: CGFloat(i - 1) * boxWidth + boxWidth / 2, y: (boxHeight - multipleSelectionBar) / 2, width: boxWidth / 2 + 1, height: multipleSelectionBar))
                                }
                            }
                            
                            // ball
                            ctx?.fillEllipse(in: CGRect(x: x, y: y, width: size, height: size))
                        } else {
                            let size = min(boxHeight, boxWidth)
                            let x = CGFloat(i - 1) * boxWidth + (boxWidth - size) / 2
                            let y = (boxHeight - size) / 2
                            ctx?.fillEllipse(in: CGRect(x: x, y: y, width: size, height: size))
                        }
                        str = NSMutableAttributedString(string: "\(date.day)")
                        if arrBlockedDates.count>0 {
                            for i in 0...arrBlockedDates.count-1 {
                                let strBlocked = arrBlockedDates[i] as! NSString
                                if strCheckInDate == strBlocked as String {
                                    str.addAttribute(NSStrikethroughStyleAttributeName, value: 2, range: NSMakeRange(0, str.length))
                                } else{
                                    
                                }
                            }
                        }
                        str.addAttributes([NSFontAttributeName: font!, NSForegroundColorAttributeName: fontHighlightColor!, NSParagraphStyleAttributeName: paragraph], range: NSMakeRange(0, str.length))
                    } else {
                        str = NSMutableAttributedString(string: "\(date.day)")
                        
                        if arrBlockedDates.count>0 {
                            for i in 0...arrBlockedDates.count-1 {
                                let strBlocked = arrBlockedDates[i] as! NSString
                                if strCheckInDate == strBlocked as String {
                                    str.addAttribute(NSStrikethroughStyleAttributeName, value: 2, range: NSMakeRange(0, str.length))
                                } else{
                                }
                            }
                        }
                        
                        str.addAttributes([NSFontAttributeName: font!, NSForegroundColorAttributeName: fontColor!, NSParagraphStyleAttributeName: paragraph], range: NSMakeRange(0, str.length))
                    }
                    
                    str.draw(in: CGRect(x: CGFloat(i - 1) * boxWidth, y: y, width: boxWidth, height: dateHeight))
                    date = date + 1.day
                    if date.month != startDate.month {
                        break
                    }
                }
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        let detail = delegate.SSCalendarRowGetDetails(tag)
        if detail.type == .date {
            let boxWidth = bounds.width / 7
            if let touch = touches.sorted(by: { $0.timestamp < $1.timestamp }).last {
                let boxIndex = Int(floor(touch.location(in: self).x / boxWidth))
                let dateTapped = detail.startDate + boxIndex.days - (detail.startDate.weekday - 1).days
                if dateTapped.month == detail.startDate.month {
                    delegate.SSCalendarRowDidSelect(dateTapped)
                }
            }
        }
    }
    
    fileprivate func flashDate(_ date: Date) -> Bool {
        let detail = delegate.SSCalendarRowGetDetails(tag)
        
        if detail.type == .date {
            let today = Date().beginningOfDay
            let startDate = detail.startDate.beginningOfDay
            let flashDate = date.beginningOfDay
            let boxHeight = bounds.height
            let boxWidth = bounds.width / 7
            var date = startDate
            
            for i in 1...7 {
                if date.weekday == i {
                    if date == flashDate {
                        var flashColor = dateFutureFlashBackgroundColor
                        if flashDate == today {
                            flashColor = dateTodayFlashBackgroundColor
                        }
                        else if flashDate.compare(today) == ComparisonResult.orderedAscending {
                            flashColor = datePastFlashBackgroundColor
                        }
                        
                        let flashView = UIView(frame: CGRect(x: CGFloat(i - 1) * boxWidth, y: 0, width: boxWidth, height: boxHeight))
                        flashView.backgroundColor = flashColor
                        flashView.alpha = 0
                        addSubview(flashView)
                        UIView.animate(
                            withDuration: flashDuration / 2,
                            delay: 0,
                            options: [UIViewAnimationOptions.allowAnimatedContent, UIViewAnimationOptions.allowUserInteraction, UIViewAnimationOptions.beginFromCurrentState, UIViewAnimationOptions.curveEaseOut],
                            animations: {
                                flashView.alpha = 0.75
                        },
                            completion: { _ in
                                UIView.animate(
                                    withDuration: self.flashDuration / 2,
                                    delay: 0,
                                    options: [UIViewAnimationOptions.allowAnimatedContent, UIViewAnimationOptions.allowUserInteraction, UIViewAnimationOptions.beginFromCurrentState, UIViewAnimationOptions.curveEaseIn],
                                    animations: {
                                        flashView.alpha = 0
                                },
                                    completion: { _ in
                                        flashView.removeFromSuperview()
                                }
                                )
                        }
                        )
                        return true
                    }
                    date = date + 1.day
                    if date.month != startDate.month {
                        break
                    }
                }
            }
        }
        return false
    }
}

internal protocol SSClockProtocol {
    func SSClockGetTime() -> Date
    func SSClockSwitchAMPM(isAM: Bool, isPM: Bool)
    func SSClockSetHourMilitary(_ hour: Int)
    func SSClockSetMinute(_ minute: Int)
}

internal class SSClock: UIView {
    
    internal var delegate: SSClockProtocol!
    internal var backgroundColorClockFace: UIColor!
    internal var backgroundColorClockFaceCenter: UIColor!
    internal var fontAMPM: UIFont!
    internal var fontAMPMHighlight: UIFont!
    internal var fontColorAMPM: UIColor!
    internal var fontColorAMPMHighlight: UIColor!
    internal var backgroundColorAMPMHighlight: UIColor!
    internal var fontHour: UIFont!
    internal var fontHourHighlight: UIFont!
    internal var fontColorHour: UIColor!
    internal var fontColorHourHighlight: UIColor!
    internal var backgroundColorHourHighlight: UIColor!
    internal var backgroundColorHourHighlightNeedle: UIColor!
    internal var fontMinute: UIFont!
    internal var fontMinuteHighlight: UIFont!
    internal var fontColorMinute: UIColor!
    internal var fontColorMinuteHighlight: UIColor!
    internal var backgroundColorMinuteHighlight: UIColor!
    internal var backgroundColorMinuteHighlightNeedle: UIColor!
    
    internal var showingHour = true
    internal var minuteStep: SSCalendarTimeSelectorTimeStep! {
        didSet {
            minutes = []
            let iter = 60 / minuteStep.rawValue
            for i in 0..<iter {
                minutes.append(i * minuteStep.rawValue)
            }
        }
    }
    
    fileprivate let border: CGFloat = 8
    fileprivate let ampmSize: CGFloat = 52
    fileprivate var faceSize: CGFloat = 0
    fileprivate var faceX: CGFloat = 0
    fileprivate let faceY: CGFloat = 8
    fileprivate let amX: CGFloat = 8
    fileprivate var pmX: CGFloat = 0
    fileprivate var ampmY: CGFloat = 0
    fileprivate let numberCircleBorder: CGFloat = 12
    fileprivate let centerPieceSize = 4
    fileprivate let hours = [12, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11]
    fileprivate var minutes: [Int] = []
    
    internal override func draw(_ rect: CGRect) {
        // update frames
        faceSize = min(rect.width - border * 2, rect.height - border * 2 - ampmSize / 3 * 2)
        faceX = (rect.width - faceSize) / 2
        pmX = rect.width - border - ampmSize
        ampmY = rect.height - border - ampmSize
        
        let time = delegate.SSClockGetTime()
        let ctx = UIGraphicsGetCurrentContext()
        let paragraph = NSMutableParagraphStyle()
        paragraph.alignment = NSTextAlignment.center
        
        ctx?.setFillColor(backgroundColorClockFace.cgColor)
        ctx?.fillEllipse(in: CGRect(x: faceX, y: faceY, width: faceSize, height: faceSize))
        
        ctx?.setFillColor(backgroundColorAMPMHighlight.cgColor)
        if time.hour < 12 {
            ctx?.fillEllipse(in: CGRect(x: amX, y: ampmY, width: ampmSize, height: ampmSize))
            var str = NSAttributedString(string: "AM", attributes: [NSFontAttributeName: fontAMPMHighlight, NSForegroundColorAttributeName: fontColorAMPMHighlight, NSParagraphStyleAttributeName: paragraph])
            var ampmHeight = fontAMPMHighlight.lineHeight
            str.draw(in: CGRect(x: amX, y: ampmY + (ampmSize - ampmHeight) / 2, width: ampmSize, height: ampmHeight))
            str = NSAttributedString(string: "PM", attributes: [NSFontAttributeName: fontAMPM, NSForegroundColorAttributeName: fontColorAMPM, NSParagraphStyleAttributeName: paragraph])
            ampmHeight = fontAMPM.lineHeight
            str.draw(in: CGRect(x: pmX, y: ampmY + (ampmSize - ampmHeight) / 2, width: ampmSize, height: ampmHeight))
        }
        else {
            ctx?.fillEllipse(in: CGRect(x: pmX, y: ampmY, width: ampmSize, height: ampmSize))
            var str = NSAttributedString(string: "AM", attributes: [NSFontAttributeName: fontAMPM, NSForegroundColorAttributeName: fontColorAMPM, NSParagraphStyleAttributeName: paragraph])
            var ampmHeight = fontAMPM.lineHeight
            str.draw(in: CGRect(x: amX, y: ampmY + (ampmSize - ampmHeight) / 2, width: ampmSize, height: ampmHeight))
            str = NSAttributedString(string: "PM", attributes: [NSFontAttributeName: fontAMPMHighlight, NSForegroundColorAttributeName: fontColorAMPMHighlight, NSParagraphStyleAttributeName: paragraph])
            ampmHeight = fontAMPMHighlight.lineHeight
            str.draw(in: CGRect(x: pmX, y: ampmY + (ampmSize - ampmHeight) / 2, width: ampmSize, height: ampmHeight))
        }
        
        if showingHour {
            let textAttr = [NSFontAttributeName: fontHour, NSForegroundColorAttributeName: fontColorHour, NSParagraphStyleAttributeName: paragraph] as [String : Any]
            let textAttrHighlight = [NSFontAttributeName: fontHourHighlight, NSForegroundColorAttributeName: fontColorHourHighlight, NSParagraphStyleAttributeName: paragraph] as [String : Any]
            
            let templateSize = NSAttributedString(string: "12", attributes: textAttr).size()
            let templateSizeHighlight = NSAttributedString(string: "12", attributes: textAttrHighlight).size()
            let maxSize = max(templateSize.width, templateSize.height)
            let maxSizeHighlight = max(templateSizeHighlight.width, templateSizeHighlight.height)
            let highlightCircleSize = maxSizeHighlight + numberCircleBorder
            let radius = faceSize / 2 - maxSize
            let radiusHighlight = faceSize / 2 - maxSizeHighlight
            
            ctx?.saveGState()
            ctx?.translateBy(x: faceX + faceSize / 2, y: faceY + faceSize / 2) // everything starts at clock face center
            
            let degreeIncrement = 360 / CGFloat(hours.count)
            let currentHour = get12Hour(time)
            
            for (index, element) in hours.enumerated() {
                let angle = getClockRad(CGFloat(index) * degreeIncrement)
                
                if element == currentHour {
                    // needle
                    ctx?.saveGState()
                    ctx?.setStrokeColor(backgroundColorHourHighlightNeedle.cgColor)
                    ctx?.setLineWidth(1)
                    ctx?.move(to: CGPoint(x: 0, y: 0))
                    ctx?.scaleBy(x: -1, y: 1)
                    ctx?.addLine(to: CGPoint(x: (radiusHighlight - highlightCircleSize / 2) * cos(angle), y: -((radiusHighlight - highlightCircleSize / 2) * sin(angle))))
                    ctx?.scaleBy(x: -1, y: 1)
                    ctx?.strokePath()
                    ctx?.restoreGState()
                    
                    // highlight
                    ctx?.saveGState()
                    ctx?.setFillColor(backgroundColorHourHighlight.cgColor)
                    ctx?.scaleBy(x: -1, y: 1)
                    ctx?.translateBy(x: radiusHighlight * cos(angle), y: -(radiusHighlight * sin(angle)))
                    ctx?.scaleBy(x: -1, y: 1)
                    ctx?.fillEllipse(in: CGRect(x: -highlightCircleSize / 2, y: -highlightCircleSize / 2, width: highlightCircleSize, height: highlightCircleSize))
                    ctx?.restoreGState()
                    
                    // numbers
                    let hour = NSAttributedString(string: "\(element)", attributes: textAttrHighlight)
                    ctx?.saveGState()
                    ctx?.scaleBy(x: -1, y: 1)
                    ctx?.translateBy(x: radiusHighlight * cos(angle), y: -(radiusHighlight * sin(angle)))
                    ctx?.scaleBy(x: -1, y: 1)
                    ctx?.translateBy(x: -hour.size().width / 2, y: -hour.size().height / 2)
                    hour.draw(at: CGPoint.zero)
                    ctx?.restoreGState()
                }
                else {
                    // numbers
                    let hour = NSAttributedString(string: "\(element)", attributes: textAttr)
                    ctx?.saveGState()
                    ctx?.scaleBy(x: -1, y: 1)
                    ctx?.translateBy(x: radius * cos(angle), y: -(radius * sin(angle)))
                    ctx?.scaleBy(x: -1, y: 1)
                    ctx?.translateBy(x: -hour.size().width / 2, y: -hour.size().height / 2)
                    hour.draw(at: CGPoint.zero)
                    ctx?.restoreGState()
                }
            }
        }
        else {
            let textAttr = [NSFontAttributeName: fontMinute, NSForegroundColorAttributeName: fontColorMinute, NSParagraphStyleAttributeName: paragraph] as [String : Any]
            let textAttrHighlight = [NSFontAttributeName: fontMinuteHighlight, NSForegroundColorAttributeName: fontColorMinuteHighlight, NSParagraphStyleAttributeName: paragraph] as [String : Any]
            let templateSize = NSAttributedString(string: "60", attributes: textAttr).size()
            let templateSizeHighlight = NSAttributedString(string: "60", attributes: textAttrHighlight).size()
            let maxSize = max(templateSize.width, templateSize.height)
            let maxSizeHighlight = max(templateSizeHighlight.width, templateSizeHighlight.height)
            let minSize: CGFloat = 0
            let highlightCircleMaxSize = maxSizeHighlight + numberCircleBorder
            let highlightCircleMinSize = minSize + numberCircleBorder
            let radius = faceSize / 2 - maxSize
            let radiusHighlight = faceSize / 2 - maxSizeHighlight
            
            ctx?.saveGState()
            ctx?.translateBy(x: faceX + faceSize / 2, y: faceY + faceSize / 2) // everything starts at clock face center
            
            let degreeIncrement = 360 / CGFloat(minutes.count)
            let currentMinute = get60Minute(time)
            
            for (index, element) in minutes.enumerated() {
                let angle = getClockRad(CGFloat(index) * degreeIncrement)
                
                if element == currentMinute {
                    // needle
                    ctx?.saveGState()
                    ctx?.setStrokeColor(backgroundColorMinuteHighlightNeedle.cgColor)
                    ctx?.setLineWidth(1)
                    ctx?.move(to: CGPoint(x: 0, y: 0))
                    ctx?.scaleBy(x: -1, y: 1)
                    if minuteStep.rawValue < 5 && element % 5 != 0 {
                        ctx?.addLine(to: CGPoint(x: (radiusHighlight - highlightCircleMinSize / 2) * cos(angle), y: -((radiusHighlight - highlightCircleMinSize / 2) * sin(angle))))
                    }
                    else {
                        ctx?.addLine(to: CGPoint(x: (radiusHighlight - highlightCircleMaxSize / 2) * cos(angle), y: -((radiusHighlight - highlightCircleMaxSize / 2) * sin(angle))))
                    }
                    ctx?.scaleBy(x: -1, y: 1)
                    ctx?.strokePath()
                    ctx?.restoreGState()
                    
                    // highlight
                    ctx?.saveGState()
                    ctx?.setFillColor(backgroundColorMinuteHighlight.cgColor)
                    ctx?.scaleBy(x: -1, y: 1)
                    ctx?.translateBy(x: radiusHighlight * cos(angle), y: -(radiusHighlight * sin(angle)))
                    ctx?.scaleBy(x: -1, y: 1)
                    if minuteStep.rawValue < 5 && element % 5 != 0 {
                        ctx?.fillEllipse(in: CGRect(x: -highlightCircleMinSize / 2, y: -highlightCircleMinSize / 2, width: highlightCircleMinSize, height: highlightCircleMinSize))
                    }
                    else {
                        ctx?.fillEllipse(in: CGRect(x: -highlightCircleMaxSize / 2, y: -highlightCircleMaxSize / 2, width: highlightCircleMaxSize, height: highlightCircleMaxSize))
                    }
                    ctx?.restoreGState()
                    
                    // numbers
                    if minuteStep.rawValue < 5 {
                        if element % 5 == 0 {
                            let min = NSAttributedString(string: "\(element)", attributes: textAttrHighlight)
                            ctx?.saveGState()
                            ctx?.scaleBy(x: -1, y: 1)
                            ctx?.translateBy(x: radiusHighlight * cos(angle), y: -(radiusHighlight * sin(angle)))
                            ctx?.scaleBy(x: -1, y: 1)
                            ctx?.translateBy(x: -min.size().width / 2, y: -min.size().height / 2)
                            min.draw(at: CGPoint.zero)
                            ctx?.restoreGState()
                        }
                    }
                    else {
                        let min = NSAttributedString(string: "\(element)", attributes: textAttrHighlight)
                        ctx?.saveGState()
                        ctx?.scaleBy(x: -1, y: 1)
                        ctx?.translateBy(x: radiusHighlight * cos(angle), y: -(radiusHighlight * sin(angle)))
                        ctx?.scaleBy(x: -1, y: 1)
                        ctx?.translateBy(x: -min.size().width / 2, y: -min.size().height / 2)
                        min.draw(at: CGPoint.zero)
                        ctx?.restoreGState()
                    }
                }
                else {
                    // numbers
                    if minuteStep.rawValue < 5 {
                        if element % 5 == 0 {
                            let min = NSAttributedString(string: "\(element)", attributes: textAttr)
                            ctx?.saveGState()
                            ctx?.scaleBy(x: -1, y: 1)
                            ctx?.translateBy(x: radius * cos(angle), y: -(radius * sin(angle)))
                            ctx?.scaleBy(x: -1, y: 1)
                            ctx?.translateBy(x: -min.size().width / 2, y: -min.size().height / 2)
                            min.draw(at: CGPoint.zero)
                            ctx?.restoreGState()
                        }
                    }
                    else {
                        let min = NSAttributedString(string: "\(element)", attributes: textAttr)
                        ctx?.saveGState()
                        ctx?.scaleBy(x: -1, y: 1)
                        ctx?.translateBy(x: radius * cos(angle), y: -(radius * sin(angle)))
                        ctx?.scaleBy(x: -1, y: 1)
                        ctx?.translateBy(x: -min.size().width / 2, y: -min.size().height / 2)
                        min.draw(at: CGPoint.zero)
                        ctx?.restoreGState()
                    }
                }
            }
        }
        
        // center piece
        ctx?.setFillColor(backgroundColorClockFaceCenter.cgColor)
        ctx?.fillEllipse(in: CGRect(x: -centerPieceSize / 2, y: -centerPieceSize / 2, width: centerPieceSize, height: centerPieceSize))
        ctx?.restoreGState()
    }
    
    fileprivate func get60Minute(_ date: Date) -> Int {
        return date.minute
    }
    
    fileprivate func get12Hour(_ date: Date) -> Int {
        let hr = date.hour
        return hr == 0 || hr == 12 ? 12 : hr < 12 ? hr : hr - 12
    }
    
    fileprivate func getClockRad(_ degrees: CGFloat) -> CGFloat {
        let radOffset = 90.degreesToRadians // add this number to get 12 at top, 3 at right
        return degrees.degreesToRadians + radOffset
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.sorted(by: { $0.timestamp < $1.timestamp }).last {
            let pt = touch.location(in: self)
            
            // see if tap on AM or PM, making the boundary bigger
            let amRect = CGRect(x: 0, y: ampmY, width: ampmSize + border * 2, height: ampmSize + border)
            let pmRect = CGRect(x: bounds.width - ampmSize - border, y: ampmY, width: ampmSize + border * 2, height: ampmSize + border)
            
            if amRect.contains(pt) {
                delegate.SSClockSwitchAMPM(isAM: true, isPM: false)
            }
            else if pmRect.contains(pt) {
                delegate.SSClockSwitchAMPM(isAM: false, isPM: true)
            }
            else {
                touchClock(pt: pt)
            }
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.sorted(by: { $0.timestamp < $1.timestamp }).last {
            let pt = touch.location(in: self)
            touchClock(pt: pt)
        }
    }
    
    fileprivate func touchClock(pt: CGPoint) {
        let touchPoint = CGPoint(x: pt.x - faceX - faceSize / 2, y: pt.y - faceY - faceSize / 2) // this means centerpoint will be 0, 0
        
        if showingHour {
            let degreeIncrement = 360 / CGFloat(hours.count)
            
            var angle = 180 - atan2(touchPoint.x, touchPoint.y).radiansToDegrees // with respect that 12 o'clock position is 0 degrees, and 3 o'clock position is 90 degrees
            if angle < 0 {
                angle = 0
            }
            angle = angle - degreeIncrement / 2
            var index = Int(floor(angle / degreeIncrement)) + 1
            
            if index < 0 || index > (hours.count - 1) {
                index = 0
            }
            
            let hour = hours[index]
            let time = delegate.SSClockGetTime()
            if hour == 12 {
                delegate.SSClockSetHourMilitary(time.hour < 12 ? 0 : 12)
            }
            else {
                delegate.SSClockSetHourMilitary(time.hour < 12 ? hour : 12 + hour)
            }
        }
        else {
            let degreeIncrement = 360 / CGFloat(minutes.count)
            
            var angle = 180 - atan2(touchPoint.x, touchPoint.y).radiansToDegrees // with respect that 12 o'clock position is 0 degrees, and 3 o'clock position is 90 degrees
            if angle < 0 {
                angle = 0
            }
            angle = angle - degreeIncrement / 2
            var index = Int(floor(angle / degreeIncrement)) + 1
            
            if index < 0 || index > (minutes.count - 1) {
                index = 0
            }
            
            let minute = minutes[index]
            delegate.SSClockSetMinute(minute)
        }
    }
}

private extension CGFloat {
    var doubleValue:      Double  { return Double(self) }
    var degreesToRadians: CGFloat { return CGFloat(doubleValue * .pi / 180) }
    var radiansToDegrees: CGFloat { return CGFloat(doubleValue * 180 / .pi) }
}

private extension Int {
    var doubleValue:      Double  { return Double(self) }
    var degreesToRadians: CGFloat { return CGFloat(doubleValue * .pi / 180) }
    var radiansToDegrees: CGFloat { return CGFloat(doubleValue * 180 / .pi) }
}
