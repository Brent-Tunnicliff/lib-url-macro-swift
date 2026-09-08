// Copyright © 2026 Brent Tunnicliff <brent@tunnicliff.dev>

enum Module: String, CaseIterable {
    /// Does not hard code any module, increasing the risk of conflicting with other symbols.
    case none

    /// Hard codes the `Foundation` module.
    case foundation

    /// Hard codes the `FoundationEssentials` module.
    case foundationEssentials
}

extension Module {
    package var name: String? {
        switch self {
        case .none: return nil
        case .foundation: return "Foundation"
        case .foundationEssentials: return "FoundationEssentials"
        }
    }
}
