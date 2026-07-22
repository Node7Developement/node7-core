Node7Shared = Node7Shared or {}

Node7Shared.Gangs = {
    ['none'] = {
        label = 'No Gang',
        grades = {
            ['0'] = {
                name = 'Unaffiliated'
            },
        },
    },
    ['blackwater_raiders'] = {
        label = 'Blackwater Raiders',
        grades = {
            ['0'] = {
                name = 'Associate'
            },
            ['1'] = {
                name = 'Member'
            },
            ['2'] = {
                name = 'Enforcer'
            },
            ['3'] = {
                name = 'Underboss'
            },
            ['4'] = {
                name = 'Boss',
                isboss = true
            },
        },
    },
    ['grizzlies_outlaws'] = {
        label = 'Grizzlies Outlaws',
        grades = {
            ['0'] = {
                name = 'Associate'
            },
            ['1'] = {
                name = 'Member'
            },
            ['2'] = {
                name = 'Enforcer'
            },
            ['3'] = {
                name = 'Underboss'
            },
            ['4'] = {
                name = 'Boss',
                isboss = true
            },
        },
    },
    ['lemoyne_riders'] = {
        label = 'Lemoyne Riders',
        grades = {
            ['0'] = {
                name = 'Associate'
            },
            ['1'] = {
                name = 'Member'
            },
            ['2'] = {
                name = 'Enforcer'
            },
            ['3'] = {
                name = 'Underboss'
            },
            ['4'] = {
                name = 'Boss',
                isboss = true
            },
        },
    },
    ['new_austin_renegades'] = {
        label = 'New Austin Renegades',
        grades = {
            ['0'] = {
                name = 'Associate'
            },
            ['1'] = {
                name = 'Member'
            },
            ['2'] = {
                name = 'Enforcer'
            },
            ['3'] = {
                name = 'Underboss'
            },
            ['4'] = {
                name = 'Boss',
                isboss = true
            },
        },
    },
    ['cumberland_wolves'] = {
        label = 'Cumberland Wolves',
        grades = {
            ['0'] = {
                name = 'Associate'
            },
            ['1'] = {
                name = 'Member'
            },
            ['2'] = {
                name = 'Enforcer'
            },
            ['3'] = {
                name = 'Underboss'
            },
            ['4'] = {
                name = 'Boss',
                isboss = true
            },
        },
    },
}

Node7Gangs = Node7Shared.Gangs

function Node7NormalizeGangDefinition(name, definition)
    assert(type(name) == 'string' and name:match('^[%w_]+$'), 'Invalid NODE7 gang name')
    assert(type(definition) == 'table' and type(definition.label) == 'string', ('Gang %s requires a label'):format(name))
    assert(type(definition.grades) == 'table' and (definition.grades['0'] or definition.grades[0]), ('Gang %s requires grade 0'):format(name))
    return definition
end
