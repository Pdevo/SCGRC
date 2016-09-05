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
B = {}
D = {}

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
-- direttrice est
P.de = 2
-- direttrice sud
P.ds = 2
-- direttrice ovest
P.dw = 2
-- direttrice nord
P.dn = 2

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

-- binari

-- binari passeggeri
if P.bp == 0 then
B.passeggeri = nil
end
if P.bp > 0 then
B.passeggeri = {}
B.passeggeri.vn,B.passeggeri.vp,B.passeggeri.bx,B.passeggeri.by = N.bp,P.bp,N.bp+1,N.bp+P.bp
end
-- binari merci
if P.bm == 0 then
B.merci = nil
end
if P.bm > 0 then
B.merci = {}
B.merci.vn,B.merci.vp,B.merci.bx,B.merci.by = N.bm,P.bm,N.bm+1,N.bm+P.bm
end
-- binari servizi
if P.bs == 0 then
B.servizi = nil
end
if P.bs > 0 then
B.servizi = {}
B.servizi.vn,B.servizi.vp,B.servizi.bx,B.servizi.by = N.bs,P.bs,N.bs+1,N.bs+P.bs
end
-- binari fermata
if P.bf == 0 then
B.fermata = nil
end
if P.bf > 0 then
B.fermata = {}
B.fermata.vn,B.fermata.vp,B.fermata.bx,B.fermata.by = N.bf,P.bf,N.bf+1,N.bf+P.bf
end
-- binari transito
if P.bt == 0 then
B.transito = nil
end
if P.bt > 0 then
B.transito = {}
B.transito.vn,B.transito.vp,B.transito.bx,B.transito.by = N.bt,P.bt,N.bt+1,N.bt+P.bt
end

-- direttrici

-- direttrice est
if P.de == 0 then
D.est = nil
end
if P.de == 1 then
D.est = {}
D.est.vg,D.est.lv,D.est.lw,D.est.kx,D.est.ky = G.de,N.de,N.dw,N.de*N.cd+N.cz,N.de*N.cd+N.cz
end
if P.de == 2 then
D.est = {}
D.est.vg,D.est.lv,D.est.lw,D.est.kx,D.est.ky = G.de,N.de,N.dw,N.de*N.cd+N.cx,N.de*N.cd+N.cy
end
-- direttrice sud
if P.ds == 0 then
D.sud = nil
end
if P.ds == 2 then
D.sud = {}
D.sud.vg,D.sud.lv,D.sud.lw,D.sud.kx,D.sud.ky = G.ds,N.ds,N.dn,N.ds*N.cd+N.cz,N.ds*N.cd+N.cz
end
if P.ds == 2 then
D.sud = {}
D.sud.vg,D.sud.lv,D.sud.lw,D.sud.kx,D.sud.ky = G.ds,N.ds,N.dn,N.ds*N.cd+N.cx,N.ds*N.cd+N.cy
end
-- direttrice ovest
if P.dw == 0 then
D.ovest = nil
end
if P.dw == 1  then
D.ovest = {}
D.ovest.vg,D.ovest.lv,D.ovest.lw,D.ovest.kx,D.ovest.ky = G.dw,N.dw,N.de,N.dw*N.cd+N.cz,N.dw*N.cd+N.cz
end
if P.dw == 2  then
D.ovest = {}
D.ovest.vg,D.ovest.lv,D.ovest.lw,D.ovest.kx,D.ovest.ky = G.dw,N.dw,N.de,N.dw*N.cd+N.cx,N.dw*N.cd+N.cy
end
-- direttrice nord
if P.dn == 0 then
D.nord = nil
end
if P.dn == 1 then
D.nord = {}
D.nord.vg,D.nord.lv,D.nord.lw,D.nord.kx,D.nord.ky = G.dn,N.dn,N.ds,N.dn*N.cd+N.cz,N.dn*N.cd+N.cz
end
if P.dn == 2 then
D.nord = {}
D.nord.vg,D.nord.lv,D.nord.lw,D.nord.kx,D.nord.ky = G.dn,N.dn,N.ds,N.dn*N.cd+N.cx,N.dn*N.cd+N.cy
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
    sistema_configura(B,"settaggi","binari")
	sistema_configura(D,"settaggi","direttrici")
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