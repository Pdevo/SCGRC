-- configurazione sistema

app = "gestore"
cod = "itinerari"
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

function configura_versori(v)

 if v == N.ve then
 return "esistente",G.ge,N.we
 end
 if v == N.vs then
 return "esistente",G.gs,N.ws
 end
 if v == N.vw then
 return "esistente",G.gw,N.ww
 end
 if v == N.vn then
 return "esistente",G.gn,N.wn
 end
 if v ~= N.ve and v ~= N.vs and v ~= N.vw and v ~= N.vn then
 return "inesistente"
 end

end

function configura_blocchi(q,g,v,d)

 if q == "esistente" and g == "ammessa" then
 return v*N.cd+d
 end
 
end

function configura_fermata(v)

 if v == N.ve or v == N.vs then
 return N.bf+1,v*N.cd
 end 
 if v == N.vw or v == N.vn then
 return N.bf+2,v*N.cd
 end
 
end

function verifica_configurazione(i,v,d,c)

rednet.broadcast({"configura",i,v,d,c})
 while true do 
 local id, scgrc = rednet.receive()
  if scgrc[1] == i and scgrc[2] == v and scgrc[3] == d and scgrc[4] == c then 
   if scgrc[5] == "configurato" then
   return true
   end
   if scgrc[5] == "indefinito" or  scgrc[5] == "errore" then
   return false
   end
  end
 end

end

function verifica_condizione(cnd1,cnd2)

 if cnd1 == true and cnd2 == true then
 return true
 end
 if ste1 == false or ste2 == false then
 return false
 end
 
end

function itininerario_configura(v,d,c)

local cnf1 = verifica_configurazione("deviatoi",v,d,c)
local cnf2 = verifica_configurazione("segnali",v,d,c)
local cnfg = verifica_condizione(cnf1,cnf2)
 if cnfg == true then
 rednet.broadcast({"aggiornamento","binario",c,"riservato"})
 end
return cnfg,cnf1,cnf2
 
end

function itininerario_transito(v1,v2,d1,d2,c,k)

local cnc1 = itininerario_configura(v1,d1,c)
local cnc2 = itininerario_configura(v2,d2,k)
local cnct = verifica_condizione(cnc1,cnc2)
return cnct,cnc1,cnc2

end

function itininerario_binario(c)

rednet.broadcast({"stato","binario",c})
 while true do
 local id, scgrc = rednet.receive()
  if scgrc[1] == "binario" then 
   if scgrc[2] == c then
    if scgrc[3] == "libero" then
    return true
    end
    if scgrc[3] == "indefinito" or scgrc[3] == "occupato" or scgrc[3] == "transito" or scgrc[3] == "riservato" or scgrc[3] == "vietato" then
    return false
    end
   end
  end
 end
 
end

function itininerario_elabora(v,b,n)

 for i = 0 , b do
  if v == N.ve or v == N.vs then
  j = 1+i
  end
  if v == N.vw or v == N.vn then
  j = b-i
  end
 local r = i
 local c = j+n
  if itininerario_binario(c) == true then
  return true,r,c
  end
 end

end

function itininerario_prepara(e,t,v,d,l,s,r,c)

 if e == false then
 local cnfg = itininerario_configura(v,d,c)
  if cnfg == true then
  rednet.broadcast({t,v,l,r,"preparato"})
  end
  if cnfg == false then
  rednet.broadcast({t,v,l,s,"eccezione"})
  end
 end 
 if e == true then
 rednet.broadcast({t,v,l,s,"impossibile"})
 end

end

function transito_binario(c,k)

local ste1 = itininerario_binario(c)
local ste2 = itininerario_binario(k)
return ste1,ste2

end

function transito_elabora(v,b,n,k)

local ste1 = itininerario_elabora(v,b,n)
local ste2 = itininerario_binario(k)
return ste1,ste2

end

function transito_prepara(v1,v2,d1,d2,l,s,r,c,k,ste1,ste2)

