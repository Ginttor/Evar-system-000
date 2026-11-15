#Copyright 2026 Evaristo Velasquez
#
#Licensed under the Apache License, Version 2.0 (the "License");
#you may not use this file except in compliance with the License.
#You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
#Unless required by applicable law or agreed to in writing, software
#distributed under the License is distributed on an "AS IS" BASIS,
#WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#See the License for the specific language governing permissions and
#limitations under the License.


@tool extends Node

@export var dt:d_tg                          ##direccion de targeta
@export                    var dl:=""        ##direccion de libro
@export                    var zm=0          ##semilla de creasion
@export                    var RR:JSON       ##pagina de ajutes
@export                    var MP:Array[JSON]##paginas de partida
@export                    var MM:Array[JSON]##paginas de partida
@export                    var PT:Array[Node]##binculado
var R:={}
var mp:={}
var mm:={}
var cg=""

func _ready() -> void:
	if Engine.is_editor_hint():
		if dl:libr(dl)
	else:
		var x=0
		while x<len(PT) and len(PT)>0:
			var file = RR.resource_path
			var json_as_text = FileAccess.get_file_as_string(file)
			var rr = JSON.parse_string(json_as_text)
			if   PT[x].name=="AA":R["a"]=x#animasiones
			elif PT[x].name=="MP-nm":#nombre de modo de partida
				R["MP-nm"]=PT[x]
				file = rr["LMP"][0]
				json_as_text = FileAccess.get_file_as_string(file)
				var c = JSON.parse_string(json_as_text)
				R["MP-nm"].text=c["NM"]
			elif PT[x].name=="At":
				R["At"]=PT[x]
				file = rr["LMP"][0]
				json_as_text = FileAccess.get_file_as_string(file)
				var c = JSON.parse_string(json_as_text)
				if c["AT"]==0:R["At"].text="Inisio"
				if c["AT"]==1:R["At"].text="En curso"
				if c["AT"]==2:R["At"].text="Acabado"
			elif PT[x].name=="PP":
				R["PP"]=PT[x]
				if len(rr["LPP"])>1:R["PP"].text="..."
				else:
					file = rr["LPP"][0]
					json_as_text = FileAccess.get_file_as_string(file)
					var c = JSON.parse_string(json_as_text)
					R["PP"].text=c["NM"]
					for i in PT:
						if i.name=="PP-r":i.visible=false
			elif PT[x].name=="MM":
				R["MM"]=PT[x]
				if len(rr["LMM"])>1:R["MM"].text="..."
				else:
					file = rr["LMM"][0]
					json_as_text = FileAccess.get_file_as_string(file)
					var c = JSON.parse_string(json_as_text)
					R["MM"].text=c["NM"]
					for i in PT:
						if i.name=="MM-r":i.visible=false
			x+=1
func _process(_delta: float) -> void:
	if Engine.is_editor_hint():
		if dt:dt.fmtg()
	else:
		pass
#===================================#
func libr(r: String):           # crear libro
	var lb = r.path_join("LB")
	var dir = DirAccess.open(r)
	
	if dir == null:
		push_error("No se pudo acceder a la ruta: " + r)
	
	if not dir.dir_exists(lb):
		var err = dir.make_dir("LB")
		if err != OK:
			push_error("Error al crear la carpeta LB: " + str(err))
		print("Carpeta 'LB' creada en: " + lb)
		DirAccess.open(r+"/LB").make_dir("TG")
		DirAccess.open(r+"/LB/TG").make_dir("tg-0")
		DirAccess.open(r+"/LB/TG").make_dir("tg-A")
		DirAccess.open(r+"/LB/TG").make_dir("tg-M")
		DirAccess.open(r+"/LB/TG").make_dir("tg-E")
		DirAccess.open(r+"/LB/TG").make_dir("tg-Q")
		DirAccess.open(r+"/LB/TG").make_dir("tg-R")
		DirAccess.open(r+"/LB/TG").make_dir("tg-L")
		DirAccess.open(r+"/LB").make_dir("PZ")
		DirAccess.open(r+"/LB").make_dir("FC")
		DirAccess.open(r+"/LB").make_dir("TB")
		DirAccess.open(r+"/LB").make_dir("GM")
		DirAccess.open(r+"/LB").make_dir("MN")
		var file = FileAccess.open((r+"/LB/RR.json"), FileAccess.WRITE)
		if file == null:
			push_error("Error al crear RR.json: " + str(FileAccess.get_open_error()))
		var pf_rr={
			"nm":"..."
		}
		file.store_string(JSON.stringify(pf_rr, "\t"))
		file.close()
		print("Archivo 'RR.json' creado en: " + (r+"/LB"))
	else:
		print("Carpeta 'LB' ya existe en: " + lb)
