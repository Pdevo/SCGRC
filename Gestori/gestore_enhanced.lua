-- configurazione sistema

app = "gestore"
cod = "itinerari"
pro = "scgrc"

-- configurazione periferiche

modem = nil
 for n,g in pairs(peripheral.getNames()) do
  if peripheral.getType(g) == "modem" then
  modem = g
  break
  end
 end

drive = nil 
 for n,g in pairs(peripheral.getNames()) do
  if peripheral.getType(g) == "drive" then
  drive = g
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

function configura_fermata(v)

cp,cl = nil,nil
 if v == N.ve or v == N.vs then
 cp = N.bf+1
 cl = v*N.cd
 end 
 if v == N.vw or v == N.vn then
 cp = N.bf+2
 cl = v*N.cd
 end
 
end

function itininerario_configura(d,l,c)

cnfg = nil
cnf1 = nil
cnf2 = nil 
rednet.broadcast({"configura","itinerario",d,l,c})
 while true do 
 local id, scgrc = rednet.receive()
  if scgrc[1] == "itinerario" and scgrc[2] == d and scgrc[3] == l and scgrc[4] == c then 
   if scgrc[5] == "deviatoi" then
    if scgrc[6] == "configurato" then
	cnf1 = true
    end
	if scgrc[6] == "indefinito" or  scgrc[6] == "errore" then
	cnf1 = false
	end
   end
   if scgrc[5] == "segnali" then
    if scgrc[6] == "configurato" then
	cnf2 = true
    end
	if scgrc[6] == "indefinito" or  scgrc[6] == "errore" then
	cnf2 = false
	end
   end
  end
  if cnf1 ~= nil and cnf2 ~= nil then 
   if cnf1 == true and cnf2 == true then
   cnfg = true
   rednet.broadcast({"aggiornamento","binario",c,"riservato"})
   break
   end
   if cnf1 == false and cnf2 == false then
   cnfg = false
   break
   end
  end
 end
 
end

function itininerario_transito(d1,d2,l1,l2,c,k)

cnct = nil
cnc1 = nil
cnc2 = nil
itininerario_configura(d1,l1,c)
 if cnfg == true then
 cnc1 = true
 end
 if cnfg == false then
 cnc1 = false
 end
itininerario_configura(d2,l2,k)
 if cnfg == true then
 cnc2 = true
 end
 if cnfg == false then
 cnc2 = false
 end
 if cnc1 ~= nil and cnc2 ~= nil then 
  if cnc1 == true and cnc2 == true then
  cnct = true
  end
  if cnc1 == false or cnc2 == false then
  cnct = false
  end
 end
 
end

function itininerario_binario(c)

erro = nil
rednet.broadcast({"stato","binario",c})
 while true do
 local id, scgrc = rednet.receive()
  if scgrc[1] == "binario" then 
   if scgrc[2] == c then
    if scgrc[3] == "libero" then
    erro = false
	break
    end
    if scgrc[3] == "indefinito" or scgrc[3] == "occupato" or scgrc[3] == "transito" or scgrc[3] == "riservato" or scgrc[3] == "vietato" then
    erro = true
	break
    end
   end
  end
 end
 
end

function itininerario_elabora(d,b,n)

erro = nil
 for p = 0 , b do
  if d == N.ve or d == N.vs then
  j = 1+p
  end
  if d == N.vw or d == N.vn then
  j = b-p
  end
 r = p
 c = j+n
 itininerario_binario(c)
  if erro == false then
  break
  end
 end

end

function itininerario_prepara(t,d,l,g,s,r,c,erro)

 if erro == false then
 itininerario_configura(d,l,c)
  if cnfg == true then
  rednet.broadcast({t,d,g,r,"preparato"})
  end
  if cnfg == false then
  rednet.broadcast({t,d,g,s,"eccezione"})
  end
 end 
 if erro == true then
 rednet.broadcast({t,d,g,s,"impossibile"})
 end

end

function transito_binario(c,k)

ste1 = nil
ste2 = nil
itininerario_binario(c)
ste1 = erro
itininerario_binario(k)
ste2 = erro

end

function transito_elabora(d,b,n,k)

ste1 = nil
ste2 = nil
itininerario_elabora(d,b,n)
ste1 = erro
itininerario_binario(k)
ste2 = erro

end

function transito_prepara(d1,d2,l1,l2,g,s,r,c,k,ste1,ste2)

step = nil
 if ste1 == false and ste2 == false then
 step = false
 end
 if ste1 == true or ste2 == true then
 step = true
 end
 if step == false then
 itininerario_transito(d1,d2,l1,l2,c,k)
  if cnct == true then
  rednet.broadcast({"transito",d1,d2,g,r,"preparato"})
  end
  if cnct == false then
   if cnc1 == false then
   rednet.broadcast({"transito",d1,d2,g,s,"imprevisto","binario"})
   end
   if cnc2 == false then
   rednet.broadcast({"transito",d1,d2,g,s,"imprevisto","linea"})
   end  
  rednet.broadcast({"transito",d1,d2,g,s,"eccezione"})
  end
 end
 if step == true then
  if ste1 == true then
  rednet.broadcast({"transito",d1,d2,g,s,"blocco_binario"})
  end
  if ste2 == true then
  rednet.broadcast({"transito",d1,d2,g,s,"blocco_linea"})
  end  
 rednet.broadcast({"transito",d1,d2,g,s,"impossibile"})
 end
 
