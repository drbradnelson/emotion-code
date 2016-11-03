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
        guard let rowArrays = array as? [NSArray] else {
            preconditionFailure("Unable to find chart rows")
        }
        let rows = rowArrays.map(chartRowWith)
        return Chart(rows: rows)
    }

    private static func chartRowWith(array: NSArray) -> Chart.Row {
        guard let sectionArrays = array as? [NSArray] else {
            preconditionFailure("Unable to find chart sections")
        }
        let sections = sectionArrays.map(chartSectionWith)
        return Chart.Row(sections: sections)
    }

    private static func chartSectionWith(array: NSArray) -> Chart.Section {
        guard let itemDictionaries = array as? [NSDictionary] else {
            preconditionFailure("Unable to find chart items")
        }
        let items = itemDictionaries.map(chartItemWith)
        return Chart.Section(items: items)
    }

    private static func chartItemWith(dictionary: NSDictionary) -> Chart.Item {
        guard let title = dictionary[itemTitleKey] as? String, let description = dictionary[itemDescriptionKey] as? String else {
            preconditionFailure("Unable to parse chart item")
        }
        return Chart.Item(title: title, description: description)
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
