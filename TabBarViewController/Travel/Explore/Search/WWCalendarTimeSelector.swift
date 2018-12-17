/**
 * WWCalendarTimeSelector.swift
 *
 * @package Makent
 * @subpackage Controller
 * @category Calendar
 * @author Trioangle Product Team
 * @version - Stable 1.0
 * @link http://trioangle.com
 */

import UIKit
import FLAnimatedImage

@objc public final class WWCalendarTimeSelectorStyle: NSObject {
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
@objc public enum WWCalendarTimeSelectorSelection: Int {
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
@objc public enum WWCalendarTimeSelectorMultipleSelectionGrouping: Int {
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
@objc public enum WWCalendarTimeSelectorTimeStep: Int {
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

@objc open class WWCalendarTimeSelectorDateRange: NSObject {
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

/// The delegate of `WWCalendarTimeSelector` can adopt the `WWCalendarTimeSelectorProtocol` optional methods. The following Optional methods are available:
///
/// `WWCalendarTimeSelectorDone:selector:dates:`
/// `WWCalendarTimeSelectorDone:selector:date:`
/// `WWCalendarTimeSelectorCancel:selector:dates:`
/// `WWCalendarTimeSelectorCancel:selector:date:`
/// `WWCalendarTimeSelectorWillDismiss:selector:`
/// `WWCalendarTimeSelectorDidDismiss:selector:`
@objc public protocol WWCalendarTimeSelectorProtocol {
    
    /// Method called before the selector is dismissed, and when user is Done with the selector.
    ///
    /// This method is only called when `optionMultipleSelection` is `true`.
    ///
    /// - SeeAlso:
    /// `WWCalendarTimeSelectorDone:selector:date:`
    ///
    /// - Parameters:
    ///     - selector: The selector that will be dismissed.
    ///     - dates: Selected dates.
    @objc optional func WWCalendarTimeSelectorDone(_ selector: WWCalendarTimeSelector, dates: [Date])
    
    /// Method called before the selector is dismissed, and when user is Done with the selector.
    ///
    /// This method is only called when `optionMultipleSelection` is `false`.
    ///
    /// - SeeAlso:
    /// `WWCalendarTimeSelectorDone:selector:dates:`
    ///
    /// - Parameters:
    ///     - selector: The selector that will be dismissed.
    ///     - dates: Selected date.
    @objc optional func WWCalendarTimeSelectorDone(_ selector: WWCalendarTimeSelector, date: Date)
    
    /// Method called before the selector is dismissed, and when user Cancel the selector.
    ///
    /// This method is only called when `optionMultipleSelection` is `true`.
    ///
    /// - SeeAlso:
    /// `WWCalendarTimeSelectorCancel:selector:date:`
    ///
    /// - Parameters:
    ///     - selector: The selector that will be dismissed.
    ///     - dates: Selected dates.
    @objc optional func WWCalendarTimeSelectorCancel(_ selector: WWCalendarTimeSelector, dates: [Date])
    
    /// Method called before the selector is dismissed, and when user Cancel the selector.
    ///
    /// This method is only called when `optionMultipleSelection` is `false`.
    ///
    /// - SeeAlso:
    /// `WWCalendarTimeSelectorCancel:selector:dates:`
    ///
    /// - Parameters:
    ///     - selector: The selector that will be dismissed.
    ///     - dates: Selected date.
    @objc optional func WWCalendarTimeSelectorCancel(_ selector: WWCalendarTimeSelector, date: Date)
    
    /// Method called before the selector is dismissed.
    ///
    /// - SeeAlso:
    /// `WWCalendarTimeSelectorDidDismiss:selector:`
    ///
    /// - Parameters:
    ///     - selector: The selector that will be dismissed.
    @objc optional func WWCalendarTimeSelectorWillDismiss(_ selector: WWCalendarTimeSelector)
    
    /// Method called after the selector is dismissed.
    ///
    /// - SeeAlso:
    /// `WWCalendarTimeSelectorWillDismiss:selector:`
    ///
    /// - Parameters:
    ///     - selector: The selector that has been dismissed.
    @objc optional func WWCalendarTimeSelectorDidDismiss(_ selector: WWCalendarTimeSelector)
    
    /// Method if implemented, will be used to determine if a particular date should be selected.
    ///
    /// - Parameters:
    ///     - selector: The selector that is checking for selectablity of date.
    ///     - date: The date that user tapped, but have not yet given feedback to determine if should be selected.
    @objc optional func WWCalendarTimeSelectorShouldSelectDate(_ selector: WWCalendarTimeSelector, date: Date) -> Bool
}

open class WWCalendarTimeSelector: UIViewController, UITableViewDelegate, UITableViewDataSource, WWCalendarRowProtocol, WWClockProtocol {
    
