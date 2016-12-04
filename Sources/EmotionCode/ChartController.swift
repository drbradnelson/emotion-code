import Foundation

final class ChartController {

    // MARK: Chart

    let chart = ChartController.chartAt(URL: ChartController.chartURL)

    // MARK: Chart parser

    private static func chartAt(URL: URL) -> Chart {
        guard let chartArray = NSArray(contentsOf: URL) else {
            preconditionFailure("Unable to load chart file")
        }
        return makeChart(with: chartArray)
    }

    private static func makeChart(with array: NSArray) -> Chart {
        guard let columnArrays = array as? [NSArray] else {
            preconditionFailure("Unable to find chart columns")
        }
        let columns = columnArrays.map(makeChartColumn)
        return Chart(columns: columns)
    }

    private static func makeChartColumn(with array: NSArray) -> Chart.Column {
        guard let sectionArrays = array as? [NSArray] else {
            preconditionFailure("Unable to find chart sections")
        }
        let sections = sectionArrays.map(makeChartSection)
        return Chart.Column(sections: sections)
    }

    private static func makeChartSection(with array: NSArray) -> Chart.Section {
        guard let emotionDictionaries = array as? [NSDictionary] else {
            preconditionFailure("Unable to find chart emotions")
        }
        let emotions = emotionDictionaries.map(makeChartEmotion)
        return Chart.Section(emotions: emotions)
    }

    private static func makeChartEmotion(with dictionary: NSDictionary) -> Chart.Emotion {
        guard let title = dictionary[emotionTitleKey] as? String, let description = dictionary[emotionDescriptionKey] as? String else {
            preconditionFailure("Unable to parse chart emotion")
        }
        return Chart.Emotion(title: title, description: description)
    }

    private static let emotionTitleKey = "Title"
    private static let emotionDescriptionKey = "Description"

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
