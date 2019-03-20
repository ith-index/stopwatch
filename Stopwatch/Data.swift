import Foundation

struct Lap: Codable {
    var number: Int
    var time: Int64
}

class Stopwatch: Codable {
    var isStarted: Bool
    var startTime: Int64
    var previouslyElapsedMilliseconds: Int64
    var laps: [Lap]
    
    init(isStarted: Bool = false, startTime: Int64 = currentTimeInMilliseconds, elapsedMilliseconds: Int64 = 0, laps: [Lap] = []) {
        self.isStarted = isStarted
        self.startTime = currentTimeInMilliseconds
        self.previouslyElapsedMilliseconds = elapsedMilliseconds
        self.laps = laps
    }
    
    func getTimeText() -> String {
        return formatTotalMilliseconds(getTotalElapsedMilliseconds())
    }
    
    func start() {
        startTime = currentTimeInMilliseconds
        isStarted = true
    }
    
    func stop() {
        previouslyElapsedMilliseconds = getTotalElapsedMilliseconds()
        isStarted = false
    }
    
    func reset() {
        previouslyElapsedMilliseconds = 0
        laps.removeAll()
    }
    
    func lap() {
        laps.insert(
            Lap(number: (laps.count + 1), time: getTotalElapsedMilliseconds()),
            at: 0
        )
    }
    
    private func getCurrentlyElapsedMilliseconds() -> Int64 {
        if isStarted {
            return elapsedMillisecondsSinceNow(from: startTime)
        } else {
            return 0
        }
    }

    private func getTotalElapsedMilliseconds() -> Int64 {
        return previouslyElapsedMilliseconds + getCurrentlyElapsedMilliseconds()
    }
}

private var currentTimeInMilliseconds: Int64 {
    return Int64(
        (Date().timeIntervalSince1970 * 1000.0).rounded()
    )
}

private func elapsedMillisecondsSinceNow(from timeInMilliseconds: Int64) -> Int64 {
    return currentTimeInMilliseconds - timeInMilliseconds
}

func formatTotalMilliseconds(_ totalMilliseconds: Int64) -> String {
    let decisecondsPart = totalMilliseconds / 10 % 100
    let secondsPart = totalMilliseconds / 1000 % 60
    let minutesPart = totalMilliseconds / 1000 / 60 % 60
    let hoursPart = totalMilliseconds / 1000 / 60 / 60
    return String(format: "%02d:%02d:%02d.%02d", hoursPart, minutesPart, secondsPart, decisecondsPart)
}

private let filePath: URL = {
    let url: URL? = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
    return url!.appendingPathComponent("StopwatchData")
}()

func saveStopwatch(_ stopwatch: Stopwatch)  {
    do {
        let data = try PropertyListEncoder().encode(stopwatch)
        try data.write(to: filePath)
        print(stopwatch.getTimeText())
        print("FINISHED SAVING")
    } catch {
        preconditionFailure("Error: \(error)")
    }
}

func loadStopwatch() -> Stopwatch? {
    do {
        let fileData = try Data(contentsOf: filePath)
        let stopwatch = try PropertyListDecoder().decode(Stopwatch.self, from: fileData)
        print("LOADED SOMETHING")
        print(stopwatch.getTimeText())
        return stopwatch
    } catch {
        print("LOADED NOTHING")
        return nil
    }
}