func ordd(E):                   # ordenar targetas
	if len(E.ddd_tg)>0:
		var l:Array[d_tg]=[E.ddd_tg[0]];var f="0AMEQRL"
		for i in f:
			var x=1
			while x<len(E.ddd_tg):
				if E.ddd_tg[x].tiprrh==i and len(l)<E.RR["IV"]["Sps"]:l.append(E.ddd_tg[x])
				x+=1
		E.ddd_tg=l
func lejs(r):                   # leer archibo json
	var archivo = FileAccess.open(r, FileAccess.READ)
	if archivo == null:
		print("Error al abrir el archivo")
		return {}
	var texto = archivo.get_as_text()
	archivo.close()
	var json = JSON.new()
	var error = json.parse(texto)
	if error == OK:
		return json.data
	else:
		print("Error al parsear JSON: ", json.get_error_message())
		return {}
func catg(l,el=[]):             # carga esena nueva
	cg=""
	if len(el)>0:
		for i in el:
			i.queue_free()
	get_tree().change_scene_to_file(l)
func barj(l):                   # baragear
	var ll:Array[d_tg]
	while len(l)>0:
		var e=EgLb.dado(0,len(l))
		ll.append(l[e])
		l.erase(l[e])
	print("(BARAGEO):> ",ll)
	return ll
func atlz(E,x):                 # atlas
	var ap=false
	for i in E.ddd_tg[x].RR["imbext"]:
		if   i==":0:":ap=true
		elif i.split(":")[2]=="":
			var e=0
			while e <len(E.recerv["IV"]):
				E.recerv["IV"][e].defn()
				if E.recerv["IV"][e].resource_name==i.split(":")[0] and E.recerv["CR"][e]>=int(i.split(":")[1]):
					E.recerv["CR"][e]-=int(i.split(":")[1]);ap=true;break
				e+=1
		elif i.split(":")[2]=="y":
			ap=true
			for e in E.RR["EV"]:
				E.ddd_tg[x].defn()
				if e.ddd_tg.resource_name==E.ddd_tg[x].resource_name:
					ap=false;break
		elif i.split(":")[2]=="p":
			for e in E.RR["EV"]:
				if e.ddd_tg.resource_name==i.split(":")[0]:
					ap=true;break
	if ap:
		E.ddd_tg[x].defn()
		var f=preload("res://Evar_system_000/rqs/eev.tscn").instantiate()
		E.add_child.call_deferred(f)
		var uv=EgLb.dado(0,len(E.puntuv))
		f.ddd_tg=E.ddd_tg[x]
		f.PT.append(E);
		E.RR["EV"].append(f)
		EgLb.poci(f,uv,E)
		print("(EVECTO):> ",E.ddd_tg[x].resource_name)
func stcM(E,l: int, e: bool):   # cambiar colision mask
	if e:
		E.collision_mask |= (1 << (l - 1))
	else:
		E.collision_mask &= ~(1 << (l - 1))
func stcL(E,l: int, e: bool):   # cambiar colision layer
	if e:
		E.collision_layer |= (1 << (l - 1))
	else:
		E.collision_layer &= ~(1 << (l - 1))
func poci(p,uv,E):              # posisionamiento de pieza
	p.global_position=E.PT[uv].global_position
	p.tablle=E
