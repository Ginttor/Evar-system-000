@tool extends Node

@export var dt:=""        ##direccion de targeta
@export var zm=0          ##semilla de creasion
@export var RR:JSON       ##pagina de ajutes
@export var MP:Array[JSON]##paginas de partida
@export var MM:Array[JSON]##paginas de partida
@export var PT:Array[Node]##binculado
var R:={}
var mp:={}
var mm:={}
var cg=""

func _ready() -> void:
	if Engine.is_editor_hint():
		pass
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
		fmtg()
	else:
		pass
#===================================#
func ccam(E,P):                 # correccion de posision de camara
	if P.global_position.x>E.R["CM"].global_position.x+E.R["P"][0].position.x:
		E.R["CM"].global_position.x+=P.global_position.x-(E.R["CM"].global_position.x+E.R["P"][0].position.x)
		if E.entblr and E.entblr.spcmap:
			E.entblr.spcmap.rotation-=0.001
			E.ioenje.velocity.x=0
	if P.global_position.x<E.R["CM"].global_position.x-E.R["P"][0].position.x:
		E.R["CM"].global_position.x+=P.global_position.x-(E.R["CM"].global_position.x-E.R["P"][0].position.x)
		if E.entblr and E.entblr.spcmap:
			E.entblr.spcmap.rotation+=0.001
			E.ioenje.velocity.x=0
	if P.global_position.y>E.R["CM"].global_position.y+E.R["P"][0].position.y:E.R["CM"].global_position.y+=P.global_position.y-(E.R["CM"].global_position.y+E.R["P"][0].position.y)
	if P.global_position.y<E.R["CM"].global_position.y-E.R["P"][0].position.y:E.R["CM"].global_position.y+=P.global_position.y-(E.R["CM"].global_position.y-E.R["P"][0].position.y)
func camb(E):                   # cambio de mano
	var po=false
	for i in E.RR["IV"]["I"]:
		if i.tiprrh=="0":po=true
	var ck=EgLb.dado(0,len(E.RR["IV"]["I"]))
	E.R["Dm"][0]=-1
	while po and E.R["Dm"][0]==-1:
		EgLb.defn(E.RR["IV"]["I"][ck])
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
func ilos(E,h):                 # hilos
	var x=0
	if !"PH" in E.R:
		E.R["PH"]=[];while x<len(h):
			E.R["PH"].append(Vector3i(0,0,0))
			x+=1
	x=0;while x<len(h):
		if Input.is_action_pressed(h[x]):
			if E.R["PH"][x].x>0 and E.R["PH"][x].x<10 and E.R["PH"][x].z<10:E.R["PH"][x].z+=1
			E.R["PH"][x].x=10
			if E.R["PH"][x].y<10:E.R["PH"][x].y+=1
		else:
			if E.R["PH"][x].x>0:E.R["PH"][x].x-=1
		if E.R["PH"][x].z<0:E.R["PH"][x].z=0
		x+=1
	#-------------------------------------------
	x=0
	if !"KM" in E.R and "PH" in E.R:
		E.R["KM"]=[];while x<len(E.R["PH"]):
			E.R["KM"].append(".")
			x+=1
	if "PH" in E.R:while x<len(E.R["PH"]):
		E.R["KM"][x]="."
		if E.R["PH"][x].x==1  and E.R["PH"][x].y>=0 and  E.R["PH"][x].y<=10 and E.R["PH"][x].z==0:E.R["KM"][x]="i"
		if E.R["PH"][x].y==10 and E.R["PH"][x].y>=2 and E.R["PH"][x].z==0:E.R["KM"][x]="a"
		if E.R["PH"][x].z>0:E.R["KM"][x]="k"
		
		if E.R["PH"][x].x==0 and E.R["PH"][x].y>0:E.R["PH"][x].y=0
		if E.R["PH"][x].x==0 and E.R["PH"][x].z>0:E.R["PH"][x].z=-1
		x+=1
		#print(E.R["KM"])
func atlz(E,x):                 # atlas
	var ap=false
	for i in E.events[x].RR["imbext"]:
		if   i==":0:":ap=true
		elif i.split(":")[2]=="":
			var e=0
			while e <len(E.recerv["IV"]):
				EgLb.defn(E.recerv["IV"][e])
				if E.recerv["IV"][e].resource_name==i.split(":")[0] and E.recerv["CR"][e]>=int(i.split(":")[1]):
					E.recerv["CR"][e]-=int(i.split(":")[1]);ap=true;break
				e+=1
		elif i.split(":")[2]=="y":
			ap=true
			for e in E.RR["EV"]:
				EgLb.defn(E.events[x])
				if e.ddd_tg.resource_name==E.events[x].resource_name:
					ap=false;break
		elif i.split(":")[2]=="p":
			for e in E.RR["EV"]:
				if e.ddd_tg.resource_name==i.split(":")[0]:
					ap=true;break
	if ap:
		EgLb.defn(E.events[x])
		var f=preload("res://Evar system 000/rqs/eev.tscn").instantiate()
		E.add_child.call_deferred(f)
		var uv=dado(0,len(E.puntuv))
		f.ddd_tg=E.events[x]
		f.PT.append(E);
		E.RR["EV"].append(f)
		EgLb.poci(f,uv,E)
		print("(EVECTO):> ",E.events[x].resource_name)
