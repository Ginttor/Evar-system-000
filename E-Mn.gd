@tool extends Node


@export var ES:Node       ##esenario de juego
@export var ioenje:Node   ##yo en el juego
@export var entblr:Node   ##en el tablero
@export var RR:Dictionary ##extras
@export var PT:Array[Node]##binculado
var R:={}

func _ready() -> void:
	if Engine.is_editor_hint():
		if len(PT)>1:
			if !"Fz" in ioenje.RR:ioenje.RR["Fz"]=Vector3i(0,0,0)
			if !"P-PI" in RR:RR["P-PI"]="//pp"
		var x=0;while x<len(PT):
			if PT[x] and PT[x]==$".":R["CM"] = PT[x];R["P"]=[null,null,null,null,]#caramara asignada
			if PT[x] and PT[x].name=="p0":R["P"][0]= PT[x]##cartel de evento 0
			if PT[x] and PT[x].name=="p1":R["P"][1]= PT[x]##cartel de evento 1
			if PT[x] and PT[x].name=="p2":R["P"][2]= PT[x]##cartel de evento 2
			if PT[x] and PT[x].name=="p3":R["P"][3]= PT[x]##cartel de evento 3
			x+=1
	else:
		R["T"]=0
		R["IV"]=[]
		if len(EgLb.mp)<=0:
			EgLb.mp={
			  "G-PP": ["//pp", "//pz", "//tg"],
			  "G-UP": ["0;0", "0;1"],
			  "G-EP": ["B"],
			  "P-PI": ["//pp"],
			  "P-UM": ["0;nt;0;//mm"],
			  "P-SH": {},
			  "L-PM": ["//pp;1"],
			  "C-IP": 0,
			  "C-PM": "1;"
			}
		var x=0;while x<len(PT):
				if   PT[x] and PT[x].name=="AA"         :R["a"] =x#animasione a ejecutar
				elif PT[x] and PT[x].name=="INF"        :R["if"]=x#animasione a ejecutar
				elif PT[x] and PT[x].name=="scl"        :R["sc"]=x#animasione a de siclo
				elif PT[x] and PT[x].name=="ssIV"       :R["iv"] =x#sistema IV simple
				elif PT[x] and PT[x].name=="ssA"        :R["A"] =x#sistema A simple
				elif PT[x] and PT[x].name=="ind"        :R["CT"] =PT[x]#punto de comprobasion
				elif PT[x] and PT[x].name=="ind2"       :R["CT2"]=PT[x]#sombtra de punto de comprobasion
				elif PT[x] and PT[x].name=="LSI"        :R["LSI"]=PT[x];PT[x].RR["MD"]=$"."#lista de informasion
				elif PT[x] and PT[x]==$".":R["CM"] = PT[x];R["P"]=[null,null,null,null,]#caramara asignada
				elif PT[x] and PT[x].name=="p0":R["P"][0]= PT[x]##cartel de evento 0
				elif PT[x] and PT[x].name=="p1":R["P"][1]= PT[x]##cartel de evento 1
				elif PT[x] and PT[x].name=="p2":R["P"][2]= PT[x]##cartel de evento 2
				elif PT[x] and PT[x].name=="p3":R["P"][3]= PT[x]##cartel de evento 3
				elif PT[x] and PT[x].name.count("stk"):R["IV"].append(PT[x]);PT[x].PT.append($".")
				x+=1
		if len(PT)>1 and entblr and entblr.fuerza!=Vector3i(0,0,0):
			ioenje.RR["Fz"]=entblr.fuerza
			EgLb.aspe($".")

func _process(_delta: float) -> void:
	if Engine.is_editor_hint():
		pass
	else:
		if EgLb.cg=="G":
			EgLb.icpt($".")
			EgLb.cg+="M"
		var h=[
			"up",   #arriba
			"down", #abajo
			"right",#derecha
			"left", #isquierda
			"esp",  #cloche
			"c",    #accionar
		]
		if len(PT)>0 and ioenje:
			EgLb.ilos(ioenje,h)
			EgLb.ccam($".",ioenje)
		var x=0;while x<6:
			var r="";if "MS" in RR:r=EgLb.miti($".",RR["MS"],x)
			if r!="":
				EgLb.catg(RR["PF"])
			x+=1
		focl($".")
		
#========================
func focl(E):                   # focalizar
	if "PS" in E.R:for i in E.R["PS"]:
		if i and i.script!=null:
			if i.R["id"][1]==1 and E.R["CT2"]:
				E.R["CT2"].global_position=i.global_position
				E.R["CT2"].visible=true
				break
			if i.R["id"][1]==2:
				var d=false
				if !("tL" in E.PT[0].R):E.PT[0].R["tL"]=[]#cercano
				for e in E.PT[0].R["tL"]:if e==i:d=true
				if !d:
					E.PT[0].R["tL"].append(i)
				E.PT[0].R["II"]=[len(E.PT[0].R["tL"])-1,"l"]
				#E.PT[0].R["AC"]=EgLb.mete(E.PT[0],"l")
				EgLb.aspe(E.PT[0].R["tL"][len(E.PT[0].R["tL"])-1],"n")
				E.R["CT"].global_position=i.global_position
				i.R["id"][1]=0;break
	if E.PT[0] and E.R["CT"] and "II" in E.PT[0].R:
		if len(E.PT[0].R["II"])>0:
			E.R["CT"].visible=true
			E.R["CT"].global_position=E.PT[0].R["II"][0].global_position
			E.PT[E.R["A"]].aspect[0].texture=load(E.PT[0].R["II"][0].ddd_tg.RR["imagen"])
			E.PT[E.R["A"]].PT[E.PT[E.R["A"]].R["a"]].play("on")
		else:
			E.R["CT"].visible=false
			E.PT[E.R["A"]].aspect[0].texture=null
			E.PT[E.R["A"]].PT[E.PT[E.R["A"]].R["a"]].play("of")
