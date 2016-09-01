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

-- funzioni cardinalità
ge = "gestita"
gs = "gestita"
gw = "gestita"
gn = "gestita"

-- codifica binari di categoria

xp = 100
xm = 200
xs = 300

-- codifica binari di funzione

xf = 500
xt = 600

-- codifica versori

cv = 1000
cw = 100

-- binari di direttrice

xd = 1
yd = 2

-- funzioni di direttrice

de = "gestita"

-- codifica di direttice

cd = 0

-- operatore sosta

s = 30

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
print("< treni >")
sleep(1)
print("gestore")
sleep(1)
print("assegnazione")
sleep(1)
print("inizializzazione")
sleep(1)
print("connessione")
rednet.open(modem)
rednet.broadcast("avvio_gestore_treni")
sleep(1)
print("funzionamento")

-- codice funzioni

function configura_versori()

q = " "
g = " "
w = " "
d = " "

 if v == ve then
 q = "esistente"
 g = ge 
 w = we
 end
 if v == vs then
 q = "esistente"
 g = gs
 w = ws
 end
 if v == vw then
 q = "esistente"
 g = gw
 w = ww
 end
 if v == vn then
 q = "esistente"
 g = gn
 w = wn
 end	
   
end

function configura_direttrici()

 if de == "gestita" then
 xd = xd
 yd = yd
 end
 if de ~= "gestita" then
 xd = cd
 yd = cd
 end
 
end 

function configura_blocchi()

 if q == "esistente" and g == "gestita" then
 k = v*cv+d
 end
 
end

function configura_fermata()

 if v == ve then
 c = xf+1
 l = v*cv+c
 end 
 if v == vs then
 c = xf+1
 l = v*cv+c
 end 
 if v == nw then
 c = xf+2
 l = v*cv+c
 end
 if v == vn then
 c = xf+2
 l = v*cv+c
 end
 
end

-- codice sistema

while true do
local senderID, message = rednet.receive()
local words = {}

