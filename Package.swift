import PackageDescription

let package = Package(
    name: "Derployer"
)

package.dependencies = [
    .Package(url: "https://github.com/masonmark/Mason.swift", majorVersion: 9),
]

package.exclude = [
    "Whatever"
]