func barj(l):                   # baragear
	var ll:Array[d_tg]
	while len(l)>0:
		var e=EgLb.dado(0,len(l))
		ll.append(l[e])
		l.erase(l[e])
	print("(BARAGEO):> ",ll)
	return ll
func stcl(E,l: int, e: bool):#cambiar colision
	if e:
		E.collision_mask |= (1 << (l - 1))
	else:
		E.collision_mask &= ~(1 << (l - 1))
func motr(E):                   # motor
	if "BP" in E.R and "KM" in E.R:
		if "DV" in E.AA:
			var el=EgLb.dado(0,69,96)
			if el==0:
				var y=0;while y < len(E.R["KM"]):
					E.R["KM"][y]="."
					y+=1
			var ap=true
			for i in E.R["KM"]:
				if i!=".":ap=false
			if ap:
				el=EgLb.dado(0,4,96)
				E.R["KM"][el]="a"
		#------------------------------------------------------------
		for i in E.AA:
			if i!="" and  E.AA[i]:
				var ej=""
				if   E.AA[i].RR["activv"][1][0]=="Q":
					if   E.R["KM"][0]==E.AA[i].RR["activv"][1][1]:ej="0"
					elif E.R["KM"][1]==E.AA[i].RR["activv"][1][1]:ej="1"
					if   E.R["KM"][2]==E.AA[i].RR["activv"][1][1]:ej="2"
					elif E.R["KM"][3]==E.AA[i].RR["activv"][1][1]:ej="3"
				elif E.AA[i].RR["activv"][1][0]!="Q" and E.R["KM"][int(E.AA[i].RR["activv"][1][0])]==E.AA[i].RR["activv"][1][1]:ej=E.AA[i].RR["activv"][1][0]
				if E.AA[i].RR["activv"][1].count("-"):
					var aaaa=E.AA[i].RR["activv"][1].split("-")
					for y in aaaa:
						if y[0]!="Q" and E.R["KM"][int(y[0])]!=y[1]:ej="";break
				if ej!="":
					if   i=="M":#-----------------------------------------#caminar
						if   E.R["KM"][0]!="." and E.velocity.y>-E.RR["io"]["Vel"]:E.R["FF"][0].y=-E.RR["io"]["Acl"]
						elif E.R["KM"][1]!="." and E.velocity.y< E.RR["io"]["Vel"]:E.R["FF"][0].y= E.RR["io"]["Acl"]
						if   E.R["KM"][2]!="." and E.velocity.x< E.RR["io"]["Vel"]:E.R["FF"][0].x= E.RR["io"]["Acl"]
						elif E.R["KM"][3]!="." and E.velocity.x>-E.RR["io"]["Vel"]:E.R["FF"][0].x=-E.RR["io"]["Acl"]
						EgLb.stcl(E,2,true)
						E.PT[E.R["a"]].play(E.AA[i].RR["acionn"])
					elif i=="R":#-----------------------------------------#rotar
						if "BI" in E.R and E.R["KM"][2]!=".":E.PT[E.R["BI"]].scale.x= 1
						if "BI" in E.R and E.R["KM"][3]!=".":E.PT[E.R["BI"]].scale.x=-1
						E.PT[E.R["a"]].play(E.AA[i].RR["acionn"])
					elif i=="D":#-----------------------------------------#dash
						if   E.R["KM"][0]!="." and E.velocity.y>-E.RR["io"]["Vel"]:E.R["FF"][0].y=-E.RR["io"]["Pot"]*2
						elif E.R["KM"][1]!="." and E.velocity.y< E.RR["io"]["Vel"]:E.R["FF"][0].y= E.RR["io"]["Pot"]*2
						if   E.R["KM"][2]!="." and E.velocity.x< E.RR["io"]["Vel"]:E.R["FF"][0].x= E.RR["io"]["Pot"]*2
						elif E.R["KM"][3]!="." and E.velocity.x>-E.RR["io"]["Vel"]:E.R["FF"][0].x=-E.RR["io"]["Pot"]*2
						E.PT[E.R["a"]].play(E.AA[i].RR["acionn"])
					elif i=="S":#-----------------------------------------#salto
						if E.R["M"][0].count("f"):
							E.velocity.y=-E.RR["io"]["Pot"]*9
							E.PT[E.R["a"]].play(E.AA[i].RR["acionn"])
							EgLb.stcl(E,2,false)
					elif i=="SK" and E.R["fp"]:#--------------------------#escalar
						E.velocity.y=-E.RR["io"]["Vel"]
						E.R["FF"][0].y=0
						E.PT[E.R["a"]].play(E.AA[i].RR["acionn"])
						EgLb.stcl(E,2,false)
					elif i=="DV":E.PT[E.R["a"]].play(E.AA[i].RR["acionn"])
	if "BP" in E.R and E.PT[E.R["BP"]].position.x!=0:
		if   E.PT[E.R["BP"]].position.x<0 and E.R["FF"][0].x>0:E.R["FF"][0].x=0
		elif E.PT[E.R["BP"]].position.x>0 and E.R["FF"][0].x<0:E.R["FF"][0].x=0
		if E.PT[E.R["BP"]].position.x!=0:E.PT[E.R["BP"]].position.x=0
