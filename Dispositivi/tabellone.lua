-- configurazione numero

n = 0

-- configurazione lato

l = " "
 
-- inizializzazione perifeiche

modem = nil
 for _, side in pairs(rs.getSides()) do
  if peripheral.getType(side) == "modem" then
  modem = side
  break
  end
 end
 
monitor = nil
 for _, side in pairs(rs.getSides()) do
  if peripheral.getType(side) == "monitor" then
  monitor = side
  break
  end
 end 
 
-- codice avvio 
 
sleep(1)
print("< "..n.." >")
sleep(1)
print("tabellone")
sleep(1)
print("assegnazione")
sleep(1)
print("inizializzazione")
sleep(1)
print("connessione")
rednet.open(modem)
rednet.broadcast("avvio_tabellone_"..n)
sleep(1)
print("funzionamento")

-- codice sistema   
   
while true do
local message = rednet.receive()
local words = {}

for word in string.gmatch(message, "%w+") do words[#words + 1] = word end

 if words[1] == "sistemi" then
 
  if words[2] == "tabellone" then
  
   if tonumber(words[3]) == n then
   
    if words[4] == "spegnimento" then
	
    rednet.broadcast("spegnimento_tabellone_"..n)
    os.shutdown()
    end
    if words[4] == "riavvio" then
    rednet.broadcast("riavvio_tabellone_"..n)
    os.reboot()
    end
	
   end
   
  end
  
 else
 
 term.redirect(peripheral.wrap(monitor))
 print(message)
 end
 
end