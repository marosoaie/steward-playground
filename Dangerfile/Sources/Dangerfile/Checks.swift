import Foundation
import Steward

/// The rules Steward checks this repository's pull requests with, in the
/// order they run and their findings show.
///
/// In a GitHub Actions `pull_request` workflow, `swift run --package-path
/// Dangerfile` posts the summary as a comment on the pull request; anywhere
/// else it's a dry run that prints the summary. Each rule is a static
/// property, so a test can call it on its own (see Tests/DangerfileTests).
@main
struct Checks: Dangerfile {
    static var rules: [Rule] {
        description
        changelog
        conflictMarkers
        diagnostics
    }

    /// A pull request that's ready for review says what it changes and why.
    /// Drafts are exempt; the workflow runs on `ready_for_review`, and on
    /// `edited`, so writing the description clears the failure.
    static let description = Rule("Description") { context in
        let pullRequest = context.pullRequest
        guard !pullRequest.isDraft, pullRequest.body.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        else { return [] }
        return [.failure("Describe what this pull request changes and why.")]
    }

    /// A change to the sources, moving a file out of them included, comes
    /// with a changelog entry. Deleting the changelog isn't one.
    static let changelog = Rule("Changelog") { context in
        let git = context.git
        let changed = git.createdFiles + git.modifiedFiles
        let touched = changed + git.deletedFiles + git.renamedFiles.map(\.from)
        guard touched.contains(where: { $0.hasPrefix("src/") }), !changed.contains("CHANGELOG.md")
        else { return [] }
        return [.warning("Add an entry to CHANGELOG.md for the changes under `src/`.")]
    }

    /// No added line, in any file, is a merge conflict's marker as git
    /// writes them: seven `<` or `>` and a label.
    static let conflictMarkers = Rule("Conflict markers") { context in
        context.git.diff.files.flatMap { file in
            file.lines.compactMap { line -> Finding? in
                guard line.info.kind == .addition,
                      line.content.starts(with: "<<<<<<< ".utf8) || line.content.starts(with: ">>>>>>> ".utf8),
                      let path = file.header.newPath?.string, let number = line.info.newNumber
                else { return nil }
                return .failure("Resolve this merge conflict.", at: Location(path: path, line: number))
            }
        }
    }

    /// ruff's findings on the lines the pull request changes, from the report
    /// the workflow converts to SonarQube's format before it runs Steward.
    /// Critical issues (syntax errors, undefined names) fail; the rest warn.
    static let diagnostics = Rule.diagnosticsOnChangedLines(in: [.sonar("ruff-sonar.json")])
}
