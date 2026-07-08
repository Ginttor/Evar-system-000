@tool extends Node

@export var est_ig:=""          ##estado en juego
@export var ddd_tg:Array[d_tg]  ##targeta de pieza
@export var etiggg:Array[String]##etiquetas
const AA_LBL:=["P_","M.","M+","M*","N.","N+","N*","I.","I+","I*","C.","C+","C*","X.","X+","X*","Z.","Z+","Z*"]##etiquetas de animasion (equibalen a RR["activa"]%19)
##estadisticas de carga[br]
##"Vel" = velocidad maxima[br]
##"Mac" = acelerasion maxima[br]
##"Acl" = aselerasion[br]
##"Pot" = potencia[br]
##"Mas" = masa[br]
##"Sti" = stabilidad[br]
##"Sps" = espasio[br]
@export var io_0SC:={
	"Vel": 10,#velocidad maxima
	"Mac": 1,#acelerasion maxima
	"Acl": 10,#aselerasion
	"Pot": 10,#potencia
	"Mas": 1,#masa
	"Sti": 1,#stabilidad
	"Sps": 1,#espasio
	}
@export var RR:={}              ##extras, RR["AA"]=animasiones armadas desde ddd_tg (tiprrh=="M")
@export var PT:Array[Node]##binculado
var R:={"id":["pz",0]}

func _ready() -> void:
	if !"AA" in RR:RR["AA"]={}
	for i in ddd_tg:
		i.defn()
		i.fmtg()
		if i.tiprrh=="M":RR["AA"][AA_LBL[i.RR["activa"]%len(AA_LBL)]]=i
	if Engine.is_editor_hint():
		sttr($".")
	else:
		if len(ddd_tg)>0:
			etiggg.append(ddd_tg[0].resource_name)
		if !"II" in R:R["II"]=[]
		if !"YY" in R:R["YY"]=[]
		if !"VV" in R:R["VV"]=[]
		sttr($".")
		EgLb.ordd($".")
		for i in ddd_tg:print(i.tiprrh)
func _process(_delta: float) -> void:
	if Engine.is_editor_hint():
		for i in ddd_tg:
			i.fmtg()
	else:
		if est_ig=="":$".".visible=false
		else:$".".visible=true
		motr($".")
		if "KM" in R and R["KM"][5]=="i":
			EgLb.camb($".")
		if "KM" in R and R["KM"][5]=="i" and R["IK"]<=0:
			EgLb.pisz($".")
		if "IK" in R and R["IK"]>0:
			R["IK"]-=1
func _physics_process(_delta: float) -> void:
	if Engine.is_editor_hint():
		pass
	else:
		girk($".")
