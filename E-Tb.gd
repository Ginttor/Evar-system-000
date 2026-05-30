@tool extends Node

@export var ddd_tg:d_tg            ##targeta de pieza
@export var mapapp:Node            ##mapa al que pertenese
@export var focodc:Node            ##foco de la camara para sentrarse
@export var spcmap:Node            ##mapa espesial
@export var fuerza:=Vector3i(0,0,0)##fuerzas influentes
@export var recerv:Dictionary={    ##reserva de recursos
		"IV":[],          #imbentario
		"CR":[0],         #cantidad
		"RC":Vector2i(0,9)#limite
	}
@export var events:Array[d_tg]     ##acciones a realizar
@export var puntuv:Array[String]   ##(0,0):IF:0/1
@export var escall:=Vector2i(0,0)  ##escalado de temaño
@export var mallat:Dictionary={    ##malla de tablero
	"P":Vector2i(0,0),
	"N":Vector2i(0,0),
	}
@export var RR:={}               ##extras
@export var PT:Array[Node]       ##binculado
var R:={"TTb":[]}

func _ready() -> void:
	if Engine.is_editor_hint():
		EgLb.tabl($".",true)
		var x=0
		while x<len(PT):
			PT[x].RR["Md"]=$"."
			if !"Fz" in PT[x].RR:PT[x].RR["Fz"]=Vector3i(0,0,0)
			PT[x].RR["Fz"]=$".".fuerza
			x+=1
	else:
		EgLb.tabl($".",false)
		if len(events)>0:RR["EV"]=[]
		var x=0
		while x<len(PT):
			PT[x].RR["Md"]=$"."
			if !"Fz" in PT[x].RR:PT[x].RR["Fz"]=Vector3i(0,0,0)
			PT[x].RR["Fz"]=$".".fuerza
			x+=1
		if ddd_tg==null:
			R["evEm"]=0#evento en mano
			events=EgLb.barj(events)
func _process(_delta: float) -> void:
	if Engine.is_editor_hint():
		pass
	else:
		var x=0;while x<len(PT):
			if PT[x].est_ig=="PZ":
				EgLb.reuv(mapapp,PT[x])
				PT[x].est_ig="pz"
			x+=1
		if ddd_tg and ddd_tg.tiprrh=="L" and mapapp:
			for i in mapapp.mjugad:
				for e in mapapp.mm["VP"]:
					if $".".name.count(e.split(";")[0]):
						if   mapapp.mm["ET"][int(e.split(";")[1])]==mapapp.autdrc and  i.PT[0].global_position.x>focodc.global_position.x:
							x=EgLb.upup(i,$".",mapapp,str(e.split(";")[2]))
							var umm=EgLb.mp["P-UM"][x].split(";")
							EgLb.mp["P-UM"][x]=str(int(umm[0])-1)+";"+umm[1]+";"+umm[2]+";"+umm[3]
							EgLb.catg(mapapp.mm["ET"][int(e.split(";")[2])],mapapp.RR["MM"])
							break
						elif mapapp.mm["ET"][int(e.split(";")[2])]==mapapp.autdrc and  i.PT[0].global_position.x<focodc.global_position.x:
							x=EgLb.upup(i,$".",mapapp,str(e.split(";")[2]))
							var umm=EgLb.mp["P-UM"][x].split(";")
							EgLb.mp["P-UM"][x]=str(int(umm[0])+1)+";"+umm[1]+";"+umm[2]+";"+umm[3]
							EgLb.catg(mapapp.mm["ET"][int(e.split(";")[1])],mapapp.RR["MM"])
							break
