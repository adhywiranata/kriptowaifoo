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
    uint[] public charactersIds;
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
        createCharacter("Jeanne D'arc", "Fate Apocrypha", "https://lh5.googleusercontent.com/3O1qjNAaIxAZrrbBWeU-_YlB9X5FFsQeswOh_PMJhB7Hs11hkO-liUUy5wlZDKx7dl5T7rNp1OPlPKzXmjQ=w1441-h759");
        createCharacter("Rem", "Re:Zero", "https://lh5.googleusercontent.com/6b-Yzl8tXjmwka8xl4UbjD0LzXHIsZk50I_vwkFcBNjWlCwauPZnLlAIrM4VH9Rvzn8ON2rl8pRjseqA2m4=w1441-h759");
        createCharacter("Megumin", "Konosuba", "https://lh6.googleusercontent.com/7MzbkFVGushKP7XrnGESCrrSe68OYOxGe8APhqtq5L_BL4Mv_4s3kqp6GNQIACi75dt6YfcqxPnBRICkX4k=w1441-h759");
        createCharacter("Artoria Pendragon", "Fate/Stay Night", "https://lh4.googleusercontent.com/dPl4EWoaTMvaZzO6IvrXbGNIYpuvJGqJmP1FZ7vi_stKsmnL8o49f8vDmVzPCIIDSDa-qQu-n-yrvAqkGIc=w1441-h759");
        createCharacter("Violet Evergarden", "Violet Evergarden", "https://lh3.googleusercontent.com/gEJFA8ajZZV3SLJxatQCR_E6bSF8z7rKG9cPvS9DdkM59PJI1yon-Bqv2ibra91AXiePtu6LsYeMQ7DhEKo=w1441-h759");
        createCharacter("Kotori Minami", "Love Live!", "https://lh3.googleusercontent.com/A04sZ7Sjlm38rkPKPkEtHZxsCqfeh8RTgC4fgeBDcFO124AduJ2CdG_IidqM1xaR2aYP_j_QP30u95eN_-A=w1441-h759");
        createCharacter("Sagiri", "Eromanga Sensei", "https://lh6.googleusercontent.com/yI4csDORefxNwvjWENTnPzNLU-6fHbUkMzlsMk188kRb5MD9kirRrHJDJfBrsLQeM2ZH2AFROhffcqiPBXs=w1441-h759");
        createCharacter("Azusa Nakano", "K-On", "https://lh4.googleusercontent.com/GR1bmN8gXkQchuT4lG9rxktXmKQSKFNVkg2hXnk0T05a8QGAYYIPotx0VNV4GNy9IMJ5p-FjsTcUQasMIyg=w1441-h759");
    }

    function createCharacter(string name, string anime, string avatarUrl) public onlyCreator {
        uint characterId = characters.push(Character(name, anime, avatarUrl, minimumCharValue)) - 1;
        charactersIds.push(characterId);
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

    function getCharactersLength() public view returns (uint) {
        return characters.length;
    }

    function getCharactersIds() public view returns (uint[]) {
        return charactersIds;
    }
}