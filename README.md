# D2A — Dota 2 Armory

D2A is a SwiftUI app for exploring Dota 2 players, matches, heroes, abilities, and game statistics on iPhone and iPad.

## Features

- Follow players and review their recent match history
- Search for players and matches by ID
- Inspect match details, player performance, item builds, and analysis
- Browse hero attributes, roles, lore, abilities, and talents
- Keep selected data available locally with Core Data
- See recent match information in Home Screen widgets
- Use the app in English or Simplified Chinese

## Requirements

- iOS or iPadOS 16.0 or later
- A current Xcode release capable of building the project

## Getting Started

1. Clone the repository.
2. Open `D2A.xcodeproj` in Xcode.
3. Allow Xcode to resolve the Swift Package Manager dependencies.
4. Add a valid STRATZ API token to the `stratzToken` field in `Resources/graphql/secrets.json` if you need STRATZ-backed data.
5. Select the `D2A` scheme and an iOS simulator or connected device.
6. Build and run the app.

Network-backed screens require an internet connection. OpenDota-backed features use its public REST API; STRATZ-backed features authenticate with the token configured above. Do not commit personal API tokens.

## Project Structure

- `D2A/` — main SwiftUI application
- `D2AWidget/` — Home Screen widget extension
- `D2AWidgetIntentHandler/` — widget intent extension
- `StratzAPI/` — generated GraphQL schema and operations used by the STRATZ integration
- `Resources/Localizations/` — String Catalogs for app and game-data localization
- `Unit Tests/`, `Remote Data Tests/`, and UI test targets — automated test suites

## Technology

- Swift and SwiftUI
- Core Data for local persistence
- WidgetKit for Home Screen widgets
- StoreKit for in-app purchases
- Apollo GraphQL for STRATZ data
- REST APIs for OpenDota data
- Swift Package Manager for dependencies

## Data Sources and Credits

- API data is provided by [OpenDota](https://www.opendota.com) and [STRATZ](https://stratz.com/dashboard).
- Dota 2 content and imagery belong to [Valve](https://www.dota2.com).

D2A is an independent project and is not affiliated with or endorsed by Valve, OpenDota, or STRATZ.

## Contributing

Contributions are welcome. Open an issue to discuss a bug or proposed change, or submit a pull request with the relevant tests and documentation updates.