func girk(E):                   # giroscopio
	if !"FF" in E.R:
		E.R["FF"]=[Vector3i(0,0,0),Vector3i(0,0,0)]
	if E.R["FF"][0].x==0 and "BP" in E.R:
		if E.velocity.x> E.RR["io"]["Sti"]:
			E.velocity.x-=E.RR["io"]["Sti"]
		elif E.velocity.x>0:E.velocity.x-=1
					
		if E.velocity.x<-E.RR["io"]["Sti"]:E.velocity.x+=E.RR["io"]["Sti"]
		elif E.velocity.x<0:E.velocity.x+=1
	if E.R["FF"][0].y==0 and "BP" in E.R:
		if E.velocity.y> E.RR["io"]["Sti"]:E.velocity.y-=E.RR["io"]["Sti"]
		elif E.velocity.y>0:E.velocity.y-=1
					
		if E.velocity.y<-E.RR["io"]["Sti"]:E.velocity.y+=E.RR["io"]["Sti"]
		elif E.velocity.y<0:E.velocity.y+=1
	E.R["FF"][1]=Vector3i(0,0,0)
	if "Fz" in E.RR and "BP" in E.R:
		if ! "M" in E.R:E.R["M"]=["",""]
		if "M" in E.R and E.R["M"][0].count("f")==0:E.velocity.y+=(E.RR["Fz"].y*E.RR["io"]["Mas"])*3
		if E.PT[E.R["BP"]].position.y>0:
			E.PT[E.R["BP"]].position.y=0
	if "BP" in E.R:
		E.velocity.x+=E.R["FF"][1].x+E.R["FF"][0].x
		E.velocity.y+=E.R["FF"][1].y+E.R["FF"][0].y
		E.move_and_slide()
		E.R["FF"][0]=Vector3i(0,0,0)
func tabl(E,s):                 # marcasion de tablero
	if s:
		if "Tg" in E.RR and E.RR["Tg"]==null:
			E.RR["TN"]=Vector3i(0,1,0)
		if !E.focodc:E.focodc=$"."
		if !"F" in E.mallat:E.mallat["F"]=false
		if len(E.puntuv)==0:
			var p=E.mallat["P"]
			while p.x>=E.mallat["N"].x:
				p.y=E.mallat["P"].y
				while p.y<=E.mallat["N"].y:
					E.puntuv.append("("+str(p.x)+","+str(p.y)+");LV;")
					p.y+=1
				p.x-=1
		if len(E.R["TTb"])!=len(E.puntuv):
			E.R["TTb"]=[]
			var x=0;while x<len(E.puntuv):
				var f=preload("res://Evar system 000/rqs/p.tscn").instantiate()
				E.add_child.call_deferred(f)
				EgLb.poci(f,x,E)
				E.R["TTb"].append(f)
				x+=1
func poci(p,uv,E):              # posisionamiento de pieza
	var xy=(E.puntuv[uv].split(";")[0].replace("(","").replace(")","")).split(",")
	p.global_position.x=(int(xy[0])*E.escall.x)+E.global_position.x
	p.global_position.y=(int(xy[1])*E.escall.y)+E.global_position.y
