-- versori cardinalita'

ve = 1
vs = 2
vw = 3
vn = 4

-- versori direzionalita'

we = 3
ws = 4
ww = 1
wn = 2

-- binari di direttrice

xd = 1
yd = 2

-- codifica di direttice

cd = 0

-- fattore sequenziale

fs = 1/5

-- inizializzazione tragitti

tragitto = {}

-- inizializzazione versore est

tragitto[ve] = {}
tragitto[ve][cd] = {}
tragitto[ve][cd]["scambi"] = {}
tragitto[ve][xd] = {}
tragitto[ve][xd]["scambi"] = {}
tragitto[ve][yd] = {}
tragitto[ve][yd]["scambi"] = {}

-- inizializzazione versore sud

tragitto[vs] = {}
tragitto[vs][cd] = {}
tragitto[vs][cd]["scambi"] = {}
tragitto[vs][xd] = {}
tragitto[vs][xd]["scambi"] = {}
tragitto[vs][yd] = {}
tragitto[vs][yd]["scambi"] = {}

-- inizializzazione versore ovest

tragitto[vw] = {}
tragitto[vw][cd] = {}
tragitto[vw][cd]["scambi"] = {}
tragitto[vw][xd] = {}
tragitto[vw][xd]["scambi"] = {}
tragitto[vw][yd] = {}
tragitto[vw][yd]["scambi"] = {}

-- inizializzazione versore nord

tragitto[vn] = {}
tragitto[vn][cd] = {}
tragitto[vn][cd]["scambi"] = {}
tragitto[vn][xd] = {}
tragitto[vn][xd]["scambi"] = {}
tragitto[vn][yd] = {}
tragitto[vn][yd]["scambi"] = {}

-- configurazione tragitti

tragitto[ve][xd]["scambi"][101] = {"0","attivo","1","inattivo","2","attivo","3","attivo","4","attivo","5","attivo"}
tragitto[ve][xd]["scambi"][102] = {"0","attivo","1","inattivo","2","attivo","3","attivo","4","attivo","5","inattivo"}
tragitto[ve][xd]["scambi"][103] = {"0","attivo","1","inattivo","2","inattivo","6","inattivo"}
tragitto[ve][xd]["scambi"][104] = {"0","attivo","1","inattivo","2","inattivo","6","attivo"}

tragitto[vn][yd]["scambi"][101] = {"5","attivo","4","attivo","3","attivo","2","attivo","1","attivo","10","inattivo","11","inattivo","12","inattivo"}
tragitto[vn][yd]["scambi"][102] = {"5","inattivo","4","attivo","3","attivo","2","attivo","1","attivo","10","inattivo","11","inattivo","12","inattivo"}
tragitto[vn][yd]["scambi"][103] = {"6","inattivo","2","inattivo","1","attivo","10","inattivo","11","inattivo","12","inattivo"}
tragitto[vn][yd]["scambi"][104] = {"6","attivo","2","inattivo","1","attivo","10","inattivo","11","inattivo","12","inattivo"}

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
print("< scambi >")
sleep(1)
print("gestore")
sleep(1)
print("assegnazione")
sleep(1)
print("inizializzazione")
sleep(1)
print("connessione")
rednet.open(modem)
rednet.broadcast("avvio_gestore_scambi")
sleep(1)
print("funzionamento")

-- codice sistema
 
while true do
local message = rednet.receive()
local words = {}

for word in string.gmatch(message, "%w+") do words[#words + 1] = word end

 if words[1] == "configura" then
 
  if words[2] == "tragitto" then
  
  local v = tonumber(words[3])
  local d = tonumber(words[4]) 
  local c = tonumber(words[5])
  local t = tragitto[v][d]["scambi"][c]
  
   if t == nil then
   rednet.broadcast("tragitto_"..v.."_"..d.."_"..c.."_scambi_indefinito")
   end
   
   if t ~= nil then
   local i1 = 1
   local i2 = #t/2
   error = nil
    for i = i1, i2 do
    local jn = i*1
    local js = i*2
    local n = tragitto[v][d]["scambi"][c][jn]
    local s = tragitto[v][d]["scambi"][c][js]
    rednet.broadcast("comando_scambio_"..n.."_"..s)
    event, id, message, distance, protocol = os.pullEvent("rednet_message")
	 if message ~= "aggiornamento_scambio_"..n.."_"..s then
	 error = true
	 break
     end     
	 if message == "aggiornamento_scambio_"..n.."_"..s then
	 error = false
     end
    end
    if error == true then  
    rednet.broadcast("tragitto_"..v.."_"..d.."_"..c.."_scambi_errore")
    end
    if error == false then
    rednet.broadcast("tragitto_"..v.."_"..d.."_"..c.."_scambi_configurato")
    end
   end
   
  end
  
 end
 
 if words[1] == "sistemi" then
 
  if words[2] == "gestore" then
  
   if words[3] == "scambi" then
   
    if words[4] == "spegnimento" then
    rednet.broadcast("spegnimento_gestore_scambi")
    os.shutdown()
    end
    if words[4] == "riavvio" then
    rednet.broadcast("riavvio_gestore_scambi")
    os.reboot()
    end
	
   end
   
  end
  
 end
 
end