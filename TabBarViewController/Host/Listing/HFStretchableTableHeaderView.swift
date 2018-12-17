/**
 * HFStretchableTableHeaderView.swift
 *
 * @package Makent
 * @subpackage Controller
 * @category Calendar
 * @author Trioangle Product Team
 * @version - Stable 1.0
 * @link http://trioangle.com
 */

import Foundation
import UIKit
class HFStretchableTableHeaderView: NSObject {
    var tableView: UITableView!
    var view: UIView!
    var initialFrame = CGRect.zero
    var defaultViewHeight: CGFloat = 0.0

    func stretchHeader(for tableView: UITableView, with view: UIView) {
        self.tableView = tableView
        self.view = view
        initialFrame = view.frame
        defaultViewHeight = initialFrame.size.height
        let emptyTableHeaderView = UIView(frame: initialFrame)
        tableView.tableHeaderView = emptyTableHeaderView
        tableView.addSubview(view)
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        var f = view.frame
        f.size.width = tableView.frame.size.width
        self.view.frame = f
        if scrollView.contentOffset.y < 0 {
            let offsetY: CGFloat = (scrollView.contentOffset.y + scrollView.contentInset.top) * -1
            initialFrame.origin.y = offsetY * -1
            initialFrame.size.height = defaultViewHeight + offsetY
            self.view.frame = initialFrame
        }
    }

    func resize() {
        initialFrame.size.width = tableView.frame.size.width
        self.view.frame = initialFrame
    }

}
