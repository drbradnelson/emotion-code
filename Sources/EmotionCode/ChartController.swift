import Foundation

final class ChartController {

    // MARK: Chart

    let chart = ChartController.chartAt(URL: ChartController.chartURL)

    // MARK: Chart parser

    private static func chartAt(URL: URL) -> Chart {
        guard let chartArray = NSArray(contentsOf: URL) else {
            preconditionFailure("Unable to load chart file")
        }
        return chartWith(array: chartArray)
    }

    private static func chartWith(array: NSArray) -> Chart {
        guard let columnArrays = array as? [NSArray] else {
            preconditionFailure("Unable to find chart columns")
        }
        let columns = columnArrays.map(chartColumnWith)
        return Chart(columns: columns)
    }

    private static func chartColumnWith(array: NSArray) -> ChartColumn {
        guard let rowArrays = array as? [NSArray] else {
            preconditionFailure("Unable to find chart rows")
        }
        let rows = rowArrays.map(chartRowWith)
        return ChartColumn(rows: rows)
    }

    private static func chartRowWith(array: NSArray) -> ChartRow {
        guard let itemDictionaries = array as? [NSDictionary] else {
            preconditionFailure("Unable to find chart items")
        }
        let items = itemDictionaries.map(chartItemWith)
        return ChartRow(items: items)
    }

    private static func chartItemWith(dictionary: NSDictionary) -> ChartItem {
        guard let title = dictionary[itemTitleKey] as? String, let description = dictionary[itemDescriptionKey] as? String else {
            preconditionFailure("Unable to parse chart item")
        }
        return ChartItem(title: title, description: description)
    }

    private static let itemTitleKey = "Title"
    private static let itemDescriptionKey = "Description"

    // MARK: Chart URL

    private static var chartURL: URL {
        let bundle = Bundle.main
        guard let chartURL = bundle.url(forResource: chartResource, withExtension: chartResourceExtension) else {
            preconditionFailure("Unable to locate chart file")
        }
        return chartURL
    }

    private static let chartResource = "EmotionCodeChart"
    private static let chartResourceExtension = "plist"

}
