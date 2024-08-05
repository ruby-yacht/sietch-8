
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