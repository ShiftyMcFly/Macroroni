# Macroroni

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