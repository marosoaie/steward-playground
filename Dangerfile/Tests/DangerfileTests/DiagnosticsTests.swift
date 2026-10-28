@testable import Dangerfile
import StewardTesting
import Testing

@Suite("Diagnostics on changed lines")
struct DiagnosticsTests {
    /// A report with no issues, as the workflow converts a clean ruff run.
    static let emptyReport = #"{"issues": []}"#

    /// A report, as the workflow converts ruff's, with an issue on the line
    /// `SampleDiff.sources` adds, a critical one there too, and one on a line
    /// it leaves alone.
    static let report = #"""
        {"issues": [
          {"component": "playground:src/app.py", "line": 2, "message": "`os` imported but unused",
           "rule": "ruff:F401", "severity": "MAJOR"},
          {"component": "playground:src/app.py", "line": 2, "message": "Undefined name `name`",
           "rule": "ruff:F821", "severity": "CRITICAL"},
          {"component": "playground:src/app.py", "line": 3, "message": "never reported",
           "rule": "ruff:F841", "severity": "MAJOR"}
        ]}
        """#

    @Test("a major issue on a changed line warns, and a critical one fails")
    func issues() async throws {
        let workspace = try ReportWorkspace(logs: ["ruff-sonar.json": Self.report])
        defer { workspace.remove() }
        let context = try Context.fixture(diff: SampleDiff.sources, workspace: workspace.path)
        let findings = try await Checks.diagnostics.evaluate(context)
        let location = Location(path: "src/app.py", line: 2)
        #expect(Set(findings.map(\.kind)) == [.failure, .warning])
        #expect(findings.map(\.location) == [location, location])
    }

    @Test("a clean report gives no findings")
    func clean() async throws {
        let workspace = try ReportWorkspace(logs: ["ruff-sonar.json": Self.emptyReport])
        defer { workspace.remove() }
        let context = try Context.fixture(diff: SampleDiff.sources, workspace: workspace.path)
        #expect(try await Checks.diagnostics.evaluate(context).isEmpty)
    }
}