func aspe(E,oj=null,t="",tx=""):# aspecto de la interfase
	var x=0
	#================================================================#foco
	if oj:
		E.R["CT"].visible=true
		E.R["CT"].global_position=oj.global_position
		if   oj.R["id"][0]=="pz":E.PT[E.R["A"]].aspect[0].texture=oj.imagee
		elif oj.R["id"][0]=="fc":E.PT[E.R["A"]].aspect[0].texture=oj.aspect[0].texture
		E.PT[E.R["A"]].PT[E.PT[E.R["A"]].R["a"]].play("on")
	else:
		E.R["CT"].visible=false
		E.PT[E.R["A"]].aspect[0].texture=null
		E.PT[E.R["A"]].PT[E.PT[E.R["A"]].R["a"]].play("of")

	#================================================================#imbentario
	if E.ioenje and "IV" in E.ioenje.RR:
		x=0;for i in E.R["IV"]:
			i.visible=false
			i.aspect[0].texture=null
			i.aspect[1].visible=false
			i.ddd_tg=null
		if "Dm" in E.ioenje.R:#----------------------------------------------#mecanicas
			if E.ioenje.R["Dm"][0]!=-1:#----------------------------------------------------------------------------------elejir
				E.R["IV"][E.ioenje.R["Dm"][0]].aspect[1].visible=true
			if (E.ioenje.R["Dm"][1]+1)*(E.ioenje.R["Dm"][0]+1)!=0 and E.ioenje.RR["IV"]["I"][E.ioenje.R["Dm"][0]]==null:#-mover
				E.ioenje.RR["IV"]["I"][E.ioenje.R["Dm"][0]]=E.ioenje.RR["IV"]["I"][E.ioenje.R["Dm"][1]]
				E.ioenje.RR["IV"]["K"][E.ioenje.R["Dm"][0]]=E.ioenje.RR["IV"]["K"][E.ioenje.R["Dm"][1]]
				E.ioenje.RR["IV"]["D"][E.ioenje.R["Dm"][0]]=E.ioenje.RR["IV"]["D"][E.ioenje.R["Dm"][1]]
				
				E.ioenje.RR["IV"]["I"][E.ioenje.R["Dm"][1]]=null
				E.ioenje.RR["IV"]["K"][E.ioenje.R["Dm"][1]]=""
				E.ioenje.RR["IV"]["D"][E.ioenje.R["Dm"][1]]=""
				
				E.ioenje.R["Dm"]=[-1,-1]
			E.ioenje.R["Dm"][1]=E.ioenje.R["Dm"][0]
		while x<E.ioenje.RR["IV"]["Sps"] and len(E.ioenje.RR["IV"]["I"])>0:#-#aspecto de imbentario
			E.R["IV"][x].visible=true
			if E.ioenje.RR["IV"]["I"][x]:
				E.R["IV"][x].ddd_tg=E.ioenje.RR["IV"]["I"][x]
				E.R["IV"][x].aspect[0].texture=load(E.ioenje.RR["IV"]["I"][x].RR["imagen"])
			#-----------------------
			#if E.ioenje.R["lQ"][x]!=-1:
			#	if E.ioenje.RR["IV"]["K"][E.ioenje.R["lQ"][x]]=="":
			#		E.R["IV"][x].aspect[0].texture=load(E.ioenje.ddd_tg[E.ioenje.R["lQ"][x]].RR["imagen"])
			#	else:
			#		var y=0;while y<len(E.ioenje.ddd_tg[E.ioenje.R["lQ"][x]].Tar_Q_.rutass):
			#			if E.ioenje.ddd_tg[E.ioenje.R["lQ"][x]].Tar_Q_.rutass[y].split(";")[2]==E.ioenje.RR["IV"]["K"][x]:
			#				E.R["IV"][x].aspect[0].texture=E.ioenje.ddd_tg[E.ioenje.R["lQ"][x]].Tar_Q_.imlist[y]
			#				break
			#			y+=1
			x+=1
		
	#================================================================#inspeccionador
	if "LSI" in E.R and E.ioenje:
		x=0;for i in E.R["LSI"].PT:
			i.text=""
		if oj and oj.R["id"][0]=="pz":
			E.R["LSI"].PT[0].text=oj.ddd_tg[0].resource_name
			if len(oj.etiggg)>0:for i in oj.etiggg:
				if   i.count("d:>_")>0 and tx=="":E.R["LSI"].PT[1].text+=i+"\n"
				elif i.count("c:>_")>0 and tx=="m":E.R["LSI"].PT[1].text+=i+"\n"

	if "Md" in E.RR:
		for i in E.RR["Md"].RR["TB"]:
			i.visible=false
	if E.ioenje and E.ioenje.tablle:E.ioenje.tablle.visible=true