    /// The delegate of `WWCalendarTimeSelector` can adopt the `WWCalendarTimeSelectorProtocol` optional methods. The following Optional methods are available:
    ///
    /// `WWCalendarTimeSelectorDone:selector:dates:`
    /// `WWCalendarTimeSelectorDone:selector:date:`
    /// `WWCalendarTimeSelectorCancel:selector:dates:`
    /// `WWCalendarTimeSelectorCancel:selector:date:`
    /// `WWCalendarTimeSelectorWillDismiss:selector:`
    /// `WWCalendarTimeSelectorDidDismiss:selector:`
    open var delegate: WWCalendarTimeSelectorProtocol?
    open var callAPI: Bool = false
    open var arrBlockedDates : NSMutableArray = NSMutableArray()
    /// A convenient identifier object. Not used by `WWCalendarTimeSelector`.
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
    open var optionStyles: WWCalendarTimeSelectorStyle = WWCalendarTimeSelectorStyle()
    
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
    open var optionTimeStep: WWCalendarTimeSelectorTimeStep = .oneMinute
    
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
    open var optionSelectionType: WWCalendarTimeSelectorSelection = .single
    
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
    open var optionCurrentDateRange: WWCalendarTimeSelectorDateRange = WWCalendarTimeSelectorDateRange()
    
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
    open var optionMultipleSelectionGrouping: WWCalendarTimeSelectorMultipleSelectionGrouping = .pill
    
    
    // Fonts & Colors
    open var optionCalendarFontMonth = UIFont.systemFont(ofSize: 14)
    open var optionCalendarFontDays = UIFont.systemFont(ofSize: 16)
    open var optionCalendarFontToday = UIFont.boldSystemFont(ofSize: 20)
    open var optionCalendarFontTodayHighlight = UIFont.boldSystemFont(ofSize: 16)
    open var optionCalendarFontPastDates = UIFont.boldSystemFont(ofSize: 16)
    open var optionCalendarFontPastDatesHighlight = UIFont.boldSystemFont(ofSize: 13)
    open var optionCalendarFontFutureDates = UIFont.boldSystemFont(ofSize: 16)
    open var optionCalendarFontFutureDatesHighlight = UIFont.boldSystemFont(ofSize: 16)
    
    open var optionCalendarFontColorMonth = UIColor.white
    open var optionCalendarFontColorDays = UIColor.white
    open var optionCalendarFontColorToday = UIColor.white
    open var optionCalendarFontColorTodayHighlight = UIColor.black
    open var optionCalendarBackgroundColorTodayHighlight = UIColor.white
    open var optionCalendarBackgroundColorTodayFlash = UIColor.white
    open var optionCalendarFontColorPastDates = UIColor.white.withAlphaComponent(0.5)
    open var optionCalendarFontColorPastDatesHighlight = UIColor.white
    open var optionCalendarBackgroundColorPastDatesHighlight = UIColor.brown
    open var optionCalendarBackgroundColorPastDatesFlash = UIColor.white
    open var optionCalendarFontColorFutureDates = UIColor.white
    open var optionCalendarFontColorFutureDatesHighlight = UIColor.black
    open var optionCalendarBackgroundColorFutureDatesHighlight = UIColor.white
    open var optionCalendarBackgroundColorFutureDatesFlash = UIColor.black
    
    open var optionCalendarFontCurrentYear = UIFont.boldSystemFont(ofSize: 18)
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
    //    @IBOutlet fileprivate weak var viewGradient: UIView!
    
    @IBOutlet fileprivate weak var yearTable: UITableView!
    @IBOutlet fileprivate weak var clockView: WWClock!
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
    var room_Id = ""
    
    
    var isDateSelected : Bool = false
    var isFromExplorePage : Bool = false
    
    @IBOutlet var viewErrorHolder: UIView!
    @IBOutlet var lblErrorMsg: UILabel!
    var appDelegate  = UIApplication.shared.delegate as! AppDelegate
    
    
    @IBOutlet var animatedImgBooking: FLAnimatedImageView?
    