local step = verifica_condizione(ste1,ste2)
 if step == true then
 local cnct,cnc1,cnc2 = itininerario_transito(v1,v2,d1,d2,c,k)
  if cnct == true then
  rednet.broadcast({"transito",v1,v2,l,r,"preparato"})
  end
  if cnct == false then
   if cnc1 == false then
   rednet.broadcast({"transito",v1,v2,l,s,"imprevisto","binario"})
   end
   if cnc2 == false then
   rednet.broadcast({"transito",v1,v2,l,s,"imprevisto","linea"})
   end  
  rednet.broadcast({"transito",v1,v2,l,s,"eccezione"})
  end
 end
 if step == false then
  if ste1 == false then
  rednet.broadcast({"transito",v1,v2,l,s,"blocco_binario"})
  end
  if ste2 == false then
  rednet.broadcast({"transito",v1,v2,l,s,"blocco_linea"})
  end  
 rednet.broadcast({"transito",v1,v2,l,s,"impossibile"})
 end
 
end

function transito_verifica(v,l,f,b,n,vrfy)

 if vrfy == nil then
  if f == "ammessa" then
  rednet.broadcast({"transito","eccezionale",l,f})
  local e,r,c = itininerario_elabora(v,b,n)
   if e == true then
   rednet.broadcast({"transito","eccezionale",l,"possibile"})
   return e,l,r,c
   end  
   if e == false then
   rednet.broadcast({"transito","eccezionale",l,"impossibile"})  
   return e,nil,r,c
   end
  end
  if f == "vietata" then
  rednet.broadcast({"transito","eccezionale",l,f})
  end
 end
  
end

function transito_dedicato(v1,v2,d1,d2,l,b,s,r,k,n,y)

 if b == 0 then
 rednet.broadcast({"transito","funzione",l,"inesistente"})
 end 
 if b ~= 0 then
  if s == nil then
  rednet.broadcast({"transito",v1,v2,l,"indefinito"})
  end	  
  if s == "elabora" then  
  local ste1,ste2 = transito_elabora(v1,b,n,k)
  transito_prepara(v1,v2,d1,d2,l,s,r,c,k,ste1,ste2)
  end
  if r ~= nil then
  local c = r+n
   if c > y then
   rednet.broadcast({"transito",v1,v2,l,"binario","inesistente"})
   end
   if c <= y then
   local ste1,ste2 = transito_binario(c,k)
   transito_prepara(v1,v2,d1,d2,l,s,r,c,k,ste1,ste2)
   end
  end
 end
 
end

function transito_eccezionale(v1,v2,d1,d2,l,f,s,r,k)

 if f == "vietata" then
 rednet.broadcast({"transito","funzione","eccezionale",f})
 end 
 if f == "ammessa" then
  if s == nil then
  rednet.broadcast({"transito",v1,v2,"eccezionale","binario","indefinito"})
  end
  if s == "elabora" then	
  local vrfy = nil	
  local ste1,vrfy = transito_verifica(v,"passeggeri",G.tp,P.bp,N.bp,vrfy)
  local ste1,vrfy = transito_verifica(v,"merci",G.tm,P.bm,N.bm,vrfy) 
  local ste1,vrfy = transito_verifica(v,"servizi",G.ts,V.bs,N.bs,vrfy)
  local ste2 = itininerario_binario(k)
  transito_prepara(v1,v2,d1,d2,l,s,er,ec,k,ste1,ste2)
  end
  if r ~= nil then
  local c = r
   if r > P.ls then
   rednet.broadcast({"transito",v1,v2,"eccezionale",r,"limite","sistemi"})
   end
   if r <= P.ls then
   local ste1,ste2 = transito_binario(c,k)
   transito_prepara(v1,v2,d1,d2,l,s,r,c,k,ste1,ste2)
   end
  end 
 end

end