end

function transito_verifica(d,g,f,b,n)

 if f == "ammessa" then
 rednet.broadcast({"transito","eccezionale",g,f})
 itininerario_elabora(d,b,n)
 er = r
 ec = c
  if erro == true then
  rednet.broadcast({"transito","eccezionale",g,"impossibile"})  
  vrfy = nil
  end
  if erro == false then
  rednet.broadcast({"transito","eccezionale",g,"possibile"})
  vrfy = g
  end  
 end
 if f == "vietata" then
 rednet.broadcast({"transito","eccezionale",g,f})
 end
 r = nil
 c = nil

end

function transito_dedicato(d1,d2,l1,l2,g,b,s,r,k,n,u)

 if b == 0 then
 rednet.broadcast({"transito","funzione",g,"inesistente"})
 end 
 if b ~= 0 then
  if s == nil then
  rednet.broadcast({"transito",d1,d2,g,"indefinito"})
  end	  
  if s == "elabora" then  
  transito_elabora(d1,b,n,k)
  transito_prepara(d1,d2,l1,l2,g,s,r,c,k,ste1,ste2)
  g = nil
  end
  if r ~= nil then
  local c = r+n
   if c > u then
   rednet.broadcast({"transito",d1,d2,g,"binario","inesistente"})
   end
   if c <= u then
   transito_binario(c,k)
   transito_prepara(d1,d2,l1,l2,g,s,r,c,k,ste1,ste2)
   end
  end
 end
 
end

function transito_eccezionale(d1,d2,l1,l2,g,f,s,r,k)

 if f == "vietata" then
 rednet.broadcast({"transito","funzione","eccezionale",f})
 end 
 if f == "ammessa" then
  if s == nil then
  rednet.broadcast({"transito",d1,d2,"eccezionale","binario","indefinito"})
  end
  if s == "elabora" then	
  vrfy = nil	
   if vrfy == nil then
   g = "passeggeri"
   transito_verifica(d,g,G.tp,P.bp,N.bp)
   ste1 = erro
   end
   if vrfy == nil then
   g = "merci"
   transito_verifica(d,g,G.tm,P.bm,N.bm)
   ste1 = erro
   end
   if vrfy == nil then
   g = "servizi"		 
   transito_verifica(d,g,G.ts,V.bs,N.bs)
   ste1 = erro
   end
  itininerario_binario(k)
  ste2 = erro
  transito_prepara(d1,d2,l1,l2,g,s,er,ec,k,ste1,ste2)
  end
  if r ~= nil then
  local c = r
   if r > N.ls then
   rednet.broadcast({"transito",d1,d2,"eccezionale",r,"limite","sistemi"})
   end
   if r <= N.ls then
   transito_binario(c,k)
   transito_prepara(d1,d2,l1,l2,g,s,r,c,k,ste1,ste2)
   end
  end 
 end

end

function prepara_arrivo(d,l,g,b,s,r,k,n,u)

 if b == 0 then
 rednet.broadcast({"arrivo","funzione",g,"inesistente"})
 end
 if b ~= 0 then
  if s == nil then
  rednet.broadcast({"arrivo",d,g,"binario","indefinito"})
  end  
  if s == "elabora" then 
  itininerario_elabora(d,b,n)
  itininerario_prepara("arrivo",d,l,g,s,r,c,erro)
  end
  if s ~= nil and s ~= "elabora" then 
   if r ~= nil then
   local c = r+n
    if c > u then
    rednet.broadcast({"arrivo",d,g,"binario","inesistente"})
    end
    if c <= u then
    itininerario_binario(c)
    itininerario_prepara("arrivo",d,l,g,s,r,c,erro)
    end  
   end
  end
 end   
 
end

function prepara_partenza(d,l,g,b,s,r,k,n,u)

 if b == 0 then
 rednet.broadcast({"partenza","funzione",g,"inesistente"})
 end
 if b ~= 0 then
  if s == nil then	
  rednet.broadcast({"partenza",d,g,"binario","indefinito"})
  end	  
  if r ~= nil then
  local c = r+n
   if c > u then
   rednet.broadcast({"partenza",d,g,"binario","inesistente"})
   end    
   if c <= u then
   itininerario_binario(k)
   itininerario_prepara("partenza",d,l,g,s,r,c,erro)
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
  if c > N.ls then
  rednet.broadcast({t,v,"eccezionale","limite","sistemi"})
  end
  if c <= N.ls then
   if (V.pp <= c and c <= V.up) or (V.pm <= c and c <= V.um) or (V.ps <= c and c <= V.us) then
   itininerario_binario(k)
   itininerario_prepara(t,v,d,"eccezionale",s,r,c,erro)
   else
   rednet.broadcast({t,v,"eccezionale","binario","inesistente"})
   end
  end
 end
 