for word in string.gmatch(message, "%w+") do words[#words + 1] = word end

 if words[1] == "gestisci" then

  if words[2] == "arrivo" then
  v = tonumber(words[3])
  
  q = ""
  g = ""
   
   if v == ve then
   q = "esistente"
   g = ge
   w = vw  
   d = dw
   x = ce+xk
   z = cw+zk
   k = x
   end
   if v == vs then
   q = "esistente"
   g = gs
   w = vn
   d = dn
   x = cs+xk
   z = cn+zk
   k = x
   end
   if v == vw then
   q = "esistente"
   g = gw
   w = ve
   d = de
   x = cw+xk
   z = ce+zk
   k = x
   end
   if v == vn then
   q = "esistente"
   g = gn
   w = vs
   d = ds
   x = cn+xk
   z = cs+zk
   k = x
   end	
	
   if q == "esistente" and g == "gestita" then

    if words[4] == "passeggeri" then

     if words[5] == "elabora" then	 	 
	 rednet.broadcast("prepara_arrivo_"..v.."_passeggeri_elabora")
      while true do
      local senderID, message = rednet.receive()
      local words = {}
      local i = " " 
      for word in string.gmatch(message, "%w+") do words[#words + 1] = word end	  
       if words[1] == "arrivo" then	   		
        if tonumber(words[2]) == v then		 
         if words[3] == "passeggeri" then   
          if words[4] == "elaborato" then
	      r = tonumber(words[5])
          c = r+xp
	      rednet.broadcast("arrivo_"..v.."_passeggeri_"..r.."_attesa")
          rednet.broadcast("comando_avviatore_"..k.."_"..d)
		  rednet.broadcast("comando_arrestatore_"..c.."_"..d)
           while true do
           event, id, message, distance, protocol = os.pullEvent("rednet_message")	
            if message == "aggiornamento_binario_"..k.."_libero" then
            rednet.broadcast("comando_avviatore_"..k.."_inattivo")
            end
   	        if message == "aggiornamento_binario_"..c.."_occupato" then
            rednet.broadcast("arrivo_"..v.."_passeggeri_"..r.."_gestito")
	        break
            end				  
           end			 
          end			
          if words[4] == "elabora" then          
    	   if words[5] == "impossibile" then
           rednet.broadcast("arrivo_"..v.."_passeggeri_elabora_ingestibile")
           break		
           end		   
	      end		  
         end
        end
       end
      end
	  
	 else	
     r = tonumber(words[5])
     c = r+xp
	 rednet.broadcast("prepara_arrivo_"..v.."_passeggeri_"..r)
      while true do
      event, id, message, distance, protocol = os.pullEvent("rednet_message")
       if message == "aggiornamento_binario_"..k.."_libero" then
       rednet.broadcast("comando_avviatore_"..k.."_inattivo")
       end
       if message == "aggiornamento_binario_"..c.."_occupato" then
       rednet.broadcast("arrivo_"..v.."_passeggeri_"..r.."_gestito")
       break	   
       end
       if message == "arrivo_"..v.."_passeggeri_"..r.."_preparato" then  
       rednet.broadcast("arrivo_"..v.."_passeggeri_"..r.."_attesa")
	   rednet.broadcast("comando_avviatore_"..k.."_"..d)
	   rednet.broadcast("comando_arrestatore_"..c.."_"..d)
       end
       if message == "arrivo_"..v.."_passeggeri_"..r.."_impossibile" then
       rednet.broadcast("arrivo_"..v.."_passeggeri_"..r.."_ingestibile")
       break	   
       end
      end
	 end

    end 	 
    
    if words[4] == "merci" then

     if words[5] == "elabora" then	 	 
	 rednet.broadcast("prepara_arrivo_"..v.."_merci_elabora")
      while true do
      local senderID, message = rednet.receive()
      local words = {}
      local i = " " 
      for word in string.gmatch(message, "%w+") do words[#words + 1] = word end	  	   
       if words[1] == "arrivo" then		
        if tonumber(words[2]) == v then		 
         if words[3] == "merci" then		   
          if words[4] == "elaborato" then
	      r = tonumber(words[5])
          c = r+xm
	      rednet.broadcast("arrivo_"..v.."_merci_"..r.."_attesa")
          rednet.broadcast("comando_avviatore_"..k.."_"..d)
		  rednet.broadcast("comando_arrestatore_"..c.."_"..d)			
           while true do
           event, id, message, distance, protocol = os.pullEvent("rednet_message")
            if message == "aggiornamento_binario_"..k.."_libero" then
            rednet.broadcast("comando_avviatore_"..k.."_inattivo")
            end			 
   	        if message == "aggiornamento_binario_"..c.."_occupato" then
            rednet.broadcast("arrivo_"..v.."_merci_"..r.."_gestito")
	        break
            end			  
           end			 
          end			
          if words[4] == "elabora" then          
           if words[5] == "impossibile" then
           rednet.broadcast("arrivo_"..v.."_merci_elabora_ingestibile")
           break
           end					   
	      end		  
         end
        end
       end
      end
      
	 else
     r = tonumber(words[5])
     c = r+xm
	 rednet.broadcast("prepara_arrivo_"..v.."_merci_"..r)
      while true do
      event, id, message, distance, protocol = os.pullEvent("rednet_message")
       if message == "aggiornamento_binario_"..k.."_libero" then
       rednet.broadcast("comando_avviatore_"..k.."_inattivo")
       end
       if message == "aggiornamento_binario_"..c.."_occupato" then
       rednet.broadcast("arrivo_"..v.."_merci_"..r.."_gestito")
       break	   
       end
       if message == "arrivo_"..v.."_merci_"..r.."_preparato" then  
       rednet.broadcast("arrivo_"..v.."_merci_"..r.."_attesa")
	   rednet.broadcast("comando_avviatore_"..k.."_"..d)
	   rednet.broadcast("comando_arrestatore_"..c.."_"..d)
       end
       if message == "arrivo_"..v.."_merci_"..r.."_impossibile" then
       rednet.broadcast("arrivo_"..v.."_merci_"..r.."_ingestibile")
       break	   
       end
      end
	 end

    end 	 

    if words[4] == "servizi" then

     if words[5] == "elabora" then	 	 
	 rednet.broadcast("prepara_arrivo_"..v.."_servizi_elabora")
      while true do
      local senderID, message = rednet.receive()
      local words = {}
      local i = " " 
      for word in string.gmatch(message, "%w+") do words[#words + 1] = word end	     
       if words[1] == "arrivo" then
        if tonumber(words[2]) == v then		 
         if words[3] == "servizi" then		   
          if words[4] == "elaborato" then
	      r = tonumber(words[5])
          c = r+xs
	      rednet.broadcast("arrivo_"..v.."_servizi_"..r.."_attesa")
          rednet.broadcast("comando_avviatore_"..k.."_"..d)
		  rednet.broadcast("comando_arrestatore_"..c.."_"..d)			
           while true do
           event, id, message, distance, protocol = os.pullEvent("rednet_message")
            if message == "aggiornamento_binario_"..k.."_libero" then
            rednet.broadcast("comando_avviatore_"..k.."_inattivo")
            end			 
   	        if message == "aggiornamento_binario_"..c.."_occupato" then
            rednet.broadcast("arrivo_"..v.."_servizi_"..r.."_gestito")
	        break
            end			  
           end			 
          end			
          if words[4] == "elabora" then          
    	   if words[5] == "impossibile" then
           rednet.broadcast("arrivo_"..v.."_servizi_elabora_ingestibile")
           break
           end				   
	      end		  
         end
        end
       end
      end
	  
	 else
     r = tonumber(words[5])
     c = r+xs
	 rednet.broadcast("prepara_arrivo_"..v.."_servizi_"..r)
      while true do
      event, id, message, distance, protocol = os.pullEvent("rednet_message")
       if message == "aggiornamento_binario_"..k.."_libero" then
       rednet.broadcast("comando_avviatore_"..k.."_inattivo")
       end
       if message == "aggiornamento_binario_"..c.."_occupato" then
       rednet.broadcast("arrivo_"..v.."_servizi_"..r.."_gestito")
       break	   
       end
       if message == "arrivo_"..v.."_servizi_"..r.."_preparato" then  
       rednet.broadcast("arrivo_"..v.."_passeggeri_"..r.."_attesa")
	   rednet.broadcast("comando_avviatore_"..k.."_"..d)
	   rednet.broadcast("comando_arrestatore_"..c.."_"..d)
       end
       if message == "arrivo_"..v.."_servizi_"..r.."_impossibile" then
       rednet.broadcast("arrivo_"..v.."_servizi_"..r.."_ingestibile")
       break	   
       end
      end
	 end

    end
    
    if words[4] == "eccezionale" then

     r = tonumber(words[5])
     c = r+xe
	 rednet.broadcast("prepara_arrivo_"..v.."_eccezionale_"..r)
      while true do
      event, id, message, distance, protocol = os.pullEvent("rednet_message")
       if message == "aggiornamento_binario_"..k.."_libero" then
       rednet.broadcast("comando_avviatore_"..k.."_inattivo")
       end
       if message == "aggiornamento_binario_"..c.."_occupato" then
       rednet.broadcast("arrivo_"..v.."_eccezionale_"..r.."_gestito")
       break	   
       end
       if message == "arrivo_"..v.."_eccezionale_"..r.."_preparato" then  
       rednet.broadcast("arrivo_"..v.."_eccezionale_"..r.."_attesa")
	   rednet.broadcast("comando_avviatore_"..k.."_"..d)
	   rednet.broadcast("comando_arrestatore_"..c.."_"..d)
       end
       if message == "arrivo_"..v.."_eccezionale_"..r.."_impossibile" then
       rednet.broadcast("arrivo_"..v.."_eccezionale_"..r.."_ingestibile")
       break	   
       end
       if message == "arrivo_"..v.."_eccezionale_"..r.."_inestistente" then
       rednet.broadcast("arrivo_"..v.."_eccezionale_"..r.."_ingestibile")
	   break
	   end
      end
	 end
   
   end
   
   if q == "esistente" and g == "ingestita" then
   rednet.broadcast("arrivo_"..v.."_cardinalita'_ingestita")
   end
   
   if q ~= "esistente" then
   rednet.broadcast("arrivo_"..v.."_cardinalita'_inesistente")
   end
   
   if v == nil then
   rednet.broadcast("arrivo_cardinalita'_indefinita")
   end
 
  end
  
  if words[2] == "partenza" then  
  v = tonumber(words[3])
  q = ""
  g = ""
   
   if v == ve then
   q = "esistente"
   g = ge
   w = vw
   d = de
   x = cw+xk
   z = ce+zk
   k = z
   end
   if v == vs then
   q = "esistente"
   g = gs
   w = vn
   d = ds
   x = cn+xk
   z = cs+zk
   k = z
   end
   if v == vw then
   q = "esistente"
   g = gw
   w = ve
   d = dw
   x = ce+xk
   z = cw+zk
   k = z
   end
   if v == vn then
   q = "esistente"
   g = gn
   w = vs
   d = dn
   x = cs+xk
   z = cn+zk
   k = z
   end  
	
   if q == "esistente" and g == "gestita" then
   
    if words[4] == "passeggeri" then
    r = tonumber(words[5])
    c = r+xp
	rednet.broadcast("prepara_partenza_"..v.."_passeggeri_"..r)
     while true do
     event, id, message, distance, protocol = os.pullEvent("rednet_message")
      if message == "aggiornamento_binario_"..c.."_libero" then
      rednet.broadcast("comando_avviatore_"..c.."_inattivo")
      end
      if message == "aggiornamento_binario_"..k.."_occupato" then
      rednet.broadcast("partenza_"..v.."_passeggeri_"..r.."_gestito")
      break	   
      end
      if message == "partenza_"..v.."_passeggeri_"..r.."_preparato" then  
      rednet.broadcast("partenza_"..v.."_passeggeri_"..r.."_attesa")
	  rednet.broadcast("comando_avviatore_"..c.."_"..d)
      end
      if message == "partenza_"..v.."_passeggeri_"..r.."_impossibile" then
      rednet.broadcast("partenza_"..v.."_passeggeri_"..r.."_ingestibile")
      break	   
      end
     end
	end
	  
    if words[4] == "merci" then
    r = tonumber(words[5])
    c = r+xm
	rednet.broadcast("prepara_partenza_"..v.."_merci_"..r)
     while true do
     event, id, message, distance, protocol = os.pullEvent("rednet_message")
      if message == "aggiornamento_binario_"..c.."_libero" then
      rednet.broadcast("comando_avviatore_"..c.."_inattivo")
      end
      if message == "aggiornamento_binario_"..k.."_occupato" then
      rednet.broadcast("partenza_"..v.."_merci_"..r.."_gestito")
      break	   
      end
      if message == "partenza_"..v.."_merci_"..r.."_preparato" then  
      rednet.broadcast("partenza_"..v.."_merci_"..r.."_attesa")
	  rednet.broadcast("comando_avviatore_"..c.."_"..d)
      end
      if message == "partenza_"..v.."_merci_"..r.."_impossibile" then
      rednet.broadcast("partenza_"..v.."_merci_"..r.."_ingestibile")
      break	   
      end
     end
	end
	
    if words[4] == "servizi" then
    r = tonumber(words[5])
    c = r+xs
	rednet.broadcast("prepara_partenza_"..v.."_servizi_"..r)
     while true do
     event, id, message, distance, protocol = os.pullEvent("rednet_message")
      if message == "aggiornamento_binario_"..c.."_libero" then
      rednet.broadcast("comando_avviatore_"..c.."_inattivo")
      end
      if message == "aggiornamento_binario_"..k.."_occupato" then
      rednet.broadcast("partenza_"..v.."_servizi_"..r.."_gestito")
      break	   
      end
      if message == "partenza_"..v.."_servizi_"..r.."_preparato" then  
      rednet.broadcast("partenza_"..v.."_servizi_"..r.."_attesa")
	  rednet.broadcast("comando_avviatore_"..c.."_"..d)
      end
      if message == "partenza_"..v.."_servizi_"..r.."_impossibile" then
      rednet.broadcast("partenza_"..v.."_servizi_"..r.."_ingestibile")
      break	   
      end
     end
	end
	
	if words[4] == "eccezionale" then
    r = tonumber(words[5])
    c = r+xe
	rednet.broadcast("prepara_partenza_"..v.."_eccezionale_"..r)
     while true do
     event, id, message, distance, protocol = os.pullEvent("rednet_message")
      if message == "aggiornamento_binario_"..c.."_libero" then
      rednet.broadcast("comando_avviatore_"..c.."_inattivo")
      end
      if message == "aggiornamento_binario_"..k.."_occupato" then
      rednet.broadcast("partenza_"..v.."_eccezionale_"..r.."_gestito")
      break	   
      end
      if message == "partenza_"..v.."_eccezionale_"..r.."_preparato" then  
      rednet.broadcast("gestisci_partenza_"..v.."_eccezionale_"..r.."_attesa")
	  rednet.broadcast("comando_avviatore_"..c.."_"..d)
      end
      if message == "partenza_"..v.."_eccezionale_"..r.."_impossibile" then
      rednet.broadcast("partenza_"..v.."_eccezionale_"..r.."_ingestibile")
      break	   
      end
      if message == "partenza_"..v.."_eccezionale_"..r.."_inestistente" then
      rednet.broadcast("partenza_"..v.."_eccezionale_"..r.."_ingestibile")
	  break
	  end
     end
	end
   
   end
   
   if q == "esistente" and g == "ingestita" then
   rednet.broadcast("gestisci_partenza_"..v.."_cardinalita'_ingestita")
   end
   
   if q ~= "esistente" then
   rednet.broadcast("gestisci_partenza_"..v.."_cardinalita'_inesistente")
   end
   
   if v == nil then
   rednet.broadcast("gestisci_partenza_cardinalita'_indefinita")
   end
   
  end
  
  if words[2] == "fermata" then
  v = tonumber(words[3])
  q = ""
  g = ""

   if v == ve then  
   q = "esistente"
   g = ge	
   w = vw
   d = dw	
   x = ce+xk
   z = cw+zk
   c = xf+1
   k = zf+c+w
   end
   if v == vs then  
   q = "esistente"
   g = gs	
   w = vn
   d = dn
   x = cs+xk
   z = cn+zk
   c = xf+1
   k = zf+c+w
   end
   if v == vw then  
   q = "esistente"
   g = gw	
   w = ve
   d = de
   x = cw+xk
   z = ce+zk
   c = xf+2
   k = zf+c+w
   end
   if v == vn then  
   q = "esistente"
   g = gn	
   w = vs
   d = ds
   x = cn+xk
   z = cs+zk
   c = xf+2
   k = zf+c+w
   end	
   
   if q == "esistente" and g == "gestita" then
 
    if words[4] == "dedicato" then
	
	 if words[5] == "arrivo" then
	 rednet.broadcast("prepara_fermata_"..v.."_dedicato_arrivo")
      while true do
      event, id, message, distance, protocol = os.pullEvent("rednet_message")
       if message == "aggiornamento_binario_"..x.."_libero" then
       rednet.broadcast("comando_avviatore_"..x.."_inattivo")
       end
       if message == "aggiornamento_binario_"..c.."_occupato" then	  
       rednet.broadcast("gestisci_fermata_"..v.."_dedicato_arrivo_completato")
       break	   
       end
       if message == "prepara_fermata_"..v.."_dedicato_arrivo_completato" then  
       rednet.broadcast("gestisci_fermata_"..v.."_dedicato_arrivo_attesa")
	   rednet.broadcast("comando_avviatore_"..x.."_"..d)
	   rednet.broadcast("comando_arrestatore_"..c.."_"..d)
       end
       if message == "prepara_fermata_"..v.."_dedicato_arrivo_impossibile" then
       rednet.broadcast("gestisci_fermata_"..v.."_dedicato_arrivo_impossibile")
       break	   
       end
      end
	 end
	 
	 if words[5] == "partenza" then
	 rednet.broadcast("prepara_fermata_"..w.."_dedicato_partenza")
      while true do
      event, id, message, distance, protocol = os.pullEvent("rednet_message")
       if message == "aggiornamento_binario_"..c.."_libero" then
       rednet.broadcast("comando_avviatore_"..c.."_inattivo")
       end
       if message == "aggiornamento_binario_"..z.."_occupato" then	  
       rednet.broadcast("gestisci_fermata_"..w.."_dedicato_partenza_completato")
       break
       end
       if message == "prepara_fermata_"..w.."_dedicato_partenza_completato" then  
       rednet.broadcast("gestisci_fermata_"..w.."_dedicato_partenza_attesa")
	   rednet.broadcast("comando_avviatore_"..c.."_"..d)
       end
       if message == "prepara_fermata_"..w.."_dedicato_partenza_impossibile" then
       rednet.broadcast("gestisci_fermata_"..w.."_dedicato_partenza_impossibile")
       break	   
       end
      end
	 end
	 
	end
	
    if words[4] == "eccezionale" then
	
	 if words[5] == "arrivo" then
	 rednet.broadcast("prepara_fermata_"..v.."_eccezionale_arrivo")
      while true do
      event, id, message, distance, protocol = os.pullEvent("rednet_message")
       if message == "aggiornamento_binario_"..x.."_libero" then
       rednet.broadcast("comando_avviatore_"..x.."_inattivo")
       end
       if message == "aggiornamento_binario_"..k.."_occupato" then	  
       rednet.broadcast("gestisci_fermata_"..v.."_eccezionale_arrivo_completato")
       break	   
       end
       if message == "prepara_fermata_"..v.."_eccezionale_arrivo_completato" then  
       rednet.broadcast("gestisci_fermata_"..v.."_eccezionale_arrivo_attesa")
	   rednet.broadcast("comando_avviatore_"..x.."_"..d)
	   rednet.broadcast("comando_arrestatore_"..k.."_"..d)
       end
       if message == "prepara_fermata_"..v.."_eccezionale_arrivo_impossibile" then
       rednet.broadcast("gestisci_fermata_"..v.."_eccezionale_arrivo_impossibile")
       break	   
       end
      end
	 end
	 
	 if words[5] == "partenza" then
	 rednet.broadcast("prepara_fermata_"..w.."_eccezionale_partenza")
      while true do
      event, id, message, distance, protocol = os.pullEvent("rednet_message")
       if message == "aggiornamento_binario_"..k.."_libero" then
       rednet.broadcast("comando_avviatore_"..k.."_inattivo")
       end
       if message == "aggiornamento_binario_"..z.."_occupato" then	  
       rednet.broadcast("gestisci_fermata_"..w.."_eccezionale_partenza_completato")
       break
       end
       if message == "prepara_fermata_"..w.."_eccezionale_partenza_completato" then  
       rednet.broadcast("gestisci_fermata_"..w.."_eccezionale_partenza_attesa")
	   rednet.broadcast("comando_avviatore_"..k.."_"..d)
       end
       if message == "prepara_fermata_"..w.."_eccezionale_partenza_impossibile" then
       rednet.broadcast("gestisci_fermata_"..w.."_eccezionale_partenza_impossibile")
       break	   
       end
      end
	 end	
	
	end
   
   end
   
   if q == "esistente" and g == "ingestita" then
   rednet.broadcast("gestisci_fermata_"..v.."_cardinalita'_ingestita")
   end
   
   if q ~= "esistente" then
   rednet.broadcast("gestisci_fermata_"..v.."_cardinalita'_inesistente")
   end
   
   if v == nil then
   rednet.broadcast("gestisci_fermata_cardinalita'_indefinita")
   end
   
  end
  
  if words[2] == "transito" then
  v = tonumber(words[3])
  q = ""
  g = ""
   
   if v == ve then  
   q = "esistente"
   g = ge
   w = vw
   d = dw
   x = ce+xk
   z = cw+zk
   k = z
   end
   if v == vs then  
   q = "esistente"
   g = gs
   w = vn
   d = dn
   x = cs+xk
   z = cn+zk
   k = z
   end
   if v == vw then  
   q = "esistente"
   g = gw
   w = ve
   d = de
   x = cw+xk
   z = ce+zk
   k = z
   end
   if v == vn then  
   q = "esistente"
   g = gn
   w = vs
   d = ds
   x = cn+xk
   z = cs+zk
   k = z
   end	
   
   if q == "esistente" and g == "gestita" then
   
    if words[4] == "dedicato" then
	
     if words[5] == "elabora" then	 	 
	 rednet.broadcast("prepara_transito_"..v.."_dedicato_elabora")
      while true do
      local senderID, message = rednet.receive()
      local words = {}
      local i = " " 
      for word in string.gmatch(message, "%w+") do words[#words + 1] = word end	  
       if words[1] == "prepara" then	   
        if words[2] == "transito" then		
         if tonumber(words[3]) == v then		 
           if words[4] == "dedicato" then   
            if words[5] == "elaborato" then
	        r = tonumber(words[6])
            c = tonumber(words[6])+xt
	        rednet.broadcast("gestisci_transito_"..v.."_dedicato_"..r.."_attesa")
            rednet.broadcast("comando_avviatore_"..x.."_"..d)
			rednet.broadcast("comando_arrestatore_"..c.."_"..d)
             while true do
             event, id, message, distance, protocol = os.pullEvent("rednet_message")	
              if message == "aggiornamento_binario_"..x.."_libero" then
              rednet.broadcast("comando_avviatore_"..x.."_inattivo")
              end
   	          if message == "aggiornamento_binario_"..c.."_occupato" then
              rednet.broadcast("gestisci_transito_"..v.."_dedicato_"..r.."_completato")
	          break
              end				  
             end			 
            end			
            if words[5] == "elabora" then          
    		 if words[6] == "impossibile" then
             rednet.broadcast("gestisci_transito_"..v.."_dedicato_elabora_impossibile")
             break
            end			
           end		   
	      end		  
         end
        end
       end
      end
	  
	 else	
     r = tonumber(words[5])
     c = tonumber(words[5])+xt
	 rednet.broadcast("prepara_transito_"..v.."_dedicato_"..r)
      while true do
      event, id, message, distance, protocol = os.pullEvent("rednet_message")
       if message == "aggiornamento_binario_"..x.."_libero" then
       rednet.broadcast("comando_avviatore_"..x.."_inattivo")
       end
       if message == "aggiornamento_binario_"..c.."_occupato" then
       rednet.broadcast("gestisci_transito_"..v.."_dedicato_"..r.."_completato")
       break	   
       end
       if message == "prepara_transito_"..v.."_dedicato_"..r.."_completato" then  
       rednet.broadcast("gestisci_arrivo_"..v.."_passeggeri_"..r.."_attesa")
	   rednet.broadcast("comando_avviatore_"..x.."_"..d)
	   rednet.broadcast("comando_arrestatore_"..c.."_"..d)
       end
       if message == "prepara_transito_"..v.."_dedicato_"..r.."_impossibile" then
       rednet.broadcast("gestisci_transito_"..v.."_dedicato_"..r.."_impossibile")
       break	   
       end
      end
	 end
	 
	end
	
    if words[4] == "eccezionale" then
	
     if words[5] == "elabora" then	 	 
	 rednet.broadcast("prepara_transito_"..v.."_eccezionale_elabora")
      while true do
      local senderID, message = rednet.receive()
      local words = {}
      local i = " " 
      for word in string.gmatch(message, "%w+") do words[#words + 1] = word end	  
       if words[1] == "prepara" then	   
        if words[2] == "transito" then		
         if tonumber(words[3]) == v then		 
           if words[4] == "eccezionale" then   
            if words[5] == "elaborato" then
	        r = tonumber(words[6])
            c = tonumber(words[6])+zt
	        rednet.broadcast("gestisci_transito_"..v.."_eccezionale_"..r.."_attesa")
            rednet.broadcast("comando_avviatore_"..x.."_"..d)
			rednet.broadcast("comando_arrestatore_"..c.."_"..d)
             while true do
             event, id, message, distance, protocol = os.pullEvent("rednet_message")	
              if message == "aggiornamento_binario_"..x.."_libero" then
              rednet.broadcast("comando_avviatore_"..x.."_inattivo")
              end
   	          if message == "aggiornamento_binario_"..c.."_occupato" then
              rednet.broadcast("gestisci_transito_"..v.."_eccezionale_"..r.."_completato")
	          break
              end				  
             end			 
            end			
            if words[5] == "elabora" then          
    		 if words[6] == "impossibile" then
             rednet.broadcast("gestisci_transito_"..v.."_eccezionale_elabora_impossibile")
             break
            end			
           end		   
	      end		  
         end
        end
       end
      end
	  
	 else	
     r = tonumber(words[5])
     c = tonumber(words[5])+zt
	 rednet.broadcast("prepara_transito_"..v.."_eccezionale_"..r)
      while true do
      event, id, message, distance, protocol = os.pullEvent("rednet_message")
       if message == "aggiornamento_binario_"..x.."_libero" then
       rednet.broadcast("comando_avviatore_"..x.."_inattivo")
       end
       if message == "aggiornamento_binario_"..c.."_occupato" then
       rednet.broadcast("gestisci_transito_"..v.."_eccezionale_"..r.."_completato")
       break	   
       end
       if message == "prepara_transito_"..v.."_eccezionale_"..r.."_completato" then  
       rednet.broadcast("gestisci_arrivo_"..v.."_passeggeri_"..r.."_attesa")
	   rednet.broadcast("comando_avviatore_"..x.."_"..d)
	   rednet.broadcast("comando_arrestatore_"..c.."_"..d)
       end
       if message == "prepara_transito_"..v.."_eccezionale_"..r.."_impossibile" then
       rednet.broadcast("gestisci_transito_"..v.."_eccezionale_"..r.."_impossibile")
       break
       end
       if message == "prepara_transito_"..v.."_eccezionale_"..r.."_inestistente" then
       rednet.broadcast("gestisci_transito_"..v.."_eccezionale_"..r.."_inesistente")
	   break
	   end
      end
	 end
	 
	end
   
   end
   
   if q == "esistente" and g == "ingestita" then
   rednet.broadcast("gestisci_transito_"..v.."_cardinalita'_ingestita")
   end
   
   if q ~= "esistente" then
   rednet.broadcast("gestisci_transito_"..v.."_cardinalita'_inesistente")
   end
   
   if v == nil then
   rednet.broadcast("gestisci_transito_cardinalita'_indefinita")
   end
  
  end
   
 end

 if words[1] == "sistemi" then
 
  if words[2] == "gestore" then
  
   if words[3] == "treni" then
   
    if words[4] == "spegnimento" then
    rednet.broadcast("spegnimento_gestore_treni")
    os.shutdown()
    end
    if words[4] == "riavvio" then
    rednet.broadcast("riavvio_gestore_treni")
    os.reboot()
    end
	
   end
   
  end
  
 end

end