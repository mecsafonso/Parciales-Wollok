class Vikingo {

	var property claseSocial 
	var property monedas = 0
	var property vidasCobradas
	
	method puedeExpedicionar() 
	method esProductivo() // metodo abstracto
	
	method ascender(){
	self.claseSocial(claseSocial.ascender())		
	}
	
	method ganarMonedas(cantidad){
		monedas = monedas + cantidad
	}
	
	method cosecharAlma(){
		vidasCobradas += 1
	}

}

class Soldado inherits Vikingo{
	
	 
	var property armas = []
	
	override method puedeExpedicionar() = self.esProductivo() and claseSocial.puedeExpedicionarSoldado() 
	
	override method esProductivo() = vidasCobradas > 20 and !armas.isEmpty()
	
}

class Granjero inherits Vikingo{
	
	var property cantidadHijos
	var property hectareas
	
	override method puedeExpedicionar() = self.esProductivo() 
	override method esProductivo() = hectareas >= cantidadHijos * 2
	
}

object jarl{
	method puedeExpedicionarSoldado() = true
	method ascender() = karl
}

object thrall{
	method puedeExpedicionarSoldado() = true
	method ascender() = self
}

object karl{
	method puedeExpedicionarSoldado() = false // Un Karl guerrero nunca puede expedicionar
	method ascender() = jarl
}


class Expedicion {
	
	const property participantes = new List() 
	const property destinos = new List()
	var botinTotal = 0
	
	method valeLaPena() = destinos.forAll({destino => destino.valeLaPena(participantes.size())})
	
	method subir(vikingo) = if(vikingo.puedeExpedicionar()) {participantes.add(vikingo)} else { throw new Exception(message = "No puede subir a la expedicion")}

	method realizar() {
		botinTotal = destinos.map({destino => destino.botin()}).sum()
		participantes.forEach({participante => participante.ganarMonedas(botinTotal/participantes.size())})
		destinos.forEach({destino => destino.recibirExpedicion(participantes)})
	}
}

class Destino{
	method valeLaPena(cantidadVikingos)
	
}

class Capital inherits Destino{
	
	const property factorRiqueza
	const property cantidadDefensores
	var botinSaqueado
	
	override method valeLaPena(cantidadVikingos) = self.botin(cantidadVikingos) >= cantidadVikingos * 3
	
	method botin(cantidadVikingos){
		botinSaqueado =  cantidadVikingos * factorRiqueza
		return botinSaqueado
	} // cantidadVikingos = cantidadDefensor
	
	method botin() = botinSaqueado
	
	method recibirExpedicion(participantes) = participantes.forEach({participante => participante.cosecharAlma()})

}

class Aldea inherits Destino{
	
	var property cantidadCrucifijos
	
	override method valeLaPena(cantidadVikingos) = self.botin() >= 15
	
	method botin() = cantidadCrucifijos
	
	method recibirExpedicion(){
		cantidadCrucifijos = 0
	}
	
	method recibirExpedicion(participantes) {
		cantidadCrucifijos = 0
	}
}

class AldeaAmurallada inherits Aldea{
	
	const property cantidadMinimaAtacantes
	
	override method valeLaPena(cantidadVikingos) = cantidadVikingos >= cantidadMinimaAtacantes and super(cantidadVikingos)// metodo lookup
	
}







































