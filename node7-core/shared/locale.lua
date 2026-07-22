Node7Locales = Node7Locales or {}

function Node7Translate(key)
    local locale = Node7Locales[Node7Config.Locale] or Node7Locales.en
    return locale[key] or key
end
