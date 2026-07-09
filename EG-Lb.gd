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
func ordd(E):                   #ordenar targetas
	if len(E.ddd_tg)>0:
		var l:Array[d_tg]=[E.ddd_tg[0]];var f="0AMEQRL"
		for i in f:
			var x=1
			while x<len(E.ddd_tg):
				if E.ddd_tg[x].tiprrh==i and len(l)<E.io_0SC["Sps"]:l.append(E.ddd_tg[x])
				x+=1
		E.ddd_tg=l
func camb(E):                   # cambio de mano
	var po=false
	for i in E.RR["IV"]["I"]:
		if i.tiprrh=="0":po=true
	var ck=EgLb.dado(0,len(E.RR["IV"]["I"]))
	E.R["Dm"][0]=-1
	while po and E.R["Dm"][0]==-1:
		E.RR["IV"]["I"][ck].defn()
		if E.RR["IV"]["I"][ck].tiprrh=="0":E.R["Dm"][0]=ck
		ck=EgLb.dado(0,len(E.RR["IV"]["I"]))
	if E.R["Dm"][0]!=-1:
		print("ELEGIDO:",E.RR["IV"]["I"][E.R["Dm"][0]].resource_name)
		EgLb.aspe(E.RR["Md"],null,"","iv")
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
	for i in E.enbolt[x].RR["imbext"]:
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
				E.enbolt[x].defn()
				if e.ddd_tg.resource_name==E.enbolt[x].resource_name:
					ap=false;break
		elif i.split(":")[2]=="p":
			for e in E.RR["EV"]:
				if e.ddd_tg.resource_name==i.split(":")[0]:
					ap=true;break
	if ap:
		E.enbolt[x].defn()
		var f=preload("res://Evar_system_000/rqs/eev.tscn").instantiate()
		E.add_child.call_deferred(f)
		var uv=EgLb.dado(0,len(E.puntuv))
		f.ddd_tg=E.enbolt[x]
		f.PT.append(E);
		E.RR["EV"].append(f)
		EgLb.poci(f,uv,E)
		print("(EVECTO):> ",E.enbolt[x].resource_name)
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
	var xy=(E.puntuv[uv].split(";")[0].replace("(","").replace(")","")).split(",")
	p.global_position.x=(int(xy[0])*E.escall.x)+E.global_position.x
	p.global_position.y=(int(xy[1])*E.escall.y)+E.global_position.y
func aspe(E,oj=null,t="",tx=""):# aspecto de la interfase
	#================================================================#foco
	if t=="u":
		E.entblr=oj.RR["Tb"]
		E.ioenje.global_position=oj.RR["MK"].global_position
		#EgLb.bgls(E)
	if len(E.PT)>1 and E.entblr and E.entblr.focodc:
		E.global_position=E.entblr.focodc.global_position
		E.entblr.visible=true
	#if "CT2" in R:R["CT2"].visible=false
	
	#================================================================#imbentario
	var x=0;if E.ioenje:
		while x<len(E.R["IV"]):
			E.R["IV"][x].visible=false
			E.R["IV"][x].aspect[0].texture=null
			x+=1
		x=1
		while x<len(E.ioenje.RR["i0"]):
			E.R["IV"][x-1].visible=false
			E.R["IV"][x-1].aspect[0].texture=null
			E.R["IV"][x-1].aspect[0].texture=load(E.ioenje.RR["i0"][x].RR["imagen"])
			E.R["IV"][x-1].visible=true
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
	if "LSI" in E.R:
		x=0;for i in E.R["LSI"].PT:
			i.text=""
			if i.name.count("b"):
				if "kQ" in E.ioenje.R and len(E.ioenje.R["kQ"][2])<x:
					i.text=E.ioenje.R["kQ"][2][x]
					x+=1
				else:i.visible=false
		if "Dm" in E.ioenje.R:
			if E.ioenje.R["Dm"][0]!=-1:
				E.R["LSI"].ioenje.text=E.ioenje.ddd_tg[E.ioenje.R["Dm"][0]].resource_name#====================================Nombre
				E.R["LSI"].entblr.text=E.ioenje.RR["IV"]["D"][E.ioenje.R["Dm"][0]]
		if "kQ" in E.ioenje.R and E.ioenje.R["lQ"][E.ioenje.R["kQ"][0]]:E.R["LSI"].aspect[1].texture=E.ioenje.R["lQ"][E.ioenje.R["kQ"][0]].RR["imagen"]
		if "kQ" in E.ioenje.R and E.ioenje.R["lQ"][E.ioenje.R["kQ"][1]]:E.R["LSI"].aspect[2].texture=E.ioenje.R["lQ"][E.ioenje.R["kQ"][1]].RR["imagen"]
		if t=="n":
			E.R["LSI"].ioenje.text=oj.name
			E.R["LSI"].ioenje.text=EgLb.idio(R["LSI"].ioenje.text)
		if t=="t":
			E.R["LSI"].aspect[0].texture=load(oj.RR["imagen"])
			E.R["LSI"].ioenje.text=oj.resource_name
			E.R["LSI"].ioenje.text=EgLb.idio(R["LSI"].ioenje.text)
			E.R["LSI"].entblr.text=tx
			E.R["LSI"].entblr.text=EgLb.idio(R["LSI"].entblr.text)
		if "AC" in E.ioenje.R:
			var a=0;x=3;while x<len(E.R["LSI"].PT):
				if a<len(E.ioenje.R["AC"]):
					E.R["LSI"].PT[x].visible=true
					E.R["LSI"].PT[x].text=E.ioenje.R["AC"][a]
					a+=1
				x+=1
	if "Md" in E.RR:
		for i in E.RR["Md"].RR["TB"]:
			i.visible=false
	if E.entblr:E.entblr.visible=true