    // Private Variables
    fileprivate let selAnimationDuration: TimeInterval = 0.4
    fileprivate let selInactiveHeight: CGFloat = 48
    fileprivate var portraitContainerWidth: CGFloat { return optionLayoutWidth ?? optionLayoutWidthRatio * portraitWidth }
    fileprivate var portraitTopContainerHeight: CGFloat { return optionShowTopContainer ? (optionLayoutHeight ?? optionLayoutHeightRatio * portraitHeight) * optionLayoutPortraitRatio : 0 }
    fileprivate var portraitBottomContainerHeight: CGFloat { return (optionLayoutHeight ?? optionLayoutHeightRatio * portraitHeight) - portraitTopContainerHeight }
    fileprivate var landscapeContainerHeight: CGFloat { return optionLayoutWidth ?? optionLayoutWidthRatio * portraitWidth }
    fileprivate var landscapeTopContainerWidth: CGFloat { return optionShowTopContainer ? (optionLayoutHeight ?? optionLayoutHeightRatio * portraitHeight) * optionLayoutLandscapeRatio : 0 }
    fileprivate var landscapeBottomContainerWidth: CGFloat { return (optionLayoutHeight ?? optionLayoutHeightRatio * portraitHeight) - landscapeTopContainerWidth }
    fileprivate var selCurrrent: WWCalendarTimeSelectorStyle = WWCalendarTimeSelectorStyle(isSingular: true)
    fileprivate var isFirstLoad = false
    fileprivate var selTimeStateHour = true
    fileprivate var calRow1Type: WWCalendarRowType = WWCalendarRowType.date
    fileprivate var calRow2Type: WWCalendarRowType = WWCalendarRowType.date
    fileprivate var calRow3Type: WWCalendarRowType = WWCalendarRowType.date
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
    
    fileprivate let weekDays = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"]
    
    open static func instantiate() -> WWCalendarTimeSelector {
        let podBundle = Bundle(for: self.classForCoder())
        let bundleURL = podBundle.url(forResource: "WWCalendarTimeSelectorStoryboardBundle", withExtension: "bundle")
        var bundle: Bundle?
        if let bundleURL = bundleURL {
            bundle = Bundle(url: bundleURL)
        }
        return UIStoryboard(name: "WWCalendarTimeSelector", bundle: bundle).instantiateInitialViewController() as! WWCalendarTimeSelector
    }
    
    open override func awakeFromNib() {
        super.awakeFromNib()
        modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        modalTransitionStyle = UIModalTransitionStyle.crossDissolve
    }
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        
        STOREVALUE(value: "notselected", keyname: "isDateSelected")
        viewErrorHolder.isHidden = true
        
        if callAPI
        {
            self.animatedImgBooking?.isHidden = true
        }
        
        let seventhRowStartDate = optionCurrentDate.beginningOfMonth
        calRow3StartDate = ((seventhRowStartDate - 1.day).beginningOfWeek - 1.day).beginningOfWeek
        calRow2StartDate = (calRow3StartDate - 1.day).beginningOfWeek
        calRow1StartDate = (calRow2StartDate - 1.day).beginningOfWeek
        
        yearRow1 = optionCurrentDate.year - 5
        calendarTable.setContentOffset(CGPoint(x: 0, y:250), animated:true)
        
        view.layoutIfNeeded()
        
        UIDevice.current.beginGeneratingDeviceOrientationNotifications()
        NotificationCenter.default.addObserver(self, selector: #selector(WWCalendarTimeSelector.didRotateOrNot), name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
        
        doneButton.layer.cornerRadius = 6
        updateDate()
        isFirstLoad = true
        
    }
    
    open override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if isFirstLoad {
            isFirstLoad = false // Temp fix for i6s+ bug?
            calendarTable.reloadData()
            //yearTable.reloadData()
            //clockView.setNeedsDisplay()
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
    }
    
    open override var preferredStatusBarStyle: UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }
    
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
    
    @IBAction func selectMonth(_ sender: UIButton) {
        let date = (optionCurrentDate.beginningOfYear + sender.tag.months).beginningOfDay
        if delegate?.WWCalendarTimeSelectorShouldSelectDate?(self, date: date) ?? true {
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
        }
        else {
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
        }
        else {
            isSelectingStartRange = false
        }
        shouldResetRange = false
        updateDate()
    }
    
