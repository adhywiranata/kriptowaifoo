pragma solidity ^0.4.17;

contract CharacterFactory {

    address creator; // contracts creator/owner address
    uint minimumCharValue = 0.005 ether;

    struct Character {
        string name;
        string anime;
        string avatarUrl;
        uint value;
    }

    Character[] public characters;
    mapping (uint => address) characterToOwner; // 1 character can only be owned by 1 user

    constructor() public {
        creator = msg.sender;
        seedCharacters();
    }

    modifier onlyCreator() {
        require(msg.sender == creator);
        _;
    }

    function seedCharacters() private {
        createCharacter("Jeanne D'arc", "Fate Apocrypha", "https://vignette.wikia.nocookie.net/fategrandorder/images/5/56/Jeanne1.png");
        createCharacter("Rem", "Re:Zero", "https://coubsecure-s.akamaihd.net/get/b9/p/coub/simple/cw_timeline_pic/ff85dc2cb2c/0775f4b5d6c283d2064ad/med_1470218917_image.jpg");
        createCharacter("Megumin", "Konosuba", "https://www.nautiljon.com/images/perso/00/30/megumin_13903.jpg?1501512323");
    }

    function createCharacter(string name, string anime, string avatarUrl) public onlyCreator {
        uint characterId = characters.push(Character(name, anime, avatarUrl, minimumCharValue)) - 1;
        characterToOwner[characterId] = msg.sender;
    }

    function buyCharacter(uint characterId) public payable {
        require(msg.value > characters[characterId].value);
        
        // change character ownership and update value
        characterToOwner[characterId] = msg.sender;
        characters[characterId].value = msg.value;
    }

    function characterOwnership(uint characterId) public view returns (address) {
        return characterToOwner[characterId];
    }

    function getCharacter(uint characterId) public view returns (uint id, string name, string anime, string avatarUrl, uint value) {
        Character memory targetCharacter = characters[characterId];
        return (characterId, targetCharacter.name, targetCharacter.anime, targetCharacter.avatarUrl, targetCharacter.value);
    }
}