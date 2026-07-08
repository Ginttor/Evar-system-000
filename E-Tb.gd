@tool extends Node

@export var ddd_tg:d_tg            ##targeta de entidad
@export var mapapp:Node            ##mapa al que pertenese
@export var fuerza:=Vector3i(0,0,0)##fuerzas influentes
@export var accion:={              ##accionamiento
	"AC":0,#acciones
	"SM":1,#sumador
	"TR":[1]#tiempo de reactivasion
	}
@export_group("Mapeado")
@export var focodc:Node            ##foco de la camara para sentrarse
@export var spcmap:Node            ##mapa espesial
@export var mallat:Dictionary={    ##malla de tablero
	"P":Vector2i(0,0),
	"N":Vector2i(0,0),
	}
@export var puntuv:Array[String]   ##(0,0):IF:0/1
@export var escall:=Vector2i(0,0)  ##escalado de temaño
@export var acctib:Array[d_tg]=[null]##eventos activos
@export var PT:Array[Node]         ##binculado
@export_group("Emboltorio")
@export var recerv:=Vector3i(0,1,4)##limites (minimo en pantalla | maximo en panalla | maximo de reserva)
@export var enbolt:Array[d_tg]     ##targetas de resrva
@export var reppem:Array[int]      ##repetisiones de targetas
@export var RR:={}                 ##extras

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
		if len(enbolt)>0 :
			RR["VL"]=[]
			for i in enbolt:
				RR["VL"].append(Vector2i(0,0))
	else:
		var rt=0
		for i in reppem:
			if i>0:
				rt+=i
		print("!!--Reserva: ",rt,"/",recerv.z)
		EgLb.tabl($".",false)
		if len(enbolt)>0:RR["EV"]=[]
		var x=0
		while x<len(PT):
			PT[x].RR["Md"]=$"."
			if !"Fz" in PT[x].RR:PT[x].RR["Fz"]=Vector3i(0,0,0)
			PT[x].RR["Fz"]=$".".fuerza
			x+=1
		if ddd_tg==null:
			R["evEm"]=0#evento en mano
			enbolt=EgLb.barj(enbolt)
func _process(_delta: float) -> void:
	if Engine.is_editor_hint():
		rcrv()
	else:
		if mapapp.RR["TT"][0]==accion["TR"][0] and accion["AC"]!=0:#=#accion por turno
			actt()
			accion["AC"]-=1
		for i in acctib:#============================================#prosesar acciones
				if i and i.tiprrh=="Q":chmt(EgLb.dado(0,6),i)
		
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
#========================
func chmt(t,q):                   # kuez
	var y=0;var x=0
	if !"RK" in RR:
		RR["RK"]=[]
		for i in acctib:
			if  i and i.tiprrh=="Q":RR["RK"].append("")
	x=0;while x<len(RR["RK"]):
			var r:=""
			if   q and r=="":#==================================#ejecusion de kues
				y=0;while y<len(q.RR["ruatas"]):
					if q.RR["ruatas"][y].split(":")[0]==RR["RK"][x] and q.RR["intrpt"][y]:
						r=EgLb.miti(mapapp.mjugad[EgLb.dado(0,len(mapapp.mjugad))],load(q.RR["intrpt"][y]),t)
						print("KZ_en revision:",q.resource_name," <r>:",r)
						break
					y+=1
			elif q and r!="":#==================================#prosesar resultados de kues
				var sd=EgLb.alqm(q.RR["ruatas"],RR["RK"][x],r)
				r=sd[0]
				RR["RK"][x]=sd[1]
				print("KZ_resultado de:",q.resource_name," =>",RR["RK"][x])
			elif q and r=="f.":#================================#finalizar kues
				print("KZ_finalisada:",q.resource_name,"(",RR["CK"][y],")")
			x+=1
func rcrv():                      #coerensia
	if len(reppem)!=len(enbolt):
		reppem=[]
		for i in enbolt:reppem.append(0)
func actt():                      #activasion
	var el=EgLb.dado(0,2)
	if el==0 and acctib.count(null)>0:
		var mt=[]
		for i in enbolt:
			i.defn()
			if i.tiprrh=="Q" or i.tiprrh=="L":mt.append(i)
		var sp=acctib.find(null)
		if acctib.count(mt[EgLb.dado(0,len(mt),449333)])==0:
			acctib[sp]=mt[EgLb.dado(0,len(mt),449333)]
			print("!!--Accion a activar:",acctib[sp].resource_name)
		else:EgLb.dado(0,0,449333)
	else:print("!!--:PASAR")