    @IBAction func showDate() {
        if optionStyles.showDateMonth {
            showDate(true)
        }
        else {
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
        if isFromExplorePage
        {
            self.cancelTapped()
            let _ = navigationController?.popViewController(animated: false)
            return
        }
        let picker = self
        let del = delegate
        if optionSelectionType == .single {
            del?.WWCalendarTimeSelectorCancel?(picker, date: optionCurrentDate)
        }
        else {
            del?.WWCalendarTimeSelectorCancel?(picker, dates: multipleDates)
        }
        del?.WWCalendarTimeSelectorWillDismiss?(picker)
        
        dismiss(animated: true) {
            del?.WWCalendarTimeSelectorDidDismiss?(picker)
        }
    }
    
    func cancelTapped() {
        let picker = self
        let del = delegate
        del?.WWCalendarTimeSelectorCancel?(picker, dates: multipleDates)
    }
    /* Temp code here */
    func isPad() -> Bool
    {
        let deviceIdiom = UIScreen.main.traitCollection.userInterfaceIdiom
        switch (deviceIdiom)
        {
        case .pad:
            return true
        case .phone:
            return false
        default:
            break
        }
        return false
    }
    
    
    func getScreenSize() -> CGRect
    {
        var rect = UIScreen.main.bounds as CGRect
        let orientation = UIApplication.shared.statusBarOrientation as UIInterfaceOrientation
        
        if self.isPad()
        {
            if(orientation.isLandscape)
            {
                rect = CGRect(x: 0, y:0,width: 1024 ,height: 768)
            }
            else
            {
                rect = CGRect(x: 0, y:0,width: 768 ,height: 1024)
            }
        }
        return rect
    }
    //MARK: API CALL FOR CHECKING AVAILABILITY
    func checkAvailableDatesForBooking(dates:[Date])
    {
        if let path =  Bundle.main.path(forResource: "dot_loading_white", ofType: "gif")
        {
            if let data = NSData(contentsOfFile: path) {
                let gif = FLAnimatedImage(animatedGIFData: data as Data!)
                animatedImgBooking?.animatedImage = gif
            }
        }
        
        self.doneButton.titleLabel?.text = ""
        doneButton.setTitle("", for: .normal)
        let rect = self.getScreenSize()
        
        var rectImg = animatedImgBooking?.frame
        rectImg?.origin.y = rect.size.height - 50
        animatedImgBooking?.frame = rectImg!
        
        animatedImgBooking?.isHidden = false
        
        let formalDates = dates
        let startDay = formalDates[0]
        let lastDay = formalDates.last
        
        
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateStyle = DateFormatter.Style.medium
        
        dateFormatter.timeStyle = DateFormatter.Style.none
        dateFormatter.dateFormat = "dd-MM-yyy"
        
        var strCheckOutDate = ""
        let strCheckInDate = dateFormatter.string(from: startDay)
        
        
        if !shouldResetRange && formalDates.count==1
        {
            shouldResetRange = false
            let startDay = optionCurrentDateRange.start
            let start = Calendar.current.date(byAdding: .day, value: 1, to: startDay)
            optionCurrentDateRange.setEndDate((start?.beginningOfDay)!)
            strCheckOutDate = dateFormatter.string(from: (start)!)
            
        }
        else
        {
            strCheckOutDate = dateFormatter.string(from: lastDay!)
        }
        
        
        
        let dicts = NSMutableDictionary()
        dicts["start_date"] =  strCheckInDate
        dicts["end_date"] =  strCheckOutDate//strCheckOutDate
        dicts["room_id"] =  room_Id
        
        ServerAPI.sharedInstance.makeCall(requestMethod: "GET", apiName: API_ROOM_AVAILABLE_STATUS, params: dicts, isTokenRequired: true, forSuccessionBlock: { (response, error) in
            OperationQueue.main.addOperation {
                if(error != nil){
                    self.doneButton.setTitle("Save", for: .normal)
                    self.doneButton.titleLabel?.text = "Save"
                    self.disPlayErrorView()
                }else{
                    if response != nil {
                        self.onSuccess()
                    }
                }
                self.animatedImgBooking?.isHidden = true
            }
        }) { (error) in
            self.animatedImgBooking?.isHidden = true
        }
        
    }
    
    func disPlayErrorView()
    {
        let formalDates = optionCurrentDateRange.array
        WWCalendarRowDidSelect(formalDates[0])
        shouldResetRange = true
        calendarTable.reloadData()
        lblErrorMsg.text = "Those dates are not available"
        viewErrorHolder.isHidden = false
        updateDate()
        
        let rangeDate = formalDates[0].beginningOfDay
        let start = Calendar.current.date(byAdding: .day, value: 1, to: rangeDate)
        let getLastDayWeek = self.getDayOfWeek(today: (start?.stringFromFormat("d' 'MMM' 'yyyy"))!)
        rangeEndLabel.text = (String(format: "%@ %@",weekDays[getLastDayWeek-1], (start?.stringFromFormat("d' 'MMM' 'yyyy"))!) as NSString) as String
        doneButton.isUserInteractionEnabled = true
        doneButton.alpha = 1.0
        
    }
    
    func onSuccess()
    {
        let picker = self
        let del = delegate
        switch optionSelectionType {
        case .single:
            del?.WWCalendarTimeSelectorDone?(picker, date: optionCurrentDate)
        case .multiple:
            del?.WWCalendarTimeSelectorDone?(picker, dates: multipleDates)
        case .range:
            del?.WWCalendarTimeSelectorDone?(picker, dates: optionCurrentDateRange.array)
        }
        del?.WWCalendarTimeSelectorWillDismiss?(picker)
        STOREVALUE(value: (self.rangeStartLabel.text! as NSString) as String, keyname: "START_DATE")
        STOREVALUE(value: (self.rangeEndLabel.text! as NSString) as String, keyname: "END_DATE")
        
        if isFromExplorePage
        {
            let _ = navigationController?.popViewController(animated: false)
        }
        else
        {
            dismiss(animated: true) {
                del?.WWCalendarTimeSelectorDidDismiss?(picker)
            }
        }
    }
    
    @IBAction func done() {
        if isFromExplorePage
        {
            self.onSuccess()
            return
        }
        self.checkAvailableDatesForBooking(dates: optionCurrentDateRange.array)
    }
    
    @IBAction func closeErrorView() {
        viewErrorHolder.isHidden = true
    }
    
    
    fileprivate func showDate(_ userTap: Bool) {
        changeSelDate()
        
        if userTap {
            let seventhRowStartDate = optionCurrentDate.beginningOfMonth
            calRow3StartDate = ((seventhRowStartDate - 1.day).beginningOfWeek - 1.day).beginningOfWeek
            calRow2StartDate = (calRow3StartDate - 1.day).beginningOfWeek
            calRow1StartDate = (calRow2StartDate - 1.day).beginningOfWeek
            calendarTable.reloadData()
            calendarTable.scrollToRow(at: IndexPath(row: 4, section: 0), at: UITableViewScrollPosition.top, animated: true)
        }
        else {
            calendarTable.reloadData()
        }
        
        UIView.animate(
            withDuration: selAnimationDuration,
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
            
        }
        else {
            
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
        }
        else {
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
            }
            else {
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
        
        rangeStartLabel.text = optionCurrentDateRange.start.stringFromFormat("d' 'MMM' 'yyyy")
        rangeEndLabel.text = optionCurrentDateRange.end.stringFromFormat("d' 'MMM' 'yyyy")
        
        let getWeekDay = self.getDayOfWeek(today: optionCurrentDateRange.start.stringFromFormat("d' 'MMM' 'yyyy"))
        
        var getLastDayWeek = self.getDayOfWeek(today: optionCurrentDateRange.end.stringFromFormat("d' 'MMM' 'yyyy"))
        
        rangeStartLabel.text = (String(format: "%@ %@",weekDays[getWeekDay-1], optionCurrentDateRange.start.stringFromFormat("d' 'MMM' 'yyyy")) as NSString) as String
        
        rangeEndLabel.text = (String(format: "%@ %@",weekDays[getLastDayWeek-1], optionCurrentDateRange.end.stringFromFormat("d' 'MMM' 'yyyy")) as NSString) as String
        
        
        if shouldResetRange {
            rangeStartLabel.textColor = optionSelectorPanelFontColorDateHighlight
            rangeEndLabel.textColor = optionSelectorPanelFontColorDateHighlight
            //            doneButton.alpha = 1.0
            //            doneButton.isUserInteractionEnabled = true
        }
        else {
            rangeStartLabel.textColor = isSelectingStartRange ?  optionSelectorPanelFontColorDate: optionSelectorPanelFontColorDateHighlight
            rangeEndLabel.textColor = isSelectingStartRange ?  optionSelectorPanelFontColorDateHighlight: optionSelectorPanelFontColorDate
        }
        
        if rangeStartLabel.text == rangeEndLabel.text
        {
            shouldResetRange = false
            
            rangeEndLabel.textColor = optionSelectorPanelFontColorDateHighlight
            
            let startDay = optionCurrentDateRange.start
            let start = Calendar.current.date(byAdding: .day, value: 1, to: startDay)
            
            
            if getLastDayWeek==7
            {
                getLastDayWeek = 0
            }
            rangeEndLabel.text = (String(format: "%@ %@",weekDays[getLastDayWeek], (start?.stringFromFormat("d' 'MMM' 'yyyy"))!) as NSString) as String
        }
    }
    fileprivate func changeSelDate() {
    }
    
    fileprivate func changeSelMonth() {
        
    }
    
    fileprivate func changeSelYear() {
        let selInactiveHeight = self.selInactiveHeight
        
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
            }
            else {
                selDateRightConstraint.constant = 0
                selYearHeightConstraint.constant = 0
                selYearTopConstraint.constant = 0
            }
        }
        else {
            selDateHeightConstraint.constant = 0
            selDateTopConstraint.constant = 0
            if optionStyles.showYear {
                selYearHeightConstraint.constant = selInactiveHeight
                selYearLeftConstraint.constant = 0
            }
            else {
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
            if let c = tableView.dequeueReusableCell(withIdentifier: "cell") {
                cell = c
            }
            else {
                cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "cell")
                let calRow = WWCalendarRow()
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
                
                if arrBlockedDates.count>0
                {
                    calRow.arrBlockedDates = arrBlockedDates
                    calRow.isDateSelected = isDateSelected
                }
            }
            
            for sv in cell.contentView.subviews {
                if let calRow = sv as? WWCalendarRow {
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
        }
            
        else { // multiple dates table
            if let c = tableView.dequeueReusableCell(withIdentifier: "cell") {
                cell = c
            }
            else {
                cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "cell")
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
            if delegate?.WWCalendarTimeSelectorShouldSelectDate?(self, date: newDate!) ?? true {
                optionCurrentDate = newDate!
                updateDate()
                tableView.reloadData()
            }
        }
    }
    
    open func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        
        if scrollView == calendarTable {
            let twoRow = bottomContainerView.frame.height / 4
            if offsetY < twoRow {
                // every row shift by 4 to the back, recalculate top 3 towards earlier dates
                
                let detail1 = WWCalendarRowGetDetails(-3)
                let detail2 = WWCalendarRowGetDetails(-2)
                let detail3 = WWCalendarRowGetDetails(-1)
                calRow1Type = detail1.type
                calRow1StartDate = detail1.startDate
                calRow2Type = detail2.type
                calRow2StartDate = detail2.startDate
                calRow3Type = detail3.type
                calRow3StartDate = detail3.startDate
                
                scrollView.contentOffset = CGPoint(x: 0, y: offsetY + twoRow * 2)
                calendarTable.reloadData()
            }
            else if offsetY > twoRow * 3 {
                // every row shift by 4 to the front, recalculate top 3 towards later dates
                
                let detail1 = WWCalendarRowGetDetails(5)
                let detail2 = WWCalendarRowGetDetails(6)
                let detail3 = WWCalendarRowGetDetails(7)
                calRow1Type = detail1.type
                calRow1StartDate = detail1.startDate
                calRow2Type = detail2.type
                calRow2StartDate = detail2.startDate
                calRow3Type = detail3.type
                calRow3StartDate = detail3.startDate
                
                scrollView.contentOffset = CGPoint(x: 0, y: offsetY - twoRow * 2)
                calendarTable.reloadData()
            }
        }
        else if scrollView == yearTable {
            let triggerPoint = backgroundContentView.frame.height / 10 * 3
            if offsetY < triggerPoint {
                yearRow1 = yearRow1 - 3
                
                scrollView.contentOffset = CGPoint(x: 0, y: offsetY + triggerPoint * 2)
                yearTable.reloadData()
            }
            else if offsetY > triggerPoint * 3 {
                yearRow1 = yearRow1 + 3
                
                scrollView.contentOffset = CGPoint(x: 0, y: offsetY - triggerPoint * 2)
                yearTable.reloadData()
            }
        }
    }
    
    
    internal func WWCalendarRowGetDetails(_ row: Int) -> (type: WWCalendarRowType, startDate: Date) {
        if row == 1 {
            return (calRow1Type, calRow1StartDate)
        }
        else if row == 2 {
            return (calRow2Type, calRow2StartDate)
        }
        else if row == 3 {
            return (calRow3Type, calRow3StartDate)
        }
        else if row > 3 {
            var startRow: Int
            var startDate: Date
            var rowType: WWCalendarRowType
            if calRow3Type == .date {
                startRow = 3
                startDate = calRow3StartDate
                rowType = calRow3Type
            }
            else if calRow2Type == .date {
                startRow = 2
                startDate = calRow2StartDate
                rowType = calRow2Type
            }
            else {
                startRow = 1
                startDate = calRow1StartDate
                rowType = calRow1Type
            }
            
            for _ in startRow..<row {
                if rowType == .month {
                    rowType = .day
                }
                else if rowType == .day {
                    rowType = .date
                    startDate = startDate.beginningOfMonth
                }
                else {
                    let newStartDate = startDate.endOfWeek + 1.day
                    if newStartDate.month != startDate.month {
                        rowType = .month
                    }
                    startDate = newStartDate
                }
            }
            return (rowType, startDate)
        }
        else {
            // row <= 0
            var startRow: Int
            var startDate: Date
            var rowType: WWCalendarRowType
            if calRow1Type == .date {
                startRow = 1
                startDate = calRow1StartDate
                rowType = calRow1Type
            }
            else if calRow2Type == .date {
                startRow = 2
                startDate = calRow2StartDate
                rowType = calRow2Type
            }
            else {
                startRow = 3
                startDate = calRow3StartDate
                rowType = calRow3Type
            }
            
            for _ in row..<startRow {
                if rowType == .date {
                    if startDate.day == 1 {
                        rowType = .day
                    }
                    else {
                        let newStartDate = (startDate - 1.day).beginningOfWeek
                        if newStartDate.month != startDate.month {
                            startDate = startDate.beginningOfMonth
                        }
                        else {
                            startDate = newStartDate
                        }
                    }
                }
                else if rowType == .day {
                    rowType = .month
                }
                else {
                    rowType = .date
                    startDate = (startDate - 1.day).beginningOfWeek
                }
            }
            return (rowType, startDate)
        }
    }
    
    //MARK: *************** Select date *****************
    
    internal func WWCalendarRowDidSelect(_ date: Date) {
        if delegate?.WWCalendarTimeSelectorShouldSelectDate?(self, date: date) ?? true {
            switch optionSelectionType {
            case .single:
                optionCurrentDate = optionCurrentDate.change(year: date.year, month: date.month, day: date.day)
                updateDate()
                
            case .multiple:
                break
            case .range:
                
                if !viewErrorHolder.isHidden
                {
                    viewErrorHolder.isHidden = true
                }
                let date1 : NSDate = date as NSDate
                let date2 : NSDate = NSDate() //initialized by default with the current date
                
                let compareResult = date1.compare(date2 as Date)
                if compareResult == ComparisonResult.orderedAscending {
                    
                    return
                }
                
                let dateFormatter = DateFormatter()
                dateFormatter.dateStyle = DateFormatter.Style.medium
                
                dateFormatter.timeStyle = DateFormatter.Style.none
                dateFormatter.dateFormat = "dd-MM-yyy"
                let strCheckInDate = dateFormatter.string(from: date)
                
                if arrBlockedDates.count>0
                {
                    isDateSelected = true
                    for i in 0...arrBlockedDates.count-1
                    {
                        let strBlocked = arrBlockedDates[i] as! NSString
                        if strCheckInDate == strBlocked as String {
                            return
                        }
                    }
                }
                
                let rangeDate = date.beginningOfDay
                if shouldResetRange {
                    optionCurrentDateRange.setStartDate(rangeDate)
                    optionCurrentDateRange.setEndDate(rangeDate)
                    isSelectingStartRange = false
                    shouldResetRange = false
                }
                else {
                    if isSelectingStartRange {
                        optionCurrentDateRange.setStartDate(rangeDate)
                        isSelectingStartRange = false
                    }
                    else {
                        optionCurrentDateRange.setEndDate(rangeDate)
                        shouldResetRange = true
                    }
                }
                updateDate()
            }
            calendarTable.reloadData()
        }
    }
    
    internal func WWClockGetTime() -> Date {
        return optionCurrentDate
    }
    
    internal func WWClockSwitchAMPM(isAM: Bool, isPM: Bool) {
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
    
    internal func WWClockSetHourMilitary(_ hour: Int) {
        optionCurrentDate = optionCurrentDate.change(hour: hour)
        updateDate()
        clockView.setNeedsDisplay()
    }
    
    internal func WWClockSetMinute(_ minute: Int) {
        optionCurrentDate = optionCurrentDate.change(minute: minute)
        updateDate()
        clockView.setNeedsDisplay()
    }
}

@objc internal enum WWCalendarRowType: Int {
    case month, day, date
}

internal protocol WWCalendarRowProtocol {
    func WWCalendarRowGetDetails(_ row: Int) -> (type: WWCalendarRowType, startDate: Date)
    func WWCalendarRowDidSelect(_ date: Date)
}

internal class WWCalendarRow: UIView {
    
    internal var delegate: WWCalendarRowProtocol!
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
    internal var multipleSelectionGrouping: WWCalendarTimeSelectorMultipleSelectionGrouping = .pill
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
    var arrBlockedDates : NSMutableArray = NSMutableArray()
    var isDateSelected : Bool = false
    
    internal override func draw(_ rect: CGRect) {
        let detail = delegate.WWCalendarRowGetDetails(tag)
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
        }
        else if detail.type == .day {
            let dayHeight = ceil(dayFont.lineHeight)
            let y = (boxHeight - dayHeight) / 2
            
            for (index, element) in days.enumerated() {
                let str = NSAttributedString(string: element, attributes: [NSFontAttributeName: dayFont, NSForegroundColorAttributeName: dayFontColor, NSParagraphStyleAttributeName: paragraph])
                str.draw(in: CGRect(x: CGFloat(index) * boxWidth, y: y, width: boxWidth, height: dayHeight))
            }
        }
        else {
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
                        fontColor = dateTodayFontColor
                        fontHighlightColor = dateTodayHighlightFontColor
                        backgroundHighlightColor = dateTodayHighlightBackgroundColor.cgColor
                    }
                    else if date.compare(today) == ComparisonResult.orderedAscending {
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
                    /*
                     if Constants().GETVALUE(keyname: "isDateSelected") == "notselected"
                     {
                     if arrBlockedDates.count>0
                     {
                     for i in 0...arrBlockedDates.count-1
                     {
                     let strBlocked = arrBlockedDates[i] as! NSString
                     if strCheckInDate == strBlocked as String
                     {
                     //                                let myImage = UIImage(named: "close_icon_white.png")
                     //                                let myImageView:UIImageView = UIImageView()
                     //                                myImageView.image = myImage
                     //                                myImage
                     //                                myImageView.frame =  CGRect(x: 0, y:0, width: 20 ,height: 20)
                     //                                self.addSubview(myImageView)
                     
                     font = comparisonDates.contains(date) ? datePastFontHighlight : datePastFont
                     fontColor = UIColor.white
                     fontHighlightColor = UIColor.white.withAlphaComponent(0.5)
                     backgroundHighlightColor = UIColor.clear.cgColor
                     }
                     }
                     }
                     }
                     else if Constants().GETVALUE(keyname: "isDateSelected") == "selected"
                     {
                     if date.compare(today) == ComparisonResult.orderedAscending {
                     font = comparisonDates.contains(date) ? datePastFontHighlight : datePastFont
                     fontColor = UIColor.lightGray
                     fontHighlightColor = UIColor.lightGray
                     backgroundHighlightColor = UIColor.clear.cgColor
                     }
                     
                     }
                     */
                    
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
                        }
                        else {
                            let size = min(boxHeight, boxWidth)
                            let x = CGFloat(i - 1) * boxWidth + (boxWidth - size) / 2
                            let y = (boxHeight - size) / 2
                            ctx?.fillEllipse(in: CGRect(x: x, y: y, width: size, height: size))
                        }
                        
                        
                        str =  NSMutableAttributedString(string: "\(date.day)")
                        
                        //                        print("coming")
                        if arrBlockedDates.count>0
                        {
                            for i in 0...arrBlockedDates.count-1
                            {
                                let strBlocked = arrBlockedDates[i] as! NSString
                                if strCheckInDate == strBlocked as String
                                {
                                    str.addAttribute(NSStrikethroughStyleAttributeName, value: 2, range: NSMakeRange(0, str.length))
                                }
                                else{
                                    
                                }
                            }
                        }
                        
                        str.addAttributes([NSFontAttributeName: font!, NSForegroundColorAttributeName: fontHighlightColor!, NSParagraphStyleAttributeName: paragraph], range: NSMakeRange(0, str.length))
                        
                    }
                    else {
                        str =  NSMutableAttributedString(string: "\(date.day)")
                        
                        
                        if arrBlockedDates.count>0
                        {
                            for i in 0...arrBlockedDates.count-1
                            {
                                let strBlocked = arrBlockedDates[i] as! NSString
                                if strCheckInDate == strBlocked as String
                                {
                                    str.addAttribute(NSStrikethroughStyleAttributeName, value: 2, range: NSMakeRange(0, str.length))
                                }
                                else{
                                    
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
        let detail = delegate.WWCalendarRowGetDetails(tag)
        if detail.type == .date {
            let boxWidth = bounds.width / 7
            if let touch = touches.sorted(by: { $0.timestamp < $1.timestamp }).last {
                let boxIndex = Int(floor(touch.location(in: self).x / boxWidth))
                let dateTapped = detail.startDate + boxIndex.days - (detail.startDate.weekday - 1).days
                if dateTapped.month == detail.startDate.month {
                    delegate.WWCalendarRowDidSelect(dateTapped)
                }
            }
        }
    }
    
    fileprivate func flashDate(_ date: Date) -> Bool {
        let detail = delegate.WWCalendarRowGetDetails(tag)
        
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

internal protocol WWClockProtocol {
    func WWClockGetTime() -> Date
    func WWClockSwitchAMPM(isAM: Bool, isPM: Bool)
    func WWClockSetHourMilitary(_ hour: Int)
    func WWClockSetMinute(_ minute: Int)
}

internal class WWClock: UIView {
    
    internal var delegate: WWClockProtocol!
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
    internal var minuteStep: WWCalendarTimeSelectorTimeStep! {
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
        
        let time = delegate.WWClockGetTime()
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
                delegate.WWClockSwitchAMPM(isAM: true, isPM: false)
            }
            else if pmRect.contains(pt) {
                delegate.WWClockSwitchAMPM(isAM: false, isPM: true)
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
            let time = delegate.WWClockGetTime()
            if hour == 12 {
                delegate.WWClockSetHourMilitary(time.hour < 12 ? 0 : 12)
            }
            else {
                delegate.WWClockSetHourMilitary(time.hour < 12 ? hour : 12 + hour)
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
            delegate.WWClockSetMinute(minute)
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
