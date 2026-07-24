# NODE7 Core Recipe

Start order:

```cfg
ensure ox_lib
ensure oxmysql
ensure node7-core
```

Import `recipe/node7-core.sql` or leave the resource to auto-create/update the required `players` and `bans` tables on first start.

Optional ACE lines are in `recipe/permissions.cfg`.
