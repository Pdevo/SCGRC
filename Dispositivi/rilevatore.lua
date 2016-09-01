-- configurazione numero

n = 0

-- configurazione lato

l = " "

-- configurazione archivio

a = "stato"

-- fattore attivita'

h = 1

-- fattore gerarchico

g = 1/10

-- operatore gerarchico

w = n*g

-- inizializzazione periferiche

modem = nil
 for _, side in pairs(rs.getSides()) do
  if peripheral.getType(side) == "modem" then
  modem = side
  break
  end
 end

-- codice avvio
 
sleep(1)
print("< "..n.." >")
sleep(1)
print("rilevatore")
sleep(1)
print("assegnazione")
sleep(1)
print("inizializzazione")
sleep(1)
print("connessione")
rednet.open(modem)
rednet.broadcast("avvio_rilevatore_"..n)
sleep(1)
print("funzionamento")

-- codice stato
 
 if redstone.getInput(l,true) then
 sleep(w)
 rednet.broadcast("aggiornamento_rilevatore_"..n.."_attivo")
 end
 
 if redstone.getInput(l,false) then
 sleep(w)
 rednet.broadcast("aggiornamento_rilevatore_"..n.."_inattivo")
 end
 
-- codice sistema 
 
while true do
os.pullEvent("redstone")

 if redstone.getInput(l, true) then
 rednet.broadcast("aggiornamento_rilevatore_"..n.."_attivo")
 end
 
 while(redstone.getInput(l)) do
 sleep(1)
 end
 
rednet.broadcast("aggiornamento_rilevatore_"..n.."_inattivo")

end