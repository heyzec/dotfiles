import {
  layer,
  map,
  NumberKeyValue,
  rule,
  withMapper,
  writeToProfile,
} from 'karabiner.ts'

import { rules } from './rules'

// ! Change '--dry-run' to your Karabiner-Elements Profile name.
// (--dry-run print the config json into console)
// + Create a new profile if needed.
writeToProfile('Default profile', rules())
