-- configurazione sistema

app = "gestore"
cod = "stati"
pro = "scgrc"

-- configurazione periferiche

modem = nil
 for n,l in pairs(peripheral.getNames()) do
  if peripheral.getType(l) == "modem" then
  modem = l
  break
  end
 end

drive = nil 
 for n,l in pairs(peripheral.getNames()) do
  if peripheral.getType(l) == "drive" then
  drive = l
  break
  end
 end
 
-- funzioni sistema

function sistema_inizializza(tipo,nome)

local path = disk.getMountPath(drive)
local file = fs.open(path.."/"..tipo.."/"..nome,"r")
local text = file.readAll()
local data = textutils.unserialize(text)
file.close()
return data

end

-- funzioni applicativo

function tabella_salva(tabella,tipo,nome)

local path = disk.getMountPath(drive)
local file = fs.open(path.."/"..tipo.."/"..nome,"w")
local text = textutils.serialize(tabella)
file.write(text)
file.close()

end

function tabella_carica(tipo,nome)

local path = disk.getMountPath(drive)
local file = fs.open(path.."/"..tipo.."/"..nome,"r")
local text = file.readAll()
local data = textutils.unserialize(text)
file.close()
return data

end

function tabella_posiziona(tabella,indice)

table.insert(tabella,indice,posizione)

end

function tabella_aggiungi(tabella,elemento)

table.insert(tabella,elemento)

end

function tabella_rimuovi(tabella,elemento)

table.remove(tabella,elemento)

end
 
-- codice sistema

sleep() 
print(app.."_"..cod)
rednet.open(modem)
rednet.host(pro,app.."_"..cod)
rednet.broadcast({"avvio",app,cod})

-- codice tabella

S = tabella_carica("dati","stati")

-- codice applicativo
 
while true do
local id, scgrc = rednet.receive()

 if scgrc[1] == "stato" then
 
 local d = scgrc[2]
 local n = scgrc[3]
 
  if S[d] ~= nil then
   if S[d][n] ~= nil then
   rednet.broadcast({d,n,s[d][n]})
   end
   if S[d][n] == nil then
   rednet.broadcast({d,n,"indefinito"})
   end
  end
  if S[d] == nil then
  rednet.broadcast({d,"dispositivo","indefinito"})
  end
  
 end

 if scgrc[1] == "aggiornamento" then
 
 local d = scgrc[2]
 local n = scgrc[3]
 local s = scgrc[4]
 
  if S[d] ~= nil then
  S[d][n] = s
  tabella_salva(S,"dati","stati")
  end
  if S[d] == nil then
  S[d] = {}
  S[d][n] = s
  tabella_salva(S,"dati","stati")
  end
 
 end

 if scgrc[1] == "sistemi" then

  if scgrc[2] == app then

   if scgrc[3] == cod then

    if scgrc[4] == "spegnimento" then
    rednet.broadcast({"spegnimento",app,cod})
    os.shutdown()
	end
	if scgrc[4] == "riavvio" then
    rednet.broadcast({"riavvio",app,cod})
    os.reboot()
    end

   end

  end

 end

end