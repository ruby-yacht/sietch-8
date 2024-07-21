-- Constants
local GRAVITY = 0.5  -- Gravity value
local BOUNCE_FACTOR = -0.8  -- Factor to bounce back after collision

local players = {}
local playerCount = 0

asci="\1\2\3\4\5\6\7\8\9\10\11\12\13\14\15\16\17\18\19\20\21\22\23\24\25\26\27\28\29\30\31\32\33\34\35\36\37\38\39\40\41\42\43\44\45\46\47\48\49\50\51\52\53\54\55\56\57\58\59\60\61\62\63\64\65\66\67\68\69\70\71\72\73\74\75\76\77\78\79\80\81\82\83\84\85\86\87\88\89\90\91\92\93\94\95\96\97\98\99\100\101\102\103\104\105\106\107\108\109\110\111\112\113\114\115\116\117\118\119\120\121\122\123\124\125\126\127\128\129\130\131\132\133\134\135\136\137\138\139\140\141\142\143\144\145\146\147\148\149\150\151\152\153\154\155\156\157\158\159\160\161\162\163\164\165\166\167\168\169\170\171\172\173\174\175\176\177\178\179\180\181\182\183\184\185\186\187\188\189\190\191\192\193\194\195\196\197\198\199\200\201\202\203\204\205\206\207\208\209\210\211\212\213\214\215\216\217\218\219\220\221\222\223\224\225\226\227\228\229\230\231\232\233\234\235\236\237\238\239\240\241\242\243\244\245\246\247\248\249\250\251\252\253\254\255"

-- main program ---------------
function main()

cls()
spr(1,60,16)
poke(24365,1) -- mouse+key kit

t=""
print("type in some text:",28,100,11)
repeat
  --grect(0,108,128,5)
  
  print(t,64-len(t)*2,108,6)
  --grect(64+len(t)*2,108,3,5,8)
  --flip()
  --grect(64+len(t)*2,108,3,5,0)
  if stat(30)==true then
    c=stat(31)
    if c>=" " and c<="z" then
      t=t..c
    elseif c=="\8" then
      t=fnd(t)
    elseif c!="\13" then
      cls()
      color(7)
      print("raw key:")
      print(asc(c))
      stop()
    end
  end
until c=="\13"

end --main()

-->8
-- functions ------------------

-- grect: draw proper rectangle
function grect(h,v,x,y,c)
  rectfill(h,v,h+x-1,v+y-1,c)
end --grect(.)

-- return string minus last chr
function fnd(a)
  return sub(a,1,#a-1)
end--fnd(.)

-- len: return string length
function len(a)
  return #a
end -- len(.)

-- return pos # of str b in a
function instr(a,b)
local r=0
  if (a==null or a=="") return 0
  if (b==null or b=="") return 0
  for i=1,#a-#b+1 do
    if sub(a,i,i+#b-1)==b then
      r=i
      return r
    end
  end
  return 0
end --instr(.)

-- return ascii id of character
function asc(a)
  return instr(asci,a)
end --asc(.)

main()

function _init()
    cls(1)
    print("Hop To Survive");
    initPlayers(1)
   end

function _update()
    updatePlayers()

    if btnp(4) then  -- 'Z' key
        bouncePlayers()
    end
end

function _draw()
    cls()
    map(0,0,0,0,16,16)
    drawPlayers()
end

function drawPlayers()
    for _, player in ipairs(players) do
        spr(1, player.x, player.y)
    end
end

function updatePlayers()
    for _, player in ipairs(players) do
        player.vy = player.vy + GRAVITY

        player.y = player.y + player.vy

               -- Check collision with ground (assuming ground level is at y = 120)
        if player.y + player.height >= 112 then
            player.y = 112 - player.height
            player.vy = player.vy * BOUNCE_FACTOR
            player.onGround = true
        else
            player.onGround = false
        end
    end
end

-- Function to handle players' bouncing
function bouncePlayers()
    for _, player in ipairs(players) do
        if player.onGround then
            player.vy = player.vy * BOUNCE_FACTOR + 5
        end
    end
end

function initPlayers(count)
    playerCount = count
    for i = 1, count do
        players[i] = {x = 64, y = 64, width = 8, height = 8, vx = 0, vy = 0, onGround = false}
    end
end