func kdpk(E):                   # clasificasion de paquetes
	E.R["lA"]=[];E.R["lM"]=[];E.R["lE"]=[];E.R["lQ"]=[];E.R["lR"]=[];E.R["lL"]=[]
	if "IV" in E.RR:
		var x=0;while x<len(E.RR["IV"]["I"]):
			var tp=[
				E.RR["IV"]["I"][x].rrinfo.count("A!"),
				E.RR["IV"]["I"][x].rrinfo.count("M!"),
				E.RR["IV"]["I"][x].rrinfo.count("E!"),
				E.RR["IV"]["I"][x].rrinfo.count("Q!"),
				E.RR["IV"]["I"][x].rrinfo.count("R!"),
				E.RR["IV"]["I"][x].rrinfo.count("L!"),
			]
			var tteiv=tp[0]+tp[1]+tp[2]+tp[3]+tp[4]+tp[5]
			if E.RR["IV"]["I"][x] and (tp[0] or (tteiv==0 and E.ddd_tg.rrinfo.count("Aa"))) and len(E.R["lA"])<E.ddd_tg.RR["lem_ak"]["A"]:E.R["lA"].append(x)
			if E.RR["IV"]["I"][x] and (tp[1] or (tteiv==0 and E.ddd_tg.rrinfo.count("Mm"))) and len(E.R["lM"])<E.ddd_tg.RR["lem_ak"]["M"]:E.R["lM"].append(x)
			if E.RR["IV"]["I"][x] and (tp[2] or (tteiv==0 and E.ddd_tg.rrinfo.count("Ee"))) and len(E.R["lE"])<E.ddd_tg.RR["lem_ak"]["E"]:E.R["lE"].append(x)
			if E.RR["IV"]["I"][x] and (tp[3] or (tteiv==0 and E.ddd_tg.rrinfo.count("Qq"))) and len(E.R["lQ"])<E.ddd_tg.RR["lem_ak"]["Q"]:E.R["lQ"].append(x)
			if E.RR["IV"]["I"][x] and (tp[4] or (tteiv==0 and E.ddd_tg.rrinfo.count("Rr"))) and len(E.R["lR"])<E.ddd_tg.RR["lem_ak"]["R"]:E.R["lR"].append(x)
			if E.RR["IV"]["I"][x] and (tp[5] or (tteiv==0 and E.ddd_tg.rrinfo.count("Ll"))) and len(E.R["lL"])<E.ddd_tg.RR["lem_ak"]["L"]:E.R["lL"].append(x)
			x+=1
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
		x=0
		while x<len(E.ioenje.RR["IV"]["I"]):
			E.R["IV"][x].visible=false
			E.R["IV"][x].aspect[0].texture=null
			E.R["IV"][x].aspect[0].texture=load(E.ioenje.RR["IV"]["I"][x].RR["imagen"])
			E.R["IV"][x].visible=true
			#-----------------------
			#if E.ioenje.R["lQ"][x]!=-1:
			#	if E.ioenje.RR["IV"]["K"][E.ioenje.R["lQ"][x]]=="":
			#		E.R["IV"][x].aspect[0].texture=load(E.ioenje.RR["IV"]["I"][E.ioenje.R["lQ"][x]].RR["imagen"])
			#	else:
			#		var y=0;while y<len(E.ioenje.RR["IV"]["I"][E.ioenje.R["lQ"][x]].Tar_Q_.rutass):
			#			if E.ioenje.RR["IV"]["I"][E.ioenje.R["lQ"][x]].Tar_Q_.rutass[y].split(";")[2]==E.ioenje.RR["IV"]["K"][x]:
			#				E.R["IV"][x].aspect[0].texture=E.ioenje.RR["IV"]["I"][E.ioenje.R["lQ"][x]].Tar_Q_.imlist[y]
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
				E.R["LSI"].ioenje.text=E.ioenje.RR["IV"]["I"][E.ioenje.R["Dm"][0]].resource_name#====================================Nombre
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
func defn(t):                   # establese el nombre de un recurso
	var m=t.resource_path.split("/")
	t.resource_name=m[len(m)-1].split(".")[0]
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
		EgLb.defn(M)
		var ct=0;var _g=null
		var y=0;while y<len(M.RR["a_cheq"]) and t==M.RR["intchq"]:
			for i in E.R["PS"]:#===========================#rebision de elemetos a chequear
				var pj=M.RR["objchq"][y]
				if pj=="":pj=E.ioenje.ddd_tg.resource_path
				pj=load(pj)
				EgLb.defn(pj)
				if i.ddd_tg:EgLb.defn(i.ddd_tg)
				if i.ddd_tg and i.ddd_tg==pj and pj:
					if M.RR["a_cheq"][y]==0:
						var x=0;while x <len(i.RR["IV"]["I"]):
							if i.RR["IV"]["I"][x] and i.RR["IV"]["I"][x].resource_name==M.RR["crcidn"][y]:
								ct+=1
								_g=i
							x+=1
					#-------------------+
					if M.RR["a_cheq"][y]==1:#"kQ":
						var x=0;while x <len(i.R["lQ"][1]):
							if i.R["lQ"][1][x].resource_name==M.RR["crcidn"][y]:
								ct+=int(i.R["lQ"][1])
								if "PJ" in E.RR:
									for e in E.R["tL"]:
										if E.ioenje==e:_g=E.ioenje
							x+=1
					#-------------------+
					if M.RR["a_cheq"][y]==2 and len(i.R["II"])>0:#"iQ"
						var tu=null
						if i.R["II"][0].name=="P":tu=i.R["II"][0].ioenje
						else:tu=i.R["II"][0]
						var x=0;while x <len(tu.RR["IV"]["I"]):
							EgLb.defn(tu.RR["IV"]["I"][x])
							print("MS_iQ:",M.resource_name,tu.RR["IV"]["I"][x].resource_name,"==",M.RR["crcidn"][y])
							if tu.RR["IV"]["I"][x] and tu.RR["IV"]["I"][x].resource_name==M.RR["crcidn"][y]:
								ct+=1
								_g=tu
							x+=1
			if ct>=M.RR["cntreq"][y]:
				print("MS_micion cumplida:",M.resource_name)
				if !("FM" in E.RR):
					pass
					#for i in mjugad:
					#	if i.ioenje..name==g..name:
					#		if len(EgLb.RR["PA"]) and i.EgLb.RR["PA"].revisi["victorias"]:
					#			EgLb.R["II"][5]+=1
				else:
					pass
					#problema de puntuasion de victorias
					#if E.ioenje..name==g..name and len(EgLb.RR["PA"]) and EgLb.RR["PA"].revisi["victorias"]:
					#	EgLb.R["II"][5]+=1
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
			EgLb.defn(E.tabler[y])
			print("!--:",E.tabler[y].resource_name," -:- ",p[1])
			if p[1].count(E.tabler[y].resource_name):break
			y+=1
		pz=["...",y,p[0]]
	var tb=-1;var x=0
	while x<len(E.RR["MM"]):
		defn(E.tabler[int(pz[1])])
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
		EgLb.chmt(E,x)
		x+=1