#========================
func motr(E):                   # motor
	if "BP" in E.R and "KM" in E.R:
		if "DV" in E.RR["AA"]:
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
		var ej="P_"
		if   E.R["KM"][0]=="i" or E.R["KM"][1]=="i" or E.R["KM"][2]=="i" or E.R["KM"][3]=="i":ej="M."
		elif E.R["KM"][0]=="a" or E.R["KM"][1]=="a" or E.R["KM"][2]=="a" or E.R["KM"][3]=="a":ej="M+"
		elif E.R["KM"][0]=="k" or E.R["KM"][1]=="k" or E.R["KM"][2]=="k" or E.R["KM"][3]=="k":ej="M*"
		if   E.R["KM"][4]=="i":ej="C."
		elif E.R["KM"][4]=="a":ej="C+"
		elif E.R["KM"][4]=="k":ej="C*"
		#---
		if ej in E.RR["AA"] and  E.RR["AA"][ej]:
			if E.RR["AA"][ej].RR["lin_og"]==0 or E.RR["AA"][ej].RR["lin_o2"]==1:#-----------------------------------------#caminar
				if   E.R["KM"][0]!="." and E.velocity.y>-E.io_0SC["Vel"]:E.R["FF"][0].y=-E.io_0SC["Acl"]
				elif E.R["KM"][1]!="." and E.velocity.y< E.io_0SC["Vel"]:E.R["FF"][0].y= E.io_0SC["Acl"]
				if   E.R["KM"][2]!="." and E.velocity.x< E.io_0SC["Vel"]:E.R["FF"][0].x= E.io_0SC["Acl"]
				elif E.R["KM"][3]!="." and E.velocity.x>-E.io_0SC["Vel"]:E.R["FF"][0].x=-E.io_0SC["Acl"]
				EgLb.stcM(E,2,true)
				if "a" in E.R and E.RR["AA"][ej].RR["acionn"]!="AA":E.PT[E.R["a"]].play(E.RR["AA"][ej].RR["acionn"])
			if E.RR["AA"][ej].RR["lin_og"]==1 or E.RR["AA"][ej].RR["lin_o2"]==2:#-----------------------------------------#rotar x
				if   E.R["KM"][2]!=".":E.PT[E.R["BP"]].scale.x= 1
				elif E.R["KM"][3]!=".":E.PT[E.R["BP"]].scale.x=-1
				if "a" in E.R and E.RR["AA"][ej].RR["acionn"]!="AA":E.PT[E.R["a"]].play(E.RR["AA"][ej].RR["acionn"])
			if E.RR["AA"][ej].RR["lin_og"]==3 or E.RR["AA"][ej].RR["lin_o2"]==3:#-----------------------------------------#dash
				if   E.R["KM"][0]!="." and E.velocity.y>-E.io_0SC["Vel"]:E.R["FF"][0].y=-E.io_0SC["Pot"]*2
				elif E.R["KM"][1]!="." and E.velocity.y< E.io_0SC["Vel"]:E.R["FF"][0].y= E.io_0SC["Pot"]*2
				if   E.R["KM"][2]!="." and E.velocity.x< E.io_0SC["Vel"]:E.R["FF"][0].x= E.io_0SC["Pot"]*2
				elif E.R["KM"][3]!="." and E.velocity.x>-E.io_0SC["Vel"]:E.R["FF"][0].x=-E.io_0SC["Pot"]*2
				if "a" in E.R and E.RR["AA"][ej].RR["acionn"]!="AA":E.PT[E.R["a"]].play(E.RR["AA"][ej].RR["acionn"])
			if E.RR["AA"][ej].RR["lin_og"]==4 or E.RR["AA"][ej].RR["lin_o2"]==5:#-----------------------------------------#salto
				if E.R["M"][0].count("f"):
					E.velocity.y=-(E.io_0SC["Pot"]+E.io_0SC["Mas"])*30
					if "a" in E.R and E.RR["AA"][ej].RR["acionn"]!="AA":E.PT[E.R["a"]].play(E.RR["AA"][ej].RR["acionn"])
					EgLb.stcM(E,2,false)
			if E.RR["AA"][ej].RR["lin_og"]==6 or E.RR["AA"][ej].RR["lin_o2"]==7 and E.R["fp"]:#---------------------------#escalar
				E.velocity.y=-E.io_0SC["Vel"]
				E.R["FF"][0].y=0
				if "a" in E.R and E.RR["AA"][ej].RR["acionn"]!="AA":E.PT[E.R["a"]].play(E.RR["AA"][ej].RR["acionn"])
				EgLb.stcM(E,2,false)
			if ej=="P_":
				if "a" in E.R and E.RR["AA"][ej].RR["acionn"]!="AA":E.PT[E.R["a"]].play(E.RR["AA"][ej].RR["acionn"])
				EgLb.stcM($".",2,true)
	if "BP" in E.R and E.PT[E.R["BP"]].position.x!=0:
		if   E.PT[E.R["BP"]].position.x<0 and E.R["FF"][0].x>0:E.R["FF"][0].x=0
		elif E.PT[E.R["BP"]].position.x>0 and E.R["FF"][0].x<0:E.R["FF"][0].x=0
		if E.PT[E.R["BP"]].position.x!=0:E.PT[E.R["BP"]].position.x=0
