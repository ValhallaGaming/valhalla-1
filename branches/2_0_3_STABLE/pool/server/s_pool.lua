poolTable = {
    ["player"] = {},
    ["vehicle"] = {},
    ["colshape"] = {},
    ["ped"] = {},
    ["marker"] = {},
    ["object"] = {},
    ["pickup"] = {},
    ["team"] = {},
    ["blip"] = {}
}

function isValidType(elementType)
    for k, v in pairs(poolTable) do
        if k == elementType then
            return true
        end
    end
    return false
end

function deallocateElement(element)
    local elementType = getElementType(element)
    if (isValidType(elementType)) then
        local elementPool = poolTable[elementType]
        for k, v in ipairs(elementPool) do
            if v == element then
                table.remove(elementPool, k)
            end
        end
    end
end

function allocateElement(element)
    local elementType = getElementType(element)
    if (isValidType(elementType)) then
        table.insert (poolTable[elementType], element)
    end
end

function getPoolElementsByType(elementType)
    if isValidType(elementType) then
        return poolTable[elementType]
    end
end

function updatePoolOnResourceStart(resource)
    if resource == getThisResource() then
        for k, element in ipairs(getElementChildren(getRootElement())) do
            allocateElement(element)
        end
    else
        for k, element in ipairs( getElementChildren(source)) do
            allocateElement(element)
        end
    end
end

addEventHandler("onResourceStart", getRootElement(), updatePoolOnResourceStart)

addEventHandler("onPlayerJoin", getRootElement(),
    function ()
        allocateElement(source)
    end
)

addEventHandler("onPlayerQuit", getRootElement(),
    function ()
        deallocateElement(source)
    end
)

addEventHandler("onElementDestroyed", getRootElement(),
    function ()
        deallocateElement(source)
    end
)