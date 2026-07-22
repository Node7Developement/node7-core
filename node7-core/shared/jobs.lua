Node7Shared = Node7Shared or {}
Node7Shared.ForceJobDefaultDutyAtLogin = true

Node7Shared.Jobs = {
    ['unemployed'] = {
        label = 'Civilian',
        defaultDuty = true,
        offDutyPay = false,
        grades = {
            ['0'] = {
                name = 'Freelancer',
                payment = 0
            },
        },
    },
    ['sheriff'] = {
        label = 'Sheriff Department',
        defaultDuty = true,
        offDutyPay = false,
        grades = {
            ['0'] = {
                name = 'Recruit',
                payment = 4
            },
            ['1'] = {
                name = 'Deputy',
                payment = 6
            },
            ['2'] = {
                name = 'Senior Deputy',
                payment = 9
            },
            ['3'] = {
                name = 'Undersheriff',
                payment = 13
            },
            ['4'] = {
                name = 'Sheriff',
                isboss = true,
                payment = 18
            },
        },
    },
    ['doctor'] = {
        label = 'Medical Department',
        defaultDuty = true,
        offDutyPay = false,
        grades = {
            ['0'] = {
                name = 'Orderly',
                payment = 4
            },
            ['1'] = {
                name = 'Nurse',
                payment = 6
            },
            ['2'] = {
                name = 'Doctor',
                payment = 10
            },
            ['3'] = {
                name = 'Surgeon',
                payment = 13
            },
            ['4'] = {
                name = 'Chief Physician',
                isboss = true,
                payment = 17
            },
        },
    },
    ['blacksmith'] = {
        label = 'Blacksmith',
        defaultDuty = true,
        offDutyPay = false,
        grades = {
            ['0'] = {
                name = 'Apprentice',
                payment = 4
            },
            ['1'] = {
                name = 'Blacksmith',
                payment = 7
            },
            ['2'] = {
                name = 'Senior Blacksmith',
                payment = 10
            },
            ['3'] = {
                name = 'Master Blacksmith',
                isboss = true,
                payment = 14
            },
        },
    },
    ['rancher'] = {
        label = 'Ranching Company',
        defaultDuty = true,
        offDutyPay = false,
        grades = {
            ['0'] = {
                name = 'Ranch Hand',
                payment = 3
            },
            ['1'] = {
                name = 'Wrangler',
                payment = 5
            },
            ['2'] = {
                name = 'Foreman',
                payment = 8
            },
            ['3'] = {
                name = 'Ranch Owner',
                isboss = true,
                payment = 13
            },
        },
    },
    ['stablehand'] = {
        label = 'Stable Company',
        defaultDuty = true,
        offDutyPay = false,
        grades = {
            ['0'] = {
                name = 'Stable Groom',
                payment = 3
            },
            ['1'] = {
                name = 'Horse Trainer',
                payment = 6
            },
            ['2'] = {
                name = 'Stable Manager',
                payment = 9
            },
            ['3'] = {
                name = 'Stable Owner',
                isboss = true,
                payment = 13
            },
        },
    },
    ['saloon'] = {
        label = 'Saloon',
        defaultDuty = true,
        offDutyPay = false,
        grades = {
            ['0'] = {
                name = 'Server',
                payment = 3
            },
            ['1'] = {
                name = 'Bartender',
                payment = 5
            },
            ['2'] = {
                name = 'Floor Manager',
                payment = 8
            },
            ['3'] = {
                name = 'Saloon Owner',
                isboss = true,
                payment = 12
            },
        },
    },
}

Node7Jobs = Node7Shared.Jobs

function Node7NormalizeJobDefinition(name, definition)
    assert(type(name) == 'string' and name:match('^[%w_]+$'), 'Invalid NODE7 job name')
    assert(type(definition) == 'table' and type(definition.label) == 'string', ('Job %s requires a label'):format(name))
    assert(type(definition.grades) == 'table' and (definition.grades['0'] or definition.grades[0]), ('Job %s requires grade 0'):format(name))
    definition.defaultDuty = definition.defaultDuty == true
    definition.offDutyPay = definition.offDutyPay == true
    return definition
end
