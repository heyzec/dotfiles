import {
  layer,
  map,
  NumberKeyValue,
  rule,
  withMapper,
  writeToProfile,
} from 'karabiner.ts'

import { rules } from './rules'

const parameters = {
 'basic.to_if_alone_timeout_milliseconds': 300
};

const mode = process.argv[2];
if (mode == "output") {
  writeToProfile('--dry-run', rules(), parameters);
} else if (mode == "update") {
  writeToProfile('Default profile', rules(), parameters);
}
