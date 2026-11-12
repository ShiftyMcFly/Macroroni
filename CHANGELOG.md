# Macroroni

## v1.5.0 (2026-11-12)

- Added help/harm pairing. An enemy spell's menu has On Friendly, and a friendly spell's has On Enemy: pick a spell to cast instead when the unit is of the other reaction, e.g. a Mouseover Moonfire that casts Regrowth on a friendly mouseover.
- The pair follows the macro's Cast On (Target, Mouseover or Focus). Each spell in the list has its own Rank choice, Highest by default. Shift, Ctrl, Alt and form picks still come first.
- Pairing is off with Cursor, Self or Nearest Player, a sequence, a rank 1 cast or a pet ability. A paired macro shows "Help/Harm" on the page.

## v1.4.0 (2026-11-12)

- Added a Rank menu to each spell macro with more than one trained rank. Highest, the default, always casts your highest rank; picking a rank casts that one, e.g. Moonfire(Rank 3).
- The Shift, Ctrl and Alt picks have their own Rank choice, next to their Cast On choice. It defaults to Highest.
- Form, Then Cast and sequence spells cast at the rank their own macro picked.
- Downrank In Raids and Rank 1 Out Of Combat moved into the Rank menu, as In Raids and Out Of Combat, and work with a picked rank.
- A macro with a picked rank shows it on the page.

## v1.3.1 (2026-11-08)

- Fixed the Druid Smart Travel macro, which shifted out of Cat Form indoors instead of casting Dash once Aquatic Form was learned. It now finds Cat Form on your stance bar instead of assuming it is form 2.
- Smart Travel uses Cat Form until Travel Form is learned, and leaves Dash out until it is learned.
- Smart Travel has a bare #showtooltip like the other macros, so its icon follows the form it would cast.
- Smart Travel updates itself as you learn forms or Dash, without opening the page.

## v1.3.0 (2026-11-08)

- Added Edit Macro... to each spell macro's right-click menu. It opens a window where you can write the macro's text yourself, and Macroroni keeps your text instead of overwriting it.
- The window shows a character count against WoW's 255 limit, and Automatic Text fills it with the text Macroroni would generate.
- An edited macro shows "Edited" on the page. Its options are hidden, since they no longer change it, but its Icon menu still works.
- Revert To Automatic, or Reset To Default, goes back to the generated macro.

## v1.2.0 (2026-11-06)

- Added an Icon menu to each spell macro's right-click menu.
- Automatic keeps a bare #showtooltip, so the icon follows the spell the macro would cast.
- Picking one of the macro's spells names it after #showtooltip, which locks the icon to that spell.
- Custom Icon opens a picker with the game's macro icon list and sets that icon on the macro.

## v1.1.0 (2026-11-06)

- Removed the spell name after #showtooltip in generated macros, so a macro that casts different spells by form or stance shows the right icon.

## v1.0.0 (2026-11-06)

- First version: a renamed copy of Macro Action Bar v1.2.1 by NotStraws.

---

The original addon's changelog follows.

# Macro Action Bar

## [v1.2.1](https://github.com/notstraws/MacroActionBar/tree/v1.2.1) (2026-11-05)
[Full Changelog](https://github.com/notstraws/MacroActionBar/compare/v1.2.0...v1.2.1) 

- Skip restricted frames when measuring spellbook neighbours (#62)  
    Opening the spellbook scans UIParent's children for other addons' tabs  
    and pages. Restricted frames such as PingPin can't be measured, so each  
    GetRect call raised a "Can't measure restricted regions" error blamed on  
    MacroActionBar. Skip frames whose anchoring is restricted or secret  
    before reading their rect or center. Bump LibSpellBookTabs MINOR to 7.  