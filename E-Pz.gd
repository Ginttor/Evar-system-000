@tool extends Node

@export var est_ig:=""    ##estado en juego
@export var ddd_tg:d_tg   ##targeta de pieza
@export var AA:={
	"P": null,##parado
	#"M": "M",##avanzar
	#"J": "J",##saltar
	#"R": "R",##rotar
	#"D": "D",##dash
	}
@export var RR:={}        ##extras
@export var PT:Array[Node]##binculado
var R:={"id":["pz",0]}

func _ready() -> void:
	if Engine.is_editor_hint():
		EgLb.sttr($".")
		if "io" in RR:RR["io"]=ddd_tg.RR["io_0SC"]
	else:
		if !"II" in R:R["II"]=[]
		if !"YY" in R:R["YY"]=[]
		if !"VV" in R:R["VV"]=[]
		EgLb.sttr($".")
		if "io" in RR:RR["io"]=ddd_tg.RR["io_0SC"]
		if "AA" in RR:for i in RR["AA"]:#-----------------cargar acciones
			if typeof(RR["AA"][i])==TYPE_STRING and RR["AA"][i]!="":RR["AA"][i]=load(RR["AA"][i])
			else:RR["AA"][i]=null
		EgLb.kdpk($".")
func _process(_delta: float) -> void:
	if Engine.is_editor_hint():
		pass
	else:
		if est_ig=="":$".".visible=false
		else:$".".visible=true
		EgLb.motr($".")
		if "KM" in R:
			var p=true
			for i in R["KM"]:
				if i!=".":p=false
			if p and "P" in AA and AA["P"]:
				PT[R["a"]].play(AA["P"].RR["acionn"])#-----------------------------------------#parado
				EgLb.stcl($".",2,true)
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
		EgLb.girk($".")


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


func _on_f_body_entered(body: Node2D) -> void:
	if ! "M" in R:R["M"]=["",""]
	if ! "eM" in R:R["eM"]=[]
	R["M"][0]="f"
	var x=0
	while x<len(R["eM"]):
		if R["eM"][x]==null:R["eM"][x]=body;break
		x+=1
	if x==len(R["eM"]):R["eM"].append(body)
	$".".velocity=Vector2(0,0)
func _on_f_body_exited(body: Node2D) -> void:
	if ! "M" in R:R["M"]=["",""]
	if ! "eM" in R:R["eM"]=[]
	var x=0
	while x<len(R["eM"]):
		if body==R["eM"][x]:R["M"][0]="";R["eM"][x]=null
		x+=1