end

function prepara_fermata(v,w,dx,dy,g,f,s,c,k)

 if f == "vietata" then
 rednet.broadcast({"fermata","funzione",g,f})
 end
 if f == "ammessa" then
  if s == "arrivo" then	  
  itininerario_binario(c)	  
  itininerario_prepara("fermata",v,dx,g,s,c,c,erro)
  end
  if s == "partenza" then	  
  itininerario_binario(k)	  
  itininerario_prepara("fermata",w,dy,g,s,c,c,erro)
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
V = sistema_inizializza("settaggi","binari")
D = sistema_inizializza("settaggi","direttrici")

-- codice applicativo
 
while true do
local id, scgrc = rednet.receive()
 
 if scgrc[1] == "prepara" then
 
  if scgrc[2] == "arrivo" then
  
  t,d,g,s,r = scgrc[2],scgrc[3],scgrc[4],scgrc[5],tonumber(scgrc[5])
  
   if D[d] ~= nil then
    if D[d].vg == "ammessa" then
     if g == "eccezionale" then
	 prepara_eccezionale(t,d,D[d].dx,g,s,r,c,D[d].dx)
	 elseif g == "passeggeri" or g == "merci" or g == "servizi" then
	 prepara_arrivo(d,D[d].dx,g,B[g].vp,s,r,D[d].kx,B[g].vn,B[g].by)
	 end
    else
    rednet.broadcast({"arrivo",d,"cardinalita'",D[d].sg})
    end
   else
   rednet.broadcast({"arrivo",d,"cardinalita'","inesistente"})
   end
 
  end
 
  if scgrc[2] == "partenza" then  
  
  t,d,g,s,r = scgrc[2],scgrc[3],scgrc[4],scgrc[5],tonumber(scgrc[5])
  
   if D[d] ~= nil then
    if D[d].vg == "ammessa" then
     if g == "eccezionale" then
	 prepara_eccezionale(t,d,D[d].dy,g,s,r,c,D[d].ky)
	 elseif g == "passeggeri" or g == "merci" or g == "servizi" then
	 prepara_partenza(d,D[d].dy,g,B[g].vp,s,r,D[d].ky,B[g].vn,B[g].by)
	 end
    else
    rednet.broadcast({"arrivo",d,"cardinalita'",D[d].sg})
    end
   else
   rednet.broadcast({"arrivo",d,"cardinalita'","inesistente"})
   end
   
  end
 
  if scgrc[2] == "fermata" then
  
  t = scgrc[2]
  v = scgrc[3]
  g = scgrc[4]
  s = scgrc[5]

  configura_versori(v)
  configura_fermata(v)
  configura_linea(e,q,v,V.dy)

   if e == "esistente" and q == "ammessa" then
    if g == "parallela" then
	prepara_fermata(v,w,V.dx,V.dy,g,G.fp,s,cp,k)
    end
	if g == "lineare" then 
	prepara_fermata(v,w,V.dx,V.dy,g,G.fl,s,cl,k)
    end
   end
	
   if e == "esistente" and q == "vietata" then
   rednet.broadcast({"fermata",v,"cardinalita'",q})
   end
   if e == "inesistente" then
   rednet.broadcast({"fermata",v,"cardinalita'",e})
   end
   if v == nil then
   rednet.broadcast({"fermata","cardinalita'","indefinita"})
   end
 
  end
 
  if scgrc[2] == "transito" then
  
  t = scgrc[2]
  v1 = scgrc[3]
  v2 = scgrc[4]
  g = scgrc[5]
  s = scgrc[6]
  r = tonumber(scgrc[6])  
  
  d1 = V.dx
  d2 = V.dy
  configura_versori(v1)
  e1 = e
  g1 = q
  configura_versori(v2)
  e2 = e
  g2 = q
  configura_linea(e,q,v,V.dy)

   if e1 == "esistente" and e2 == "esistente" then
   e = "esistente"
   end
   if e1 == "inesistente" or e2 == "inesistente" then
   e = "inesistente"
   end  
   if q1 == "ammessa" and q2 == "ammessa" then
   q = "ammessa"
   end 
   if q1 == "vietata" or q2 == "vietata" then
   q = "vietata"
   end 
   
   if e == "esistente" and q == "ammessa" then
    if g == "dedicato" then
	transito_dedicato(v1,v2,d1,d2,g,P.bt,s,r,k,N.bt,V.ut)
    end	 
    if g == "eccezionale" then	 
    transito_eccezionale(v1,v2,d1,d2,g,G.te,s,r,k)
    end
   end   

   if e == "esistente" and q == "vietata" then
   rednet.broadcast({"transito",v1,v2,"cardinalita'",q})
   end
   if e == "inesistente" then
   rednet.broadcast({"transito",v1,v2,"cardinalita'",e})
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