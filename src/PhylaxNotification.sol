// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
pragma experimental ABIEncoderV2;

import {PhylaxBase} from "./PhylaxBase.sol";

/// @title PhylaxNotification
/// @dev Base contract for all Phylax notification contracts.
abstract contract PhylaxNotification is PhylaxBase {
    enum NotificationSeverity {
        Info,
        Warning,
        Critical
    }

    struct NotificationMessage {
        string summary;
        string description;
        NotificationSeverity severity;
        Label[] labels;
    }

    // helper functions
    function info(string memory summary, string memory description) internal pure returns (NotificationMessage memory) {
        Label[] memory labels;
        return NotificationMessage({
            summary: summary,
            description: description,
            severity: NotificationSeverity.Info,
            labels: labels
        });
    }

    function info(string memory summary, string memory description, Label[] memory labels)
        internal
        pure
        returns (NotificationMessage memory)
    {
        return NotificationMessage({
            summary: summary,
            description: description,
            severity: NotificationSeverity.Info,
            labels: labels
        });
    }

    function warning(string memory summary, string memory description)
        internal
        pure
        returns (NotificationMessage memory)
    {
        Label[] memory labels;
        return NotificationMessage({
            summary: summary,
            description: description,
            severity: NotificationSeverity.Warning,
            labels: labels
        });
    }

    function warning(string memory summary, string memory description, Label[] memory labels)
        internal
        pure
        returns (NotificationMessage memory)
    {
        return NotificationMessage({
            summary: summary,
            description: description,
            severity: NotificationSeverity.Warning,
            labels: labels
        });
    }

    function critical(string memory summary, string memory description)
        internal
        pure
        returns (NotificationMessage memory)
    {
        Label[] memory labels;
        return NotificationMessage({
            summary: summary,
            description: description,
            severity: NotificationSeverity.Critical,
            labels: labels
        });
    }

    function critical(string memory summary, string memory description, Label[] memory labels)
        internal
        pure
        returns (NotificationMessage memory)
    {
        return NotificationMessage({
            summary: summary,
            description: description,
            severity: NotificationSeverity.Critical,
            labels: labels
        });
    }
}