func girk(E):                   # giroscopio
	if !"FF" in E.R:E.R["FF"]=[Vector3i(0,0,0),Vector3i(0,0,0)]
	#===============resistensia
	if E.R["FF"][0].x==0 and "BP" in E.R:
		if E.velocity.x> E.io_0SC["Sti"]:
			E.velocity.x-=E.io_0SC["Sti"]
		elif E.velocity.x>0:E.velocity.x-=1
					
		if E.velocity.x<-E.io_0SC["Sti"]:E.velocity.x+=E.io_0SC["Sti"]
		elif E.velocity.x<0:E.velocity.x+=1
	if E.R["FF"][0].y==0 and "BP" in E.R:
		if E.velocity.y> E.io_0SC["Sti"]:E.velocity.y-=E.io_0SC["Sti"]
		elif E.velocity.y>0:E.velocity.y-=1
					
		if E.velocity.y<-E.io_0SC["Sti"]:E.velocity.y+=E.io_0SC["Sti"]
		elif E.velocity.y<0:E.velocity.y+=1
	E.R["FF"][1]=Vector3i(0,0,0)
	#===============grabedad
	if "Fz" in E.RR and "BP" in E.R:
		if ! "M" in E.R:E.R["M"]=["",""]
		if E.R["M"][0].count("f")==0:E.R["FF"][1].y+=(E.RR["Fz"].y*E.io_0SC["Mas"])
		if E.PT[E.R["BP"]].position.y>0:
			E.PT[E.R["BP"]].position.y=0
	#===============sumar todo
	if "BP" in E.R:
		E.velocity.x+=E.R["FF"][1].x+E.R["FF"][0].x
		E.velocity.y+=E.R["FF"][1].y+E.R["FF"][0].y
		E.move_and_slide()
		E.R["FF"][0]=Vector3i(0,0,0)
func sttr(E):                   # estructurar
	EgLb.stcL(E,1, false);EgLb.stcL(E,4, true);EgLb.stcM(E,2,true);EgLb.stcM(E,1, true);
	var x=0;while x < len(E.PT):
		E.R["IK"]=100
		#if E.ddd_tg.tiprrh=="0" and E.ddd_tg.RR["estres"]==0:
		#	var y=0;E.R["KM"]=[];while y<11:
		#		E.R["KM"].append(".")
		#		y+=1
		if E.PT[x].name=="P":E.R["BP"]=x
		if E.PT[x].name=="f":EgLb.stcM(E.PT[x],5, true);EgLb.stcL(E.PT[x],1, false);EgLb.stcM(E.PT[x],1, true)
		if E.PT[x].name=="i":EgLb.stcL(E.PT[x],1, false);EgLb.stcM(E.PT[x],1, true);EgLb.stcM(E.PT[x],4, true)
		if E.PT[x].name=="AA"  :
			E.R["a"]=x
			if E.ddd_tg and !"M" in E.RR["AA"]:E.RR["AA"]["M"]=null
		#if E.script==load("res://Evar system 000/E-Pz.gd"):
		if "SK" in E.RR["AA"]:E.R["fp"]=false
		if E.io_0SC["Sps"]>0:
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
#========================
func _on_i_body_entered(body: Node2D) -> void:
	if body!=$"." and !("BP" in R and body==PT[R["BP"]]) and body.script and body.est_ig!="":
		R["II"].append(body)
		R["II"]=EgLb.invl(R["II"])
	if body.name=="sm_Tb":R["fp"]=true
func _on_i_body_exited(body: Node2D) -> void:
	R["II"]=[]
	if body.name=="sm_Tb":R["fp"]=false
func _on_y_body_entered(body: Node2D) -> void:
	if body!=$"." and !("BP" in R and body==PT[R["BP"]]) and body.script and body.est_ig!="":
		if !"YY" in R:R["YY"]=[]
		R["YY"].append(body)
func _on_y_body_exited(_body: Node2D) -> void:
	R["YY"]=[]
func _on_a_body_entered(body: Node2D) -> void:
	if body!=$"." and !("BP" in R and body==PT[R["BP"]]) and body.script and body.est_ig!="":
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