func cttb(E):                   # control de tableros
	E.R["PS"]=[]
	for e in E.mjugad:
		if "PS" in e.R:
			for i in e.R["PS"]:
				E.R["PS"].append(i)
func icpt(E):                   # inisio de carrga de partida
	E.R["PS"]=[E.ioenje]
	var x=2;while x<len(E.PT):
		if E.PT[x].name=="AA":E.R["aa"]=x
		x+=1
	if E.ioenje:E.ioenje.RR["Md"]=E
	if E.ioenje and E.ioenje.tablle:
		E.ioenje.tablle.RR["Md"]=E
		for i in E.ioenje.tablle.PT:
			E.R["PS"].append(i)
	for i in E.R["IV"]:i.RR["MD"]=E
	if len(EgLb.mp)>0:
		var d=[];x=0;while x<len(EgLb.mp["P-PI"]):
			if !"P-PI" in E.RR:E.RR["P-PI"]="//pp"
			if E.RR and EgLb.mp["P-PI"][x]==E.RR["P-PI"]:
				d=EgLb.mp["P-UM"][x].split(";")
				break
			x+=1
		if d[1]!="nt":EgLb.reuv(E.ES,d,E.ioenje)
func miti(E,M,t):               # prosesamiento de mision
	if !"SM" in E.R:E.R["SM"]=0#segimiento de mision
	if M and "PS" in E.R:
		M.defn()
		var ct=0
		var y=0;while y<len(M.RR["a_cheq"]) and t==M.RR["intchq"]:
			for i in E.R["PS"]:#===========================#rebision de elemetos a chequear
				for e in i.etiggg:
					if e.count(M.RR["objchq"][y])>0:
						if   M.RR["a_cheq"][y]==0:#-----------------------+ todo en la Pz
							var x=0;while x <len(i.ddd_tg):
								if i.ddd_tg[x] and i.ddd_tg[x].resource_name==M.RR["crcidn"][y]:
									ct+=1
								x+=1
						elif M.RR["a_cheq"][y]==1:#-----------------------+ la interaccion
							var x=0;while x <len(i.R["II"]):
								for o in i.R["II"][x].etiggg:
									if o.count(M.RR["crcidn"][y])>0:
										ct+=1
								x+=1
						elif M.RR["a_cheq"][y]==2 and len(i.R["II"])>0:#--+ todo en la interaccion
							var tu=null
							if i.R["II"][0].name=="P":tu=i.R["II"][0].ioenje
							else:tu=i.R["II"][0]
							var x=0;while x <len(tu.RR["IV"]["I"]):
								tu.RR["IV"]["I"][x].defn()
								print("MS_iQ:",M.resource_name,tu.RR["IV"]["I"][x].resource_name,"==",M.RR["crcidn"][y])
								if tu.RR["IV"]["I"][x] and tu.RR["IV"]["I"][x].resource_name==M.RR["crcidn"][y]:
									ct+=1
								x+=1
						elif M.RR["a_cheq"][y]==3:#-----------------------+ en lo equipado
							var x=0;while x <len(i.eqiped):
								if i.eqiped[x]:
									if i.eqiped[x].name==M.RR["crcidn"][y]:
										ct+=1
								x+=1
			##===========================#prosesar resultados
			if ct>=M.RR["cntreq"][y]:
				print("MS_micion cumplida:",M.resource_name)
				if M.RR["trfcnd"][y]!="" and M.RR["trfcnd"][y]!="//Tg":
					var x=0;while x<len(E.R["PS"]):
						print("!!--:",E.R["PS"][x].name)
						if E.R["PS"][x].ddd_tg[0] and E.R["PS"][x].ddd_tg[0]==load(M.RR["trfcnd"][y]):
							E.R["PS"][x].est_ig="0"
						x+=1
				E.R["SM"]=0
				if !("FM" in E.RR):
					if "a" in E.R:E.PT[E.R["a"]].play(M.recocmp[y])
				return M.RR["aareco"][y]
			if E.R["SM"]==0:R["SM"]=M.RR["timlim"]+1
			if E.R["SM"]==1:
				R["SM"]=0
				return M.RR["castig"][y]
			R["SM"]-=1
			y+=1
	return ""
