# steward-playground

Throwaway repo for trying [Steward](https://github.com/marosoaie/swift-steward)
on a non-Swift project, for swift-steward's step 5.0 validation.

- `src/wordstats/`: a small Python package, linted with
  [ruff](https://docs.astral.sh/ruff/).
- `.github/actions/ruff-sonar/`: runs ruff and converts its JSON with `jq`
  to SonarQube's issues report (`GET /api/issues/search`), which Steward's
  `.sonar` source reads.
- `Dangerfile/`: the quickstart's template package, with its three example
  rules (the changelog one watching `src/`) and the diagnostics rule over
  that report.
- `.github/workflows/steward.yml`: runs it on pull requests, on the runner
  the head branch's prefix names (the workflow lists them), with the
  default read-only token for `readonly/…` branches.
- `.github/workflows/install.yml`: installs the `steward` CLI on fresh
  runners from the Homebrew tap, from a release's binary, and from source on
  Linux.