func cttb(E):                   # control de tableros
	E.R["PS"]=[]
	for e in E.mjugad:
		for i in e.R["PS"]:
			E.R["PS"].append(i)
func icpt(E):                   # inisio de carrga de partida
	E.R["PS"]=[E.ioenje]
	var x=2;while x<len(E.PT):
		if E.PT[x].name=="AA":E.R["aa"]=x
		x+=1
	if E.ioenje:E.ioenje.RR["Md"]=E
	if E.entblr:
		E.entblr.RR["Md"]=E
		for i in E.entblr.PT:
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
	if M:
		M.defn()
		var ct=0
		var y=0;while y<len(M.RR["a_cheq"]) and t==M.RR["intchq"]:
			for i in E.R["PS"]:#===========================#rebision de elemetos a chequear
				for e in i.etiggg:
					if e==M.RR["objchq"][y]:
						if M.RR["a_cheq"][y]==0:
							var x=0;while x <len(i.ddd_tg):
								if i.ddd_tg[x] and i.ddd_tg[x].resource_name==M.RR["crcidn"][y]:
									ct+=1
								x+=1
						#-------------------+
						if M.RR["a_cheq"][y]==1:
							var x=0;while x <len(i.R["II"]):
								if i.R["II"][x].etiggg[len(i.R["II"][x].etiggg)-1].count(M.RR["crcidn"][y])>0:
									ct+=1
								x+=1
						#-------------------+
						if M.RR["a_cheq"][y]==2 and len(i.R["II"])>0:#"iQ"
							var tu=null
							if i.R["II"][0].name=="P":tu=i.R["II"][0].ioenje
							else:tu=i.R["II"][0]
							var x=0;while x <len(tu.ddd_tg):
								tu.ddd_tg[x].defn()
								print("MS_iQ:",M.resource_name,tu.ddd_tg[x].resource_name,"==",M.RR["crcidn"][y])
								if tu.ddd_tg[x] and tu.ddd_tg[x].resource_name==M.RR["crcidn"][y]:
									ct+=1
								x+=1
			##===========================#prosesar resultados
			if ct>=M.RR["cntreq"][y]:
				print("MS_micion cumplida:",M.resource_name)
				if M.RR["trfcnd"][y]!="" and M.RR["trfcnd"][y]!="//Tg":
					var x=0;while x<len(E.R["PS"]):
						if E.R["PS"][x].ddd_tg and E.R["PS"][x].ddd_tg==load(M.RR["trfcnd"][y]):E.R["PS"][x].est_ig="0"
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
	if !c:
		for i in E.pasodt:
			if i.split(";")[0]==p.name:pz=i
		pz=pz.split(";")
	else:
		var y=0;while y<len(E.tabler):
			E.tabler[y].defn()
			print("!--:",E.tabler[y].resource_name," -:- ",p[1])
			if p[1].count(E.tabler[y].resource_name):break
			y+=1
		pz=["...",y,p[0]]
	var tb=-1;var x=0
	while x<len(E.RR["MM"]):
		E.tabler[int(pz[1])].defn()
		if E.RR["MM"][x].name.count(E.tabler[int(pz[1])].resource_name):tb=x
		x+=1
	if tb==-1:
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
	if !c:EgLb.poci(p.R["II"][0],int(pz[2]), E.RR["MM"][tb])
	else:EgLb.poci(c,int(pz[2]), E.RR["MM"][tb])
	E.mjugad[0].PT[E.mjugad[0].R["aa"]].play("finTb")
	E.mjugad[0].entblr=E.RR["MM"][tb]
	E.mjugad[0].R["PS"]=E.mjugad[0].R["PS"]+E.mjugad[0].entblr.PT
	EgLb.aspe(E.mjugad[0])
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
		if E.RR["TT"][0]==1:
			var y=0;while y<len(E.tablee):
				E.tablee[y].accion["AC"]+=1
				print("!!--:",E.tablee[y].accion["AC"])
				y+=1
		x+=1
