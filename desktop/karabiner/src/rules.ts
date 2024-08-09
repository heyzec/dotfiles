// prettier-ignore
import {
// rule and layers
rule, layer, simlayer, hyperLayer, modifierLayer, duoLayer,
// from / map()
map, mapConsumerKey, mapPointingButton, mapSimultaneous, mapDoubleTap, mouseMotionToScroll,
// to
toKey, toConsumerKey, toPointingButton, toHyper, toSuperHyper, toMeh, to$, toApp, toPaste, toTypeSequence, toNone, toNotificationMessage, toRemoveNotificationMessage, toInputSource, toSetVar, toMouseKey, toMouseCursorPosition, toStickyModifier, toCgEventDoubleClick, toSleepSystem,
// conditions
ifApp, ifDevice, ifVar, ifDeviceExists, ifInputSource, ifKeyboardType, ifEventChanged,
// utils
withCondition, withMapper, withModifier
} from 'karabiner.ts'

let hyper: any = ['option', 'control', 'shift', 'command']

export const rules = () => [
  rule('Better Caps Lock').manipulators([
    map('caps_lock').toHyper().toIfAlone('escape'),

    // Restore capslock
    withModifier(['left_shift'])({
      right_shift: toKey('caps_lock'),
    }),
    withModifier(['right_shift'])({
      left_shift: toKey('caps_lock'),
    })
  ]),

  rule('Arrows').manipulators([
    withModifier(hyper)({
      h: toKey('left_arrow'),
      j: toKey('down_arrow'),
      k: toKey('up_arrow'),
      l: toKey('right_arrow'),
    }),
  ]),

  // Requires enabling these shortcuts in MacOS settings
  rule('Workspaces - Absolute').manipulators([
    withModifier('command')({
      1: toKey('1', 'control'),
      2: toKey('2', 'control'),
      3: toKey('3', 'control'),
      4: toKey('4', 'control'),
      5: toKey('5', 'control'),
      6: toKey('6', 'control'),
    }),
  ]),

  rule('Workspaces - Relative').manipulators([
    withModifier(hyper)({
      d: toKey('left_arrow', 'control'),
      f: toKey('right_arrow', 'control'),
    }),
  ]),

  // rule('Terminal').manipulators([
  //   withModifier('command')({
  //       return_or_enter: to$('~/dotfiles/scripts/new-hyper-window.sh'),
  //   })
  // ]),
]

