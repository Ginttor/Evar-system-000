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


@tool extends CharacterBody2D
class_name e_pz

##etiquetas[br]
##"c:>_" define inscripsion en la piesa[br]
##"d:>_" define descripsion en la piesa[br]
@export_multiline var                                      etiggg:Array[String]
@export var                                                imagee:Texture    ##iagen de presentasion
@export var                                                tablle:Node       ##tablero
@export var                                                est_ig:=""        ##estado en juego
@export var                                                cllloz:=""        ##resumen de datos
@export_group("ESCULPE")
@export_multiline var                                      rrinfo:=""        ##información
@export_multiline var                                      pzetev={          ##elementos basicos de la pieza
	"io":NodePath("CollisionShape2D"),
	"P":NodePath("Sprite2D"),
	"f":NodePath("Area2D2"),
	"cf":NodePath("Area2D2/CollisionShape2D"),
	"i":NodePath("Sprite2D/Area2D"),
	"ci":NodePath("Sprite2D/Area2D/CollisionShape2D"),
	"y":NodePath("Area2D3"),
	"cy":NodePath("Area2D3/CollisionShape2D"),
	"A":NodePath("AnimationPlayer")
	}
@export var                                                ddd_tg:Array[d_tg]##targeta de pieza
@export_enum("RR","IO","IV","MK") var  tiprrh:=""        ##formatos
@export var           RR:={}
@export var           potakj:Array[Node]  ##punto de anclaje
@export var           eqiped:Array[Node]  ##equipados

var R:={"id":["pz",0]}

func _ready() -> void:
	if len(ddd_tg)>0:
		RR["i0"]=ddd_tg[0]
		if etiggg.count(ddd_tg[0].resource_name)==0:etiggg.append(ddd_tg[0].resource_name)
	if Engine.is_editor_hint():
		if !"Pz" in EgLb.R:EgLb.R["Pz"]={}
		EgLb.R["Pz"][name]=scene_file_path
		EgLb.rgst(EgLb.R,"res://","RR")
	else:
		if !"II" in R:R["II"]=[]
		if !"YY" in R:R["YY"]=[]
		if !"VV" in R:R["VV"]=[]
		#EgLb.ordd($".")
		for i in ddd_tg:print(i.tiprrh)
	sttr()
func _process(_delta: float) -> void:
	if Engine.is_editor_hint():
		if tiprrh!="":sttr()
		
		for i in ddd_tg:
			i.fmtg()
		eqiped=[]
		var x=0
		while x<len(potakj):
			eqiped.append(null)
			x+=1
	else:
		if "IO" in RR:inte()
		if est_ig=="":$".".visible=false
		else:$".".visible=true
		motr($".")
		var x=0
		for i  in eqiped:
			if i:
				i.global_position=potakj[x].global_position
			x+=1
func _physics_process(_delta: float) -> void:
	if Engine.is_editor_hint():
		pass
	else:
		if "IO" in RR:girk($".")
#========================
func accc(E,a):                   # accionamiento
	if a>-1:
		if   a==0:#-------------------------------------------------------------------------------------#caminar
			if   E.R["KM"][1]!="." and E.velocity.y>-E.RR["IO"]["Vel"]:E.R["FF"][0].y=-E.RR["IO"]["Acl"]
			elif E.R["KM"][2]!="." and E.velocity.y< E.RR["IO"]["Vel"]:E.R["FF"][0].y= E.RR["IO"]["Acl"]
			if   E.R["KM"][3]!="." and E.velocity.x< E.RR["IO"]["Vel"]:E.R["FF"][0].x= E.RR["IO"]["Acl"]
			elif E.R["KM"][4]!="." and E.velocity.x>-E.RR["IO"]["Vel"]:E.R["FF"][0].x=-E.RR["IO"]["Acl"]
		elif a==1:#-------------------------------------------------------------------------------------#rotar x
			if   E.R["KM"][3]!=".":R["P"].scale.x= 1
			elif E.R["KM"][4]!=".":R["P"].scale.x=-1
		elif a==2:#-------------------------------------------------------------------------------------#dash
			if   E.R["KM"][1]!="." and E.velocity.y>-E.RR["IO"]["Vel"]:E.R["FF"][0].y=-E.RR["IO"]["Pot"]*2
			elif E.R["KM"][2]!="." and E.velocity.y< E.RR["IO"]["Vel"]:E.R["FF"][0].y= E.RR["IO"]["Pot"]*2
			if   E.R["KM"][3]!="." and E.velocity.x< E.RR["IO"]["Vel"]:E.R["FF"][0].x= E.RR["IO"]["Pot"]*2
			elif E.R["KM"][4]!="." and E.velocity.x>-E.RR["IO"]["Vel"]:E.R["FF"][0].x=-E.RR["IO"]["Pot"]*2
		elif a==3:#-------------------------------------------------------------------------------------#salto
			if "M" in R and E.R["M"][0].count("f"):
				E.velocity.y=-(E.RR["IO"]["Pot"]+E.RR["IO"]["Mas"])*30
		elif a==6 and E.R["fp"]:#-----------------------------------------------------------------------#escalar
			E.velocity.y=-E.RR["IO"]["Vel"]
			E.R["FF"][0].y=0
