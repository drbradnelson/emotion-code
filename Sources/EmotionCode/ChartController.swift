import Foundation

// MARK: Main

final class ChartController {

    let chart = ChartController.chartAtURL(ChartController.chartURL)

}

// MARK: Parser

private extension ChartController {

    static func chartAtURL(URL: NSURL) -> Chart {
        guard let chartArray = NSArray(contentsOfURL: URL) else {
            preconditionFailure("Unable to load chart file")
        }
        return chartWithArray(chartArray)
    }

    static func chartWithArray(array: NSArray) -> Chart {
        guard let columnArrays = array as? [NSArray] else {
            preconditionFailure("Unable to find chart columns")
        }
        let columns = columnArrays.map(chartColumnWithArray)
        return Chart(columns: columns)
    }

    static func chartColumnWithArray(array: NSArray) -> ChartColumn {
        guard let rowArrays = array as? [NSArray] else {
            preconditionFailure("Unable to find chart rows")
        }
        let rows = rowArrays.map(chartRowWithArray)
        return ChartColumn(rows: rows)
    }

    static func chartRowWithArray(array: NSArray) -> ChartRow {
        guard let itemDictionaries = array as? [NSDictionary] else {
            preconditionFailure("Unable to find chart items")
        }
        let items = itemDictionaries.map(chartItemWithDictionary)
        return ChartRow(items: items)
    }

    static func chartItemWithDictionary(dictionary: NSDictionary) -> ChartItem {
        guard let title = dictionary["Title"] as? String, description = dictionary["Description"] as? String else {
            preconditionFailure("Unable to parse chart item")
        }
        return ChartItem(title: title, description: description)
    }

}

// MARK: Chart URL

private extension ChartController {

    static var chartURL: NSURL {
        let bundle = NSBundle.mainBundle()
        guard let chartURL = bundle.URLForResource(chartResource, withExtension: chartResourceExtension) else {
            preconditionFailure("Unable to locate chart file")
        }
        return chartURL
    }

}

private extension ChartController {

    static let chartResource = "EmotionCodeChart"
    static let chartResourceExtension = "plist"

}
