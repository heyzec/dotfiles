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
// 300 similar to keyd overload_tap_timeout
writeToProfile('Default profile', rules(), { 'basic.to_if_alone_timeout_milliseconds': 300 })
