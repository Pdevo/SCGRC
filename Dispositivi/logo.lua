-- configurazione numero

n = 0

-- configurazione lato

l = " "
 
-- inizializzazione perifeiche

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

term.redirect(peripheral.wrap(monitor))
term.clear()
   
print("           `:'+++++++++++")
print("         ;++++++;,`      ")
print("        ++++++`   :+++++`")
print("       :+++++   `+++++++ ")
print("       +++++    +++++++  ")
print("      ;++++:   ++++++++  ")
print("                         ")
print("               :;+++''   ")
print("     +++++   ;++++`      ")
print("    '++++.   ++++;       ")
print("    +++++   `++++`       ")
print("   ;++++`   .++++`       ")
print("   ++++'    :++++        ")
print("  '++++     +++++        ")
print("  +++'      ++++.        ")
print(" ,,.       ++++:         ")
print("         :+++'           ")