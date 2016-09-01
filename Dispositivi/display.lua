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
print("display")
sleep(1)
print("assegnazione")
sleep(1)
print("inizializzazione")
sleep(1)
print("connessione")
rednet.open(modem)
rednet.broadcast("avvio_display_"..n)
sleep(1)
print("funzionamento")

-- codice sistema   
   
while true do
local id, codice = rednet.receive()

 if codice == {"sistemi","display",n,"spegnimento"} then
 rednet.broadcast({"spegnimento","display",n})
 os.shutdown()
 end
 if codice == {"sistemi","display",n,"riavvio"} then
 rednet.broadcast({"riavvio","display",n})
 os.reboot()
 end
 
term.redirect(peripheral.wrap(monitor))
print(textutils.serialize(codice))
 
end