# Fixed Assets feature

## Purpose

- Provides branch users with fixed-assets workflows: search, view results, and submit asset status modifications.

## Architecture

- **Presentation**: screens and widgets under `lib/features/fixed_assets/presentation/`
- **State management**: uses `PagingCubit` for simple page/tab switching (e.g. `IndexedStack` screens).
- **Shared UI**: relies on `lib/core/` widgets, styles, routing, and responsive extensions.

## New UI added

- `FixedAssetsModificationDetailsScreen`: a two-tab (Details / Timelines) screen implemented with `IndexedStack` + `PagingCubit` to match the Figma “Modification Details” design.
- `FixedAssetsReceiveAssetsScreen`: a responsive list-based receive-assets screen with reusable card/list widgets and `SafeCubit`-driven view states (initial/empty/populated).
