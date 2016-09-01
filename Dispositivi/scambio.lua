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
print("scambio")
sleep(1)
print("assegnazione")
sleep(1)
print("inizializzazione")
sleep(1)
print("connessione")
rednet.open(modem)
rednet.broadcast("avvio_scambio_"..n)
sleep(1)
print("funzionamento")

-- codice funzioni

function genera_tabella()

scambio = {}
scambio[stato] = {}
scambio[tempo] = {}

end

function salva_tabella(table,name)

local file = fs.open(name,"w")
local text = textutils.serialize(table)
file.write(text)
file.close()

end

function carica_tabella(table,name)

local file = fs.open(name,"r")
local text = file.readAll()
local data = textutils.unserialize(text)
table = data
file.close()

end

-- codice archiviazione

local archivio = fs.exists(a)
 
 if archivio == true then
 carica_tabella(scambio,a)
 end

 if archivio == false then
 genera_tabella()
 end
 
-- codice stato 
 
local s = scambio[stato]
local t = scambio[tempo]

 if s == "attivo" then
 redstone.setOutput(l, true)
 end
 
 if s == "inattivo" then
 redstone.setOutput(l, false)
 end
 
 if s == "temporizzato" then
  redstone.setOutput(l, true)
  sleep(t)
  local s = "inattivo"
  local t = nil
  redstone.setOutput(l, false)
  scambio[stato] = s
  scambio[tempo] = t
  rednet.broadcast("aggiornamento_scambio_"..n.."_"..s)
 end

-- codice sistema
  
while true do
local message = rednet.receive()
local words = {}

for word in string.gmatch(message, "%w+") do words[#words + 1] = word end

 if words[1] == "comando" then
 
  if words[2] == "scambio" then
  
   if tonumber(words[3]) == n then
   
    if words[4] == "attivo" then
	local s = "attivo"
    redstone.setOutput(l, true)
	scambio[stato] = s
    rednet.broadcast("aggiornamento_scambio_"..n.."_"..s)
	salva_tabella(scambio,a)
    end  
	
    if words[4] == "inattivo" then
	local s = "inattivo"
    redstone.setOutput(l, false)
    scambio[stato] = s
    rednet.broadcast("aggiornamento_scambio_"..n.."_"..s)
	salva_tabella(scambio,a)
    end
	
    if words[4] == "temporizzato" then
     if words[5] == nil then
	 local s = "temporizzato"
     local t = h
     redstone.setOutput(l, true)
	 scambio[stato] = s
	 scambio[tempo] = t
     rednet.broadcast("aggiornamento_scambio_"..n.."_"..s.."_predefinito")
	 salva_tabella(scambio,a)
     sleep(t)
	 local s = "inattivo"
	 local t = nil
     redstone.setOutput(l, false)
	 scambio[stato] = s
	 scambio[tempo] = t
     rednet.broadcast("aggiornamento_scambio_"..n.."_"..s)
	 salva_tabella(scambio,a)
     end
	 if words[5] ~= nil then
	 local s = "temporizzato"
     local t = tonumber(words[5])
     redstone.setOutput(l, true)
	 scambio[stato] = s
	 scambio[tempo] = t
     rednet.broadcast("aggiornamento_scambio_"..n.."_"..s.."_"..t)
	 salva_tabella(scambio,a)
     sleep(t)
	 local s = "inattivo"
	 local t = nil
	 scambio[stato] = s
	 scambio[tempo] = t
     redstone.setOutput(l, false)
     rednet.broadcast("aggiornamento_scambio_"..n.."_"..s)
	 salva_tabella(scambio,a)
     end
    end
	
   end
   
  end
  
 end
 
 if words[1] == "sistemi" then
 
  if words[2] == "scambio" then
  
   if tonumber(words[3]) == n then
   
    if words[4] == "spegnimento" then
    rednet.broadcast("spegnimento_scambio_"..n)
    os.shutdown()
    end
    if words[4] == "riavvio" then
    rednet.broadcast("riavvio_scambio_"..n)
    os.reboot()
    end
	
   end
   
  end
  
 end
 
end