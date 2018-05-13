const path = require('path');
const fs = require('fs');
const solc = require('solc');

const contractPath = path.resolve(__dirname, 'contracts', 'CharacterFactory.sol');
const source = fs.readFileSync(contractPath, 'utf8');
const compiled = solc.compile(source, 1);
module.exports = compiled.contracts[':CharacterFactory'];