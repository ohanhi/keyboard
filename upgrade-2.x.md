# Upgrading to 2.0

The major changes from 1.x:

- Characters are always uppercase by default in the "Msg and update" way
- Instead of `anyKey`, use either `anyKeyUpper` (uppercase characters) or `anyKeyOriginal` (original case)
- Instead of `characterKey`, use either `characterKeyUpper` (uppercase characters) or `characterKeyOriginal` (original case)
- Space key is now `Spacebar` instead of `Character " "` in the `anyKeyUpper` and `anyKeyOriginal` parsers. It is still `Character " "` if your parser does not use `whitespaceKey` or if it's after `characterKey__` in `oneOf`.