func motr(E):                   # motor
	if "KM" in E.R:
		#------------------------------------------------------------
		if   R["KM"].count(".")==len(R["KM"]):
			if RR["MK"]["Man"][0] and RR["MK"]["Man"][0].tiprrh=="1":R["A"].play("P")
		#if   RR["MK"]["Man"][0].tiprrh=="M":R["A"].play(RR["MK"]["Man"][0].RR["acionn"])
		EgLb.stcM($".",2,true)
		var x=0
		while x<len(E.R["KM"]):
			if E.R["KM"][x]!=".":
				if   E.R["KM"][x]=="i" and x!=0:
					if   RR["MK"]["Man"][x].tiprrh=="1":pisz("i"+R["KM"][0])
					elif RR["MK"]["Man"][x].tiprrh=="M":pass
					elif RR["MK"]["Man"][x].tiprrh=="E":pass
				elif E.R["KM"][x]=="a" and x!=0:
					if   RR["MK"]["Man"][x].tiprrh=="1":pass
					elif RR["MK"]["Man"][x].tiprrh=="M":
						accc(E,RR["MK"]["Man"][x].RR["lin_og"])
						accc(E,RR["MK"]["Man"][x].RR["lin_o2"]-1)
						EgLb.stcM(E,2,true)
						R["A"].play(RR["MK"]["Man"][x].RR["acionn"])
					elif RR["MK"]["Man"][x].tiprrh=="E":pass
			x+=1
	if "P" in R and R["P"].position.x!=0:
		if  R["P"].position.x<0 and E.R["FF"][0].x>0:E.R["FF"][0].x=0
		elif R["P"].position.x>0 and E.R["FF"][0].x<0:E.R["FF"][0].x=0
		if R["P"].position.x!=0:R["P"].position.x=0
func girk(E):                   # giroscopio
	if !"FF" in E.R:E.R["FF"]=[Vector3i(0,0,0),Vector3i(0,0,0)]
	#===============resistensia
	if E.R["FF"][0].x==0:
		if E.velocity.x> E.RR["IO"]["Sti"]:
			E.velocity.x-=E.RR["IO"]["Sti"]
		elif E.velocity.x>0:E.velocity.x-=1
					
		if E.velocity.x<-E.RR["IO"]["Sti"]:E.velocity.x+=E.RR["IO"]["Sti"]
		elif E.velocity.x<0:E.velocity.x+=1
	if E.R["FF"][0].y==0:
		if E.velocity.y> E.RR["IO"]["Sti"]:E.velocity.y-=E.RR["IO"]["Sti"]
		elif E.velocity.y>0:E.velocity.y-=1
					
		if E.velocity.y<-E.RR["IO"]["Sti"]:E.velocity.y+=E.RR["IO"]["Sti"]
		elif E.velocity.y<0:E.velocity.y+=1
	E.R["FF"][1]=Vector3i(0,0,0)
	#===============grabedad
	if "Fz" in E.RR:
		if ! "M" in E.R:E.R["M"]=["",""]
		if E.R["M"][0].count("f")==0:E.R["FF"][1].y+=(E.RR["Fz"].y*E.RR["IO"]["Mas"])
		if "P" in R and R["P"].position.y>0:
			R["P"].position.y=0
	#===============sumar todo
	E.velocity.x+=E.R["FF"][1].x+E.R["FF"][0].x
	E.velocity.y+=E.R["FF"][1].y+E.R["FF"][0].y
	E.move_and_slide()
	E.R["FF"][0]=Vector3i(0,0,0)
