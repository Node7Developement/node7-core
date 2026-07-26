-- Native RedM feed notifications pass packed structures to the game.
-- This DataView implementation provides the required little-endian buffers.

local zeroBlob = string.blob or function(length)
    return string.rep('\0', math.max(0, length))
end

DataView = DataView or {
    EndBig = '>',
    EndLittle = '<',
    Types = {
        Int8 = { code = 'i1', size = 1 },
        Uint8 = { code = 'I1', size = 1 },
        Int16 = { code = 'i2', size = 2 },
        Uint16 = { code = 'I2', size = 2 },
        Int32 = { code = 'i4', size = 4 },
        Uint32 = { code = 'I4', size = 4 },
        Int64 = { code = 'i8', size = 8 },
        Uint64 = { code = 'I8', size = 8 },
        LuaInt = { code = 'j', size = 8 },
        ULuaInt = { code = 'J', size = 8 },
        LuaNum = { code = 'n', size = 8 },
        Float32 = { code = 'f', size = 4 },
        Float64 = { code = 'd', size = 8 },
        String = { code = 'z', size = -1 },
    },
}

DataView.__index = DataView

local function endianPrefix(bigEndian)
    return bigEndian and DataView.EndBig or DataView.EndLittle
end

local function inBounds(view, offset, size)
    return offset >= 0 and (offset + size) <= view.length
end

local function replaceBytes(view, offset, packed)
    if not inBounds(view, offset, #packed) then return view end

    local startIndex = offset + 1
    local endIndex = startIndex + #packed - 1
    view.blob = view.blob:sub(1, startIndex - 1) .. packed .. view.blob:sub(endIndex + 1)
    return view
end

function DataView.ArrayBuffer(length)
    length = math.max(0, tonumber(length) or 0)
    return setmetatable({ offset = 0, length = length, blob = zeroBlob(length) }, DataView)
end

function DataView.Wrap(blob)
    blob = blob or ''
    return setmetatable({ offset = 0, length = #blob, blob = blob }, DataView)
end

function DataView:Buffer()
    return self.blob
end

function DataView:ByteLength()
    return self.length
end

function DataView:ByteOffset()
    return self.offset
end

function DataView:SubView(offset)
    offset = math.max(0, tonumber(offset) or 0)
    return setmetatable({ offset = self.offset + offset, length = self.length, blob = self.blob }, DataView)
end

for label, datatype in pairs(DataView.Types) do
    DataView['Get' .. label] = function(self, offset, bigEndian)
        offset = (tonumber(offset) or 0) + self.offset
        if datatype.size < 0 or not inBounds(self, offset, datatype.size) then return nil end
        local value = string.unpack(endianPrefix(bigEndian) .. datatype.code, self.blob, offset + 1)
        return value
    end

    DataView['Set' .. label] = function(self, offset, value, bigEndian)
        offset = (tonumber(offset) or 0) + self.offset
        if datatype.size < 0 or not inBounds(self, offset, datatype.size) then return self end
        return replaceBytes(self, offset, string.pack(endianPrefix(bigEndian) .. datatype.code, value))
    end
end
