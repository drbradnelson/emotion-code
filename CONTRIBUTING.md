_This document is a work in progress._

# Management

## Issues

* Each issue represents a single problem
* Each issue has a milestone attached
* Each issue title starts with a verb
* Each issue title starts with an uppercase and doesn't end with a period

## Milestones

* Each milestone needs to match one of the following patterns:
 * semantic version number (`1.0`, `1.0.5`)
 * semantic version number with a wildcard (`2.x`, `2.1.x`)
 * `undecided`
 * `invalid`

# Workflow

## Development

1. Branch off `feature/describe-your-feature` from `develop`
2. Make and commit changes
3. Create a pull request against `develop`
4. Go through code review, rebase and force-push if needed
5. See your pull request merged and feature branch deleted

## Deployment

1. Branch off `release/X.Y.Z` from `develop`
2. Test the release
3. Update version information
4. Merge the release branch to `master` and `develop`
5. Tag the merge commit as `vX.Y.Z`
6. Delete the release branch
7. Deploy from `master` branch

To read more about the `X.Y.Z` placeholder, check out [Semantic Versioning](http://semver.org).

# Versioning

## Commits

* Each commit represents a single change
* Each commit keeps the project fully functional
* Each commit message starts with a verb
* Each commit message starts with an uppercase and doesn't end with a period
* Each commit message starts with a line that is less than 80 characters long
* Each commit message that closes an issue ends with `(close #XYZ)`

**Examples:**

* _Design login workflow (close #1)_
* _Fix typo in about dialog_
* _Document data model accessors (close #3, close #4)_

## Pull requests

* Each pull request represents a single problem
* Each pull request has a milestone attached
* Each pull request title starts with a verb
* Each pull request title starts with an uppercase and doesn't end with a period
* Each pull request contains as few commits as needed
* Each pull request is rebased on latest `develop`
* Each pull request is free from fixup or revert commits

## Branches

* Default configuration:
  * `develop` - default and protected
  * `master` - protected
* Always use _true merge_ instead of _fast-forward merge_

## Other

* Third-party content is not allowed in the repository