func chmt(E,t):                 # kuez
	var y=0
	var x=0;if "KZ" in E.RR:
		x=0;while x<len(E.RR["KS"]):#========#nueva asignasionn de kues
			y=0;while y<len(E.RR["KZ"]):
				if EgLb.dado(0,100,6)<5 and E.RR["KZ"][y]==null and E.RR["CK"][x]>=0:
					EgLb.defn(E.RR["KS"][x])
					E.RR["KZ"][y]=E.RR["KS"][x]
					E.RR["RK"][y]=""
					print("KZ_ACTIVANDO:",E.RR["KZ"][y].resource_name)
					#EgLb.dmod(EgLb.RR["pe"],"s",R["PS"])
					#for i in EgLb.MP[EgLb.RR["pe"]]["IP"]:
					#	for p in E.R["PS"]:
					#		if p.name==i:
					#			EgLb.dper(i,"s",p)
				y+=1
			x+=1
		x=0;while x<len(E.RR["KZ"]):
			var r:="";if E.RR["KZ"][x]:#==================================#ejecusion de kues
				y=0;while y<len(E.RR["KZ"][x].RR["ruatas"]):
					if E.RR["KZ"][x].RR["ruatas"][y].split(";")[0]==E.RR["RK"][x] and E.RR["KZ"][x].RR["intrpt"][y]:
						r=EgLb.miti(E.mjugad[EgLb.dado(0,len(E.mjugad))],load(E.RR["KZ"][x].RR["intrpt"][y]),t)
						if r!="":print("KZ_en revision:",E.RR["KZ"][x].resource_name," <r>:",r)
						break
					y+=1
			if E.RR["KZ"][x] and r!="":#==================================#prosesar resultados de kues
				var sd=EgLb.alqm(E.RR["KZ"][x].RR["ruatas"],E.RR["RK"][x],r)
				r=sd[0]
				E.RR["RK"][x]=sd[1]
				print("KZ_resultado de:",E.RR["KZ"][x].resource_name," =>",E.RR["RK"][x])
			y=0;while y<len(E.RR["CK"]):#==================================#finalizar kues
				if E.RR["KZ"][x]==E.RR["KS"][y] and E.RR["RK"][x].count(".")>0:
					E.RR["CK"][y]=int(E.RR["CK"][y])
					if   E.RR["CK"][y]==1:E.RR["CK"][y]=-1
					elif E.RR["CK"][y]>=1:E.RR["CK"][y]-=1
					print("KZ_finalisada:",E.RR["KZ"][x].resource_name,"(",E.RR["CK"][y],")")
					E.RR["KZ"][x]=null
					break
				y+=1
			x+=1
func alqm(k,e,r):               # alquimia
	var y=0;while y<len(k):
		if k[y].split(";")[0]==e and k[y].split(";")[1]==r:
			e=k[y].split(";")[2]
			r=""
			break
		y+=1
	return [r,e]
