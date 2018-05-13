const assert = require('assert');
const ganache = require('ganache-cli');
const Web3 = require('web3');

const provider = ganache.provider();
const web3 = new Web3(provider);

const { interface, bytecode } = require('../compile');

let accounts;
let characterFactory;

beforeEach(async () => {
  accounts = await web3.eth.getAccounts();
  characterFactory = await new web3.eth.Contract(JSON.parse(interface))
    .deploy({ data: bytecode })
    .send({ from: accounts[0], gas: '3000000' });
  
    characterFactory.setProvider(provider);
});

describe('Character Factory contract', () => {
  it('deploys a character factory', () => {
    assert.ok(characterFactory.options.address);
  });

  it('seeds three new characters on contract creation', async () => {
    const charactersLength = await characterFactory.methods
      .getCharactersLength()
      .call({ from: accounts[0] });
    assert.equal(charactersLength, 3);
  });

  it('creates new character (contract creator only)', async () => {
    await characterFactory.methods
      .createCharacter("test", "test", "test")
      .call({ from: accounts[0] });
    const charactersLength = await characterFactory.methods
      .getCharactersLength()
      .call({ from: accounts[0] });
    assert.equal(charactersLength, 4);
  });

  it('get a character using its index (id)', async () => {
    const characterIndex = 0;
    const expectedCharacter = {
      name: 'Jeanne D\'arc',
      anime: 'Fate Apocrypha',
      avatarUrl: 'https://vignette.wikia.nocookie.net/fategrandorder/images/5/56/Jeanne1.png',
      value: '5000000000000000',
    };
    const actualCharacter = await characterFactory.methods
      .getCharacter(characterIndex)
      .call({ from: accounts[0] });
    
    assert.equal(expectedCharacter.name, actualCharacter.name);
    assert.equal(expectedCharacter.anime, actualCharacter.anime);
    assert.equal(expectedCharacter.avatarUrl, actualCharacter.avatarUrl);
    assert.equal(expectedCharacter.value, actualCharacter.value);
  });

  it('get a character\'s owner address', async () => {
    const characterIndex = 0;
    const ownerAddress = await characterFactory.methods
      .characterOwnership(characterIndex)
      .call({ from: accounts[0] });

    assert.equal(ownerAddress, accounts[0]);
  });

  it('successfully buy a character', async () => {
    const characterIndex = 0;
    await characterFactory.methods
      .buyCharacter(characterIndex)
      .send({
        from: accounts[1],
        value: web3.utils.toWei('0.08', 'ether'),
      });
    const ownerAddress = await characterFactory.methods
      .characterOwnership(characterIndex)
      .call({ from: accounts[1] });
  
      assert.equal(ownerAddress, accounts[1]);
  });
});