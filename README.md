# Macroroni

A World of Warcraft forever addon that allow players to easily configure macro's straight from the spellbook.

## Configuring your class

Each class has its own file in `src/Config/` (for example `src/Config/Warlock.lua`). It sets the page's sections,
which spells offer mouseover or cursor casting, and your own custom macros. `src/Config/Config.lua` explains
each list. Edit your class's file, then type `/reload` in game.

Spells that aren't in any section appear under "Unsorted" at the end of the page.

## Credits

Macroroni is based on [Macro Action Bar](https://github.com/notstraws/MacroActionBar) v1.2.1 by NotStraws, used under
the MIT License (see `LICENSE`). Do not run both addons at once: they manage the same WoW macros.