func pisz(E):                   # interaccion
	if "II" in E.R and len(E.R["II"])>0 and E.R["II"][0].est_ig!="" and E.R["II"][0].ddd_tg:#comportamientoc
		#E.R["II"][0].cpp()
		if   E.R["II"][0].ddd_tg.RR["estres"]==1:#-#Fruta
			#if true:
			#	EgLb.R["km"][3]+=1
			var s=false;var x=0
			if "IV" in E.RR and len(E.RR["IV"]["I"])<E.RR["io"]["Sps"]:
				while x<len(E.RR["IV"]["I"]):
					if !E.RR["IV"]["I"][x]:
						if !("kg" in E.R["II"][0].RR):E.R["II"][0].RR["kg"]=""
						E.RR["IV"]["I"][x]=E.R["II"][0].ddd_tg
						E.RR["IV"]["K"][x]=E.R["II"][0].RR["kg"]
						s=true
						break
					x+=1
				if !s:
					EgLb.defn(E.R["II"][0].ddd_tg)
					E.RR["IV"]["I"].append(E.R["II"][0].ddd_tg)
					if "kg" in E.R["II"][0].RR:E.RR["IV"]["K"].append(E.R["II"][0].RR["kg"])
					else:E.RR["IV"]["K"].append("")
					if "DS" in E.R["II"][0].RR:E.RR["IV"]["D"].append(E.R["II"][0].RR["DS"])
					else:E.RR["IV"]["D"].append("")
				E.R["II"][0].est_ig=""
			EgLb.kdpk(E)
		elif E.R["II"][0].ddd_tg.RR["estres"]==4:#-#Interuptor
			if E.R["II"][0].RR["AA"][".+i"]:
				E.R["II"][0].PT[E.R["II"][0].R["a"]].play(E.R["II"][0].RR["AA"][".+i"].RR["acionn"])
		elif E.R["II"][0].ddd_tg.RR["estres"]==5:#-#Puesto
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
func sttr(E):                   # estructurar
	var x=0;while x < len(E.PT):
		E.R["IK"]=100
		if E.ddd_tg.tiprrh=="0" and E.ddd_tg.RR["estres"]==0:
			var y=0;E.R["KM"]=[];while y<11:
				E.R["KM"].append(".")
				y+=1
		if E.PT[x].name=="P":E.R["BP"]=x
		if E.PT[x].name=="i":E.R["BI"]=x
		if E.PT[x].name=="AA"  :
			E.R["a"]=x
			if E.ddd_tg and !"M" in E.AA:E.AA["M"]=null
			if "markks" in E.ddd_tg.RR:
				for i in E.ddd_tg.RR["markks"]:
					if   load(i).RR["lin_og"]==1 and !"R" in E.AA:E.AA["R"]=load(i)
					elif load(i).RR["lin_og"]==3 and !"D" in E.AA:E.AA["D"]=load(i)
					elif load(i).RR["lin_og"]==4 and !"S" in E.AA:E.AA["S"]=load(i)
					elif load(i).RR["lin_og"]==6 and !"SK" in E.AA:E.AA["SK"]=load(i)
					elif load(i).RR["lin_og"]==8 and !"DV" in E.AA:E.AA["DV"]=load(i)
					elif load(i).RR["lin_og"]==9 and !"AG" in E.AA:E.AA["AG"]=load(i)
		if E.script==load("res://Evar system 000/E-Pz.gd"):
			if !"io" in E.RR:
				E.RR["io"]={##estadisticas de carga
				"Vel":0,#velocidad maxima
				"Mac":0,#acelerasion maxima
				"Acl":0,#aselerasion
				"Pot":0,#potencia
				"Mas":0,#masa
				"Sti":0,#stabilidad
				"Sps":0,#espasio
				}
		if "SK" in E.AA:E.R["fp"]=false
		if E.RR["io"]["Sps"]>0:
			if "IV" in E.RR:
				E.R["Dm"]=[-1] #en lamno del dedo
				if !E.RR["IV"]:
					E.RR["IV"]={
						"I":[],#objeto
						"K":[],#cargas
						"D":[],#descripsion o grabados
						}
					EgLb.camb($".")
		x+=1
