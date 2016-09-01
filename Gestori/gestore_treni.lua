-- configurazione sistema

app = "gestore"
cod = "treni"
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

function tabella_posiziona(tabella,indice,elemento)

table.insert(tabella,indice,elemento)

end

function tabella_aggiungi(tabella,elemento)

table.insert(tabella,elemento)

end

function tabella_rimuovi(tabella,elemento)

table.remove(tabella,elemento)

end

function configura_versori(v)

q = nil
g = nil
w = nil
 if v == N.ve then
 q = "esistente"
 g = G.de
 w = N.we
 end
 if v == N.vs then
 q = "esistente"
 g = G.ds
 w = N.ws
 end
 if v == N.vw then
 q = "esistente"
 g = G.dw
 w = N.ww
 end
 if v == N.vn then
 q = "esistente"
 g = G.dn
 w = N.wn
 end
 if v ~= N.ve and v ~= N.vs and v ~= N.vw and v ~= N.vn then
 q = "inesistente"
 end

end

function condizione_linea(v)

 if (v == V.ve) or (v == V.vs) or (v == V.vw) or (v == V.vn) then
 return true
 else
 return false
 end
 
end

function condizione_blocco(k)

 if (k == V.xe) or (k == V.xs) or (k == V.xn) or (k == V.xw) then
 return true
 else
 return false
 end
 
end

function condizione_binario(c)

 if (V.pp <= c and c <= V.up) or (V.pm <= c and c <= V.um) or (V.ps <= c and c <= V.us) then
 return true
 else
 return false
 end
 
end

function determina_orario()

h = os.time()

end

function determina_azione(n)

 if T[n].s.a ~= "convergente" then
  if T[n].r.b == "indefinito" and T[n].r.x ~= "indefinito" then
  T[n].s.a = "convergente"
  T[n].s.r = E[n].ox
  end
 end
 if T[n].s.a ~= "controvergente" then
  if T[n].r.b == "indefinito" and T[n].r.y ~= "indefinito" then
  T[n].s.a = "controvergente"
  T[n].s.r = E[n].ox
  end
 end
 if T[n].s.a ~= "originante" then
  if T[n].r.b ~= "indefinito" and T[n].r.l == "indefinito" then
  T[n].s.a = "originante"
  T[n].s.r = E[n].oy
  end
 end
 if T[n].s.a ~= "divergente" then
  if T[n].r.b ~= "indefinito" and T[n].r.l ~= "indefinito" then
  T[n].s.a = "divergente"
  T[n].s.r = E[n].oy
  end
 end

end
 
function determina_stato(n,h)

local r = T[n].s.r
local d = h - r
T[n].s.d = d
 if T[n].s.o ~= "anticipo" and (-O.fe < d and d < -O.fi) then
 T[n].s.o = "anticipo"
 end
 if T[n].s.o ~= "puntuale" and (-O.fi < d and d < O.fi) then
 T[n].s.o = "puntuale"
 end
 if T[n].s.o ~= "ritardo" and (O.fi < d and d < O.fe) then
 T[n].s.o = "ritardo"
 end
 if T[n].s.o ~= "vincolo" and (O.fe < d or d < -O.fe) then
 T[n].s.o = "escluso"
 end

end

function determina_vincolo(n,h,i)

local r = T[n].r.b
local d = h - r
 if T[n].u.v ~= "blocco" and d > O.fi then
 T[n].u.v = "blocco"
 end
 if T[n].u.v ~= "libero" and d < O.fi then
 T[n].u.v = "libero"
 end
 
end

function iterazione_inizializza(n,h)
 
T[n].i.e = h
T[n].i.r = "sblocco"
T[n].i.c = 0

end

function iterazione_ripetitore(n,h)

local e = T[n].i.e
local d = h - e
 if T[n].i.r ~= "blocco" and d > O.fc then
 T[n].i.r = "blocco"
 end
 if T[n].i.r ~= "sblocco" and d < O.fc then
 T[n].i.r = "sblocco"
 end

end

function iterazione_contatore(n,h)

T[n].i.c = T[n].i.c + 1

end

function compito_iterazione(n,t,v,l,b)

 if T[n].c.t == "indefinito" then
 T[n].c.t = 1
 else
 T[n].c.t = T[n].c.t + 1
 end
 if b ~= "elabora" and T[n].c.t <= O.fd then
 compito_prepara(n,t,v,l,b)
 end
 if b == "elabora" or T[n].c.t > O.fd then
 compito_prepara(n,t,v,l,"elabora")
 end 