func alqm(k,e,r):               # alquimia
	var y=0;while y<len(k):
		if k[y].split(":")[0]==e and k[y].split(":")[1]==r:
			e=k[y].split(":")[2]
			r=""
			break
		y+=1
	return [r,e]
func pisz(E):                   # interaccion
	if "II" in E.R and len(E.R["II"])>0 and E.R["II"][0].est_ig!="" and E.R["II"][0].ddd_tg:#comportamientoc
		#E.R["II"][0].cpp()
		if   E.R["II"][0].ddd_tg.RR["estrus"]==1:#-#Fruta
			#if true:
			#	EgLb.R["km"][3]+=1
			var s=false;var x=0
			if "IV" in E.RR and len(E.RR["IV"]["I"])<E.io_0SC["Sps"]:
				while x<len(E.RR["IV"]["I"]):
					if !E.RR["IV"]["I"][x]:
						if !("kg" in E.R["II"][0].RR):E.R["II"][0].RR["kg"]=""
						E.RR["IV"]["I"][x]=E.R["II"][0].ddd_tg
						E.RR["IV"]["K"][x]=E.R["II"][0].RR["kg"]
						s=true
						break
					x+=1
				if !s:
					E.R["II"][0].ddd_tg.defn()
					E.RR["IV"]["I"].append(E.R["II"][0].ddd_tg)
					if "kg" in E.R["II"][0].RR:E.RR["IV"]["K"].append(E.R["II"][0].RR["kg"])
					else:E.RR["IV"]["K"].append("")
					if "DS" in E.R["II"][0].RR:E.RR["IV"]["D"].append(E.R["II"][0].RR["DS"])
					else:E.RR["IV"]["D"].append("")
				E.R["II"][0].est_ig=""
			EgLb.kdpk(E)
		elif E.R["II"][0].ddd_tg.RR["estrus"]==4:#-#Interuptor
			if E.R["II"][0].RR["AA"][".+i"]:
				E.R["II"][0].PT[E.R["II"][0].R["a"]].play(E.R["II"][0].RR["AA"][".+i"].RR["acionn"])
		elif E.R["II"][0].ddd_tg.RR["estrus"]==5:#-#Puesto
			if E.R["II"][0].est_ig=="pz":
				E.R["II"][0].R["II"].append(E)
				E.R["II"][0].R["II"][0]=E
				E.R["II"][0].est_ig="PZ"
			#============================
			if E.R["Dm"][0]>-1 and E.RR["IV"]["I"][E.R["Dm"][0]] and "IV" in E.R["II"][0].RR:
				E.R["II"][0].RR["IV"]["I"].append(E.RR["IV"]["I"][E.R["Dm"][0]])
				E.R["II"][0].RR["IV"]["K"].append(E.RR["IV"]["K"][E.R["Dm"][0]])
				E.R["II"][0].RR["IV"]["D"].append(E.RR["IV"]["D"][E.R["Dm"][0]])
				#E.R["II"][0].R["ak"]=EgLb.maca(E.R["II"][0])
				E.RR["IV"]["I"].erase(E.RR["IV"]["I"][E.R["Dm"][0]])
				E.RR["IV"]["K"].erase(E.RR["IV"]["K"][E.R["Dm"][0]])
				E.RR["IV"]["D"].erase(E.RR["IV"]["D"][E.R["Dm"][0]])
				E.R["Dm"][0]=-1;R["Dm"][0]=-1
		EgLb.aspe(E.RR["Md"])
		E.R["IK"]=100
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
	if R["e"]<0:R["e"]=len(rr["LPP"]-1)
	file = rr["LPP"][R["e"]]
	json_as_text = FileAccess.get_file_as_string(file)
	var c = JSON.parse_string(json_as_text)
	R["PP"].text=c["NM"]
