pragma solidity ^0.4.0;

contract CharacterFactory {

    address creator; // contracts creator/owner address
    uint minimumCharValue = 0.005 ether;

    struct Character {
        string name;
        string anime;
        string avatarUrl;
        uint currentValue;
    }

    Character[] public characters;
    mapping (uint => address) characterToOwner; // 1 character can only be owned by 1 user

    constructor() public {
        creator = msg.sender;
    }

    modifier onlyCreator() {
        require(msg.sender == creator);
        _;
    }

    function createCharacter(string name, string anime, string avatarUrl) public onlyCreator {
        uint characterId = characters.push(Character(name, anime, avatarUrl, minimumCharValue)) - 1;
        characterToOwner[characterId] = msg.sender;
    }
}