function prepara_arrivo(v,d,l,b,s,r,k,n,y)

 if b == 0 then
 rednet.broadcast({"arrivo","funzione",l,"inesistente"})
 end
 if b ~= 0 then
  if s == nil then
  rednet.broadcast({"arrivo",v,l,"binario","indefinito"})
  end  
  if s == "elabora" then 
  local e,r,c = itininerario_elabora(v,b,n)
  itininerario_prepara(e,"arrivo",v,d,l,s,r,c)
  end
  if s ~= nil and s ~= "elabora" then 
   if r ~= nil then
   local c = r+n
    if c > y then
    rednet.broadcast({"arrivo",v,l,"binario","inesistente"})
    end
    if c <= y then
    local e,r,c = itininerario_binario(c)
    itininerario_prepara(e,"arrivo",v,d,l,s,r,c)
	end
   end  
  end
 end   
 
end

function prepara_partenza(v,d,l,b,s,r,k,n,y)

 if b == 0 then
 rednet.broadcast({"partenza","funzione",l,"inesistente"})
 end
 if b ~= 0 then
  if s == nil then	
  rednet.broadcast({"partenza",v,l,"binario","indefinito"})
  end	  
  if r ~= nil then
  local c = r+n
   if c > y then
   rednet.broadcast({"partenza",v,l,"binario","inesistente"})
   end    
   if c <= y then
   local e,r,c = itininerario_binario(k)
   itininerario_prepara(e,"partenza",v,d,l,s,r,c)
   end
  end
 end
 
end

function prepara_eccezionale(t,v,d,b,s,r,c,k)
    
 if s == nil then
 rednet.broadcast({t,v,"eccezionale","binario","indefinito"})
 end
 if s ~= nil then
 local c = r
  if r > P.ls then
  rednet.broadcast({t,v,"eccezionale","limite","sistemi"})
  end
  if r <= P.ls then
   if (V.xp <= r and r <= V.yp) or (V.xm <= r and r <= V.ym) or (V.xs <= r and r <= V.ys) then
   local e,r,c = itininerario_binario(k)
   itininerario_prepara(e,t,v,d,"eccezionale",s,r,c)
   else
   rednet.broadcast({t,v,"eccezionale","binario","inesistente"})
   end
  end
 end
 
end

function prepara_fermata(v,w,dx,dy,l,f,s,c,k)

 if f == "vietata" then
 rednet.broadcast({"fermata","funzione",l,f})
 end
 if f == "ammessa" then
  if s == "arrivo" then	  
  local e,r,c = itininerario_binario(c)	  
  itininerario_prepara(e,"fermata",v,dx,l,s,c,c)
  end
  if s == "partenza" then	  
  local e,r,c = itininerario_binario(k)	  
  itininerario_prepara(e,"fermata",w,dy,l,s,c,c)
  end
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
P = sistema_inizializza("settaggi","parametri")
G = sistema_inizializza("settaggi","gestioni")
V = sistema_inizializza("settaggi","variabili")

-- codice applicativo
 
