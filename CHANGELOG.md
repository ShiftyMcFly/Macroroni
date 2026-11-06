# Macro Action Bar

## [v1.2.1](https://github.com/notstraws/MacroActionBar/tree/v1.2.1) (2026-11-05)
[Full Changelog](https://github.com/notstraws/MacroActionBar/compare/v1.2.0...v1.2.1) 

- Skip restricted frames when measuring spellbook neighbours (#62)  
    Opening the spellbook scans UIParent's children for other addons' tabs  
    and pages. Restricted frames such as PingPin can't be measured, so each  
    GetRect call raised a "Can't measure restricted regions" error blamed on  
    MacroActionBar. Skip frames whose anchoring is restricted or secret  
    before reading their rect or center. Bump LibSpellBookTabs MINOR to 7.  