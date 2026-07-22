# NODE7 Registry Guide

All definitions are ordinary Lua tables. The normalizers apply defaults and reject malformed entries.

## Add an item

```lua
exports['node7-core']:AddItem('railroad_bond', {
    ['name'] = 'railroad_bond',
    ['label'] = 'Railroad Bond',
    ['weight'] = 10,
    ['type'] = 'item',
    ['image'] = 'railroad_bond.png',
    ['unique'] = true,
    ['useable'] = true,
    ['shouldClose'] = true,
    ['combinable'] = nil,
    ['level'] = 0,
    ['description'] = 'A negotiable railroad bond.'
})
```

The built-in item file uses this same literal format for every entry.

## Add a job

```lua
exports['node7-core']:AddJob('railroad', {
    label = 'Railroad Company',
    defaultDuty = true,
    offDutyPay = false,
    grades = {
        ['0'] = { name = 'Laborer', payment = 3 },
        ['1'] = { name = 'Engineer', payment = 7 },
        ['2'] = { name = 'Superintendent', payment = 12, isboss = true }
    }
})
```

## Add a gang

```lua
exports['node7-core']:AddGang('example_gang', {
    label = 'Example Gang',
    grades = {
        ['0'] = { name = 'Associate' },
        ['1'] = { name = 'Member' },
        ['2'] = { name = 'Boss', isboss = true }
    }
})
```

## Add a stable model

Add a shared horse definition at runtime:

```lua
exports['node7-core']:AddHorse('example_horse', {
    name = 'Example Horse',
    model = 'A_C_HORSE_EXAMPLE_MODEL',
    price = 100,
    category = 'horse',
    type = 'horse',
    shop = 'stable'
})
```

Only registered stable models can be granted or spawned by NODE7 commands.