func sttr():                    # estructurar
	rrinfo=""
	if "i0" in RR:
		if   RR["i0"].tiprrh=="0":rrinfo+="PIEZA"
		elif RR["i0"].tiprrh=="A":rrinfo+="APLICADOR"
		elif RR["i0"].tiprrh=="M":rrinfo+="MECANISMO"
		elif RR["i0"].tiprrh=="E":rrinfo+="REACCIONADOR"
		elif RR["i0"].tiprrh=="Q":rrinfo+="CAMBIANTE"
		elif RR["i0"].tiprrh=="R":rrinfo+="ESTRUCTURA"
		elif RR["i0"].tiprrh=="L":rrinfo+="LUGAR"
	EgLb.stcL($".",1, false);EgLb.stcL($".",4, true);EgLb.stcM($".",2,true);EgLb.stcM($".",1, true);
	R["IK"]=100
	if has_node(pzetev["io"]):R["io"]=get_node(pzetev["io"])
	if has_node(pzetev["ci"]):R["ci"]=get_node(pzetev["ci"]);R["ci"].debug_color="ffffff4a"
	if has_node(pzetev["cy"]):R["cy"]=get_node(pzetev["cy"]);R["cy"].debug_color="00ff0000"
	if has_node(pzetev["cf"]):R["cf"]=get_node(pzetev["cf"]);R["cf"].debug_color="bd753c6b"
	if has_node(pzetev["P"]):R["P"]=get_node(pzetev["P"])
	if has_node(pzetev["f"]):R["f"]=get_node(pzetev["f"]);EgLb.stcM(R["f"],5,  true);EgLb.stcL(R["f"],1, false);EgLb.stcM(R["f"],1, false)
	if has_node(pzetev["i"]):R["i"]=get_node(pzetev["i"]);EgLb.stcL(R["i"],1, false);EgLb.stcM(R["i"],1,  true);EgLb.stcM(R["i"],4,  true)
	if has_node(pzetev["y"]):R["y"]=get_node(pzetev["y"])
	if has_node(pzetev["A"]):R["A"]=get_node(pzetev["A"])
	
	if "IV" in RR:
		RR["IV"]["I"]=[]
		RR["IV"]["K"]=[]
		RR["IV"]["D"]=[]
		for i in ddd_tg:
			if i.tiprrh=="0" or i.tiprrh=="Q" or i.tiprrh=="R":
				RR["IV"]["I"].append(i)
				RR["IV"]["K"].append("")
				RR["IV"]["D"].append("")
			if len(RR["IV"]["I"])==RR["IV"]["Sps"]:break
		while len(RR["IV"]["I"])<RR["IV"]["Sps"]:
			RR["IV"]["I"].append(null)
			RR["IV"]["K"].append("")
			RR["IV"]["D"].append("")
		R["Dm"]=[-1,-1]
	if "MK" in RR:
		var x=0
		while x < len(ddd_tg):
			if ddd_tg[x].tiprrh=="1" or ddd_tg[x].tiprrh=="M" or ddd_tg[x].tiprrh=="E":
				if x<len(RR["MK"]["Man"]):RR["MK"]["Man"][x]=ddd_tg[x]
				else:RR["MK"]["Rec"].append(ddd_tg[x])
			x+=1
	for i in ddd_tg:
		if "i0" in RR and i!=RR["i0"]: 
			i.defn()
			i.fmtg()
	if   tiprrh=="IO":
		RR["IO"]={
		"Vel": 10,#velocidad maxima
		"Mac": 1, #acelerasion maxima
		"Acl": 10,#aselerasion
		"Pot": 10,#potencia
		"Mas": 1, #masa
		"Sti": 1, #stabilidad
		}
	elif tiprrh=="IV":
		R["Dm"]=[-1,-1]  #dedo
		RR["IV"]={
			"Sps":4,#limite
			"I":[], #objeto
			"K":[], #cargas
			"D":[], #descripsion o grabados
			}
	elif tiprrh=="MK":
		RR["MK"]={
		"Man": [null,null,null,null],#
		"Rec": [],#
		"Dsc": [],#
		}
	#if E.script==load("res://Evar system 000/E-Pz.gd"):
	if "AA" in R and "SK" in RR["AA"]:R["fp"]=false
	tiprrh=""
