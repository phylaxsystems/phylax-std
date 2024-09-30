// SPDX-License-Identifier: MIT
pragma solidity >=0.6.2 <0.9.0;
pragma experimental ABIEncoderV2;

/// @title PhylaxNotification
/// @dev Base contract for all Phylax notification contracts.
abstract contract PhylaxNotification {
    enum NotificationSeverity {
        Info,
        Warning,
        Critical
    }

    struct NotificationLabel {
        string key;
        string value;
    }

    struct NotificationMessage {
        string summary;
        string description;
        NotificationSeverity severity;
        NotificationLabel[] labels;
    }

    // helper functions
    function info(string memory summary, string memory description) public pure returns (NotificationMessage memory) {
        NotificationLabel[] memory labels;
        return NotificationMessage({
            summary: summary,
            description: description,
            severity: NotificationSeverity.Info,
            labels: labels
        });
    }

    function info(string memory summary, string memory description, NotificationLabel[] memory labels)
        public
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
        public
        pure
        returns (NotificationMessage memory)
    {
        NotificationLabel[] memory labels;
        return NotificationMessage({
            summary: summary,
            description: description,
            severity: NotificationSeverity.Warning,
            labels: labels
        });
    }

    function warning(string memory summary, string memory description, NotificationLabel[] memory labels)
        public
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
        public
        pure
        returns (NotificationMessage memory)
    {
        NotificationLabel[] memory labels;
        return NotificationMessage({
            summary: summary,
            description: description,
            severity: NotificationSeverity.Critical,
            labels: labels
        });
    }

    function critical(string memory summary, string memory description, NotificationLabel[] memory labels)
        public
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