end

function compito_annuncia(n,t,v,l,b)

rednet.broadcast({"annuncia",t,v,l,b})
 while true do
 local id, scgrc = rednet.receive()
  if scgrc[1] == t and scgrc[2] == v and scgrc[3] == l and scgrc[4] == T[n].c.b then
  T[n].c.a = scgrc[5]
  break
  end
 end

end

function compito_prepara(n,t,v,l,b)

rednet.broadcast({"prepara",t,v,l,b})
 while true do
 local id, scgrc = rednet.receive()
  if scgrc[1] == t and scgrc[2] == v and scgrc[3] == l then
   if scgrc[5] == "preparato" then
   T[n].c.b = scgrc[4]
   T[n].c.p = scgrc[5]
   break
   end
   if scgrc[5] == "impossibile" or scgrc[5] == "errore" then
   T[n].c.p = scgrc[5]
   break
   end
  end
 end
 
end

function compito_rettifica(n,t,v,l,b)

rednet.broadcast({"annuncia",t,v,l,b})
 while true do
 local id, scgrc = rednet.receive()
  if scgrc[1] == t and scgrc[2] == v and scgrc[3] == l and scgrc[4] == T[n].c.b then
  T[n].c.r = scgrc[5]
  break
  end
 end
 
end

function compito_esegui(n,t,v,l,b)

rednet.broadcast({"esegui",t,v,l,b})
 while true do
 local id, scgrc = rednet.receive()
  if scgrc[1] == t and scgrc[2] == v and scgrc[3] == l then
   if scgrc[5] == "preparato" then
   T[n].c.b = scgrc[4]
   T[n].c.p = scgrc[5]
   break
   end
   if scgrc[5] == "impossibile" or scgrc[5] == "errore" then
   T[n].c.p = scgrc[5]
   break
   end
  end
 end
 
end

function treno_genera(n)

T[n] = {}
T[n].s = {}                     -- stato
T[n].s.o = "indefinito"           -- orario
T[n].s.r = "indefinito"           -- riferimento
T[n].s.d = "indefinito"           -- differenziale
T[n].s.a = "indefinito"           -- azione
T[n].u = {}                     -- ubicazione
T[n].u.p = "indefinito"           -- posizione
T[n].u.i = "indefinito"           -- codice
T[n].u.v = "indefinito"           -- vincolo
T[n].i = {}                     -- iterazione
T[n].i.e = "indefinito"           -- effettuato
T[n].i.r = "indefinito"           -- ripetitore
T[n].i.c = "indefinito"           -- contatore
T[n].c = {}                     -- compito
T[n].c.a = "indefinito"           -- annunciazione
T[n].c.b = "indefinito"           -- binario
T[n].c.p = "indefinito"           -- preparazione
T[n].c.r = "indefinito"           -- rettifica
T[n].c.e = "indefinito"           -- esecuzione
T[n].r = {}                     -- registro
T[n].r.l = "indefinito"           -- linea
T[n].r.x = "indefinito"           -- blocco
T[n].r.y = "indefinito"           -- blocco
T[n].r.b = "indefinito"           -- binario

end

function treno_elimina(n)

tabella_rimuovi(T,n)

end

function treno_ubica(n,p,i)

T[n].u.p = p
T[n].u.i = i

end

function treno_registra(n,h,p)

T[n].s.r = h
T[n].r[p] = h

end

function treno_disponi(n,h,t,v,l,b)

 if T[n].c.p ~= "preparato" then
  if T[n].c.p == "indefinito" then
  iterazione_inizializza(n,h)
  end
  if T[n].i.r == "blocco" then
  iterazione_ripetitore(n,h)
  end
  if T[n].i.r == "sblocco" then
  iterazione_contatore(n,h)
  compito_prepara(n,t,v,l,b)
  end
 end
 if T[n].c.p == "preparato" then
  if T[n].c.e ~= "eseguito" then
  compito_esegui(n,t,v,l,b)
  iterazione_inizializza(n,h)
  treno_elimina(n)  
  treno_genera(n)
  end
 end

end