func reuv(E,p,c=null):          # reuvicasion
	var pz=""
	for i in E.pasodt:
		if i.split(";")[0]==p.name:pz=i
	pz=pz.split(";")
	var tb=-1;var x=0
	while x<len(E.RR["MM"]):
		if str(E.RR["MM"][x]).count(E.tabler[int(pz[1])].resource_name):tb=x
		x+=1
	if tb==-1:#---poner tablero agregado
		var f=E.tabler[int(pz[1])].instantiate()
		add_child(f)
		f.name=E.tabler[int(pz[1])].resource_name
		f.global_position=E.postab[int(pz[1])]
		E.RR["MM"].append(f)
		f.mapapp=E
		tb=len(E.RR["MM"])-1
	if pz[2].count("-"):
		x=0;while x<len(E.RR["MM"][tb].puntuv):
			if E.RR["MM"][tb].puntuv[x].count(pz[2]):pz[2]=str(x);break
			x+=1
	EgLb.poci(c,int(pz[2]), E.RR["MM"][tb])
	E.mjugad[0].position = E.RR["MM"][tb].position
	#E.mjugad[0].PT[E.mjugad[0].R["aa"]].play("finTb")
	#E.mjugad[0].ioenje.tablle=E.RR["MM"][tb]
	#E.mjugad[0].R["PS"]=E.mjugad[0].R["PS"]+E.mjugad[0].ioenje.tablle.PT
	#EgLb.aspe(E.mjugad[0])
func tigt(E) :                  # paso del tiempo
	#================================================#flujo de tiempo y su medision
	if !"ET" in E.R:E.R["ET"]=""
	if E.R["ET"]=="nh" and "NH" in E.RR:
		if E.modulate.r<E.RR["NH"].r:E.modulate.r+=0.01
		else:E.modulate.r-=0.01
		if E.modulate.g<E.RR["NH"].g:E.modulate.g+=0.01
		else:E.modulate.g-=0.01
		if E.modulate.b<E.RR["NH"].b:E.modulate.b+=0.01
		else:E.modulate.b-=0.01
		if E.modulate.a<E.RR["NH"].a:E.modulate.a+=0.01
		else:E.modulate.a-=0.01
	if E.R["ET"]=="dy" and "DY" in E.RR:
		if E.modulate.r<E.RR["DY"].r:E.modulate.r+=0.01
		else:E.modulate.r-=0.01
		if E.modulate.g<E.RR["DY"].g:E.modulate.g+=0.01
		else:E.modulate.g-=0.01
		if E.modulate.b<E.RR["DY"].b:E.modulate.b+=0.01
		else:E.modulate.b-=0.01
		if E.modulate.a<E.RR["DY"].a:E.modulate.a+=0.01
		else:E.modulate.a-=0.01
	if E.RR["TT"][0]>=E.RR["TL"][0]-1:
		for i in E.mjugad:
			if "sc" in i.R:i.PT[i.R["sc"]].play("qm"+str(E.RR["TT"][1]))
			#EgLb.ccmp(i.PT[0],"M-puntuasion")
		if E.RR["TT"][1]==4:E.R["ET"]="nh"
		if E.RR["TT"][1]==10:E.R["ET"]="dy"
	#if R["tb"]>=len(R["Tb"])-1:R["tb"]=0
	if E.RR["TT"][1]>=E.RR["TL"][1] and "St" in R:R["St"]-=EgLb.dado(0,100,1)
	var x=0;while x<6:
		if E.RR["TT"][x]>E.RR["TL"][x]:E.RR["TT"][x]=0;E.RR["TT"][x+1]+=1
		#if E.RR["TT"][0]==1:
		#	var y=0;while y<len(E.PT):
		#		E.PT[y].accion["AC"]+=1
		#		print("!!--:",E.PT[y].accion["AC"])
		#		y+=1
		x+=1
func alqm(k,e,r):               # alquimia
	var y=0;while y<len(k):
		if k[y].split(":")[0]==e and k[y].split(":")[1]==r:
			e=k[y].split(":")[2]
			r=""
			break
		y+=1
	return [r,e]
func dado(n,p,a=0):             # da un numero aleatorio
	if zm<100000:zm+=3711
	else:zm-=100000
	if n>p:var nn=n;n=p;p=nn
	zm=zm*7+a
	if zm<p:zm+=(zm+7)*p
	var r=n
	if n!=p:
		var m=zm%(p-n)
		r=m+n
	else:zm+=3711
	if zm>3711:zm=zm/3
	return r
