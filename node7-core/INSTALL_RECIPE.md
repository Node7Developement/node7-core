# txAdmin Recipe Support

This resource is built to be dropped into the clean NODE7 recipe folder layout.

Expected path after running the recipe:

```text
resources/[node7-core]/node7-core
```

Expected start order:

```cfg
ensure oxmysql
ensure node7-core
ensure node7-players
ensure node7-multicharacter
```

Important:

- `node7-core` has no SQL.
- `node7-core` has no `oxmysql` dependency.
- The recipe should import only the clean `players` table for `node7-players`.
- Do not import any old core SQL.
