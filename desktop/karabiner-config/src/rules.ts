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

  rule('Playground').manipulators([
    map('caps_lock').toHyper().toIfAlone('escape'),
  ]),

  rule('Terminal').manipulators([
        withModifier('command')({
            return_or_enter: to$('osascript ~/dotfiles/scripts/new-iterm-window.scpt'),
        })
  ]),
  rule('Launch Apps').manipulators([
        withModifier(['option', 'control', 'shift', 'command'])({
            h: toKey('left_arrow'),
            j: toKey('down_arrow'),
            k: toKey('up_arrow'),
            l: toKey('right_arrow'),
            d: toApp('Calendar'),
            f: toApp('Finder'),
        })
  ]),

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
  ])
]

