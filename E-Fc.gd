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

@export var est_ig:=""    ##estado en juego
@export var ddd_tg:d_tg   ##targeta de pieza
@export var aspect:Array[Node]##aspecto susedaneo al cuerpo
@export var RR:={}            ##extras
@export var PT:Array[Node]    ##binculado
var R:={"id":["fc",0]}

func _ready() -> void:
	if Engine.is_editor_hint():
		pass
	else:
		var x=0;while x<len(PT):
			if PT[x].name=="EFF":RR["EF"]=PT[x]
			if PT[x].name=="AA" :R["a"]=x
			x+=1
		if $".".name=="P":
			est_ig=PT[0].est_ig
			ddd_tg=PT[0].ddd_tg
			RR=PT[0].RR
		elif ddd_tg and ddd_tg.tiprrh=="L":
			var ap=false
			for i in PT[0].RR["EV"]:
				if i==ddd_tg:ap=true;break
			for i in ddd_tg.RR["imbmin"]:
				if ap:pass
				if i!="" and i!="//Tg" and !ap:
					if   ddd_tg.RR["ejecus"]==0:
						for e in PT[0].mapapp.mjugad:
							var f=load(i).instantiate()
							e.add_child.call_deferred(f)
							f.global_position=e.global_position
					elif ddd_tg.RR["ejecus"]==1:
						var f=load(i).instantiate()
						PT[0].add_child.call_deferred(f)
						PT[0].PT.append(f)
						f.RR["Md"]=PT[0]
						f.global_position=$".".global_position
						if !"Fz" in f.RR:f.RR["Fz"]=Vector3i(0,0,0)
						f.RR["Fz"]=PT[0].fuerza

func _process(_delta: float) -> void:
	if Engine.is_editor_hint():
		pass
	else:
		if $".".name=="P":
			PT[0].est_ig=est_ig
			PT[0].ddd_tg=ddd_tg
			PT[0].RR=RR


func _on_a_pressed() -> void:
	if len(PT)>0:
		var x=0;while x<len(PT[0].R["IV"]):
			if PT[0].R["IV"][x]==$".":
				PT[0].PT[0].R["Dm"][0]=x
				EgLb.aspe(PT[0])
				break
			x+=1