function treno_compito(n,h,t,v,l,b)

 if T[n].c.p ~= "preparato" then
  if T[n].c.p == "indefinito" then
  iterazione_inizializza(n,h)
  end
  if T[n].i.r == "blocco" then
  iterazione_ripetitore(n,h)
  end
  if T[n].i.r == "sblocco" then
  iterazione_contatore(n,h)
  compito_prepara(n,t,v,l,b)
  end
 end
 if T[n].c.p == "preparato" then
  if T[n].c.r ~= "annunciato" then
  compito_rettifica(n,t,v,l,b)
  end
  if T[n].c.r == "annunciato" then
   if T[n].c.e ~= "eseguito" then
   compito_esegui(n,t,v,l,b)
   end
  end
 end
   
end

function treno_linea(n,h,t,v,l,b)

 if T[n].c.a ~= "annunciato" then
 compito_rettifica(n,t,v,l,E[n].tb)
 end 

end

function treno_blocco(n,h,t,v,l,b)

 if T[n].s.a == "convergente" then
 treno_compito(n,h,t,v,l,b)
 end
 if T[n].s.a == "controvergente" then
 treno_disponi(n,h,t,v,l,b)
 end
 if T[n].s.a == "divergente" then
 treno_elimina(n)
 end
 
end

function treno_binario(n,h,t,v,l,b)

 if T[n].s.o == "anticipo" then
  if T[n].c.a ~= "annunciato" then
  compito_annuncia(n,t,v,l,b)
  end 
 end
 if T[n].s.o == "puntuale" then
 treno_compito(n,h,t,v,l,b)
 end
 if T[n].s.o == "ritardo" then
 treno_compito(n,h,t,v,l,b)
 end

end

function treno_controlla(h)

 for n in pairs(T) do
  if T[n] ~= nil and E[n] ~= nil then
  determina_azione(n)
  determina_stato(n,h)
   if T[n].u.p == "linea" then
   treno_linea(n,E[n].tt,E[n].vx,E[n].tl,E[n].tb)   
   end
   if T[n].u.p == "blocco" then
   treno_blocco(n,E[n].tt,E[n].vx,E[n].tl,E[n].tb)   
   end
   if T[n].u.p == "binario" then
   determina_vincolo(n,h,T[n].u.i)
   treno_binario(n,E[n].tt,E[n].vy,E[n].tl,E[n].tb)	
   end	
  end   
 end
 
end

function treno_rileva(n,h,p,i)

 if i ~= nil then
 
  if p == "linea" then
  cond = condizione_blocco(i)
  end
  if p == "blocco" then
  cond = condizione_blocco(i)
  end
  if p == "binario" then
  cond = condizione_blocco(i)
  end
  
  if cond == true then
  treno_ubica(n,p,i)
  treno_registra(n,h,"k",i)
  end
  
  if cond == false then
  rednet.broadcast({"rilevazione",p,"numero","inesistente"})
  end
  
 end

 if i == nil then
 rednet.broadcast({"rilevazione",p,"numero","indefinito"})
 end
 
end

-- codice sistema

sleep() 
print(app.."_"..cod)
rednet.open(modem)
rednet.host(pro,app.."_"..cod)
rednet.broadcast({"avvio",app,cod})

-- codice inizializzazione

N = sistema_inizializza("settaggi","norme")
O = sistema_inizializza("settaggi","operatori")
P = sistema_inizializza("settaggi","parametri")
G = sistema_inizializza("settaggi","gestioni")
V = sistema_inizializza("settaggi","variabili")
E = sistema_inizializza("dati","elenchi")
T = sistema_inizializza("dati","treni")
R = sistema_inizializza("dati","registri")
C = sistema_inizializza("dati","compiti")

-- codice applicativo

while true do

tabella_salva(T,"dati","treni")

determina_orario()
treno_controlla(h)

id, scgrc = rednet.receive(O.fc)

 if scgrc ~= nil then
    
  if scgrc[1] == "rilevazione" then
  n = scgrc[2]
  p = scgrc[3]
  i = scgrc[4]
 
   if n == nil then
   rednet.broadcast({"rilevazione","treno",v,"numero","sconosciuto"})
   end
  
   if n ~= nil then

    if T[n] == nil then
    treno_genera(n)
	end

    if n == N.cs then
    rednet.broadcast({"rilevazione","treno","numero","speciale"})
    R[n].ts = "speciale"
    else
     if T[n] == nil then
     rednet.broadcast({"rilevazione","treno","numero","sconosciuto"})
     end
	 if T[n] ~= nil then
	 treno_rileva(n,h,p,i)
	 end
    end
    
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
 
end