func fmtg():                    # formato de tarjeta
	if dt!="":
			var tg=load(dt)
			if len(tg.RR)==0:
					if   tg.tiprrh=="0":
						tg.RR={
							"estres": 0,        ##iestructura de esensia
							"imagen": "//imagen",    ##imagen de referensia
							"descri": "...",      ##descripsion
							"io_0SC": {##estadisticas de carga
								"Vel": 0,#velocidad maxima
								"Mac": 2,#acelerasion maxima
								"Acl": 3,#aselerasion
								"Pot": 4,#potencia
								"Mas": 1,#masa
								"Sti": 1,#stabilidad
								"Sps": 1,#espasio
								},
							"lem_ak": {##limite de acumulasiones
								"A": 0,
								"M": 0,
								"E": 0,
								"Q": 0,
								"R": 0,
								"L": 0,
								},
							"fin_es": "//esena",      ##forma fisica
							"markks": ["//!=(0,1,9)"],      ##marcas caracteristicas
						}
					elif tg.tiprrh=="A":
						tg.RR={
							"efects":["","","",""]
						}
					elif tg.tiprrh=="M":
						tg.RR={
							"activv": [0,""],
							"costos": ["E",1],
							"lin_og": 0,
							"acionn": "AA"
						}
					elif tg.tiprrh=="E":
						tg.RR={
							"a_cheq":[0],#0-9
							"intchq":0,
							"timlim":0,
							"objchq":["//0"],#objeto a chequear
							"crcidn":["ojo"],
							"cntreq":[0],#cantidad para ser 
							"aareco":["AA"],  
							"trfcnd":["//Tg"],#trofeo a dar
							"castig":["AA"],
							"cstapl":["//Tg"]
						}
					elif tg.tiprrh=="Q":
						tg.RR={
							"ruatas":["estado:elemento de estado:resultado:cargas"],
							"efecto":["//A"],
							"reaccn":["AA"],
							"intrpt":["//E"],
							"lstimg":["//img"],
							"rsiduo":["//Tg"]
						}
					elif tg.tiprrh=="R":
						tg.RR={
							"marcaa": "",
							"efecto": ["//A"]
						}
					elif tg.tiprrh=="L":
						tg.RR={
							"ejecus":0,#a=ambiente
							"imbmin":["//Tg"],
							"imbext":[":0:"]
						}
			tg.rrinfo=""
			if "markks" in tg.RR:
				var tipo=[false,false,false,false,false,false,]
				for i in tg.RR["markks"]:
					if i!="//!=(0,1,9)" and load(i).tiprrh=="A":tipo[0]=true
					if i!="//!=(0,1,9)" and load(i).tiprrh=="M":tipo[1]=true
					if i!="//!=(0,1,9)" and load(i).tiprrh=="E":tipo[2]=true
					if i!="//!=(0,1,9)" and load(i).tiprrh=="Q":tipo[3]=true
					if i!="//!=(0,1,9)" and load(i).tiprrh=="R":tipo[4]=true
					if i!="//!=(0,1,9)" and load(i).tiprrh=="L":tipo[5]=true
				var m=""
				if tipo[0]:m+="A"
				if tg.RR["lem_ak"]["A"]>0:m+="a"
				if tipo[1]:m+="M"
				if tg.RR["lem_ak"]["M"]>0:m+="m"
				if tipo[2]:m+="E"
				if tg.RR["lem_ak"]["E"]>0:m+="e"
				if tipo[3]:m+="Q"
				if tg.RR["lem_ak"]["Q"]>0:m+="q"
				if tipo[4]:m+="R"
				if tg.RR["lem_ak"]["R"]>0:m+="r"
				if tipo[5]:m+="L"
				if tg.RR["lem_ak"]["L"]>0:m+="l"
				tg.rrinfo+="Marcas: "+m+"\n"
			if "estres" in tg.RR:
				if   tg.RR["estres"]%5==0:tg.rrinfo+="Estructura: 0=personaje\n"
				elif tg.RR["estres"]%5==1:tg.rrinfo+="Estructura: 1=objeto\n"
				elif tg.RR["estres"]%5==2:tg.rrinfo+="Estructura: 2=equipo\n"
				elif tg.RR["estres"]%5==3:tg.rrinfo+="Estructura: 3=inmobiliario\n"
				elif tg.RR["estres"]%5==4:tg.rrinfo+="Estructura: 4=estructura\n"
			if "ejecus" in tg.RR:
				if   tg.RR["ejecus"]%13==0:tg.rrinfo+="Eventualidad: 0=ambiente.        {o}\n"
				elif tg.RR["ejecus"]%13==1:tg.rrinfo+="Eventualidad: 1=entre en esena.  _o_\n"
				elif tg.RR["ejecus"]%13==2:tg.rrinfo+="Eventualidad: 2=emboscada.       >o<\n"
				elif tg.RR["ejecus"]%13==3:tg.rrinfo+="Eventualidad: 3=persecusion      >>o\n"
				elif tg.RR["ejecus"]%13==4:tg.rrinfo+="Eventualidad: 4=inbestigar       [o]\n"
				elif tg.RR["ejecus"]%13==5:tg.rrinfo+="Eventualidad: 5=estar            (o)\n"
				elif tg.RR["ejecus"]%13==6:tg.rrinfo+="Eventualidad: 6=oficio           _o0\n"
				elif tg.RR["ejecus"]%13==7:tg.rrinfo+="Eventualidad: 7=surgir           o_o\n"
				elif tg.RR["ejecus"]%13==8:tg.rrinfo+="Eventualidad: 8=encontrado       o<Q\n"
				elif tg.RR["ejecus"]%13==9:tg.rrinfo+="Eventualidad: 9=rutina           &o&\n"
				elif tg.RR["ejecus"]%13==10:tg.rrinfo+="Eventualidad: 10=emcarnar         }o{\n"
				elif tg.RR["ejecus"]%13==11:tg.rrinfo+="Eventualidad: 11=momento magico   JoL\n"
				elif tg.RR["ejecus"]%13==12:tg.rrinfo+="Eventualidad: 12=conflicto        oxo\n"
			if "lin_og" in tg.RR:
				var tl=10
				if   tg.RR["lin_og"]%tl==0:tg.rrinfo+="Funsion organica: 0=accion\n"
				elif tg.RR["lin_og"]%tl==1:tg.rrinfo+="Funsion organica: 1=orientar x\n"
				elif tg.RR["lin_og"]%tl==2:tg.rrinfo+="Funsion organica: 2=orientar y\n"
				elif tg.RR["lin_og"]%tl==3:tg.rrinfo+="Funsion organica: 3=dash xx\n"
				elif tg.RR["lin_og"]%tl==4:tg.rrinfo+="Funsion organica: 4=esalto +y\n"
				elif tg.RR["lin_og"]%tl==5:tg.rrinfo+="Funsion organica: 5=en picada -y\n"
				elif tg.RR["lin_og"]%tl==6:tg.rrinfo+="Funsion organica: 6=escalar\n"
				elif tg.RR["lin_og"]%tl==7:tg.rrinfo+="Funsion organica: 7=recuperacion\n"
				elif tg.RR["lin_og"]%tl==8:tg.rrinfo+="Funsion organica: 8=divagar\n"
				elif tg.RR["lin_og"]%tl==9:tg.rrinfo+="Funsion organica: 9=agarrar\n"
			if "activv" in tg.RR:
				var tl=27
				if   tg.RR["activv"][0]%tl==0:tg.RR["activv"][1]="Qai"
				elif tg.RR["activv"][0]%tl==-1:tg.RR["activv"][1]="tt"
				elif tg.RR["activv"][0]%tl==1:tg.RR["activv"][1]="Qa"
				elif tg.RR["activv"][0]%tl==2:tg.RR["activv"][1]="Qk"
				elif tg.RR["activv"][0]%tl==3:tg.RR["activv"][1]="0i"
				elif tg.RR["activv"][0]%tl==4:tg.RR["activv"][1]="0a"
				elif tg.RR["activv"][0]%tl==5:tg.RR["activv"][1]="0k"
				elif tg.RR["activv"][0]%tl==6:tg.RR["activv"][1]="1i"
				elif tg.RR["activv"][0]%tl==7:tg.RR["activv"][1]="1a"
				elif tg.RR["activv"][0]%tl==8:tg.RR["activv"][1]="1k"
				elif tg.RR["activv"][0]%tl==9:tg.RR["activv"][1]="2i"
				elif tg.RR["activv"][0]%tl==10:tg.RR["activv"][1]="2a"
				elif tg.RR["activv"][0]%tl==11:tg.RR["activv"][1]="2k"
				elif tg.RR["activv"][0]%tl==12:tg.RR["activv"][1]="3i"
				elif tg.RR["activv"][0]%tl==13:tg.RR["activv"][1]="3a"
				elif tg.RR["activv"][0]%tl==14:tg.RR["activv"][1]="3k"
				elif tg.RR["activv"][0]%tl==15:tg.RR["activv"][1]="4i"
				elif tg.RR["activv"][0]%tl==16:tg.RR["activv"][1]="4a"
				elif tg.RR["activv"][0]%tl==17:tg.RR["activv"][1]="4k"
				elif tg.RR["activv"][0]%tl==18:tg.RR["activv"][1]="5i"
				elif tg.RR["activv"][0]%tl==19:tg.RR["activv"][1]="5a"
				elif tg.RR["activv"][0]%tl==20:tg.RR["activv"][1]="5k"
				elif tg.RR["activv"][0]%tl==21:tg.RR["activv"][1]="Qi-4i"
				elif tg.RR["activv"][0]%tl==22:tg.RR["activv"][1]="Qa-4i"
				elif tg.RR["activv"][0]%tl==23:tg.RR["activv"][1]="Qk-4i"
				elif tg.RR["activv"][0]%tl==24:tg.RR["activv"][1]="Qi-5i"
				elif tg.RR["activv"][0]%tl==25:tg.RR["activv"][1]="Qa-5i"
				elif tg.RR["activv"][0]%tl==26:tg.RR["activv"][1]="Qk-5i"
				tg.rrinfo+="Actibasion: "+tg.RR["activv"][1]+"\n"
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
