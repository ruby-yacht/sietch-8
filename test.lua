function _init()
    cls(1)
    print("Hop To Survive");
   end

function _update()

end

function _draw()
    map(0,0,0,0,16,16)
    drawYoMama()
end

function drawYoMama()
    spr(1, 50, 50)
end