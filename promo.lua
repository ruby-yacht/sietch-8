
local sprites = {33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, 52, 53, 54, 55, 56, 57, 58, 59, 60, 61, 62, 63, 64}

function _init()


end


function _update()


end

function _draw()

    cls()
    --map(0,0,0,0,128,16)
    map(17,0,0,0,128,16)

    rectfill(0, 0, 0, 0 + 8, 0)


    local row1 = 24
    local row2 = 30
    local offset = 7.8
    local xpos = 1
    local amplitude = 2.5

    for i = 1, 16, 1 do
        if i != 1 and i != 3 then
            spr(sprites[i], xpos, row1 + (sin(xpos / 10) * amplitude) )
            
        end
        xpos += offset
    end

    spr(sprites[1], 4, 12)
    spr(sprites[3], 18, 6)
    --[[
        spr(sprites[1], xpos,row1)
        spr(sprites[2], ,row1)
        spr(sprites[3], 18,row1)
        spr(sprites[4], 20,row1)
        spr(sprites[5], 25,row1)
        spr(sprites[6], 30,row1)
        spr(sprites[7], 35,row1)
        spr(sprites[8], 20,row1)
        spr(sprites[9], 50,row1)
        spr(sprites[10], 85,row1)
        spr(sprites[11], 90,row1)
        spr(sprites[12], 80,row1)
        spr(sprites[13], 70,row1)
        spr(sprites[14], 5,row1)
        spr(sprites[15], 5,row1)
        spr(sprites[16], 14,row1)
        ]]

    xpos = 2
    for i = 17, 32, 1 do
        if i != 28 then
            spr(sprites[i], xpos, row2 + (sin(xpos / 10) * amplitude))
        end
        xpos += offset
    end

    spr(sprites[28], 90,8)
    --[[
        spr(sprites[17], 5,row2)
        spr(sprites[18], 38,row2)
        spr(sprites[19], 97,row2)
        spr(sprites[20], 100,row2)
        spr(sprites[21], 105,row2)
        spr(sprites[22], 110,row2)
        spr(sprites[23], 115,row2)
        spr(sprites[24], 115,row2)
        spr(sprites[25], 75,row2)
        spr(sprites[26], 85,row2)
        spr(sprites[27], 48,row2)
        spr(sprites[28], 58,row2)
        spr(sprites[29], 68,row2)
        spr(sprites[30], 110,row2)
        spr(sprites[31], 88,row2)
        spr(sprites[32], 98,row2)
        ]]

    --spr(110, 45, 7)
    --spr(109, 45, 1)

        print("", 0, 0, 7)
    --print("\^w\^thop32", 46, 56)
    print("\^w\^thop32", 44, 12)

    rectfill(0, 5*8, 128, 128, 1)

end