-- configurazione sistema

app = "gestore"
cod = "sistemi"
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

-- inizializzazione settaggi

N = {}
O = {}
P = {}
G = {}
V = {}

-- norme

-- limite sistemi
N.ls = 10000
-- codice speciale
N.cs = 0000
-- codice direttrice
N.cd = 1000
-- direttrice est
N.de = 1
-- direttrice sud
N.ds = 2
-- direttrice ovest
N.dw = 3
-- direttrice nord
N.dn = 4
-- circolazione positiva
N.cx = 1
-- circolazione negativa
N.cy = 2
-- circolazione neutra
N.cz = 3
-- binari passeggeri
N.bp = 100
-- binari merci
N.bm = 200
-- binari servizi
N.bs = 300
-- binari fermata
N.bf = 500
-- binari transito
N.bt = 600

-- operatori

-- fattore inclusione
O.fi = 1/3
-- fattore esclusione
O.fe = 5/3
-- fattore determinazione
O.fl = 5
-- fattore ciclico
O.fc = 5
-- fattore attivazione
O.fa = 10
-- fattore limite
O.fl = 15
-- fattore reiterazione
O.fr = 25
-- fattore sequenziale
O.fs = 1/5
-- fattore gerarchico
O.fg = 1/10

-- parametri

-- binari passeggeri
P.bp = 10
-- binari merci
P.bm = 10
-- binari servizi
P.bs = 10
-- binari fermata
P.bf = 10
-- binari transito
P.bt = 10

-- gestioni

-- circolazione binata
G.cb = "ammessa"
-- circolazione deviatoi
G.cd = "ammessa"
-- circolazione segnali
G.cs = "ammessa"
-- direttrice est
G.de = "ammessa"
-- direttrice sud
G.ds = "ammessa"
-- direttrice ovest
G.dw = "ammessa"
-- direttrice nord
G.dn = "ammessa"
-- fermata parallela
G.fp = "ammessa"
-- fermata lineare
G.fl = "ammessa" 
-- transito dedicato
G.td = "ammessa"
-- transito eccezionale
G.te = "ammessa"
-- transito passeggeri
G.tp = "ammessa"
-- transito merci
G.tm = "ammessa"
-- transito servizi
G.ts = "ammessa"

-- variabili

-- binari passeggeri
if P.bp > 0 then
V.pp,V.up = N.bp+1,N.bp+P.bp
end
if P.bp = 0 then
V.pp,V.up = nil,nil
end
-- binari merci
if P.bm > 0 then
V.pm,V.um = N.bm+1,N.bm+P.bm
end
if P.bm = 0 then
V.pm,V.um = nil,nil
end
-- binari servizi
if P.bm > 0 then
V.ps,V.us = N.bs+1,N.bs+P.bs
end
if P.bm = 0 then
V.ps,V.us = nil,nil
end
-- binari fermata
if P.bm > 0 then
V.pf,V.uf = N.bf+1,N.bf+P.bf
end
if P.bm = 0 then
V.pf,V.uf = nil,nil
end
-- binari transito
if P.bt > 0 then
V.pt,V.ut = N.bt+1,N.bt+P.bt
end
if P.bt = 0 then
V.pt,V.ut = nil,nil
end
-- circolazione binata
if G.cb == "ammessa" then
V.dx,V.dy = N.cx,N.cy
end
if G.cb == "vietata" then
V.dx,V.dy = N.cz,N.cz
end
-- linea est
if G.de == "ammessa" then
V.ve,V.we = N.de,N.dw
end
if G.de == "vietata" then
V.ve,V.we = nil,nil
end
-- linea sud
if G.ds == "ammessa" then
V.vs,V.ws = N.ds,N.dn
end
if G.de == "vietata" then
V.vs,V.ws = nil,nil
end
-- linea ovest
if G.dw == "ammessa" then
V.vw,V.ww = N.dw,N.de
end
if G.dw == "vietata" then
V.vw,V.ww = nil,nil
end
-- linea nord
if G.dn == "ammessa" then
V.vn,V.wn = N.dn,N.ds
end
if G.dn == "vietata" then
V.vn,V.wn = nil,nil
end
-- blocco est
if G.de == "ammessa" then
V.xe,V.ye = N.de*N.cd+V.dx,N.de*N.cd+V.dy
end
if G.de == "vietata" then
V.xe,V.ye = nil,nil
end
-- blocco sud
if G.ds == "ammessa" then
V.xs,V.ys = N.ds*N.cd+V.dx,N.ds*N.cd+V.dy
end
if G.ds == "vietata" then
V.xs,V.ys = nil,nil
end
-- blocco ovest
if G.dw == "ammessa" then
V.xw,V.yw = N.dw*N.cd+V.dx,N.dw*N.cd+V.dy
end
if G.dw == "vietata" then
V.xw,V.yw = nil,nil
end
-- blocco nord
if G.dn == "ammessa" then
V.xn,V.yn = N.dn*N.cd+V.dx,N.dn*N.cd+V.dy
end
if G.dn == "vietata" then
V.xn,V.yn = nil,nil
end

-- inizializzazione dati

I = {}
E = {}
S = {}
T = {}
R = {}
C = {}
M = {}

-- itinerari

-- elenchi

E[2020] = {tt = "tratta",tl = "passeggeri",tc = "intercity",tb = 1,vx = 1,vy = 3,ox = 12.00,oy = 12.15,lx = "venezia",ly = "milano",lm = "verona"}
E[4040] = {tt = "tratta",tl = "passeggeri",tc = "frecciabianca",tb = 2,vx = 1,vy = 3,ox = 13.30,oy = 13.45,lx = "venezia",ly = "firenze",lm = "verona"}

-- stati

-- treni

-- registri

-- compiti

-- media


-- funzioni sistema

function sistema_struttura(tipo)

local path = disk.getMountPath(drive)
fs.makeDir(path.."/"..tipo)

end

function sistema_configura(tabella,tipo,nome)

local path = disk.getMountPath(drive)
local file = fs.open(path.."/"..tipo.."/"..nome,"w")
local text = textutils.serialize(tabella)
file.write(text)
file.close()

end

-- codice sistema

sleep() 
print(app.."_"..cod)
rednet.open(modem)
rednet.host(pro,app.."_"..cod)
rednet.broadcast({"avvio",app,cod})

while true do
local id, scgrc = rednet.receive()

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
    if scgrc[4] == "configura" then
    rednet.broadcast({"configura",app,cod})
	sistema_configura(N,"settaggi","norme")
    sistema_configura(O,"settaggi","operatori")
    sistema_configura(P,"settaggi","parametri")
    sistema_configura(G,"settaggi","gestioni")
    sistema_configura(V,"settaggi","variabili")
    sistema_configura(I,"dati","itinerari")
	sistema_configura(E,"dati","elenchi")
    sistema_configura(S,"dati","stati")
    sistema_configura(T,"dati","treni")
    sistema_configura(R,"dati","registri")
	sistema_configura(C,"dati","compiti")
    sistema_configura(M,"dati","media")
    end
	
   end
   
  end
  
 end
 
end