func invl(L):                   # imbertir lista
	var LL=[]
	var x=len(L)-1;while x>=0:
		LL.append(L[x])
		x-=1 
	return LL
func upup(i,t,m,d):             # actualizar uvicasion de personaje
	var pp=[0,1000];var x=0;while x<len(t.puntuv):
		var xy=(t.puntuv[x].split(";")[0].replace("(","").replace(")","")).split(",")
		var cc=int(((int(xy[0])*t.escall.x)+t.global_position.x)-i.PT[0].global_position.x)
		if (cc<pp[1] and cc>0) or (cc>pp[1] and cc<0):
			pp[1]=cc
			pp[0]=x
		x+=1
	x=0;while x<len(EgLb.mp["P-PI"]):
		if EgLb.mp["P-PI"][x]==i.RR["P-PI"]:
			EgLb.mp["P-UM"][x]=str(pp[0])+";"+t.name+";"+d+";"+str(m.mapmmd.resource_path)
			print("N-P:"+EgLb.mp["P-PI"][x]+" -:- "+EgLb.mp["P-UM"][x])
			break
		x+=1
	return x
func rgst(c: Dictionary, d: String, n: String, k: String = "u") -> void:
	# Crea la carpeta si no existe
	if not DirAccess.dir_exists_absolute(d):
		DirAccess.make_dir_recursive_absolute(d)

	var ruta: String = d.path_join(n + ".json")
	var datos: Dictionary = c

	if k == "u" and FileAccess.file_exists(ruta):
		# Modo actualizar: lee lo que ya hay y lo fusiona con "c"
		var arch_lec := FileAccess.open(ruta, FileAccess.READ)
		var texto: String = arch_lec.get_as_text()
		arch_lec.close()

		var json := JSON.new()
		var err := json.parse(texto)
		if err == OK and typeof(json.data) == TYPE_DICTIONARY:
			var existente: Dictionary = json.data
			#existente.merge(c, true)  # true = las claves nuevas sobrescriben las viejas
			if "Pz" in existente and "Pz" in c:
				existente["Pz"].merge(c["Pz"], true)
				for i in existente["Pz"]:
					if FileAccess.file_exists(i):
						existente["Pz"].erase(i)
			if "Tg" in existente and "Tg" in c:
				existente["Tg"].merge(c["Tg"], true)
				for i in existente["Tg"]:
					if FileAccess.file_exists(i):existente["Tg"].erase(i)
			if "cm" in existente and "cm" in c:
				existente["cm"]=c["cm"]
			datos = existente
		else:
			push_warning("rgst: JSON existente inválido en " + ruta + ", se sobrescribirá.")

	# k == "s" (o cualquier valor distinto de "u") sobrescribe directo con "c"

	var arch_esc := FileAccess.open(ruta, FileAccess.WRITE)
	if arch_esc == null:
		push_error("rgst: no se pudo crear/abrir el archivo en " + ruta)
		return

	arch_esc.store_string(JSON.stringify(datos, "\t"))
	arch_esc.close()
#=================================================#
func _on_jp_pressed() -> void:
	#LibBouk.RR["pe"]=RR["MP"][0]
	#LibBouk.MP[RR["MP"][0]]["PP"].append(DD[RR["PE"][0]]["id"][1])
	#LibBouk.MP[RR["MP"][0]]["IP"].append(RR["PE"][0])
	#LibBouk.MP[RR["MP"][0]]["UP"].append(Vector2i(0,0))
	#3LibBouk.MP[RR["MP"][0]]["LP"]["MM"]=MP[RR["MP"][0]]["PI"][0]["MM"]
	#LibBouk.MP[RR["MP"][0]]["LP"]["M"] =MP[RR["MP"][0]]["PI"][0]["M"]
	#LibBouk.MP[RR["MP"][0]]["LP"]["T"] =MP[RR["MP"][0]]["PI"][0]["T"]
	catg("res://MacionTyurma-MD/ese/es_manion.tscn")#(LibBouk.MM[LibBouk.MP[LibBouk.RR["pe"]]["LP"]["MM"]]["MP"][LibBouk.MP[LibBouk.RR["pe"]]["LP"]["M"]])
func _on_jp_mouse_entered() -> void:
	PT[R["a"]].play("jp")
