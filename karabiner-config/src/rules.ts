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


export const rules = () => [
  rule('Better Caps Lock').manipulators([
    map('caps_lock').toHyper().toIfAlone('escape'),
    withModifier(['option', 'control', 'shift', 'command'])({
      h: toKey('left_arrow'),
      j: toKey('down_arrow'),
      k: toKey('up_arrow'),
      l: toKey('right_arrow'),
    })
  ]),

  rule('Shift Shift').manipulators([
    withModifier(['left_shift'])({
      right_shift: toKey('caps_lock'),
    }),
    withModifier(['right_shift'])({
      left_shift: toKey('caps_lock'),
    })
  ]),

  rule('Terminal').manipulators([
        withModifier('command')({
            return_or_enter: to$('~/dotfiles/scripts/new-hyper-window.sh'),
        })
  ]),

  // Requires enabling these shortcuts in MacOS settings
  rule('Workspaces').manipulators([
    withModifier('command')({
      1: toKey('1', 'control'),
    }),
    withModifier('command')({
      2: toKey('2', 'control'),
    }),
    withModifier('command')({
      3: toKey('3', 'control'),
    }),
    withModifier('command')({
      4: toKey('4', 'control'),
    }),
    withModifier('command')({
      5: toKey('5', 'control'),
    }),
    withModifier('command')({
      6: toKey('6', 'control'),
    }),
  ]),

    // rule('swap').manipulators([
    //     // dont do this
    //     // map('left_command').to('left_control'),
    //     // map('left_control').to('left_command')
    //
    //     withModifier('command')({
    //         h: toKey('left_arrow', 'control')
    //
    //     }),
    //     withModifier('command')({
    //         j: toKey('down_arrow', 'control')
    //
    //     }),
    //     withModifier('command')({
    //         k: toKey('up_arrow', 'control')
    //
    //     }),
    //     withModifier('command')({
    //         l: toKey('right_arrow', 'control')
    //
    //     }),
    //     // withModifier('control')({
    //     //     l: toKey('l', 'command')
    //     //
    //     // }),
    //
    // ])
]

