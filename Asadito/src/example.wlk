import tiposDePersona.*

class Comensal{
	
	const property elementosCerca = new List()
	const property platosIngeridos = new List()
	
	var property posicion 
	
	var property criterio
	var property tipoDeComensal
	
	method cambiarCriterio(nuevoCriterio) { self.criterio(nuevoCriterio) }
	
	method cambiarTipoDeComensal(nuevoTipo) {self.tipoDeComensal(nuevoTipo)}
	
	method pedirElemento(cosa,otraPersona) {
		otraPersona.pasar(cosa,self)
	}

	method pasar(cosa,otraPersona) {
		if(otraPersona.puedePasar(cosa)){
			criterio.pasar(cosa,otraPersona,self)
			}
		else self.error("No le puede pasar ese elemento")
	}
	
	method puedePasar(elemento) = elementosCerca.contains(elemento)
	
	method tomar(elemento) { elementosCerca.add(elemento) }
	
	method dejarIr(elemento) { elementosCerca.remove(elemento)}
	
	method tomarTodos(elementos) { elementos.map({elemento => self.tomar(elemento)}) }
		
	method dejarIrTodos() {elementosCerca.clear() }

	method irAlLugarDe(otraPersona){
		self.posicion(otraPersona.posicion())
	}	
	
	method reemplazarElementosPor(nuevosElementos) {
		self.dejarIrTodos()
		self.tomarTodos(nuevosElementos)
	}
	
	method quiereComer(platillo) = tipoDeComensal.decision(platillo)
	
	method comer(platillo){
		if(self.quiereComer(platillo)){
			platosIngeridos.add(platillo)
		}
		else self.error("No quielo XLR8")
	}
	
	
	method estasPipon() = platosIngeridos.any({plato => plato.teDejaPipon()})
	
	method laEstaPasandoBien() = !platosIngeridos.isEmpty()
}

object osky inherits Comensal{
	override method laEstaPasandoBien() = true // super()
}
object moni inherits Comensal{
	override method laEstaPasandoBien() = self.posicion() == "1@1"
}

object facu inherits Comensal{
	override method laEstaPasandoBien() = self.platosIngeridos().any({plato => plato.esCarne()})
}

object vero inherits Comensal{
	override method laEstaPasandoBien() = self.elementosCerca().size() < 3
}





object vegetariano{
	method decision(platillo) = !platillo.esCarne()
}

object detetico{
	method decision(platillo) = platillo.calorias() < 500
}

object alternado{
		
	var aceptarComida = false
	
	method decision(platillo) {
		aceptarComida = !aceptarComida
		return aceptarComida
	}

}

class Combinado{
	
	const tiposDeCondiciones = new List()
	
	method decision(platillo) = tiposDeCondiciones.all({condicion => condicion.decision(platillo)})
	
}




class ComidadosPuntitosPeh{
	const property calorias
	const property esCarne
	
	method teDejaPipon() = calorias > 500
}





