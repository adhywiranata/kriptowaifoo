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
});