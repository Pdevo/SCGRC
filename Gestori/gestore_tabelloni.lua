-- inizializzazione periferiche

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
print("< tabelloni >")
sleep(1)
print("gestore")
sleep(1)
print("assegnazione")
sleep(1)
print("inizializzazione")
sleep(1)
print("connessione")
rednet.open(modem)
rednet.broadcast("avvio_gestore_tabelloni")
sleep(1)
print("funzionamento")
   
while true do
local message = rednet.receive()
local words = {}

for word in string.gmatch(message, "%w+") do words[#words + 1] = word end

 if words[1] == "sistemi" then
 
  if words[2] == "gestore" then
  
   if words[3] == "tabelloni" then
   
    if words[4] == "spegnimento" then
    rednet.broadcast("spegnimento_gestore_tabelloni")
    os.shutdown()
    end
	
    if words[4] == "riavvio" then
    rednet.broadcast("riavvio_gestore_tabelloni")
    os.reboot()
    end
	
   end
   
  end
  
 end
 
end