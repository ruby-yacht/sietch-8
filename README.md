# HOP32
Created by Sietch of Ludicrous <br>
Game design and development: Mr. Cole Pergerson<br>
Production, outreach, and character design: James Morgan<br>
Additional development: Shahbaz Mansahia<br>

## Player input
Our original support for 32 players on the keyboard was quite unconventional and we weren't sure if this was possible in Pico8. We did consider hacking gamepad input
in such a way where each button represented a unique player, but luckily we found that Pico8 had experiemental support for full keyboard and mouse input. See 
6.13 in the manual for the details. At the start of the game, players can press any key and a characters becomes assigned to that key. When physical buttons were introduced,
the keys were changed to be preassigned so that players knew which character they were playing when they chose a button. The predetermined or assigning keys at will methods
were both useful and a setting to switch between the two is planned. 

## Characters
A character is just a table that holds the essential data such as location, sprite, score, and other variables. Look in players.lua for the full table. 

## Level generation
The environment is procedurally generated in chunks to reduce memory costs. The method is fairly trivial; first fill all the grid spaces with tiles, then 
remove tiles above a height determined by a sin wave. The sin wave can be modified to allow for different terrain types, such as grass lands, desert dunes, or mountains.   
