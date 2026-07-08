extends Resource
class_name d_tg

@export_multiline var                                 rrinfo:=""##información
@export_multiline var                                 cllloz:=""##resumen de targeta
@export_enum("0","1","9","A","M","E","Q","R","L") var tiprrh:=""##formatos de tarjeta
@export var                                           RR:={}    ##extras

#========================
func fmtg():                   # formato de tarjeta
	if   tiprrh=="0":
		if !"estrus" in RR:RR["estrus"]=0                                                  #iestructura de esensia
		if !"imagen" in RR:RR["imagen"]="res://Evar system 000/rqs/p.png"                  #imagen de referensia
		if !"descri" in RR:RR["descri"]="..."                                              #descripsion
		if !"lem_ak" in RR:RR["lem_ak"]={"0": 0,"A": 0,"M": 0,"E": 0,"Q": 0,"R": 0,"L": 0,}#limite de acumulasiones
		if !"fin_es" in RR:RR["fin_es"]="//Pz"                                             #forma fisica
		if !"markks" in RR:RR["markks"]=["//!=(0,1,9)"]                                    #marcas caracteristicas
	elif tiprrh=="A":
		if !"efects" in RR:RR["efects"]=["","","",""]
	elif tiprrh=="M":
		if !"activa" in RR:RR["activa"]=0   #activasion
		if !"activ2" in RR:RR["activ2"]=0   #activasion 2
		if !"condii" in RR:RR["condii"]=0   #condision
		if !"lin_og" in RR:RR["lin_og"]=0   #opersion
		if !"lin_o2" in RR:RR["lin_o2"]=0   #operasio 2
		if !"acionn" in RR:RR["acionn"]="AA"#animasion
	elif tiprrh=="E":
		if !"a_cheq" in RR:RR["a_cheq"]=[0]#0-9
		if !"intchq" in RR:RR["intchq"]=0
		if !"timlim" in RR:RR["timlim"]=0
		if !"objchq" in RR:RR["objchq"]=["//0"] #objeto a chequear
		if !"crcidn" in RR:RR["crcidn"]=["ojo"] #objetivo de comprobasion
		if !"cntreq" in RR:RR["cntreq"]=[0]     #cantidad para ser valido
		#---------------------------------------#
		if !"aareco" in RR:RR["aareco"]=["AA"]  #animasion de victoria
		if !"trfcnd" in RR:RR["trfcnd"]=["//Tg"]#trofeo a dar
		if !"castig" in RR:RR["castig"]=["AA"]  #animasion de derrota
		if !"cstapl" in RR:RR["cstapl"]=["//Tg"]#castigp
	elif tiprrh=="Q":
		if !"ruatas" in RR:RR["ruatas"]=["estado:elemento de estado:resultado:cargas"]#rutas
		if !"efecto" in RR:RR["efecto"]=["//A"]                                       #efecto a emitir
		if !"reaccn" in RR:RR["reaccn"]=["AA"]                                        #animasion de reaccion
		if !"intrpt" in RR:RR["intrpt"]=["//E"]                                       #interprete de mision
		if !"lstimg" in RR:RR["lstimg"]=["//img"]                                     #imagen de cada fase
		if !"rsiduo" in RR:RR["rsiduo"]=["//Tg"]                                      #targeta a expulsar
	elif tiprrh=="R":
		if !"marcaa" in RR:RR["marcaa"]=""
		if !"efecto" in RR:RR["efecto"]=["//A"]
	elif tiprrh=="L":
		if !"efecto" in RR:RR["ejecus"]=0#a=ambiente
		if !"efecto" in RR:RR["imbmin"]=["//Tg"]
		if !"efecto" in RR:RR["imbext"]=[":0:"]
	rrinfo=""
	if "markks" in RR:
		var tipo=[false,false,false,false,false,false,]
		for i in RR["markks"]:
			if i!="//!=(0,1,9)" and load(i).tiprrh=="A":tipo[0]=true
			if i!="//!=(0,1,9)" and load(i).tiprrh=="M":tipo[1]=true
			if i!="//!=(0,1,9)" and load(i).tiprrh=="E":tipo[2]=true
			if i!="//!=(0,1,9)" and load(i).tiprrh=="Q":tipo[3]=true
			if i!="//!=(0,1,9)" and load(i).tiprrh=="R":tipo[4]=true
			if i!="//!=(0,1,9)" and load(i).tiprrh=="L":tipo[5]=true
		var m=""
		if tipo[0]:m+="A"
		if RR["lem_ak"]["A"]>0:m+="a"
		if tipo[1]:m+="M"
		if RR["lem_ak"]["M"]>0:m+="m"
		if tipo[2]:m+="E"
		if RR["lem_ak"]["E"]>0:m+="e"
		if tipo[3]:m+="Q"
		if RR["lem_ak"]["Q"]>0:m+="q"
		if tipo[4]:m+="R"
		if RR["lem_ak"]["R"]>0:m+="r"
		if tipo[5]:m+="L"
		if RR["lem_ak"]["L"]>0:m+="l"
		rrinfo+="Marcas: "+m+"\n"
	if "estrus" in RR:
		var tl=5
		if   RR["estrus"]%tl==0:rrinfo+="Estructura: 0=personaje\n"
		elif RR["estrus"]%tl==1:rrinfo+="Estructura: 1=objeto\n"
		elif RR["estrus"]%tl==2:rrinfo+="Estructura: 2=equipo\n"
		elif RR["estrus"]%tl==3:rrinfo+="Estructura: 3=inmobiliario\n"
		elif RR["estrus"]%tl==4:rrinfo+="Estructura: 4=estructura\n"
		if RR["estrus"]>=tl:RR["estrus"]=0
	if "ejecus" in RR:
		var tl=13
		if   RR["ejecus"]%tl==0:rrinfo+="Eventualidad: 0=ambiente.        {o}\n"
		elif RR["ejecus"]%tl==1:rrinfo+="Eventualidad: 1=entre en esena.  _o_\n"
		elif RR["ejecus"]%tl==2:rrinfo+="Eventualidad: 2=emboscada.       >o<\n"
		elif RR["ejecus"]%tl==3:rrinfo+="Eventualidad: 3=persecusion      >>o\n"
		elif RR["ejecus"]%tl==4:rrinfo+="Eventualidad: 4=inbestigar       [o]\n"
		elif RR["ejecus"]%tl==5:rrinfo+="Eventualidad: 5=estar            (o)\n"
		elif RR["ejecus"]%tl==6:rrinfo+="Eventualidad: 6=oficio           _o0\n"
		elif RR["ejecus"]%tl==7:rrinfo+="Eventualidad: 7=surgir           o_o\n"
		elif RR["ejecus"]%tl==8:rrinfo+="Eventualidad: 8=encontrado       o<Q\n"
		elif RR["ejecus"]%tl==9:rrinfo+="Eventualidad: 9=rutina           &o&\n"
		elif RR["ejecus"]%tl==10:rrinfo+="Eventualidad: 10=emcarnar         }o{\n"
		elif RR["ejecus"]%tl==11:rrinfo+="Eventualidad: 11=momento magico   JoL\n"
		elif RR["ejecus"]%tl==12:rrinfo+="Eventualidad: 12=conflicto        oxo\n"
		if RR["ejecus"]>=tl:RR["ejecus"]=0
	if "a_cheq" in RR:
		var tl=3
		rrinfo+="A chequear:\n"
		var x=0;while x<len(RR["a_cheq"]):
			if   RR["a_cheq"][x]%tl==0:rrinfo+="\t"+str(x)+"- 0=todo en la Pz\n"
			elif RR["a_cheq"][x]%tl==1:rrinfo+="\t"+str(x)+"- 1=la interaccion\n"
			elif RR["a_cheq"][x]%tl==2:rrinfo+="\t"+str(x)+"- 2=todo en la interaccion\n"
			if RR["a_cheq"][x]>=tl:RR["a_cheq"][x]=0
			x+=1
	if "acionn" in RR:rrinfo+="Nombre de la animasion: "+RR["acionn"]+"\n"
	if "objchq" in RR:
		rrinfo+="Objetivos a chequear:\n"
		var x=0;while x<len(RR["objchq"]):
			if RR["objchq"][x]!="//0" and RR["objchq"][x]!=null and RR["objchq"][x]!="":
				rrinfo+="\t"+str(x)+"- "+RR["objchq"][x]+"\n"
			else:rrinfo+="\t"+str(x)+"- ...\n"
			x+=1
	if "crcidn" in RR:
		rrinfo+="Marca a obserbar:\n"
		var x=0;while x<len(RR["crcidn"]):
			rrinfo+="\t"+str(x)+"- "+RR["crcidn"][x]+"\n"
			x+=1
	if "cntreq" in RR:
		rrinfo+="Cantidad requerida:\n"
		var x=0;while x<len(RR["cntreq"]):
			rrinfo+="\t"+str(x)+"- "+str(RR["cntreq"][x])+"\n"
			x+=1
	if "aareco" in RR:
		rrinfo+="Animasiones de recompensa:\n"
		var x=0;while x<len(RR["aareco"]):
			rrinfo+="\t"+str(x)+"- "+str(RR["aareco"][x])+"\n"
			x+=1
	if "trfcnd" in RR:
		rrinfo+="Trofeos:\n"
		var x=0;while x<len(RR["trfcnd"]):
			if RR["trfcnd"][x]!="//Tg" and RR["trfcnd"][x]!=null and RR["trfcnd"][x]!="":
				EgLb.defn(load(RR["trfcnd"][x]))
				rrinfo+="\t"+str(x)+"- "+load(RR["trfcnd"][x]).resource_name+"\n"
			else:rrinfo+="\t"+str(x)+"- ...\n"
			x+=1
	if "castig" in RR:
		rrinfo+="Animasiones de castigo:\n"
		var x=0;while x<len(RR["castig"]):
			rrinfo+="\t"+str(x)+"- "+str(RR["castig"][x])+"\n"
			x+=1
	if "cstapl" in RR:
		rrinfo+="Castigos:\n"
		var x=0;while x<len(RR["cstapl"]):
			if RR["cstapl"][x]!="//Tg" and RR["cstapl"][x]!=null and RR["cstapl"][x]!="":
				EgLb.defn(load(RR["cstapl"][x]))
				rrinfo+="\t"+str(x)+"- "+load(RR["cstapl"][x]).resource_name+"\n"
			else:rrinfo+="\t"+str(x)+"- ...\n"
			x+=1
	if "intchq" in RR:
		var tl=6
		if   RR["intchq"]%tl==0:rrinfo+="Conteo en: 0=tigs\n"
		elif RR["intchq"]%tl==1:rrinfo+="Conteo en: 1=momentos\n"
		elif RR["intchq"]%tl==2:rrinfo+="Conteo en: 2=dias\n"
		elif RR["intchq"]%tl==3:rrinfo+="Conteo en: 3=semanas\n"
		elif RR["intchq"]%tl==4:rrinfo+="Conteo en: 4=meses\n"
		elif RR["intchq"]%tl==5:rrinfo+="Conteo en: 5=años\n"
		if RR["intchq"]>=tl:RR["intchq"]=0
	if "timlim" in RR:
		rrinfo+="Repetisiones: "+str(RR["timlim"])+"\n"
	if "activa" in RR:
		var tl=19
		if   RR["activa"]%tl==0:rrinfo+="actibasion: 0=[P_]=pasiba\n"
		elif RR["activa"]%tl==1:rrinfo+="actibasion: 1=[M.]=paso\n"
		elif RR["activa"]%tl==2:rrinfo+="actibasion: 2=[M+]=marcha\n"
		elif RR["activa"]%tl==3:rrinfo+="actibasion: 3=[M*]=pateada\n"
		elif RR["activa"]%tl==4:rrinfo+="actibasion: 4=[N.]=paso atras\n"
		elif RR["activa"]%tl==5:rrinfo+="actibasion: 5=[N+]=retroseder\n"
		elif RR["activa"]%tl==6:rrinfo+="actibasion: 6=[N*]=distansiar\n"
		elif RR["activa"]%tl==7:rrinfo+="actibasion: 7=[I.]=topar\n"
		elif RR["activa"]%tl==8:rrinfo+="actibasion: 8=[I+]=interactuar\n"
		elif RR["activa"]%tl==9:rrinfo+="actibasion: 9=[I*]=reaccion\n"
		elif RR["activa"]%tl==10:rrinfo+="actibasion: 10=[C.]=salto\n"
		elif RR["activa"]%tl==11:rrinfo+="actibasion: 11=[C+]=cloche\n"
		elif RR["activa"]%tl==12:rrinfo+="actibasion: 12=[C*]=cambio\n"
		elif RR["activa"]%tl==13:rrinfo+="actibasion: 13=[X.]=tope x\n"
		elif RR["activa"]%tl==14:rrinfo+="actibasion: 14=[X+]=interaccion x\n"
		elif RR["activa"]%tl==15:rrinfo+="actibasion: 15=[X*]=reaccion x\n"
		elif RR["activa"]%tl==16:rrinfo+="actibasion: 16=[Z.]=tope z\n"
		elif RR["activa"]%tl==17:rrinfo+="actibasion: 17=[Z+]=interaccion z\n"
		elif RR["activa"]%tl==18:rrinfo+="actibasion: 18=[Z*]=reaccion z\n"
		if RR["activa"]>=tl:RR["activa"]=0
	if "activ2" in RR:
		var tl=19
		if   RR["activ2"]%tl==0:rrinfo+="actibasion: 0=[P_]=pasiba\n"
		elif RR["activ2"]%tl==1:rrinfo+="actibasion: 1=[M.]=paso\n"
		elif RR["activ2"]%tl==2:rrinfo+="actibasion: 2=[M+]=marcha\n"
		elif RR["activ2"]%tl==3:rrinfo+="actibasion: 3=[M*]=pateada\n"
		elif RR["activ2"]%tl==4:rrinfo+="actibasion: 4=[N.]=paso atras\n"
		elif RR["activ2"]%tl==5:rrinfo+="actibasion: 5=[N+]=retroseder\n"
		elif RR["activ2"]%tl==6:rrinfo+="actibasion: 6=[N*]=distansiar\n"
		elif RR["activ2"]%tl==7:rrinfo+="actibasion: 7=[I.]=topar\n"
		elif RR["activ2"]%tl==8:rrinfo+="actibasion: 8=[I+]=interactuar\n"
		elif RR["activ2"]%tl==9:rrinfo+="actibasion: 9=[I*]=reaccion\n"
		elif RR["activ2"]%tl==10:rrinfo+="actibasion: 10=[C.]=salto\n"
		elif RR["activ2"]%tl==11:rrinfo+="actibasion: 11=[C+]=cloche\n"
		elif RR["activ2"]%tl==12:rrinfo+="actibasion: 12=[C*]=cambio\n"
		elif RR["activ2"]%tl==13:rrinfo+="actibasion: 13=[X.]=tope x\n"
		elif RR["activ2"]%tl==14:rrinfo+="actibasion: 14=[X+]=interaccion x\n"
		elif RR["activ2"]%tl==15:rrinfo+="actibasion: 15=[X*]=reaccion x\n"
		elif RR["activ2"]%tl==16:rrinfo+="actibasion: 16=[Z.]=tope z\n"
		elif RR["activ2"]%tl==17:rrinfo+="actibasion: 17=[Z+]=interaccion z\n"
		elif RR["activ2"]%tl==18:rrinfo+="actibasion: 18=[Z*]=reaccion z\n"
		if RR["activ2"]>=tl:RR["activ2"]=0
	if "condii" in RR:
		var tl=4
		if   RR["condii"]%tl==0:rrinfo+="Condision: 0=si\n"
		elif RR["condii"]%tl==1:rrinfo+="Condision: 1=tope (0)\n"
		elif RR["condii"]%tl==2:rrinfo+="Condision: 2=en pared\n"
		elif RR["condii"]%tl==3:rrinfo+="Condision: 3=en piso\n"
		if RR["condii"]>=tl:RR["condii"]=0
	if "lin_og" in RR:
		var tl=10
		if   RR["lin_og"]%tl==0:rrinfo+="Funsion: 0=mover\n"
		elif RR["lin_og"]%tl==1:rrinfo+="Funsion: 1=orientar x\n"
		elif RR["lin_og"]%tl==2:rrinfo+="Funsion: 2=orientar y\n"
		elif RR["lin_og"]%tl==3:rrinfo+="Funsion: 3=dash xx\n"
		elif RR["lin_og"]%tl==4:rrinfo+="Funsion: 4=esalto +y\n"
		elif RR["lin_og"]%tl==5:rrinfo+="Funsion: 5=en picada -y\n"
		elif RR["lin_og"]%tl==6:rrinfo+="Funsion: 6=escalar\n"
		elif RR["lin_og"]%tl==7:rrinfo+="Funsion: 7=recuperacion\n"
		elif RR["lin_og"]%tl==8:rrinfo+="Funsion: 8=divagar\n"
		elif RR["lin_og"]%tl==9:rrinfo+="Funsion: 9=agarrar\n"
		if RR["lin_og"]>=tl:RR["lin_og"]=0
	if "lin_o2" in RR:
		var tl=11
		if   RR["lin_o2"]%tl==0:rrinfo+="Funsion: 0=ninguna\n"
		elif RR["lin_o2"]%tl==1:rrinfo+="Funsion: 1=mover\n"
		elif RR["lin_o2"]%tl==2:rrinfo+="Funsion: 2=orientar x\n"
		elif RR["lin_o2"]%tl==3:rrinfo+="Funsion: 3=orientar y\n"
		elif RR["lin_o2"]%tl==4:rrinfo+="Funsion: 4=dash xx\n"
		elif RR["lin_o2"]%tl==5:rrinfo+="Funsion: 5=esalto +y\n"
		elif RR["lin_o2"]%tl==6:rrinfo+="Funsion: 6=en picada -y\n"
		elif RR["lin_o2"]%tl==7:rrinfo+="Funsion: 7=escalar\n"
		elif RR["lin_o2"]%tl==8:rrinfo+="Funsion: 8=recuperacion\n"
		elif RR["lin_o2"]%tl==9:rrinfo+="Funsion: 9=divagar\n"
		elif RR["lin_o2"]%tl==10:rrinfo+="Funsion: 10=agarrar\n"
		if RR["lin_o2"]>=tl:RR["lin_o2"]=0
	if "activv" in RR:
		var tl=27
		if   RR["activv"][0]%tl==0:RR["activv"][1]="Qai"
		elif RR["activv"][0]%tl==-1:RR["activv"][1]="tt"
		elif RR["activv"][0]%tl==1:RR["activv"][1]="Qa"
		elif RR["activv"][0]%tl==2:RR["activv"][1]="Qk"
		elif RR["activv"][0]%tl==3:RR["activv"][1]="0i"
		elif RR["activv"][0]%tl==4:RR["activv"][1]="0a"
		elif RR["activv"][0]%tl==5:RR["activv"][1]="0k"
		elif RR["activv"][0]%tl==6:RR["activv"][1]="1i"
		elif RR["activv"][0]%tl==7:RR["activv"][1]="1a"
		elif RR["activv"][0]%tl==8:RR["activv"][1]="1k"
		elif RR["activv"][0]%tl==9:RR["activv"][1]="2i"
		elif RR["activv"][0]%tl==10:RR["activv"][1]="2a"
		elif RR["activv"][0]%tl==11:RR["activv"][1]="2k"
		elif RR["activv"][0]%tl==12:RR["activv"][1]="3i"
		elif RR["activv"][0]%tl==13:RR["activv"][1]="3a"
		elif RR["activv"][0]%tl==14:RR["activv"][1]="3k"
		elif RR["activv"][0]%tl==15:RR["activv"][1]="4i"
		elif RR["activv"][0]%tl==16:RR["activv"][1]="4a"
		elif RR["activv"][0]%tl==17:RR["activv"][1]="4k"
		elif RR["activv"][0]%tl==18:RR["activv"][1]="5i"
		elif RR["activv"][0]%tl==19:RR["activv"][1]="5a"
		elif RR["activv"][0]%tl==20:RR["activv"][1]="5k"
		elif RR["activv"][0]%tl==21:RR["activv"][1]="Qi-4i"
		elif RR["activv"][0]%tl==22:RR["activv"][1]="Qa-4i"
		elif RR["activv"][0]%tl==23:RR["activv"][1]="Qk-4i"
		elif RR["activv"][0]%tl==24:RR["activv"][1]="Qi-5i"
		elif RR["activv"][0]%tl==25:RR["activv"][1]="Qa-5i"
		elif RR["activv"][0]%tl==26:RR["activv"][1]="Qk-5i"
		rrinfo+="Actibasion: "+RR["activv"][1]+"\n"
func defn():                   # establese el nombre de un recurso
	var m=resource_path.split("/")
	resource_name=m[len(m)-1].split(".")[0]
