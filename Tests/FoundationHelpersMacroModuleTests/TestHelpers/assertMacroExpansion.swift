// Copyright © 2026 Brent Tunnicliff <brent@tunnicliff.dev>

import SwiftSyntaxMacroExpansion
import SwiftSyntaxMacrosGenericTestSupport
import Testing

func assertMacroExpansion(
    _ originalSource: String,
    expandedSource expectedExpandedSource: String,
    diagnostics: [DiagnosticSpec] = [],
    macroSpecs: [String: MacroSpec],
    fileID: StaticString = #fileID,
    filePath: StaticString = #filePath,
    line: UInt = #line,
    column: UInt = #column
) {
    SwiftSyntaxMacrosGenericTestSupport.assertMacroExpansion(
        originalSource,
        expandedSource: expectedExpandedSource,
        diagnostics: diagnostics,
        macroSpecs: macroSpecs,
        failureHandler: Issue.record(failure:),
        fileID: fileID,
        filePath: filePath,
        line: line,
        column: column
    )
}

extension DiagnosticSpec {
    /// Simple wrapper of `DiagnosticSpec` to reduce needing to import `SwiftSyntaxMacrosGenericTestSupport`
    /// in other files.
    static func expected(
        message: String,
        line: Int = 1,
        column: Int = 1,
        originatorFileID: StaticString = #fileID,
        originatorFile: StaticString = #filePath,
        originatorLine: UInt = #line,
        originatorColumn: UInt = #column
    ) -> DiagnosticSpec {
        DiagnosticSpec(
            message: message,
            line: line,
            column: column,
            originatorFileID: originatorFileID,
            originatorFile: originatorFile,
            originatorLine: originatorLine,
            originatorColumn: originatorColumn
        )
    }
}
