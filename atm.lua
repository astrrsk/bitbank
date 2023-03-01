local inputChest = peripheral.wrap("minecraft:chest_4")
local outputChest = peripheral.wrap("minecraft:chest_5")

local nInput = peripheral.getName(inputChest)
local nOutput = peripheral.getName(outputChest)

local diamondChest = peripheral.wrap("minecraft:chest_12")
local singleBitChest = peripheral.wrap("minecraft:chest_9")
local stackBitChest = peripheral.wrap("minecraft:chest_10")

local nDiamonds = peripheral.getName(diamondChest)
local nSingleBit = peripheral.getName(singleBitChest)
local nStackBit = peripheral.getName(stackBitChest)

local trashChest = peripheral.wrap("minecraft:chest_7")

local nTrash = peripheral.getName(trashChest)

print("Bits ATM System v1")
print("written by astr :3")

local function bitSingle(slot, item)
    local stacksToGive = 0
    local stackSize = item.count
    
    while (stackSize - 4) >= 0 do
        stackSize = stackSize - 4
        stacksToGive = stacksToGive + 1
    end
    
    inputChest.pushItems(nTrash, slot, item.count, slot)
    diamondChest.pushItems(nOutput, slot, stacksToGive, slot)
    if stackSize == 0 then return end

    while singleBitChest.pushItems(nOutput, slot, stackSize, slot) == 0 do end
    return {stacksToGive, stackSize}
end

local function bitStack(slot, item)
    inputChest.pushItems(nTrash, slot, item.count, slot)
    diamondChest.pushItems(nOutput, slot, item.count, slot)
    return item.count
end

local function diamond(slot, item)
    inputChest.pushItems(nTrash, slot, item.count, slot)
    stackBitChest.pushItems(nOutput, slot, item.count, slot)
    return item.count
end


local function pullItems()
    local transactionResults = [0, 0, 0] --Diamonds transferred, Bit Stacks transferred, Bits returned
    for slot, item in pairs(inputChest.list()) do
        if item.name == "minecraft:diamond" then
            transactionResults[2] = transactionResults[2] + diamond(slot, item)
        end
        if item.name == "createdeco:gold_coin" then
            local res = bitSingle(slot, item)
            transactionResults[2] = transactionResults[2] + res[1]
            transactionResults[3] = transactionResults[3] + res[2]
        end
        if item.name == "createdeco:gold_coinstack" then
            transactionResults[1] = transactionResults[1] + bitStack(slot, item)
        end
        
        local output = ("Transferred %d Diamonds, %d Bit Stacks. Returned %d Single Bits to the recipient."):format(transactionResults[1], transactionResults[2], transactionResults[3])
        print(output)
    end
end

while true do
    os.pullEvent("redstone")
    if rs.getInput("top") then
        pullItems()
    end
end
