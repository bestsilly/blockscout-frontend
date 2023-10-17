const dotenv = require('dotenv');
const fs = require('fs');
const path = require('path');

dotenv.parse(
  fs.readFileSync(path.resolve(__dirname, '.env.local')),
);

// for (let k in envConfig) {
//   console.log(`export ${k}='${envConfig[k]}'`);
// }
