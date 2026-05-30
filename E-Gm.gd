@tool extends Node

@export var autdrc:="//"                    ##su propia direccion
@export var mapmmd:JSON                     ##mapa mundi
@export var mjugad:Array[Node]              ##manos de tugadores
@export var tabler:Array[PackedScene]       ##tableros de la esena
@export var postab:Array[Vector2i]          ##tableros de la esena
@export var pasodt:Array[String]=["p;0;0"]##nombre:tablero de destino:casilla en tablero de destino
@export var RR:={}                          ##extras
var R:={}
var mm:={}

func _ready() -> void:
	if Engine.is_editor_hint():
		if !"TL" in RR:RR["TL"]=[89,11,6,4,15,12]
		if !"TT" in RR:RR["TT"]=[0 ,1 ,0,0,0 ,0 ]
		var x=0;while x<len(mjugad):
			mjugad[x].ES=$"."
			x+=1
		if len(tabler)>0 and !"rTb" in RR:RR["rTb"]=[1,0,""]
		if !"MM" in RR:
			RR["MM"]=[]
	else:
		if len(EgLb.mm)==0:
			mm=EgLb.lejs(mapmmd.resource_path)
			EgLb.mm=mm
		else:mm=EgLb.mm
		if len(tabler)>0 and !"rTb" in RR:RR["rTb"]=[1,0,""]
		if !"MM" in RR:RR["MM"]=[]
		if len(RR["MM"])==0:RR["MM"].append(mjugad[0].entblr)
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
		#===================================
		#print()
		var x=RR["rTb"][1];var cpf=false
		while x>=0:
			if RR["TT"][x]==1:cpf=true
			else:cpf=false;break
			x-=1
		if cpf and R["T"]==1:
			x=0;while x<len(RR["MM"]):
				var cnp=false;for i in mjugad:
					if RR["MM"][x]!=i.PT[0] or RR["MM"][x].ddd_tg==null:cnp=true
					else:cnp=false;break
				if cnp:
					if len(RR["MM"][x].events)>0:
						EgLb.atlz(RR["MM"][x],RR["MM"][x].R["evEm"])
						RR["MM"][x].R["evEm"]+=1
						if RR["MM"][x].R["evEm"]>=len(RR["MM"][x].events):
							RR["MM"][x].R["evEm"]=0
							RR["MM"][x].events=EgLb.barj(RR["MM"][x].events)
				x+=1