while true do
local id, scgrc = rednet.receive()
 
 if scgrc[1] == "prepara" then
 
  if scgrc[2] == "arrivo" then
  
  local t = scgrc[2]
  local v = scgrc[3]
  local l = scgrc[4]
  local s = scgrc[5]
  local r = tonumber(scgrc[5])

  local q,g,w = configura_versori(v)
  local k = configura_blocchi(q,g,v,V.dx)
   
   if q == "esistente" and g == "ammessa" then
    if l == "passeggeri" then
    prepara_arrivo(v,V.dx,l,P.bp,s,r,k,N.bp,V.yp)
    end
    if l == "merci" then
    prepara_arrivo(v,V.dx,l,P.bm,s,r,k,N.bm,V.ym)
    end
    if l == "servizi" then
    prepara_arrivo(v,V.dx,l,P.bs,s,r,k,N.bs,V.ys)
    end
    if l == "eccezionale" then
	prepara_eccezionale(t,v,V.dx,l,s,r,c,k)
    end
   end
   
   if q == "esistente" and g == "vietata"  then
   rednet.broadcast({"arrivo",v,"cardinalita'",g})
   end
   if q == "inesistente" then
   rednet.broadcast({"arrivo",v,"cardinalita'",q})
   end
   if v == nil then
   rednet.broadcast({"arrivo","cardinalita'","indefinita"})
   end
 
  end
 
  if scgrc[2] == "partenza" then  
  
  local t = scgrc[2]
  local v = scgrc[3]
  local l = scgrc[4]
  local s = scgrc[5]
  local r = tonumber(scgrc[5])

  local q,g,w = configura_versori(v)
  local k = configura_blocchi(q,g,v,V.dy)
	
   if q == "esistente" and g == "ammessa" then
    if l == "passeggeri" then
	prepara_partenza(v,V.dy,l,P.bp,s,r,k,N.bp,V.yp)
    end
    if l == "merci" then
	prepara_partenza(v,V.dy,l,P.bm,s,r,k,N.bm,V.ym)
    end
    if l == "servizi" then
	prepara_partenza(v,V.dy,l,P.bs,s,r,k,N.bs,V.ys)
    end
    if l == "eccezionale" then
	prepara_eccezionale(t,v,V.dy,l,s,r,c,k)
    end
   end
   
   if q == "esistente" and g == "vietata" then
   rednet.broadcast({"partenza",v,"cardinalita'",g})
   end
   if q == "inesistente" then
   rednet.broadcast({"partenza",v,"cardinalita'",q})
   end
   if v == nil then
   rednet.broadcast({"partenza","cardinalita'","indefinita"})
   end
 
  end
 
  if scgrc[2] == "fermata" then
  
  local t = scgrc[2]
  local v = scgrc[3]
  local l = scgrc[4]
  local s = scgrc[5]

  local q,g,w = configura_versori(v)
  local cp,cl = configura_fermata(v)
  local k = configura_blocchi(q,g,v,V.dy)

   if q == "esistente" and g == "ammessa" then
    if l == "parallela" then
	prepara_fermata(v,w,V.dx,V.dy,l,G.fp,s,cp,k)
    end
	if l == "lineare" then 
	prepara_fermata(v,w,V.dx,V.dy,l,G.fl,s,cl,k)
    end
   end
	
   if q == "esistente" and g == "vietata" then
   rednet.broadcast({"fermata",v,"cardinalita'",g})
   end
   if q == "inesistente" then
   rednet.broadcast({"fermata",v,"cardinalita'",q})
   end
   if v == nil then
   rednet.broadcast({"fermata","cardinalita'","indefinita"})
   end
 
  end
 
  if scgrc[2] == "transito" then
  
  local t = scgrc[2]
  local v1 = scgrc[3]
  local v2 = scgrc[4]
  local l = scgrc[5]
  local s = scgrc[6]
  local r = tonumber(scgrc[6])  
  
  local d1,d2 = V.dx,V.dy
  local q1,g1,w1 = configura_versori(v1)
  local q2,g2,w2 = configura_versori(v2)
  local k = configura_blocchi(q,g,v,V.dy)

   if q1 == "esistente" and q2 == "esistente" then
   q = "esistente"
   end
   if q1 == "inesistente" or q2 == "inesistente" then
   q = "inesistente"
   end  
   if g1 == "ammessa" and g2 == "ammessa" then
   g = "ammessa"
   end 
   if g1 == "vietata" or g2 == "vietata" then
   g = "vietata"
   end 
   
   if q == "esistente" and g == "ammessa" then
    if l == "dedicato" then
	transito_dedicato(v1,v2,d1,d2,l,P.bt,s,r,k,N.bt,V.yt)
    end	 
    if l == "eccezionale" then	 
    transito_eccezionale(v1,v2,d1,d2,l,G.te,s,r,k)
    end
   end   

   if q == "esistente" and g == "vietata" then
   rednet.broadcast({"transito",v1,v2,"cardinalita'",g})
   end
   if q == "inesistente" then
   rednet.broadcast({"transito",v1,v2,"cardinalita'",q})
   end  
   if (v1 == nil and v2 ~= nil) or (v2 == nil and v1 ~= nil) then
   rednet.broadcast({"transito","cardinalita'","incompleta"})
   end
   if v1 == nil and v2 == nil then
   rednet.broadcast({"transito","cardinalita'","indefinita"})
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
