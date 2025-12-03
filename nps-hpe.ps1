
# Programme de décodage des codes erreurs retournés par les commutateurs HPE sur le serveur NPS Windows

#Fonctionnement :
#Code erreur en décimal à convertir en binaire sur 32 bits

#Découpage : 4 bits (bourrage) - 4 bits/4 bits/8 bits (interface x/y/z) - 12 bits (id vlan)

#Suivi des mises à jour

#1.0 - 22/07/2024 : création

#

write-host "******************************************************"
write-host " "
write-host "        Programme de decodage des codes erreurs"
write-host "        retournes par un commutateur HPE"
write-host "        sur le serveur NPS"
write-host " "
write-host "******************************************************"
write-host " "


$erreur = Read-Host "Saisir le code erreur "

# Conversion decimal vers binaire (32 bits)
# Déclaration et initialisation du tableau de 32 bits

$tab = 0..31

For($i=0 ; $i -lt 32 ; $i++) 
{ 
	$tab[$i] = 0;
}

For($i=0 ; $erreur -gt 0 ; $i++) 
{ 
	$tab[$i] = [int]$erreur%2;
	$erreur = [Math]::Floor($erreur/2);
}


# Fin de conversion decimal vers binaire (32 bits)


# Affichage sous forme binaire avec les separations 4 4 4 8 12 - Bourrage (4 bits) Interface (4 bits/4 bits/8 bits) Id Vlan (12 bits)
# POUR DEBUG - A SUPPRIMER A TERME

# INTERFACE
$interface=" ";
For($i=27 ; $i -gt 23 ; $i--)
{
	$interface=$interface+$tab[$i];	
}

$interface+="/";

For($i=23 ; $i -gt 19 ; $i--)
{
	$interface=$interface+$tab[$i];	
}

$interface+="/";

For($i=19 ; $i -gt 11 ; $i--)
{
	$interface=$interface+$tab[$i];	
}

write-host " ";
write-host "Interface (binaire ) : " $interface;

# VLAN 
$vlan = " ";

For($i=11 ; $i -ge 0 ; $i--)
{
	$vlan=$vlan+$tab[$i];	
}

write-host "VLAN (binaire) : " $vlan;
write-host " ";

# FIN DEBUG EN BINAIRE

# AFFICHAGE EN DECIMAL
# Calcul de l'interface en décimal
$tmp0=0;
For(($i=27), ($j=3) ; $i -gt 23 ; $i--, $j--)
{
	$tmp0+=$tab[$i]*[math]::Pow(2,$j);	
}


$tmp1=0;
For(($i=23), ($j=3) ; $i -gt 19 ; $i--, $j--)
{
	$tmp1+=$tab[$i]*[math]::Pow(2,$j);	
}


$tmp2=0;
For(($i=19), ($j=7) ; $i -gt 11 ; $i--, $j--)
{
	$tmp2+=$tab[$i]*[math]::Pow(2,$j);	
}

# Affichage du résultat
write-host "Interface (décimal) : "$tmp0"/"$tmp1"/"$tmp2


# Calcul du VLAN id en décimal
$vlan=0;
For(($i=11), ($j=11) ; $i -ne 0 ; $i--, $j--)
{
	$vlan+=$tab[$i]*[math]::Pow(2,$j);	
}

# Affichage du VLAN id
write-host "VLAN Id (décimal) : "$vlan
write-host " ";

pause 