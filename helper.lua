
-- Tables

function add_unique(table, value)
    if not contains(table, value) then
        add(table, value)
    end

end

function contains(table, value)
    for _, v in ipairs(table) do
        if v == value then 
            return true
        end
    end
    return false
end

-- Queue

-- Queue implementation
Queue = {}
Queue.__index = Queue

-- Create a new queue
function Queue.new()
    local self = setmetatable({
        items = {}, -- The table to hold queue items
        head = 1,   -- Index of the first element
        tail = 1    -- Index of the next insertion point
    }, Queue)
    return self
end

-- Add an item to the end of the queue
function Queue:enqueue(item)
    self.items[self.tail] = item
    self.tail = self.tail + 1
end

-- Remove and return the item from the front of the queue
function Queue:dequeue()
    if self:isempty() then
        return nil
    end
    local item = self.items[self.head]
    self.items[self.head] = nil -- Remove reference
    self.head = self.head + 1
    return item
end

-- Check if the queue is empty
function Queue:isempty()
    return self.head == self.tail
end

-- Peek at the item at the front of the queue without removing it
function Queue:peek()
    if self:isempty() then
        return nil
    end
    return self.items[self.head]
end

-- Get the number of items in the queue
function Queue:size()
    return self.tail - self.head
end
