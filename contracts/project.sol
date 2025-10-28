// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract CampusConnect {
    // Define user structure
    enum UserType { Student, Faculty }
    struct User {
        address userAddress;
        string name;
        UserType userType;
        uint256 registrationTimestamp;
    }

    // Define announcement structure
    struct Announcement {
        address sender;
        string content;
        uint256 timestamp;
    }

    // Mapping of address to User details
    mapping(address => User) public users;
    // List of announcements
    Announcement[] public announcements;

    // Events
    event UserRegistered(address indexed user, string name, UserType userType);
    event AnnouncementPosted(address indexed sender, string content, uint256 timestamp);

    // Modifier to check if the user is registered
    modifier onlyRegistered() {
        require(bytes(users[msg.sender].name).length > 0, "User is not registered");
        _;
    }

    // Register a new user (Student or Faculty)
    function registerUser(string memory _name, UserType _userType) public {
        require(bytes(_name).length > 0, "Name is required");

        // Ensure the user is not already registered
        require(bytes(users[msg.sender].name).length == 0, "User already registered");

        // Create and store user
        users[msg.sender] = User({
            userAddress: msg.sender,
            name: _name,
            userType: _userType,
            registrationTimestamp: block.timestamp
        });

        emit UserRegistered(msg.sender, _name, _userType);
    }

    // Post an announcement (only registered users can post)
    function postAnnouncement(string memory _content) public onlyRegistered {
        require(bytes(_content).length > 0, "Announcement content cannot be empty");

        // Create a new announcement
        announcements.push(Announcement({
            sender: msg.sender,
            content: _content,
            timestamp: block.timestamp
        }));

        emit AnnouncementPosted(msg.sender, _content, block.timestamp);
    }

    // Get the number of announcements posted
    function getAnnouncementCount() public view returns (uint256) {
        return announcements.length;
    }

    // Fetch a specific announcement
    function getAnnouncement(uint256 index) public view returns (address, string memory, uint256) {
        require(index < announcements.length, "Invalid announcement index");
        Announcement memory ann = announcements[index];
        return (ann.sender, ann.content, ann.timestamp);
    }
}
