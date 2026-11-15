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

@export var mjugad:Array[Node]              ##jugadores
@export var PT:Array[Node]                  ##tableros de la esena
@export var pasodt:Array[String]=["p;0;0"]  ##nombre:tablero de destino:posision en tablero de destino
@export var ddd_tg:Array[d_tg]              ##targetas de recursos
#@export var menprt:JSON                     ##partida
@export var tabler:Array[PackedScene]       ##tableros de la esena
@export var postab:Array[Vector2i]          ##tableros de la esena
@export var RR:={}                          ##extras
var R:={}

func _ready() -> void:
	var x=0
	while x < len(PT):
		PT[x].mapapp=$"."
		x+=1
	cpps()
	if Engine.is_editor_hint():
		if !"Gm" in EgLb.R:EgLb.R["Gm"]={}
		EgLb.R["Gm"][name]=scene_file_path
		EgLb.rgst(EgLb.R,"res://","RR")
		if !"TL" in RR:RR["TL"]=[89,11,6,4,15,12]
		if !"TT" in RR:RR["TT"]=[0 ,1 ,0,0,0 ,0 ]
		x=0;while x<len(mjugad):
			mjugad[x].ES=$"."
		if !"MM" in RR:
			RR["MM"]=[]
	else:
		if !"MM" in RR:RR["MM"]=[]
		#if len(RR["MM"])==0 and len(mjugad)>0:RR["MM"].append(mjugad[0].entblr)
		if !"TL" in RR:RR["TL"]=[89,11,6,4,15,12]
		if !"TT" in RR:RR["TT"]=[0 ,1 ,0,0,0 ,0 ]
		R["T"]=0
		EgLb.cg+="G"
func _process(_delta: float) -> void:
	if Engine.is_editor_hint():
		pass
	else:
		if EgLb.cg=="GM":
			EgLb.cttb($".")
			EgLb.cg+="G"
		R["T"]+=1
		if R["T"]>=59:
			EgLb.tigt($".")
			RR["TT"][0]+=1
			R["T"]=0
			cpps()
		#===================================
		#var x=RR["rTb"][1];var cpf=false
		#while x>=0:
		#	if RR["TT"][x]==1:cpf=true
		#	else:cpf=false;break
		#	x-=1
		#if cpf and R["T"]==1:
		#	x=0;while x<len(RR["MM"]):
		#		var cnp=false;for i in mjugad:
		#			if RR["MM"][x]!=i.PT[0] or RR["MM"][x].ddd_tg==null:cnp=true
		#			else:cnp=false;break
		#		if cnp:
		#			if len(RR["MM"][x].ddd_tg)>0:
		#				EgLb.atlz(RR["MM"][x],RR["MM"][x].R["evEm"])
		#				RR["MM"][x].R["evEm"]+=1
		#				if RR["MM"][x].R["evEm"]>=len(RR["MM"][x].ddd_tg):
		#					RR["MM"][x].R["evEm"]=0
		#					RR["MM"][x].ddd_tg=EgLb.barj(RR["MM"][x].ddd_tg)
		#		x+=1


func cpps():                   # control de tableros
	R["PS"]=[]
	for i in PT:
		for e in i.PT:
			R["PS"].append(e)
	print(R["PS"])
