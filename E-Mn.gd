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


@export var ioenje:Node   ##yo en el juego
@export var commad:=[     ##comandos
	"up",   #arriba
	"down", #abajo
	"right",#derecha
	"left", #isquierda
	"esp",  #cloche
	"c",    #accionar
	]
@export var mision:={  ##mision prinsipal
	"ms":null,
	"wi":"",
	}
@export var RR:Dictionary ##extras
@export var PT:Array[Node]##binculado
var R:={}

func _ready() -> void:
	if ioenje:ioenje.etiggg.append("Mn"+$".".name)
	if Engine.is_editor_hint():
		if len(PT)>1:
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
		EgLb.aspe($".")
		EgLb.icpt($".")
func _process(_delta: float) -> void:
	if Engine.is_editor_hint():
		if mision["ms"]:
			mision["ms"].defn()
			mision["ms"].fmtg()
		if "P" in R:
			R["P"][1].position.x=R["P"][0].position.x*-1;R["P"][1].position.y=R["P"][0].position.y
			R["P"][2].position.x=R["P"][0].position.x   ;R["P"][2].position.y=R["P"][0].position.y*-1
			R["P"][3].position.x=R["P"][0].position.x*-1;R["P"][3].position.y=R["P"][0].position.y*-1
	else:
		if EgLb.cg=="G":
			EgLb.icpt($".")
			EgLb.cg+="M"
		if ioenje:
			ilos(ioenje,commad)
			if "CM" in R:ccam($".",ioenje)
		var x=0;while x<6:
			var r="";if mision["ms"]:r=EgLb.miti($".",mision["ms"],x)
			if r!="":
				EgLb.catg(mision["wi"])
			x+=1
		focl($".")
#========================
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
func ccam(E,P):                 # correccion de posision de camara
	if P.global_position.x>E.R["CM"].global_position.x+E.R["P"][0].position.x:
		E.R["CM"].global_position.x+=P.global_position.x-(E.R["CM"].global_position.x+E.R["P"][0].position.x)
		if E.ioenje.tablle and E.ioenje.tablle.spcmap:
			E.ioenje.tablle.spcmap.rotation-=0.001
			E.ioenje.velocity.x=0
	if P.global_position.x<E.R["CM"].global_position.x-E.R["P"][0].position.x:
		E.R["CM"].global_position.x+=P.global_position.x-(E.R["CM"].global_position.x-E.R["P"][0].position.x)
		if E.ioenje.tablle and E.ioenje.tablle.spcmap:
			E.ioenje.tablle.spcmap.rotation+=0.001
			E.ioenje.velocity.x=0
	if P.global_position.y>E.R["CM"].global_position.y+E.R["P"][0].position.y:E.R["CM"].global_position.y+=P.global_position.y-(E.R["CM"].global_position.y+E.R["P"][0].position.y)
	if P.global_position.y<E.R["CM"].global_position.y-E.R["P"][0].position.y:E.R["CM"].global_position.y+=P.global_position.y-(E.R["CM"].global_position.y-E.R["P"][0].position.y)
func focl(E):                   # focalizar
	if "PS" in E.R:for i in E.R["PS"]:
		if i and i.script!=null:
			if i.R["id"][1]==1 and E.R["CT2"]:
				E.R["CT2"].global_position=i.global_position
				E.R["CT2"].visible=true
				break
			if i.R["id"][1]==2:
				var d=false
				if !("tL" in ioenje.R):ioenje.R["tL"]=[]#cercano
				for e in ioenje.R["tL"]:if e==i:d=true
				if !d:
					ioenje.R["tL"].append(i)
				ioenje.R["II"]=[len(ioenje.R["tL"])-1,"l"]
				#ioenje.R["AC"]=EgLb.mete(ioenje,"l")
				EgLb.aspe(ioenje.R["tL"][len(ioenje.R["tL"])-1],"n")
				E.R["CT"].global_position=i.global_position
				i.R["id"][1]=0;break
	if ioenje and "CT" in E.R and "II" in ioenje.R:
		if len(ioenje.R["II"])>0 and "i0" in ioenje.R["II"][0].RR:
			E.R["CT"].visible=true
			E.R["CT"].global_position=ioenje.R["II"][0].global_position
			E.PT[E.R["A"]].aspect[0].texture=load(ioenje.R["II"][0].RR["i0"][0].RR["imagen"])
			E.PT[E.R["A"]].PT[E.PT[E.R["A"]].R["a"]].play("on")
		else:
			E.R["CT"].visible=false
			E.PT[E.R["A"]].aspect[0].texture=null
			E.PT[E.R["A"]].PT[E.PT[E.R["A"]].R["a"]].play("of")
