---
toc: Utilities / Miscellaneous
summary: How to roll dice.
---
# Roll
This command lets you roll dice on the game.

`roll <dice>` - Rolls the given dice, with modifiers.
    Example 1: roll 1d20 + 5
    Example 2: roll 1d20 + 1d6 + 4
    Example 3: roll 1d20 + Strength + 2
`roll <dice>/<comment>` - The same as above, but lets you add an optional
    comment to explain where the values are coming from.
    Example 4: roll 1d20 + 5/+2 (BAB) + 1 (Masterwork) + 1 (Favored Enemy)
`roll <dice>=<target>` - Instead of rolling to the room, this rolls to a
    specific target. Target can be another player or a job.
    Example 6: roll 1d20 + 5 = Ao
    Example 7: roll 1d20 + 5 = Job 31
`roll <dice>=<target>/<comment>` - The same as above, save that it rolls the
    dice to a specific target with an additional comment.
    Example 8: roll 1d20 + 5=Ao/+2 (BAB) + 1 (Masterwork) + 1 (Favored Emeny)