func pisz(k="i."):              # interaccion
	if "II" in R and len(R["II"])>0 and len(R["II"][0].est_ig)>0:#comportamientoc
		if  len(R["II"])==0:
			if   k=="ii":pass#señal
			elif k=="ia":pass#tontear
		else:
			if k=="ii":
				if  R["II"][0].R["id"][0]=="fc":
					EgLb.reuv(tablle.mapapp,R["II"][0],$".")
				else:
					if eqiped[0]==null:
						if   R["II"][0].ddd_tg[0].tiprrh=="0":#recojer
							eqiped[0]=R["II"][0]
							R["II"]=[]
					else:
						if   R["II"][0].ddd_tg[0].tiprrh=="0":#recojer
							eqiped[0]=R["II"][0]
							R["II"]=[]
						elif R["II"][0].ddd_tg[0].tiprrh=="M":#depositar
							var x=0
							while x<len(R["II"][0].RR["IV"]["I"]):
								if R["II"][0].RR["IV"]["I"][x]==null:
									R["II"][0].RR["IV"]["I"][x]=eqiped[0].ddd_tg[0]
									R["II"][0].ddd_tg.append(eqiped[0].ddd_tg[0])
									eqiped[0].est_ig=""
									eqiped[0]=null
									break
								x+=1
						if "Mn" in RR:EgLb.aspe(get_node(RR["Mn"]),eqiped[0],"","m")#leer
		R["IK"]=100
func inte():                    # calculos internos
	if ddd_tg[0]:
		var mm=""
		var x=0
		while x<ddd_tg[0].RR["descri"]["v0"][1].y:
			if x<=ddd_tg[0].RR["descri"]["v0"][1].x:mm+=ddd_tg[0].RR["descri"]["v0"][0]
			else:mm+="."
			x+=1
		x=0
		while x<ddd_tg[0].RR["descri"]["v1"][1].y:
			if x<=ddd_tg[0].RR["descri"]["v1"][1].x:mm+=ddd_tg[0].RR["descri"]["v1"][0]
			else:mm+="."
			x+=1
		cllloz=mm
#========================
func _on_i_body_entered(body: Node2D) -> void:
	if body!=$"." and body.script and body.est_ig!="":
		R["II"].append(body)
		R["II"]=EgLb.invl(R["II"])
		if "Mn" in RR:EgLb.aspe(RR["Mn"],R["II"][0])
		
	if body.name=="sm_Tb":R["fp"]=true
func _on_i_body_exited(body: Node2D) -> void:
	if body!=$"." and body.script and body.est_ig!="":
		R["II"]=[]
		if body.name=="sm_Tb":R["fp"]=false
		if "Mn" in RR:EgLb.aspe(RR["Mn"])
func _on_y_body_entered(body: Node2D) -> void:
	if body!=$"." and body.script and body.est_ig!="":
		if !"YY" in R:R["YY"]=[]
		R["YY"].append(body)
func _on_y_body_exited(_body: Node2D) -> void:
	R["YY"]=[]
func _on_a_body_entered(body: Node2D) -> void:
	if body!=$"." and body.script and body.est_ig!="":
		if !"VV" in R:R["VV"]=[]
		R["VV"].append(body)
func _on_a_body_exited(_body: Node2D) -> void:
	R["VV"]=[]
func _on_a_input_event(_viewport: Node, _event: InputEvent, _shape_idx: int) -> void:
	pass # Replace with function body.
func _on_a_mouse_entered() -> void:
	pass # Replace with function body.
func _on_a_mouse_exited() -> void:
	pass # Replace with function body.
func _on_f_body_entered(_body: Node2D) -> void:
	if ! "M" in R:R["M"]=["",""]
	R["M"][0]="f"
	$".".velocity=Vector2(0,0)
func _on_f_body_exited(_body: Node2D) -> void:
	if ! "M" in R:R["M"]=["",""]
	R["M"][0]=""