#func _on_el_pressed() -> void:
#	for i in PT:
#		if !i.script:i.visible=false
#		if i.name=="EL":i.visible=true
#		#for e in LibBouk.RR["MP"]:
#		#		if i.name=="MKP":
#		#			if len(LibBouk.MP[e].PP)>0:
#		#				i.visible=true
#		#				LibBouk.RR["pe"]=e
#		#				break
#		#			else:i.visible=false
#func _on_rt_pressed() -> void:
#	for i in PT:
#		if !i.script:i.visible=false
#		if i.name=="RT":i.visible=true
#func _on_rs_pressed() -> void:
#	for i in PT:
#		if !i.script:i.visible=false
#		if i.name=="P1":i.visible=true
#	LibBouk.daju("s")
func _on_ex_pressed() -> void:
	get_tree().quit()
func _on_ex_mouse_entered() -> void:
	PT[R["a"]].play("ex")
#func _on_ct_pressed() -> void:
#	LibBouk.R["CM"]="c"
#	#=============cargar la partida guardada"
#	catg(LibBouk.MM[LibBouk.MP[LibBouk.RR["pe"]]["LP"]["MM"]]["MP"][0])
#
#func _on_ct_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
#	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
#		for i in PT:
#			if i.name=="CONTR":
#				if i.visible:i.visible=false
#				else:i.visible=true
#				break
#func _on_lg_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
#	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
#		for i in PT:
#			if i.name=="LENGU":
#				if i.visible:i.visible=false
#				else:i.visible=true
#				break
#
#func _on_b_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
#	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
#		LibBouk.R["CT"]["ST"]["1"]="";cdct("")
#func _on_b_2_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
#	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
#		LibBouk.R["CT"]["ST"]["2"]="";cdct("")
#func _on_b_3_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
#	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
#		LibBouk.R["CT"]["ST"]["3"]="";cdct("")
#func _on_b_4_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
#	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
#		LibBouk.R["CT"]["ST"]["4"]="";cdct("")
#func _on_b_5_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
#	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
#		LibBouk.R["CT"]["ST"]["e"]="";cdct("")
#func _on_b_6_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
#	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
#		LibBouk.R["CT"]["ST"]["c"]="";cdct("")
#func _on_b_7_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
#	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
#		LibBouk.R["CT"]["ST"]["x"]="";cdct("")
#func _on_b_8_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
#	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
#		LibBouk.R["CT"]["ST"]["z"]="";cdct("")
#func _on_b_9_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
#	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
#		LibBouk.R["CT"]["ST"]["s"]="";cdct("")
#func _on_b_10_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
#	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
#		LibBouk.R["CT"]["ST"]["d"]="";cdct("")
#func _on_b_11_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
#	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
#		LibBouk.R["CT"]["ST"]["MENU"]="";cdct("")
func _on_p_pr_pressed() -> void:
	var file = RR.resource_path
	var json_as_text = FileAccess.get_file_as_string(file)
	var rr = JSON.parse_string(json_as_text)
	var e=EgLb.dado(0,len(rr["LPP"]),7)
	file = rr["LPP"][e]
	json_as_text = FileAccess.get_file_as_string(file)
	var c = JSON.parse_string(json_as_text)
	R["PP"].text=c["NM"]
func _on_p_pp_pressed() -> void:
	var file = RR.resource_path
	var json_as_text = FileAccess.get_file_as_string(file)
	var rr = JSON.parse_string(json_as_text)
	if !"e" in R:R["e"]=0
	R["e"]+=1
	if R["e"]>=len(rr["LPP"]):R["e"]=0
	file = rr["LPP"][R["e"]]
	json_as_text = FileAccess.get_file_as_string(file)
	var c = JSON.parse_string(json_as_text)
	R["PP"].text=c["NM"]
func _on_p_pn_pressed() -> void:
	var file = RR.resource_path
	var json_as_text = FileAccess.get_file_as_string(file)
	var rr = JSON.parse_string(json_as_text)
	if !"e" in R:R["e"]=0
	R["e"]-=1
	if R["e"]<0:R["e"]=len(rr["LPP"])-1
	file = rr["LPP"][R["e"]]
	json_as_text = FileAccess.get_file_as_string(file)
	var c = JSON.parse_string(json_as_text)
	R["PP"].text=c["NM"]
